Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYICGxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYICGxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYICGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:53:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52651 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYICGxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=heLmZi8C/Kg6sEUCjtQ6XVTlqddbWqlgzGsJ9ygT69reDB8+TUdmimDArHy4fdyWzO
         wbP4t+fhYJj+Okl9fya8yypOIDxzMCdyhRpwy9XPCUKiIKEjVbIEg4sjekJfh7HBVsaX
         H8NnigYPKq8tLXeMUtCdaYgp00FjTG3dlBqwI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/5] x86: order functions in cpu/common.c and cpu/common_64.c v2
Date: Tue,  2 Sep 2008 23:52:57 -0700
Message-Id: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: make 64 bit get c->x86_cache_alignment = c->x86_clfush_size

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |  190 ++++++++++++++++++++++------------------
 arch/x86/kernel/cpu/common_64.c |  106 ++++++++++------------
 2 files changed, 156 insertions(+), 140 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -60,6 +60,18 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+}
+
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
@@ -123,15 +135,15 @@ int __cpuinit get_model_name(struct cpui
 
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, ecx, edx, l2size;
+	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
 	n = c->extended_cpuid_level;
 
 	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &dummy, &ecx, &edx);
+		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-			edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size = (ecx>>24)+(edx>>24);
+				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
+		c->x86_cache_size = (ecx>>24) + (edx>>24);
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
@@ -185,6 +197,51 @@ static char __cpuinit *table_lookup_mode
 	return NULL;		/* Not found */
 }
 
+#ifdef CONFIG_X86_HT
+void __cpuinit detect_ht(struct cpuinfo_x86 *c)
+{
+	u32 	eax, ebx, ecx, edx;
+	int 	index_msb, core_bits;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
+	if (!cpu_has(c, X86_FEATURE_HT) || cpu_has(c, X86_FEATURE_CMP_LEGACY))
+		return;
+
+	smp_num_siblings = (ebx & 0xff0000) >> 16;
+
+	if (smp_num_siblings == 1) {
+		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
+	} else if (smp_num_siblings > 1) {
+
+		if (smp_num_siblings > NR_CPUS) {
+			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
+					smp_num_siblings);
+			smp_num_siblings = 1;
+			return;
+		}
+
+		index_msb = get_count_order(smp_num_siblings);
+		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
+
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+
+		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
+
+		index_msb = get_count_order(smp_num_siblings);
+
+		core_bits = get_count_order(c->x86_max_cores);
+
+		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
+					       ((1 << core_bits) - 1);
+
+		if (c->x86_max_cores > 1)
+			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+			       c->cpu_core_id);
+	}
+}
+#endif
 
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
@@ -258,7 +315,26 @@ static int __cpuinit have_cpuid_p(void)
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
 
-void __init cpu_detect(struct cpuinfo_x86 *c)
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
+void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
@@ -267,19 +343,20 @@ void __init cpu_detect(struct cpuinfo_x8
 	      (unsigned int *)&c->x86_vendor_id[4]);
 
 	c->x86 = 4;
+	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 junk, tfms, cap0, misc;
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
-		c->x86 = (tfms >> 8) & 15;
-		c->x86_model = (tfms >> 4) & 15;
+		c->x86 = (tfms >> 8) & 0xf;
+		c->x86_model = (tfms >> 4) & 0xf;
+		c->x86_mask = tfms & 0xf;
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		c->x86_mask = tfms & 15;
+			c->x86_model += ((tfms >> 16) & 0xf) << 4;
 		if (cap0 & (1<<19)) {
-			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
 }
@@ -341,6 +418,17 @@ static void __init early_identify_cpu(st
 	validate_pat_support(c);
 }
 
