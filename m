Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYEETDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYEETDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760475AbYEETCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:02:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42452 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759467AbYEETCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:43 -0400
Message-Id: <20080505190241.943649771@sgi.com>
References: <20080505190213.714827651@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 12:02:14 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 1/4] x86: e820.h unification
Content-Disposition: inline; filename=e820_unify
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch simply puts both 32 and 64 bit headers into one header file.
The #ifdef sequence at the top is shared.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/e820.h |  102 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 2 deletions(-)

Index: linux-next/include/asm-x86/e820.h
===================================================================
--- linux-next.orig/include/asm-x86/e820.h	2008-05-04 23:01:53.699852096 -0700
+++ linux-next/include/asm-x86/e820.h	2008-05-04 23:03:16.084868751 -0700
@@ -30,9 +30,107 @@ struct e820map {
 
 #ifdef __KERNEL__
 #ifdef CONFIG_X86_32
-# include "e820_32.h"
+/*
+ * structures and definitions for the int 15, ax=e820 memory map
+ * scheme.
+ *
+ * In a nutshell, arch/i386/boot/setup.S populates a scratch table
+ * in the empty_zero_block that contains a list of usable address/size
+ * duples.   In arch/i386/kernel/setup.c, this information is
+ * transferred into the e820map, and in arch/i386/mm/init.c, that
+ * new information is used to mark pages reserved or not.
+ *
+ */
+#include <linux/ioport.h>
+
+#define HIGH_MEMORY	(1024*1024)
+
+#ifndef __ASSEMBLY__
+
+extern void setup_memory_map(void);
+extern void finish_e820_parsing(void);
+
+extern struct e820map e820;
+extern void update_e820(void);
+
+extern int e820_all_mapped(unsigned long start, unsigned long end,
+			   unsigned type);
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
+extern void propagate_e820_map(void);
+extern void register_bootmem_low_pages(unsigned long max_low_pfn);
+extern void add_memory_region(unsigned long long start,
+			      unsigned long long size, int type);
+extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type);
+extern void e820_register_memory(void);
+extern void limit_regions(unsigned long long size);
+extern void init_iomem_resources(struct resource *code_resource,
+				 struct resource *data_resource,
+				 struct resource *bss_resource);
+
+#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
+extern void e820_mark_nosave_regions(void);
 #else
-# include "e820_64.h"
+static inline void e820_mark_nosave_regions(void)
+{
+}
+#endif
+
+
+#endif/*!__ASSEMBLY__*/
+#else /* X86_32 */
+/*
+ * structures and definitions for the int 15, ax=e820 memory map
+ * scheme.
+ *
+ * In a nutshell, setup.S populates a scratch table in the
+ * empty_zero_block that contains a list of usable address/size
+ * duples.  setup.c, this information is transferred into the e820map,
+ * and in init.c/numa.c, that new information is used to mark pages
+ * reserved or not.
+ */
+#include <linux/ioport.h>
+
+#ifndef __ASSEMBLY__
+extern unsigned long find_e820_area(unsigned long start, unsigned long end,
+				    unsigned long size, unsigned long align);
+extern unsigned long find_e820_area_size(unsigned long start,
+					 unsigned long *sizep,
+					 unsigned long align);
+extern void add_memory_region(unsigned long start, unsigned long size,
+			      int type);
+extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type);
+extern void setup_memory_region(void);
+extern void contig_e820_setup(void);
+extern unsigned long e820_end_of_ram(void);
+extern void e820_reserve_resources(void);
+extern void e820_mark_nosave_regions(void);
+extern int e820_any_mapped(unsigned long start, unsigned long end,
+			   unsigned type);
+extern int e820_all_mapped(unsigned long start, unsigned long end,
+			   unsigned type);
+extern int e820_any_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_any_valid(unsigned long start, unsigned long end);
+extern int e820_all_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_all_valid(unsigned long start, unsigned long end);
+extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
+
+extern void e820_setup_gap(void);
+extern void e820_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long end_pfn);
+
+extern void finish_e820_parsing(void);
+
+extern struct e820map e820;
+extern void update_e820(void);
+
+extern void reserve_early(unsigned long start, unsigned long end, char *name);
+extern void free_early(unsigned long start, unsigned long end);
+extern void early_res_to_bootmem(unsigned long start, unsigned long end);
+
+#endif/*!__ASSEMBLY__*/
+
 #endif
 #endif /* __KERNEL__ */
 

-- 
