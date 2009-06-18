Return-Path: <linux-kernel-owner+w=401wt.eu-S1764368AbZFRMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764368AbZFRMwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763476AbZFRMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:51:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:38268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763534AbZFRMvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:51:07 -0400
Date: Thu, 18 Jun 2009 12:50:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add event overlow handling
Message-ID: <tip-43a21ea81a2400992561146327c4785ce7f7be38@git.kernel.org>
Git-Commit-ID: 43a21ea81a2400992561146327c4785ce7f7be38
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:50:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43a21ea81a2400992561146327c4785ce7f7be38
Gitweb:     http://git.kernel.org/tip/43a21ea81a2400992561146327c4785ce7f7be38
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 19:39:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 14:46:11 +0200

perf_counter: Add event overlow handling

Alternative method of mmap() data output handling that provides
better overflow management and a more reliable data stream.

Unlike the previous method, that didn't have any user->kernel
feedback and relied on userspace keeping up, this method relies on
userspace writing its last read position into the control page.

It will ensure new output doesn't overwrite not-yet read events,
new events for which there is no space left are lost and the
overflow counter is incremented, providing exact event loss
numbers.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   40 +++++++---
 kernel/perf_counter.c        |  185 +++++++++++++++++++++++++++++-------------
 2 files changed, 158 insertions(+), 67 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a7d3a61..0765e8e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -236,10 +236,16 @@ struct perf_counter_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading this value should issue an rmb(), on SMP capable
-	 * platforms, after reading this value -- see perf_counter_wakeup().
+	 * User-space reading the @data_head value should issue an rmb(), on
+	 * SMP capable platforms, after reading this value -- see
+	 * perf_counter_wakeup().
+	 *
+	 * When the mapping is PROT_WRITE the @data_tail value should be
+	 * written by userspace to reflect the last read data. In this case
+	 * the kernel will not over-write unread data.
 	 */
 	__u64   data_head;		/* head in the data section */
+	__u64	data_tail;		/* user-space written tail */
 };
 
 #define PERF_EVENT_MISC_CPUMODE_MASK		(3 << 0)
@@ -275,6 +281,15 @@ enum perf_event_type {
 
 	/*
 	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				id;
+	 * 	u64				lost;
+	 * };
+	 */
+	PERF_EVENT_LOST			= 2,
+
+	/*
+	 * struct {
 	 *	struct perf_event_header	header;
 	 *
 	 *	u32				pid, tid;
@@ -313,26 +328,26 @@ enum perf_event_type {
 
 	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
-	 * will be PERF_RECORD_*
+	 * will be PERF_SAMPLE_*
 	 *
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
-	 *	{ u64			ip;	  } && PERF_RECORD_IP
-	 *	{ u32			pid, tid; } && PERF_RECORD_TID
-	 *	{ u64			time;     } && PERF_RECORD_TIME
-	 *	{ u64			addr;     } && PERF_RECORD_ADDR
-	 *	{ u64			config;   } && PERF_RECORD_CONFIG
-	 *	{ u32			cpu, res; } && PERF_RECORD_CPU
+	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
+	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 *	{ u64			time;     } && PERF_SAMPLE_TIME
+	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
+	 *	{ u64			config;   } && PERF_SAMPLE_CONFIG
+	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 *
 	 *	{ u64			nr;
-	 *	  { u64 id, val; }	cnt[nr];  } && PERF_RECORD_GROUP
+	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
 	 *
 	 *	{ u16			nr,
 	 *				hv,
 	 *				kernel,
 	 *				user;
-	 *	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
+	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 * };
 	 */
 };
@@ -424,6 +439,7 @@ struct file;
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;	/* nr of data pages  */
+	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
@@ -433,8 +449,8 @@ struct perf_mmap_data {
 	atomic_long_t			done_head;	/* completed head    */
 
 	atomic_t			lock;		/* concurrent writes */
-
 	atomic_t			wakeup;		/* needs a wakeup    */
+	atomic_t			lost;		/* nr records lost   */
 
 	struct perf_counter_mmap_page   *user_page;
 	void				*data_pages[0];
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 109a957..7e9108e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1794,6 +1794,12 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct perf_mmap_data *data;
 	int ret = VM_FAULT_SIGBUS;
 
+	if (vmf->flags & FAULT_FLAG_MKWRITE) {
+		if (vmf->pgoff == 0)
+			ret = 0;
+		return ret;
+	}
+
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (!data)
@@ -1807,9 +1813,16 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		if ((unsigned)nr > data->nr_pages)
 			goto unlock;
 
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			goto unlock;
+
 		vmf->page = virt_to_page(data->data_pages[nr]);
 	}
+
 	get_page(vmf->page);
+	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->index   = vmf->pgoff;
+
 	ret = 0;
 unlock:
 	rcu_read_unlock();
@@ -1862,6 +1875,14 @@ fail:
 	return -ENOMEM;
 }
 
+static void perf_mmap_free_page(unsigned long addr)
+{
+	struct page *page = virt_to_page(addr);
+
+	page->mapping = NULL;
+	__free_page(page);
+}
+
 static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 {
 	struct perf_mmap_data *data;
@@ -1869,9 +1890,10 @@ static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
 
-	free_page((unsigned long)data->user_page);
+	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
-		free_page((unsigned long)data->data_pages[i]);
+		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+
 	kfree(data);
 }
 
