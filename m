Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZCNI4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZCNI4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZCNIzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:55:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:50475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZCNIzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:55:17 -0400
Date: Sat, 14 Mar 2009 08:54:42 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237009789.4387.2.camel@localhost.localdomain>
References: <1237009789.4387.2.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: cpu/common.c more cleanups
Message-ID: <tip-0f3fa48a7eaf5d1118cfda1650e8c759b2a116e4@git.kernel.org>
Git-Commit-ID: 0f3fa48a7eaf5d1118cfda1650e8c759b2a116e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 08:54:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f3fa48a7eaf5d1118cfda1650e8c759b2a116e4
Gitweb:     http://git.kernel.org/tip/0f3fa48a7eaf5d1118cfda1650e8c759b2a116e4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 14 Mar 2009 08:46:17 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 10:37:34 +0100

x86: cpu/common.c more cleanups

Complete/fix the cleanups of cpu/common.c:

 - fix ugly warning due to asm/topology.h -> linux/topology.h change
 - standardize the style across the file
 - simplify/refactor the code flow where possible

Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
LKML-Reference: <1237009789.4387.2.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/common.c |  243 +++++++++++++++++++++++++-----------------
 1 files changed, 143 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cad6878..a9e3791 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,4 +1,3 @@
-#include <linux/topology.h>
 #include <linux/bootmem.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
@@ -18,6 +17,7 @@
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
+#include <asm/topology.h>
 #include <asm/cpumask.h>
 #include <asm/pgtable.h>
 #include <asm/atomic.h>
@@ -82,45 +82,45 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	 * TLS descriptors are currently at a different place compared to i386.
 	 * Hopefully nobody expects them at a fixed place (Wine?)
 	 */
-	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
-	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
-	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
-	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+	[GDT_ENTRY_KERNEL32_CS]		= { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS]	= { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00affb00 } } },
 #else
-	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
-	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff200 } } },
+	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00cf9a00 } } },
+	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00cffa00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff200 } } },
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
 	 * They code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_PNPBIOS_CS32] = { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS32]	= { { { 0x0000ffff, 0x00409a00 } } },
 	/* 16-bit code */
-	[GDT_ENTRY_PNPBIOS_CS16] = { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS16]	= { { { 0x0000ffff, 0x00009a00 } } },
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_DS] = { { { 0x0000ffff, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_DS]		= { { { 0x0000ffff, 0x00009200 } } },
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS1] = { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS1]		= { { { 0x00000000, 0x00009200 } } },
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS2] = { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS2]		= { { { 0x00000000, 0x00009200 } } },
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_APMBIOS_BASE] = { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE]	= { { { 0x0000ffff, 0x00409a00 } } },
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1] = { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE+1]	= { { { 0x0000ffff, 0x00009a00 } } },
 	/* data */
-	[GDT_ENTRY_APMBIOS_BASE+2] = { { { 0x0000ffff, 0x00409200 } } },
+	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
 
-	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
-	[GDT_ENTRY_PERCPU] = { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	GDT_STACK_CANARY_INIT
 #endif
 } };
@@ -164,16 +164,17 @@ static inline int flag_is_changeable_p(u32 flag)
 	 * the CPUID. Add "volatile" to not allow gcc to
 	 * optimize the subsequent calls to this function.
 	 */
-	asm volatile ("pushfl\n\t"
-		      "pushfl\n\t"
-		      "popl %0\n\t"
-		      "movl %0,%1\n\t"
-		      "xorl %2,%0\n\t"
-		      "pushl %0\n\t"
-		      "popfl\n\t"
-		      "pushfl\n\t"
-		      "popl %0\n\t"
-		      "popfl\n\t"
+	asm volatile ("pushfl		\n\t"
+		      "pushfl		\n\t"
+		      "popl %0		\n\t"
+		      "movl %0, %1	\n\t"
+		      "xorl %2, %0	\n\t"
+		      "pushl %0		\n\t"
+		      "popfl		\n\t"
+		      "pushfl		\n\t"
+		      "popl %0		\n\t"
+		      "popfl		\n\t"
+
 		      : "=&r" (f1), "=&r" (f2)
 		      : "ir" (flag));
 
@@ -188,18 +189,22 @@ static int __cpuinit have_cpuid_p(void)
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
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
+	unsigned long lo, hi;
+
+	if (!cpu_has(c, X86_FEATURE_PN) || !disable_x86_serial_nr)
+		return;
+
+	/* Disable processor serial number: */
+
+	rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+	lo |= 0x200000;
+	wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+
+	printk(KERN_NOTICE "CPU serial number disabled.\n");
+	clear_cpu_cap(c, X86_FEATURE_PN);
+
+	/* Disabling the serial number may affect the cpuid level */
+	c->cpuid_level = cpuid_eax(0);
 }
 
 static int __init x86_serial_nr_setup(char *s)
@@ -232,6 +237,7 @@ struct cpuid_dependent_feature {
 	u32 feature;
 	u32 level;
 };
