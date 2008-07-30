Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYG3Ejo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYG3Ejo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYG3Ejf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:39:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:17615 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYG3Ejc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Y3339EnOKdjErD5eFNepzArOg1IcsSNzLihbW6wGA/j6Sq4L5qgqUDubK4wcmO67rn
         P3s9fx/UyQloeAgO8Glw/p0au1XZgIekwG4AIT5O1JyS8t4+Qs/LazJF4ygrzcVpA/AL
         NyPlXeEKP6WwzSSAscV71o31yjukrsfiyPdE8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: RFC [PATCH] x86: introduce nr_irqs for 64bit
Date: Tue, 29 Jul 2008 21:38:41 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com>
In-Reply-To: <200807291414.55479.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292138.41720.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


add DEFINE_DYN_ARRAY for dynamical array support

todo:
1. convert x86 32bit and other arch
2. nr_irqs auto probe via acpi_oem_check?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c      |    1 
 arch/x86/kernel/io_apic_64.c      |   59 ++++++++++++++++++++++++--------------
 arch/x86/kernel/irq_64.c          |    8 ++---
 arch/x86/kernel/irqinit_64.c      |    2 -
 arch/x86/kernel/setup.c           |    7 ++++
 arch/x86/kernel/vmlinux_64.lds.S  |    3 +
 drivers/char/hpet.c               |    2 -
 drivers/char/random.c             |    4 +-
 drivers/pci/intr_remapping.c      |   22 +++++++-------
 drivers/serial/8250.c             |    8 +++--
 drivers/serial/serial_core.c      |    2 -
 drivers/xen/events.c              |   12 +++----
 fs/proc/proc_misc.c               |   10 +++---
 include/asm-generic/vmlinux.lds.h |    7 ++++
 include/asm-x86/irq.h             |    4 ++
 include/asm-x86/irq_vectors.h     |   14 +++------
 include/linux/init.h              |   23 ++++++++++++++
 include/linux/irq.h               |    2 -
 init/main.c                       |   20 ++++++++++++
 kernel/irq/autoprobe.c            |   10 +++---
 kernel/irq/chip.c                 |   20 ++++++------
 kernel/irq/handle.c               |   34 +++++++++++++++------
 kernel/irq/manage.c               |   16 +++++-----
 kernel/irq/proc.c                 |    2 -
 kernel/irq/resend.c               |    4 +-
 kernel/irq/spurious.c             |    4 +-
 26 files changed, 199 insertions(+), 101 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -70,6 +70,7 @@ int timer_through_8259 __initdata;
  */
 int sis_apic_bug = -1;
 
