Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0BNABJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:01:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:49310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab0BNABG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:01:06 -0500
Message-ID: <4B773CEB.9010609@kernel.org>
Date: Sat, 13 Feb 2010 15:59:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical
 flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org> <m16360ohi2.fsf@fess.ebiederm.org>
In-Reply-To: <m16360ohi2.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 03:14 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 02/13/2010 04:04 AM, Eric W. Biederman wrote:
>>>>  
>>>>  #ifdef CONFIG_X86_LOCAL_APIC
>>>> Index: linux-2.6/arch/x86/lguest/boot.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/lguest/boot.c
>>>> +++ linux-2.6/arch/x86/lguest/boot.c
>>>> @@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
>>>>  
>>>>  	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
>>>>  		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
>>>> -		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
>>>> +		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
>>>>  		if (i != SYSCALL_VECTOR)
>>>>  			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
>>>>  	}
>>>
>>> YH It appears that irq_to_desc_alloc_node has not been called yet
>>> so the setting of vector_desc needs to move to lguest_setup_irq.
>>
>> lguest is using sparseirq?
> 
> Apparently.  The last commit in that region of code moved some of the
> work (irq_to_desc_alloc_node) into lguest_setup_irq because kmalloc
> would not work that early.

please check -v2

Subject: [PATCH] x86: use vector_desc instead of vector_irq

Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
of handle_irq.
use vector_desc to reduce the calling of irq_to_desc.

next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc

-v2: irq should be unsigned in 32bit handle_irq according to Eric
     also reset vector_desc for lguest in setup_irq

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/desc.h    |    2 -
 arch/x86/include/asm/hw_irq.h  |   10 ++---
 arch/x86/include/asm/irq.h     |    3 +
 arch/x86/kernel/apic/io_apic.c |   75 ++++++++++++++++++++---------------------
 arch/x86/kernel/irq.c          |   15 +++-----
 arch/x86/kernel/irq_32.c       |   12 ++----
 arch/x86/kernel/irq_64.c       |    7 +--
 arch/x86/kernel/irqinit.c      |    8 +---
 arch/x86/kernel/smpboot.c      |    2 -
 arch/x86/kernel/vmiclock_32.c  |    2 -
 arch/x86/lguest/boot.c         |    7 +++
 11 files changed, 70 insertions(+), 73 deletions(-)

Index: linux-2.6/arch/x86/include/asm/desc.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/desc.h
+++ linux-2.6/arch/x86/include/asm/desc.h
@@ -334,7 +334,7 @@ static inline void set_intr_gate(unsigne
 }
 
 extern int first_system_vector;
-/* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
+/* used_vectors is BITMAP for irq is not managed by percpu vector_desc */
 extern unsigned long used_vectors[];
 
 static inline void alloc_system_vector(int vector)
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -99,7 +99,7 @@ struct irq_cfg {
 };
 
 extern struct irq_cfg *irq_cfg(unsigned int);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+extern int assign_irq_vector(struct irq_desc *, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
 struct irq_desc;
@@ -138,17 +138,17 @@ extern asmlinkage void smp_invalidate_in
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
-typedef int vector_irq_t[NR_VECTORS];
-DECLARE_PER_CPU(vector_irq_t, vector_irq);
+typedef struct irq_desc *vector_desc_t[NR_VECTORS];
+DECLARE_PER_CPU(vector_desc_t, vector_desc);
 
 #ifdef CONFIG_X86_IO_APIC
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern void __setup_vector_irq(int cpu);
+extern void __setup_vector_desc(int cpu);
 #else
 static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
-static inline void __setup_vector_irq(int cpu) {}
+static inline void __setup_vector_desc(int cpu) {}
 #endif
 
 #endif /* !ASSEMBLY_ */
Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -39,7 +39,8 @@ extern void irq_force_complete_move(int)
 
 extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
-extern bool handle_irq(unsigned irq, struct pt_regs *regs);
+struct irq_desc;
+extern bool handle_irq(struct irq_desc *desc, struct pt_regs *regs);
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1136,7 +1136,7 @@ void unlock_vector_lock(void)
 }
 
 static int
