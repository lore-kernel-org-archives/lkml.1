Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZCYOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZCYOx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZCYOxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:53:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZCYOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:53:03 -0400
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1237985832.7972.930.camel@twins>
References: <20090325113021.781490788@chello.nl>
	 <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu>
	 <1237984033.7972.865.camel@twins> <20090325123514.GB28639@elte.hu>
	 <1237984864.7972.896.camel@twins>  <20090325125407.GA32744@elte.hu>
	 <1237985832.7972.930.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Mar 2009 15:52:54 +0100
Message-Id: <1237992774.7972.1178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 13:57 +0100, Peter Zijlstra wrote:
> On Wed, 2009-03-25 at 13:54 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Wed, 2009-03-25 at 13:35 +0100, Ingo Molnar wrote:
> > > 
> > > > > Also, when mixing streams (events,mmap) is a single: you missed 
> > > > > 'n' events still good?
> > > > 
> > > > How would such mixing work? Multiple counters streaming into the 
> > > > same mmap area?
> > > 
> > > No basically having overflow events and mmap-vma changed events in 
> > > a single output stream.
> > 
> > ah, and i missed the impact of variable size records - that too 
> > makes it somewhat impractical to emit overflow records in situ. (the 
> > kernel does not really know the precise start of the previous 
> > record, typically.)
> 
> Alternatively, we could simply not emit new events until the read
> position increases,. that's much simpler.
> 
> Still don't like mapping the stuff writable though..

This is what it would look like I suppose...

Any thoughts?

Not-signed-off-by: me
---
 include/linux/perf_counter.h |    4 ++
 kernel/perf_counter.c        |   67 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6bf67ce..d5a599c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 3b862a7..1f5c515 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1330,6 +1330,7 @@ static void __perf_counter_update_userpage(struct perf_counter *counter,
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
 	userpg->data_head = atomic_read(&data->head);
+	userpg->overflow = atomic_read(&data->overflow);
 	smp_wmb();
 	++userpg->lock;
 	preempt_enable();
@@ -1375,6 +1376,28 @@ unlock:
 	return ret;
 }
 
+static int perf_mmap_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
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
@@ -1463,6 +1486,7 @@ static struct vm_operations_struct perf_mmap_vmops = {
 	.open = perf_mmap_open,
 	.close = perf_mmap_close,
 	.fault = perf_mmap_fault,
+	.page_mkwrite = perf_mmap_mkwrite,
 };
 
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1473,7 +1497,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long locked, lock_limit;
 	int ret = 0;
 
-	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -1503,16 +1527,19 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
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
 
@@ -1540,6 +1567,28 @@ struct perf_output_handle {
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
@@ -1552,11 +1601,13 @@ static int perf_output_begin(struct perf_output_handle *handle,
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
@@ -1567,6 +1618,8 @@ static int perf_output_begin(struct perf_output_handle *handle,
 
 	return 0;
 
+fail:
+	atomic_inc(&data->overflow);
 out:
 	rcu_read_unlock();
 

