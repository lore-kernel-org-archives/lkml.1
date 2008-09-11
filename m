Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYIKP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYIKP0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYIKP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:26:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35951 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755535AbYIKP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:26:00 -0400
Date: Thu, 11 Sep 2008 10:25:58 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [RFC 1/4] switch vector_irq[] from irq number to irq_desc pointer
Message-ID: <20080911152558.GB13655@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152304.GA13655@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change per_cpu variable vector_irq[] from holding an 'int' irq number to
holding a 'struct irq_desc' pointer.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

Note that this pre-allocates the irq_desc structure before we know whether
a vector will be successfully found. And should it not, the irq_desc structure
is left created with the irq still unallocated. Should someone in the future
attempt to allocate a vector with that same irq and succeed, they will get
the previously allocated irq_desc structure.

Also, I won't claim the changes to arch/x86/xen/irq.c were correctly done, and
I know they weren't tested.

 arch/x86/kernel/io_apic.c     |   32 ++++++++++++++++++--------------
 arch/x86/kernel/irq_32.c      |   14 ++++++--------
 arch/x86/kernel/irq_64.c      |   10 ++++------
 arch/x86/kernel/irqinit_32.c  |   29 +++++++++--------------------
 arch/x86/kernel/irqinit_64.c  |   29 +++++++++--------------------
 arch/x86/kernel/vmiclock_32.c |    2 +-
 arch/x86/xen/irq.c            |    3 ++-
 include/asm-x86/hw_irq.h      |    2 +-
 8 files changed, 50 insertions(+), 71 deletions(-)

