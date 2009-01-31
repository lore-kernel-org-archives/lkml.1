Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZAaTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZAaTFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZAaTFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:05:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZAaTFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:05:40 -0500
Date: Sat, 31 Jan 2009 20:05:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/Voyager: make it build and boot
Message-ID: <20090131190525.GA10088@elte.hu>
References: <1233340524.3248.45.camel@localhost.localdomain> <20090130185411.GA9984@elte.hu> <1233341963.3248.48.camel@localhost.localdomain> <20090130193849.GC32705@elte.hu> <1233344509.3248.58.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233344509.3248.58.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > [...] However, this patch is needed now to get 2.6.29-rc3 to boot.
> > 
> > and there's also the other ones. We can put them in now that we've got 
> > the new subarch code. Could you send a pull request with all the 
> > voyager fixes collected into one tree?
> 
> Sure, they're currently all here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/voyager-2.6.git

I couldnt pull this tree as it had nearly as many problems as commits:

1) The tree was rebased freshly, losing history.

2) Commit febf1fe ("[VOYAGER] x86: fix voyager QIC interrupt controller") 
   is bogus as it adds only comment but claims to be an ioremap_cache() 
   fix. Probably a rebasing artifact.

4) Commit 569a588 is bogus as it introduces a duplicate Kconfig entry.
   Probably a rebasing/merging artifact.

3) The standard x86 commit log format is not:

       [VOYAGER] fix cpu bootmaps

   But something like:

       x86/Voyager: fix cpu bootmaps

   You even mixed them inconsistently:

       [VOYAGER] fix cpu bootmaps
       [VOYAGER] x86: fix voyager QIC interrupt controller

5) Commit 78543b1 ("[VOYAGER] x86: add ability to test for boot CPU") is 
   ugly and possibly breaks the standard build:

    +#ifdef CONFIG_ACPI
     #include <asm/acpi.h>
    +#endif

   If then such conditionals should be added to the acpi.h header itself 
   and any knock-on build breakages addressed. The construct you used are 
   magnets for standard kernel build breakages.

6) Neither did i like the commit logs berating x86 developers for breaking 
   voyager - while in reality there's only a single Linux developer on the 
   planet who _can_ test Voyager and its assumptions (and that is you).

   Unless you take part in the x86 development process fully (which you
   havent for a long time - you always came one stuff hit upstream and 
   sometimes in late rcs jumping months of x86 development), you cannot 
   expect special treatment nor can you expect people to even be aware of 
   the quirks of Voyager. Development is complex already without a 
   constant distraction from a subarch that is not used by any developer
   but you.

Anyway, to move forward i consolidated the acceptable bits into a single 
low-impact commit and queued it up in x86/urgent - see it below. The 
acpi.h bit you probably still need to build Voyager but it needs 
reworking. Please submit it separately.

Thanks,

	Ingo

-------------------->
>From 92ab78315c638515d0e81b0c70b2082f713582d9 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 31 Jan 2009 17:24:43 +0100
Subject: [PATCH] x86/Voyager: make it build and boot

[
  mingo@elte.hu: these fixes are a subset of changes cherry-picked from:

     git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/voyager-2.6.git

  They fix various problems that recent x86 changes caused in the Voyager
  subarchitecture: both APIC changes and cpumask changes and certain
  cleanups caused subarch assumptions to break.

  Most of these changes are obsolete as the subarch code has been removed
  from the x86 development tree - but we merge them upstream to make Voyager
  build and boot.
]

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irqinit_32.c        |   12 ------------
 arch/x86/mach-default/setup.c       |   12 ++++++++++++
 arch/x86/mach-voyager/setup.c       |   12 +++++++++++-
 arch/x86/mach-voyager/voyager_smp.c |   25 ++++++++++++-------------
 4 files changed, 35 insertions(+), 26 deletions(-)

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
 
