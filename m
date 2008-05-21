Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYEUDK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYEUDK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYEUDKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:10:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:59302 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbYEUDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VnTGs13Wz0OjFxM/PeEUcNBH3CmQ0pRqo7E+v0enrgYbButyXIo2u/viREBNgTuBj+vEM2iFXLgDKM/43iKJfAB3Q6bcTxUEbQQROMLf5gzpaXMFH4j87Haf4w4CciCPs63Duo3+HoRz5zBqbbGT8AJKJ/7WmaWfP3BtfFYdC88=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: move e820_mark_nosave_regions to e820.c
Date: Tue, 20 May 2008 20:10:58 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com>
In-Reply-To: <200805180118.57863.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805202010.58646.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and make e820_mark_nosave_regions to take limit_pfn to use max_low_pfn
for 32bit and end_pfn for 64bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pfn.h>
+#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -495,6 +496,36 @@ __init void e820_setup_gap(void)
 	       pci_mem_start, gapstart, gapsize);
 }
 
+#if defined(CONFIG_X86_64) || (defined(CONFIG_X86_32) && defined(CONFIG_PM) && defined(CONFIG_HIBERNATION))
+/**
+ * Find the ranges of physical addresses that do not correspond to
+ * e820 RAM areas and mark the corresponding pages as nosave for
+ * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
+ *
+ * This function requires the e820 map to be sorted and without any
+ * overlapping entries and assumes the first e820 area to be RAM.
+ */
+void __init e820_mark_nosave_regions(unsigned long limit_pfn)
+{
+	int i;
+	unsigned long pfn;
+
+	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
+	for (i = 1; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (pfn < PFN_UP(ei->addr))
+			register_nosave_region(pfn, PFN_UP(ei->addr));
+
+		pfn = PFN_DOWN(ei->addr + ei->size);
+		if (ei->type != E820_RAM)
+			register_nosave_region(PFN_UP(ei->addr), pfn);
+
+		if (pfn >= limit_pfn)
+			break;
+	}
+}
+#endif
 
 /*
  * Early reserved memory areas.
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
-#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -208,37 +207,6 @@ void __init init_iomem_resources(struct 
 	}
 }
 
-#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
-/**
- * e820_mark_nosave_regions - Find the ranges of physical addresses that do not
- * correspond to e820 RAM areas and mark the corresponding pages as nosave for
- * hibernation.
- *
- * This function requires the e820 map to be sorted and without any
- * overlapping entries and assumes the first e820 area to be RAM.
- */
-void __init e820_mark_nosave_regions(void)
-{
-	int i;
-	unsigned long pfn;
-
-	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
-	for (i = 1; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-
-		if (pfn < PFN_UP(ei->addr))
-			register_nosave_region(pfn, PFN_UP(ei->addr));
-
-		pfn = PFN_DOWN(ei->addr + ei->size);
-		if (ei->type != E820_RAM)
-			register_nosave_region(PFN_UP(ei->addr), pfn);
-
-		if (pfn >= max_low_pfn)
-			break;
-	}
-}
-#endif
-
 /*
  * Find the highest page frame number we have available
  */
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -17,7 +17,6 @@
 #include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/suspend.h>
 #include <linux/pfn.h>
 #include <linux/pci.h>
 
@@ -94,37 +93,6 @@ void __init e820_reserve_resources(void)
 }
 
 /*
- * Find the ranges of physical addresses that do not correspond to
- * e820 RAM areas and mark the corresponding pages as nosave for software
- * suspend and suspend to RAM.
- *
- * This function requires the e820 map to be sorted and without any
- * overlapping entries and assumes the first e820 area to be RAM.
- */
-void __init e820_mark_nosave_regions(void)
-{
-	int i;
-	unsigned long paddr;
-
-	paddr = round_down(e820.map[0].addr + e820.map[0].size, PAGE_SIZE);
-	for (i = 1; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-
-		if (paddr < ei->addr)
-			register_nosave_region(PFN_DOWN(paddr),
-						PFN_UP(ei->addr));
-
-		paddr = round_down(ei->addr + ei->size, PAGE_SIZE);
-		if (ei->type != E820_RAM)
-			register_nosave_region(PFN_UP(ei->addr),
-						PFN_DOWN(paddr));
-
-		if (paddr >= (end_pfn << PAGE_SHIFT))
-			break;
-	}
-}
-
-/*
  * Finds an active region in the address range from start_pfn to last_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
  */
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -789,7 +789,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	e820_setup_gap();
-	e820_mark_nosave_regions();
+	e820_mark_nosave_regions(max_low_pfn);
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -499,7 +499,7 @@ void __init setup_arch(char **cmdline_p)
 	 * We trust e820 completely. No explicit ROM probing in memory.
 	 */
 	e820_reserve_resources();
-	e820_mark_nosave_regions();
+	e820_mark_nosave_regions(end_pfn);
 
 	/* request I/O space for devices used on all i[345]86 PCs */
 	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -70,6 +70,14 @@ extern u64 update_memory_range(u64 start
 extern void update_e820(void);
 extern void e820_setup_gap(void);
 
+#if defined(CONFIG_X86_64) || (defined(CONFIG_X86_32) && defined(CONFIG_PM) && defined(CONFIG_HIBERNATION))
+extern void e820_mark_nosave_regions(unsigned long limit_pfn);
+#else
+static inline void e820_mark_nosave_regions(unsigned long limit_pfn)
+{
+}
+#endif
+
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -28,13 +28,5 @@ extern void init_iomem_resources(struct 
 				 struct resource *data_resource,
 				 struct resource *bss_resource);
 
-#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
-extern void e820_mark_nosave_regions(void);
-#else
-static inline void e820_mark_nosave_regions(void)
-{
-}
-#endif
-
 #endif/*!__ASSEMBLY__*/
 #endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -18,7 +18,6 @@ extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
-extern void e820_mark_nosave_regions(void);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
