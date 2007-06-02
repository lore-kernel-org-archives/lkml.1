Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXFBESE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXFBESE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXFBERz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:17:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49451 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbXFBERy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:17:54 -0400
Date: Fri, 1 Jun 2007 21:17:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>
Subject: Conditionals for development tests and output
Message-ID: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces 

CONFIG_DEVELKERNEL

If CONFIG_DEVELKERNEL is set then this is a development kernel.
Otherwise the kernel to be built is a a production kernel.


If CONFIG_DEVELKERNEL is set then the constant

DEVELKERNEL

is set to 1. Otherwise it is zero.

The following functions are defined in kernel.h for diagnostics

DEVEL_WARN_ON(condition)

	Warn on the condition but only if this is a development kernel

DEVEL_WARN_ON_ONCE(condition)

	Warn on the condition once but only if this is a development kernel

devel_printk(fmt, ...)

	Output that should only be generated for a development kernel.


CONFIG_DEVELKERNEL is set and cleared by edit the Makefile. Line 7 contains

DEVELKERNEL = 1


Updates SLAB and SLUB to not perform the kmalloc(0) tests anymore
if the kernel is not a development kernel.


Editing DEVELKERNEL requires a 

	make clean

to correctly rebuild the kernel with the proper settings. This is similar 
to editing the version number. Sam: Is there any way to avoid the make 
clean?

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 Makefile                 |    3 ++-
 include/linux/kernel.h   |   14 ++++++++++++++
 include/linux/slub_def.h |    2 +-
 mm/slab.c                |    2 +-
 mm/slub.c                |    4 ++--
 scripts/kconfig/symbol.c |    9 +++++++++
 6 files changed, 29 insertions(+), 5 deletions(-)

Index: slub/Makefile
===================================================================
--- slub.orig/Makefile	2007-06-01 20:11:57.000000000 -0700
+++ slub/Makefile	2007-06-01 20:56:27.000000000 -0700
@@ -3,6 +3,7 @@ PATCHLEVEL = 6
 SUBLEVEL = 22
 EXTRAVERSION = -rc3-mm1
 NAME = Jeff Thinks I Should Change This, But To What?
+DEVELKERNEL = 1
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
@@ -320,7 +321,7 @@ AFLAGS          := -D__ASSEMBLY__
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
-export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
+export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION DEVELKERNEL
 export ARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
Index: slub/scripts/kconfig/symbol.c
===================================================================
--- slub.orig/scripts/kconfig/symbol.c	2007-06-01 20:13:24.000000000 -0700
+++ slub/scripts/kconfig/symbol.c	2007-06-01 21:07:52.000000000 -0700
@@ -72,6 +72,15 @@ void sym_init(void)
 	sym->type = S_STRING;
 	sym->flags |= SYMBOL_AUTO;
 	sym_add_default(sym, uts.release);
+
+	sym = sym_lookup("DEVELKERNEL", 0);
+	sym->type = S_BOOLEAN;
+	sym->flags |= SYMBOL_VALID|SYMBOL_AUTO;
+	p = getenv("DEVELKERNEL");
+	if (p && atoi(p))
+		sym_add_default(sym, "y");
+	else
+		sym_add_default(sym, "n");
 }
 
 enum symbol_type sym_get_type(struct symbol *sym)
Index: slub/include/linux/kernel.h
===================================================================
--- slub.orig/include/linux/kernel.h	2007-06-01 20:19:17.000000000 -0700
+++ slub/include/linux/kernel.h	2007-06-01 20:30:16.000000000 -0700
@@ -375,4 +375,18 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#ifdef CONFIG_DEVELKERNEL
+#define DEVELKERNEL 1
+#else
+#define DEVELKERNEL 0
+#endif
+
+#define DEVEL_WARN_ON(x)	WARN_ON(DEVELKERNEL && (x))
+#define DEVEL_WARN_ON_ONCE(x)	WARN_ON_ONCE(DEVELKERNEL && (x))
+
+#define devel_printk(fmt,arg...) 	({					\
+	if (DEVELKERNEL)						\
+			printk(fmt, ##arg);				\
+})
+
 #endif
Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-06-01 20:25:06.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-06-01 20:28:02.000000000 -0700
@@ -80,7 +80,7 @@ static inline int kmalloc_index(size_t s
 	 * allocate memory but return ZERO_SIZE_PTR.
 	 * WARN so that people can review and fix their code.
 	 */
-	WARN_ON_ONCE(size == 0);
+	DEVEL_WARN_ON_ONCE(size == 0);
 
 	if (!size)
 		return 0;
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-01 20:24:26.000000000 -0700
+++ slub/mm/slub.c	2007-06-01 20:28:20.000000000 -0700
@@ -2525,8 +2525,8 @@ void __init kmem_cache_init(void)
 	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
 				nr_cpu_ids * sizeof(struct page *);
 
-	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" Processors=%d, Nodes=%d\n",
+	devel_printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, "
+		"MinObjects=%d, Processors=%d, Nodes=%d\n",
 		KMALLOC_SHIFT_HIGH, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-06-01 20:29:39.000000000 -0700
+++ slub/mm/slab.c	2007-06-01 20:29:45.000000000 -0700
@@ -774,7 +774,7 @@ static inline struct kmem_cache *__find_
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
-	WARN_ON_ONCE(size == 0);
+	DEVEL_WARN_ON_ONCE(size == 0);
 	while (size > csizep->cs_size)
 		csizep++;
 
