Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYHAJjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYHAJjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYHAJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYHAJic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vx74MdjRtju8qmO/5F6GCykRBY0QIrijQfzh3t1ve+f1TG6prpMbv5ni7ZqC3AY1u/
         hODzZb1rqTulOTFwukcXbTVjHynaxBHcLtNsNUoDjbHiK0iCXSVxAOO8eNkuv9ewiprd
         QTv5iBV9YsWNlycSigMRJ/h3PVYBZxnS47T6Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/16] x86: introduce nr_irqs for 64bit v3
Date: Fri,  1 Aug 2008 02:37:30 -0700
Message-Id: <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add DEFINE_DYN_ARRAY for dynamical array support

v2: other platform will have nr_irqs = NR_IRQS
    for MAXSMP/UV: could set smaller nr_irqs in acpi_madt_oem_check in genx2_apic_uv_x
v3: seperate DYN_ARRAY and enabling to x86_64 to following patches

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
---
 arch/x86/kernel/io_apic_32.c            |   26 +++++++++++++------------
 arch/x86/kernel/io_apic_64.c            |   33 ++++++++++++++++----------------
 arch/x86/kernel/irq_32.c                |    8 +++----
 arch/x86/kernel/irq_64.c                |    8 +++----
 arch/x86/kernel/irqinit_32.c            |    2 -
 arch/x86/kernel/irqinit_64.c            |    2 -
 drivers/char/hpet.c                     |    2 -
 drivers/char/random.c                   |    4 +--
 drivers/char/vr41xx_giu.c               |    2 -
 drivers/net/3c59x.c                     |    4 +--
 drivers/net/hamradio/baycom_ser_fdx.c   |    4 +--
 drivers/net/hamradio/scc.c              |    6 ++---
 drivers/net/wan/sbni.c                  |    2 -
 drivers/pci/intr_remapping.c            |   16 +++++++--------
 drivers/pcmcia/at91_cf.c                |    2 -
 drivers/pcmcia/vrc4171_card.c           |    2 -
 drivers/rtc/rtc-vr41xx.c                |    4 +--
 drivers/scsi/aha152x.c                  |    2 -
 drivers/serial/8250.c                   |    4 +--
 drivers/serial/amba-pl010.c             |    2 -
 drivers/serial/amba-pl011.c             |    2 -
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 -
 drivers/serial/m32r_sio.c               |    4 +--
 drivers/serial/serial_core.c            |    2 -
 drivers/serial/serial_lh7a40x.c         |    2 -
 drivers/serial/sh-sci.c                 |    2 -
 drivers/serial/ucc_uart.c               |    2 -
 drivers/xen/events.c                    |   12 +++++------
 fs/proc/proc_misc.c                     |   10 ++++-----
 include/asm-x86/irq.h                   |    3 ++
 include/linux/irq.h                     |    2 +
 kernel/irq/autoprobe.c                  |   10 ++++-----
 kernel/irq/chip.c                       |   20 +++++++++----------
 kernel/irq/handle.c                     |    3 +-
 kernel/irq/manage.c                     |   16 +++++++--------
 kernel/irq/proc.c                       |    2 -
 kernel/irq/resend.c                     |    4 +--
 kernel/irq/spurious.c                   |    4 +--
 38 files changed, 123 insertions(+), 114 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -70,6 +70,7 @@ int timer_through_8259 __initdata;
  */
 int sis_apic_bug = -1;
 
+int first_free_entry = NR_IRQS;
 /*
  * # of IRQ routing registers
  */
@@ -100,6 +101,8 @@ static int disable_timer_pin_1 __initdat
 #define MAX_PLUS_SHARED_IRQS NR_IRQS
 #define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
