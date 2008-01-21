Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYAUFiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYAUFiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 00:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYAUFim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 00:38:42 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62509 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYAUFil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 00:38:41 -0500
Date: Sun, 20 Jan 2008 21:44:46 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_32: trim memory by updating e820
In-reply-to: <200801202140.57829.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801202144.46869.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801201608.15401.ak@suse.de> <200801202140.57829.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_32: trim memory by updating e820

need to be applied after the patch for x86_64 version mtrr fix e820 v2.

when mtrr is not covering all e820 table, need to trim the ram, need to update e820

reuse some code for x86_64

here need to add early_identify_cpu for x86_32, and move mtrr_bp_init early

compiled only, need someone test it.


Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -396,11 +396,9 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	int i;
 
-	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	c->cpuid_level = -1;	/* CPUID not detected */
@@ -424,7 +422,14 @@ void __cpuinit identify_cpu(struct cpuin
 
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
+}
 
+void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+	early_identify_cpu(c);
 	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
@@ -485,7 +490,6 @@ void __init identify_boot_cpu(void)
 	identify_cpu(&boot_cpu_data);
 	sysenter_setup();
 	enable_sep_cpu();
-	mtrr_bp_init();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -49,6 +49,7 @@
 
 #include <video/edid.h>
 
+#include <asm/mtrr.h>
 #include <asm/apic.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
@@ -747,6 +748,7 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+	early_identify_cpu(&boot_cpu_data);
 	parse_early_param();
 
 	if (user_defined_memmap) {
@@ -762,6 +764,12 @@ void __init setup_arch(char **cmdline_p)
 
 	max_low_pfn = setup_memory();
 
+	/* update e820 for memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	if (mtrr_trim_uncached_memory(max_pfn)) {
+		max_low_pfn = setup_memory();
+	}
+
 #ifdef CONFIG_VMI
 	/*
 	 * Must be after max_low_pfn is determined, and before kernel
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -624,7 +624,6 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
-#ifdef CONFIG_X86_64
 static int disable_mtrr_trim;
 
 static int __init disable_mtrr_trim_setup(char *str)
@@ -726,7 +725,6 @@ int __init mtrr_trim_uncached_memory(uns
 
 	return 0;
 }
-#endif
 
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -575,7 +575,7 @@ and is between 256 and 4096 characters. 
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
-	disable_mtrr_trim [X86-64, Intel only]
+	disable_mtrr_trim [X86, Intel and AMD only]
 			By default the kernel will trim any uncacheable
 			memory out of your available memory pool based on
 			MTRR settings.  This parameter disables that behavior,
Index: linux-2.6/include/asm-x86/processor.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor.h
+++ linux-2.6/include/asm-x86/processor.h
@@ -131,6 +131,7 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_
 
 void cpu_detect(struct cpuinfo_x86 *c);
 
+extern void early_identify_cpu(struct cpuinfo_x86 *);
 extern void identify_cpu(struct cpuinfo_x86 *);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -827,3 +827,14 @@ static int __init parse_memmap(char *arg
 	return 0;
 }
 early_param("memmap", parse_memmap);
+void __init update_e820(void)
+{
+	u8 nr_map;
+
+	nr_map = e820.nr_map;
+	if (sanitize_e820_map(e820.map, &nr_map))
+		return;
+	e820.nr_map = nr_map;
+	printk(KERN_INFO "modified physical RAM map:\n");
+	print_memory_map("modified");
+}
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -19,6 +19,7 @@
 #ifndef __ASSEMBLY__
 
 extern struct e820map e820;
+extern void update_e820(void);
 
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
@@ -29,6 +30,8 @@ extern int is_memory_all_valid(u64 start
 extern int is_memory_all_reserved(u64 start, u64 end);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
+extern void add_memory_region(unsigned long long start,
+			      unsigned long long size, int type);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
