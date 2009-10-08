Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZJHSvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZJHSvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbZJHSvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:51:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497AbZJHSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:51:05 -0400
Date: Thu, 8 Oct 2009 20:50:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC GIT PULL] SPARC perf events fixes
Message-ID: <20091008185013.GA20622@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the sparc-perf-events-fixes-for-linus git tree 
from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sparc-perf-events-fixes-for-linus

( Note: this is on top of the perf-fixes-for-linus-2 pull request i just 
  sent. )

This tree contains two fixes for SPARC support that originate from 
before the merge window but got delayed due to being reworked.

They fix perf events sampling buffers to not corrupt memory on Sparc. We 
are providing the vmalloc based facility on x86 too - under a 
non-default debug .config option, to ease testing.

The MM bits were in -mm and Andrew originally queued them for .32 and it 
got rerouted to this topic branch to keep it together with Dave's fix 
patch.

I kept them in a separate branch because they are a bit large (mostly 
mechanic to the !vmalloc case but still large), and because they touch 
the MM.

 Thanks,

	Ingo

------------------>
David Miller (1):
      mm, perf_event: Make vmalloc_user() align base kernel virtual address to SHMLBA

Peter Zijlstra (1):
      perf_event: Provide vmalloc() based mmap() backing


 arch/sparc/Kconfig         |    2 +
 include/linux/perf_event.h |    5 +
 init/Kconfig               |   18 +++
 kernel/perf_event.c        |  248 +++++++++++++++++++++++++++++++++-----------
 mm/vmalloc.c               |   48 +++++----
 tools/perf/design.txt      |    3 +
 6 files changed, 240 insertions(+), 84 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 97fca46..9b70a2f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,6 +26,7 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_PERF_EVENTS
+	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 
@@ -48,6 +49,7 @@ config SPARC64
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
 	select HAVE_PERF_EVENTS
+	select PERF_USE_VMALLOC
 
 config ARCH_DEFCONFIG
 	string
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3a9d36d..2e6d95f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -442,6 +442,7 @@ enum perf_callchain_context {
 #include <linux/hrtimer.h>
 #include <linux/fs.h>
 #include <linux/pid_namespace.h>
+#include <linux/workqueue.h>
 #include <asm/atomic.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -513,6 +514,10 @@ struct file;
 
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
+#ifdef CONFIG_PERF_USE_VMALLOC
+	struct work_struct		work;
+#endif
+	int				data_order;
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
diff --git a/init/Kconfig b/init/Kconfig
index c7bac39..09c5c64 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -921,6 +921,11 @@ config HAVE_PERF_EVENTS
 	help
 	  See tools/perf/design.txt for details.
 
+config PERF_USE_VMALLOC
+	bool
+	help
+	  See tools/perf/design.txt for details
+
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
@@ -976,6 +981,19 @@ config PERF_COUNTERS
 
 	  Say N if unsure.
 
+config DEBUG_PERF_USE_VMALLOC
+	default n
+	bool "Debug: use vmalloc to back perf mmap() buffers"
+	depends on PERF_EVENTS && DEBUG_KERNEL
+	select PERF_USE_VMALLOC
+	help
+	 Use vmalloc memory to back perf mmap() buffers.
+
+	 Mostly useful for debugging the vmalloc code on platforms
+	 that don't require it.
+
+	 Say N if unsure.
+
 endmenu
 
 config VM_EVENT_COUNTERS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e491fb0..9d0b5c6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -20,6 +20,7 @@
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
 #include <linux/vmstat.h>
+#include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
@@ -2091,49 +2092,31 @@ unlock:
 	rcu_read_unlock();
 }
 
-static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static unsigned long perf_data_size(struct perf_mmap_data *data)
 {
-	struct perf_event *event = vma->vm_file->private_data;
-	struct perf_mmap_data *data;
-	int ret = VM_FAULT_SIGBUS;
-
-	if (vmf->flags & FAULT_FLAG_MKWRITE) {
-		if (vmf->pgoff == 0)
-			ret = 0;
-		return ret;
-	}
-
-	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (!data)
-		goto unlock;
-
-	if (vmf->pgoff == 0) {
-		vmf->page = virt_to_page(data->user_page);
-	} else {
-		int nr = vmf->pgoff - 1;
-
-		if ((unsigned)nr > data->nr_pages)
-			goto unlock;
+	return data->nr_pages << (PAGE_SHIFT + data->data_order);
+}
 
-		if (vmf->flags & FAULT_FLAG_WRITE)
-			goto unlock;
+#ifndef CONFIG_PERF_USE_VMALLOC
 
-		vmf->page = virt_to_page(data->data_pages[nr]);
-	}
+/*
+ * Back perf_mmap() with regular GFP_KERNEL-0 pages.
+ */
 