+int pin_map_size = PIN_MAP_SIZE;
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -213,7 +216,6 @@ static void ioapic_mask_entry(int apic,
  */
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	static int first_free_entry = NR_IRQS;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
 	while (entry->next)
@@ -222,7 +224,7 @@ static void add_pin_to_irq(unsigned int
 	if (entry->pin != -1) {
 		entry->next = first_free_entry;
 		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= PIN_MAP_SIZE)
+		if (++first_free_entry >= pin_map_size)
 			panic("io_apic.c: whoops");
 	}
 	entry->apic = apic;
@@ -457,7 +459,7 @@ static inline void rotate_irqs_among_cpu
 	int i, j;
 
 	for_each_online_cpu(i) {
-		for (j = 0; j < NR_IRQS; j++) {
+		for (j = 0; j < nr_irqs; j++) {
 			if (!irq_desc[j].action)
 				continue;
 			/* Is it a significant load ?  */
@@ -492,7 +494,7 @@ static void do_irq_balance(void)
 		if (!cpu_online(i))
 			continue;
 		package_index = CPU_TO_PACKAGEINDEX(i);
-		for (j = 0; j < NR_IRQS; j++) {
+		for (j = 0; j < nr_irqs; j++) {
 			unsigned long value_now, delta;
 			/* Is this an active IRQ or balancing disabled ? */
 			if (!irq_desc[j].action || irq_balancing_disabled(j))
@@ -587,7 +589,7 @@ tryanotherirq:
 	 */
 	move_this_load = 0;
 	selected_irq = -1;
-	for (j = 0; j < NR_IRQS; j++) {
+	for (j = 0; j < nr_irqs; j++) {
 		/* Is this an active IRQ? */
 		if (!irq_desc[j].action)
 			continue;
@@ -664,7 +666,7 @@ static int balanced_irq(void *unused)
 	long time_remaining = balanced_irq_interval;
 
 	/* push everything to CPU 0 to give us a starting point.  */
-	for (i = 0 ; i < NR_IRQS ; i++) {
+	for (i = 0 ; i < nr_irqs ; i++) {
 		irq_desc[i].pending_mask = cpumask_of_cpu(0);
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
@@ -712,8 +714,8 @@ static int __init balanced_irq_init(void
 		physical_balance = 1;
 
 	for_each_online_cpu(i) {
-		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
-		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
+		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * nr_irqs, GFP_KERNEL);
+		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * nr_irqs, GFP_KERNEL);
 		if (irq_cpu_data[i].irq_delta == NULL || irq_cpu_data[i].last_irq == NULL) {
 			printk(KERN_ERR "balanced_irq_init: out of memory");
 			goto failed;
@@ -1445,7 +1447,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_pin_list *entry = irq_2_pin + i;
 		if (entry->pin < 0)
 			continue;
@@ -1625,7 +1627,7 @@ static void __init enable_IO_APIC(void)
 	int i, apic;
 	unsigned long flags;
 
-	for (i = 0; i < PIN_MAP_SIZE; i++) {
+	for (i = 0; i < pin_map_size; i++) {
 		irq_2_pin[i].pin = -1;
 		irq_2_pin[i].next = 0;
 	}
@@ -2009,7 +2011,7 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < NR_IRQS ; irq++) {
+	for (irq = 0; irq < nr_irqs ; irq++) {
 		if (IO_APIC_IRQ(irq) && !irq_vector[irq]) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2453,7 +2455,7 @@ int create_irq(void)
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = (NR_IRQS - 1); new >= 0; new--) {
+	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
 		if (irq_vector[new] != 0)
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -132,6 +132,7 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
 #define MAX_PLUS_SHARED_IRQS NR_IRQS
 #define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
+int pin_map_size = PIN_MAP_SIZE;
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -224,7 +225,7 @@ static inline void io_apic_sync(unsigned
 	int pin;							\
 	struct irq_pin_list *entry = irq_2_pin + irq;			\
 									\
-	BUG_ON(irq >= NR_IRQS);						\
+	BUG_ON(irq >= nr_irqs);						\
 	for (;;) {							\
 		unsigned int reg;					\
 		pin = entry->pin;					\
@@ -301,7 +302,7 @@ static void __target_IO_APIC_irq(unsigne
 	int apic, pin;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	for (;;) {
 		unsigned int reg;
 		apic = entry->apic;
@@ -358,19 +359,19 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
+int first_free_entry = NR_IRQS;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	static int first_free_entry = NR_IRQS;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	while (entry->next)
 		entry = irq_2_pin + entry->next;
 
 	if (entry->pin != -1) {
 		entry->next = first_free_entry;
 		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= PIN_MAP_SIZE)
+		if (++first_free_entry >= pin_map_size)
 			panic("io_apic.c: ran out of irq_2_pin entries!");
 	}
 	entry->apic = apic;
@@ -634,7 +635,7 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= NR_IRQS);
+	BUG_ON(best_guess >= nr_irqs);
 	return best_guess;
 }
 
@@ -766,7 +767,7 @@ static int pin_2_irq(int idx, int apic,
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
 	}
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	return irq;
 }
 
@@ -788,7 +789,7 @@ static int __assign_irq_vector(int irq,
 	int cpu;
 	struct irq_cfg *cfg;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
+	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = &irq_cfg[irq];
 
 	/* Only try and allocate irqs on cpus that are present */
@@ -862,7 +863,7 @@ static void __clear_irq_vector(int irq)
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
+	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = &irq_cfg[irq];
 	BUG_ON(!cfg->vector);
 
@@ -882,7 +883,7 @@ static void __setup_vector_irq(int cpu)
 	int irq, vector;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < NR_IRQS; ++irq) {
+	for (irq = 0; irq < nr_irqs; ++irq) {
 		if (!cpu_isset(cpu, irq_cfg[irq].domain))
 			continue;
 		vector = irq_cfg[irq].vector;
@@ -1188,7 +1189,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_pin_list *entry = irq_2_pin + i;
 		if (entry->pin < 0)
 			continue;
@@ -1361,7 +1362,7 @@ void __init enable_IO_APIC(void)
 	int i, apic;
 	unsigned long flags;
 
-	for (i = 0; i < PIN_MAP_SIZE; i++) {
+	for (i = 0; i < pin_map_size; i++) {
 		irq_2_pin[i].pin = -1;
 		irq_2_pin[i].next = 0;
 	}
@@ -1655,7 +1656,7 @@ static void ir_irq_migration(struct work
 {
 	int irq;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_desc *desc = irq_desc + irq;
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
@@ -1704,7 +1705,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= NR_IRQS)
+		if (irq >= nr_irqs)
 			continue;
 
 		desc = irq_desc + irq;
@@ -1862,7 +1863,7 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < NR_IRQS ; irq++) {
+	for (irq = 0; irq < nr_irqs ; irq++) {
 		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2276,7 +2277,7 @@ int create_irq(void)
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = (NR_IRQS - 1); new >= 0; new--) {
+	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
 		if (irq_cfg[new].vector != 0)
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -226,7 +226,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 	int overflow, irq = ~regs->orig_ax;
 	struct irq_desc *desc = irq_desc + irq;
 
-	if (unlikely((unsigned)irq >= NR_IRQS)) {
+	if (unlikely((unsigned)irq >= nr_irqs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
 					__func__, irq);
 		BUG();
@@ -271,7 +271,7 @@ int show_interrupts(struct seq_file *p,
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i < nr_irqs) {
 		unsigned any_count = 0;
 
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
@@ -303,7 +303,7 @@ int show_interrupts(struct seq_file *p,
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+	} else if (i == nr_irqs) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", nmi_count(j));
@@ -396,7 +396,7 @@ void fixup_irqs(cpumask_t map)
 	unsigned int irq;
 	static int warned;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		cpumask_t mask;
 		if (irq == 2)
 			continue;
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -81,7 +81,7 @@ int show_interrupts(struct seq_file *p,
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i < nr_irqs) {
 		unsigned any_count = 0;
 
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
@@ -112,7 +112,7 @@ int show_interrupts(struct seq_file *p,
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+	} else if (i == nr_irqs) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
@@ -201,7 +201,7 @@ asmlinkage unsigned int do_IRQ(struct pt
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < NR_IRQS))
+	if (likely(irq < nr_irqs))
 		generic_handle_irq(irq);
 	else {
 		if (!disable_apic)
@@ -224,7 +224,7 @@ void fixup_irqs(cpumask_t map)
 	unsigned int irq;
 	static int warned;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -91,7 +91,7 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (i >= NR_IRQS)
+		if (i >= nr_irqs)
 			break;
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -142,7 +142,7 @@ static void __init init_ISA_irqs (void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		irq_desc[i].status = IRQ_DISABLED;
 		irq_desc[i].action = NULL;
 		irq_desc[i].depth = 1;
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -222,7 +222,7 @@ static void hpet_timer_set_irq(struct hp
 	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
 		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
 
-		if (irq >= NR_IRQS) {
+		if (irq >= nr_irqs) {
 			irq = HPET_MAX_IRQ;
 			break;
 		}
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= NR_IRQS || irq_timer_state[irq] == NULL)
+	if (irq >= nr_irqs || irq_timer_state[irq] == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
@@ -911,7 +911,7 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
-	if (irq >= NR_IRQS || irq_timer_state[irq])
+	if (irq >= nr_irqs || irq_timer_state[irq])
 		return;
 
 	/*
Index: linux-2.6/drivers/char/vr41xx_giu.c
===================================================================
--- linux-2.6.orig/drivers/char/vr41xx_giu.c
+++ linux-2.6/drivers/char/vr41xx_giu.c
@@ -641,7 +641,7 @@ static int __devinit giu_probe(struct pl
 	}
 
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0 || irq >= NR_IRQS)
+	if (irq < 0 || irq >= nr_irqs)
 		return -EBUSY;
 
 	return cascade_irq(irq, giu_get_irq);
Index: linux-2.6/drivers/net/3c59x.c
===================================================================
--- linux-2.6.orig/drivers/net/3c59x.c
+++ linux-2.6/drivers/net/3c59x.c
@@ -90,7 +90,7 @@ static int vortex_debug = 1;
 #include <linux/eisa.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
-#include <asm/irq.h>			/* For NR_IRQS only. */
+#include <asm/irq.h>			/* For nr_irqs only. */
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
@@ -1221,7 +1221,7 @@ static int __devinit vortex_probe1(struc
 	if (print_info)
 		printk(", IRQ %d\n", dev->irq);
 	/* Tell them about an invalid IRQ. */
-	if (dev->irq <= 0 || dev->irq >= NR_IRQS)
+	if (dev->irq <= 0 || dev->irq >= nr_irqs)
 		printk(KERN_WARNING " *** Warning: IRQ %d is unlikely to work! ***\n",
 			   dev->irq);
 
Index: linux-2.6/drivers/net/hamradio/baycom_ser_fdx.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/baycom_ser_fdx.c
+++ linux-2.6/drivers/net/hamradio/baycom_ser_fdx.c
@@ -416,10 +416,10 @@ static int ser12_open(struct net_device
 	if (!dev || !bc)
 		return -ENXIO;
 	if (!dev->base_addr || dev->base_addr > 0xffff-SER12_EXTENT ||
-	    dev->irq < 2 || dev->irq > NR_IRQS) {
+	    dev->irq < 2 || dev->irq > nr_irqs) {
 		printk(KERN_INFO "baycom_ser_fdx: invalid portnumber (max %u) "
 				"or irq (2 <= irq <= %d)\n",
-				0xffff-SER12_EXTENT, NR_IRQS);
+				0xffff-SER12_EXTENT, nr_irqs);
 		return -ENXIO;
 	}
 	if (bc->baud < 300 || bc->baud > 4800) {
Index: linux-2.6/drivers/net/hamradio/scc.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/scc.c
+++ linux-2.6/drivers/net/hamradio/scc.c
@@ -1465,7 +1465,7 @@ static void z8530_init(void)
 	printk(KERN_INFO "Init Z8530 driver: %u channels, IRQ", Nchips*2);
 	
 	flag=" ";
-	for (k = 0; k < NR_IRQS; k++)
+	for (k = 0; k < nr_irqs; k++)
 		if (Ivec[k].used) 
 		{
 			printk("%s%d", flag, k);
@@ -1728,7 +1728,7 @@ static int scc_net_ioctl(struct net_devi
 
 			if (hwcfg.irq == 2) hwcfg.irq = 9;
 
-			if (hwcfg.irq < 0 || hwcfg.irq >= NR_IRQS)
+			if (hwcfg.irq < 0 || hwcfg.irq >= nr_irqs)
 				return -EINVAL;
 				
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
@@ -2148,7 +2148,7 @@ static void __exit scc_cleanup_driver(vo
 		}
 		
 	/* To unload the port must be closed so no real IRQ pending */
-	for (k=0; k < NR_IRQS ; k++)
+	for (k=0; k < nr_irqs ; k++)
 		if (Ivec[k].used) free_irq(k, NULL);
 		
 	local_irq_enable();
Index: linux-2.6/drivers/net/wan/sbni.c
===================================================================
--- linux-2.6.orig/drivers/net/wan/sbni.c
+++ linux-2.6/drivers/net/wan/sbni.c
@@ -318,7 +318,7 @@ sbni_pci_probe( struct net_device  *dev
 				continue;
 		}
 
-		if( pci_irq_line <= 0  ||  pci_irq_line >= NR_IRQS )
+		if( pci_irq_line <= 0  ||  pci_irq_line >= nr_irqs )
 			printk( KERN_WARNING "  WARNING: The PCI BIOS assigned "
 				"this PCI card to IRQ %d, which is unlikely "
 				"to work!.\n"
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -22,7 +22,7 @@ static DEFINE_SPINLOCK(irq_2_ir_lock);
 
 int irq_remapped(int irq)
 {
-	if (irq > NR_IRQS)
+	if (irq > nr_irqs)
 		return 0;
 
 	if (!irq_2_iommu[irq].iommu)
@@ -35,7 +35,7 @@ int get_irte(int irq, struct irte *entry
 {
 	int index;
 
-	if (!entry || irq > NR_IRQS)
+	if (!entry || irq > nr_irqs)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
@@ -126,7 +126,7 @@ int map_irq_to_irte_handle(int irq, u16
 	int index;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -140,7 +140,7 @@ int map_irq_to_irte_handle(int irq, u16
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -158,7 +158,7 @@ int set_irte_irq(int irq, struct intel_i
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -180,7 +180,7 @@ int modify_irte(int irq, struct irte *ir
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -205,7 +205,7 @@ int flush_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -248,7 +248,7 @@ int free_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
Index: linux-2.6/drivers/pcmcia/at91_cf.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/at91_cf.c
+++ linux-2.6/drivers/pcmcia/at91_cf.c
@@ -273,7 +273,7 @@ static int __init at91_cf_probe(struct p
 			goto fail0d;
 		cf->socket.pci_irq = board->irq_pin;
 	} else
-		cf->socket.pci_irq = NR_IRQS + 1;
+		cf->socket.pci_irq = nr_irqs + 1;
 
 	/* pcmcia layer only remaps "real" memory not iospace */
 	cf->socket.io_offset = (unsigned long)
Index: linux-2.6/drivers/pcmcia/vrc4171_card.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/vrc4171_card.c
+++ linux-2.6/drivers/pcmcia/vrc4171_card.c
@@ -639,7 +639,7 @@ static int __devinit vrc4171_card_setup(
 		int irq;
 		options += 4;
 		irq = simple_strtoul(options, &options, 0);
-		if (irq >= 0 && irq < NR_IRQS)
+		if (irq >= 0 && irq < nr_irqs)
 			vrc4171_irq = irq;
 
 		if (*options != ',')
Index: linux-2.6/drivers/rtc/rtc-vr41xx.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-vr41xx.c
+++ linux-2.6/drivers/rtc/rtc-vr41xx.c
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct pl
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= NR_IRQS) {
+	if (aie_irq < 0 || aie_irq >= nr_irqs) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= NR_IRQS)
+	if (pie_irq < 0 || pie_irq >= nr_irqs)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
Index: linux-2.6/drivers/scsi/aha152x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aha152x.c
+++ linux-2.6/drivers/scsi/aha152x.c
@@ -337,7 +337,7 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int
 #else
 #define IRQ_MIN 9
 #if defined(__PPC)
-#define IRQ_MAX (NR_IRQS-1)
+#define IRQ_MAX (nr_irqs-1)
 #else
 #define IRQ_MAX 12
 #endif
Index: linux-2.6/drivers/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250.c
+++ linux-2.6/drivers/serial/8250.c
@@ -2433,7 +2433,7 @@ static void serial8250_config_port(struc
 static int
 serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
 	    ser->type == PORT_STARTECH)
@@ -2964,7 +2964,7 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&serial8250_reg);
Index: linux-2.6/drivers/serial/amba-pl010.c
===================================================================
--- linux-2.6.orig/drivers/serial/amba-pl010.c
+++ linux-2.6/drivers/serial/amba-pl010.c
@@ -512,7 +512,7 @@ static int pl010_verify_port(struct uart
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
Index: linux-2.6/drivers/serial/amba-pl011.c
===================================================================
--- linux-2.6.orig/drivers/serial/amba-pl011.c
+++ linux-2.6/drivers/serial/amba-pl011.c
@@ -572,7 +572,7 @@ static int pl010_verify_port(struct uart
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
Index: linux-2.6/drivers/serial/cpm_uart/cpm_uart_core.c
===================================================================
--- linux-2.6.orig/drivers/serial/cpm_uart/cpm_uart_core.c
+++ linux-2.6/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -589,7 +589,7 @@ static int cpm_uart_verify_port(struct u
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
Index: linux-2.6/drivers/serial/m32r_sio.c
===================================================================
--- linux-2.6.orig/drivers/serial/m32r_sio.c
+++ linux-2.6/drivers/serial/m32r_sio.c
@@ -922,7 +922,7 @@ static void m32r_sio_config_port(struct
 static int
 m32r_sio_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config))
 		return -EINVAL;
@@ -1162,7 +1162,7 @@ static int __init m32r_sio_init(void)
 
 	printk(KERN_INFO "Serial: M32R SIO driver\n");
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&m32r_sio_reg);
Index: linux-2.6/drivers/serial/serial_core.c
===================================================================
--- linux-2.6.orig/drivers/serial/serial_core.c
+++ linux-2.6/drivers/serial/serial_core.c
@@ -741,7 +741,7 @@ static int uart_set_info(struct uart_sta
 	if (port->ops->verify_port)
 		retval = port->ops->verify_port(port, &new_serial);
 
-	if ((new_serial.irq >= NR_IRQS) || (new_serial.irq < 0) ||
+	if ((new_serial.irq >= nr_irqs) || (new_serial.irq < 0) ||
 	    (new_serial.baud_base < 9600))
 		retval = -EINVAL;
 
Index: linux-2.6/drivers/serial/serial_lh7a40x.c
===================================================================
--- linux-2.6.orig/drivers/serial/serial_lh7a40x.c
+++ linux-2.6/drivers/serial/serial_lh7a40x.c
@@ -460,7 +460,7 @@ static int lh7a40xuart_verify_port (stru
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_LH7A40X)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600) /* *** FIXME: is this true? */
 		ret = -EINVAL;
Index: linux-2.6/drivers/serial/sh-sci.c
===================================================================
--- linux-2.6.orig/drivers/serial/sh-sci.c
+++ linux-2.6/drivers/serial/sh-sci.c
@@ -1157,7 +1157,7 @@ static int sci_verify_port(struct uart_p
 {
 	struct sci_port *s = &sci_ports[port->line];
 
-	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > NR_IRQS)
+	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > nr_irqs)
 		return -EINVAL;
 	if (ser->baud_base < 2400)
 		/* No paper tape reader for Mitch.. */
Index: linux-2.6/drivers/serial/ucc_uart.c
===================================================================
--- linux-2.6.orig/drivers/serial/ucc_uart.c
+++ linux-2.6/drivers/serial/ucc_uart.c
@@ -1066,7 +1066,7 @@ static int qe_uart_verify_port(struct ua
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		return -EINVAL;
 
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		return -EINVAL;
 
 	if (ser->baud_base < 9600)
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -139,7 +139,7 @@ static void init_evtchn_cpu_bindings(voi
 #ifdef CONFIG_SMP
 	int i;
 	/* By default all event channels notify CPU#0. */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		irq_desc[i].affinity = cpumask_of_cpu(0);
 #endif
 
@@ -223,12 +223,12 @@ static int find_unbound_irq(void)
 	int irq;
 
 	/* Only allocate from dynirq range */
-	for (irq = 0; irq < NR_IRQS; irq++)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
-	if (irq == NR_IRQS)
-		panic("No available IRQ to bind to: increase NR_IRQS!\n");
+	if (irq == nr_irqs)
+		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
 	return irq;
 }
@@ -761,7 +761,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for (irq = 0; irq < NR_IRQS; irq++)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -793,7 +793,7 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		irq_bindcount[i] = 0;
 
 	irq_ctx_init(smp_processor_id());
Index: linux-2.6/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_misc.c
+++ linux-2.6/fs/proc/proc_misc.c
@@ -503,7 +503,7 @@ static int show_stat(struct seq_file *p,
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
 
-	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
 	if (!per_irq_sum)
 		return -ENOMEM;
 
@@ -525,7 +525,7 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < NR_IRQS; j++) {
+		for (j = 0; j < nr_irqs; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
 			per_irq_sum[j] += temp;
@@ -571,7 +571,7 @@ static int show_stat(struct seq_file *p,
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		seq_printf(p, " %u", per_irq_sum[i]);
 
 	seq_printf(p,
@@ -625,13 +625,13 @@ static const struct file_operations proc
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
-	return (*pos <= NR_IRQS) ? pos : NULL;
+	return (*pos <= nr_irqs) ? pos : NULL;
 }
 
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
-	if (*pos > NR_IRQS)
+	if (*pos > nr_irqs)
 		return NULL;
 	return pos;
 }
Index: linux-2.6/include/asm-x86/irq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq.h
+++ linux-2.6/include/asm-x86/irq.h
@@ -10,6 +10,9 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+extern int pin_map_size;
+extern int first_free_entry;
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -24,6 +24,8 @@
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
 
+extern int nr_irqs;
+
 struct irq_desc;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -38,7 +38,7 @@ unsigned long probe_irq_on(void)
 	 * something may have generated an irq long ago and we want to
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
+	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc + i;
 
 		spin_lock_irq(&desc->lock);
@@ -68,7 +68,7 @@ unsigned long probe_irq_on(void)
 	 * (we must startup again here because if a longstanding irq
 	 * happened in the previous stage, it may have masked itself)
 	 */
-	for (i = NR_IRQS-1; i > 0; i--) {
+	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc + i;
 
 		spin_lock_irq(&desc->lock);
@@ -89,7 +89,7 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		unsigned int status;
 
 		desc = irq_desc + i;
@@ -130,7 +130,7 @@ unsigned int probe_irq_mask(unsigned lon
 	int i;
 
 	mask = 0;
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
@@ -173,7 +173,7 @@ int probe_irq_off(unsigned long val)
 {
 	int i, irq_found = 0, nr_irqs = 0;
 
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -27,7 +27,7 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
@@ -60,7 +60,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
@@ -92,7 +92,7 @@ int set_irq_chip(unsigned int irq, struc
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
@@ -121,7 +121,7 @@ int set_irq_type(unsigned int irq, unsig
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
 	}
@@ -148,7 +148,7 @@ int set_irq_data(unsigned int irq, void
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
 		return -EINVAL;
@@ -174,7 +174,7 @@ int set_irq_msi(unsigned int irq, struct
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
@@ -200,7 +200,7 @@ int set_irq_chip_data(unsigned int irq,
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !desc->chip) {
+	if (irq >= nr_irqs || !desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
 	}
@@ -544,7 +544,7 @@ __set_irq_handler(unsigned int irq, irq_
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
 		return;
@@ -609,7 +609,7 @@ void __init set_irq_noprobe(unsigned int
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
 		return;
@@ -627,7 +627,7 @@ void __init set_irq_probe(unsigned int i
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS) {
+	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
 		return;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -47,6 +47,7 @@ handle_bad_irq(unsigned int irq, struct
  *
  * Controller mappings for all interrupt sources:
  */
+int nr_irqs = NR_IRQS;
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -265,7 +266,7 @@ void early_init_irq_lock_class(void)
 {
 	int i;
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		lockdep_set_class(&irq_desc[i].lock, &irq_desc_lock_class);
 }
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -34,7 +34,7 @@ void synchronize_irq(unsigned int irq)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned int status;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	do {
@@ -143,7 +143,7 @@ void disable_irq_nosync(unsigned int irq
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -171,7 +171,7 @@ void disable_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	disable_irq_nosync(irq);
@@ -214,7 +214,7 @@ void enable_irq(unsigned int irq)
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -290,7 +290,7 @@ int can_request_irq(unsigned int irq, un
 {
 	struct irqaction *action;
 
-	if (irq >= NR_IRQS || irq_desc[irq].status & IRQ_NOREQUEST)
+	if (irq >= nr_irqs || irq_desc[irq].status & IRQ_NOREQUEST)
 		return 0;
 
 	action = irq_desc[irq].action;
@@ -349,7 +349,7 @@ int setup_irq(unsigned int irq, struct i
 	int shared = 0;
 	int ret;
 
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return -EINVAL;
 
 	if (desc->chip == &no_irq_chip)
@@ -503,7 +503,7 @@ void free_irq(unsigned int irq, void *de
 	unsigned long flags;
 
 	WARN_ON(in_interrupt());
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return;
 
 	desc = irq_desc + irq;
@@ -617,7 +617,7 @@ int request_irq(unsigned int irq, irq_ha
 	 */
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
-	if (irq >= NR_IRQS)
+	if (irq >= nr_irqs)
 		return -EINVAL;
 	if (irq_desc[irq].status & IRQ_NOREQUEST)
 		return -EINVAL;
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -234,7 +234,7 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		register_irq_proc(i);
 }
 
Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c
+++ linux-2.6/kernel/irq/resend.c
@@ -33,8 +33,8 @@ static void resend_irqs(unsigned long ar
 	struct irq_desc *desc;
 	int irq;
 
-	while (!bitmap_empty(irqs_resend, NR_IRQS)) {
-		irq = find_first_bit(irqs_resend, NR_IRQS);
+	while (!bitmap_empty(irqs_resend, nr_irqs)) {
+		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
 		desc = irq_desc + irq;
 		local_irq_disable();
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -91,7 +91,7 @@ static int misrouted_irq(int irq)
 	int i;
 	int ok = 0;
 
-	for (i = 1; i < NR_IRQS; i++) {
+	for (i = 1; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 
 		if (i == irq)	/* Already tried */
@@ -107,7 +107,7 @@ static int misrouted_irq(int irq)
 static void poll_spurious_irqs(unsigned long dummy)
 {
 	int i;
-	for (i = 1; i < NR_IRQS; i++) {
+	for (i = 1; i < nr_irqs; i++) {
 		struct irq_desc *desc = irq_desc + i;
 		unsigned int status;
 