@@ -1908,9 +1930,10 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 }
 
 static struct vm_operations_struct perf_mmap_vmops = {
-	.open  = perf_mmap_open,
-	.close = perf_mmap_close,
-	.fault = perf_mmap_fault,
+	.open		= perf_mmap_open,
+	.close		= perf_mmap_close,
+	.fault		= perf_mmap_fault,
+	.page_mkwrite	= perf_mmap_fault,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1924,7 +1947,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	long user_extra, extra;
 	int ret = 0;
 
-	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -1983,10 +2006,12 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;
 	counter->data->nr_locked = extra;
+	if (vma->vm_flags & VM_WRITE)
+		counter->data->writable = 1;
+
 unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
-	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
@@ -2163,11 +2188,38 @@ struct perf_output_handle {
 	unsigned long		head;
 	unsigned long		offset;
 	int			nmi;
-	int			overflow;
+	int			sample;
 	int			locked;
 	unsigned long		flags;
 };
 
+static bool perf_output_space(struct perf_mmap_data *data,
+			      unsigned int offset, unsigned int head)
+{
+	unsigned long tail;
+	unsigned long mask;
+
+	if (!data->writable)
+		return true;
+
+	mask = (data->nr_pages << PAGE_SHIFT) - 1;
+	/*
+	 * Userspace could choose to issue a mb() before updating the tail
+	 * pointer. So that all reads will be completed before the write is
+	 * issued.
+	 */
+	tail = ACCESS_ONCE(data->user_page->data_tail);
+	smp_rmb();
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return false;
+
+	return true;
+}
+
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
 	atomic_set(&handle->data->poll, POLL_IN);
@@ -2258,12 +2310,57 @@ out:
 	local_irq_restore(handle->flags);
 }
 
+static void perf_output_copy(struct perf_output_handle *handle,
+			     const void *buf, unsigned int len)
+{
+	unsigned int pages_mask;
+	unsigned int offset;
+	unsigned int size;
+	void **pages;
+
+	offset		= handle->offset;
+	pages_mask	= handle->data->nr_pages - 1;
+	pages		= handle->data->data_pages;
+
+	do {
+		unsigned int page_offset;
+		int nr;
+
+		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
+		page_offset = offset & (PAGE_SIZE - 1);
+		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
+
+		memcpy(pages[nr] + page_offset, buf, size);
+
+		len	    -= size;
+		buf	    += size;
+		offset	    += size;
+	} while (len);
+
+	handle->offset = offset;
+
+	/*
+	 * Check we didn't copy past our reservation window, taking the
+	 * possible unsigned int wrap into account.
+	 */
+	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
+}
+
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
-			     int nmi, int overflow)
+			     int nmi, int sample)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
+	int have_lost;
+	struct {
+		struct perf_event_header header;
+		u64			 id;
+		u64			 lost;
+	} lost_event;
 
 	/*
 	 * For inherited counters we send all the output towards the parent.
@@ -2276,19 +2373,25 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	if (!data)
 		goto out;
 
-	handle->data	 = data;
-	handle->counter	 = counter;
-	handle->nmi	 = nmi;
-	handle->overflow = overflow;
+	handle->data	= data;
+	handle->counter	= counter;
+	handle->nmi	= nmi;
+	handle->sample	= sample;
 
 	if (!data->nr_pages)
 		goto fail;
 
+	have_lost = atomic_read(&data->lost);
+	if (have_lost)
+		size += sizeof(lost_event);
+
 	perf_output_lock(handle);
 
 	do {
 		offset = head = atomic_long_read(&data->head);
 		head += size;
+		if (unlikely(!perf_output_space(data, offset, head)))
+			goto fail;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
@@ -2297,55 +2400,27 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
 		atomic_set(&data->wakeup, 1);
 
+	if (have_lost) {
+		lost_event.header.type = PERF_EVENT_LOST;
+		lost_event.header.misc = 0;
+		lost_event.header.size = sizeof(lost_event);
+		lost_event.id          = counter->id;
+		lost_event.lost        = atomic_xchg(&data->lost, 0);
+
+		perf_output_put(handle, lost_event);
+	}
+
 	return 0;
 
 fail:
-	perf_output_wakeup(handle);
+	atomic_inc(&data->lost);
+	perf_output_unlock(handle);
 out:
 	rcu_read_unlock();
 
 	return -ENOSPC;
 }
 
-static void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len)
-{
-	unsigned int pages_mask;
-	unsigned int offset;
-	unsigned int size;
-	void **pages;
-
-	offset		= handle->offset;
-	pages_mask	= handle->data->nr_pages - 1;
-	pages		= handle->data->data_pages;
-
-	do {
-		unsigned int page_offset;
-		int nr;
-
-		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
-		page_offset = offset & (PAGE_SIZE - 1);
-		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
-
-		memcpy(pages[nr] + page_offset, buf, size);
-
-		len	    -= size;
-		buf	    += size;
-		offset	    += size;
-	} while (len);
-
-	handle->offset = offset;
-
-	/*
-	 * Check we didn't copy past our reservation window, taking the
-	 * possible unsigned int wrap into account.
-	 */
-	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
-}
-
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
-
 static void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_counter *counter = handle->counter;
@@ -2353,7 +2428,7 @@ static void perf_output_end(struct perf_output_handle *handle)
 
 	int wakeup_events = counter->attr.wakeup_events;
 
-	if (handle->overflow && wakeup_events) {
+	if (handle->sample && wakeup_events) {
 		int events = atomic_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			atomic_sub(wakeup_events, &data->events);
@@ -2958,7 +3033,7 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 }
 
 /*
- * Generic counter overflow handling.
+ * Generic counter overflow handling, sampling.
  */
 
 int perf_counter_overflow(struct perf_counter *counter, int nmi,
