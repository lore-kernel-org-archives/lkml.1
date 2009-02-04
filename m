Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZBDTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZBDTWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZBDTWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:22:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZBDTW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:22:29 -0500
Date: Wed, 4 Feb 2009 20:22:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090204192217.GA17749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
MAINTAINERS                        # bcde563: x86: add x86@kernel.org to MAINTA
kernel/irq/numa_migrate.c          # 10b888d: irq, x86: fix lock status with nu

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86: APIC: enable workaround on AMD Fam10h CPUs

Dave Jones (1):
      x86: add cache descriptors for Intel Core i7

H. Peter Anvin (1):
      x86: add x86@kernel.org to MAINTAINERS

James Bottomley (1):
      x86/Voyager: make it build and boot

Jeremy Fitzhardinge (1):
      xen: disable interrupts before saving in percpu

Martin Hicks (1):
      x86: push old stack address on irqstack for unwinder

Yinghai Lu (1):
      irq, x86: fix lock status with numa_migrate_irq_desc


 MAINTAINERS                           |    1 +
 arch/x86/kernel/apic.c                |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   15 +++++++++++++++
 arch/x86/kernel/entry_64.S            |    1 +
 arch/x86/kernel/io_apic.c             |    5 +++--
 arch/x86/kernel/irqinit_32.c          |   12 ------------
 arch/x86/mach-default/setup.c         |   12 ++++++++++++
 arch/x86/mach-voyager/setup.c         |   12 +++++++++++-
 arch/x86/mach-voyager/voyager_smp.c   |   25 ++++++++++++-------------
 arch/x86/xen/multicalls.h             |    4 +++-
 kernel/irq/numa_migrate.c             |    7 ++++++-
 11 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 474ec0c..cf0ab3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4841,6 +4841,7 @@ P:	Ingo Molnar
 M:	mingo@redhat.com
 P:	H. Peter Anvin
 M:	hpa@zytor.com
+M:	x86@kernel.org
 L:	linux-kernel@vger.kernel.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 4b6df24..115449f 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1436,7 +1436,7 @@ static int __init detect_init_APIC(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
-		    (boot_cpu_data.x86 == 15))
+		    (boot_cpu_data.x86 >= 15))
 			break;
 		goto no_apic;
 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 48533d7..da299eb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -36,8 +36,11 @@ static struct _cache_table cache_table[] __cpuinitdata =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x09, LVL_1_INST, 32 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x0a, LVL_1_DATA, 8 },	/* 2 way set assoc, 32 byte line size */
 	{ 0x0c, LVL_1_DATA, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
@@ -85,6 +88,18 @@ static struct _cache_table cache_table[] __cpuinitdata =
 	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e28c7a9..a134621 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -346,6 +346,7 @@ ENTRY(save_args)
 	popq_cfi %rax			/* move return address... */
 	mov %gs:pda_irqstackptr,%rsp
 	EMPTY_FRAME 0
+	pushq_cfi %rbp			/* backlink for unwinder */
 	pushq_cfi %rax			/* ... to the new stack */
 	/*
 	 * We entered an interrupt context - irqs are off:
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 1c4a130..9b0c480 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2528,14 +2528,15 @@ static void irq_complete_move(struct irq_desc **descp)
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
+
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
 #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
 		*descp = desc = move_irq_desc(desc, me);
 		/* get the new one */
 		cfg = desc->chip_data;
 #endif
-
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
+	}
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 1507ad4..10a09c2 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -78,15 +78,6 @@ void __init init_ISA_irqs(void)
 	}
 }
 
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[0 ... IRQ0_VECTOR - 1] = -1,
 	[IRQ0_VECTOR] = 0,
@@ -178,9 +169,6 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
 
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-
 	/* setup after call gates are initialised (usually add in
 	 * the architecture specific gates)
 	 */
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index df167f2..a265a7c 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -38,6 +38,15 @@ void __init pre_intr_init_hook(void)
 	init_ISA_irqs();
 }
 
+/*
+ * IRQ2 is cascade interrupt to second interrupt controller
+ */
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
+
 /**
  * intr_init_hook - post gate setup interrupt initialisation
  *
@@ -53,6 +62,9 @@ void __init intr_init_hook(void)
 		if (x86_quirks->arch_intr_init())
 			return;
 	}
+	if (!acpi_ioapic)
+		setup_irq(2, &irq2);
+
 }
 
 /**
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index a580b95..d914a79 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -33,13 +33,23 @@ void __init intr_init_hook(void)
 	setup_irq(2, &irq2);
 }
 
-void __init pre_setup_arch_hook(void)
+static void voyager_disable_tsc(void)
 {
 	/* Voyagers run their CPUs from independent clocks, so disable
 	 * the TSC code because we can't sync them */
 	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
 
