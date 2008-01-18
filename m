Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYARR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYARR1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYARR1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:53243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760553AbYARR1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/7] Add frame work to disable CPUID bits on the command line
Message-Id: <20080118172717.51E3214AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are already various options to disable specific cpuid bits
on the command line. They all use their own variable. Add a generic
mask to make this easier in the future.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/common.c |    6 ++++++
 arch/x86/kernel/setup_64.c   |    6 ++++++
 include/asm-x86/cpufeature.h |    4 ++++
 include/asm-x86/processor.h  |    1 +
 4 files changed, 17 insertions(+)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -57,6 +57,8 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_fxsr __cpuinitdata;
 static int disable_x86_serial_nr __cpuinitdata = 1;
@@ -497,6 +499,10 @@ void __cpuinit identify_cpu(struct cpuin
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
+	/* Clear all flags overriden by options */
+	for (i = 0; i < NCAPINTS; i++)
+		c->x86_capability[i] ^= cleared_cpu_caps[i];
+
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
 
Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -132,6 +132,10 @@
 
 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
 #define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
+#define setup_clear_cpu_cap(bit) do { \
+	clear_cpu_cap(&boot_cpu_data, bit);	\
+	set_bit(bit, cleared_cpu_caps); 	\
+} while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
Index: linux/include/asm-x86/processor.h
===================================================================
--- linux.orig/include/asm-x86/processor.h
+++ linux/include/asm-x86/processor.h
@@ -118,6 +118,7 @@ struct cpuinfo_x86 {
 extern struct cpuinfo_x86 boot_cpu_data;
 extern struct cpuinfo_x86 new_cpu_data;
 extern struct tss_struct doublefault_tss;
+extern __u32 cleared_cpu_caps[NCAPINTS];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -82,6 +82,8 @@
 struct cpuinfo_x86 boot_cpu_data __read_mostly;
 EXPORT_SYMBOL(boot_cpu_data);
 
+__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+
 unsigned long mmu_cr4_features;
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
@@ -1012,6 +1014,10 @@ void __cpuinit identify_cpu(struct cpuin
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
+	/* Clear all flags overriden by options */
+	for (i = 0; i < NCAPINTS; i++)
+		c->x86_capability[i] ^= cleared_cpu_caps[i];
+
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
 #endif
