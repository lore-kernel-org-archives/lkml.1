Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZIUOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZIUOUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZIUOUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:20:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZIUOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:20:09 -0400
Message-Id: <20090921141751.228941944@chello.nl>
References: <20090921140848.444528343@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 21 Sep 2009 16:08:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/2] perf: Provide weak interfaces to mmap() backing
Content-Disposition: inline; filename=perf-weak-mmap-alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures such as Sparc, ARM and MIPS (basically everything
with flush_dcache_page()) need to deal with dcache aliases by
carefully placing pages in both kernel and user maps.

These architectures typically have to use vmalloc_user() for this.

However, on other architectures, vmalloc() is not needed and has the
downsides of being more restricted and slower than regular
allocations.

Hence reshape the code so that we can do either by over-riding a few
simply functions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/perf_counter.h |   18 ++++++++++
 kernel/perf_counter.c        |   72 ++++++++++++++++++++++++++++---------------
 2 files changed, 66 insertions(+), 24 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -513,6 +513,7 @@ struct file;
 
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
+	struct work_struct		work;
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
@@ -533,6 +534,23 @@ struct perf_mmap_data {
 	void				*data_pages[0];
 };
 
+/*
+ * The below three functions dealing with the mmap() backing are weak
+ * functions, which allow the arch implementation to over-ride them:
+ *
+ *   struct page *perf_mmap_to_page(void *addr);
+ *   struct perf_mmap_data *
+ *   perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages);
+ *   void perf_mmap_data_free(struct perf_mmap_data *data);
+ *
+ * They default to allocating memory using get_zeroed_page(GFP_KERNEL).
+ */
+
+struct page *perf_mmap_to_page(void *addr);
+struct perf_mmap_data *
+perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages);
+void perf_mmap_data_free(struct perf_mmap_data *data);
+
 struct perf_pending_entry {
 	struct perf_pending_entry *next;
 	void (*func)(struct perf_pending_entry *);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2106,6 +2106,11 @@ unlock:
 	rcu_read_unlock();
 }
 
+struct page * __weak perf_mmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_counter *counter = vma->vm_file->private_data;
@@ -2124,7 +2129,7 @@ static int perf_mmap_fault(struct vm_are
 		goto unlock;
 
 	if (vmf->pgoff == 0) {
-		vmf->page = virt_to_page(data->user_page);
+		vmf->page = perf_mmap_to_page(data->user_page);
 	} else {
 		int nr = vmf->pgoff - 1;
 
@@ -2134,7 +2139,7 @@ static int perf_mmap_fault(struct vm_are
 		if (vmf->flags & FAULT_FLAG_WRITE)
 			goto unlock;
 
-		vmf->page = virt_to_page(data->data_pages[nr]);
+		vmf->page = perf_mmap_to_page(data->data_pages[nr]);
 	}
 
 	get_page(vmf->page);
@@ -2148,7 +2153,26 @@ unlock:
 	return ret;
 }
 
-static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
+void perf_mmap_data_init(struct perf_counter *counter, struct perf_mmap_data *data)
+{
+	long max_size = PAGE_SIZE * data->nr_pages;
+
+	atomic_set(&data->lock, -1);
+
+	if (counter->attr.watermark) {
+		data->watermark = min_t(long, max_size,
+					counter->attr.wakeup_watermark);
+	}
+
+	if (!data->watermark)
+		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
+
+
+	rcu_assign_pointer(counter->data, data);
+}
+
+struct perf_mmap_data * __weak
+perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 {
 	struct perf_mmap_data *data;
 	unsigned long size;
@@ -2174,18 +2198,8 @@ static int perf_mmap_data_alloc(struct p
 	}
 
 	data->nr_pages = nr_pages;
-	atomic_set(&data->lock, -1);
 
-	if (counter->attr.watermark) {
-		data->watermark = min_t(long, PAGE_SIZE * nr_pages,
-				      counter->attr.wakeup_watermark);
-	}
-	if (!data->watermark)
-		data->watermark = max(PAGE_SIZE, PAGE_SIZE * nr_pages / 4);
-
-	rcu_assign_pointer(counter->data, data);
-
-	return 0;
+	return data;
 
 fail_data_pages:
 	for (i--; i >= 0; i--)
@@ -2197,7 +2211,7 @@ fail_user_page:
 	kfree(data);
 
 fail:
-	return -ENOMEM;
+	return NULL;
 }
 
 static void perf_mmap_free_page(unsigned long addr)
@@ -2208,28 +2222,32 @@ static void perf_mmap_free_page(unsigned
 	__free_page(page);
 }
 
-static void __perf_mmap_data_free(struct rcu_head *rcu_head)
+void __weak perf_mmap_data_free(struct perf_mmap_data *data)
 {
-	struct perf_mmap_data *data;
 	int i;
 
-	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
-
 	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
 		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+}
 
+static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
+{
+	struct perf_mmap_data *data;
+
+	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
+	perf_mmap_data_free(data);
 	kfree(data);
 }
 
-static void perf_mmap_data_free(struct perf_counter *counter)
+static void perf_mmap_data_release(struct perf_counter *counter)
 {
 	struct perf_mmap_data *data = counter->data;
 
 	WARN_ON(atomic_read(&counter->mmap_count));
 
 	rcu_assign_pointer(counter->data, NULL);
-	call_rcu(&data->rcu_head, __perf_mmap_data_free);
+	call_rcu(&data->rcu_head, perf_mmap_data_free_rcu);
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -2249,7 +2267,7 @@ static void perf_mmap_close(struct vm_ar
 
 		atomic_long_sub(counter->data->nr_pages + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= counter->data->nr_locked;
-		perf_mmap_data_free(counter);
+		perf_mmap_data_release(counter);
 		mutex_unlock(&counter->mmap_mutex);
 	}
 }
@@ -2267,6 +2285,7 @@ static int perf_mmap(struct file *file, 
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
+	struct perf_mmap_data *data;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -2329,10 +2348,15 @@ static int perf_mmap(struct file *file, 
 	}
 
 	WARN_ON(counter->data);
-	ret = perf_mmap_data_alloc(counter, nr_pages);
-	if (ret)
+
+	data = perf_mmap_data_alloc(counter, nr_pages);
+	ret = -ENOMEM;
+	if (!data)
 		goto unlock;
 
+	ret = 0;
+	perf_mmap_data_init(counter, data);
+
 	atomic_set(&counter->mmap_count, 1);
 	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;

-- 