+void __init pre_setup_arch_hook(void)
+{
+	voyager_disable_tsc();
+}
+
+void __init pre_time_init_hook(void)
+{
+	voyager_disable_tsc();
+}
+
 void __init trap_init_hook(void)
 {
 }
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 9840b7e..7ffcdee 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -81,7 +81,7 @@ static void enable_local_vic_irq(unsigned int irq);
 static void disable_local_vic_irq(unsigned int irq);
 static void before_handle_vic_irq(unsigned int irq);
 static void after_handle_vic_irq(unsigned int irq);
-static void set_vic_irq_affinity(unsigned int irq, cpumask_t mask);
+static void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask);
 static void ack_vic_irq(unsigned int irq);
 static void vic_enable_cpi(void);
 static void do_boot_cpu(__u8 cpuid);
@@ -211,8 +211,6 @@ static __u32 cpu_booted_map;
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
 /* This is for the new dynamic CPU boot code */
-cpumask_t cpu_callin_map = CPU_MASK_NONE;
-cpumask_t cpu_callout_map = CPU_MASK_NONE;
 
 /* The per processor IRQ masks (these are usually kept in sync) */
 static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
@@ -378,7 +376,7 @@ void __init find_smp_config(void)
 	cpus_addr(phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	cpu_possible_map = phys_cpu_present_map;
+	init_cpu_possible(&phys_cpu_present_map);
 	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
 	       cpus_addr(phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
@@ -1599,16 +1597,16 @@ static void after_handle_vic_irq(unsigned int irq)
  * change the mask and then do an interrupt enable CPI to re-enable on
  * the selected processors */
 
-void set_vic_irq_affinity(unsigned int irq, cpumask_t mask)
+void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	/* Only extended processors handle interrupts */
 	unsigned long real_mask;
 	unsigned long irq_mask = 1 << irq;
 	int cpu;
 
-	real_mask = cpus_addr(mask)[0] & voyager_extended_vic_processors;
+	real_mask = cpus_addr(*mask)[0] & voyager_extended_vic_processors;
 
-	if (cpus_addr(mask)[0] == 0)
+	if (cpus_addr(*mask)[0] == 0)
 		/* can't have no CPUs to accept the interrupt -- extremely
 		 * bad things will happen */
 		return;
@@ -1750,10 +1748,11 @@ static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
 
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
+	cpu_online_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callout_map = cpumask_of_cpu(smp_processor_id());
+	cpu_callin_map = CPU_MASK_NONE;
+	cpu_present_map = cpumask_of_cpu(smp_processor_id());
+
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
@@ -1783,9 +1782,9 @@ void __init smp_setup_processor_id(void)
 	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
 
-static void voyager_send_call_func(cpumask_t callmask)
+static void voyager_send_call_func(const struct cpumask *callmask)
 {
-	__u32 mask = cpus_addr(callmask)[0] & ~(1 << smp_processor_id());
+	__u32 mask = cpus_addr(*callmask)[0] & ~(1 << smp_processor_id());
 	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
 }
 
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
index 8589382..fa3e107 100644
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -19,8 +19,10 @@ DECLARE_PER_CPU(unsigned long, xen_mc_irq_flags);
    paired with xen_mc_issue() */
 static inline void xen_mc_batch(void)
 {
+	unsigned long flags;
 	/* need to disable interrupts until this entry is complete */
-	local_irq_save(__get_cpu_var(xen_mc_irq_flags));
+	local_irq_save(flags);
+	__get_cpu_var(xen_mc_irq_flags) = flags;
 }
 
 static inline struct multicall_space xen_mc_entry(size_t args)
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index ecf765c..acd8835 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -71,7 +71,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	desc = irq_desc_ptrs[irq];
 
 	if (desc && old_desc != desc)
-			goto out_unlock;
+		goto out_unlock;
 
 	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
@@ -84,10 +84,15 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	/* free the old one */
 	free_one_irq_desc(old_desc, desc);
+	spin_unlock(&old_desc->lock);
 	kfree(old_desc);
+	spin_lock(&desc->lock);
+
+	return desc;
 
 out_unlock:
 	spin_unlock_irqrestore(&sparse_irq_lock, flags);