Index: linux/arch/x86/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/io_apic.c	2008-09-10 09:21:29.000000000 -0500
@@ -1222,6 +1222,7 @@ static int __assign_irq_vector(int irq, 
 	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
 	cfg = irq_cfg(irq);
 
@@ -1239,6 +1240,8 @@ static int __assign_irq_vector(int irq, 
 			return 0;
 	}
 
+	desc = irq_to_desc_alloc(irq);
+
 	for_each_cpu_mask_nr(cpu, mask) {
 		cpumask_t domain, new_mask;
 		int new_cpu;
@@ -1266,7 +1269,7 @@ next:
 			goto next;
 #endif
 		for_each_cpu_mask_nr(new_cpu, new_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+			if (per_cpu(vector_irq, new_cpu)[vector] != NULL)
 				goto next;
 		/* Found one! */
 		current_vector = vector;
@@ -1276,7 +1279,7 @@ next:
 			cfg->old_domain = cfg->domain;
 		}
 		for_each_cpu_mask_nr(new_cpu, new_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
+			per_cpu(vector_irq, new_cpu)[vector] = desc;
 		cfg->vector = vector;
 		cfg->domain = domain;
 		return 0;
@@ -1307,7 +1310,7 @@ static void __clear_irq_vector(int irq)
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
 	for_each_cpu_mask_nr(cpu, mask)
-		per_cpu(vector_irq, cpu)[vector] = -1;
+		per_cpu(vector_irq, cpu)[vector] = NULL;
 
 	cfg->vector = 0;
 	cpus_clear(cfg->domain);
@@ -1319,23 +1322,26 @@ void __setup_vector_irq(int cpu)
 	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
 	/* Mark the inuse vectors */
 	for_each_irq_cfg(irq, cfg) {
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
-		per_cpu(vector_irq, cpu)[vector] = irq;
+		desc = irq_to_desc(irq);
+		BUG_ON(desc == NULL);
+		per_cpu(vector_irq, cpu)[vector] = desc;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		irq = per_cpu(vector_irq, cpu)[vector];
-		if (irq < 0)
+		desc = per_cpu(vector_irq, cpu)[vector];
+		if (desc == NULL)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = irq_cfg(desc->irq);
 		if (!cpu_isset(cpu, cfg->domain))
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_irq, cpu)[vector] = NULL;
 	}
 }
 
@@ -2370,16 +2376,14 @@ asmlinkage void smp_irq_move_cleanup_int
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
-		irq = __get_cpu_var(vector_irq)[vector];
 
-		desc = irq_to_desc(irq);
-		if (!desc)
+		desc = __get_cpu_var(vector_irq)[vector];
+		if (desc == NULL)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = irq_cfg(desc->irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
 			goto unlock;
@@ -2387,7 +2391,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		if ((vector == cfg->vector) && cpu_isset(me, cfg->domain))
 			goto unlock;
 
-		__get_cpu_var(vector_irq)[vector] = -1;
+		__get_cpu_var(vector_irq)[vector] = NULL;
 		cfg->move_cleanup_count--;
 unlock:
 		spin_unlock(&desc->lock);
Index: linux/include/asm-x86/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86/hw_irq.h	2008-09-09 12:57:08.000000000 -0500
+++ linux/include/asm-x86/hw_irq.h	2008-09-09 12:57:13.000000000 -0500
@@ -113,7 +113,7 @@ extern asmlinkage void smp_invalidate_in
 extern void (*const interrupt[NR_VECTORS])(void);
 #endif
 
-typedef int vector_irq_t[NR_VECTORS];
+typedef struct irq_desc *vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 
 #ifdef CONFIG_X86_IO_APIC
Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/irq_32.c	2008-09-10 09:20:10.000000000 -0500
@@ -226,26 +226,24 @@ unsigned int do_IRQ(struct pt_regs *regs
 	int overflow;
 	unsigned vector = ~regs->orig_ax;
 	struct irq_desc *desc;
-	unsigned irq;
 
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
 
 	overflow = check_stack_overflow();
 
-	desc = irq_to_desc(irq);
-	if (unlikely(!desc)) {
-		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
-					__func__, irq, vector, smp_processor_id());
+	desc = __get_cpu_var(vector_irq)[vector];
+	if (unlikely(desc == NULL)) {
+		printk(KERN_EMERG "%s: cannot handle IRQ vector %#x cpu %d\n",
+					__func__, vector, smp_processor_id());
 		BUG();
 	}
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
+	if (!execute_on_irq_stack(overflow, desc, desc->irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
-		desc->handle_irq(irq, desc);
+		desc->handle_irq(desc->irq, desc);
 	}
 
 	irq_exit();
Index: linux/arch/x86/kernel/irq_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_64.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/irq_64.c	2008-09-10 09:20:10.000000000 -0500
@@ -213,20 +213,18 @@ asmlinkage unsigned int do_IRQ(struct pt
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
 
 	exit_idle();
 	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
 #endif
 
-	desc = irq_to_desc(irq);
-	if (likely(desc))
-		generic_handle_irq_desc(irq, desc);
-	else {
+	desc = __get_cpu_var(vector_irq)[vector];
+	if (likely(desc != NULL)) {
+		generic_handle_irq_desc(desc->irq, desc);
+	} else {
 		if (!disable_apic)
 			ack_APIC_irq();
 
Index: linux/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux.orig/arch/x86/kernel/vmiclock_32.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/vmiclock_32.c	2008-09-09 12:57:13.000000000 -0500
@@ -242,7 +242,7 @@ void __init vmi_time_init(void)
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
 	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
+		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = NULL;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
Index: linux/arch/x86/xen/irq.c
===================================================================
--- linux.orig/arch/x86/xen/irq.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/xen/irq.c	2008-09-09 12:57:13.000000000 -0500
@@ -27,8 +27,9 @@ static void __init __xen_init_IRQ(void)
 	for(i = 0; i < NR_VECTORS; i++) {
 		int cpu;
 
+		desc = irq_to_desc_alloc(i);
 		for_each_possible_cpu(cpu)
-			per_cpu(vector_irq, cpu)[i] = i;
+			per_cpu(vector_irq, cpu)[i] = desc;
 	}
 
 	xen_init_IRQ();
Index: linux/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_32.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_32.c	2008-09-09 12:57:13.000000000 -0500
@@ -59,6 +59,8 @@ static struct irqaction fpu_irq = {
 void __init init_ISA_irqs (void)
 {
 	int i;
+	int cpu;
+	unsigned int vector;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	init_bsp_APIC();
@@ -76,6 +78,12 @@ void __init init_ISA_irqs (void)
 		desc->action = NULL;
 		desc->depth = 1;
 
+		vector = IRQ0_VECTOR + i;
+		for_each_cpu_mask_nr(cpu, cpu_possible_map) {
+			BUG_ON(per_cpu(vector_irq, cpu)[vector] != NULL);
+			per_cpu(vector_irq, cpu)[vector] = desc;
+		}
+
 		set_irq_chip_and_handler_name(i, &i8259A_chip,
 					      handle_level_irq, "XT");
 	}
@@ -90,26 +98,7 @@ static struct irqaction irq2 = {
 	.name = "cascade",
 };
 
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
-};
+DEFINE_PER_CPU(vector_irq_t, vector_irq);
 
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2008-09-09 12:57:08.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_64.c	2008-09-09 12:57:13.000000000 -0500
@@ -114,30 +114,13 @@ static struct irqaction irq2 = {
 	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
-};
+DEFINE_PER_CPU(vector_irq_t, vector_irq);
 
 static void __init init_ISA_irqs (void)
 {
 	int i;
+	int cpu;
+	unsigned int vector;
 
 	init_bsp_APIC();
 	init_8259A(0);
@@ -150,6 +133,12 @@ static void __init init_ISA_irqs (void)
 		desc->action = NULL;
 		desc->depth = 1;
 
+		vector = IRQ0_VECTOR + i;
+		for_each_cpu_mask_nr(cpu, cpu_possible_map) {
+			BUG_ON(per_cpu(vector_irq, cpu)[vector] != NULL);
+			per_cpu(vector_irq, cpu)[vector] = desc;
+		}
+
 		/*
 		 * 16 old-style INTA-cycle interrupts:
 		 */
