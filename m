Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbZJPPdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbZJPPdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbZJPPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:33:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44072 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbZJPPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:33:07 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Oct 2009 16:31:14 +0100
Message-Id: <1255707074.3008.48.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 15:31:15.0304 (UTC) FILETIME=[B2E60680:01CA4E75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:07 +0200, Zdenek Kabelac wrote:
> 2009/10/16 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > 2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
> >> diff --git a/kernel/module.c b/kernel/module.c
> >> index 8b7d880..8cc4406 100644
> >> --- a/kernel/module.c
> >> +++ b/kernel/module.c
> >> @@ -2383,6 +2383,10 @@ static noinline struct module *load_module(void __user *umod,
> >>                                         "_ftrace_events",
> >>                                         sizeof(*mod->trace_events),
> >>                                         &mod->num_trace_events);
> >> +       kmemleak_scan_area(mod->module_core, (unsigned long)mod->trace_events -
> >> +                          (unsigned long)mod->module_core,
> >> +                          sizeof(*mod->trace_events) * mod->num_trace_events,
> >> +                          GFP_KERNEL);
> >>  #endif
> >>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >>        /* sechdrs[0].sh_size is always zero */
> 
> But it's still not perfect - as my machine now has a lot of these
> entries in the boot log:
> (I'm using only this patch - and not the next one where you removed
> call to kmemleak_load_module)
> 
> kmemleak: Scan area larger than object 0xffffffffa04f0000
> Pid: 1752, comm: modprobe Not tainted 2.6.32-rc5-00002-gdab7e9a #27
> Call Trace:
>  [<ffffffff8140ee6f>] kmemleak_scan_area+0x15f/0x1a0
>  [<ffffffff810a0089>] load_module+0xff9/0x1af0
>  [<ffffffff8109ca70>] ? setup_modinfo_srcversion+0x0/0x30
>  [<ffffffff810a0bfb>] sys_init_module+0x7b/0x260
>  [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
> kmemleak: Object 0xffffffffa04f0000 (size 8192):

I think that's caused by modules not having an _ftrace_events section.
The patch below (applied after the one above, though there may be a
conflict with some comments I added) changes the interface of
kmemleak_scan_area and now handles NULL pointers passed to it (not fully
tested as I just created it):


kmemleak: Simplify the kmemleak_scan_area() function prototype

From: Catalin Marinas <catalin.marinas@arm.com>

This function was taking non-necessary arguments which can be determined
by kmemleak. The patch also modifies the calling sites.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/linux/kmemleak.h |    8 ++++----
 kernel/module.c          |   13 ++++--------
 mm/kmemleak.c            |   49 ++++++++++++++++++++--------------------------
 mm/slab.c                |    4 ++--
 4 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 3c7497d..00888b9 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -32,8 +32,8 @@ extern void kmemleak_padding(const void *ptr, unsigned long offset,
 			     size_t size) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
-extern void kmemleak_scan_area(const void *ptr, unsigned long offset,
-			       size_t length, gfp_t gfp) __ref;
+extern void kmemleak_scan_area(const void *ptr, size_t length,
+			       gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
@@ -84,8 +84,8 @@ static inline void kmemleak_not_leak(const void *ptr)
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
-static inline void kmemleak_scan_area(const void *ptr, unsigned long offset,
-				      size_t length, gfp_t gfp)
+static inline void kmemleak_scan_area(const void *ptr, size_t length,
+				      gfp_t gfp)
 {
 }
 static inline void kmemleak_erase(void **ptr)
diff --git a/kernel/module.c b/kernel/module.c
index dd22f4e..dd29ba4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2043,9 +2043,7 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 	unsigned int i;
 
 	/* only scan the sections containing data */
-	kmemleak_scan_area(mod->module_core, (unsigned long)mod -
-			   (unsigned long)mod->module_core,
-			   sizeof(struct module), GFP_KERNEL);
+	kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
 
 	for (i = 1; i < hdr->e_shnum; i++) {
 		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
@@ -2054,8 +2052,7 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
 			continue;
 
-		kmemleak_scan_area(mod->module_core, sechdrs[i].sh_addr -
-				   (unsigned long)mod->module_core,
+		kmemleak_scan_area((void *)sechdrs[i].sh_addr,
 				   sechdrs[i].sh_size, GFP_KERNEL);
 	}
 }
@@ -2387,10 +2384,8 @@ static noinline struct module *load_module(void __user *umod,
 	 * This section contains pointers to allocated objects in the trace
 	 * code and not scanning it leads to false positives.
 	 */
-	kmemleak_scan_area(mod->module_core, (unsigned long)mod->trace_events -
-			   (unsigned long)mod->module_core,
-			   sizeof(*mod->trace_events) * mod->num_trace_events,
-			   GFP_KERNEL);
+	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
+			   mod->num_trace_events, GFP_KERNEL);
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8bf765c..9610635 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -119,8 +119,8 @@
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
 	struct hlist_node node;
-	unsigned long offset;
-	size_t length;
+	unsigned long start;
+	size_t size;
 };
 
 #define KMEMLEAK_GREY	0
@@ -241,8 +241,6 @@ struct early_log {
 	const void *ptr;		/* allocated/freed memory block */
 	size_t size;			/* memory block size */
 	int min_count;			/* minimum reference count */
-	unsigned long offset;		/* scan area offset */
-	size_t length;			/* scan area length */
 	unsigned long trace[MAX_TRACE];	/* stack trace */
 	unsigned int trace_len;		/* stack trace length */
 };
@@ -720,14 +718,13 @@ static void make_black_object(unsigned long ptr)
  * Add a scanning area to the object. If at least one such area is added,
  * kmemleak will only scan these ranges rather than the whole memory block.
  */
-static void add_scan_area(unsigned long ptr, unsigned long offset,
-			  size_t length, gfp_t gfp)
+static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
 	struct kmemleak_scan_area *area;
 
-	object = find_and_get_object(ptr, 0);
+	object = find_and_get_object(ptr, 1);
 	if (!object) {
 		kmemleak_warn("Adding scan area to unknown object at 0x%08lx\n",
 			      ptr);
@@ -741,7 +738,7 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
 	}
 
 	spin_lock_irqsave(&object->lock, flags);
-	if (offset + length > object->size) {
+	if (ptr + size > object->pointer + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
 		kmem_cache_free(scan_area_cache, area);
@@ -749,8 +746,8 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
 	}
 
 	INIT_HLIST_NODE(&area->node);
-	area->offset = offset;
-	area->length = length;
+	area->start = ptr;
+	area->size = size;
 
 	hlist_add_head(&area->node, &object->area_list);
 out_unlock:
@@ -786,7 +783,7 @@ static void object_no_scan(unsigned long ptr)
  * processed later once kmemleak is fully initialized.
  */
 static void __init log_early(int op_type, const void *ptr, size_t size,
-			     int min_count, unsigned long offset, size_t length)
+			     int min_count)
 {
 	unsigned long flags;
 	struct early_log *log;
@@ -808,8 +805,6 @@ static void __init log_early(int op_type, const void *ptr, size_t size,
 	log->ptr = ptr;
 	log->size = size;
 	log->min_count = min_count;
-	log->offset = offset;
-	log->length = length;
 	if (op_type == KMEMLEAK_ALLOC)
 		log->trace_len = __save_stack_trace(log->trace);
 	crt_early_log++;
@@ -858,7 +853,7 @@ void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		create_object((unsigned long)ptr, size, min_count, gfp);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_ALLOC, ptr, size, min_count, 0, 0);
+		log_early(KMEMLEAK_ALLOC, ptr, size, min_count);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
 
@@ -873,7 +868,7 @@ void __ref kmemleak_free(const void *ptr)
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		delete_object_full((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_FREE, ptr, 0, 0, 0, 0);
+		log_early(KMEMLEAK_FREE, ptr, 0, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
 
@@ -888,7 +883,7 @@ void __ref kmemleak_free_part(const void *ptr, size_t size)
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		delete_object_part((unsigned long)ptr, size);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_FREE_PART, ptr, size, 0, 0, 0);
+		log_early(KMEMLEAK_FREE_PART, ptr, size, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
 
@@ -903,7 +898,7 @@ void __ref kmemleak_not_leak(const void *ptr)
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		make_gray_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_NOT_LEAK, ptr, 0, 0, 0, 0);
+		log_early(KMEMLEAK_NOT_LEAK, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
 
@@ -919,22 +914,21 @@ void __ref kmemleak_ignore(const void *ptr)
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		make_black_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_IGNORE, ptr, 0, 0, 0, 0);
+		log_early(KMEMLEAK_IGNORE, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
 
 /*
  * Limit the range to be scanned in an allocated memory block.
  */
-void __ref kmemleak_scan_area(const void *ptr, unsigned long offset,
-			      size_t length, gfp_t gfp)
+void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
-		add_scan_area((unsigned long)ptr, offset, length, gfp);
+		add_scan_area((unsigned long)ptr, size, gfp);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_SCAN_AREA, ptr, 0, 0, offset, length);
+		log_early(KMEMLEAK_SCAN_AREA, ptr, size, 0);
 }
 EXPORT_SYMBOL(kmemleak_scan_area);
 
@@ -948,7 +942,7 @@ void __ref kmemleak_no_scan(const void *ptr)
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
 		object_no_scan((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
-		log_early(KMEMLEAK_NO_SCAN, ptr, 0, 0, 0, 0);
+		log_early(KMEMLEAK_NO_SCAN, ptr, 0, 0);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
 
@@ -1075,9 +1069,9 @@ static void scan_object(struct kmemleak_object *object)
 		}
 	} else
 		hlist_for_each_entry(area, elem, &object->area_list, node)
-			scan_block((void *)(object->pointer + area->offset),
-				   (void *)(object->pointer + area->offset
-					    + area->length), object, 0);
+			scan_block((void *)area->start,
+				   (void *)(area->start + area->size),
+				   object, 0);
 out:
 	spin_unlock_irqrestore(&object->lock, flags);
 }
@@ -1642,8 +1636,7 @@ void __init kmemleak_init(void)
 			kmemleak_ignore(log->ptr);
 			break;
 		case KMEMLEAK_SCAN_AREA:
-			kmemleak_scan_area(log->ptr, log->offset, log->length,
-					   GFP_KERNEL);
+			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);
 			break;
 		case KMEMLEAK_NO_SCAN:
 			kmemleak_no_scan(log->ptr);
diff --git a/mm/slab.c b/mm/slab.c
index 646db30..d2713a9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2584,8 +2584,8 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		 * kmemleak does not treat the ->s_mem pointer as a reference
 		 * to the object. Otherwise we will not report the leak.
 		 */
-		kmemleak_scan_area(slabp, offsetof(struct slab, list),
-				   sizeof(struct list_head), local_flags);
+		kmemleak_scan_area(&slabp->list, sizeof(struct list_head),
+				   local_flags);
 		if (!slabp)
 			return NULL;
 	} else {

-- 
Catalin

