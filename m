Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYIFXye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYIFXye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYIFXuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54646 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752965AbYIFXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235038.292703000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:46 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 10/13] genapic: reduce stack pressuge in io_apic.c step 2 internal abi
Content-Disposition: inline; filename=stack-hogs-io_apic_c-step-2-internal-abi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Step 2 of cleaning up io_apic.c removes cpumask_t variables
    passed as arguments on the stack for internal functions:

	assign_irq_vector()
	__assign_irq_vector()
	migrate_ioapic_irq()
	set_ioapic_affinity_irq()
	set_ir_ioapic_affinity_irq()

   The last two functions are used both internally and externally so
   there are now intermediate functions to maintain the external ABI.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/io_apic.c |   66 +++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic.c
@@ -578,9 +578,9 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, cpumask_t *mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq_p(unsigned int irq, cpumask_t *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -589,7 +589,7 @@ static void set_ioapic_affinity_irq(unsi
 	struct irq_desc *desc;
 
 	get_cpumask_var(tmp, cpumask_irq_level_3);
-	cpus_and(*tmp, mask, cpu_online_map);
+	cpus_and(*tmp, *mask, cpu_online_map);
 	if (cpus_empty(*tmp)) {
 		put_cpumask_var(tmp, cpumask_irq_level_3);
 		return;
@@ -601,7 +601,7 @@ static void set_ioapic_affinity_irq(unsi
 		return;
 	}
 
-	cpus_and(*tmp, cfg->domain, mask);
+	cpus_and(*tmp, cfg->domain, *mask);
 	dest = cpu_mask_to_apicid(*tmp);
 	/*
 	 * Only the high 8 bits are valid.
@@ -611,10 +611,16 @@ static void set_ioapic_affinity_irq(unsi
 	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	desc->affinity = mask;
+	desc->affinity = *mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 	put_cpumask_var(tmp, cpumask_irq_level_3);
 }
+
+/* for struct irq_chip.set_affinity compatibility */
+static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	set_ioapic_affinity_irq_p(irq, &mask);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -1246,7 +1252,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t inmask)
+static int __assign_irq_vector(int irq, cpumask_t *inmask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1274,7 +1280,7 @@ static int __assign_irq_vector(int irq, 
 
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpus_and(*tmpmask, inmask, cpu_online_map);
+		cpus_and(*tmpmask, *inmask, cpu_online_map);
 		cpus_and(*tmpmask, cfg->domain, *tmpmask);
 		if (!cpus_empty(*tmpmask)) {
 			put_cpumask_var(tmpmask, cpumask_irq_level_1);
@@ -1282,7 +1288,7 @@ static int __assign_irq_vector(int irq, 
 		}
 	}
 
-	for_each_online_cpu_mask_nr(cpu, inmask) {
+	for_each_online_cpu_mask_nr(cpu, *inmask) {
 		int new_cpu;
 		int vector, offset;
 
@@ -1327,7 +1333,7 @@ next:
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask)
+static int assign_irq_vector(int irq, cpumask_t *mask)
 {
 	int err;
 	unsigned long flags;
@@ -1527,7 +1533,7 @@ static void setup_IO_APIC_irq(int apic, 
 
 	get_cpumask_var(mask, cpumask_irq_level_3);
 	*mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, *mask))
+	if (assign_irq_vector(irq, mask))
 		goto out;
 
 	cpus_and(*mask, cfg->domain, *mask);
@@ -2293,7 +2299,7 @@ static DECLARE_DELAYED_WORK(ir_migration
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq(int irq, cpumask_t mask)
+static void migrate_ioapic_irq(int irq, cpumask_t *mask)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -2304,7 +2310,7 @@ static void migrate_ioapic_irq(int irq, 
 	unsigned long flags;
 
 	get_cpumask_var(tmpmask, cpumask_irq_level_3);
-	cpus_and(*tmpmask, mask, cpu_online_map);
+	cpus_and(*tmpmask, *mask, cpu_online_map);
 	if (cpus_empty(*tmpmask))
 		goto out;
 
@@ -2315,7 +2321,7 @@ static void migrate_ioapic_irq(int irq, 
 		goto out;
 
 	cfg = irq_cfg(irq);
-	cpus_and(*tmpmask, cfg->domain, mask);
+	cpus_and(*tmpmask, cfg->domain, *mask);
 	dest = cpu_mask_to_apicid(*tmpmask);
 
 	desc = irq_to_desc(irq);
@@ -2341,7 +2347,7 @@ static void migrate_ioapic_irq(int irq, 
 		cfg->move_in_progress = 0;
 	}
 
-	desc->affinity = mask;
+	desc->affinity = *mask;
 out:
 	put_cpumask_var(tmpmask, cpumask_irq_level_3);
 }
@@ -2365,7 +2371,7 @@ static int migrate_irq_remapped_level(in
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, desc->pending_mask);
+	migrate_ioapic_irq(irq, &desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
@@ -2402,19 +2408,25 @@ static void ir_irq_migration(struct work
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq_p(unsigned int irq, cpumask_t *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		desc->pending_mask = mask;
+		desc->pending_mask = *mask;
 		migrate_irq_remapped_level(irq);
 		return;
 	}
 
 	migrate_ioapic_irq(irq, mask);
 }
+
+/* for struct irq_chip.set_affinity compatibility */
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	set_ir_ioapic_affinity_irq_p(irq, &mask)
+}
 #endif
 
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
@@ -2814,7 +2826,7 @@ static inline void __init check_timer(vo
 	disable_8259A_irq(0);
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 	*tgt_cpus = TARGET_CPUS;
-	assign_irq_vector(0, *tgt_cpus);
+	assign_irq_vector(0, tgt_cpus);
 	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 
 	/*
@@ -3134,7 +3146,7 @@ unsigned int create_irq_nr(unsigned int 
 		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, *tgt_cpus) == 0)
+		if (__assign_irq_vector(new, tgt_cpus) == 0)
 			irq = new;
 		break;
 	}
@@ -3186,7 +3198,7 @@ static int msi_compose_msg(struct pci_de
 
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 	*tgt_cpus = TARGET_CPUS;
-	err = assign_irq_vector(irq, *tgt_cpus);
+	err = assign_irq_vector(irq, tgt_cpus);
 	if (err)
 		return err;
 
@@ -3260,7 +3272,7 @@ static void set_msi_irq_affinity(unsigne
 	if (cpus_empty(*tmp))
 		goto out;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		goto out;
 
 	cfg = irq_cfg(irq);
@@ -3302,7 +3314,7 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3544,7 +3556,7 @@ static void dmar_msi_set_affinity(unsign
 	if (cpus_empty(*tmp))
 		goto out;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		goto out;
 
 	cfg = irq_cfg(irq);
@@ -3626,7 +3638,7 @@ static void set_ht_irq_affinity(unsigned
 	if (cpus_empty(*tmp))
 		goto out;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		goto out;
 
 	cfg = irq_cfg(irq);
@@ -3660,7 +3672,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 	*tgt_cpus = TARGET_CPUS;
-	err = assign_irq_vector(irq, *tgt_cpus);
+	err = assign_irq_vector(irq, tgt_cpus);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
@@ -3899,12 +3911,12 @@ void __init setup_ioapic_dest(void)
 #ifdef CONFIG_INTR_REMAP
 			else if (intr_remapping_enabled) {
 				*tgt_cpus = TARGET_CPUS;
-				set_ir_ioapic_affinity_irq(irq, *tgt_cpus);
+				set_ir_ioapic_affinity_irq_p(irq, tgt_cpus);
 			}
 #endif
 			else {
 				*tgt_cpus = TARGET_CPUS;
-				set_ioapic_affinity_irq(irq, *tgt_cpus);
+				set_ioapic_affinity_irq_p(irq, tgt_cpus);
 			}
 		}
 

-- 
