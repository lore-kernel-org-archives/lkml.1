Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYKMTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYKMTok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKMTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:33 -0500
Received: from gw.goop.org ([64.81.55.164]:34407 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYKMTeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 33 of 38] xen: pack all irq-related info together
X-Mercurial-Node: ff925080c5f1fdea9719d88359501f0ab51d31ca
Message-Id: <ff925080c5f1fdea9719.1226603431@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put all irq info into one struct.  Also, use a union to keep
event channel type-specific information, rather than overloading the
index field.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |  184 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 135 insertions(+), 49 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -51,18 +51,8 @@
 /* IRQ <-> IPI mapping */
 static DEFINE_PER_CPU(int, ipi_to_irq[XEN_NR_IPIS]) = {[0 ... XEN_NR_IPIS-1] = -1};
 
-/* Packed IRQ information: binding type, sub-type index, and event channel. */
-struct packed_irq
-{
-	unsigned short evtchn;
-	unsigned char index;
-	unsigned char type;
-};
-
-static struct packed_irq irq_info[NR_IRQS];
-
-/* Binding types. */
-enum {
+/* Interrupt types. */
+enum xen_irq_type {
 	IRQT_UNBOUND,
 	IRQT_PIRQ,
 	IRQT_VIRQ,
@@ -70,14 +60,39 @@
 	IRQT_EVTCHN
 };
 
-/* Convenient shorthand for packed representation of an unbound IRQ. */
-#define IRQ_UNBOUND	mk_irq_info(IRQT_UNBOUND, 0, 0)
+/*
+ * Packed IRQ information:
+ * type - enum xen_irq_type
+ * event channel - irq->event channel mapping
+ * cpu - cpu this event channel is bound to
+ * index - type-specific information:
+ *    PIRQ - vector, with MSB being "needs EIO"
+ *    VIRQ - virq number
+ *    IPI - IPI vector
+ *    EVTCHN -
+ */
+struct irq_info
+{
+	enum xen_irq_type type;	/* type */
+	unsigned short evtchn;	/* event channel */
+	unsigned short cpu;	/* cpu bound */
+
+	union {
+		unsigned short virq;
+		enum ipi_vector ipi;
+		struct {
+			unsigned short gsi;
+			unsigned short vector;
+		} pirq;
+	} u;
+};
+
+static struct irq_info irq_info[NR_IRQS];
 
 static int evtchn_to_irq[NR_EVENT_CHANNELS] = {
 	[0 ... NR_EVENT_CHANNELS-1] = -1
 };
 static unsigned long cpu_evtchn_mask[NR_CPUS][NR_EVENT_CHANNELS/BITS_PER_LONG];
-static u8 cpu_evtchn[NR_EVENT_CHANNELS];
 
 /* Reference counts for bindings to IRQs. */
 static int irq_bindcount[NR_IRQS];
@@ -88,27 +103,107 @@
 static struct irq_chip xen_dynamic_chip;
 
 /* Constructor for packed IRQ information. */
-static inline struct packed_irq mk_irq_info(u32 type, u32 index, u32 evtchn)
+static struct irq_info mk_unbound_info(void)
 {
-	return (struct packed_irq) { evtchn, index, type };
+	return (struct irq_info) { .type = IRQT_UNBOUND };
+}
+
+static struct irq_info mk_evtchn_info(unsigned short evtchn)
+{
+	return (struct irq_info) { .type = IRQT_EVTCHN, .evtchn = evtchn };
+}
+
+static struct irq_info mk_ipi_info(unsigned short evtchn, enum ipi_vector ipi)
+{
+	return (struct irq_info) { .type = IRQT_IPI, .evtchn = evtchn,
+			.u.ipi = ipi };
+}
+
+static struct irq_info mk_virq_info(unsigned short evtchn, unsigned short virq)
+{
+	return (struct irq_info) { .type = IRQT_VIRQ, .evtchn = evtchn,
+			.u.virq = virq };
+}
+
+static struct irq_info mk_pirq_info(unsigned short evtchn,
+				    unsigned short gsi, unsigned short vector)
+{
+	return (struct irq_info) { .type = IRQT_PIRQ, .evtchn = evtchn,
+			.u.pirq = { .gsi = gsi, .vector = vector } };
 }
 
 /*
  * Accessors for packed IRQ information.
  */
-static inline unsigned int evtchn_from_irq(int irq)
+static struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_info[irq].evtchn;
+	return &irq_info[irq];
 }
 
-static inline unsigned int index_from_irq(int irq)
+static unsigned int evtchn_from_irq(unsigned irq)
 {
-	return irq_info[irq].index;
+	return info_for_irq(irq)->evtchn;
 }
 
-static inline unsigned int type_from_irq(int irq)
+static enum ipi_vector ipi_from_irq(unsigned irq)
 {
-	return irq_info[irq].type;
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info == NULL);
+	BUG_ON(info->type != IRQT_IPI);
+
+	return info->u.ipi;
+}
+
+static unsigned virq_from_irq(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info == NULL);
+	BUG_ON(info->type != IRQT_VIRQ);
+
+	return info->u.virq;
+}
+
+static unsigned gsi_from_irq(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info == NULL);
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.gsi;
+}
+
+static unsigned vector_from_irq(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info == NULL);
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.vector;
+}
+
+static enum xen_irq_type type_from_irq(unsigned irq)
+{
+	return info_for_irq(irq)->type;
+}
+
+static unsigned cpu_from_irq(unsigned irq)
+{
+	return info_for_irq(irq)->cpu;
+}
+
+static unsigned int cpu_from_evtchn(unsigned int evtchn)
+{
+	int irq = evtchn_to_irq[evtchn];
+	unsigned ret = 0;
+
+	if (irq != -1)
+		ret = cpu_from_irq(irq);
+
+	return ret;
 }
 
 static inline unsigned long active_evtchns(unsigned int cpu,
@@ -129,10 +224,10 @@
 	irq_to_desc(irq)->affinity = cpumask_of_cpu(cpu);
 #endif
 
-	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
+	__clear_bit(chn, cpu_evtchn_mask[cpu_from_irq(irq)]);
 	__set_bit(chn, cpu_evtchn_mask[cpu]);
 
-	cpu_evtchn[chn] = cpu;
+	irq_info[irq].cpu = cpu;
 }
 
 static void init_evtchn_cpu_bindings(void)
