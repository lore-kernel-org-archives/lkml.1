Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYICGy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYICGy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbYICGxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:53:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52651 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbYICGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jv2jPyAAGht4PjDuvk6XuL0rBx2O0Skk6+0VW8ycyl8lAuZBU2NbZ/spJGlOFOuq/Q
         5iFsHIxFm/srENDWxax3KuCDhyHrLQATRkwJkeMG+n/Ct+TaJ1pO05H/h+bmTIfL3EVO
         4xWzGyksvc0wagw7es/G2clgwCxV2+S/jV7Hc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/5] x86: move 32bit related func together
Date: Tue,  2 Sep 2008 23:53:01 -0700
Message-Id: <1220424781-17752-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 233f1ee..24560fc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,6 +22,8 @@
 
 #include "cpu.h"
 
+static struct cpu_dev *this_cpu __cpuinitdata;
+
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
@@ -58,6 +60,109 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+static int cachesize_override __cpuinitdata = -1;
+static int disable_x86_serial_nr __cpuinitdata = 1;
+
+static int __init cachesize_setup(char *str)
+{
+	get_option(&str, &cachesize_override);
+	return 1;
+}
+__setup("cachesize=", cachesize_setup);
+
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
+
+/* Look up CPU names by table lookup. */
+static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+{
+	struct cpu_model_info *info;
+
+	if (c->x86_model >= 16)
+		return NULL;	/* Range check */
+
+	if (!this_cpu)
+		return NULL;
+
+	info = this_cpu->c_models;
+
+	while (info && info->family) {
+		if (info->family == c->x86)
+			return info->model_names[c->x86_model];
+		info++;
+	}
+	return NULL;		/* Not found */
+}
+
+static int __init x86_fxsr_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_FXSR);
+	setup_clear_cpu_cap(X86_FEATURE_XMM);
+	return 1;
+}
+__setup("nofxsr", x86_fxsr_setup);
+
+static int __init x86_sep_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SEP);
+	return 1;
+}
+__setup("nosep", x86_sep_setup);
+
+/* Standard macro to see if a specific flag is changeable */
+static inline int flag_is_changeable_p(u32 flag)
+{
+	u32 f1, f2;
+
+	asm("pushfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "movl %0,%1\n\t"
+	    "xorl %2,%0\n\t"
+	    "pushl %0\n\t"
+	    "popfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "popfl\n\t"
+	    : "=&r" (f1), "=&r" (f2)
+	    : "ir" (flag));
+
+	return ((f1^f2) & flag) != 0;
+}
+
+/* Probe for the CPUID instruction */
+static int __cpuinit have_cpuid_p(void)
+{
+	return flag_is_changeable_p(X86_EFLAGS_ID);
+}
+
+static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
+		/* Disable processor serial number */
+		unsigned long lo, hi;
+		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		lo |= 0x200000;
+		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		printk(KERN_NOTICE "CPU serial number disabled.\n");
+		clear_cpu_cap(c, X86_FEATURE_PN);
+
+		/* Disabling the serial number may affect the cpuid level */
+		c->cpuid_level = cpuid_eax(0);
+	}
+}
+
+static int __init x86_serial_nr_setup(char *s)
+{
+	disable_x86_serial_nr = 0;
+	return 1;
+}
+__setup("serialnumber", x86_serial_nr_setup);
+
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
@@ -72,9 +177,6 @@ void switch_to_new_gdt(void)
 	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
-static int cachesize_override __cpuinitdata = -1;
-static int disable_x86_serial_nr __cpuinitdata = 1;
-
 static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
@@ -95,14 +197,6 @@ static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_vendor = "Unknown",
 	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata;
-
-static int __init cachesize_setup(char *str)
-{
-	get_option(&str, &cachesize_override);
-	return 1;
-}
-__setup("cachesize=", cachesize_setup);
 
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
@@ -133,7 +227,6 @@ int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	return 1;
 }
 
-
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
@@ -150,7 +243,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
 		return;
 
-	ecx = cpuid_ecx(0x80000006);
+	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
 	l2size = ecx >> 16;
 
 	/* do processor-specific cache resizing */
@@ -167,48 +260,23 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 	c->x86_cache_size = l2size;
 
 	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-	       l2size, ecx & 0xFF);
-}
-
-/*
- * Naming convention should be: <Name> [(<Codename>)]
- * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
- */
-
-/* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
-{
-	struct cpu_model_info *info;
-
-	if (c->x86_model >= 16)
-		return NULL;	/* Range check */
-
-	if (!this_cpu)
-		return NULL;
-
-	info = this_cpu->c_models;
-
-	while (info && info->family) {
-		if (info->family == c->x86)
-			return info->model_names[c->x86_model];
-		info++;
-	}
-	return NULL;		/* Not found */
+			l2size, ecx & 0xFF);
 }
 
 #ifdef CONFIG_X86_HT
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
-	u32 	eax, ebx, ecx, edx;
-	int 	index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
+	u32 eax, ebx, ecx, edx;
+	int index_msb, core_bits;
 