-	get_page(vmf->page);
-	vmf->page->mapping = vma->vm_file->f_mapping;
-	vmf->page->index   = vmf->pgoff;
+static struct page *
+perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
+{
+	if (pgoff > data->nr_pages)
+		return NULL;
 
-	ret = 0;
-unlock:
-	rcu_read_unlock();
+	if (pgoff == 0)
+		return virt_to_page(data->user_page);
 
-	return ret;
+	return virt_to_page(data->data_pages[pgoff - 1]);
 }
 
-static int perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
+static struct perf_mmap_data *
+perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 {
 	struct perf_mmap_data *data;
 	unsigned long size;
@@ -2158,19 +2141,10 @@ static int perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 			goto fail_data_pages;
 	}
 
+	data->data_order = 0;
 	data->nr_pages = nr_pages;
-	atomic_set(&data->lock, -1);
-
-	if (event->attr.watermark) {
-		data->watermark = min_t(long, PAGE_SIZE * nr_pages,
-				      event->attr.wakeup_watermark);
-	}
-	if (!data->watermark)
-		data->watermark = max(PAGE_SIZE, PAGE_SIZE * nr_pages / 4);
 
-	rcu_assign_pointer(event->data, data);
-
-	return 0;
+	return data;
 
 fail_data_pages:
 	for (i--; i >= 0; i--)
@@ -2182,7 +2156,7 @@ fail_user_page:
 	kfree(data);
 
 fail:
-	return -ENOMEM;
+	return NULL;
 }
 
 static void perf_mmap_free_page(unsigned long addr)
@@ -2193,28 +2167,169 @@ static void perf_mmap_free_page(unsigned long addr)
 	__free_page(page);
 }
 
-static void __perf_mmap_data_free(struct rcu_head *rcu_head)
+static void perf_mmap_data_free(struct perf_mmap_data *data)
 {
-	struct perf_mmap_data *data;
 	int i;
 
-	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
-
 	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
 		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+}
+
+#else
+
+/*
+ * Back perf_mmap() with vmalloc memory.
+ *
+ * Required for architectures that have d-cache aliasing issues.
+ */
+
+static struct page *
+perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
+{
+	if (pgoff > (1UL << data->data_order))
+		return NULL;
+
+	return vmalloc_to_page((void *)data->user_page + pgoff * PAGE_SIZE);
+}
+
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void perf_mmap_data_free_work(struct work_struct *work)
+{
+	struct perf_mmap_data *data;
+	void *base;
+	int i, nr;
+
+	data = container_of(work, struct perf_mmap_data, work);
+	nr = 1 << data->data_order;
+
+	base = data->user_page;
+	for (i = 0; i < nr + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+}
+
+static void perf_mmap_data_free(struct perf_mmap_data *data)
+{
+	schedule_work(&data->work);
+}
+
+static struct perf_mmap_data *
+perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
+{
+	struct perf_mmap_data *data;
+	unsigned long size;
+	void *all_buf;
 
+	WARN_ON(atomic_read(&event->mmap_count));
+
+	size = sizeof(struct perf_mmap_data);
+	size += sizeof(void *);
+
+	data = kzalloc(size, GFP_KERNEL);
+	if (!data)
+		goto fail;
+
+	INIT_WORK(&data->work, perf_mmap_data_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	data->user_page = all_buf;
+	data->data_pages[0] = all_buf + PAGE_SIZE;
+	data->data_order = ilog2(nr_pages);
+	data->nr_pages = 1;
+
+	return data;
+
+fail_all_buf:
+	kfree(data);
+
+fail:
+	return NULL;
+}
+
+#endif
+
+static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct perf_event *event = vma->vm_file->private_data;
+	struct perf_mmap_data *data;
+	int ret = VM_FAULT_SIGBUS;
+
+	if (vmf->flags & FAULT_FLAG_MKWRITE) {
+		if (vmf->pgoff == 0)
+			ret = 0;
+		return ret;
+	}
+
+	rcu_read_lock();
+	data = rcu_dereference(event->data);
+	if (!data)
+		goto unlock;
+
+	if (vmf->pgoff && (vmf->flags & FAULT_FLAG_WRITE))
+		goto unlock;
+
+	vmf->page = perf_mmap_to_page(data, vmf->pgoff);
+	if (!vmf->page)
+		goto unlock;
+
+	get_page(vmf->page);
+	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->index   = vmf->pgoff;
+
+	ret = 0;
+unlock:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static void
+perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
+{
+	long max_size = perf_data_size(data);
+
+	atomic_set(&data->lock, -1);
+
+	if (event->attr.watermark) {
+		data->watermark = min_t(long, max_size,
+					event->attr.wakeup_watermark);
+	}
+
+	if (!data->watermark)
+		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
+
+
+	rcu_assign_pointer(event->data, data);
+}
+
+static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
+{
+	struct perf_mmap_data *data;
+
+	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
+	perf_mmap_data_free(data);
 	kfree(data);
 }
 
-static void perf_mmap_data_free(struct perf_event *event)
+static void perf_mmap_data_release(struct perf_event *event)
 {
 	struct perf_mmap_data *data = event->data;
 
 	WARN_ON(atomic_read(&event->mmap_count));
 
 	rcu_assign_pointer(event->data, NULL);
-	call_rcu(&data->rcu_head, __perf_mmap_data_free);
+	call_rcu(&data->rcu_head, perf_mmap_data_free_rcu);
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -2230,11 +2345,12 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
+		unsigned long size = perf_data_size(event->data);
 		struct user_struct *user = current_user();
 
-		atomic_long_sub(event->data->nr_pages + 1, &user->locked_vm);
+		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= event->data->nr_locked;
-		perf_mmap_data_free(event);
+		perf_mmap_data_release(event);
 		mutex_unlock(&event->mmap_mutex);
 	}
 }
@@ -2252,6 +2368,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
+	struct perf_mmap_data *data;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -2314,10 +2431,15 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	}
 
 	WARN_ON(event->data);
