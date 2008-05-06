Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbYEFTfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbYEFTfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761449AbYEFTeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:34:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757163AbYEFTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:34:04 -0400
Message-Id: <20080506193403.114914061@sgi.com>
References: <20080506193352.225379637@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 12:33:56 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [patch 4/4] x86: e820 unification: Extract common functions
Content-Disposition: inline; filename=e820_2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the common functions to the common area.

The parameters of e820_any_mapped vary between 32 and 64 bit.
Convert them to u64 so that they match.

Same issue is there fore add_memory_region. 32 bit uses unsigned long long
there. Convert both platforms to use u64.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/e820_32.c |    3 --
 arch/x86/kernel/e820_64.c |    4 +--
 include/asm-x86/e820.h    |   47 +++++++++++++++-------------------------------
 3 files changed, 19 insertions(+), 35 deletions(-)

Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h	2008-05-06 12:29:06.000000000 -0700
+++ linux-2.6/include/asm-x86/e820.h	2008-05-06 12:29:06.000000000 -0700
@@ -44,30 +44,15 @@ struct e820map {
 
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
 
 #if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 extern void e820_mark_nosave_regions(void);
@@ -77,25 +62,30 @@ static inline void e820_mark_nosave_regi
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
@@ -106,11 +96,6 @@ extern void e820_setup_gap(void);
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
--- linux-2.6.orig/arch/x86/kernel/e820_64.c	2008-05-06 12:29:02.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_64.c	2008-05-06 12:29:06.000000000 -0700
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
--- linux-2.6.orig/arch/x86/kernel/e820_32.c	2008-05-06 12:29:04.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_32.c	2008-05-06 12:29:08.000000000 -0700
@@ -255,8 +255,7 @@ void __init e820_mark_nosave_regions(voi
 }
 #endif
 
-void __init add_memory_region(unsigned long long start,
-			      unsigned long long size, int type)
+void __init add_memory_region(u64 start, u64 size, int type)
 {
 	int x;
 

-- 
