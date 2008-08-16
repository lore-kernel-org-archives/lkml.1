Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYHPIDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYHPIDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYHPICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:02:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYHPICv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:02:51 -0400
Date: Sat, 16 Aug 2008 10:02:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] rename io_apic_64.c to io_apic.c
Message-ID: <20080816080221.GA8415@elte.hu>
References: <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-6-git-send-email-yhlu.kernel@gmail.com> <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com>
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

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/Makefile     |    2 
>  arch/x86/kernel/io_apic.c    | 3898 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/io_apic_32.c | 3220 -----------------------------------
>  arch/x86/kernel/io_apic_64.c | 3898 -------------------------------------------
>  4 files changed, 3899 insertions(+), 7119 deletions(-)

very nice stuff!

Could we please make this rename more mechanic? Ie. more intermediate 
changes (or a single change, if it's safe enough) that makes 
io_apic_32.c equal to io_apic_64.c - and _then_ do the rename, ok?

I've looked at the diff (see it below), and there seem to be material 
differences.

Also, the move introduces bogus style that is still present on the 
64-bit side:

-static void mask_IO_APIC_irq(unsigned int irq)
+static void mask_IO_APIC_irq (unsigned int irq)

i'll put it all into tip/irq/sparseirq, to start testing it - but these 
changes _will_ be bisected to so it needs to be as finegrained as 
possible.

	Ingo

1 file changed, 1090 insertions(+), 414 deletions(-)

--- arch/x86/kernel/io_apic_32.c	2008-08-16 09:58:52.000000000 +0200
+++ arch/x86/kernel/io_apic_64.c	2008-08-16 09:58:52.000000000 +0200
@@ -35,7 +35,7 @@
 #include <linux/htirq.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
-#include <linux/jiffies.h>      /* time_after() */
+#include <linux/jiffies.h>	/* time_after() */
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -64,8 +64,8 @@
 #define __apicdebuginit(type) static type __init
 
 /*
- *	Is the SiS APIC rmw bug present ?
- *	-1 = don't know, 0 = no, 1 = yes
+ *      Is the SiS APIC rmw bug present ?
+ *      -1 = don't know, 0 = no, 1 = yes
  */
 int sis_apic_bug = -1;
 
@@ -102,7 +102,7 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BU
 
 int skip_ioapic_setup;
 
-static int __init parse_noapic(char *arg)
+static int __init parse_noapic(char *str)
 {
 	/* disable IO-APIC */
 	disable_ioapic_setup();
@@ -188,7 +188,7 @@ static void __init init_work(void *data)
 	irq_cfgx[legacy_count - 1].next = NULL;
 }
 
-#define for_each_irq_cfg(cfg)           \
+#define for_each_irq_cfg(cfg)		\
 	for (cfg = irq_cfgx; cfg; cfg = cfg->next)
 
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
@@ -262,7 +262,6 @@ static struct irq_cfg *irq_cfg_with_new(
 		irq_cfgx = cfg;
 	cfg->irq = irq;
 	printk(KERN_DEBUG "found new irq_cfg for irq %d\n", cfg->irq);
-
 #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
 	{
 		/* dump the results */
@@ -384,9 +383,9 @@ static inline void io_apic_write(unsigne
  */
 static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
-	volatile struct io_apic __iomem *io_apic = io_apic_base(apic);
-	if (sis_apic_bug)
-		writel(reg, &io_apic->index);
+	struct io_apic __iomem *io_apic = io_apic_base(apic);
+        if (sis_apic_bug)
+                writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
 
@@ -494,11 +493,20 @@ static void __target_IO_APIC_irq(unsigne
 
 		apic = entry->apic;
 		pin = entry->pin;
+#ifdef CONFIG_INTR_REMAP
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(irq))
+			io_apic_write(apic, 0x11 + pin*2, dest);
+#else
 		io_apic_write(apic, 0x11 + pin*2, dest);
+#endif
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin *2, reg);
+		io_apic_modify(apic, 0x10 + pin*2, reg);
 		if (!entry->next)
 			break;
 		entry = entry->next;
@@ -534,7 +542,6 @@ static void set_ioapic_affinity_irq(unsi
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
-
 #endif /* CONFIG_SMP */
 
 /*
@@ -699,7 +706,7 @@ static void __unmask_and_level_IO_APIC_i
 
 #endif
 
-static void mask_IO_APIC_irq(unsigned int irq)
+static void mask_IO_APIC_irq (unsigned int irq)
 {
 	unsigned long flags;
 
@@ -708,7 +715,7 @@ static void mask_IO_APIC_irq(unsigned in
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq(unsigned int irq)
+static void unmask_IO_APIC_irq (unsigned int irq)
 {
 	unsigned long flags;
 
@@ -725,14 +732,13 @@ static void clear_IO_APIC_pin(unsigned i
 	entry = ioapic_read_entry(apic, pin);
 	if (entry.delivery_mode == dest_SMI)
 		return;
-
 	/*
 	 * Disable it in the IO-APIC irq-routing table:
 	 */
 	ioapic_mask_entry(apic, pin);
 }
 
-static void clear_IO_APIC(void)
+static void clear_IO_APIC (void)
 {
 	int apic, pin;
 
@@ -741,7 +747,7 @@ static void clear_IO_APIC(void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && defined(CONFIG_X86_32)
 void send_IPI_self(int vector)
 {
 	unsigned int cfg;
@@ -756,9 +762,9 @@ void send_IPI_self(int vector)
 	 */
 	apic_write(APIC_ICR, cfg);
 }
-#endif /* !CONFIG_SMP */
-
+#endif /* !CONFIG_SMP && CONFIG_X86_32*/
 
+#ifdef CONFIG_X86_32
 /*
  * support for broken MP BIOSs, enables hand-redirection of PIRQ0-7 to
  * specific CPU-side IRQs.
@@ -797,6 +803,75 @@ static int __init ioapic_pirq_setup(char
 }
 
 __setup("pirq=", ioapic_pirq_setup);
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_INTR_REMAP
+/* I/O APIC RTE contents at the OS boot up */
+static struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+
+/*
+ * Saves and masks all the unmasked IO-APIC RTE's
+ */
+int save_mask_IO_APIC_setup(void)
+{
+	union IO_APIC_reg_01 reg_01;
+	unsigned long flags;
+	int apic, pin;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_01.raw = io_apic_read(apic, 1);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		early_ioapic_entries[apic] =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				nr_ioapic_registers[apic], GFP_KERNEL);
+		if (!early_ioapic_entries[apic])
+			return -ENOMEM;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+			struct IO_APIC_route_entry entry;
+
+			entry = early_ioapic_entries[apic][pin] =
+				ioapic_read_entry(apic, pin);
+			if (!entry.mask) {
+				entry.mask = 1;
+				ioapic_write_entry(apic, pin, entry);
+			}
+		}
+	return 0;
+}
+
+void restore_IO_APIC_setup(void)
+{
+	int apic, pin;
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+			ioapic_write_entry(apic, pin,
+					   early_ioapic_entries[apic][pin]);
+}
+
+void reinit_intr_remapped_IO_APIC(int intr_remapping)
+{
+	/*
+	 * for now plain restore of previous settings.
+	 * TBD: In the case of OS enabling interrupt-remapping,
+	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
+	 * table entries. for now, do a plain restore, and wait for
+	 * the setup_IO_APIC_irqs() to do proper initialization.
+	 */
+	restore_IO_APIC_setup();
+}
+#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
@@ -848,7 +923,7 @@ static int __init find_isa_irq_apic(int 
 	}
 	if (i < mp_irq_entries) {
 		int apic;
-		for (apic = 0; apic < nr_ioapics; apic++) {
+		for(apic = 0; apic < nr_ioapics; apic++) {
 			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
 				return apic;
 		}
@@ -867,10 +942,10 @@ int IO_APIC_get_PCI_irq_vector(int bus, 
 {
 	int apic, i, best_guess = -1;
 
-	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, "
-		"slot:%d, pin:%d.\n", bus, slot, pin);
+	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
+		bus, slot, pin);
 	if (test_bit(bus, mp_bus_not_pci)) {
-		printk(KERN_WARNING "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
+		apic_printk(APIC_VERBOSE, "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
@@ -885,7 +960,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, 
 		    !mp_irqs[i].mp_irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].mp_dstirq);
+			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
@@ -902,6 +977,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, 
 	}
 	return best_guess;
 }
+
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
@@ -918,6 +994,7 @@ static int EISA_ELCR(unsigned int irq)
 			"Broken MPtable reports ISA irq %d\n", irq);
 	return 0;
 }
+
 #endif
 
 /* ISA interrupts are always polarity zero edge triggered,
@@ -931,8 +1008,8 @@ static int EISA_ELCR(unsigned int irq)
  * EISA conforming in the MP table, that means its trigger type must
  * be read in from the ELCR */
 
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
-#define default_EISA_polarity(idx)	default_ISA_polarity(idx)
+#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_polarity(idx)      default_ISA_polarity(idx)
 
 /* PCI interrupts are always polarity one level triggered,
  * when listed as conforming in the MP table. */
@@ -940,11 +1017,14 @@ static int EISA_ELCR(unsigned int irq)
 #define default_PCI_trigger(idx)	(1)
 #define default_PCI_polarity(idx)	(1)
 
-/* MCA interrupts are always polarity zero level triggered,
- * when listed as conforming in the MP table. */
+/* EISA interrupts are always polarity zero and can be edge or level
+ * trigger depending on the ELCR value.  If an interrupt is listed as
+ * EISA conforming in the MP table, that means its trigger type must
+ * be read in from the ELCR */
+
+#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_polarity(idx)      default_ISA_polarity(idx)
 
-#define default_MCA_trigger(idx)	(1)
-#define default_MCA_polarity(idx)	default_ISA_polarity(idx)
 
 static int MPBIOS_polarity(int idx)
 {
@@ -954,36 +1034,36 @@ static int MPBIOS_polarity(int idx)
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mp_irqflag & 3) {
-	case 0: /* conforms, ie. bus-type dependent polarity */
-	{
-		polarity = test_bit(bus, mp_bus_not_pci)?
-			default_ISA_polarity(idx):
-			default_PCI_polarity(idx);
-		break;
-	}
-	case 1: /* high active */
+	switch (mp_irqs[idx].mp_irqflag & 3)
 	{
-		polarity = 0;
-		break;
-	}
-	case 2: /* reserved */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		polarity = 1;
-		break;
-	}
-	case 3: /* low active */
-	{
-		polarity = 1;
-		break;
-	}
-	default: /* invalid */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		polarity = 1;
-		break;
-	}
+		case 0: /* conforms, ie. bus-type dependent polarity */
+			if (test_bit(bus, mp_bus_not_pci))
+				polarity = default_ISA_polarity(idx);
+			else
+				polarity = default_PCI_polarity(idx);
+			break;
+		case 1: /* high active */
+		{
+			polarity = 0;
+			break;
+		}
+		case 2: /* reserved */
+		{
+			printk(KERN_WARNING "broken BIOS!!\n");
+			polarity = 1;
+			break;
+		}
+		case 3: /* low active */
+		{
+			polarity = 1;
+			break;
+		}
+		default: /* invalid */
+		{
+			printk(KERN_WARNING "broken BIOS!!\n");
+			polarity = 1;
+			break;
+		}
 	}
 	return polarity;
 }
