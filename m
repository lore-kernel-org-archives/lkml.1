Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYFDCh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYFDCh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYFDChp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:37:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:57816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYFDChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c4o5Jg3ZJm1BP3280t4pa7p86E5uQtaLBe2j7Sn1vtq7PEBPRkQCEEMc1PMY+P1WiF1FHiAEsOaeyeTFcLCXO5eYr2cej34qoIkyVcJWv7bSTmGY/E7H7vNA5P5dfF4QX+Z+NM9nhmX44oxSsXEI1VGjJCsKYbX6Qu5i2eimJJw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: move e820_register_active to e820.c
Date: Tue, 3 Jun 2008 19:34:00 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com>
In-Reply-To: <200806031025.55026.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031934.01198.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to prepare 32 bit to use it

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -764,3 +764,112 @@ u64 __init early_reserve_e820(u64 startt
 	return addr;
 }
 
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_PAE
+#  define MAX_ARCH_PFN		(1ULL<<(36-PAGE_SHIFT))
+# else
+#  define MAX_ARCH_PFN		(1ULL<<(32-PAGE_SHIFT))
+# endif
+#else /* CONFIG_X86_32 */
+# define MAX_ARCH_PFN MAXMEM<<PAGE_SHIFT
+#endif
+
+/*
+ * Last pfn which the user wants to use.
+ */
+unsigned long __initdata end_user_pfn = MAX_ARCH_PFN;
+
+/*
+ * Find the highest page frame number we have available
+ */
+unsigned long __init e820_end_of_ram(void)
+{
+	unsigned long last_pfn;
+	unsigned long max_arch_pfn = MAX_ARCH_PFN;
+
+	last_pfn = find_max_pfn_with_active_regions();
+
+	if (last_pfn > max_arch_pfn)
+		last_pfn = max_arch_pfn;
+	if (last_pfn > end_user_pfn)
+		last_pfn = end_user_pfn;
+
+	printk(KERN_INFO "last_pfn = %lu max_arch_pfn = %lu\n",
+			 last_pfn, max_arch_pfn);
+	return last_pfn;
+}
+
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
+ */
+int __init e820_find_active_region(const struct e820entry *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn)
+{
+	u64 align = PAGE_SIZE;
+
+	*ei_startpfn = round_up(ei->addr, align) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->addr + ei->size, align) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Skip if map is outside the node */
+	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
+				    *ei_startpfn >= last_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > last_pfn)
+		*ei_endpfn = last_pfn;
+
+	/* Obey end_user_pfn to save on memmap */
+	if (*ei_startpfn >= end_user_pfn)
+		return 0;
+	if (*ei_endpfn > end_user_pfn)
+		*ei_endpfn = end_user_pfn;
+
+	return 1;
+}
+
+/* Walk the e820 map and register active regions within a node */
+void __init e820_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++)
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init e820_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+	}
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -42,29 +42,6 @@ unsigned long end_pfn;
 unsigned long max_pfn_mapped;
 
 /*
- * Last pfn which the user wants to use.
- */
-static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
-
-/*
- * Find the highest page frame number we have available
- */
-unsigned long __init e820_end_of_ram(void)
-{
-	unsigned long last_pfn;
-
-	last_pfn = find_max_pfn_with_active_regions();
-
-	if (last_pfn > MAXMEM>>PAGE_SHIFT)
-		last_pfn = MAXMEM>>PAGE_SHIFT;
-	if (last_pfn > end_user_pfn)
-		last_pfn = end_user_pfn;
-
-	printk(KERN_INFO "last_pfn = %lu\n", last_pfn);
-	return last_pfn;
-}
-
-/*
  * Mark e820 reserved areas as busy for the resource manager.
  */
 void __init e820_reserve_resources(void)
@@ -88,80 +65,6 @@ void __init e820_reserve_resources(void)
 	}
 }
 
-/*
- * Finds an active region in the address range from start_pfn to last_pfn and
- * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
- */
-static int __init e820_find_active_region(const struct e820entry *ei,
-					  unsigned long start_pfn,
-					  unsigned long last_pfn,
-					  unsigned long *ei_startpfn,
-					  unsigned long *ei_endpfn)
-{
-	*ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
-	*ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE) >> PAGE_SHIFT;
-
-	/* Skip map entries smaller than a page */
-	if (*ei_startpfn >= *ei_endpfn)
-		return 0;
-
-	/* Skip if map is outside the node */
-	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
-				    *ei_startpfn >= last_pfn)
-		return 0;
-
-	/* Check for overlaps */
-	if (*ei_startpfn < start_pfn)
-		*ei_startpfn = start_pfn;
-	if (*ei_endpfn > last_pfn)
-		*ei_endpfn = last_pfn;
-
-	/* Obey end_user_pfn to save on memmap */
-	if (*ei_startpfn >= end_user_pfn)
-		return 0;
-	if (*ei_endpfn > end_user_pfn)
-		*ei_endpfn = end_user_pfn;
-
-	return 1;
-}
-
-/* Walk the e820 map and register active regions within a node */
-void __init
-e820_register_active_regions(int nid, unsigned long start_pfn,
-							unsigned long last_pfn)
-{
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++)
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
-}
-
-/*
- * Find the hole size (in bytes) in the memory range.
- * @start: starting address of the memory range to scan
- * @end: ending address of the memory range to scan
- */
-unsigned long __init e820_hole_size(unsigned long start, unsigned long end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-	}
-	return end - start - (ram << PAGE_SHIFT);
-}
-
 static void early_panic(char *msg)
 {
 	early_printk(msg);
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -79,6 +79,8 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
+extern unsigned long end_user_pfn;
+
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
@@ -86,6 +88,15 @@ extern void free_early(u64 start, u64 en
 extern void early_res_to_bootmem(u64 start, u64 end);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
+extern unsigned long e820_end_of_ram(void);
+extern int e820_find_active_region(const struct e820entry *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn);
+extern void e820_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long end_pfn);
+extern u64 e820_hole_size(u64 start, u64 end);
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -16,16 +16,11 @@
 #ifndef __ASSEMBLY__
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
-extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_all_valid(unsigned long start, unsigned long end);
-extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
-
-extern void e820_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long end_pfn);
 
 extern void finish_e820_parsing(void);
 
