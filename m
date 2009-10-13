Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZJMUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZJMUe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZJMUeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:34:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55684 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751965AbZJMUeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:34:24 -0400
Date: Tue, 13 Oct 2009 15:32:36 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Move SGI UV functionality out of generic IO-APIC code
Message-ID: <20091013203236.GD20543@sgi.com>
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012193433.GB2691@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move UV specific functionality out of the generic IO-APIC code.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/include/asm/hw_irq.h    |   19 ++++
 arch/x86/include/asm/uv/uv_irq.h |    7 -
 arch/x86/kernel/apic/io_apic.c   |  140 +----------------------------------
 arch/x86/kernel/uv_irq.c         |  109 +++++++++++++++++++++++++++
 4 files changed, 133 insertions(+), 142 deletions(-)

Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-10-13 13:53:37.000000000 -0500
+++ linux/arch/x86/include/asm/hw_irq.h	2009-10-13 13:54:25.000000000 -0500
@@ -85,6 +85,25 @@ static inline void set_io_apic_irq_attr(
 	irq_attr->polarity   = polarity;
 }
 
+/*
+ * This is performance-critical, we want to do it O(1)
+ *
+ * Most irqs are mapped 1:1 with pins.
+ */
+struct irq_cfg {
+	struct irq_pin_list *irq_2_pin;
+	cpumask_var_t domain;
+	cpumask_var_t old_domain;
+	unsigned move_cleanup_count;
+	u8 vector;
+	u8 move_in_progress : 1;
+};
+
+extern struct irq_cfg *irq_cfg(unsigned int);
+extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+extern void send_cleanup_vector(struct irq_cfg *);
+extern unsigned int set_desc_affinity(struct irq_desc *,
+					const struct cpumask *);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
 					struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
Index: linux/arch/x86/include/asm/uv/uv_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_irq.h	2009-10-13 13:53:47.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_irq.h	2009-10-13 13:56:11.000000000 -0500
@@ -31,13 +31,6 @@ enum {
 	UV_AFFINITY_CPU
 };
 
-extern struct irq_chip uv_irq_chip;
-
-extern int
-arch_enable_uv_irq(char *, unsigned int, int, int, unsigned long, int);
-extern void arch_disable_uv_irq(int, unsigned long);
-extern int uv_set_irq_affinity(unsigned int, const struct cpumask *);
-
 extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
 extern int uv_setup_irq(char *, int, int, unsigned long, int);
 extern void uv_teardown_irq(unsigned int);
Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-10-13 13:53:47.000000000 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2009-10-13 15:19:04.000000000 -0500
@@ -60,8 +60,6 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
-#include <asm/uv/uv_hub.h>
-#include <asm/uv/uv_irq.h>
 
 #include <asm/apic.h>
 
@@ -140,20 +138,6 @@ static struct irq_pin_list *get_one_free
 	return pin;
 }
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * Most irqs are mapped 1:1 with pins.
- */
-struct irq_cfg {
-	struct irq_pin_list *irq_2_pin;
-	cpumask_var_t domain;
-	cpumask_var_t old_domain;
-	unsigned move_cleanup_count;
-	u8 vector;
-	u8 move_in_progress : 1;
-};
-
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[] = {
@@ -209,7 +193,7 @@ int __init arch_early_irq_init(void)
 }
 
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg *irq_cfg(unsigned int irq)
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg = NULL;
 	struct irq_desc *desc;
