Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYHRHiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYHRHiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYHRHiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:38:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYHRHiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:38:06 -0400
Date: Mon, 18 Aug 2008 09:37:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] irq: rename irq_desc() to to_irq_desc()
Message-ID: <20080818073747.GC30694@elte.hu>
References: <1219032749-9312-1-git-send-email-yhlu.kernel@gmail.com> <1219032749-9312-2-git-send-email-yhlu.kernel@gmail.com> <1219032749-9312-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219032749-9312-3-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> So could revert back to use irq_desc[] for other arch except x86
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

great!

could we get rid of the remaining non-x86 arch changes too, please? 

- __do_IRQ(): why is the change needed? Architectures that want to use 
  sparse IRQs should first properly convert to genirq (i.e. should get 
  rid of their __do_IRQ() use).

- kstat_cpu / kstat_irqs_cpu: seems unnecessary now?

- create_irq prototype return value change: cannot we limit the irq 
  space to 0..INT_MAX, and leave the prototype alone?

- create_irq(int) argument change: how about introducing a new 
  create_irq_nr(int) variant, while the create_irq(void) function would 
  just call create_irq_nr(0) ?

	Ingo

diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index c626a82..b5348ae 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -89,7 +89,7 @@ show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(irq));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[irq]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
 		seq_printf(p, "  %c%s",
@@ -156,6 +156,6 @@ handle_irq(int irq)
 	 * at IPL 0.
 	 */
 	local_irq_disable();
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 }
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index e16aeb6..2c0852c 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -64,7 +64,7 @@ do_entInt(unsigned long type, unsigned long vector,
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-		        kstat_cpu(cpu).irqs[RTC_IRQ]++;
+			irq_desc[RTC_IRQ].kstat_irqs[cpu]++;
 		} else {
 			handle_irq(RTC_IRQ);
 		}
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index f88efb1..26a1185 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -69,22 +69,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-		seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+		seq_printf(p, " %10s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 #ifdef CONFIG_ARCH_ACORN
 		show_fiq_list(p, v);
diff --git a/arch/arm/mach-iop13xx/msi.c b/arch/arm/mach-iop13xx/msi.c
index 63ef112..ace5bad 100644
--- a/arch/arm/mach-iop13xx/msi.c
+++ b/arch/arm/mach-iop13xx/msi.c
@@ -125,7 +125,7 @@ void __init iop13xx_msi_init(void)
 /*
  * Dynamic irq allocate and deallocation
  */
-int create_irq(void)
+unsigned int create_irq(unsigned not_used)
 {
 	int irq, pos;
 
@@ -173,7 +173,7 @@ static struct irq_chip iop13xx_msi_chip = {
 
 int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
-	int id, irq = create_irq();
+	int id, irq = create_irq(0);
 	struct msi_msg msg;
 
 	if (irq < 0)
diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 38260d5..5118872 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -63,7 +63,6 @@ static struct irq_chip ns9xxx_chip = {
 #else
 static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -72,7 +71,7 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 	BUG_ON(desc->status & IRQ_INPROGRESS);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index a8e767d..b75a957 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -51,22 +51,24 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_desc(i);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
-		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+		seq_printf(p, " %8s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 	unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	return 0;
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 0b26ae2..08ad8ad 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -989,7 +989,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 689b69c..66e770d 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -1024,7 +1024,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index ed2b0b8..49b02ec 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -418,7 +418,7 @@ static int __init cm_bf533_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 079389c..0b9c3a6 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -426,7 +426,7 @@ static int __init ezkit_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 13ae495..1bb6d18 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -627,7 +627,7 @@ static int __init stamp_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 01b63e2..6f57f09 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -733,7 +733,7 @@ static int __init stamp_init(void)
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index bc6fede..8cdc0ad 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -540,7 +540,7 @@ static int __init ezkit_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+	irq_desc(PATA_INT)->status |= IRQ_NOAUTOEN;
 #endif
 	return 0;
 }
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 2dfac8c..a2746de 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -66,7 +66,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
@@ -99,7 +99,7 @@ asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
         irq_exit();
 	set_irq_regs(old_regs);
 }
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 73abae7..af3e824 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -74,7 +74,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index ef4f004..221c4cd 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -176,7 +176,7 @@ void __init init_IRQ(void)
 asmlinkage void do_IRQ(int irq)
 {
 	irq_enter();
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 }
 
@@ -196,7 +196,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
-		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 5c4674a..031e02e 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -407,7 +407,7 @@ iosapic_end_level_irq (unsigned int irq)
 		iosapic_eoi(rte->iosapic->addr, vec);
 
 	if (unlikely(do_unmask_irq)) {
-		move_masked_irq(irq);
+		move_masked_irq(irq, &irq_desc[irq]);
 		unmask_irq(irq);
 	}
 }
@@ -452,7 +452,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 	irq_desc_t *idesc = irq_desc + irq;
 
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(irq, idesc);
 	/*
 	 * Once we have recorded IRQ_PENDING already, we can mask the
 	 * interrupt for real. This prevents IRQ storms from unhandled
@@ -532,7 +532,7 @@ iosapic_reassign_vector (int irq)
 	int new_irq;
 
 	if (iosapic_intr_info[irq].count) {
-		new_irq = create_irq();
+		new_irq = create_irq(0);
 		if (new_irq < 0)
 			panic("%s: out of interrupt vectors!\n", __func__);
 		printk(KERN_INFO "Reassigning vector %d to %d\n",
@@ -783,7 +783,7 @@ iosapic_register_intr (unsigned int gsi,
 			goto unlock_iosapic_lock;
 		}
 	} else
-		irq = create_irq();
+		irq = create_irq(0);
 
 	/* If vector is running out, we try to find a sharable vector */
 	if (irq < 0) {
@@ -922,7 +922,7 @@ iosapic_register_platform_intr (u32 int_type, unsigned int gsi,
 		delivery = IOSAPIC_PMI;
 		break;
 	      case ACPI_INTERRUPT_INIT:
-		irq = create_irq();
+		irq = create_irq(0);
 		if (irq < 0)
 			panic("%s: out of interrupt vectors!\n", __func__);
 		vector = irq_to_vector(irq);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 7fd18f5..4140d51 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -80,7 +80,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j) {
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		}
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 28d3d48..96f7571 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -403,7 +403,7 @@ void destroy_and_reserve_irq(unsigned int irq)
 /*
  * Dynamic irq allocate and deallocation for MSI
  */
-int create_irq(void)
+unsigned int create_irq(unsigned int not_used)
 {
 	unsigned long flags;
 	int irq, vector, cpu;
@@ -495,9 +495,9 @@ ia64_handle_irq (ia64_vector vector, struct pt_regs *regs)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		else {
 			int irq = local_vector_to_irq(vector);
 
@@ -553,9 +553,9 @@ void ia64_process_pending_intr(void)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(&irq_desc[vector])++;
 		else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 			int irq = local_vector_to_irq(vector);
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 60c6ef6..924293f 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -84,7 +84,7 @@ int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	int	irq, vector;
 	cpumask_t mask;
 
-	irq = create_irq();
+	irq = create_irq(0);
 	if (irq < 0)
 		return irq;
 
@@ -120,7 +120,7 @@ void ia64_teardown_msi_irq(unsigned int irq)
 static void ia64_ack_msi_irq(unsigned int irq)
 {
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(irq, &irq_desc[irq]);
 	ia64_eoi();
 }
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 96c31b4..50ddcf3 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -110,7 +110,7 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq);
+	move_native_irq(irq, &irq_desc[irq]);
 }
 
 static void sn_end_irq(unsigned int irq)
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 83f190f..a6739fa 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -83,7 +83,7 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 	if (provider == NULL || provider->dma_map_consistent == NULL)
 		return -EINVAL;
 
-	irq = create_irq();
+	irq = create_irq(0);
 	if (irq < 0)
 		return irq;
 
@@ -210,7 +210,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 
 static void sn_ack_msi_irq(unsigned int irq)
 {
-	move_native_irq(irq);
+	move_native_irq(irq, &irq_desc[irq]);
 	ia64_eoi();
 }
 
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index d0c5b0b..09d16ea 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -52,7 +52,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
@@ -84,7 +84,7 @@ asmlinkage unsigned int do_IRQ(int irq, struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* FIXME M32R */
 #endif
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 	set_irq_regs(old_regs);
 
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index ded7dd2..d8aebfc 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -46,6 +46,8 @@
 #include <asm/q40ints.h>
 #endif
 
+int nr_irqs = NR_IRQS;
+
 extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
diff --git a/arch/m68knommu/kernel/irq.c b/arch/m68knommu/kernel/irq.c
index bba1bb4..7d565f1 100644
--- a/arch/m68knommu/kernel/irq.c
+++ b/arch/m68knommu/kernel/irq.c
@@ -23,7 +23,7 @@ asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 	struct pt_regs *oldregs = set_irq_regs(regs);
 
 	irq_enter();
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 
 	set_irq_regs(oldregs);
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 4b4007b..7b845ba 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -108,7 +108,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f6d9bf4..6794c76 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -164,7 +164,7 @@ static void indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(&irq_desc[irq])++;
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 10e5054..f744b2e 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -186,7 +186,7 @@ void indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(&irq_desc[irq])++;
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index bd9eeb4..6f09896 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -180,7 +180,7 @@ void bcm1480_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_BCM1480_INT_MBOX_0_0]++;
+	irq_desc[K_BCM1480_INT_MBOX_0_0].kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 0734b93..dd0e55e 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -168,7 +168,7 @@ void sb1250_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_INT_MBOX_0]++;
+	irq_desc[K_INT_MBOX_0].kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 761c434..87ecf9d 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -197,12 +197,11 @@ int show_interrupts(struct seq_file *p, void *v)
 		/* display information rows, one per active CPU */
 	case 1 ... NR_IRQS - 1:
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
-
 		action = irq_desc[i].action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 23ef950..8672b27 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -183,7 +183,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
@@ -363,7 +363,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 		goto set_out;
 	}
 #endif
-	__do_IRQ(irq);
+	__do_IRQ(irq, irq_desc);
 
  out:
 	irq_exit();
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index d972dec..93870a6 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -190,7 +190,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif /* CONFIG_SMP */
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 2d5bb22..490b619 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -254,7 +254,7 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 		goto out_eoi;
 	}
 
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 6d149ae..e3d44d5 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -221,7 +221,7 @@ static irqreturn_t gatwick_action(int cpl, void *dev_id)
 			continue;
 		irq += __ilog2(bits);
 		spin_unlock_irqrestore(&pmac_pic_lock, flags);
