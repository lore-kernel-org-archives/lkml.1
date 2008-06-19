Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYFSW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYFSW3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYFSW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:29:33 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:6459 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYFSW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HLE05NAaMrUE/jLCTr5dOGM4cuTwIIoW03al+v18i1rmJmaerjocnnTqJVRpVXu0is
         in7BnRBCMx8RYATePQu9lV/5bdQMfq5rzbQ5SASejAXK/f9zG1zHDjPlhISQ0jpuvjpG
         foFip0cbL558XNkPhtokiG4OHYa/bMIxQeEFY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: [PATCH] x86: make 64bit identify_cpu use cpu_dev v2
Date: Thu, 19 Jun 2008 15:30:31 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com>
In-Reply-To: <200806180215.53755.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806191530.32354.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: fix early_panic on some conf
    reason : struct cpu_vendor_dev size is 16, need to make table to be 16
             byte alignment
    also print out the cpu supported...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd_64.c     |   17 ++++-
 arch/x86/kernel/cpu/centaur_64.c |   16 ++++-
 arch/x86/kernel/cpu/cpu.h        |    6 +-
 arch/x86/kernel/cpu/intel_64.c   |   15 ++++-
 arch/x86/kernel/setup_64.c       |  114 +++++++++++++++++++++++----------------
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 6 files changed, 115 insertions(+), 54 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -7,8 +7,7 @@
 
 #include <mach_apic.h>
 
-extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
-extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
+#include "cpu.h"
 
 int force_mwait __cpuinitdata;
 
@@ -109,7 +108,7 @@ static void __cpuinit early_init_amd_mc(
 #endif
 }
 
-void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
@@ -118,7 +117,7 @@ void __cpuinit early_init_amd(struct cpu
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
-void __cpuinit init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
 
@@ -200,3 +199,13 @@ void __cpuinit init_amd(struct cpuinfo_x
 			set_memory_4k((unsigned long)__va(tseg), 1);
 	}
 }
+
+static struct cpu_dev amd_cpu_dev __cpuinitdata = {
+	.c_vendor	= "AMD",
+	.c_ident	= { "AuthenticAMD" },
+	.c_early_init   = early_init_amd,
+	.c_init		= init_amd,
+};
+
+cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
+
Index: linux-2.6/arch/x86/kernel/cpu/centaur_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur_64.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur_64.c
@@ -4,13 +4,15 @@
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
 