-	ret = perf_mmap_data_alloc(event, nr_pages);
-	if (ret)
+
+	data = perf_mmap_data_alloc(event, nr_pages);
+	ret = -ENOMEM;
+	if (!data)
 		goto unlock;
 
+	ret = 0;
+	perf_mmap_data_init(event, data);
+
 	atomic_set(&event->mmap_count, 1);
 	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;
@@ -2505,7 +2627,7 @@ static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 	if (!data->writable)
 		return true;
 
-	mask = (data->nr_pages << PAGE_SHIFT) - 1;
+	mask = perf_data_size(data) - 1;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -2610,7 +2732,7 @@ void perf_output_copy(struct perf_output_handle *handle,
 		      const void *buf, unsigned int len)
 {
 	unsigned int pages_mask;
-	unsigned int offset;
+	unsigned long offset;
 	unsigned int size;
 	void **pages;
 
@@ -2619,12 +2741,14 @@ void perf_output_copy(struct perf_output_handle *handle,
 	pages		= handle->data->data_pages;
 
 	do {
-		unsigned int page_offset;
+		unsigned long page_offset;
+		unsigned long page_size;
 		int nr;
 
 		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
-		page_offset = offset & (PAGE_SIZE - 1);
-		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
+		page_size   = 1UL << (handle->data->data_order + PAGE_SHIFT);
+		page_offset = offset & (page_size - 1);
+		size	    = min_t(unsigned int, page_size - page_offset, len);
 
 		memcpy(pages[nr] + page_offset, buf, size);
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 69511e6..4ecbbde 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
+#include <asm/shmparam.h>
 
 
 /*** Page table manipulation functions ***/
@@ -1156,12 +1157,11 @@ static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
-		unsigned long flags, unsigned long start, unsigned long end,
-		int node, gfp_t gfp_mask, void *caller)
+		unsigned long align, unsigned long flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
 	static struct vmap_area *va;
 	struct vm_struct *area;
-	unsigned long align = 1;
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
@@ -1201,7 +1201,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 						__builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
@@ -1210,7 +1210,7 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
 				       unsigned long start, unsigned long end,
 				       void *caller)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 				  caller);
 }
 
@@ -1225,22 +1225,22 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
  */
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 				-1, GFP_KERNEL, __builtin_return_address(0));
 }
 
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				void *caller)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 						-1, GFP_KERNEL, caller);
 }
 
 struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
 				   int node, gfp_t gfp_mask)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END, node,
-				  gfp_mask, __builtin_return_address(0));
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
+				  node, gfp_mask, __builtin_return_address(0));
 }
 
 static struct vm_struct *find_vm_area(const void *addr)
@@ -1403,7 +1403,8 @@ void *vmap(struct page **pages, unsigned int count,
 }
 EXPORT_SYMBOL(vmap);
 
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node, void *caller)
@@ -1417,7 +1418,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
@@ -1476,6 +1477,7 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 /**
  *	__vmalloc_node  -  allocate virtually contiguous memory
  *	@size:		allocation size
+ *	@align:		desired alignment
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
@@ -1485,8 +1487,9 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  */
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
-						int node, void *caller)
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1496,8 +1499,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
-						node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
+				  VMALLOC_END, node, gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1516,7 +1519,7 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, gfp_mask, prot, -1,
+	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -1532,7 +1535,7 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					-1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
@@ -1549,7 +1552,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+	ret = __vmalloc_node(size, SHMLBA,
+			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
 			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
@@ -1572,7 +1576,7 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
@@ -1595,7 +1599,7 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
 			      -1, __builtin_return_address(0));
 }
 
@@ -1616,7 +1620,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
 			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
@@ -1633,7 +1637,7 @@ void *vmalloc_32_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+	ret = __vmalloc_node(size, 1, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
 			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index f1946d1..fdd42a8 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -455,3 +455,6 @@ will need at least this:
 
 If your architecture does have hardware capabilities, you can override the
 weak stub hw_perf_event_init() to register hardware counters.
+
+Architectures that have d-cache aliassing issues, such as Sparc and ARM,
+should select PERF_USE_VMALLOC in order to avoid these for perf mmap().