+int nr_irqs = NR_IRQS;
 /*
  * # of IRQ routing registers
  */
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -66,7 +66,7 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
+static struct irq_cfg irq_cfg_legacy[] __initdata = {
 	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
 	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
 	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
@@ -85,6 +85,19 @@ static struct irq_cfg irq_cfg[NR_IRQS] _
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
+static struct irq_cfg *irq_cfg;
+
+int nr_irqs;
+
+static void __init init_work(void *data)
+{
+	struct dyn_array *da = data;
+
+	memcpy(*da->name, irq_cfg_legacy, sizeof(irq_cfg_legacy));
+}
+
+DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+
 static int assign_irq_vector(int irq, cpumask_t mask);
 
 int first_system_vector = 0xfe;
@@ -129,8 +142,8 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
  */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
+
+int pin_map_size;
 
 /*
  * This is performance-critical, we want to do it O(1)
@@ -140,8 +153,12 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
  */
 
 static struct irq_pin_list {
-	short apic, pin, next;
-} irq_2_pin[PIN_MAP_SIZE];
+	short apic, pin;
+	int next;
+} *irq_2_pin;
+
+DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);
+
 
 struct io_apic {
 	unsigned int index;
@@ -224,7 +241,7 @@ static inline void io_apic_sync(unsigned
 	int pin;							\
 	struct irq_pin_list *entry = irq_2_pin + irq;			\
 									\
-	BUG_ON(irq >= NR_IRQS);						\
+	BUG_ON(irq >= nr_irqs);						\
 	for (;;) {							\
 		unsigned int reg;					\
 		pin = entry->pin;					\
@@ -301,7 +318,7 @@ static void __target_IO_APIC_irq(unsigne
 	int apic, pin;
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	for (;;) {
 		unsigned int reg;
 		apic = entry->apic;
@@ -358,19 +375,19 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
+int first_free_entry;
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
@@ -634,7 +651,7 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= NR_IRQS);
+	BUG_ON(best_guess >= nr_irqs);
 	return best_guess;
 }
 
@@ -766,7 +783,7 @@ static int pin_2_irq(int idx, int apic,
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
 	}
-	BUG_ON(irq >= NR_IRQS);
+	BUG_ON(irq >= nr_irqs);
 	return irq;
 }
 
@@ -788,7 +805,7 @@ static int __assign_irq_vector(int irq,
 	int cpu;
 	struct irq_cfg *cfg;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
+	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = &irq_cfg[irq];
 
 	/* Only try and allocate irqs on cpus that are present */
@@ -862,7 +879,7 @@ static void __clear_irq_vector(int irq)
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON((unsigned)irq >= NR_IRQS);
+	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = &irq_cfg[irq];
 	BUG_ON(!cfg->vector);
 
@@ -882,7 +899,7 @@ static void __setup_vector_irq(int cpu)
 	int irq, vector;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < NR_IRQS; ++irq) {
+	for (irq = 0; irq < nr_irqs; ++irq) {
 		if (!cpu_isset(cpu, irq_cfg[irq].domain))
 			continue;
 		vector = irq_cfg[irq].vector;
@@ -1188,7 +1205,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		struct irq_pin_list *entry = irq_2_pin + i;
 		if (entry->pin < 0)
 			continue;
@@ -1361,7 +1378,7 @@ void __init enable_IO_APIC(void)
 	int i, apic;
 	unsigned long flags;
 
-	for (i = 0; i < PIN_MAP_SIZE; i++) {
+	for (i = 0; i < pin_map_size; i++) {
 		irq_2_pin[i].pin = -1;
 		irq_2_pin[i].next = 0;
 	}
@@ -1655,7 +1672,7 @@ static void ir_irq_migration(struct work
 {
 	int irq;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_desc *desc = irq_desc + irq;
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
@@ -1704,7 +1721,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= NR_IRQS)
+		if (irq >= nr_irqs)
 			continue;
 
 		desc = irq_desc + irq;
@@ -1862,7 +1879,7 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < NR_IRQS ; irq++) {
+	for (irq = 0; irq < nr_irqs ; irq++) {
 		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2276,7 +2293,7 @@ int create_irq(void)
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = (NR_IRQS - 1); new >= 0; new--) {
+	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
 		if (irq_cfg[new].vector != 0)
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
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -856,7 +856,14 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	prefill_possible_map();
+
 #ifdef CONFIG_X86_64
+	/* need to wait for nr_cpu_ids settle down */
+	nr_irqs = NR_VECTORS * nr_cpu_ids;
+	pin_map_size = nr_irqs * 2;
+	first_free_entry = nr_irqs;
+	printk(KERN_INFO "nr_irqs: %d\n", nr_irqs);
+	pre_alloc_dyn_array();
 	init_cpu_to_node();
 #endif
 
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -174,6 +174,9 @@ SECTIONS
 	*(.x86cpuvendor.init)
   }
   __x86cpuvendor_end = .;
+
+  DYN_ARRAY_INIT(8)
+
   SECURITY_INIT
 
   . = ALIGN(8);
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
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -11,18 +11,20 @@ static struct ioapic_scope ir_ioapic[MAX
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
-static struct {
+static struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
 	u16 sub_handle;
 	u8  irte_mask;
-} irq_2_iommu[NR_IRQS];
+} *irq_2_iommu;
+
+DEFINE_DYN_ARRAY(irq_2_iommu, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
 int irq_remapped(int irq)
 {
-	if (irq > NR_IRQS)
+	if (irq > nr_irqs)
 		return 0;
 
 	if (!irq_2_iommu[irq].iommu)
@@ -35,7 +37,7 @@ int get_irte(int irq, struct irte *entry
 {
 	int index;
 
-	if (!entry || irq > NR_IRQS)
+	if (!entry || irq > nr_irqs)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
@@ -126,7 +128,7 @@ int map_irq_to_irte_handle(int irq, u16
 	int index;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -140,7 +142,7 @@ int map_irq_to_irte_handle(int irq, u16
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -158,7 +160,7 @@ int set_irte_irq(int irq, struct intel_i
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -180,7 +182,7 @@ int modify_irte(int irq, struct irte *ir
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -205,7 +207,7 @@ int flush_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -248,7 +250,7 @@ int free_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
Index: linux-2.6/drivers/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250.c
+++ linux-2.6/drivers/serial/8250.c
@@ -149,7 +149,9 @@ struct irq_info {
 	struct list_head	*head;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+static struct irq_info *irq_lists;
+
+DEFINE_DYN_ARRAY(irq_lists, sizeof(struct irq_info), nr_irqs, sizeof(struct irq_info), NULL);
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -2433,7 +2435,7 @@ static void serial8250_config_port(struc
 static int
 serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
 	    ser->type == PORT_STARTECH)
@@ -2964,7 +2966,7 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&serial8250_reg);
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
 
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -150,7 +150,7 @@ static void init_evtchn_cpu_bindings(voi
 #ifdef CONFIG_SMP
 	int i;
 	/* By default all event channels notify CPU#0. */
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		irq_desc[i].affinity = cpumask_of_cpu(0);
 #endif
 
@@ -234,12 +234,12 @@ static int find_unbound_irq(void)
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
@@ -772,7 +772,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for (irq = 0; irq < NR_IRQS; irq++)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -804,7 +804,7 @@ void __init xen_init_IRQ(void)
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
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -214,6 +214,13 @@
  * All archs are supposed to use RO_DATA() */
 #define RODATA RO_DATA(4096)
 
+#define DYN_ARRAY_INIT(align)							\
+	. = ALIGN((align));						\
+	.dyn_array.init : AT(ADDR(.dyn_array.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__dyn_array_start) = .;			\
+		*(.dyn_array.init)					\
+		VMLINUX_SYMBOL(__dyn_array_end) = .;			\
+	}
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
Index: linux-2.6/include/asm-x86/irq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq.h
+++ linux-2.6/include/asm-x86/irq.h
@@ -10,6 +10,10 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+extern int nr_irqs;
+extern int pin_map_size;
+extern int first_free_entry;
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
Index: linux-2.6/include/asm-x86/irq_vectors.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq_vectors.h
+++ linux-2.6/include/asm-x86/irq_vectors.h
@@ -113,28 +113,26 @@
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
+#ifdef CONFIG_X86_64
+#  define NR_IRQS		(NR_VECTORS * NR_CPUS)
+#else
 #  define NR_IRQS		224
-
-#  if (224 >= 32 * NR_CPUS)
-#   define NR_IRQ_VECTORS	NR_IRQS
-#  else
-#   define NR_IRQ_VECTORS	(32 * NR_CPUS)
-#  endif
+#endif
 
 # else /* IO_APIC || PARAVIRT */
 
 #  define NR_IRQS		16
-#  define NR_IRQ_VECTORS	NR_IRQS
 
 # endif
 
 #else /* !VISWS && !VOYAGER */
 
 # define NR_IRQS		224
-# define NR_IRQ_VECTORS		NR_IRQS
 
 #endif /* VISWS */
 
+#define NR_IRQ_VECTORS		NR_IRQS
+
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
 #define VIC_CPI_LEVEL0			0
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -249,6 +249,29 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+
+struct dyn_array {
+        void **name;
+        unsigned long size;
+        unsigned int *nr;
+        unsigned long align;
+        void (*init_work)(void *);
+};
+extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
+
+#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+		static struct dyn_array __dyn_array_##nameX __initdata = \
+		{	.name = &nameX,\
+			.size = sizeX,\
+			.nr   = &nrX,\
+			.align = alignX,\
+			.init_work = init_workX,\
+		}; \
+		static struct dyn_array *__dyn_array_ptr_##nameX __used \
+		__attribute__((__section__(".dyn_array.init"))) = \
+			&__dyn_array_##nameX
+
+extern void pre_alloc_dyn_array(void);
 #endif /* __ASSEMBLY__ */
 
 /**
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -179,7 +179,7 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern struct irq_desc irq_desc[NR_IRQS];
+extern struct irq_desc *irq_desc;
 
 /*
  * Migration helpers for obsolete names, they will go away:
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -539,6 +539,26 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+void pre_alloc_dyn_array(void)
+{
+	unsigned long size;
+	struct dyn_array **daa;
+
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("dyna_array %s", da->name);
+		printk(KERN_INFO "%p name:%p size:%lx nr:%d align:%lx",
+			da, da->name, da->size, *da->nr, da->align);
+		*da->name = __alloc_bootmem_nopanic(size, da->align, 16ULL<<20);
+		printk(KERN_CONT "  *name:%p\n", *da->name);
+
+		if (da->init_work)
+			da->init_work(da);
+	}
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
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
@@ -47,19 +47,33 @@ handle_bad_irq(unsigned int irq, struct
  *
  * Controller mappings for all interrupt sources:
  */
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
-	[0 ... NR_IRQS-1] = {
-		.status = IRQ_DISABLED,
-		.chip = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth = 1,
-		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+static struct irq_desc irq_desc_init = {
+	.status = IRQ_DISABLED,
+	.chip = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
 #ifdef CONFIG_SMP
-		.affinity = CPU_MASK_ALL
+	.affinity = CPU_MASK_ALL
 #endif
-	}
 };
 
+static void __init init_work(void *data)
+{
+        struct dyn_array *da = data;
+	int i;
+	struct  irq_desc *desc;
+
+	desc = *da->name;
+
+	for (i = 0; i < *da->nr; i++)
+		memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
+}
+
+struct irq_desc *irq_desc;
+
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -265,7 +279,7 @@ void early_init_irq_lock_class(void)
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
 