-__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+__assign_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1195,7 +1195,7 @@ next:
 			goto next;
 
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+			if (per_cpu(vector_desc, new_cpu)[vector] != NULL)
 				goto next;
 		/* Found one! */
 		current_vector = vector;
@@ -1205,7 +1205,7 @@ next:
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
+			per_cpu(vector_desc, new_cpu)[vector] = desc;
 		cfg->vector = vector;
 		cpumask_copy(cfg->domain, tmp_mask);
 		err = 0;
@@ -1215,18 +1215,18 @@ next:
 	return err;
 }
 
-int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+int assign_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	err = __assign_irq_vector(desc, cfg, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void __clear_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg)
 {
 	int cpu, vector;
 
@@ -1234,7 +1234,7 @@ static void __clear_irq_vector(int irq,
 
 	vector = cfg->vector;
 	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
-		per_cpu(vector_irq, cpu)[vector] = -1;
+		per_cpu(vector_desc, cpu)[vector] = NULL;
 
 	cfg->vector = 0;
 	cpumask_clear(cfg->domain);
@@ -1244,18 +1244,18 @@ static void __clear_irq_vector(int irq,
 	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] != irq)
+			if (per_cpu(vector_desc, cpu)[vector] != desc)
 				continue;
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_desc, cpu)[vector] = NULL;
 			break;
 		}
 	}
 	cfg->move_in_progress = 0;
 }
 
-void __setup_vector_irq(int cpu)
+void __setup_vector_desc(int cpu)
 {
-	/* Initialize vector_irq on a new cpu */
+	/* Initialize vector_desc on a new cpu */
 	int irq, vector;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -1272,17 +1272,17 @@ void __setup_vector_irq(int cpu)
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
-		per_cpu(vector_irq, cpu)[vector] = irq;
+		per_cpu(vector_desc, cpu)[vector] = desc;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		irq = per_cpu(vector_irq, cpu)[vector];
-		if (irq < 0)
+		desc = per_cpu(vector_desc, cpu)[vector];
+		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = desc->chip_data;
 		if (!cpumask_test_cpu(cpu, cfg->domain))
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_desc, cpu)[vector] = NULL;
 	}
 	spin_unlock(&vector_lock);
 }