-void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+#include "cpu.h"
+
+static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 {
 	if (c->x86 == 0x6 && c->x86_model >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
-void __cpuinit init_centaur(struct cpuinfo_x86 *c)
+static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
 	unsigned n;
@@ -29,3 +31,13 @@ void __cpuinit init_centaur(struct cpuin
 	}
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 }
+
+static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+	.c_vendor	= "Centaur",
+	.c_ident	= { "CentaurHauls" },
+	.c_early_init	= early_init_centaur,
+	.c_init		= init_centaur,
+};
+
+cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+
Index: linux-2.6/arch/x86/kernel/cpu/cpu.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpu.h
+++ linux-2.6/arch/x86/kernel/cpu/cpu.h
@@ -1,4 +1,6 @@
-#ifdef CONFIG_X86_32
+#ifndef ARCH_X86_CPU_H
+
+#define ARCH_X86_CPU_H
 
 struct cpu_model_info {
 	int vendor;
@@ -38,4 +40,4 @@ extern struct cpu_vendor_dev __x86cpuven
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
-#endif /* CONFIG_X86_32 */
+#endif
Index: linux-2.6/arch/x86/kernel/cpu/intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_64.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_64.c
@@ -5,7 +5,9 @@
 #include <asm/topology.h>
 #include <asm/numa_64.h>
 
-void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+#include "cpu.h"
+
+static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
@@ -48,7 +50,7 @@ static void __cpuinit srat_detect_node(v
 #endif
 }
 
-void __cpuinit init_intel(struct cpuinfo_x86 *c)
+static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
 	unsigned n;
@@ -90,3 +92,12 @@ void __cpuinit init_intel(struct cpuinfo
 
 	srat_detect_node();
 }
+
+static struct cpu_dev intel_cpu_dev __cpuinitdata = {
+	.c_vendor	= "Intel",
+	.c_ident	= { "GenuineIntel" },
+	.c_early_init   = early_init_intel,
+	.c_init		= init_intel,
+};
+cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
+
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -81,6 +81,8 @@
 #define ARCH_SETUP
 #endif
 
+#include "cpu/cpu.h"
+
 /* We need valid kernel segments for data and code in long mode too
  * IRET will check the segment types  kkeil 2000/10/28
  * Also sysret mandates a special GDT layout
@@ -180,6 +182,7 @@ static struct resource bss_resource = {
 	.flags = IORESOURCE_RAM,
 };
 
+static void __init early_cpu_init(void);
 static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
 
 #ifdef CONFIG_PROC_VMCORE
@@ -341,6 +344,7 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+	early_cpu_init();
 	early_identify_cpu(&boot_cpu_data);
 
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
@@ -527,6 +531,19 @@ void __init setup_arch(char **cmdline_p)
 	check_enable_amd_mmconf_dmi();
 }
 
+struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+
+static void __cpuinit default_init(struct cpuinfo_x86 *c)
+{
+	display_cacheinfo(c);
+}
+
+static struct cpu_dev __cpuinitdata default_cpu = {
+	.c_init	= default_init,
+	.c_vendor = "Unknown",
+};
+static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
+
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
@@ -628,24 +645,57 @@ out:
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
+	int i;
+	static int printed;
 
-	if (!strcmp(v, "AuthenticAMD"))
-		c->x86_vendor = X86_VENDOR_AMD;
-	else if (!strcmp(v, "GenuineIntel"))
-		c->x86_vendor = X86_VENDOR_INTEL;
-	else if (!strcmp(v, "CentaurHauls"))
-		c->x86_vendor = X86_VENDOR_CENTAUR;
-	else
-		c->x86_vendor = X86_VENDOR_UNKNOWN;
+	for (i = 0; i < X86_VENDOR_NUM; i++) {
+		if (cpu_devs[i]) {
+			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+			    (cpu_devs[i]->c_ident[1] &&
+			    !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+				c->x86_vendor = i;
+				this_cpu = cpu_devs[i];
+				return;
+			}
+		}
+	}
+	if (!printed) {
+		printed++;
+		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
+		printk(KERN_ERR "CPU: Your system may be unstable.\n");
+	}
+	c->x86_vendor = X86_VENDOR_UNKNOWN;
 }
 
-// FIXME: Needs to use cpu_vendor_dev_register
-extern void __cpuinit early_init_amd(struct cpuinfo_x86 *c);
-extern void __cpuinit init_amd(struct cpuinfo_x86 *c);
-extern void __cpuinit early_init_intel(struct cpuinfo_x86 *c);
-extern void __cpuinit init_intel(struct cpuinfo_x86 *c);
-extern void __cpuinit early_init_centaur(struct cpuinfo_x86 *c);
-extern void __cpuinit init_centaur(struct cpuinfo_x86 *c);
+static void __init early_cpu_support_print(void)
+{
+	int i,j;
+	struct cpu_dev *cpu_devx;
+
+	printk("KERNEL supported cpus:\n");
+	for (i = 0; i < X86_VENDOR_NUM; i++) {
+		cpu_devx = cpu_devs[i];
+		if (!cpu_devx)
+			continue;
+		for (j = 0; j < 2; j++) {
+			if (!cpu_devx->c_ident[j])
+				continue;
+			printk("  %s %s\n", cpu_devx->c_vendor,
+				cpu_devx->c_ident[j]);
+		}
+	}
+}
+
+static void __init early_cpu_init(void)
+{
+        struct cpu_vendor_dev *cvdev;
+
+        for (cvdev = __x86cpuvendor_start ;
+             cvdev < __x86cpuvendor_end   ;
+             cvdev++)
+                cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+	early_cpu_support_print();
+}
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
    needed before check_bugs. Everything advanced is in identify_cpu
@@ -725,17 +775,9 @@ static void __cpuinit early_identify_cpu
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		early_init_amd(c);
-		break;
-	case X86_VENDOR_INTEL:
-		early_init_intel(c);
-		break;
-	case X86_VENDOR_CENTAUR:
-		early_init_centaur(c);
-		break;
-	}
+	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
+	    cpu_devs[c->x86_vendor]->c_early_init)
+		cpu_devs[c->x86_vendor]->c_early_init(c);
 
 	validate_pat_support(c);
 }
@@ -763,24 +805,8 @@ void __cpuinit identify_cpu(struct cpuin
 	 * At the end of this section, c->x86_capability better
 	 * indicate the features this CPU genuinely supports!
 	 */
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		init_amd(c);
-		break;
-
-	case X86_VENDOR_INTEL:
-		init_intel(c);
-		break;
-
-	case X86_VENDOR_CENTAUR:
-		init_centaur(c);
-		break;
-
-	case X86_VENDOR_UNKNOWN:
-	default:
-		display_cacheinfo(c);
-		break;
-	}
+	if (this_cpu->c_init)
+		this_cpu->c_init(c);
 
 	detect_ht(c);
 
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -168,6 +168,7 @@ SECTIONS
 	*(.con_initcall.init)
   }
   __con_initcall_end = .;
+  . = ALIGN(16);
   __x86cpuvendor_start = .;
   .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
 	*(.x86cpuvendor.init)
