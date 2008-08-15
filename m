Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbYHOXpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbYHOXpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYHOXnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:43:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbYHOXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e+Zox9SWRf2qfiAH9x8mt6/3bZf8KeJEM/2eUsFeFy1kea+S0r2yDq5bnm1wb4jvas
         2Jh1z3FtnVDEi+q+08TZfysVMoWiR6hbVTAI4+8MRNAYTB1d4Z0zji4mF44dCvH+Fi93
         XA06QsMBk9ZWbKpAbmUyvI4t5HS/kxkIH75Vc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/7] x86: make io_apic_64.c and io_apic_32.c the same
Date: Fri, 15 Aug 2008 16:42:40 -0700
Message-Id: <1218843762-14650-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all the same except INTR_REMAPPING related and ioapic io resource

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c |  213 ++++++++++++-
 arch/x86/kernel/io_apic_64.c |  666 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 832 insertions(+), 47 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -123,7 +123,6 @@ struct irq_cfg {
 	u8 move_in_progress : 1;
 };
 
-
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 static struct irq_cfg irq_cfg_legacy[] __initdata = {
 	[0]  = { .irq =  0, .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
@@ -391,6 +390,38 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
+#ifdef CONFIG_X86_64
+static bool io_apic_level_ack_pending(unsigned int irq)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+	struct irq_cfg *cfg = irq_cfg(irq);
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	entry = cfg->irq_2_pin;
+	for (;;) {
+		unsigned int reg;
+		int pin;
+
+		if (!entry)
+			break;
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		/* Is the remote IRR bit set? */
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+			spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return false;
+}
+#endif
+
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -483,17 +514,15 @@ static void set_ioapic_affinity_irq(unsi
 	unsigned int dest;
 	cpumask_t tmp;
 
-	cfg = irq_cfg(irq);
-
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
+	cfg = irq_cfg(irq);
 	if (assign_irq_vector(irq, mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
-
 	dest = cpu_mask_to_apicid(tmp);
 	/*
 	 * Only the high 8 bits are valid.
@@ -572,6 +601,54 @@ static void __init replace_pin_at_irq(un
 		add_pin_to_irq(irq, newapic, newpin);
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Synchronize the IO-APIC and the CPU by doing
+ * a dummy read from the IO-APIC
+ */
+static inline void io_apic_sync(unsigned int apic)
+{
+	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	readl(&io_apic->data);
+}
+
+#define __DO_ACTION(R, ACTION, FINAL)					\
+									\
+{									\
+	int pin;							\
+	struct irq_cfg *cfg;						\
+	struct irq_pin_list *entry;					\
+									\
+	cfg = irq_cfg(irq);						\
+	entry = cfg->irq_2_pin;						\
+	for (;;) {							\
+		unsigned int reg;					\
+		if (!entry)						\
+			break;						\
+		pin = entry->pin;					\
+		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
+		reg ACTION;						\
+		io_apic_modify(entry->apic, 0x10 + R + pin*2, reg);	\
+		FINAL;							\
+		if (!entry->next)					\
+			break;						\
+		entry = entry->next;					\
+	}								\
+}
+
+#define DO_ACTION(name,R,ACTION, FINAL)					\
+									\
+	static void name##_IO_APIC_irq (unsigned int irq)		\
+	__DO_ACTION(R, ACTION, FINAL)
+
+/* mask = 1 */
+DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, io_apic_sync(entry->apic))
+
+/* mask = 0 */
+DO_ACTION(__unmask,	0, &= ~IO_APIC_REDIR_MASKED, )
+
+#else
+
 static void __modify_IO_APIC_irq(unsigned int irq, unsigned long enable, unsigned long disable)
 {
 	struct irq_cfg *cfg;
@@ -620,6 +697,8 @@ static void __unmask_and_level_IO_APIC_i
 				IO_APIC_REDIR_MASKED);
 }
 
+#endif
+
 static void mask_IO_APIC_irq(unsigned int irq)
 {
 	unsigned long flags;
@@ -1055,6 +1134,17 @@ void unlock_vector_lock(void)
 
 static int __assign_irq_vector(int irq, cpumask_t mask)
 {
+	/*
+	 * NOTE! The local APIC isn't very good at handling
+	 * multiple interrupts at the same interrupt level.
+	 * As the interrupt level is determined by taking the
+	 * vector number and shifting that right by 4, we
+	 * want to spread these out a bit so that they don't
+	 * all fall in the same interrupt level.
+	 *
+	 * Also, we've got to be careful not to trash gate
+	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
+	 */
         static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
         unsigned int old_vector;
         int cpu;
@@ -1095,9 +1185,13 @@ next:
                 }
                 if (unlikely(current_vector == vector))
                         continue;
-		if (vector == SYSCALL_VECTOR)
+#ifdef CONFIG_X86_64
+                if (vector == IA32_SYSCALL_VECTOR)
                         goto next;
-
+#else
+                if (vector == SYSCALL_VECTOR)
+                        goto next;
+#endif
                 for_each_cpu_mask_nr(new_cpu, new_mask)
                         if (per_cpu(vector_irq, new_cpu)[vector] != -1)
                                 goto next;
@@ -1184,6 +1278,7 @@ static struct irq_chip ioapic_chip;
 #define IOAPIC_EDGE	0
 #define IOAPIC_LEVEL	1
 
+#ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
 {
 	int apic, idx, pin;
@@ -1200,6 +1295,12 @@ static inline int IO_APIC_irq_trigger(in
 	 */
 	return 0;
 }
+#else
+static inline int IO_APIC_irq_trigger(int irq)
+{
+        return 1;
+}
+#endif
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
@@ -1212,15 +1313,18 @@ static void ioapic_register_intr(int irq
 		desc = irq_desc_with_new(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL) {
+	    trigger == IOAPIC_LEVEL)
 		desc->status |= IRQ_LEVEL;
+	else
+		desc->status &= ~IRQ_LEVEL;
+
+	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
+	    trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
-	} else {
-		desc->status &= ~IRQ_LEVEL;
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
-	}
 }
 
 static int setup_ioapic_entry(int apic, int irq,
@@ -1662,7 +1766,6 @@ static void __init enable_IO_APIC(void)
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
 
-
 			/* If the interrupt line is enabled and in ExtInt mode
 			 * I have found the pin where the i8259 is connected.
 			 */
@@ -2012,6 +2115,60 @@ static void ack_apic_edge(unsigned int i
 	ack_APIC_irq();
 }
 
+#ifdef CONFIG_X86_64
+static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
+{
+        int do_unmask_irq = 0;
+
+        irq_complete_move(irq);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+        /* If we are moving the irq we need to mask it */
+        if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+                do_unmask_irq = 1;
+                mask_IO_APIC_irq(irq);
+        }
+#endif
+
+        /*
+         * We must acknowledge the irq before we move it or the acknowledge will
+         * not propagate properly.
+         */
+        ack_APIC_irq();
+
+        /* Now we can move and renable the irq */
+        if (unlikely(do_unmask_irq)) {
+                /* Only migrate the irq if the ack has been received.
+                 *
+                 * On rare occasions the broadcast level triggered ack gets
+                 * delayed going to ioapics, and if we reprogram the
+                 * vector while Remote IRR is still set the irq will never
+                 * fire again.
+                 *
+                 * To prevent this scenario we read the Remote IRR bit
+                 * of the ioapic.  This has two effects.
+                 * - On any sane system the read of the ioapic will
+                 *   flush writes (and acks) going to the ioapic from
+                 *   this cpu.
+                 * - We get to see if the ACK has actually been delivered.
+                 *
+                 * Based on failed experiments of reprogramming the
+                 * ioapic entry from outside of irq context starting
+                 * with masking the ioapic entry and then polling until
+                 * Remote IRR was clear before reprogramming the
+                 * ioapic I don't trust the Remote IRR bit to be
+                 * completey accurate.
+                 *
+                 * However there appears to be no other way to plug
+                 * this race, so if the Remote IRR bit is not
+                 * accurate and is causing problems then it is a hardware bug
+                 * and you can go talk to the chipset vendor about it.
+                 */
+                if (!io_apic_level_ack_pending(irq))
+                        move_masked_irq(irq, desc);
+                unmask_IO_APIC_irq(irq);
+        }
+}
+#else
 atomic_t irq_mis_count;
 static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
@@ -2053,6 +2210,7 @@ static void ack_apic_level(unsigned int
 		spin_unlock(&ioapic_lock);
 	}
 }
+#endif
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name 		= "IO-APIC",
@@ -2224,7 +2382,7 @@ static inline void __init unlock_ExtINT_
 }
 
 static int disable_timer_pin_1 __initdata;
-
+/* Actually the next is obsolete, but keep it for paranoid reasons -AK */
 static int __init parse_disable_timer_pin_1(char *arg)
 {
 	disable_timer_pin_1 = 1;
@@ -2244,9 +2402,9 @@ static inline void __init check_timer(vo
 {
 	struct irq_cfg *cfg = irq_cfg(0);
 	int apic1, pin1, apic2, pin2;
-	int no_pin1 = 0;
-	unsigned int ver;
 	unsigned long flags;
+	unsigned int ver;
+	int no_pin1 = 0;
 
 	local_irq_save(flags);
 
@@ -2550,6 +2708,7 @@ unsigned int create_irq(unsigned int irq
 		cfg_new = irq_cfg(new);
 		if (cfg_new && cfg_new->vector != 0)
 			continue;
+		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_with_new(new);
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
@@ -2714,6 +2873,32 @@ int arch_setup_msi_irq(struct pci_dev *d
 	return 0;
 }
 
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+        unsigned int irq;
+        int ret, sub_handle;
+        struct msi_desc *desc;
+        unsigned int irq_want;
+
+        irq_want = build_irq_for_pci_dev(dev) + 0x100;
+        sub_handle = 0;
+        list_for_each_entry(desc, &dev->msi_list, list) {
+                irq = create_irq(irq_want--);
+                if (irq == 0)
+                        return -1;
+                ret = setup_msi_irq(dev, desc, irq);
+                if (ret < 0)
+                        goto error;
+                sub_handle++;
+        }
+        return 0;
+
+error:
+        destroy_irq(irq);
+        return ret;
+}
+
+
 void arch_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -94,18 +94,22 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
+#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+int mp_bus_id_to_type[MAX_MP_BUSSES];
+#endif
+
 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 int skip_ioapic_setup;
 
 static int __init parse_noapic(char *str)
 {
+	/* disable IO-APIC */
 	disable_ioapic_setup();
 	return 0;
 }
 early_param("noapic", parse_noapic);
 
-
 struct irq_cfg;
 struct irq_pin_list;
 struct irq_cfg {
@@ -374,6 +378,8 @@ static inline void io_apic_write(unsigne
 /*
  * Re-write a value: to be used for read-modify-write
  * cycles where the read already set up the index register.
+ *
+ * Older SiS APIC requires we rewrite the index register
  */
 static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
@@ -383,6 +389,7 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
+#ifdef CONFIG_X86_64
 static bool io_apic_level_ack_pending(unsigned int irq)
 {
 	struct irq_pin_list *entry;
@@ -412,6 +419,7 @@ static bool io_apic_level_ack_pending(un
 
 	return false;
 }
+#endif
 
 union entry_union {
 	struct { u32 w1, w2; };
@@ -509,7 +517,7 @@ static int assign_irq_vector(int irq, cp
 
 static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -518,12 +526,12 @@ static void set_ioapic_affinity_irq(unsi
 	if (cpus_empty(tmp))
 		return;
 
+	cfg = irq_cfg(irq);
 	if (assign_irq_vector(irq, mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
-
 	/*
 	 * Only the high 8 bits are valid.
 	 */
@@ -534,7 +542,7 @@ static void set_ioapic_affinity_irq(unsi
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
@@ -600,6 +608,7 @@ static void __init replace_pin_at_irq(un
 		add_pin_to_irq(irq, newapic, newpin);
 }
 
+#ifdef CONFIG_X86_64
 /*
  * Synchronize the IO-APIC and the CPU by doing
  * a dummy read from the IO-APIC
@@ -645,6 +654,58 @@ DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MA
 /* mask = 0 */
 DO_ACTION(__unmask,	0, &= ~IO_APIC_REDIR_MASKED, )
 
+#else
+
+static void __modify_IO_APIC_irq(unsigned int irq, unsigned long enable, unsigned long disable)
+{
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
+	unsigned int pin, reg;
+
+	cfg = irq_cfg(irq);
+	entry = cfg->irq_2_pin;
+	for (;;) {
+		if (!entry)
+			break;
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		reg &= ~disable;
+		reg |= enable;
+		io_apic_modify(entry->apic, 0x10 + pin*2, reg);
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+}
+
+/* mask = 1 */
+static void __mask_IO_APIC_irq(unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED, 0);
+}
+
+/* mask = 0 */
+static void __unmask_IO_APIC_irq(unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, 0, IO_APIC_REDIR_MASKED);
+}
+
+/* mask = 1, trigger = 0 */
+static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED,
+				IO_APIC_REDIR_LEVEL_TRIGGER);
+}
+
+/* mask = 0, trigger = 1 */
+static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_LEVEL_TRIGGER,
+				IO_APIC_REDIR_MASKED);
+}
+
+#endif
+
 static void mask_IO_APIC_irq (unsigned int irq)
 {
 	unsigned long flags;
@@ -686,6 +747,64 @@ static void clear_IO_APIC (void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
+#if !defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+void send_IPI_self(int vector)
+{
+	unsigned int cfg;
+
+	/*
+	 * Wait for idle.
+	 */
+	apic_wait_icr_idle();
+	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
+	/*
+	 * Send the IPI. The write to APIC_ICR fires this off.
+	 */
+	apic_write(APIC_ICR, cfg);
+}
+#endif /* !CONFIG_SMP && CONFIG_X86_32*/
+
+#ifdef CONFIG_X86_32
+/*
+ * support for broken MP BIOSs, enables hand-redirection of PIRQ0-7 to
+ * specific CPU-side IRQs.
+ */
+
+#define MAX_PIRQS 8
+static int pirq_entries [MAX_PIRQS];
+static int pirqs_enabled;
+
+static int __init ioapic_pirq_setup(char *str)
+{
+	int i, max;
+	int ints[MAX_PIRQS+1];
+
+	get_options(str, ARRAY_SIZE(ints), ints);
+
+	for (i = 0; i < MAX_PIRQS; i++)
+		pirq_entries[i] = -1;
+
+	pirqs_enabled = 1;
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"PIRQ redirection, working around broken MP-BIOS.\n");
+	max = MAX_PIRQS;
+	if (ints[0] < MAX_PIRQS)
+		max = ints[0];
+
+	for (i = 0; i < max; i++) {
+		apic_printk(APIC_VERBOSE, KERN_DEBUG
+				"... PIRQ%d -> IRQ %d\n", i, ints[i+1]);
+		/*
+		 * PIRQs are mapped upside down, usually.
+		 */
+		pirq_entries[MAX_PIRQS-i-1] = ints[i+1];
+	}
+	return 1;
+}
+
+__setup("pirq=", ioapic_pirq_setup);
+#endif /* CONFIG_X86_32 */
+
 #ifdef CONFIG_INTR_REMAP
 /* I/O APIC RTE contents at the OS boot up */
 static struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
@@ -859,18 +978,54 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 	return best_guess;
 }
 
+EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
+
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+/*
+ * EISA Edge/Level control register, ELCR
+ */
+static int EISA_ELCR(unsigned int irq)
+{
+	if (irq < 16) {
+		unsigned int port = 0x4d0 + (irq >> 3);
+		return (inb(port) >> (irq & 7)) & 1;
+	}
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"Broken MPtable reports ISA irq %d\n", irq);
+	return 0;
+}
+
+#endif
+
 /* ISA interrupts are always polarity zero edge triggered,
  * when listed as conforming in the MP table. */
 
 #define default_ISA_trigger(idx)	(0)
 #define default_ISA_polarity(idx)	(0)
 
+/* EISA interrupts are always polarity zero and can be edge or level
+ * trigger depending on the ELCR value.  If an interrupt is listed as
+ * EISA conforming in the MP table, that means its trigger type must
+ * be read in from the ELCR */
+
+#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_polarity(idx)      default_ISA_polarity(idx)
+
 /* PCI interrupts are always polarity one level triggered,
  * when listed as conforming in the MP table. */
 
 #define default_PCI_trigger(idx)	(1)
 #define default_PCI_polarity(idx)	(1)
 
+/* EISA interrupts are always polarity zero and can be edge or level
+ * trigger depending on the ELCR value.  If an interrupt is listed as
+ * EISA conforming in the MP table, that means its trigger type must
+ * be read in from the ELCR */
+
+#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_polarity(idx)      default_ISA_polarity(idx)
+
+
 static int MPBIOS_polarity(int idx)
 {
 	int bus = mp_irqs[idx].mp_srcbus;
@@ -928,6 +1083,36 @@ static int MPBIOS_trigger(int idx)
 				trigger = default_ISA_trigger(idx);
 			else
 				trigger = default_PCI_trigger(idx);
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
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
 		case 1: /* edge */
 		{
@@ -965,6 +1150,7 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
+int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
@@ -986,7 +1172,32 @@ static int pin_2_irq(int idx, int apic,
 		while (i < apic)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
+                /*
+                 * For MPS mode, so far only needed by ES7000 platform
+                 */
+                if (ioapic_renumber_irq)
+                        irq = ioapic_renumber_irq(apic, irq);
+	}
+
+#ifdef CONFIG_X86_32
+	/*
+	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
+	 */
+	if ((pin >= 16) && (pin <= 23)) {
+		if (pirq_entries[pin-16] != -1) {
+			if (!pirq_entries[pin-16]) {
+				apic_printk(APIC_VERBOSE, KERN_DEBUG
+						"disabling PIRQ%d\n", pin-16);
+			} else {
+				irq = pirq_entries[pin-16];
+				apic_printk(APIC_VERBOSE, KERN_DEBUG
+						"using PIRQ%d -> IRQ %d\n",
+						pin-16, irq);
+			}
+		}
 	}
+#endif
+
 	return irq;
 }
 
@@ -1056,8 +1267,13 @@ next:
 		}
 		if (unlikely(current_vector == vector))
 			continue;
+#ifdef CONFIG_X86_64
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
+#else
+		if (vector == SYSCALL_VECTOR)
+			goto next;
+#endif
 		for_each_cpu_mask_nr(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
@@ -1138,6 +1354,34 @@ static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
 #endif
 
+#define IOAPIC_AUTO     -1
+#define IOAPIC_EDGE     0
+#define IOAPIC_LEVEL    1
+
+#ifdef CONFIG_X86_32
+static inline int IO_APIC_irq_trigger(int irq)
+{
+        int apic, idx, pin;
+
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
+}
+#else
+static inline int IO_APIC_irq_trigger(int irq)
+{
+	return 1;
+}
+#endif
+
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
 	struct irq_desc *desc;
@@ -1148,7 +1392,8 @@ static void ioapic_register_intr(int irq
 	else
 		desc = irq_desc_with_new(irq);
 
-	if (trigger)
+	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
+	    trigger == IOAPIC_LEVEL)
 		desc->status |= IRQ_LEVEL;
 	else
 		desc->status &= ~IRQ_LEVEL;
@@ -1166,7 +1411,8 @@ static void ioapic_register_intr(int irq
 		return;
 	}
 #endif
-	if (trigger)
+	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
+	    trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq,
 					      "fasteoi");
@@ -1301,6 +1547,10 @@ static void __init setup_IO_APIC_irqs(vo
 		}
 
 		irq = pin_2_irq(idx, apic, pin);
+#ifdef CONFIG_X86_32
+                if (multi_timer_check(apic, irq))
+                        continue;
+#endif
 		add_pin_to_irq(irq, apic, pin);
 
 		setup_IO_APIC_irq(apic, pin, irq,
@@ -1358,6 +1608,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
+	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
@@ -1382,6 +1633,8 @@ __apicdebuginit(void) print_IO_APIC(void
 	reg_01.raw = io_apic_read(apic, 1);
 	if (reg_01.bits.version >= 0x10)
 		reg_02.raw = io_apic_read(apic, 2);
+        if (reg_01.bits.version >= 0x20)
+                reg_03.raw = io_apic_read(apic, 3);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
@@ -1397,11 +1650,27 @@ __apicdebuginit(void) print_IO_APIC(void
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
 	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
 
-	if (reg_01.bits.version >= 0x10) {
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
+	 * but the value of reg_02 is read as the previous read register
+	 * value, so ignore it if reg_02 == reg_01.
+	 */
+	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
 		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
 		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
 	}
 
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x2? don't have reg_02
+	 * or reg_03, but the value of reg_0[23] is read as the previous read
+	 * register value, so ignore it if reg_03 == reg_0[12].
+	 */
+	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
+	    reg_03.raw != reg_01.raw) {
+		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
+		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
+	}
+
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
 	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
@@ -1473,7 +1742,7 @@ __apicdebuginit(void) print_APIC_bitfiel
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
-	unsigned long icr;
+	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1490,11 +1759,13 @@ __apicdebuginit(void) print_local_APIC(v
 	v = apic_read(APIC_TASKPRI);
 	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
-	v = apic_read(APIC_ARBPRI);
-	printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-		v & APIC_ARBPRI_MASK);
-	v = apic_read(APIC_PROCPRI);
-	printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
+		v = apic_read(APIC_ARBPRI);
+		printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
+			v & APIC_ARBPRI_MASK);
+		v = apic_read(APIC_PROCPRI);
+		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+	}
 
 	v = apic_read(APIC_EOI);
 	printk(KERN_DEBUG "... APIC EOI: %08x\n", v);
@@ -1514,8 +1785,13 @@ __apicdebuginit(void) print_local_APIC(v
 	printk(KERN_DEBUG "... APIC IRR field:\n");
 	print_APIC_bitfield(APIC_IRR);
 
-	v = apic_read(APIC_ESR);
-	printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
+		if (maxlvt > 3)         /* Due to the Pentium erratum 3AP. */
+			apic_write(APIC_ESR, 0);
+
+		v = apic_read(APIC_ESR);
+		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+	}
 
 	icr = apic_icr_read();
 	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
@@ -1606,6 +1882,13 @@ void __init enable_IO_APIC(void)
 	int apic;
 	unsigned long flags;
 
+#ifdef CONFIG_X86_32
+	int i;
+	if (!pirqs_enabled)
+		for (i = 0; i < MAX_PIRQS; i++)
+			pirq_entries[i] = -1;
+#endif
+
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
@@ -1634,6 +1917,10 @@ void __init enable_IO_APIC(void)
 	}
  found_i8259:
 	/* Look to see what if the MP table has reported the ExtINT */
+	/* If we could not find the appropriate pin by looking at the ioapic
+	 * the i8259 probably is not connected the ioapic but give the
+	 * mptable a chance anyway.
+	 */
 	i8259_pin  = find_isa_irq_pin(0, mp_ExtINT);
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
 	/* Trust the MP table if nothing is setup in the hardware */
@@ -1693,6 +1980,122 @@ void disable_IO_APIC(void)
 	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
 }
 
+#ifdef CONFIG_X86_32
+/*
+ * function to set the IO-APIC physical IDs based on the
+ * values stored in the MPC table.
+ *
+ * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
+ */
+
+static void __init setup_ioapic_ids_from_mpc(void)
+{
+	union IO_APIC_reg_00 reg_00;
+	physid_mask_t phys_id_present_map;
+	int apic;
+	int i;
+	unsigned char old_id;
+	unsigned long flags;
+
+	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
+		return;
+
+	/*
+	 * Don't check I/O APIC IDs for xAPIC systems.  They have
+	 * no meaning without the serial APIC bus.
+	 */
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return;
+	/*
+	 * This is broken; anything with a real cpu count has to
+	 * circumvent this idiocy regardless.
+	 */
+	phys_id_present_map = ioapic_phys_id_map(phys_cpu_present_map);
+
+	/*
+	 * Set the IOAPIC ID to the value stored in the MPC table.
+	 */
+	for (apic = 0; apic < nr_ioapics; apic++) {
+
+		/* Read the register 0 value */
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_00.raw = io_apic_read(apic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		old_id = mp_ioapics[apic].mp_apicid;
+
+		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
+			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
+				apic, mp_ioapics[apic].mp_apicid);
+			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+				reg_00.bits.ID);
+			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
+		}
+
+		/*
+		 * Sanity check, is the ID really free? Every APIC in a
+		 * system must have a unique ID or we get lots of nice
+		 * 'stuck on smp_invalidate_needed IPI wait' messages.
+		 */
+		if (check_apicid_used(phys_id_present_map,
+					mp_ioapics[apic].mp_apicid)) {
+			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
+				apic, mp_ioapics[apic].mp_apicid);
+			for (i = 0; i < get_physical_broadcast(); i++)
+				if (!physid_isset(i, phys_id_present_map))
+					break;
+			if (i >= get_physical_broadcast())
+				panic("Max APIC ID exceeded!\n");
+			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
+				i);
+			physid_set(i, phys_id_present_map);
+			mp_ioapics[apic].mp_apicid = i;
+		} else {
+			physid_mask_t tmp;
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
+			apic_printk(APIC_VERBOSE, "Setting %d in the "
+					"phys_id_present_map\n",
+					mp_ioapics[apic].mp_apicid);
+			physids_or(phys_id_present_map, phys_id_present_map, tmp);
+		}
+
+
+		/*
+		 * We need to adjust the IRQ routing table
+		 * if the ID changed.
+		 */
+		if (old_id != mp_ioapics[apic].mp_apicid)
+			for (i = 0; i < mp_irq_entries; i++)
+				if (mp_irqs[i].mp_dstapic == old_id)
+					mp_irqs[i].mp_dstapic
+						= mp_ioapics[apic].mp_apicid;
+
+		/*
+		 * Read the right value from the MPC table and
+		 * write it into the ID register.
+		 */
+		apic_printk(APIC_VERBOSE, KERN_INFO
+			"...changing IO-APIC physical APIC ID to %d ...",
+			mp_ioapics[apic].mp_apicid);
+
+		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
+		spin_lock_irqsave(&ioapic_lock, flags);
+
+		/*
+		 * Sanity check
+		 */
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_00.raw = io_apic_read(apic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
+			printk("could not set ID!\n");
+		else
+			apic_printk(APIC_VERBOSE, " ok.\n");
+	}
+}
+#endif
+
 int no_timer_check __initdata;
 
 static int __init notimercheck(char *s)
@@ -1778,8 +2181,10 @@ static unsigned int startup_ioapic_irq(u
 	return was_pending;
 }
 
+#ifdef CONFIG_X86_64
 static int ioapic_retrigger_irq(unsigned int irq)
 {
+
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
@@ -1789,6 +2194,14 @@ static int ioapic_retrigger_irq(unsigned
 
 	return 1;
 }
+#else
+static int ioapic_retrigger_irq(unsigned int irq)
+{
+        send_IPI_self(irq_cfg(irq)->vector);
+
+        return 1;
+}
+#endif
 
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
@@ -1948,7 +2361,9 @@ asmlinkage void smp_irq_move_cleanup_int
 {
 	unsigned vector, me;
 	ack_APIC_irq();
+#ifdef CONFIG_X86_64
 	exit_idle();
+#endif
 	irq_enter();
 
 	me = smp_processor_id();
@@ -2020,6 +2435,7 @@ static void ack_apic_edge(unsigned int i
 	ack_APIC_irq();
 }
 
+#ifdef CONFIG_X86_64
 static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
 	int do_unmask_irq = 0;
@@ -2072,6 +2488,49 @@ static void ack_apic_level(unsigned int
 		unmask_IO_APIC_irq(irq);
 	}
 }
+#else
+atomic_t irq_mis_count;
+static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long v;
+	int i;
+
+	irq_complete_move(irq);
+	move_native_irq(irq, desc);
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
+	i = irq_cfg(irq)->vector;
+
+	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
+
+	ack_APIC_irq();
+
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+		spin_lock(&ioapic_lock);
+		__mask_and_edge_IO_APIC_irq(irq);
+		__unmask_and_level_IO_APIC_irq(irq);
+		spin_unlock(&ioapic_lock);
+	}
+}
+#endif
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name 		= "IO-APIC",
@@ -2137,20 +2596,24 @@ static inline void init_IO_APIC_traps(vo
 	}
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+/*
+ * The local APIC irq-chip implementation:
+ */
+
+static void mask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void mask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
 	v = apic_read(APIC_LVT0);
-	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
+	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
 static void ack_lapic_irq(unsigned int irq, struct irq_desc *desc)
@@ -2178,19 +2641,19 @@ static void lapic_register_intr(int irq)
 static void __init setup_nmi(void)
 {
 	/*
- 	 * Dirty trick to enable the NMI watchdog ...
+	 * Dirty trick to enable the NMI watchdog ...
 	 * We put the 8259A master into AEOI mode and
 	 * unmask on all local APICs LVT0 as NMI.
 	 *
 	 * The idea to use the 8259A in AEOI mode ('8259A Virtual Wire')
 	 * is from Maciej W. Rozycki - so we do not have to EOI from
 	 * the NMI handler or the timer interrupt.
-	 */ 
-	printk(KERN_INFO "activating NMI Watchdog ...");
+	 */
+	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
 	enable_NMI_through_LVT0();
 
-	printk(" done.\n");
+	apic_printk(APIC_VERBOSE, " done.\n");
 }
 
 /*
@@ -2207,12 +2670,17 @@ static inline void __init unlock_ExtINT_
 	unsigned char save_control, save_freq_select;
 
 	pin  = find_isa_irq_pin(8, mp_INT);
+	if (pin == -1) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 	apic = find_isa_irq_apic(8, mp_INT);
-	if (pin == -1)
+	if (apic == -1) {
+		WARN_ON_ONCE(1);
 		return;
+	}
 
 	entry0 = ioapic_read_entry(apic, pin);
-
 	clear_IO_APIC_pin(apic, pin);
 
 	memset(&entry1, 0, sizeof(entry1));
@@ -2264,17 +2732,21 @@ int timer_through_8259 __initdata;
  * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
  * fanatically on his truly buggy board.
  *
- * FIXME: really need to revamp this for modern platforms only.
+ * FIXME: really need to revamp this for all platforms.
  */
 static inline void __init check_timer(void)
 {
 	struct irq_cfg *cfg = irq_cfg(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
+	unsigned int ver;
 	int no_pin1 = 0;
 
 	local_irq_save(flags);
 
+        ver = apic_read(APIC_LVR);
+        ver = GET_APIC_VERSION(ver);
+
 	/*
 	 * get/set the timer IRQ vector:
 	 */
@@ -2283,10 +2755,18 @@ static inline void __init check_timer(vo
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
-	 * wire has to be disabled in the local APIC.
+	 * wire has to be disabled in the local APIC.  Also
+	 * timer interrupts need to be acknowledged manually in
+	 * the 8259A for the i82489DX when using the NMI
+	 * watchdog as that APIC treats NMIs as level-triggered.
+	 * The AEOI mode will finish them in the 8259A
+	 * automatically.
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
+#ifdef CONFIG_X86_32
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+#endif
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2378,6 +2858,9 @@ static inline void __init check_timer(vo
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
+#ifdef CONFIG_X86_32
+	timer_ack = 0;
+#endif
 
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
@@ -2431,19 +2914,29 @@ out:
  * the I/O APIC in all cases now.  No actual device should request
  * it anyway.  --macro
  */
-#define PIC_IRQS	(1<<2)
+#define PIC_IRQS	(1 << PIC_CASCADE_IR)
 
 void __init setup_IO_APIC(void)
 {
 
+#ifdef CONFIG_X86_32
+	enable_IO_APIC();
+#else
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
+#endif
 
 	io_apic_irqs = ~PIC_IRQS;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
-
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
@@ -3104,7 +3597,93 @@ int arch_setup_ht_irq(unsigned int irq,
 
 #ifdef CONFIG_ACPI
 
-#define IO_APIC_MAX_ID		0xFE
+#ifdef CONFIG_X86_32
+int __init io_apic_get_unique_id(int ioapic, int apic_id)
+{
+	union IO_APIC_reg_00 reg_00;
+	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
+	physid_mask_t tmp;
+	unsigned long flags;
+	int i = 0;
+
+	/*
+	 * The P4 platform supports up to 256 APIC IDs on two separate APIC
+	 * buses (one for LAPICs, one for IOAPICs), where predecessors only
+	 * supports up to 16 on one shared APIC bus.
+	 *
+	 * TBD: Expand LAPIC/IOAPIC support on P4-class systems to take full
+	 *      advantage of new APIC bus architecture.
+	 */
+
+	if (physids_empty(apic_id_map))
+		apic_id_map = ioapic_phys_id_map(phys_cpu_present_map);
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	reg_00.raw = io_apic_read(ioapic, 0);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	if (apic_id >= get_physical_broadcast()) {
+		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
+			"%d\n", ioapic, apic_id, reg_00.bits.ID);
+		apic_id = reg_00.bits.ID;
+	}
+
+	/*
+	 * Every APIC in a system must have a unique ID or we get lots of nice
+	 * 'stuck on smp_invalidate_needed IPI wait' messages.
+	 */
+	if (check_apicid_used(apic_id_map, apic_id)) {
+
+		for (i = 0; i < get_physical_broadcast(); i++) {
+			if (!check_apicid_used(apic_id_map, i))
+				break;
+		}
+
+		if (i == get_physical_broadcast())
+			panic("Max apic_id exceeded!\n");
+
+		printk(KERN_WARNING "IOAPIC[%d]: apic_id %d already used, "
+			"trying %d\n", ioapic, apic_id, i);
+
+		apic_id = i;
+	}
+
+	tmp = apicid_to_cpu_present(apic_id);
+	physids_or(apic_id_map, apic_id_map, tmp);
+
+	if (reg_00.bits.ID != apic_id) {
+		reg_00.bits.ID = apic_id;
+
+		spin_lock_irqsave(&ioapic_lock, flags);
+		io_apic_write(ioapic, 0, reg_00.raw);
+		reg_00.raw = io_apic_read(ioapic, 0);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		/* Sanity check */
+		if (reg_00.bits.ID != apic_id) {
+			printk("IOAPIC[%d]: Unable to change apic_id!\n", ioapic);
+			return -1;
+		}
+	}
+
+	apic_printk(APIC_VERBOSE, KERN_INFO
+			"IOAPIC[%d]: Assigned apic_id %d\n", ioapic, apic_id);
+
+	return apic_id;
+}
+
+int __init io_apic_get_version(int ioapic)
+{
+	union IO_APIC_reg_01	reg_01;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	reg_01.raw = io_apic_read(ioapic, 1);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return reg_01.bits.version;
+}
+#endif
 
 int __init io_apic_get_redir_entries (int ioapic)
 {
@@ -3206,6 +3785,7 @@ void __init setup_ioapic_dest(void)
 }
 #endif
 
+#ifdef CONFIG_X86_64
 #define IOAPIC_RESOURCE_NAME_SIZE 11
 
 static struct resource *ioapic_resources;
@@ -3241,36 +3821,56 @@ static struct resource * __init ioapic_s
 
 	return res;
 }
+#endif
 
 void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
-	struct resource *ioapic_res;
 	int i;
+#ifdef CONFIG_X86_64
+	struct resource *ioapic_res;
 
 	ioapic_res = ioapic_setup_resources();
+#endif
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].mp_apicaddr;
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
+fake_ioapic_page:
+#endif
 			ioapic_phys = (unsigned long)
 				alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
 		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %016lx (%016lx)\n",
+			    "mapped IOAPIC to %08lx (%08lx)\n",
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
 
+#ifdef CONFIG_X86_64
 		if (ioapic_res != NULL) {
 			ioapic_res->start = ioapic_phys;
 			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
 			ioapic_res++;
 		}
+#endif
 	}
 }
 
+#ifdef CONFIG_X86_64
 static int __init ioapic_insert_resources(void)
 {
 	int i;
@@ -3293,4 +3893,4 @@ static int __init ioapic_insert_resource
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
-
+#endif
