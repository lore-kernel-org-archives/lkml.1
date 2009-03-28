Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZC1Tuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZC1Tuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbZC1TuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbZC1TuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:07 -0400
Message-Id: <20090328194930.255211811@chello.nl>
References: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:44:08 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 9/9] RFC perf_counter: event overlow handling
Content-Disposition: inline; filename=perf_counter-mmap-write.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alternative method of mmap() data output handling that provides better
overflow management.

Unlike the previous method, that didn't have any user->kernel
feedback and relied on userspace keeping up, this method relies on
userspace writing its last read position into the control page.

It will ensure new output doesn't overwrite not-yet read events, new
events for which there is no space left are lost and the overflow
counter is incremented, providing exact event loss numbers.

Untested -- not sure its really worth the overhead, the most important
thing to know is _if_ you're loosing data, either method allows for
that.

Still unsure about this, Paulus seems to agree.

Maybe-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   14 ++++-
 kernel/perf_counter.c        |  114 +++++++++++++++++++++++++++++++++----------
 2 files changed, 101 insertions(+), 27 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -198,10 +198,18 @@ struct perf_counter_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading this value should issue an rmb(), on SMP capable
-	 * platforms, after reading this value. -- see perf_counter_wakeup().
+	 * User-space reading the @data_head value should issue an rmb(), on
+	 * SMP capable platforms, after reading this value -- see
+	 * perf_counter_wakeup().
+	 *
+	 * When the mapping is PROT_WRITE the @data_tail value should be
+	 * written by userspace to reflect the last read data. In this case
+	 * the kernel will not over-write unread data, and @overflow will
+	 * contain the number of events that were lost due to this.
 	 */
 	__u32   data_head;		/* head in the data section */
+	__u32	data_tail;		/* user-space written tail */
+	__u32	overflow;		/* number of lost events */
 };
 
 struct perf_event_header {
@@ -309,8 +317,10 @@ struct file;
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;
+	int				writable;
 	atomic_t			wakeup;
 	atomic_t			head;
+	atomic_t			overflow;
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1382,6 +1382,26 @@ unlock:
 	return ret;
 }
 
