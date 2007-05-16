Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbXEPBAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbXEPBAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbXEPBAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:00:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54513 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760208AbXEPBAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:00:24 -0400
Date: Tue, 15 May 2007 18:00:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
In-Reply-To: <20070515.173820.101498227.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0705151759420.4399@schroedinger.engr.sgi.com>
References: <20070515165636.5057456e.akpm@linux-foundation.org>
 <20070515.171447.83623268.davem@davemloft.net> <20070515172957.02d80d51.akpm@linux-foundation.org>
 <20070515.173820.101498227.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch. It probably does not apply cleanly against Andrew's 
tree. I am waiting for the new tree in order to submit it.


Slab allocators: Define common size limitations

Currently we have a maze of configuration variables that determine
the maximum slab size. Worst of all it seems to vary between SLAB and SLUB.

So define a common maximum size for kmalloc. For conveniences sake
we use the maximum size ever supported which is 32 MB. We limit the maximum
size to a lower limit if MAX_ORDER does not allow such large allocations.

For many architectures this patch will have the effect of adding large
possible kmalloc sizes. x86_64 adds 5 new kmalloc sizes. So a small amount
of memory will be needed for these caches (contemporary SLAB has dynamically
sizeable node and cpu structure so the waste is less than in th past)

Most architectures will then be able to allocate object sizes up to MAX_ORDER.
We have had repeated breakage on IA64 because a NUMA structure grew beyond
what the slab allocators supported. This will avoid future issues.

CONFIG_LARGE_ALLOCS is no longer necessary so drop it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/blackfin/Kconfig         |    8 --------
 arch/frv/Kconfig              |    8 --------
 arch/m68knommu/Kconfig        |    8 --------
 arch/sparc64/Kconfig          |    3 ---
 arch/v850/Kconfig             |    8 --------
 include/linux/kmalloc_sizes.h |   20 +++++++++++++++-----
 include/linux/slab.h          |   15 +++++++++++++++
 include/linux/slub_def.h      |   19 ++-----------------
 mm/slab.c                     |   19 ++-----------------
 9 files changed, 34 insertions(+), 74 deletions(-)

Index: slub/include/linux/slab.h
===================================================================
--- slub.orig/include/linux/slab.h	2007-05-14 17:26:56.000000000 -0700
+++ slub/include/linux/slab.h	2007-05-15 17:57:42.000000000 -0700
@@ -77,6 +77,21 @@ static inline void *kmem_cache_alloc_nod
 #endif
 
 /*
+ * The largest kmalloc size supported by the slab allocators is
+ * 32 megabyte (2^25) or the maximum allocatable page order if that is
+ * less than 32 MB.
+ *
+ * WARNING: Its not easy to increase this value since the allocators have
+ * to do various tricks to work around compiler limitations in order to
+ * ensure proper constant folding.
+ */
+#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT) <= 25 ? \
+				(MAX_ORDER + PAGE_SHIFT) : 25)
+
+#define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
+#define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_HIGH - PAGE_SHIFT)
+
+/*
  * Common kmalloc functions provided by all allocators
  */
 void *__kmalloc(size_t, gfp_t);
Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-05-14 17:26:56.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-05-15 17:58:10.000000000 -0700
@@ -58,17 +58,6 @@ struct kmem_cache {
  */
 #define KMALLOC_SHIFT_LOW 3
 
-#ifdef CONFIG_LARGE_ALLOCS
-#define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) < 25 ? \
-				MAX_ORDER + PAGE_SHIFT - 1 : 25)
-#else
-#if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
-#define KMALLOC_SHIFT_HIGH 20
-#else
-#define KMALLOC_SHIFT_HIGH 18
-#endif
-#endif
-
 /*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
@@ -79,7 +68,7 @@ extern struct kmem_cache kmalloc_caches[
  * Sorry that the following has to be that ugly but some versions of GCC
  * have trouble with constant propagation and loops.
  */
