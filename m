Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZDNUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZDNUp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZDNUps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:45:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:33036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZDNUpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:45:47 -0400
Message-ID: <49E4F5A3.9050802@kernel.org>
Date: Tue, 14 Apr 2009 13:44:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] irq: move move_irq_desc calling to set_affinity directly
 -v4
References: <200903231757.53709.rusty@rustcorp.com.au> <20090323165921.GA7559@us.ibm.com> <200903241553.58209.rusty@rustcorp.com.au> <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com> <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu> <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org> <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu> <49E4F513.1060709@kernel.org>
In-Reply-To: <49E4F513.1060709@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix panic

so could move_masked_irq call move_irq_desc directly.
also we still don't support IRQ_MOVE_PCNTXT aka intr_remapped path

v3: update after "irq, x86: Remove IRQ_DISABLED check in process context IRQ move"
v4: update after "irq: make set_affinity to return status"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |  108 +++++++++++++++++++++++++++--------------
 kernel/irq/migration.c         |   10 +++
 2 files changed, 80 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -361,8 +361,12 @@ void arch_free_chip_data(struct irq_desc
 static void
 set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_cfg *cfg = desc->chip_data;
+	struct irq_cfg *cfg;
+
+	if (desc->status & IRQ_MOVE_PCNTXT)
+		return;
 
+	cfg = desc->chip_data;
 	if (!cfg->move_in_progress) {
 		/* it means that domain is not changed */
 		if (!cpumask_intersects(desc->affinity, mask))
@@ -2299,14 +2303,53 @@ __target_IO_APIC_irq(unsigned int irq, u
 	}
 }
 
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+static struct irq_desc *masked_move_desc(struct irq_desc *desc,
+					 const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	int cpu;
+
+	/*
+	 * can not moved via set_affinity from irq_set_affinity when
+	 * intr_remapped aka IRQ_MOVE_PCNTXT is set
+	 */
+	if (desc->status & IRQ_MOVE_PCNTXT)
+		return desc;
+
+	cfg = desc->chip_data;
+	if (likely(!cfg->move_in_progress))
+		if (likely(!cfg->move_desc_pending))
+			return desc;
+
+	for_each_cpu_and(cpu, mask, cfg->domain) {
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	}
+
+	desc = move_irq_desc(desc, cpu);
+	cfg = desc->chip_data;
+	cfg->move_desc_pending = 0;
+
+	return desc;
+}
+#else
+static inline struct irq_desc *masked_move_desc(struct irq_desc *desc,
+						const struct cpumask *mask)
+{
+	return desc;
+}
+#endif
+
 /*
  * Either sets desc->affinity to a valid value, and returns
  * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
  * leaves desc->affinity untouched.
  */
 static unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
+set_desc_affinity(struct irq_desc **descp, const struct cpumask *mask)
 {
+	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
@@ -2323,6 +2366,9 @@ set_desc_affinity(struct irq_desc *desc,
 
 	cpumask_copy(desc->affinity, mask);
 
+	*descp = desc = masked_move_desc(desc, mask);
+	cfg = desc->chip_data;
+
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
 
@@ -2339,7 +2385,7 @@ set_ioapic_affinity_irq_desc(struct irq_
 	cfg = desc->chip_data;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest != BAD_APICID) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
@@ -2394,6 +2440,12 @@ migrate_ioapic_irq_desc(struct irq_desc
 	if (assign_irq_vector(irq, cfg, mask))
 		return ret;
 
+	/*
+	 * when intr_remap is used, IRQ_MOVE_PCNTXT is set,
+	 * set_affinity will be called directly by irq_set_affinity
+	 * Can we to make intr could be go through move_masked_irq/
+	 *	 move_native_irq path ?
+	 */
 	set_extra_move_desc(desc, mask);
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
@@ -2411,6 +2463,8 @@ migrate_ioapic_irq_desc(struct irq_desc
 
 	cpumask_copy(desc->affinity, mask);
 
+	desc = masked_move_desc(desc, mask);
+
 	return 0;
 }
 
@@ -2489,43 +2543,22 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void irq_complete_move(struct irq_desc *desc)
 {
-	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		if (likely(!cfg->move_desc_pending))
-			return;
-
-		/* domain has not changed, but affinity did */
-		me = smp_processor_id();
-		if (cpumask_test_cpu(me, desc->affinity)) {
-			*descp = desc = move_irq_desc(desc, me);
-			/* get the new one */
-			cfg = desc->chip_data;
-			cfg->move_desc_pending = 0;
-		}
-#endif
+	if (likely(!cfg->move_in_progress))
 		return;
-	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		*descp = desc = move_irq_desc(desc, me);
-		/* get the new one */
-		cfg = desc->chip_data;
-#endif
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
-	}
 }
 #else
-static inline void irq_complete_move(struct irq_desc **descp) {}
+static inline void irq_complete_move(struct irq_desc *desc) {}
 #endif
 
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
@@ -2579,7 +2612,7 @@ static void ack_apic_edge(unsigned int i
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	irq_complete_move(&desc);
+	irq_complete_move(desc);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
@@ -2597,7 +2630,7 @@ static void ack_apic_level(unsigned int
 	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
-	irq_complete_move(&desc);
+	irq_complete_move(desc);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
@@ -2670,8 +2703,11 @@ static void ack_apic_level(unsigned int
 		 * and you can go talk to the chipset vendor about it.
 		 */
 		cfg = desc->chip_data;
-		if (!io_apic_level_ack_pending(cfg))
+		if (!io_apic_level_ack_pending(cfg)) {
 			move_masked_irq(irq);
+			desc = irq_remap_to_desc(irq, desc);
+			cfg = desc->chip_data;
+		}
 		unmask_IO_APIC_irq_desc(desc);
 	}
 
@@ -3377,7 +3413,7 @@ static int set_msi_irq_affinity(unsigned
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest == BAD_APICID)
 		return -1;
 
@@ -3410,7 +3446,7 @@ ir_set_msi_irq_affinity(unsigned int irq
 	if (get_irte(irq, &irte))
 		return -1;
 
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest == BAD_APICID)
 		return -1;
 
@@ -3591,7 +3627,7 @@ static int dmar_msi_set_affinity(unsigne
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest == BAD_APICID)
 		return -1;
 
@@ -3647,7 +3683,7 @@ static int hpet_msi_set_affinity(unsigne
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest == BAD_APICID)
 		return -1;
 
@@ -3725,7 +3761,7 @@ static int set_ht_irq_affinity(unsigned
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
+	dest = set_desc_affinity(&desc, mask);
 	if (dest == BAD_APICID)
 		return -1;
 
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -42,11 +42,16 @@ void move_masked_irq(int irq)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		   < nr_cpu_ids)) {
+		int ret;
+
+		ret = desc->chip->set_affinity(irq, desc->pending_mask);
+		desc = irq_remap_to_desc(irq, desc);
+		if (!ret) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc, desc->pending_mask);
 		}
+	}
 
 	cpumask_clear(desc->pending_mask);
 }
@@ -63,6 +68,7 @@ void move_native_irq(int irq)
 
 	desc->chip->mask(irq);
 	move_masked_irq(irq);
+	desc = irq_remap_to_desc(irq, desc);
 	desc->chip->unmask(irq);
 }
 