+static int perf_mmap_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct perf_counter *counter = vma->vm_file->private_data;
+	struct perf_mmap_data *data;
+	int ret = -EINVAL;
+
+	rcu_read_lock();
+	data = rcu_dereference(counter->data);
+
+	/*
+	 * Only allow writes to the control page.
+	 */
+	if (data && (page == virt_to_page(data->user_page)))
+		ret = 0;
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 {
 	struct perf_mmap_data *data;
@@ -1467,9 +1487,10 @@ static void perf_mmap_close(struct vm_ar
 }
 
 static struct vm_operations_struct perf_mmap_vmops = {
-	.open = perf_mmap_open,
-	.close = perf_mmap_close,
-	.fault = perf_mmap_fault,
+	.open		= perf_mmap_open,
+	.close		= perf_mmap_close,
+	.fault		= perf_mmap_fault,
+	.page_mkwrite	= perf_mmap_mkwrite,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1480,7 +1501,7 @@ static int perf_mmap(struct file *file, 
 	unsigned long locked, lock_limit;
 	int ret = 0;
 
-	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -1510,16 +1531,19 @@ static int perf_mmap(struct file *file, 
 
 	mutex_lock(&counter->mmap_mutex);
 	if (atomic_inc_not_zero(&counter->mmap_count))
-		goto out;
+		goto unlock;
 
 	WARN_ON(counter->data);
 	ret = perf_mmap_data_alloc(counter, nr_pages);
-	if (!ret)
-		atomic_set(&counter->mmap_count, 1);
-out:
+	if (ret)
+		goto unlock;
+
+	atomic_set(&counter->mmap_count, 1);
+	if (vma->vm_flags & VM_WRITE)
+		counter->data->writable = 1;
+unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
-	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
@@ -1550,6 +1574,7 @@ void perf_counter_wakeup(struct perf_cou
 	data = rcu_dereference(counter->data);
 	if (data) {
 		(void)atomic_xchg(&data->wakeup, POLL_IN);
+		data->user_page->overflow = atomic_read(&data->overflow);
 		/*
 		 * Ensure all data writes are issued before updating the
 		 * user-space data head information. The matching rmb()
@@ -1661,10 +1686,46 @@ struct perf_output_handle {
 	unsigned int		offset;
 	unsigned int		head;
 	int			wakeup;
+	int			nmi;
 };
 
+static bool perf_output_overflow(struct perf_mmap_data *data,
+				 unsigned int offset, unsigned int head)
+{
+	unsigned int tail;
+	unsigned int mask;
+
+	if (!data->writable)
+		return false;
+
+	mask = (data->nr_pages << PAGE_SHIFT) - 1;
+	/*
+	 * Userspace could choose to issue a wmb() after updating the tail
+	 * pointer. This ensures we get to see the tail move sooner.
+	 */
+	smp_rmb();
+	tail = ACCESS_ONCE(data->user_page->data_tail);
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return true;
+
+	return false;
+}
+
+static inline void __perf_output_wakeup(struct perf_output_handle *handle)
+{
+	if (handle->nmi)
+		perf_pending_queue(handle->counter);
+	else
+		perf_counter_wakeup(handle->counter);
+}
+
 static int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_counter *counter, unsigned int size)
+			     struct perf_counter *counter, unsigned int size,
+			     int nmi)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
@@ -1674,15 +1735,19 @@ static int perf_output_begin(struct perf
 	if (!data)
 		goto out;
 
+	handle->counter	= counter;
+	handle->nmi	= nmi;
+
 	if (!data->nr_pages)
-		goto out;
+		goto fail;
 
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
+		if (unlikely(perf_output_overflow(data, offset, head)))
+			goto fail;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
-	handle->counter	= counter;
 	handle->data	= data;
 	handle->offset	= offset;
 	handle->head	= head;
@@ -1690,6 +1755,9 @@ static int perf_output_begin(struct perf
 
 	return 0;
 
+fail:
+	atomic_inc(&data->overflow);
+	__perf_output_wakeup(handle);
 out:
 	rcu_read_unlock();
 
@@ -1731,14 +1799,10 @@ static void perf_output_copy(struct perf
 #define perf_output_put(handle, x) \
 	perf_output_copy((handle), &(x), sizeof(x))
 
-static void perf_output_end(struct perf_output_handle *handle, int nmi)
+static void perf_output_end(struct perf_output_handle *handle)
 {
-	if (handle->wakeup) {
-		if (nmi)
-			perf_pending_queue(handle->counter);
-		else
-			perf_counter_wakeup(handle->counter);
-	}
+	if (handle->wakeup)
+		__perf_output_wakeup(handle);
 	rcu_read_unlock();
 }
 
@@ -1748,12 +1812,12 @@ static int perf_output_write(struct perf
 	struct perf_output_handle handle;
 	int ret;
 
-	ret = perf_output_begin(&handle, counter, size);
+	ret = perf_output_begin(&handle, counter, size, nmi);
 	if (ret)
 		goto out;
 
 	perf_output_copy(&handle, buf, size);
-	perf_output_end(&handle, nmi);
+	perf_output_end(&handle);
 
 out:
 	return ret;
@@ -1802,7 +1866,7 @@ static void perf_output_group(struct per
 
 	size = sizeof(header) + counter->nr_siblings * sizeof(entry);
 
-	ret = perf_output_begin(&handle, counter, size);
+	ret = perf_output_begin(&handle, counter, size, nmi);
 	if (ret)
 		return;
 
@@ -1822,7 +1886,7 @@ static void perf_output_group(struct per
 		perf_output_put(&handle, entry);
 	}
 
-	perf_output_end(&handle, nmi);
+	perf_output_end(&handle);
 }
 
 void perf_counter_output(struct perf_counter *counter,
@@ -1867,7 +1931,7 @@ static void perf_counter_mmap_output(str
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event.header.size;
-	int ret = perf_output_begin(&handle, counter, size);
+	int ret = perf_output_begin(&handle, counter, size, 0);
 
 	if (ret)
 		return;
@@ -1875,7 +1939,7 @@ static void perf_counter_mmap_output(str
 	perf_output_put(&handle, mmap_event->event);
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
-	perf_output_end(&handle, 0);
+	perf_output_end(&handle);
 }
 
 static int perf_counter_mmap_match(struct perf_counter *counter,

-- 