-static inline int kmalloc_index(int size)
+static inline int kmalloc_index(size_t size)
 {
 	/*
 	 * We should return 0 if size == 0 but we use the smallest object
@@ -87,7 +76,7 @@ static inline int kmalloc_index(int size
 	 */
 	WARN_ON_ONCE(size == 0);
 
-	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
+	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
 	if (size > 64 && size <= 96)
@@ -110,17 +99,13 @@ static inline int kmalloc_index(int size
 	if (size <=  64 * 1024) return 16;
 	if (size <= 128 * 1024) return 17;
 	if (size <= 256 * 1024) return 18;
-#if KMALLOC_SHIFT_HIGH > 18
 	if (size <=  512 * 1024) return 19;
 	if (size <= 1024 * 1024) return 20;
-#endif
-#if KMALLOC_SHIFT_HIGH > 20
 	if (size <=  2 * 1024 * 1024) return 21;
 	if (size <=  4 * 1024 * 1024) return 22;
 	if (size <=  8 * 1024 * 1024) return 23;
 	if (size <= 16 * 1024 * 1024) return 24;
 	if (size <= 32 * 1024 * 1024) return 25;
-#endif
 	return -1;
 
 /*
Index: slub/include/linux/kmalloc_sizes.h
===================================================================
--- slub.orig/include/linux/kmalloc_sizes.h	2007-05-14 17:26:56.000000000 -0700
+++ slub/include/linux/kmalloc_sizes.h	2007-05-14 18:42:45.000000000 -0700
@@ -19,17 +19,27 @@
 	CACHE(32768)
 	CACHE(65536)
 	CACHE(131072)
-#if (NR_CPUS > 512) || (MAX_NUMNODES > 256) || !defined(CONFIG_MMU)
+#if KMALLOC_MAX_SIZE >= 262144
 	CACHE(262144)
 #endif
-#ifndef CONFIG_MMU
+#if KMALLOC_MAX_SIZE >= 524288
 	CACHE(524288)
+#endif
+#if KMALLOC_MAX_SIZE >= 1048576
 	CACHE(1048576)
-#ifdef CONFIG_LARGE_ALLOCS
+#endif
+#if KMALLOC_MAX_SIZE >= 2097152
 	CACHE(2097152)
+#endif
+#if KMALLOC_MAX_SIZE >= 4194304
 	CACHE(4194304)
+#endif
+#if KMALLOC_MAX_SIZE >= 8388608
 	CACHE(8388608)
+#endif
+#if KMALLOC_MAX_SIZE >= 16777216
 	CACHE(16777216)
+#endif
+#if KMALLOC_MAX_SIZE >= 33554432
 	CACHE(33554432)
-#endif /* CONFIG_LARGE_ALLOCS */
-#endif /* CONFIG_MMU */
+#endif
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-05-14 17:26:56.000000000 -0700
+++ slub/mm/slab.c	2007-05-15 15:39:47.000000000 -0700
@@ -569,21 +569,6 @@ static void **dbg_userword(struct kmem_c
 #endif
 
 /*
- * Maximum size of an obj (in 2^order pages) and absolute limit for the gfp
- * order.
- */
-#if defined(CONFIG_LARGE_ALLOCS)
-#define	MAX_OBJ_ORDER	13	/* up to 32Mb */
-#define	MAX_GFP_ORDER	13	/* up to 32Mb */
-#elif defined(CONFIG_MMU)
-#define	MAX_OBJ_ORDER	5	/* 32 pages */
-#define	MAX_GFP_ORDER	5	/* 32 pages */
-#else
-#define	MAX_OBJ_ORDER	8	/* up to 1Mb */
-#define	MAX_GFP_ORDER	8	/* up to 1Mb */
-#endif
-
-/*
  * Do not go above this order unless 0 objects fit into the slab.
  */
 #define	BREAK_GFP_ORDER_HI	1
@@ -2001,7 +1986,7 @@ static size_t calculate_slab_order(struc
 	size_t left_over = 0;
 	int gfporder;
 
-	for (gfporder = 0; gfporder <= MAX_GFP_ORDER; gfporder++) {
+	for (gfporder = 0; gfporder <= KMALLOC_MAX_ORDER; gfporder++) {
 		unsigned int num;
 		size_t remainder;
 
@@ -2147,7 +2132,7 @@ kmem_cache_create (const char *name, siz
 	 * Sanity checks... these are all serious usage bugs.
 	 */
 	if (!name || in_interrupt() || (size < BYTES_PER_WORD) ||
-	    (size > (1 << MAX_OBJ_ORDER) * PAGE_SIZE) || dtor) {
+	    size > KMALLOC_MAX_SIZE || dtor) {
 		printk(KERN_ERR "%s: Early error in slab %s\n", __FUNCTION__,
 				name);
 		BUG();
Index: slub/arch/blackfin/Kconfig
===================================================================
--- slub.orig/arch/blackfin/Kconfig	2007-05-14 17:30:31.000000000 -0700
+++ slub/arch/blackfin/Kconfig	2007-05-14 17:30:45.000000000 -0700
@@ -560,14 +560,6 @@ endchoice
 
 source "mm/Kconfig"
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large
-	  memory sizes - upto 32MB. You may need this if your system has
-	  a lot of RAM, and you need to able to allocate very large
-	  contiguous chunks. If unsure, say N.
-
 config BFIN_DMA_5XX
 	bool "Enable DMA Support"
 	depends on (BF533 || BF532 || BF531 || BF537 || BF536 || BF534 || BF561)
Index: slub/arch/frv/Kconfig
===================================================================
--- slub.orig/arch/frv/Kconfig	2007-05-14 17:30:32.000000000 -0700
+++ slub/arch/frv/Kconfig	2007-05-14 17:31:08.000000000 -0700
@@ -102,14 +102,6 @@ config HIGHPTE
 	  with a lot of RAM, this can be wasteful of precious low memory.
 	  Setting this option will put user-space page tables in high memory.
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large memory
-	  sizes - up to 32MB. You may need this if your system has a lot of
-	  RAM, and you need to able to allocate very large contiguous chunks.
-	  If unsure, say N.
-
 source "mm/Kconfig"
 
 choice
Index: slub/arch/m68knommu/Kconfig
===================================================================
--- slub.orig/arch/m68knommu/Kconfig	2007-05-14 17:30:32.000000000 -0700
+++ slub/arch/m68knommu/Kconfig	2007-05-14 17:31:16.000000000 -0700
@@ -470,14 +470,6 @@ config AVNET
 	default y
 	depends on (AVNET5282)
 
-config LARGE_ALLOCS
-	bool "Allow allocating large blocks (> 1MB) of memory"
-	help
-	  Allow the slab memory allocator to keep chains for very large
-	  memory sizes - upto 32MB. You may need this if your system has
-	  a lot of RAM, and you need to able to allocate very large
-	  contiguous chunks. If unsure, say N.
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	default y
Index: slub/arch/sparc64/Kconfig
===================================================================
--- slub.orig/arch/sparc64/Kconfig	2007-05-14 17:30:32.000000000 -0700
+++ slub/arch/sparc64/Kconfig	2007-05-14 17:31:24.000000000 -0700
@@ -226,9 +226,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	select SPARSEMEM_STATIC
 
-config LARGE_ALLOCS
-	def_bool y
-
 source "mm/Kconfig"
 
 config ISA
Index: slub/arch/v850/Kconfig
===================================================================
--- slub.orig/arch/v850/Kconfig	2007-05-14 17:30:32.000000000 -0700
+++ slub/arch/v850/Kconfig	2007-05-14 17:31:33.000000000 -0700
@@ -240,14 +240,6 @@ menu "Processor type and features"
    config RESET_GUARD
    	  bool "Reset Guard"
 
-   config LARGE_ALLOCS
-	  bool "Allow allocating large blocks (> 1MB) of memory"
-	  help
-	     Allow the slab memory allocator to keep chains for very large
-	     memory sizes - upto 32MB. You may need this if your system has
-	     a lot of RAM, and you need to able to allocate very large
-	     contiguous chunks. If unsure, say N.
-
 source "mm/Kconfig"
 
 endmenu
