Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYK2TmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYK2TmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYK2TmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:42:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYK2TmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:42:09 -0500
Date: Sat, 29 Nov 2008 20:41:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] irq fixes
Message-ID: <20081129194158.GA26305@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      irq: fix typo

Mark Nelson (1):
      genirq: __irq_set_trigger: change pr_warning to pr_debug

Randy Dunlap (1):
      irq.h: fix missing/extra kernel-doc

Thomas Gleixner (3):
      genirq: keep affinities set from userspace across free/request_irq()
      genirq: fix the affinity setting in setup_irq
      x86: apic honour irq affinity which was set in early boot


 arch/x86/kernel/io_apic.c |   26 ++++++++++++++---
 include/linux/irq.h       |   11 ++-----
 kernel/irq/internals.h    |    2 +
 kernel/irq/manage.c       |   68 +++++++++++++++++++++++++++++++++++----------
 kernel/irq/migration.c    |   11 -------
 kernel/irq/proc.c         |    2 +-
 6 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index c9513e1..8e2ed9c 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3775,7 +3775,9 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
+	cpumask_t mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3792,16 +3794,30 @@ void __init setup_ioapic_dest(void)
 			 * cpu is online.
 			 */
 			cfg = irq_cfg(irq);
-			if (!cfg->vector)
+			if (!cfg->vector) {
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
+				continue;
+
+			}
+
+			/*
+			 * Honour affinities which have been set in early boot
+			 */
+			desc = irq_to_desc(irq);
+			if (desc->status &
+			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
+				mask = desc->affinity;
+			else
+				mask = TARGET_CPUS;
+
 #ifdef CONFIG_INTR_REMAP
-			else if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
-#endif
+			if (intr_remapping_enabled)
+				set_ir_ioapic_affinity_irq(irq, mask);
 			else
-				set_ioapic_affinity_irq(irq, TARGET_CPUS);
+#endif
+				set_ioapic_affinity_irq(irq, mask);
 		}
 
 	}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d058c57..3dddfa7 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -63,7 +63,8 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
-#define IRQ_MOVE_PCNTXT	0x01000000	/* IRQ migration from process context */
+#define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
+#define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
@@ -130,7 +131,7 @@ struct irq_chip {
 
 /**
  * struct irq_desc - interrupt descriptor
- *
+ * @irq:		interrupt number for this descriptor
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor
@@ -149,7 +150,6 @@ struct irq_chip {
  * @cpu:		cpu index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @dir:		/proc/irq/ procfs entry
- * @affinity_entry:	/proc/irq/smp_affinity procfs entry on SMP
  * @name:		flow handler name for /proc/interrupts output
  */
 struct irq_desc {
@@ -210,7 +210,6 @@ extern int setup_irq(unsigned int irq, struct irqaction *new);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void set_pending_irq(unsigned int irq, cpumask_t mask);
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
 
@@ -228,10 +227,6 @@ static inline void move_masked_irq(int irq)
 {
 }
 
-static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
-{
-}
-
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
 #else /* CONFIG_SMP */
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c9767e6..64c1c72 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -25,6 +25,8 @@ static inline void unregister_handler_proc(unsigned int irq,
 					   struct irqaction *action) { }
 #endif
 
+extern int irq_select_affinity_usr(unsigned int irq);
+
 /*
  * Debugging printout:
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c498a1b..801addd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -82,24 +82,27 @@ int irq_can_set_affinity(unsigned int irq)
 int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
 
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
 
+	spin_lock_irqsave(&desc->lock, flags);
+
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&desc->lock, flags);
 		desc->affinity = cpumask;
 		desc->chip->set_affinity(irq, cpumask);
-		spin_unlock_irqrestore(&desc->lock, flags);
-	} else
-		set_pending_irq(irq, cpumask);
+	} else {
+		desc->status |= IRQ_MOVE_PENDING;
+		desc->pending_mask = cpumask;
+	}
 #else
 	desc->affinity = cpumask;
 	desc->chip->set_affinity(irq, cpumask);
 #endif
+	desc->status |= IRQ_AFFINITY_SET;
+	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 
@@ -107,24 +110,59 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 /*
  * Generic version of the affinity autoselector.
  */
-int irq_select_affinity(unsigned int irq)
+int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	cpumask_t mask;
-	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
-	desc = irq_to_desc(irq);
+	/*
+	 * Preserve an userspace affinity setup, but make sure that
+	 * one of the targets is online.
+	 */
+	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
+		if (cpus_intersects(desc->affinity, cpu_online_map))
+			mask = desc->affinity;
+		else
+			desc->status &= ~IRQ_AFFINITY_SET;
+	}
+
 	desc->affinity = mask;
 	desc->chip->set_affinity(irq, mask);
 
 	return 0;
 }
+#else
+static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *d)
+{
+	return irq_select_affinity(irq);
+}
 #endif
 
+/*
+ * Called when affinity is set via /proc/irq
+ */
+int irq_select_affinity_usr(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	ret = do_irq_select_affinity(irq, desc);
+	spin_unlock_irqrestore(&desc->lock, flags);
+
+	return ret;
+}
+
+#else
+static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
+{
+	return 0;
+}
 #endif
 
 /**
@@ -327,7 +365,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
 		 */
-		pr_warning("No set_type function for IRQ %d (%s)\n", irq,
+		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
 				chip ? (chip->name ? : "unknown") : "unknown");
 		return 0;
 	}
@@ -445,8 +483,12 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 			/* Undo nested disables: */
 			desc->depth = 1;
 
+		/* Exclude IRQ from balancing if requested */
+		if (new->flags & IRQF_NOBALANCING)
+			desc->status |= IRQ_NO_BALANCING;
+
 		/* Set default affinity mask once everything is setup */
-		irq_select_affinity(irq);
+		do_irq_select_affinity(irq, desc);
 
 	} else if ((new->flags & IRQF_TRIGGER_MASK)
 			&& (new->flags & IRQF_TRIGGER_MASK)
@@ -459,10 +501,6 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 
 	*p = new;
 
-	/* Exclude IRQ from balancing */
-	if (new->flags & IRQF_NOBALANCING)
-		desc->status |= IRQ_NO_BALANCING;
-
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 90b920d..9db681d 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -1,17 +1,6 @@
 
 #include <linux/irq.h>
 
-void set_pending_irq(unsigned int irq, cpumask_t mask)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&desc->lock, flags);
-	desc->status |= IRQ_MOVE_PENDING;
-	desc->pending_mask = mask;
-	spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4d161c7..d257e7d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -62,7 +62,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	if (!cpus_intersects(new_value, cpu_online_map))
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return irq_select_affinity(irq) ? -EINVAL : count;
+		return irq_select_affinity_usr(irq) ? -EINVAL : count;
 
 	irq_set_affinity(irq, new_value);
 