@@ -996,67 +1076,67 @@ static int MPBIOS_trigger(int idx)
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3) {
-	case 0: /* conforms, ie. bus-type dependent */
+	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
 	{
-		trigger = test_bit(bus, mp_bus_not_pci)?
-				default_ISA_trigger(idx):
-				default_PCI_trigger(idx);
+		case 0: /* conforms, ie. bus-type dependent */
+			if (test_bit(bus, mp_bus_not_pci))
+				trigger = default_ISA_trigger(idx);
+			else
+				trigger = default_PCI_trigger(idx);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		switch (mp_bus_id_to_type[bus]) {
-		case MP_BUS_ISA: /* ISA pin */
-		{
-			/* set before the switch */
+			switch (mp_bus_id_to_type[bus]) {
+				case MP_BUS_ISA: /* ISA pin */
+				{
+					/* set before the switch */
+					break;
+				}
+				case MP_BUS_EISA: /* EISA pin */
+				{
+					trigger = default_EISA_trigger(idx);
+					break;
+				}
+				case MP_BUS_PCI: /* PCI pin */
+				{
+					/* set before the switch */
+					break;
+				}
+				case MP_BUS_MCA: /* MCA pin */
+				{
+					trigger = default_MCA_trigger(idx);
+					break;
+				}
+				default:
+				{
+					printk(KERN_WARNING "broken BIOS!!\n");
+					trigger = 1;
+					break;
+				}
+			}
+#endif
 			break;
-		}
-		case MP_BUS_EISA: /* EISA pin */
+		case 1: /* edge */
 		{
-			trigger = default_EISA_trigger(idx);
+			trigger = 0;
 			break;
 		}
-		case MP_BUS_PCI: /* PCI pin */
+		case 2: /* reserved */
 		{
-			/* set before the switch */
+			printk(KERN_WARNING "broken BIOS!!\n");
+			trigger = 1;
 			break;
 		}
-		case MP_BUS_MCA: /* MCA pin */
+		case 3: /* level */
 		{
-			trigger = default_MCA_trigger(idx);
+			trigger = 1;
 			break;
 		}
-		default:
+		default: /* invalid */
 		{
 			printk(KERN_WARNING "broken BIOS!!\n");
-			trigger = 1;
+			trigger = 0;
 			break;
 		}
 	}
-#endif
-		break;
-	}
-	case 1: /* edge */
-	{
-		trigger = 0;
-		break;
-	}
-	case 2: /* reserved */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		trigger = 1;
-		break;
-	}
-	case 3: /* level */
-	{
-		trigger = 1;
-		break;
-	}
-	default: /* invalid */
-	{
-		printk(KERN_WARNING "broken BIOS!!\n");
-		trigger = 0;
-		break;
-	}
-	}
 	return trigger;
 }
 
@@ -1082,9 +1162,9 @@ static int pin_2_irq(int idx, int apic, 
 	if (mp_irqs[idx].mp_dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
-	if (test_bit(bus, mp_bus_not_pci))
+	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].mp_srcbusirq;
-	else {
+	} else {
 		/*
 		 * PCI IRQs are mapped in order
 		 */
@@ -1092,14 +1172,14 @@ static int pin_2_irq(int idx, int apic, 
 		while (i < apic)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
-
-		/*
-		 * For MPS mode, so far only needed by ES7000 platform
-		 */
-		if (ioapic_renumber_irq)
-			irq = ioapic_renumber_irq(apic, irq);
+                /*
+                 * For MPS mode, so far only needed by ES7000 platform
+                 */
+                if (ioapic_renumber_irq)
+                        irq = ioapic_renumber_irq(apic, irq);
 	}
 
+#ifdef CONFIG_X86_32
 	/*
 	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
 	 */
@@ -1116,6 +1196,8 @@ static int pin_2_irq(int idx, int apic, 
 			}
 		}
 	}
+#endif
+
 	return irq;
 }
 
