Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbYEETES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbYEETES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763237AbYEETCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:02:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42459 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763244AbYEETCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:53 -0400
Message-Id: <20080505190247.676948211@sgi.com>
References: <20080505190213.714827651@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 12:02:17 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 4/4] x86: e820 unification: Extract common functions
Content-Disposition: inline; filename=e820_2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the common functions to the common area. The parameters of
e820_any_mapped vary between 32 and 64 bit. Convert them to unsigned long
for 32 bit so that they match.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/e820_32.c |    2 +-
 include/asm-x86/e820.h    |   43 +++++++++++++++----------------------------
 2 files changed, 16 insertions(+), 29 deletions(-)

Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h	2008-05-05 11:59:56.000000000 -0700
+++ linux-2.6/include/asm-x86/e820.h	2008-05-05 12:00:58.000000000 -0700
@@ -44,29 +44,17 @@ struct e820map {
 
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
-extern int e820_any_mapped(u64 start, u64 end, unsigned type);
-extern void propagate_e820_map(void);
-extern void register_bootmem_low_pages(unsigned long max_low_pfn);
+extern int e820_any_mapped(unsigned long start, unsigned long end,
+			unsigned type);
 extern void add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
-extern void e820_register_memory(void);
-extern void limit_regions(unsigned long long size);
-extern void init_iomem_resources(struct resource *code_resource,
-				 struct resource *data_resource,
-				 struct resource *bss_resource);
 
 #if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 extern void e820_mark_nosave_regions(void);
@@ -76,25 +64,29 @@ static inline void e820_mark_nosave_regi
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
@@ -105,11 +97,6 @@ extern void e820_setup_gap(void);
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
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c	2008-04-23 12:07:32.000000000 -0700
+++ linux-2.6/arch/x86/kernel/e820_32.c	2008-05-05 12:00:01.000000000 -0700
@@ -645,7 +645,7 @@ void __init limit_regions(unsigned long 
  * with type.
  */
 int
-e820_any_mapped(u64 start, u64 end, unsigned type)
+e820_any_mapped(unsigned long start,unsigned long end, unsigned type)
 {
 	int i;
 	for (i = 0; i < e820.nr_map; i++) {

-- 