-		__do_IRQ(irq);
+		__do_IRQ(irq, &irq_desc[irq]);
 		spin_lock_irqsave(&pmac_pic_lock, flags);
 		rc = IRQ_HANDLED;
 	}
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e7c5bfb..14eb549 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -17,6 +17,8 @@
 #include <linux/proc_fs.h>
 #include <linux/profile.h>
 
+int nr_irqs = NR_IRQS;
+
 /*
  * show_interrupts is needed by /proc/interrupts.
  */
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 64b7690..0080a16 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 93e1d1c..059598b 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -55,6 +55,9 @@
 #define SMP_NOP2
 #define SMP_NOP3
 #endif /* SMP */
+
+int nr_irqs = NR_IRQS;
+
 unsigned long __raw_local_irq_save(void)
 {
 	unsigned long retval;
diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index 9b6689d..fc0fd8b 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -185,7 +185,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %9s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index cc16fdc..db211ac 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -16,6 +16,7 @@
 #include <linux/param.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/timex.h>
@@ -942,7 +943,7 @@ void timer_interrupt(int irq, struct pt_regs *regs)
 
 	irq_enter();
 
-	kstat_this_cpu.irqs[0]++;
+	irq_desc[0].kstat_irqs[0]++;
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3d7aad0..a2ff0ea 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -42,7 +42,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
@@ -332,7 +332,7 @@ unsigned int do_IRQ(int irq, struct uml_pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
-	__do_IRQ(irq);
+	__do_IRQ(irq, &irq_desc[irq]);
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
