Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZI0HQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZI0HQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZI0HQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:16:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:41132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZI0HQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:16:11 -0400
Message-ID: <4ABF1123.5030703@kernel.org>
Date: Sun, 27 Sep 2009 00:15:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: print out microcode patch level
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


warning if there are not consistent between cpus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/amd.c   |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c |   27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -439,6 +439,31 @@ static void __cpuinit early_init_amd(str
 #endif
 }
 
+static u32 __cpuinitdata boot_cpu_microcode_level;
+
+static void __cpuinit check_amd_microcode_level(struct cpuinfo_x86 *c)
+{
+	u32 level, dummy;
+	unsigned int cpu_index = 0;
+
+#ifdef CONFIG_SMP
+	cpu_index = c->cpu_index;
+#endif
+
+	rdmsr(MSR_AMD64_PATCH_LEVEL, level, dummy);
+
+	printk(KERN_INFO "CPU %d microcode level: 0x%x\n", cpu_index, level);
+
+#ifdef CONFIG_SMP
+	if (cpu_index == boot_cpu_id)
+		boot_cpu_microcode_level = level;
+	else if (boot_cpu_microcode_level != level)
+		printk(KERN_WARNING
+		       "CPU %d microcode level 0x%x is not same to boot cpu\n",
+			cpu_index, level);
+#endif
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -562,6 +587,8 @@ static void __cpuinit init_amd(struct cp
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
+	check_amd_microcode_level(c);
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -327,6 +327,31 @@ static void __cpuinit detect_vmx_virtcap
 	}
 }
 
+static u32 __cpuinitdata boot_cpu_microcode_level;
+
+static void __cpuinit check_intel_microcode_level(struct cpuinfo_x86 *c)
+{
+	u32 level, dummy;
+	unsigned int cpu_index = 0;
+
+#ifdef CONFIG_SMP
+	cpu_index = c->cpu_index;
+#endif
+
+	rdmsr(MSR_IA32_UCODE_REV, dummy, level);
+
+	printk(KERN_INFO "CPU %d microcode level: 0x%x\n", cpu_index, level);
+
+#ifdef CONFIG_SMP
+	if (cpu_index == boot_cpu_id)
+		boot_cpu_microcode_level = level;
+	else if (boot_cpu_microcode_level != level)
+		printk(KERN_WARNING
+		       "CPU %d microcode level 0x%x is not same to boot cpu\n",
+			cpu_index, level);
+#endif
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
@@ -432,6 +457,8 @@ static void __cpuinit init_intel(struct
 	/* Work around errata */
 	srat_detect_node(c);
 
+	check_intel_microcode_level(c);
+
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
 }