@@ -1442,7 +1442,7 @@ static void setup_IO_APIC_irq(int apic_i
 	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
 		apic->vector_allocation_domain(0, cfg->domain);
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	if (assign_irq_vector(desc, cfg, apic->target_cpus()))
 		return;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
@@ -1458,7 +1458,7 @@ static void setup_IO_APIC_irq(int apic_i
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
-		__clear_irq_vector(irq, cfg);
+		__clear_irq_vector(desc, cfg);
 		return;
 	}
 
@@ -2336,14 +2336,12 @@ set_desc_affinity(struct irq_desc *desc,
 		  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg;
-	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -1;
 
-	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(desc, cfg, mask))
 		return -1;
 
 	cpumask_copy(desc->affinity, mask);
@@ -2416,7 +2414,7 @@ migrate_ioapic_irq_desc(struct irq_desc
 		return ret;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(desc, cfg, mask))
 		return ret;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
@@ -2470,20 +2468,15 @@ asmlinkage void smp_irq_move_cleanup_int
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
-		irq = __get_cpu_var(vector_irq)[vector];
+		desc = __get_cpu_var(vector_desc)[vector];
 
-		if (irq == -1)
-			continue;
-
-		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = desc->chip_data;
 		raw_spin_lock(&desc->lock);
 
 		/*
@@ -2508,7 +2501,7 @@ asmlinkage void smp_irq_move_cleanup_int
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__get_cpu_var(vector_irq)[vector] = -1;
+		__get_cpu_var(vector_desc)[vector] = NULL;
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
@@ -2945,7 +2938,7 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, cfg, apic->target_cpus());
+	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3274,7 +3267,7 @@ unsigned int create_irq_nr(unsigned int
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
+		if (__assign_irq_vector(desc_new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
 	}
@@ -3304,14 +3297,16 @@ int create_irq(void)
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
 	dynamic_irq_cleanup_keep_chip_data(irq);
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
-	cfg = irq_to_desc(irq)->chip_data;
-	__clear_irq_vector(irq, cfg);
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	__clear_irq_vector(desc, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -3322,6 +3317,7 @@ void destroy_irq(unsigned int irq)
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			   struct msi_msg *msg, u8 hpet_id)
 {
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3329,8 +3325,9 @@ static int msi_compose_msg(struct pci_de
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
 		return err;
 
@@ -3803,14 +3800,16 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -229,19 +229,19 @@ unsigned int __irq_entry do_IRQ(struct p
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
+	struct irq_desc *desc;
 
 	exit_idle();
 	irq_enter();
 
-	irq = __get_cpu_var(vector_irq)[vector];
+	desc = __get_cpu_var(vector_desc)[vector];
 
-	if (!handle_irq(irq, regs)) {
+	if (!handle_irq(desc, regs)) {
 		ack_APIC_irq();
 
 		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
-				__func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector\n",
+				__func__, smp_processor_id(), vector);
 	}
 
 	irq_exit();
@@ -348,14 +348,13 @@ void fixup_irqs(void)
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irr;
 
-		if (__get_cpu_var(vector_irq)[vector] < 0)
+		if (__get_cpu_var(vector_desc)[vector] == NULL)
 			continue;
 
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
 		if (irr  & (1 << (vector % 32))) {
-			irq = __get_cpu_var(vector_irq)[vector];
+			desc = __get_cpu_var(vector_desc)[vector];
 
-			desc = irq_to_desc(irq);
 			raw_spin_lock(&desc->lock);
 			if (desc->chip->retrigger)
 				desc->chip->retrigger(irq);
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -76,7 +76,7 @@ static void call_on_stack(void *func, vo
 }
 
 static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
+execute_on_irq_stack(int overflow, struct irq_desc *desc)
 {
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp, arg1, arg2;
@@ -189,24 +189,22 @@ asmlinkage void do_softirq(void)
 
 #else
 static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
+execute_on_irq_stack(int overflow, struct irq_desc *desc) { return 0; }
 #endif
 
-bool handle_irq(unsigned irq, struct pt_regs *regs)
+bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	int overflow;
 
 	overflow = check_stack_overflow();
 
-	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
+	if (!execute_on_irq_stack(overflow, desc)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
-		desc->handle_irq(irq, desc);
+		desc->handle_irq(desc->irq, desc);
 	}
 
 	return true;
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -48,17 +48,14 @@ static inline void stack_overflow_check(
 #endif
 }
 
-bool handle_irq(unsigned irq, struct pt_regs *regs)
+bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
-
 	stack_overflow_check(regs);
 
-	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
 
-	generic_handle_irq_desc(irq, desc);
+	generic_handle_irq_desc(desc->irq, desc);
 	return true;
 }
 
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -83,16 +83,14 @@ static struct irqaction irq2 = {
 	.name = "cascade",
 };
 
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... NR_VECTORS - 1] = -1,
-};
+DEFINE_PER_CPU(vector_desc_t, vector_desc);
 
 int vector_used_by_percpu_irq(unsigned int vector)
 {
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
+		if (per_cpu(vector_desc, cpu)[vector] != NULL)
 			return 1;
 	}
 
@@ -139,7 +137,7 @@ void __init init_IRQ(void)
 	 * irq's migrate etc.
 	 */
 	for (i = 0; i < nr_legacy_irqs; i++)
-		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
+		per_cpu(vector_desc, 0)[IRQ0_VECTOR + i] = irq_to_desc(i);
 
 	x86_init.irqs.intr_init();
 }
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -245,7 +245,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
-	__setup_vector_irq(smp_processor_id());
+	__setup_vector_desc(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -236,7 +236,7 @@ void __init vmi_time_init(void)
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
 	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
+		per_cpu(vector_desc, cpu)[vmi_get_timer_vector()] = irq_to_desc(0);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
 
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
-		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
+		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
@@ -842,6 +842,11 @@ static void __init lguest_init_IRQ(void)
 void lguest_setup_irq(unsigned int irq)
 {
 	irq_to_desc_alloc_node(irq, 0);
+	/*
+	 *  for sparseirq, we could get new desc other than legacy irq,
+	 *  so set vector_desc again for that irq
+	 */
+	__get_cpu_var(vector_desc)[irq + FIRST_EXTERNAL_VECTOR] = irq_to_desc(irq);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
