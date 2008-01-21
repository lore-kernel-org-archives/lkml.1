Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYAUGv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYAUGv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYAUGvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:51:36 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63077 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYAUGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:51:34 -0500
Date: Sun, 20 Jan 2008 22:57:20 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: update e820 instead of updating end_pfn v3
In-reply-to: <200801202255.02645.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801202257.21327.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801210658.04030.ak@suse.de> <200801202255.02645.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: update e820 instead of updating end_pfn v3

need to apply after x86_64 check if Tom2 is enabled

when mtrr is not covering all e820 table, need to trim the ram, need to update e820

so we can reuse some code for x86_32.

after we add early_identify_cpu for x86_32, and move mtrr_bp_init early for x86_32

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -624,6 +624,7 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
+#ifdef CONFIG_X86_64
 static int disable_mtrr_trim;
 
 static int __init disable_mtrr_trim_setup(char *str)
@@ -633,8 +634,6 @@ static int __init disable_mtrr_trim_setu
 }
 early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
 
-#ifdef CONFIG_X86_64
-
 /*
  * Newer AMD K8s and later CPUs have a special magic MSR way to force WB
  * for memory >4GB. Check for that here.
@@ -644,7 +643,7 @@ early_param("disable_mtrr_trim", disable
 #define Tom2Enabled (1U << 21)
 #define Tom2ForceMemTypeWB (1U << 22)
 
-static __init int amd_special_default_mtrr(void)
+static __init int amd_special_default_mtrr(unsigned long end_pfn)
 {
 	u32 l, h;
 
@@ -678,10 +677,11 @@ static __init int amd_special_default_mt
  * memory off the end by adjusting end_pfn, removing it from the kernel's
  * allocation pools, warning the user with an obnoxious message.
  */
-void __init mtrr_trim_uncached_memory(void)
+int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
 	unsigned long i, base, size, highest_addr = 0, def, dummy;
 	mtrr_type type;
+	u64 trim_start, trim_size;
 
 	/*
 	 * Make sure we only trim uncachable memory on machines that
@@ -690,7 +690,7 @@ void __init mtrr_trim_uncached_memory(vo
 	rdmsr(MTRRdefType_MSR, def, dummy);
 	def &= 0xff;
 	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
-		return;
+		return 0;
 
 	/* Find highest cached pfn */
 	for (i = 0; i < num_var_ranges; i++) {
@@ -703,8 +703,8 @@ void __init mtrr_trim_uncached_memory(vo
 			highest_addr = base + size;
 	}
 
-	if (amd_special_default_mtrr())
-		return;
+	if (amd_special_default_mtrr(end_pfn))
+		return 0;
 
 	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
 		printk(KERN_WARNING "***************\n");
@@ -713,8 +713,18 @@ void __init mtrr_trim_uncached_memory(vo
 		       "memory, trimmed %ld pages\n", end_pfn -
 		       (highest_addr >> PAGE_SHIFT));
 		printk(KERN_WARNING "***************\n");
-		end_pfn = highest_addr >> PAGE_SHIFT;
+
+		printk(KERN_INFO "update e820 for mtrr\n");
+		trim_start = highest_addr;
+		trim_size = end_pfn;
+		trim_size <<= PAGE_SHIFT;
+		trim_size -= trim_start;
+		add_memory_region(trim_start, trim_size, E820_RESERVED);
+		update_e820();
+		return 1;
 	}
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -324,9 +324,12 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
-	/* Trim memory not covered by WB MTRRs */
+	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
-	mtrr_trim_uncached_memory();
+	if (mtrr_trim_uncached_memory(end_pfn)) {
+		e820_register_active_regions(0, 0, -1UL);
+		end_pfn = e820_end_of_ram();
+	}
 
 	num_physpages = end_pfn;
 
Index: linux-2.6/include/asm-x86/mtrr.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mtrr.h
+++ linux-2.6/include/asm-x86/mtrr.h
@@ -97,7 +97,7 @@ extern int mtrr_del_page (int reg, unsig
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
-extern void mtrr_trim_uncached_memory(void);
+extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
@@ -121,8 +121,9 @@ static __inline__ int mtrr_del_page (int
 {
     return -ENODEV;
 }
-static __inline__ void mtrr_trim_uncached_memory(void)
+static __inline__ int mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
+	return 0;
 }
 static __inline__ void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi) {;}
 
