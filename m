Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0CHJiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:38:12 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54208 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0CHJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:37:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 08 Mar 2010 01:36:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/4] x86: add get_centaur_ram_top
In-reply-to: <1268040992-13807-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1268040992-13807-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1268040992-13807-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we can avoid to access e820.map[] directly.

later we could move e820 to static and _initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>



---
 arch/x86/include/asm/e820.h   |    9 ++++++
 arch/x86/kernel/cpu/centaur.c |   53 +--------------------------------------
 arch/x86/kernel/e820.c        |   57 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c       |    2 +
 4 files changed, 70 insertions(+), 51 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1194,3 +1194,60 @@ void __init setup_memory_map(void)
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
+
+#ifdef CONFIG_X86_OOSTORE
+/*
+ * Figure what we can cover with MCR's
+ *
+ * Shortcut: We know you can't put 4Gig of RAM on a winchip
+ */
+void __init get_centaur_ram_top(void)
+{
+	u32 clip = 0xFFFFFFFFUL;
+	u32 top = 0;
+	int i;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+		return;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		unsigned long start, end;
+
+		if (e820.map[i].addr > 0xFFFFFFFFUL)
+			continue;
+		/*
+		 * Don't MCR over reserved space. Ignore the ISA hole
+		 * we frob around that catastrophe already
+		 */
+		if (e820.map[i].type == E820_RESERVED) {
+			if (e820.map[i].addr >= 0x100000UL &&
+			    e820.map[i].addr < clip)
+				clip = e820.map[i].addr;
+			continue;
+		}
+		start = e820.map[i].addr;
+		end = e820.map[i].addr + e820.map[i].size;
+		if (start >= end)
+			continue;
+		if (end > top)
+			top = end;
+	}
+	/*
+	 * Everything below 'top' should be RAM except for the ISA hole.
+	 * Because of the limited MCR's we want to map NV/ACPI into our
+	 * MCR range for gunk in RAM
+	 *
+	 * Clip might cause us to MCR insufficient RAM but that is an
+	 * acceptable failure mode and should only bite obscure boxes with
+	 * a VESA hole at 15Mb
+	 *
+	 * The second case Clip sometimes kicks in is when the EBDA is marked
+	 * as reserved. Again we fail safe with reasonable results
+	 */
+	if (top > clip)
+		top = clip;
+
+	centaur_ram_top = top;
+}
+#endif
+
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -875,6 +875,8 @@ void __init setup_arch(char **cmdline_p)
 	if (mtrr_trim_uncached_memory(max_pfn))
 		max_pfn = e820_end_of_ram_pfn();
 
+	get_centaur_ram_top();
+
 #ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
Index: linux-2.6/arch/x86/kernel/cpu/centaur.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur.c
@@ -37,63 +37,14 @@ static void __cpuinit centaur_mcr_insert
 	mtrr_centaur_report_mcr(reg, lo, hi);	/* Tell the mtrr driver */
 }
 
-/*
- * Figure what we can cover with MCR's
- *
- * Shortcut: We know you can't put 4Gig of RAM on a winchip
- */
-static u32 __cpuinit ramtop(void)
-{
-	u32 clip = 0xFFFFFFFFUL;
-	u32 top = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		unsigned long start, end;
-
-		if (e820.map[i].addr > 0xFFFFFFFFUL)
-			continue;
-		/*
-		 * Don't MCR over reserved space. Ignore the ISA hole
-		 * we frob around that catastrophe already
-		 */
-		if (e820.map[i].type == E820_RESERVED) {
-			if (e820.map[i].addr >= 0x100000UL &&
-			    e820.map[i].addr < clip)
-				clip = e820.map[i].addr;
-			continue;
-		}
-		start = e820.map[i].addr;
-		end = e820.map[i].addr + e820.map[i].size;
-		if (start >= end)
-			continue;
-		if (end > top)
-			top = end;
-	}
-	/*
-	 * Everything below 'top' should be RAM except for the ISA hole.
-	 * Because of the limited MCR's we want to map NV/ACPI into our
-	 * MCR range for gunk in RAM
-	 *
-	 * Clip might cause us to MCR insufficient RAM but that is an
-	 * acceptable failure mode and should only bite obscure boxes with
-	 * a VESA hole at 15Mb
-	 *
-	 * The second case Clip sometimes kicks in is when the EBDA is marked
-	 * as reserved. Again we fail safe with reasonable results
-	 */
-	if (top > clip)
-		top = clip;
-
-	return top;
-}
+int __cpuinitdata centaur_ram_top;
 
 /*
  * Compute a set of MCR's to give maximum coverage
  */
 static int __cpuinit centaur_mcr_compute(int nr, int key)
 {
-	u32 mem = ramtop();
+	u32 mem = centaur_ram_top;
 	u32 root = power2(mem);
 	u32 base = root;
 	u32 top = root;
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -72,6 +72,15 @@ struct e820map {
 extern struct e820map e820;
 extern struct e820map e820_saved;
 
+#ifdef CONFIG_X86_OOSTORE
+extern int centaur_ram_top;
+void get_centaur_ram_top(void);
+#else
+static inline void get_centaur_ram_top(void)
+{
+}
+#endif
+
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