-	if (!cpu_has(c, X86_FEATURE_HT) || cpu_has(c, X86_FEATURE_CMP_LEGACY))
+	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
 
+	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
+		goto out;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
 	if (smp_num_siblings == 1) {
@@ -225,8 +293,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		index_msb = get_count_order(smp_num_siblings);
 		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
 
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -236,10 +302,14 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
 					       ((1 << core_bits) - 1);
+	}
 
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
+out:
+	if ((c->x86_max_cores * smp_num_siblings) > 1) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
 	}
 }
 #endif
@@ -273,52 +343,6 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 	this_cpu = &default_cpu;
 }
 
-
-static int __init x86_fxsr_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_FXSR);
-	setup_clear_cpu_cap(X86_FEATURE_XMM);
-	return 1;
-}
-__setup("nofxsr", x86_fxsr_setup);
-
-
-static int __init x86_sep_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_SEP);
-	return 1;
-}
-__setup("nosep", x86_sep_setup);
-
-
-/* Standard macro to see if a specific flag is changeable */
-static inline int flag_is_changeable_p(u32 flag)
-{
-	u32 f1, f2;
-
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
-
-	return ((f1^f2) & flag) != 0;
-}
-
-
-/* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
-{
-	return flag_is_changeable_p(X86_EFLAGS_ID);
-}
-
 void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
@@ -380,16 +404,16 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
  */
 static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	c->x86_cache_alignment = 32;
 	c->x86_clflush_size = 32;
+	c->x86_cache_alignment = c->x86_clflush_size;
 
 	if (!have_cpuid_p())
 		return;
 
-	c->extended_cpuid_level = 0;
-
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
+	c->extended_cpuid_level = 0;
+
 	cpu_detect(c);
 
 	get_cpu_vendor(c);
@@ -487,31 +511,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 	detect_nopl(c);
 }
 
-static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
-{
-	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
-		/* Disable processor serial number */
-		unsigned long lo, hi;
-		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		lo |= 0x200000;
-		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		printk(KERN_NOTICE "CPU serial number disabled.\n");
-		clear_cpu_cap(c, X86_FEATURE_PN);
-
-		/* Disabling the serial number may affect the cpuid level */
-		c->cpuid_level = cpuid_eax(0);
-	}
-}
-
-static int __init x86_serial_nr_setup(char *s)
-{
-	disable_x86_serial_nr = 0;
-	return 1;
-}
-__setup("serialnumber", x86_serial_nr_setup);
-
-
-
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 55a21bd..e8a406d 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -37,6 +37,8 @@
 
 #include "cpu.h"
 
+static struct cpu_dev *this_cpu __cpuinitdata;
+
 /* We need valid kernel segments for data and code in long mode too
  * IRET will check the segment types  kkeil 2000/10/28
  * Also sysret mandates a special GDT layout
@@ -78,7 +80,6 @@ static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_vendor = "Unknown",
 	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata;
 
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
@@ -112,7 +113,7 @@ int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, ebx, ecx, edx;
+	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
 	n = c->extended_cpuid_level;
 
@@ -125,15 +126,17 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 		c->x86_tlbsize = 0;
 	}
 
-	if (n >= 0x80000006) {
-		cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
-		ecx = cpuid_ecx(0x80000006);
-		c->x86_cache_size = ecx >> 16;
-		c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+	if (n < 0x80000006)	/* Some chips just has a large L1. */
+		return;
 
-		printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-		c->x86_cache_size, ecx & 0xFF);
-	}
+	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
+	l2size = ecx >> 16;
+	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+
+	c->x86_cache_size = l2size;
+
+	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
+			l2size, ecx & 0xFF);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -145,14 +148,13 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
 		return;
 
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
 	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
 		goto out;
 
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
 	if (smp_num_siblings == 1) {
@@ -178,6 +180,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		c->cpu_core_id = phys_pkg_id(index_msb) &
 					       ((1 << core_bits) - 1);
 	}
+
 out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
@@ -185,7 +188,6 @@ out:
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	}
-
 #endif
 }
 
@@ -408,10 +410,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
-	c->x86_clflush_size = 64;
-	c->x86_cache_alignment = c->x86_clflush_size;
 	c->x86_max_cores = 1;
 	c->x86_coreid_bits = 0;
+	c->x86_clflush_size = 64;
+	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
 	generic_identify(c);