+void __init early_cpu_init(void)
+{
+	struct cpu_vendor_dev *cvdev;
+
+	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
+		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+
+	early_cpu_support_print();
+	early_identify_cpu(&boot_cpu_data);
+}
+
 /*
  * The NOPL instruction is supposed to exist on all CPUs with
  * family >= 6, unfortunately, that's not true in practice because
@@ -500,7 +588,7 @@ static void __cpuinit identify_cpu(struc
 	 */
 	if (c != &boot_cpu_data) {
 		/* AND the already accumulated flags with these */
-		for (i = 0 ; i < NCAPINTS ; i++)
+		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
@@ -529,52 +617,6 @@ void __cpuinit identify_secondary_cpu(st
 	mtrr_ap_init();
 }
 
-#ifdef CONFIG_X86_HT
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
-{
-	u32 	eax, ebx, ecx, edx;
-	int 	index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-	if (!cpu_has(c, X86_FEATURE_HT) || cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		return;
-
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
-
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
-
-		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of the "
-					"siblings %d", smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
-		}
-
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
-
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
-
-		index_msb = get_count_order(smp_num_siblings) ;
-
-		core_bits = get_count_order(c->x86_max_cores);
-
-		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
-					       ((1 << core_bits) - 1);
-
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-	}
-}
-#endif
-
 static __init int setup_noclflush(char *arg)
 {
 	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
@@ -592,17 +634,17 @@ void __cpuinit print_cpu_info(struct cpu
 		vendor = c->x86_vendor_id;
 
 	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
-		printk("%s ", vendor);
+		printk(KERN_CONT "%s ", vendor);
 
-	if (!c->x86_model_id[0])
-		printk("%d86", c->x86);
+	if (c->x86_model_id[0])
+		printk(KERN_CONT "%s", c->x86_model_id);
 	else
-		printk("%s", c->x86_model_id);
+		printk(KERN_CONT "%d86", c->x86);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(" stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
 	else
-		printk("\n");
+		printk(KERN_CONT "\n");
 }
 
 static __init int setup_disablecpuid(char *arg)
@@ -618,16 +660,6 @@ __setup("clearcpuid=", setup_disablecpui
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-void __init early_cpu_init(void)
-{
-	struct cpu_vendor_dev *cvdev;
-
-	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
-		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
-
-	early_identify_cpu(&boot_cpu_data);
-}
-
 /* Make sure %fs is initialized properly in idle threads */
 struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
@@ -636,18 +668,6 @@ struct pt_regs * __cpuinit idle_regs(str
 	return regs;
 }
 
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-void switch_to_new_gdt(void)
-{
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
-}
-
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -103,9 +103,8 @@ void __cpuinit display_cacheinfo(struct
 
 	if (n >= 0x80000005) {
 		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), "
-		       "D cache %dK (%d bytes/line)\n",
-		       edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
+		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
+				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
 		/* On K8 L1 TLB is inclusive, so don't count it */
 		c->x86_tlbsize = 0;
@@ -146,8 +145,8 @@ void __cpuinit detect_ht(struct cpuinfo_
 	} else if (smp_num_siblings > 1) {
 
 		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of "
-			       "siblings %d", smp_num_siblings);
+			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
+					smp_num_siblings);
 			smp_num_siblings = 1;
 			return;
 		}
@@ -185,7 +184,7 @@ static void __cpuinit get_cpu_vendor(str
 		if (cpu_devs[i]) {
 			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
 			    (cpu_devs[i]->c_ident[1] &&
-			    !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
 				c->x86_vendor = i;
 				this_cpu = cpu_devs[i];
 				return;
@@ -220,39 +219,6 @@ static void __init early_cpu_support_pri
 	}
 }
 
-/*
- * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6, unfortunately, that's not true in practice because
- * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  Hence, probe for it based on first
- * principles.
- *
- * Note: no 64-bit chip is known to lack these, but put the code here
- * for consistency with 32 bits, and to make it utterly trivial to
- * diagnose the problem should it ever surface.
- */
-static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
-{
-	const u32 nopl_signature = 0x888c53b1; /* Random number */
-	u32 has_nopl = nopl_signature;
-
-	clear_cpu_cap(c, X86_FEATURE_NOPL);
-	if (c->x86 >= 6) {
-		asm volatile("\n"
-			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
-			     "2:\n"
-			     "        .section .fixup,\"ax\"\n"
-			     "3:      xor %0,%0\n"
-			     "        jmp 2b\n"
-			     "        .previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : "+a" (has_nopl));
-
-		if (has_nopl == nopl_signature)
-			set_cpu_cap(c, X86_FEATURE_NOPL);
-	}
-}
-
 void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
@@ -261,6 +227,7 @@ void __cpuinit cpu_detect(struct cpuinfo
 	      (unsigned int *)&c->x86_vendor_id[8],
 	      (unsigned int *)&c->x86_vendor_id[4]);
 
+	c->x86 = 4;
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 junk, tfms, cap0, misc;
@@ -271,12 +238,11 @@ void __cpuinit cpu_detect(struct cpuinfo
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		if (cap0 & (1<<19))
+			c->x86_model += ((tfms >> 16) & 0xf) << 4;
+		if (cap0 & (1<<19)) {
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
-	} else {
-		/* Have CPUID level 0 only - unheard of */
-		c->x86 = 4;
+			c->x86_cache_alignment = c->x86_clflush_size;
+		}
 	}
 }
 
@@ -286,9 +252,6 @@ static void __cpuinit get_cpu_cap(struct
 	u32 tfms, xlvl;
 	u32 ebx;
 
-	/* Initialize the standard set of capabilities */
-	/* Note that the vendor-specific code below might override */
-
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 capability, excap;
@@ -364,6 +327,39 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
+/*
+ * The NOPL instruction is supposed to exist on all CPUs with
+ * family >= 6, unfortunately, that's not true in practice because
+ * of early VIA chips and (more importantly) broken virtualizers that
+ * are not easy to detect.  Hence, probe for it based on first
+ * principles.
+ *
+ * Note: no 64-bit chip is known to lack these, but put the code here
+ * for consistency with 32 bits, and to make it utterly trivial to
+ * diagnose the problem should it ever surface.
+ */
+static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
+{
+	const u32 nopl_signature = 0x888c53b1; /* Random number */
+	u32 has_nopl = nopl_signature;
+
+	clear_cpu_cap(c, X86_FEATURE_NOPL);
+	if (c->x86 >= 6) {
+		asm volatile("\n"
+			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
+			     "2:\n"
+			     "        .section .fixup,\"ax\"\n"
+			     "3:      xor %0,%0\n"
+			     "        jmp 2b\n"
+			     "        .previous\n"
+			     _ASM_EXTABLE(1b,3b)
+			     : "+a" (has_nopl));
+
+		if (has_nopl == nopl_signature)
+			set_cpu_cap(c, X86_FEATURE_NOPL);
+	}
+}
+
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
 	c->extended_cpuid_level = 0;
@@ -451,7 +447,7 @@ static void __cpuinit identify_cpu(struc
 
 }
 
-void __cpuinit identify_boot_cpu(void)
+void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
 }
@@ -463,13 +459,6 @@ void __cpuinit identify_secondary_cpu(st
 	mtrr_ap_init();
 }
 
-static __init int setup_noclflush(char *arg)
-{
-	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
-	return 1;
-}
-__setup("noclflush", setup_noclflush);
-
 struct msr_range {
 	unsigned min;
 	unsigned max;
@@ -513,6 +502,13 @@ static __init int setup_show_msr(char *a
 }
 __setup("show_msr=", setup_show_msr);
 
+static __init int setup_noclflush(char *arg)
+{
+	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
+	return 1;
+}
+__setup("noclflush", setup_noclflush);
+
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