+
 static const struct cpuid_dependent_feature __cpuinitconst
 cpuid_dependent_features[] = {
 	{ X86_FEATURE_MWAIT,		0x00000005 },
@@ -245,6 +251,9 @@ static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 	const struct cpuid_dependent_feature *df;
 
 	for (df = cpuid_dependent_features; df->feature; df++) {
+
+		if (!cpu_has(c, df->feature))
+			continue;
 		/*
 		 * Note: cpuid_level is set to -1 if unavailable, but
 		 * extended_extended_level is set to 0 if unavailable
@@ -252,26 +261,26 @@ static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 		 * when signed; hence the weird messing around with
 		 * signs here...
 		 */
-		if (cpu_has(c, df->feature) &&
-		    ((s32)df->level < 0 ?
+		if (!((s32)df->level < 0 ?
 		     (u32)df->level > (u32)c->extended_cpuid_level :
-		     (s32)df->level > (s32)c->cpuid_level)) {
-			clear_cpu_cap(c, df->feature);
-			if (warn)
-				printk(KERN_WARNING
-				       "CPU: CPU feature %s disabled "
-				       "due to lack of CPUID level 0x%x\n",
-				       x86_cap_flags[df->feature],
-				       df->level);
-		}
+		     (s32)df->level > (s32)c->cpuid_level))
+			continue;
+
+		clear_cpu_cap(c, df->feature);
+		if (!warn)
+			continue;
+
+		printk(KERN_WARNING
+		       "CPU: CPU feature %s disabled, no CPUID level 0x%x\n",
+				x86_cap_flags[df->feature], df->level);
 	}
 }
 
 /*
  * Naming convention should be: <Name> [(<Codename>)]
  * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
+ * in particular, if CPUID levels 0x80000002..4 are supported, this
+ * isn't used
  */
 
 /* Look up CPU names by table lookup. */
@@ -308,8 +317,10 @@ void load_percpu_segment(int cpu)
 	load_stack_canary_segment();
 }
 
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
+/*
+ * Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one.
+ */
 void switch_to_new_gdt(int cpu)
 {
 	struct desc_ptr gdt_descr;
@@ -355,14 +366,16 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level < 0x80000004)
 		return;
 
-	v = (unsigned int *) c->x86_model_id;
+	v = (unsigned int *)c->x86_model_id;
 	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
 
-	/* Intel chips right-justify this string for some dumb reason;
-	   undo that brain damage */
+	/*
+	 * Intel chips right-justify this string for some dumb reason;
+	 * undo that brain damage:
+	 */
 	p = q = &c->x86_model_id[0];
 	while (*p == ' ')
 		p++;
@@ -439,28 +452,30 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 	if (smp_num_siblings == 1) {
 		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
+		goto out;
+	}
 
-		if (smp_num_siblings > nr_cpu_ids) {
-			pr_warning("CPU: Unsupported number of siblings %d",
-				   smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
-		}
+	if (smp_num_siblings <= 1)
+		goto out;
 
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
-						    index_msb);
+	if (smp_num_siblings > nr_cpu_ids) {
+		pr_warning("CPU: Unsupported number of siblings %d",
+			   smp_num_siblings);
+		smp_num_siblings = 1;
+		return;
+	}
 
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
+	index_msb = get_count_order(smp_num_siblings);
+	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
-		index_msb = get_count_order(smp_num_siblings);
+	smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
-		core_bits = get_count_order(c->x86_max_cores);
+	index_msb = get_count_order(smp_num_siblings);
 
-		c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, index_msb) &
-					       ((1 << core_bits) - 1);
-	}
+	core_bits = get_count_order(c->x86_max_cores);
+
+	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, index_msb) &
+				       ((1 << core_bits) - 1);
 
 out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
@@ -475,8 +490,8 @@ out:
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
-	int i;
 	static int printed;
+	int i;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
 		if (!cpu_devs[i])
