Return-Path: <linux-kernel-owner+w=401wt.eu-S1946175AbXBCAg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946175AbXBCAg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBCAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:36:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59627 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402AbXBCAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:36:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 02 Feb 2007 17:35:31 -0700
In-Reply-To: <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 02 Feb 2007 17:31:04 -0700")
Message-ID: <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When making the interrupt vectors per cpu I failed to handle a case
during irq migration.  If the same interrupt comes in while we are
servicing the irq but before we migrate it the pending bit in the
local apic IRR register will be set for that irq.

After migrating the irq to another cpu and or vector the data
structures will no longer be setup to handle this pending irq.  Then as
soon as we return from servicing the irq we just migrated we will get
a nasty: "No irq handler for vector" message. 

Since we do not disable irqs for edge triggered interrupts except
in the smallest possible window during migration I cannot avoid
migrating an irq in the unlikely event that it becomes pending.
This is because by the time the irq could no longer become pending
I have already updated all of my data structures.

Therefore this patch introduces an intermediate state that
exists soley on the cpu where we are handling the irq during
migration.  The irq number is changed to negative in the
vector_irq data structure.

Once the migration operation is complete we know we will receive
no more interrupts on this vector so the irq pending state for
this irq will no longer be updated.  If the irq is not pending and
we are in the intermediate state we immediately free the vector,
otherwise in we free the vector in do_IRQ when the pending irq
arrives.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |   56 ++++++++++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/irq.c     |   19 +++++++++++++-
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index d1fcd4b..ffcb5f6 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -730,9 +730,17 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		for_each_cpu_mask(old_cpu, old_mask)
-			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask(old_cpu, old_mask) {
+			int free = -1;
+			/* When migrating we need to preserve the old
+			 * vector until we have processed all of the
+			 * pending irqs.
+			 */
+			if (old_cpu == smp_processor_id())
+				free = -irq;
+			per_cpu(vector_irq, old_cpu)[old_vector] = free;
+		} 
+ 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		irq_vector[irq] = vector;
 		irq_domain[irq] = domain;
@@ -1389,6 +1397,37 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	return 1;
 }
 
+static unsigned apic_in_service_vector(void)
+{
+	unsigned isr, vector;
+	/* Figure out which vector we are servicing */
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector += 32) {
+		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
+		if (isr)
+			break;
+	}
+	/* Find the low bits of the vector we are servicing */
+	vector += __ffs(isr);
+	return vector;
+}
+
+static void apic_handle_pending_vector(unsigned vector)
+{
+	unsigned irr;
+	int irq;
+
+	irq = __get_cpu_var(vector_irq)[vector];
+	if (irq >= 0)
+		return;
+
+	/* If the irq we are servicing has moved and is not pending
+	 * free it's vector.
+	 */
+	irr = apic_read(APIC_IRR + ((vector/32) * 0x10));
+	if (!(irr & (1 << (vector % 32))))
+		__get_cpu_var(vector_irq)[vector] = -1;
+}
+
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
  * so we use two separate IRQ descriptors. Edge triggered IRQs can be
@@ -1400,19 +1439,24 @@ static int ioapic_retrigger_irq(unsigned int irq)
 
 static void ack_apic_edge(unsigned int irq)
 {
-	move_native_irq(irq);
+	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+		move_native_irq(irq);
+		apic_handle_pending_vector(apic_in_service_vector());
+	}
 	ack_APIC_irq();
 }
 
 static void ack_apic_level(unsigned int irq)
 {
 	int do_unmask_irq = 0;
+	unsigned int vector = 0;
 
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
+		vector = apic_in_service_vector();
 	}
 #endif
 
@@ -1424,8 +1468,10 @@ static void ack_apic_level(unsigned int irq)
 
 	/* Now we can move and renable the irq */
 	move_masked_irq(irq);
-	if (unlikely(do_unmask_irq))
+	if (unlikely(do_unmask_irq)) {
+		apic_handle_pending_vector(vector);
 		unmask_IO_APIC_irq(irq);
+	}
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 648055a..0ff5fbc 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -97,6 +97,23 @@ skip:
 	return 0;
 }
 
+static inline unsigned int irq_from_vector(unsigned int vector)
+{
+	int irq;
+	irq = __get_cpu_var(vector_irq)[vector];
+
+	/* If we changed vectors during migration and we had a pending
+	 * irq, we left the irq allocated on this cpu.  Now that the
+	 * pending irq has arrived get the irq number and free this
+	 * vector. 
+	 */
+	if (irq < -1) {
+		__get_cpu_var(vector_irq)[vector] = -1;
+		irq = -irq;
+	}
+	return irq;
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -112,7 +129,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
+	irq = irq_from_vector(vector);
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
-- 
1.4.4.1.g278f