@@ -361,7 +345,7 @@ void arch_free_chip_data(struct irq_desc
 /* end for move_irq_desc */
 
 #else
-static struct irq_cfg *irq_cfg(unsigned int irq)
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
@@ -1237,8 +1221,7 @@ next:
 	return err;
 }
 
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
@@ -2228,7 +2211,7 @@ static int ioapic_retrigger_irq(unsigned
  */
 
 #ifdef CONFIG_SMP
-static void send_cleanup_vector(struct irq_cfg *cfg)
+void send_cleanup_vector(struct irq_cfg *cfg)
 {
 	cpumask_var_t cleanup_mask;
 
@@ -2272,15 +2255,12 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
-
 /*
  * Either sets desc->affinity to a valid value, and returns
  * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
  * leaves desc->affinity untouched.
  */
-static unsigned int
+unsigned int
 set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
@@ -3741,116 +3721,6 @@ int arch_setup_ht_irq(unsigned int irq, 
 }
 #endif /* CONFIG_HT_IRQ */
 
-#ifdef CONFIG_X86_UV
-/*
- * Re-target the irq to the specified CPU and enable the specified MMR located
- * on the specified blade to allow the sending of MSIs to the specified CPU.
- */
-int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset, int restrict)
-{
-	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
-	int mmr_pnode;
-	unsigned long mmr_value;
-	struct uv_IO_APIC_route_entry *entry;
-	unsigned long flags;
-	int err;
-
-	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	cfg = irq_cfg(irq);
-
-	err = assign_irq_vector(irq, cfg, eligible_cpu);
-	if (err != 0)
-		return err;
-
-	if (restrict == UV_AFFINITY_CPU)
-		desc->status |= IRQ_NO_BALANCING;
-	else
-		desc->status |= IRQ_MOVE_PCNTXT;
-
-	spin_lock_irqsave(&vector_lock, flags);
-	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
-				      irq_name);
-	spin_unlock_irqrestore(&vector_lock, flags);
-
-	mmr_value = 0;
-	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	entry->vector		= cfg->vector;
-	entry->delivery_mode	= apic->irq_delivery_mode;
-	entry->dest_mode	= apic->irq_dest_mode;
-	entry->polarity		= 0;
-	entry->trigger		= 0;
-	entry->mask		= 0;
-	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
-
-	mmr_pnode = uv_blade_to_pnode(mmr_blade);
-	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
-
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	return irq;
-}
-
-/*
- * Disable the specified MMR located on the specified blade so that MSIs are
- * longer allowed to be sent.
- */
-void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
-{
-	unsigned long mmr_value;
-	struct uv_IO_APIC_route_entry *entry;
-
-	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	mmr_value = 0;
-	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	entry->mask = 1;
-
-	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
-}
-
-int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
-	unsigned int dest;
-	unsigned long mmr_value;
-	struct uv_IO_APIC_route_entry *entry;
-	unsigned long mmr_offset;
-	unsigned mmr_pnode;
-
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
-		return -1;
-
-	mmr_value = 0;
-	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-
-	entry->vector = cfg->vector;
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode = apic->irq_dest_mode;
-	entry->polarity = 0;
-	entry->trigger = 0;
-	entry->mask = 0;
-	entry->dest = dest;
-
-	/* Get previously stored MMR and pnode of hub sourcing interrupts */
-	if (uv_irq_2_mmr_info(irq, &mmr_offset, &mmr_pnode))
-		return -1;
-
-	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
-
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	return 0;
-}
-#endif /* CONFIG_X86_64 */
-
 int __init io_apic_get_redir_entries (int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
Index: linux/arch/x86/kernel/uv_irq.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_irq.c	2009-10-13 13:53:47.000000000 -0500
+++ linux/arch/x86/kernel/uv_irq.c	2009-10-13 13:55:49.000000000 -0500
@@ -25,6 +25,7 @@ struct uv_irq_2_mmr_pnode{
 };
 static spinlock_t uv_irq_lock;
 static struct rb_root uv_irq_root;
+static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
 
 static void uv_noop(unsigned int irq)
 {
@@ -132,6 +133,114 @@ int uv_irq_2_mmr_info(int irq, unsigned 
 }
 
 /*
+ * Re-target the irq to the specified CPU and enable the specified MMR located
+ * on the specified blade to allow the sending of MSIs to the specified CPU.
+ */
+static int
+arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
+		       unsigned long mmr_offset, int restrict)
+{
+	const struct cpumask *eligible_cpu = cpumask_of(cpu);
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg;
+	int mmr_pnode;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	int err;
+
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
+			sizeof(unsigned long));
+
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, eligible_cpu);
+	if (err != 0)
+		return err;
+
+	if (restrict == UV_AFFINITY_CPU)
+		desc->status |= IRQ_NO_BALANCING;
+	else
+		desc->status |= IRQ_MOVE_PCNTXT;
+
+	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
+				      irq_name);
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	entry->vector		= cfg->vector;
+	entry->delivery_mode	= apic->irq_delivery_mode;
+	entry->dest_mode	= apic->irq_dest_mode;
+	entry->polarity		= 0;
+	entry->trigger		= 0;
+	entry->mask		= 0;
+	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return irq;
+}
+
+/*
+ * Disable the specified MMR located on the specified blade so that MSIs are
+ * longer allowed to be sent.
+ */
+static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
+{
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
+			sizeof(unsigned long));
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	entry->mask = 1;
+
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+}
+
+static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
+	unsigned int dest;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	unsigned long mmr_offset;
+	unsigned mmr_pnode;
+
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
+		return -1;
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+
+	entry->vector = cfg->vector;
+	entry->delivery_mode = apic->irq_delivery_mode;
+	entry->dest_mode = apic->irq_dest_mode;
+	entry->polarity = 0;
+	entry->trigger = 0;
+	entry->mask = 0;
+	entry->dest = dest;
+
+	/* Get previously stored MMR and pnode of hub sourcing interrupts */
+	if (uv_irq_2_mmr_info(irq, &mmr_offset, &mmr_pnode))
+		return -1;
+
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	return 0;
+}
+
+/*
  * Set up a mapping of an available irq and vector, and enable the specified
  * MMR that defines the MSI that is to be sent to the specified CPU when an
  * interrupt is raised.
