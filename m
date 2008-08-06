Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbYHFIrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbYHFIrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761050AbYHFIo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:44:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763414AbYHFIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AQP5oW+4yHhmfcxi2UacS91CYfCrePI1Su71Xlds94Puoz+khm5Rr8AR9ynWsREV9T
         VO/NCxQJiojLwNhz/y6Ld0/cCUjTxu8FhYJPAVKHW/nCp6rTWtHyDNM+UfGsPuH2gr7v
         PtsYOnWahmziZvd5LCTFFSaWgvZLfe38LTtxQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 08/33] x86: using nr_irqs
Date: Wed,  6 Aug 2008 01:42:50 -0700
Message-Id: <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also add first_free_entry and pin_map_size

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |   26 ++++++++++++++------------
 arch/x86/kernel/io_apic_64.c |   33 +++++++++++++++++----------------
 arch/x86/kernel/irq_32.c     |    8 ++++----
 arch/x86/kernel/irq_64.c     |    8 ++++----
 arch/x86/kernel/irqinit_32.c |    2 +-
 arch/x86/kernel/irqinit_64.c |    2 +-
 include/asm-x86/irq.h        |    3 +++
 7 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 7f0d88c..d5953ff 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -70,6 +70,7 @@ int timer_through_8259 __initdata;
  */
 int sis_apic_bug = -1;
 
+int first_free_entry = NR_IRQS;
 /*
  * # of IRQ routing registers
  */
@@ -100,6 +101,8 @@ static int disable_timer_pin_1 __initdata;
 #define MAX_PLUS_SHARED_IRQS NR_IRQS
 #define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
+int pin_map_size = PIN_MAP_SIZE;
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -213,7 +216,6 @@ static void ioapic_mask_entry(int apic, int pin)
  */
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	static int first_free_entry = NR_IRQS;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
 	while (entry->next)
@@ -222,7 +224,7 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	if (entry->pin != -1) {
 		entry->next = first_free_entry;
 		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= PIN_MAP_SIZE)
+		if (++first_free_entry >= pin_map_size)
 			panic("io_apic.c: whoops");
 	}
 	entry->apic = apic;
@@ -457,7 +459,7 @@ static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
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
@@ -712,8 +714,8 @@ static int __init balanced_irq_init(void)
 		physical_balance = 1;
 
 	for_each_online_cpu(i) {
-		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
-		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
+		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * nr_irqs, GFP_KERNEL);
+		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * nr_irqs, GFP_KERNEL);
 		if (irq_cpu_data[i].irq_delta == NULL || irq_cpu_data[i].last_irq == NULL) {
 			printk(KERN_ERR "balanced_irq_init: out of memory");
 			goto failed;
@@ -1445,7 +1447,7 @@ __apicdebuginit(void) print_IO_APIC(void)
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
@@ -2009,7 +2011,7 @@ static inline void init_IO_APIC_traps(void)
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
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8800743..456f2e7 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -132,6 +132,7 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 #define MAX_PLUS_SHARED_IRQS NR_IRQS
 #define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
+int pin_map_size = PIN_MAP_SIZE;
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -224,7 +225,7 @@ static inline void io_apic_sync(unsigned int apic)
 	int pin;							\
 	struct irq_pin_list *entry = irq_2_pin + irq;			\
 									\
-	BUG_ON(irq >= NR_IRQS);						\
+	BUG_ON(irq >= nr_irqs);						\
 	for (;;) {							\
 		unsigned int reg;					\
 		pin = entry->pin;					\
@@ -301,7 +302,7 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 	int apic, pin;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	for (;;) {
 		unsigned int reg;
 		apic = entry->apic;
@@ -358,19 +359,19 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
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
@@ -634,7 +635,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= NR_IRQS);
+	BUG_ON(best_guess >= nr_irqs);
 	return best_guess;
 }
 
@@ -766,7 +767,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
 	}
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	return irq;
 }
 
@@ -788,7 +789,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
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
@@ -1188,7 +1189,7 @@ __apicdebuginit(void) print_IO_APIC(void)
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
@@ -1655,7 +1656,7 @@ static void ir_irq_migration(struct work_struct *work)
 {
 	int irq;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_desc *desc = irq_desc + irq;
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
@@ -1704,7 +1705,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= NR_IRQS)
+		if (irq >= nr_irqs)
 			continue;
 
 		desc = irq_desc + irq;
@@ -1862,7 +1863,7 @@ static inline void init_IO_APIC_traps(void)
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
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 1cf8c1f..0cff2f4 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -226,7 +226,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 	int overflow, irq = ~regs->orig_ax;
 	struct irq_desc *desc = irq_desc + irq;
 
-	if (unlikely((unsigned)irq >= NR_IRQS)) {
+	if (unlikely((unsigned)irq >= nr_irqs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
 					__func__, irq);
 		BUG();
@@ -271,7 +271,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i < nr_irqs) {
 		unsigned any_count = 0;
 
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
@@ -303,7 +303,7 @@ int show_interrupts(struct seq_file *p, void *v)
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
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 1f78b23..de94c60 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -81,7 +81,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	if (i < NR_IRQS) {
+	if (i < nr_irqs) {
 		unsigned any_count = 0;
 
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
@@ -112,7 +112,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
+	} else if (i == nr_irqs) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
@@ -201,7 +201,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
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
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index d669142..b13d932 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -91,7 +91,7 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (i >= NR_IRQS)
+		if (i >= nr_irqs)
 			break;
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 1f26fd9..48674e6 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,7 +142,7 @@ static void __init init_ISA_irqs (void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		irq_desc[i].status = IRQ_DISABLED;
 		irq_desc[i].action = NULL;
 		irq_desc[i].depth = 1;
diff --git a/include/asm-x86/irq.h b/include/asm-x86/irq.h
index 1e5f290..2a130c4 100644
--- a/include/asm-x86/irq.h
+++ b/include/asm-x86/irq.h
@@ -10,6 +10,9 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+extern int pin_map_size;
+extern int first_free_entry;
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
-- 
1.5.4.5

