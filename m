Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYEJCMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYEJCMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYEJCKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:10:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42685 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752768AbYEJCKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:10:22 -0400
Message-Id: <20080510021021.229662721@sgi.com>
References: <20080510020947.803480649@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:09:52 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: travis@sgi.com
Subject: [patch 5/6] x86: e820 unification: Extract common functions
Content-Disposition: inline; filename=x86_unify_e820_h_common_functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the common functions to the common area.

The parameters of e820_any_mapped vary between 32 and 64 bit.
Convert them to u64 so that they match.

Same issue is there for add_memory_region(). 32 bit uses unsigned long long
there. Convert both platforms to use u64.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/e820_32.c |    3 --
 arch/x86/kernel/e820_64.c |    4 +--
 include/asm-x86/e820.h    |   50 ++++++++++++++++------------------------------
 3 files changed, 21 insertions(+), 36 deletions(-)

Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h	2008-05-09 16:05:13.000000000 -0700
+++ linux-2.6/include/asm-x86/e820.h	2008-05-09 16:05:23.000000000 -0700
@@ -44,32 +44,18 @@ struct e820map {
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_X86_32
-#define HIGH_MEMORY	(1024*1024)
-
-extern void setup_memory_map(void);
 extern void finish_e820_parsing(void);
-
 extern struct e820map e820;
 extern void update_e820(void);
-
 extern int e820_all_mapped(unsigned long start, unsigned long end,
 			   unsigned type);
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
-extern void propagate_e820_map(void);
-extern void register_bootmem_low_pages(unsigned long max_low_pfn);
-extern void add_memory_region(unsigned long long start,
-			      unsigned long long size, int type);
-extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
+extern void add_memory_region(u64 start, u64 size, int type);
+extern void update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
-extern void e820_register_memory(void);
-extern void limit_regions(unsigned long long size);
-extern void print_memory_map(char *who);
-extern void init_iomem_resources(struct resource *code_resource,
-				 struct resource *data_resource,
-				 struct resource *bss_resource);
 
-#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
+#if defined(CONFIG_X86_64) ||						\
+		(defined(CONFIG_PM) && defined(CONFIG_HIBERNATION))
 extern void e820_mark_nosave_regions(void);
 #else
 static inline void e820_mark_nosave_regions(void)
@@ -77,25 +63,30 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
+#ifdef CONFIG_X86_32
+#define HIGH_MEMORY	(1024*1024)
+
+extern void setup_memory_map(void);
+
+extern void propagate_e820_map(void);
+extern void register_bootmem_low_pages(unsigned long max_low_pfn);
+extern void e820_register_memory(void);
+extern void limit_regions(unsigned long long size);
+extern void print_memory_map(char *who);
+extern void init_iomem_resources(struct resource *code_resource,
+				 struct resource *data_resource,
+				 struct resource *bss_resource);
+
 #else /* X86_32 */
 extern unsigned long find_e820_area(unsigned long start, unsigned long end,
 				    unsigned long size, unsigned long align);
 extern unsigned long find_e820_area_size(unsigned long start,
 					 unsigned long *sizep,
 					 unsigned long align);
-extern void add_memory_region(unsigned long start, unsigned long size,
-			      int type);
-extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type);
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
-extern void e820_mark_nosave_regions(void);
-extern int e820_any_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
-extern int e820_all_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
@@ -106,11 +97,6 @@ extern void e820_setup_gap(void);
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 
-extern void finish_e820_parsing(void);
-
-extern struct e820map e820;
-extern void update_e820(void);
-
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
 extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(unsigned long start, unsigned long end);
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c	2008-05-09 16:05:13.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_64.c	2008-05-09 16:05:19.000000000 -0700
@@ -181,7 +181,7 @@ again:
  * with type.
  */
 int
-e820_any_mapped(unsigned long start, unsigned long end, unsigned type)
+e820_any_mapped(u64 start, u64 end, unsigned type)
 {
 	int i;
 
@@ -437,7 +437,7 @@ e820_register_active_regions(int nid, un
 /*
  * Add a memory region to the kernel e820 map.
  */
-void __init add_memory_region(unsigned long start, unsigned long size, int type)
+void __init add_memory_region(u64 start, u64 size, int type)
 {
 	int x = e820.nr_map;
 
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c	2008-05-09 16:05:13.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_32.c	2008-05-09 16:05:19.000000000 -0700
@@ -255,8 +255,7 @@ void __init e820_mark_nosave_regions(voi
 }
 #endif
 
-void __init add_memory_region(unsigned long long start,
-			      unsigned long long size, int type)
+void __init add_memory_region(u64 start, u64 size, int type)
 {
 	int x;
 

-- 