@@ -485,6 +500,7 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 		if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
 		    (cpu_devs[i]->c_ident[1] &&
 		     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+
 			this_cpu = cpu_devs[i];
 			c->x86_vendor = this_cpu->c_x86_vendor;
 			return;
@@ -493,8 +509,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 
 	if (!printed) {
 		printed++;
-		printk(KERN_ERR "CPU: vendor_id '%s'"
-			"unknown, using generic init.\n", v);
+		printk(KERN_ERR
+		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
+
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
 
@@ -514,14 +531,17 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 junk, tfms, cap0, misc;
+
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
 		c->x86 = (tfms >> 8) & 0xf;
 		c->x86_model = (tfms >> 4) & 0xf;
 		c->x86_mask = tfms & 0xf;
+
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
 			c->x86_model += ((tfms >> 16) & 0xf) << 4;
+
 		if (cap0 & (1<<19)) {
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
 			c->x86_cache_alignment = c->x86_clflush_size;
@@ -537,6 +557,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 capability, excap;
+
 		cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
 		c->x86_capability[0] = capability;
 		c->x86_capability[4] = excap;
@@ -545,6 +566,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
+
 	if ((xlvl & 0xffff0000) == 0x80000000) {
 		if (xlvl >= 0x80000001) {
 			c->x86_capability[1] = cpuid_edx(0x80000001);
@@ -762,8 +784,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	squash_the_stupid_serial_number(c);
 
 	/*
-	 * The vendor-specific functions might have changed features.  Now
-	 * we do "generic changes."
+	 * The vendor-specific functions might have changed features.
+	 * Now we do "generic changes."
 	 */
 
 	/* Filter out anything that depends on CPUID levels we don't have */
@@ -846,8 +868,8 @@ void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 }
 
 struct msr_range {
-	unsigned min;
-	unsigned max;
+	unsigned	min;
+	unsigned	max;
 };
 
 static struct msr_range msr_range_array[] __cpuinitdata = {
@@ -859,14 +881,15 @@ static struct msr_range msr_range_array[] __cpuinitdata = {
 
 static void __cpuinit print_cpu_msr(void)
 {
+	unsigned index_min, index_max;
 	unsigned index;
 	u64 val;
 	int i;
-	unsigned index_min, index_max;
 
 	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
 		index_min = msr_range_array[i].min;
 		index_max = msr_range_array[i].max;
+
 		for (index = index_min; index < index_max; index++) {
 			if (rdmsrl_amd_safe(index, &val))
 				continue;
@@ -876,6 +899,7 @@ static void __cpuinit print_cpu_msr(void)
 }
 
 static int show_msr __cpuinitdata;
+
 static __init int setup_show_msr(char *arg)
 {
 	int num;
@@ -899,10 +923,12 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	char *vendor = NULL;
 
-	if (c->x86_vendor < X86_VENDOR_NUM)
+	if (c->x86_vendor < X86_VENDOR_NUM) {
 		vendor = this_cpu->c_vendor;
-	else if (c->cpuid_level >= 0)
-		vendor = c->x86_vendor_id;
+	} else {
+		if (c->cpuid_level >= 0)
+			vendor = c->x86_vendor_id;
+	}
 
 	if (vendor && !strstr(c->x86_model_id, vendor))
 		printk(KERN_CONT "%s ", vendor);
@@ -929,10 +955,12 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 static __init int setup_disablecpuid(char *arg)
 {
 	int bit;
+
 	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
 		setup_clear_cpu_cap(bit);
 	else
 		return 0;
+
 	return 1;
 }
 __setup("clearcpuid=", setup_disablecpuid);
@@ -942,6 +970,7 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
+
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
@@ -951,6 +980,17 @@ EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
+/*
+ * Special IST stacks which the CPU switches to when it calls
+ * an IST-marked descriptor entry. Up to 7 stacks (hardware
+ * limit), all of them are 4K, except the debug stack which
+ * is 8K.
+ */
+static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
+	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
+	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
+};
+
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
 	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
 	__aligned(PAGE_SIZE);
@@ -984,7 +1024,7 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
-#else	/* x86_64 */
+#else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 DEFINE_PER_CPU(unsigned long, stack_canary);
@@ -996,9 +1036,10 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->fs = __KERNEL_PERCPU;
 	regs->gs = __KERNEL_STACK_CANARY;
+
 	return regs;
 }
-#endif	/* x86_64 */
+#endif	/* CONFIG_X86_64 */
 
 /*
  * Clear all 6 debug registers:
@@ -1024,15 +1065,20 @@ static void clear_all_debug_regs(void)
  * A lot of state is already set up in PDA init for 64 bit
  */
 #ifdef CONFIG_X86_64
+
 void __cpuinit cpu_init(void)
 {
-	int cpu = stack_smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
-	unsigned long v;
+	struct orig_ist *orig_ist;
 	struct task_struct *me;
+	struct tss_struct *t;
+	unsigned long v;
+	int cpu;
 	int i;
 
+	cpu = stack_smp_processor_id();
+	t = &per_cpu(init_tss, cpu);
+	orig_ist = &per_cpu(orig_ist, cpu);
+
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
 	    cpu_to_node(cpu) != NUMA_NO_NODE)
@@ -1073,19 +1119,17 @@ void __cpuinit cpu_init(void)
 	 * set up and load the per-CPU TSS
 	 */
 	if (!orig_ist->ist[0]) {
-		static const unsigned int sizes[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STKSZ,
-		  [DEBUG_STACK - 1] = DEBUG_STKSZ
-		};
 		char *estacks = per_cpu(exception_stacks, cpu);
+
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			estacks += sizes[v];
+			estacks += exception_stack_sizes[v];
 			orig_ist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
 		}
 	}
 
 	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+
 	/*
 	 * <= is required because the CPU will access up to
 	 * 8 bits beyond the end of the IO permission bitmap.
@@ -1187,5 +1231,4 @@ void __cpuinit cpu_init(void)
 
 	xsave_init();
 }
-
 #endif
