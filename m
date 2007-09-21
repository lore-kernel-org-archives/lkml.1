Return-Path: <linux-kernel-owner+w=401wt.eu-S1765901AbXIUWix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765901AbXIUWix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbXIUWc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:57054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763558AbXIUWcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:19 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Message-Id: <20070921223218.22A8D13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Also allow to set svm lock.

TBD double check, documentation, i386 support

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup.c    |   25 +++++++++++++++++++++++--
 include/asm-i386/cpufeature.h |    1 +
 include/asm-i386/msr-index.h  |    3 +++
 3 files changed, 27 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -565,7 +565,7 @@ static void __cpuinit early_init_amd(str
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
-	unsigned level;
+	unsigned level, flags, dummy;
 
 #ifdef CONFIG_SMP
 	unsigned long value;
@@ -634,7 +634,28 @@ static void __cpuinit init_amd(struct cp
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+
+	if (c->x86 >= 0xf && c->x86 <= 0x11 &&
+	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
+	    (flags & 0x18))
+		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);
+}
+
+static int enable_svm_lock(char *s)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
+		unsigned a,b;
+		if (rdmsr_safe(MSR_VM_CR, &a, &b))
+			return 0;
+		a |= (1 << 3);	/* set SVM lock */
+		if (!wrmsr_safe(MSR_VM_CR, &a, &b))
+			return 1;
+	}
+	printk(KERN_ERR "CPU does not support svm_lock\n");
+	return 0;
 }
+__setup("svm_lock", enable_svm_lock);
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
@@ -985,7 +1006,7 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL,
 		"constant_tsc", "up", NULL, "arch_perfmon",
 		"pebs", "bts", NULL, "sync_rdtsc",
-		"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"rep_good", "virtualization_bios_disabled", NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Intel-defined (#2) */
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -82,6 +82,7 @@
 /* 14 free */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
+#define X86_FEATURE_VIRT_DISABLED (3*32+17) /* Hardware virt. BIOS disabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux/include/asm-i386/msr-index.h
===================================================================
--- linux.orig/include/asm-i386/msr-index.h
+++ linux/include/asm-i386/msr-index.h
@@ -98,6 +98,9 @@
 #define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
 #define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
 
+/* SVM */
+#define MSR_VM_CR       0xc0010114
+
 /* K7 MSRs */
 #define MSR_K7_EVNTSEL0			0xc0010000
 #define MSR_K7_PERFCTR0			0xc0010004