@@ -1145,74 +1227,70 @@ static int __assign_irq_vector(int irq, 
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-        static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
-        unsigned int old_vector;
-        int cpu;
-        struct irq_cfg *cfg;
-
-        cfg = irq_cfg(irq);
-
-        /* Only try and allocate irqs on cpus that are present */
-        cpus_and(mask, mask, cpu_online_map);
-
-        if ((cfg->move_in_progress) || cfg->move_cleanup_count)
-                return -EBUSY;
-
-        old_vector = cfg->vector;
-        if (old_vector) {
-                cpumask_t tmp;
-                cpus_and(tmp, cfg->domain, mask);
-                if (!cpus_empty(tmp))
-                        return 0;
-        }
+	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	unsigned int old_vector;
+	int cpu;
+	struct irq_cfg *cfg;
+
+	cfg = irq_cfg(irq);
+
+	/* Only try and allocate irqs on cpus that are present */
+	cpus_and(mask, mask, cpu_online_map);
 
-        for_each_cpu_mask_nr(cpu, mask) {
-                cpumask_t domain, new_mask;
-                int new_cpu;
-                int vector, offset;
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+		return -EBUSY;
 
-                domain = vector_allocation_domain(cpu);
-                cpus_and(new_mask, domain, cpu_online_map);
+	old_vector = cfg->vector;
+	if (old_vector) {
+		cpumask_t tmp;
+		cpus_and(tmp, cfg->domain, mask);
+		if (!cpus_empty(tmp))
+			return 0;
+	}
+
+	for_each_cpu_mask_nr(cpu, mask) {
+		cpumask_t domain, new_mask;
+		int new_cpu;
+		int vector, offset;
 
-                vector = current_vector;
-                offset = current_offset;
+		domain = vector_allocation_domain(cpu);
+		cpus_and(new_mask, domain, cpu_online_map);
+
+		vector = current_vector;
+		offset = current_offset;
 next:
-                vector += 8;
-                if (vector >= first_system_vector) {
-                        /* If we run out of vectors on large boxen, must share them. */
-                        offset = (offset + 1) % 8;
-                        vector = FIRST_DEVICE_VECTOR + offset;
-                }
-                if (unlikely(current_vector == vector))
-                        continue;
+		vector += 8;
+		if (vector >= first_system_vector) {
+			/* If we run out of vectors on large boxen, must share them. */
+			offset = (offset + 1) % 8;
+			vector = FIRST_DEVICE_VECTOR + offset;
+		}
+		if (unlikely(current_vector == vector))
+			continue;
 #ifdef CONFIG_X86_64
-                if (vector == IA32_SYSCALL_VECTOR)
-                        goto next;
+		if (vector == IA32_SYSCALL_VECTOR)
+			goto next;
 #else
-                if (vector == SYSCALL_VECTOR)
-                        goto next;
+		if (vector == SYSCALL_VECTOR)
+			goto next;
 #endif
-                for_each_cpu_mask_nr(new_cpu, new_mask)
-                        if (per_cpu(vector_irq, new_cpu)[vector] != -1)
-                                goto next;
-                /* Found one! */
-                current_vector = vector;
-                current_offset = offset;
-                if (old_vector) {
-                        cfg->move_in_progress = 1;
-                        cfg->old_domain = cfg->domain;
-                }
-		printk(KERN_DEBUG "assign_irq_vector: irq %d vector %#x cpu ", irq, vector);
-		for_each_cpu_mask_nr(new_cpu, new_mask) {
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
-			printk(KERN_CONT " %d ", new_cpu);
+		for_each_cpu_mask_nr(new_cpu, new_mask)
+			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+				goto next;
+		/* Found one! */
+		current_vector = vector;
+		current_offset = offset;
+		if (old_vector) {
+			cfg->move_in_progress = 1;
+			cfg->old_domain = cfg->domain;
 		}
-		printk(KERN_CONT "\n");
-                cfg->vector = vector;
-                cfg->domain = domain;
-                return 0;
-        }
-        return -ENOSPC;
+		for_each_cpu_mask_nr(new_cpu, new_mask)
+			per_cpu(vector_irq, new_cpu)[vector] = irq;
+		cfg->vector = vector;
+		cfg->domain = domain;
+		return 0;
+	}
+	return -ENOSPC;
 }
 
 static int assign_irq_vector(int irq, cpumask_t mask)
@@ -1223,7 +1301,6 @@ static int assign_irq_vector(int irq, cp
 	spin_lock_irqsave(&vector_lock, flags);
 	err = __assign_irq_vector(irq, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
-
 	return err;
 }
 
@@ -1269,36 +1346,39 @@ void __setup_vector_irq(int cpu)
 		cfg = irq_cfg(irq);
 		if (!cpu_isset(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
-        }
+	}
 }
 
 static struct irq_chip ioapic_chip;
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip;
+#endif
 
-#define IOAPIC_AUTO	-1
-#define IOAPIC_EDGE	0
-#define IOAPIC_LEVEL	1
+#define IOAPIC_AUTO     -1
+#define IOAPIC_EDGE     0
+#define IOAPIC_LEVEL    1
 
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
 {
-	int apic, idx, pin;
+        int apic, idx, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			idx = find_irq_entry(apic, pin, mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
-				return irq_trigger(idx);
-		}
-	}
-	/*
-	 * nonexistent IRQs are edge default
-	 */
-	return 0;
+        for (apic = 0; apic < nr_ioapics; apic++) {
+                for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+                        idx = find_irq_entry(apic, pin, mp_INT);
+                        if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
+                                return irq_trigger(idx);
+                }
+        }
+        /*
+         * nonexistent IRQs are edge default
+         */
+        return 0;
 }
 #else
 static inline int IO_APIC_irq_trigger(int irq)
 {
-        return 1;
+	return 1;
 }
 #endif
 
@@ -1318,13 +1398,27 @@ static void ioapic_register_intr(int irq
 	else
 		desc->status &= ~IRQ_LEVEL;
 
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		desc->status |= IRQ_MOVE_PCNTXT;
+		if (trigger)
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_fasteoi_irq,
+						     "fasteoi");
+		else
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_edge_irq, "edge");
+		return;
+	}
+#endif
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_fasteoi_irq, "fasteoi");
+					      handle_fasteoi_irq,
+					      "fasteoi");
 	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_edge_irq, "edge");