@@ -146,15 +241,9 @@
 		desc->affinity = cpumask_of_cpu(0);
 #endif
 
-	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
 	memset(cpu_evtchn_mask[0], ~0, sizeof(cpu_evtchn_mask[0]));
 }
 
-static inline unsigned int cpu_from_evtchn(unsigned int evtchn)
-{
-	return cpu_evtchn[evtchn];
-}
-
 static inline void clear_evtchn(int port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
@@ -239,6 +328,8 @@
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
+	dynamic_irq_init(irq);
+
 	return irq;
 }
 
@@ -253,12 +344,11 @@
 	if (irq == -1) {
 		irq = find_unbound_irq();
 
-		dynamic_irq_init(irq);
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_level_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_irq_info(IRQT_EVTCHN, 0, evtchn);
+		irq_info[irq] = mk_evtchn_info(evtchn);
 	}
 
 	irq_bindcount[irq]++;
@@ -282,7 +372,6 @@
 		if (irq < 0)
 			goto out;
 
-		dynamic_irq_init(irq);
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_level_irq, "ipi");
 
@@ -293,7 +382,7 @@
 		evtchn = bind_ipi.port;
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_irq_info(IRQT_IPI, ipi, evtchn);
+		irq_info[irq] = mk_ipi_info(evtchn, ipi);
 
 		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
 
@@ -327,12 +416,11 @@
 
 		irq = find_unbound_irq();
 
-		dynamic_irq_init(irq);
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_level_irq, "virq");
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_irq_info(IRQT_VIRQ, virq, evtchn);
+		irq_info[irq] = mk_virq_info(evtchn, virq);
 
 		per_cpu(virq_to_irq, cpu)[virq] = irq;
 
@@ -361,11 +449,11 @@
 		switch (type_from_irq(irq)) {
 		case IRQT_VIRQ:
 			per_cpu(virq_to_irq, cpu_from_evtchn(evtchn))
-				[index_from_irq(irq)] = -1;
+				[virq_from_irq(irq)] = -1;
 			break;
 		case IRQT_IPI:
 			per_cpu(ipi_to_irq, cpu_from_evtchn(evtchn))
-				[index_from_irq(irq)] = -1;
+				[ipi_from_irq(irq)] = -1;
 			break;
 		default:
 			break;
@@ -375,7 +463,7 @@
 		bind_evtchn_to_cpu(evtchn, 0);
 
 		evtchn_to_irq[evtchn] = -1;
-		irq_info[irq] = IRQ_UNBOUND;
+		irq_info[irq] = mk_unbound_info();
 
 		dynamic_irq_cleanup(irq);
 	}
@@ -493,8 +581,8 @@
 	for(i = 0; i < NR_EVENT_CHANNELS; i++) {
 		if (sync_test_bit(i, sh->evtchn_pending)) {
 			printk("  %d: event %d -> irq %d\n",
-				cpu_evtchn[i], i,
-				evtchn_to_irq[i]);
+			       cpu_from_evtchn(i), i,
+			       evtchn_to_irq[i]);
 		}
 	}
 
@@ -592,7 +680,7 @@
 	BUG_ON(irq_bindcount[irq] == 0);
 
 	evtchn_to_irq[evtchn] = irq;
-	irq_info[irq] = mk_irq_info(IRQT_EVTCHN, 0, evtchn);
+	irq_info[irq] = mk_evtchn_info(evtchn);
 
 	spin_unlock(&irq_mapping_update_lock);
 
@@ -702,8 +790,7 @@
 		if ((irq = per_cpu(virq_to_irq, cpu)[virq]) == -1)
 			continue;
 
-		BUG_ON(irq_info[irq].type != IRQT_VIRQ);
-		BUG_ON(irq_info[irq].index != virq);
+		BUG_ON(virq_from_irq(irq) != virq);
 
 		/* Get a new binding from Xen. */
 		bind_virq.virq = virq;
@@ -715,7 +802,7 @@
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_irq_info(IRQT_VIRQ, virq, evtchn);
+		irq_info[irq] = mk_virq_info(evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
 		/* Ready for use. */
@@ -732,8 +819,7 @@
 		if ((irq = per_cpu(ipi_to_irq, cpu)[ipi]) == -1)
 			continue;
 
-		BUG_ON(irq_info[irq].type != IRQT_IPI);
-		BUG_ON(irq_info[irq].index != ipi);
+		BUG_ON(ipi_from_irq(irq) != ipi);
 
 		/* Get a new binding from Xen. */
 		bind_ipi.vcpu = cpu;
@@ -744,7 +830,7 @@
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_irq_info(IRQT_IPI, ipi, evtchn);
+		irq_info[irq] = mk_ipi_info(evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
 		/* Ready for use. */


