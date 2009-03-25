Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZCYVIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZCYVIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZCYVGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:06:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:40117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZCYVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:06:41 -0400
Message-Id: <20090325210542.201764923@chello.nl>
References: <20090325210419.408653980@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 22:04:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/3] perf_counter: event overlow handling
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

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    4 ++
 kernel/perf_counter.c        |   69 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 66 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -165,6 +165,8 @@ struct perf_counter_mmap_page {
 	__s64	offset;			/* add to hardware counter value */
 
 	__u32   data_head;		/* head in the data section */
+	__u32	data_tail;		/* user-space written tail */
+	__u32	overflow;		/* number of lost events */
 };
 
 struct perf_event_header {
@@ -269,8 +271,10 @@ struct file;
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
@@ -1330,6 +1330,7 @@ static void __perf_counter_update_userpa
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
 	userpg->data_head = atomic_read(&data->head);
+	userpg->overflow = atomic_read(&data->overflow);
 	smp_wmb();
 	++userpg->lock;
 	preempt_enable();
@@ -1375,6 +1376,30 @@ unlock:
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
+	if (!data)
+		goto unlock;
+
+	/*
+	 * Only allow writes to the control page.
+	 */
+	if (page != virt_to_page(data->user_page))
+		goto unlock;
+
+	ret = 0;
+unlock:
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 {
 	struct perf_mmap_data *data;
@@ -1463,6 +1488,7 @@ static struct vm_operations_struct perf_
 	.open = perf_mmap_open,
 	.close = perf_mmap_close,
 	.fault = perf_mmap_fault,
+	.page_mkwrite = perf_mmap_mkwrite,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1473,7 +1499,7 @@ static int perf_mmap(struct file *file, 
 	unsigned long locked, lock_limit;
 	int ret = 0;
 
-	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -1503,16 +1529,19 @@ static int perf_mmap(struct file *file, 
 
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
 
@@ -1540,6 +1569,28 @@ struct perf_output_handle {
 	int			wakeup;
 };
 
+static int perf_output_overflow(struct perf_mmap_data *data,
+				unsigned int offset, unsigned int head)
+{
+	unsigned int tail;
+	unsigned int mask;
+
+	if (!data->writable)
+		return 0;
+
+	mask = (data->nr_pages << PAGE_SHIFT) - 1;
+	smp_rmb();
+	tail = ACCESS_ONCE(data->user_page->data_tail);
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return 1;
+
+	return 0;
+}
+
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size)
 {
@@ -1552,11 +1603,13 @@ static int perf_output_begin(struct perf
 		goto out;
 
 	if (!data->nr_pages)
-		goto out;
+		goto fail;
 
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
+		if (unlikely(perf_output_overflow(data, offset, head)))
+			goto fail;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->counter	= counter;
@@ -1567,6 +1620,8 @@ static int perf_output_begin(struct perf
 
 	return 0;
 
+fail:
+	atomic_inc(&data->overflow);
 out:
 	rcu_read_unlock();
 

-- 