+					      handle_edge_irq, "edge");
 }
 
 static int setup_ioapic_entry(int apic, int irq,
@@ -1337,11 +1431,45 @@ static int setup_ioapic_entry(int apic, 
 	 */
 	memset(entry,0,sizeof(*entry));
 
-	entry->delivery_mode = INT_DELIVERY_MODE;
-	entry->dest_mode = INT_DEST_MODE;
-	entry->dest = destination;
+#ifdef CONFIG_INTR_REMAP
+	if (intr_remapping_enabled) {
+		struct intel_iommu *iommu = map_ioapic_to_ir(apic);
+		struct irte irte;
+		struct IR_IO_APIC_route_entry *ir_entry =
+			(struct IR_IO_APIC_route_entry *) entry;
+		int index;
+
+		if (!iommu)
+			panic("No mapping iommu for ioapic %d\n", apic);
+
+		index = alloc_irte(iommu, irq, 1);
+		if (index < 0)
+			panic("Failed to allocate IRTE for ioapic %d\n", apic);
+
+		memset(&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = trigger;
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = vector;
+		irte.dest_id = IRTE_DEST(destination);
+
+		modify_irte(irq, &irte);
+
+		ir_entry->index2 = (index >> 15) & 0x1;
+		ir_entry->zero = 0;
+		ir_entry->format = 1;
+		ir_entry->index = (index & 0x7fff);
+	} else
+#endif
+	{
+		entry->delivery_mode = INT_DELIVERY_MODE;
+		entry->dest_mode = INT_DEST_MODE;
+		entry->dest = destination;
+	}
 
-	entry->mask = 0;                                /* enable IRQ */
+	entry->mask = 0;				/* enable IRQ */
 	entry->trigger = trigger;
 	entry->polarity = polarity;
 	entry->vector = vector;
@@ -1351,12 +1479,11 @@ static int setup_ioapic_entry(int apic, 
 	 */
 	if (trigger)
 		entry->mask = 1;
-
 	return 0;
 }
 
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
-                              int trigger, int polarity)
+			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
@@ -1420,10 +1547,10 @@ static void __init setup_IO_APIC_irqs(vo
 		}
 
 		irq = pin_2_irq(idx, apic, pin);
-
+#ifdef CONFIG_X86_32
                 if (multi_timer_check(apic, irq))
                         continue;
-
+#endif
 		add_pin_to_irq(irq, apic, pin);
 
 		setup_IO_APIC_irq(apic, pin, irq,
@@ -1443,6 +1570,11 @@ static void __init setup_timer_IRQ0_pin(
 {
 	struct IO_APIC_route_entry entry;
 
+#ifdef CONFIG_INTR_REMAP
+	if (intr_remapping_enabled)
+		return;
+#endif
+
 	memset(&entry, 0, sizeof(entry));
 
 	/*
@@ -1461,7 +1593,7 @@ static void __init setup_timer_IRQ0_pin(
 	 * The timer IRQ doesn't have to know that behind the
 	 * scene we may have a 8259A-master in AEOI mode ...
 	 */
-	ioapic_register_intr(0, IOAPIC_EDGE);
+	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
 	/*
 	 * Add it to the IO-APIC irq-routing table:
@@ -1501,17 +1633,18 @@ __apicdebuginit(void) print_IO_APIC(void
 	reg_01.raw = io_apic_read(apic, 1);
 	if (reg_01.bits.version >= 0x10)
 		reg_02.raw = io_apic_read(apic, 2);
-	if (reg_01.bits.version >= 0x20)
-		reg_03.raw = io_apic_read(apic, 3);
+        if (reg_01.bits.version >= 0x20)
+                reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
+	printk("\n");
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
 	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
-	printk(KERN_DEBUG ".... register #01: %08X\n", reg_01.raw);
+	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
 	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
@@ -1548,7 +1681,10 @@ __apicdebuginit(void) print_IO_APIC(void
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %02X  ", i, entry.dest);
+		printk(KERN_DEBUG " %02x %03X ",
+			i,
+			entry.dest
+		);
 
 		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
 			entry.mask,
@@ -1567,7 +1703,7 @@ __apicdebuginit(void) print_IO_APIC(void
 		struct irq_pin_list *entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", i);
+		printk(KERN_DEBUG "IRQ%d ", cfg->irq);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
@@ -1614,8 +1750,7 @@ __apicdebuginit(void) print_local_APIC(v
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
-			GET_APIC_ID(v));
+	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
@@ -1624,7 +1759,7 @@ __apicdebuginit(void) print_local_APIC(v
 	v = apic_read(APIC_TASKPRI);
 	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
-	if (APIC_INTEGRATED(ver)) {			/* !82489DX */
+	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
 		v = apic_read(APIC_ARBPRI);
 		printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
 			v & APIC_ARBPRI_MASK);
@@ -1650,9 +1785,10 @@ __apicdebuginit(void) print_local_APIC(v
 	printk(KERN_DEBUG "... APIC IRR field:\n");
 	print_APIC_bitfield(APIC_IRR);
 
-	if (APIC_INTEGRATED(ver)) {		/* !82489DX */
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
+		if (maxlvt > 3)         /* Due to the Pentium erratum 3AP. */
 			apic_write(APIC_ESR, 0);
+
 		v = apic_read(APIC_ESR);
 		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 	}
@@ -1710,11 +1846,11 @@ __apicdebuginit(void) print_PIC(void)
 	v = inb(0xa0) << 8 | inb(0x20);
 	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
 
-	outb(0x0b, 0xa0);
-	outb(0x0b, 0x20);
+	outb(0x0b,0xa0);
+	outb(0x0b,0x20);
 	v = inb(0xa0) << 8 | inb(0x20);
-	outb(0x0a, 0xa0);
-	outb(0x0a, 0x20);
+	outb(0x0a,0xa0);
+	outb(0x0a,0x20);
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 
@@ -1739,16 +1875,19 @@ fs_initcall(print_all_ICs);
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
-	int i, apic;
+	int apic;
 	unsigned long flags;
 
+#ifdef CONFIG_X86_32
+	int i;
 	if (!pirqs_enabled)
 		for (i = 0; i < MAX_PIRQS; i++)
 			pirq_entries[i] = -1;
+#endif
 
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
@@ -1759,7 +1898,7 @@ static void __init enable_IO_APIC(void)
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
@@ -1830,16 +1969,18 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest	      = read_apic_id();
+		entry.dest            = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
 		 */
 		ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin, entry);
 	}
+
 	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
 }
 
+#ifdef CONFIG_X86_32
 /*
  * function to set the IO-APIC physical IDs based on the
  * values stored in the MPC table.
@@ -1940,8 +2081,6 @@ static void __init setup_ioapic_ids_from
 
 		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic, 0, reg_00.raw);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
@@ -1955,6 +2094,7 @@ static void __init setup_ioapic_ids_from
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
 }
+#endif
 
 int no_timer_check __initdata;
 
@@ -1994,9 +2134,10 @@ static int __init timer_irq_works(void)
 	 * might have cached one ExtINT interrupt.  Finally, at
 	 * least one tick may be lost due to delays.
 	 */
+
+	/* jiffies wrap? */
 	if (time_after(jiffies, t1 + 4))
 		return 1;
-
 	return 0;
 }
 
@@ -2014,8 +2155,6 @@ static int __init timer_irq_works(void)
  */
 
 /*
- * Startup quirk:
- *
  * Starting up a edge-triggered IO-APIC interrupt is
  * nasty - we need to make sure that we get the edge.
  * If it is already asserted for some reason, we need
@@ -2023,9 +2162,8 @@ static int __init timer_irq_works(void)
  *
  * This is not complete - we should be able to fake
  * an edge even if it isn't on the 8259A...
- *
- * (We do this for level-triggered IRQs too - it cannot hurt.)
  */
+
 static unsigned int startup_ioapic_irq(unsigned int irq)
 {
 	int was_pending = 0;
@@ -2043,58 +2181,229 @@ static unsigned int startup_ioapic_irq(u
 	return was_pending;
 }
 
+#ifdef CONFIG_X86_64
 static int ioapic_retrigger_irq(unsigned int irq)
 {
-	send_IPI_self(irq_cfg(irq)->vector);
+
+	struct irq_cfg *cfg = irq_cfg(irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
 }
-
-#ifdef CONFIG_SMP
-asmlinkage void smp_irq_move_cleanup_interrupt(void)
+#else
+static int ioapic_retrigger_irq(unsigned int irq)
 {
-	unsigned vector, me;
-	ack_APIC_irq();
-	irq_enter();
-
-	me = smp_processor_id();
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
-		struct irq_desc *desc;
-		struct irq_cfg *cfg;
-		irq = __get_cpu_var(vector_irq)[vector];
+        send_IPI_self(irq_cfg(irq)->vector);
 
-		desc = irq_desc(irq);
-		if (!desc)
-			continue;
+        return 1;
+}
+#endif
 
-		cfg = irq_cfg(irq);
-		spin_lock(&desc->lock);
-		if (!cfg->move_cleanup_count)
-			goto unlock;
+/*
+ * Level and edge triggered IO-APIC interrupts need different handling,
+ * so we use two separate IRQ descriptors. Edge triggered IRQs can be
+ * handled with the level-triggered descriptor, but that one has slightly
+ * more overhead. Level-triggered interrupts cannot be handled with the
+ * edge-triggered handler, without risking IRQ storms and other ugly
+ * races.
+ */
 
-		if ((vector == cfg->vector) && cpu_isset(me, cfg->domain))
-			goto unlock;
+#ifdef CONFIG_SMP
 
-		__get_cpu_var(vector_irq)[vector] = -1;
-		cfg->move_cleanup_count--;
-unlock:
-		spin_unlock(&desc->lock);
-	}
+#ifdef CONFIG_INTR_REMAP
+static void ir_irq_migration(struct work_struct *work);
 
-	irq_exit();
-}
+static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
 
-static void irq_complete_move(unsigned int irq)
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For edge triggered, irq migration is a simple atomic update(of vector
+ * and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we need to modify the io-apic RTE aswell with the update
+ * vector information, along with modifying IRTE with vector and destination.
+ * So irq migration for level triggered is little  bit more complex compared to
+ * edge triggered migration. But the good news is, we use the same algorithm
+ * for level triggered migration as we have today, only difference being,
+ * we now initiate the irq migration from process context instead of the
+ * interrupt context.
+ *
+ * In future, when we do a directed EOI (combined with cpu EOI broadcast
+ * suppression) to the IO-APIC, level triggered irq migration will also be
+ * as simple as edge triggered migration and we can do the irq migration
+ * with a simple atomic update to IO-APIC RTE.
+ */
+static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
-	unsigned vector, me;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+	int modify_ioapic_rte;
+	unsigned int dest;
+	unsigned long flags;
 
-	if (likely(!cfg->move_in_progress))
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
 		return;
 
-	vector = ~get_irq_regs()->orig_ax;
-	me = smp_processor_id();
+	if (get_irte(irq, &irte))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	desc = irq_desc(irq);
+	modify_ioapic_rte = desc->status & IRQ_LEVEL;
+	if (modify_ioapic_rte) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		__target_IO_APIC_irq(irq, dest, cfg->vector);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+	}
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * Modified the IRTE and flushes the Interrupt entry cache.
+	 */
+	modify_irte(irq, &irte);
+
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	desc->affinity = mask;
+}
+
+static int migrate_irq_remapped_level(int irq)
+{
+	int ret = -1;
+	struct irq_desc *desc = irq_desc(irq);
+
+	mask_IO_APIC_irq(irq);
+
+	if (io_apic_level_ack_pending(irq)) {
+		/*
+	 	 * Interrupt in progress. Migrating irq now will change the
+		 * vector information in the IO-APIC RTE and that will confuse
+		 * the EOI broadcast performed by cpu.
+		 * So, delay the irq migration to the next instance.
+		 */
+		schedule_delayed_work(&ir_migration_work, 1);
+		goto unmask;
+	}
+
+	/* everthing is clear. we have right of way */
+	migrate_ioapic_irq(irq, desc->pending_mask);
+
+	ret = 0;
+	desc->status &= ~IRQ_MOVE_PENDING;
+	cpus_clear(desc->pending_mask);
+
+unmask:
+	unmask_IO_APIC_irq(irq);
+	return ret;
+}
+
+static void ir_irq_migration(struct work_struct *work)
+{
+	unsigned int irq;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(irq, desc) {
+		if (desc->status & IRQ_MOVE_PENDING) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&desc->lock, flags);
+			if (!desc->chip->set_affinity ||
+			    !(desc->status & IRQ_MOVE_PENDING)) {
+				desc->status &= ~IRQ_MOVE_PENDING;
+				spin_unlock_irqrestore(&desc->lock, flags);
+				continue;
+			}
+
+			desc->chip->set_affinity(irq, desc, desc->pending_mask);
+			spin_unlock_irqrestore(&desc->lock, flags);
+		}
+	}
+}
+
+/*
+ * Migrates the IRQ destination in the process context.
+ */
+static void set_ir_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+{
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		desc->pending_mask = mask;
+		migrate_irq_remapped_level(irq);
+		return;
+	}
+
+	migrate_ioapic_irq(irq, mask);
+}
+#endif
+
+asmlinkage void smp_irq_move_cleanup_interrupt(void)
+{
+	unsigned vector, me;
+	ack_APIC_irq();
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
+	irq_enter();
+
+	me = smp_processor_id();
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned int irq;
+		struct irq_desc *desc;
+		struct irq_cfg *cfg;
+		irq = __get_cpu_var(vector_irq)[vector];
+
+		desc = irq_desc(irq);
+		if (!desc)
+			continue;
+
+		cfg = irq_cfg(irq);
+		spin_lock(&desc->lock);
+		if (!cfg->move_cleanup_count)
+			goto unlock;
+
+		if ((vector == cfg->vector) && cpu_isset(me, cfg->domain))
+			goto unlock;
+
+		__get_cpu_var(vector_irq)[vector] = -1;
+		cfg->move_cleanup_count--;
+unlock:
+		spin_unlock(&desc->lock);
+	}
+
+	irq_exit();
+}
+
+static void irq_complete_move(unsigned int irq)
+{
+	struct irq_cfg *cfg = irq_cfg(irq);
+	unsigned vector, me;
+
+	if (likely(!cfg->move_in_progress))
+		return;
+
+	vector = ~get_irq_regs()->orig_ax;
+	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
@@ -2107,6 +2416,17 @@ static void irq_complete_move(unsigned i
 #else
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
+#ifdef CONFIG_INTR_REMAP
+static void ack_x2apic_level(unsigned int irq, struct irq_desc *desc)
+{
+	ack_x2APIC_irq();
+}
+
+static void ack_x2apic_edge(unsigned int irq, struct irq_desc *desc)
+{
+	ack_x2APIC_irq();
+}
+#endif
 
 static void ack_apic_edge(unsigned int irq, struct irq_desc *desc)
 {
@@ -2118,55 +2438,55 @@ static void ack_apic_edge(unsigned int i
 #ifdef CONFIG_X86_64
 static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
-        int do_unmask_irq = 0;
+	int do_unmask_irq = 0;
 
-        irq_complete_move(irq);
+	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-        /* If we are moving the irq we need to mask it */
-        if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
-                do_unmask_irq = 1;
-                mask_IO_APIC_irq(irq);
-        }
+	/* If we are moving the irq we need to mask it */
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+		do_unmask_irq = 1;
+		mask_IO_APIC_irq(irq);
+	}
 #endif
 
-        /*
-         * We must acknowledge the irq before we move it or the acknowledge will
-         * not propagate properly.
-         */
-        ack_APIC_irq();
+	/*
+	 * We must acknowledge the irq before we move it or the acknowledge will
+	 * not propagate properly.
+	 */
+	ack_APIC_irq();
 
-        /* Now we can move and renable the irq */
-        if (unlikely(do_unmask_irq)) {
-                /* Only migrate the irq if the ack has been received.
-                 *
-                 * On rare occasions the broadcast level triggered ack gets
-                 * delayed going to ioapics, and if we reprogram the
-                 * vector while Remote IRR is still set the irq will never
-                 * fire again.
-                 *
-                 * To prevent this scenario we read the Remote IRR bit
-                 * of the ioapic.  This has two effects.
-                 * - On any sane system the read of the ioapic will
-                 *   flush writes (and acks) going to the ioapic from
-                 *   this cpu.
-                 * - We get to see if the ACK has actually been delivered.
-                 *
-                 * Based on failed experiments of reprogramming the
-                 * ioapic entry from outside of irq context starting
-                 * with masking the ioapic entry and then polling until
-                 * Remote IRR was clear before reprogramming the
-                 * ioapic I don't trust the Remote IRR bit to be
-                 * completey accurate.
-                 *
-                 * However there appears to be no other way to plug
-                 * this race, so if the Remote IRR bit is not
-                 * accurate and is causing problems then it is a hardware bug
-                 * and you can go talk to the chipset vendor about it.
-                 */
-                if (!io_apic_level_ack_pending(irq))
-                        move_masked_irq(irq, desc);
-                unmask_IO_APIC_irq(irq);
-        }
+	/* Now we can move and renable the irq */
+	if (unlikely(do_unmask_irq)) {
+		/* Only migrate the irq if the ack has been received.
+		 *
+		 * On rare occasions the broadcast level triggered ack gets
+		 * delayed going to ioapics, and if we reprogram the
+		 * vector while Remote IRR is still set the irq will never
+		 * fire again.
+		 *
+		 * To prevent this scenario we read the Remote IRR bit
+		 * of the ioapic.  This has two effects.
+		 * - On any sane system the read of the ioapic will
+		 *   flush writes (and acks) going to the ioapic from
+		 *   this cpu.
+		 * - We get to see if the ACK has actually been delivered.
+		 *
+		 * Based on failed experiments of reprogramming the
+		 * ioapic entry from outside of irq context starting
+		 * with masking the ioapic entry and then polling until
+		 * Remote IRR was clear before reprogramming the
+		 * ioapic I don't trust the Remote IRR bit to be
+		 * completey accurate.
+		 *
+		 * However there appears to be no other way to plug
+		 * this race, so if the Remote IRR bit is not
+		 * accurate and is causing problems then it is a hardware bug
+		 * and you can go talk to the chipset vendor about it.
+		 */
+		if (!io_apic_level_ack_pending(irq))
+			move_masked_irq(irq, desc);
+		unmask_IO_APIC_irq(irq);
+	}
 }
 #else
 atomic_t irq_mis_count;
@@ -2177,25 +2497,25 @@ static void ack_apic_level(unsigned int 
 
 	irq_complete_move(irq);
 	move_native_irq(irq, desc);
-/*
- * It appears there is an erratum which affects at least version 0x11
- * of I/O APIC (that's the 82093AA and cores integrated into various
- * chipsets).  Under certain conditions a level-triggered interrupt is
- * erroneously delivered as edge-triggered one but the respective IRR
- * bit gets set nevertheless.  As a result the I/O unit expects an EOI
- * message but it will never arrive and further interrupts are blocked
- * from the source.  The exact reason is so far unknown, but the
- * phenomenon was observed when two consecutive interrupt requests
- * from a given source get delivered to the same CPU and the source is
- * temporarily disabled in between.
- *
- * A workaround is to simulate an EOI message manually.  We achieve it
- * by setting the trigger mode to edge and then to level when the edge
- * trigger mode gets detected in the TMR of a local APIC for a
- * level-triggered interrupt.  We mask the source for the time of the
- * operation to prevent an edge-triggered interrupt escaping meanwhile.
- * The idea is from Manfred Spraul.  --macro
- */
+	/*
+	* It appears there is an erratum which affects at least version 0x11
+	* of I/O APIC (that's the 82093AA and cores integrated into various
+	* chipsets).  Under certain conditions a level-triggered interrupt is
+	* erroneously delivered as edge-triggered one but the respective IRR
+	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
+	* message but it will never arrive and further interrupts are blocked
+	* from the source.  The exact reason is so far unknown, but the
+	* phenomenon was observed when two consecutive interrupt requests
+	* from a given source get delivered to the same CPU and the source is
+	* temporarily disabled in between.
+	*
+	* A workaround is to simulate an EOI message manually.  We achieve it
+	* by setting the trigger mode to edge and then to level when the edge
+	* trigger mode gets detected in the TMR of a local APIC for a
+	* level-triggered interrupt.  We mask the source for the time of the
+	* operation to prevent an edge-triggered interrupt escaping meanwhile.
+	* The idea is from Manfred Spraul.  --macro
+	*/
 	i = irq_cfg(irq)->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
@@ -2225,6 +2545,20 @@ static struct irq_chip ioapic_chip __rea
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip __read_mostly = {
+	.name 		= "IR-IO-APIC",
+	.startup 	= startup_ioapic_irq,
+	.mask	 	= mask_IO_APIC_irq,
+	.unmask	 	= unmask_IO_APIC_irq,
+	.ack 		= ack_x2apic_edge,
+	.eoi 		= ack_x2apic_level,
+#ifdef CONFIG_SMP
+	.set_affinity 	= set_ir_ioapic_affinity_irq,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+#endif
 
 static inline void init_IO_APIC_traps(void)
 {
@@ -2383,12 +2717,12 @@ static inline void __init unlock_ExtINT_
 
 static int disable_timer_pin_1 __initdata;
 /* Actually the next is obsolete, but keep it for paranoid reasons -AK */
-static int __init parse_disable_timer_pin_1(char *arg)
+static int __init disable_timer_pin_setup(char *arg)
 {
 	disable_timer_pin_1 = 1;
 	return 0;
 }
-early_param("disable_timer_pin_1", parse_disable_timer_pin_1);
+early_param("disable_timer_pin_1", disable_timer_pin_setup);
 
 int timer_through_8259 __initdata;
 
@@ -2397,6 +2731,8 @@ int timer_through_8259 __initdata;
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
  * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
  * fanatically on his truly buggy board.
+ *
+ * FIXME: really need to revamp this for all platforms.
  */
 static inline void __init check_timer(void)
 {
@@ -2408,8 +2744,8 @@ static inline void __init check_timer(vo
 
 	local_irq_save(flags);
 
-	ver = apic_read(APIC_LVR);
-	ver = GET_APIC_VERSION(ver);
+        ver = apic_read(APIC_LVR);
+        ver = GET_APIC_VERSION(ver);
 
 	/*
 	 * get/set the timer IRQ vector:
@@ -2428,7 +2764,9 @@ static inline void __init check_timer(vo
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
+#ifdef CONFIG_X86_32
 	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+#endif
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2447,6 +2785,10 @@ static inline void __init check_timer(vo
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
+#ifdef CONFIG_INTR_REMAP
+		if (intr_remapping_enabled)
+			panic("BIOS bug: timer not connected to IO-APIC");
+#endif
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2473,6 +2815,10 @@ static inline void __init check_timer(vo
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
+#ifdef CONFIG_INTR_REMAP
+		if (intr_remapping_enabled)
+			panic("timer doesn't work through Interrupt-remapped IO-APIC");
+#endif
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
@@ -2512,7 +2858,9 @@ static inline void __init check_timer(vo
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
+#ifdef CONFIG_X86_32
 	timer_ack = 0;
+#endif
 
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
@@ -2570,17 +2918,25 @@ out:
 
 void __init setup_IO_APIC(void)
 {
+
+#ifdef CONFIG_X86_32
 	enable_IO_APIC();
+#else
+	/*
+	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 */
+#endif
 
 	io_apic_irqs = ~PIC_IRQS;
 
-	printk("ENABLING IO-APIC IRQs\n");
-
-	/*
-	 * Set up IO-APIC IRQ routing.
-	 */
-	if (!acpi_ioapic)
-		setup_ioapic_ids_from_mpc();
+	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+        /*
+         * Set up IO-APIC IRQ routing.
+         */
+#ifdef CONFIG_X86_32
+        if (!acpi_ioapic)
+                setup_ioapic_ids_from_mpc();
+#endif
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
@@ -2588,15 +2944,15 @@ void __init setup_IO_APIC(void)
 }
 
 /*
- *	Called after all the initialization is done. If we didnt find any
- *	APIC bugs then we can allow the modify fast path
+ *      Called after all the initialization is done. If we didnt find any
+ *      APIC bugs then we can allow the modify fast path
  */
 
 static int __init io_apic_bug_finalize(void)
 {
-	if (sis_apic_bug == -1)
-		sis_apic_bug = 0;
-	return 0;
+        if (sis_apic_bug == -1)
+                sis_apic_bug = 0;
+        return 0;
 }
 
 late_initcall(io_apic_bug_finalize);
@@ -2605,7 +2961,7 @@ struct sysfs_ioapic_data {
 	struct sys_device dev;
 	struct IO_APIC_route_entry entry[0];
 };
-static struct sysfs_ioapic_data *mp_ioapic_data[MAX_IO_APICS];
+static struct sysfs_ioapic_data * mp_ioapic_data[MAX_IO_APICS];
 
 static int ioapic_suspend(struct sys_device *dev, pm_message_t state)
 {
@@ -2615,8 +2971,8 @@ static int ioapic_suspend(struct sys_dev
 
 	data = container_of(dev, struct sysfs_ioapic_data, dev);
 	entry = data->entry;
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
-		entry[i] = ioapic_read_entry(dev->id, i);
+	for (i = 0; i < nr_ioapic_registers[dev->id]; i ++, entry ++ )
+		*entry = ioapic_read_entry(dev->id, i);
 
 	return 0;
 }
@@ -2653,14 +3009,14 @@ static struct sysdev_class ioapic_sysdev
 
 static int __init ioapic_init_sysfs(void)
 {
-	struct sys_device *dev;
-	int i, size, error = 0;
+	struct sys_device * dev;
+	int i, size, error;
 
 	error = sysdev_class_register(&ioapic_sysdev_class);
 	if (error)
 		return error;
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for (i = 0; i < nr_ioapics; i++ ) {
 		size = sizeof(struct sys_device) + nr_ioapic_registers[i]
 			* sizeof(struct IO_APIC_route_entry);
 		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
@@ -2691,12 +3047,12 @@ device_initcall(ioapic_init_sysfs);
 unsigned int create_irq(unsigned int irq_want)
 {
 	/* Allocate an unused irq */
-	unsigned int irq, new;
+	unsigned int irq;
+	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new;
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
-	/* only can use bus/dev/fn.. when per_cpu vector is used */
 	irq_want = nr_irqs - 1;
 #endif
 
@@ -2729,6 +3085,9 @@ void destroy_irq(unsigned int irq)
 
 	dynamic_irq_cleanup(irq);
 
+#ifdef CONFIG_INTR_REMAP
+	free_irte(irq);
+#endif
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq);
 	spin_unlock_irqrestore(&vector_lock, flags);
@@ -2754,25 +3113,54 @@ static int msi_compose_msg(struct pci_de
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
-	msg->address_hi = MSI_ADDR_BASE_HI;
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		((INT_DEST_MODE == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL:
-			MSI_ADDR_DEST_MODE_LOGICAL) |
-		((INT_DELIVERY_MODE != dest_LowestPrio) ?
-			MSI_ADDR_REDIRECTION_CPU:
-			MSI_ADDR_REDIRECTION_LOWPRI) |
-		MSI_ADDR_DEST_ID(dest);
-
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		((INT_DELIVERY_MODE != dest_LowestPrio) ?
-			MSI_DATA_DELIVERY_FIXED:
-			MSI_DATA_DELIVERY_LOWPRI) |
-		MSI_DATA_VECTOR(cfg->vector);
-
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irte irte;
+		int ir_index;
+		u16 sub_handle;
+
+		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+		BUG_ON(ir_index == -1);
+
+		memset (&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = 0; /* edge */
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = cfg->vector;
+		irte.dest_id = IRTE_DEST(dest);
+
+		modify_irte(irq, &irte);
+
+		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->data = sub_handle;
+		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_SHV |
+				  MSI_ADDR_IR_INDEX1(ir_index) |
+				  MSI_ADDR_IR_INDEX2(ir_index);
+	} else
+#endif
+	{
+		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->address_lo =
+			MSI_ADDR_BASE_LO |
+			((INT_DEST_MODE == 0) ?
+				MSI_ADDR_DEST_MODE_PHYSICAL:
+				MSI_ADDR_DEST_MODE_LOGICAL) |
+			((INT_DELIVERY_MODE != dest_LowestPrio) ?
+				MSI_ADDR_REDIRECTION_CPU:
+				MSI_ADDR_REDIRECTION_LOWPRI) |
+			MSI_ADDR_DEST_ID(dest);
+
+		msg->data =
+			MSI_DATA_TRIGGER_EDGE |
+			MSI_DATA_LEVEL_ASSERT |
+			((INT_DELIVERY_MODE != dest_LowestPrio) ?
+				MSI_DATA_DELIVERY_FIXED:
+				MSI_DATA_DELIVERY_LOWPRI) |
+			MSI_DATA_VECTOR(cfg->vector);
+	}
 	return err;
 }
 
@@ -2805,6 +3193,56 @@ static void set_msi_irq_affinity(unsigne
 	write_msi_msg(irq, &msg);
 	desc->affinity = mask;
 }
+
+#ifdef CONFIG_INTR_REMAP
+/*
+ * Migrate the MSI irq to another cpumask. This migration is
+ * done in the process context using interrupt-remapping hardware.
+ */
+static void ir_set_msi_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+{
+	struct irq_cfg *cfg;
+	unsigned int dest;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (get_irte(irq, &irte))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * atomically update the IRTE with the new destination and vector.
+	 */
+	modify_irte(irq, &irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	desc->affinity = mask;
+}
+#endif
 #endif /* CONFIG_SMP */
 
 /*
@@ -2822,6 +3260,45 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip msi_ir_chip = {
+	.name		= "IR-PCI-MSI",
+	.unmask		= unmask_msi_irq,
+	.mask		= mask_msi_irq,
+	.ack		= ack_x2apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity	= ir_set_msi_irq_affinity,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+
+/*
+ * Map the PCI dev to the corresponding remapping hardware unit
+ * and allocate 'nvec' consecutive interrupt-remapping table entries
+ * in it.
+ */
+static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
+{
+	struct intel_iommu *iommu;
+	int index;
+
+	iommu = map_dev_to_ir(dev);
+	if (!iommu) {
+		printk(KERN_ERR
+		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		return -ENOENT;
+	}
+
+	index = alloc_irte(iommu, irq, nvec);
+	if (index < 0) {
+		printk(KERN_ERR
+		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		        pci_name(dev));
+		return -ENOSPC;
+	}
+	return index;
+}
+#endif
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 {
@@ -2835,7 +3312,17 @@ static int setup_msi_irq(struct pci_dev 
 	set_irq_msi(irq, desc);
 	write_msi_msg(irq, &msg);
 
-	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irq_desc *desc = irq_desc(irq);
+		/*
+		 * irq migration in process context
+		 */
+		desc->status |= IRQ_MOVE_PCNTXT;
+		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
+	} else
+#endif
+		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
 	return 0;
 }
@@ -2854,58 +3341,162 @@ static unsigned int build_irq_for_pci_de
 
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	int irq, ret;
-        unsigned int irq_want;
-
-        irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	unsigned int irq;
+	int ret;
+	unsigned int irq_want;
 
-        irq = create_irq(irq_want);
+	irq_want = build_irq_for_pci_dev(dev) + 0x100;
 
+	irq = create_irq(irq_want);
 	if (irq == 0)
 		return -1;
 
+#ifdef CONFIG_INTR_REMAP
+	if (!intr_remapping_enabled)
+		goto no_ir;
+
+	ret = msi_alloc_irte(dev, irq, 1);
+	if (ret < 0)
+		goto error;
+no_ir:
+#endif
 	ret = setup_msi_irq(dev, desc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
-        }
-
+	}
 	return 0;
+
+#ifdef CONFIG_INTR_REMAP
+error:
+	destroy_irq(irq);
+	return ret;
+#endif
 }
 
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-        unsigned int irq;
-        int ret, sub_handle;
-        struct msi_desc *desc;
-        unsigned int irq_want;
-
-        irq_want = build_irq_for_pci_dev(dev) + 0x100;
-        sub_handle = 0;
-        list_for_each_entry(desc, &dev->msi_list, list) {
-                irq = create_irq(irq_want--);
-                if (irq == 0)
-                        return -1;
-                ret = setup_msi_irq(dev, desc, irq);
-                if (ret < 0)
-                        goto error;
-                sub_handle++;
-        }
-        return 0;
+	unsigned int irq;
+	int ret, sub_handle;
+	struct msi_desc *desc;
+	unsigned int irq_want;
+
+#ifdef CONFIG_INTR_REMAP
+	struct intel_iommu *iommu = 0;
+	int index = 0;
+#endif
+
+	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	sub_handle = 0;
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		irq = create_irq(irq_want--);
+		if (irq == 0)
+			return -1;
+#ifdef CONFIG_INTR_REMAP
+		if (!intr_remapping_enabled)
+			goto no_ir;
+
+		if (!sub_handle) {
+			/*
+			 * allocate the consecutive block of IRTE's
+			 * for 'nvec'
+			 */
+			index = msi_alloc_irte(dev, irq, nvec);
+			if (index < 0) {
+				ret = index;
+				goto error;
+			}
+		} else {
+			iommu = map_dev_to_ir(dev);
+			if (!iommu) {
+				ret = -ENOENT;
+				goto error;
+			}
+			/*
+			 * setup the mapping between the irq and the IRTE
+			 * base index, the sub_handle pointing to the
+			 * appropriate interrupt remap table entry.
+			 */
+			set_irte_irq(irq, iommu, index, sub_handle);
+		}
+no_ir:
+#endif
+		ret = setup_msi_irq(dev, desc, irq);
+		if (ret < 0)
+			goto error;
+		sub_handle++;
+	}
+	return 0;
 
 error:
-        destroy_irq(irq);
-        return ret;
+	destroy_irq(irq);
+	return ret;
 }
 
-
 void arch_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
 
-#endif /* CONFIG_PCI_MSI */
+#ifdef CONFIG_DMAR
+#ifdef CONFIG_SMP
+static void dmar_msi_set_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+{
+	struct irq_cfg *cfg;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
 
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+	desc->affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip dmar_msi_type = {
+	.name = "DMAR_MSI",
+	.unmask = dmar_msi_unmask,
+	.mask = dmar_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = dmar_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+		"edge");
+	return 0;
+}
+#endif
+
+#endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
  */
@@ -2968,7 +3559,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 	tmp = TARGET_CPUS;
 	err = assign_irq_vector(irq, tmp);
-	if ( !err) {
+	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
@@ -3001,11 +3592,12 @@ int arch_setup_ht_irq(unsigned int irq, 
 #endif /* CONFIG_HT_IRQ */
 
 /* --------------------------------------------------------------------------
-			ACPI-based IOAPIC Configuration
+                          ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
 
 #ifdef CONFIG_ACPI
 
+#ifdef CONFIG_X86_32
 int __init io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
@@ -3080,7 +3672,6 @@ int __init io_apic_get_unique_id(int ioa
 	return apic_id;
 }
 
-
 int __init io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3092,9 +3683,9 @@ int __init io_apic_get_version(int ioapi
 
 	return reg_01.bits.version;
 }
+#endif
 
-
-int __init io_apic_get_redir_entries(int ioapic)
+int __init io_apic_get_redir_entries (int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3107,10 +3698,10 @@ int __init io_apic_get_redir_entries(int
 }
 
 
-int io_apic_set_pci_routing(int ioapic, int pin, int irq, int triggering, int polarity)
+int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
 	if (!IO_APIC_IRQ(irq)) {
-		printk(KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
 		return -EINVAL;
 	}
@@ -3126,6 +3717,7 @@ int io_apic_set_pci_routing(int ioapic, 
 	return 0;
 }
 
+
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
 	int i;
@@ -3178,13 +3770,56 @@ void __init setup_ioapic_dest(void)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
+#ifdef CONFIG_INTR_REMAP
+			else if (intr_remapping_enabled) {
+				desc = irq_desc(irq);
+				set_ir_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
+			}
+#endif
 			else {
 				desc = irq_desc(irq);
 				set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
 			}
 		}
+	}
+}
+#endif
+
+#ifdef CONFIG_X86_64
+#define IOAPIC_RESOURCE_NAME_SIZE 11
+
+static struct resource *ioapic_resources;
+
+static struct resource * __init ioapic_setup_resources(void)
+{
+	unsigned long n;
+	struct resource *res;
+	char *mem;
+	int i;
+
+	if (nr_ioapics <= 0)
+		return NULL;
 
+	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
+	n *= nr_ioapics;
+
+	mem = alloc_bootmem(n);
+	res = (void *)mem;
+
+	if (mem != NULL) {
+		mem += sizeof(struct resource) * nr_ioapics;
+
+		for (i = 0; i < nr_ioapics; i++) {
+			res[i].name = mem;
+			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			sprintf(mem,  "IOAPIC %u", i);
+			mem += IOAPIC_RESOURCE_NAME_SIZE;
+		}
 	}
+
+	ioapic_resources = res;
+
+	return res;
 }
 #endif
 
@@ -3192,29 +3827,70 @@ void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	int i;
+#ifdef CONFIG_X86_64
+	struct resource *ioapic_res;
 
+	ioapic_res = ioapic_setup_resources();
+#endif
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].mp_apicaddr;
-			if (!ioapic_phys) {
-				printk(KERN_ERR
-				       "WARNING: bogus zero IO-APIC "
-				       "address found in MPTABLE, "
-				       "disabling IO/APIC support!\n");
-				smp_found_config = 0;
-				skip_ioapic_setup = 1;
-				goto fake_ioapic_page;
-			}
+#ifdef CONFIG_X86_32
+                        if (!ioapic_phys) {
+                                printk(KERN_ERR
+                                       "WARNING: bogus zero IO-APIC "
+                                       "address found in MPTABLE, "
+                                       "disabling IO/APIC support!\n");
+                                smp_found_config = 0;
+                                skip_ioapic_setup = 1;
+                                goto fake_ioapic_page;
+                        }
+#endif
 		} else {
+#ifdef CONFIG_X86_32
 fake_ioapic_page:
+#endif
 			ioapic_phys = (unsigned long)
-				      alloc_bootmem_pages(PAGE_SIZE);
+				alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
-		printk(KERN_DEBUG "mapped IOAPIC to %08lx (%08lx)\n",
-		       __fix_to_virt(idx), ioapic_phys);
+		apic_printk(APIC_VERBOSE,
+			    "mapped IOAPIC to %08lx (%08lx)\n",
+			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
+
+#ifdef CONFIG_X86_64
+		if (ioapic_res != NULL) {
+			ioapic_res->start = ioapic_phys;
+			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+			ioapic_res++;
+		}
+#endif
 	}
 }
 
+#ifdef CONFIG_X86_64
+static int __init ioapic_insert_resources(void)
+{
+	int i;
+	struct resource *r = ioapic_resources;
+
+	if (!r) {
+		printk(KERN_ERR
+		       "IO APIC resources could be not be allocated.\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_ioapics; i++) {
+		insert_resource(&iomem_resource, r);
+		r++;
+	}
+
+	return 0;
+}
+
+/* Insert the IO APIC resources after PCI initialization has occured to handle
+ * IO APICS that are mapped in on a BAR in PCI space. */
+late_initcall(ioapic_insert_resources);
+#endif
