Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZJ1RPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZJ1RPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZJ1RPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:15:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33257 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbZJ1RPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:15:41 -0400
Subject: [PATCH] kmemleak: Simplify the kmemleak_scan_area() function prototype
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Wed, 28 Oct 2009 17:11:35 +0000
Message-ID: <20091028170958.18948.31226.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-1-g9f9ed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 17:11:36.0326 (UTC) FILETIME=[B4AA1260:01CA57F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was taking non-necessary arguments which can be determined
by kmemleak. The patch also modifies the calling sites.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

That's a pretty straight-forward function prototype change which I
posted last week but forgot to add the relevant "Cc:" as it touches
files other than mm/kmemleak.c.


 include/linux/kmemleak.h |    6 ++----
 kernel/module.c          |    7 ++-----
 mm/kmemleak.c            |   49 ++++++++++++++++++++--------------------------
 mm/slab.c                |    4 ++--
 4 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 3c7497d..99d9a67 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -32,8 +32,7 @@ extern void kmemleak_padding(const void *ptr, unsigned long offset,
 			     size_t size) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
-extern void kmemleak_scan_area(const void *ptr, unsigned long offset,
-			       size_t length, gfp_t gfp) __ref;
+extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
@@ -84,8 +83,7 @@ static inline void kmemleak_not_leak(const void *ptr)
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
-static inline void kmemleak_scan_area(const void *ptr, unsigned long offset,
-				      size_t length, gfp_t gfp)
+static inline void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 }
 static inline void kmemleak_erase(void **ptr)
diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..1eb9520 100644
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

