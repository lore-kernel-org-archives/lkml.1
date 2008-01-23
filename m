Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYAWAR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYAWAR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYAWART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:17:19 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42080 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYAWARS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:17:18 -0500
Date: Tue, 22 Jan 2008 16:23:20 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_32: trim memory by updating e820 v3
In-reply-to: <20080122165125.GA17992@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801221623.20861.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
 <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_32: trim memory by updating e820 v3

when mtrr is not covering all e820 table, need to trim the ram, need to update e820

reuse some code for x86_64

here need to add early_get_cap and use it in early_cpu_detect, and move mtrr_bp_init early

need Justine to test with his special system with bug bios.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -278,6 +278,33 @@ void __init cpu_detect(struct cpuinfo_x8
 			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 	}
 }
+static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
+{
+	u32 tfms, xlvl;
+	int ebx;
+
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+	if (have_cpuid_p()) {
+		/* Intel-defined flags: level 0x00000001 */
+		if (c->cpuid_level >= 0x00000001) {
+			u32 capability, excap;
+			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
+			c->x86_capability[0] = capability;
+			c->x86_capability[4] = excap;
+		}
+
+		/* AMD-defined flags: level 0x80000001 */
+		xlvl = cpuid_eax(0x80000000);
+		if ((xlvl & 0xffff0000) == 0x80000000) {
+			if (xlvl >= 0x80000001) {
+				c->x86_capability[1] = cpuid_edx(0x80000001);
+				c->x86_capability[6] = cpuid_ecx(0x80000001);
+			}
+		}
+
+	}
+
+}
 
 /* Do minimum CPU detection early.
    Fields really needed: vendor, cpuid_level, family, model, mask, cache alignment.
@@ -306,6 +333,8 @@ static void __init early_cpu_detect(void
 		early_init_intel(c);
 		break;
 	}
+
+	early_get_cap(c);
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
@@ -485,7 +514,6 @@ void __init identify_boot_cpu(void)
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
@@ -762,6 +763,11 @@ void __init setup_arch(char **cmdline_p)
 
 	max_low_pfn = setup_memory();
 
+	/* update e820 for memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	if (mtrr_trim_uncached_memory(max_pfn))
+		max_low_pfn = setup_memory();
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
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -749,3 +749,14 @@ static int __init parse_memmap(char *arg
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
@@ -19,12 +19,15 @@
 #ifndef __ASSEMBLY__
 
 extern struct e820map e820;
+extern void update_e820(void);
 
 extern int e820_all_mapped(unsigned long start, unsigned long end,
 			   unsigned type);
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
+extern void add_memory_region(unsigned long long start,
+			      unsigned long long size, int type);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
