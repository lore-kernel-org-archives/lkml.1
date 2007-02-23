Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbXBWLmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbXBWLmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXBWLmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:42:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbXBWLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:42:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/14] x86_64 irq: Safely cleanup an irq after moving it.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:40:58 -0700
In-Reply-To: <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:38:26 -0700")
Message-ID: <m1lkipt839.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The problem:  After moving an interrupt when is it safe to teardown
the data structures for receiving the interrupt at the old location?

With a normal pci device it is possible to issue a read to a device
to flush all posted writes.  This does not work for the oldest ioapics
because they are on a 3-wire apic bus which is a completely different
data path.  For some more modern ioapics when everything is using
front side bus delivery you can flush interrupts by simply issuing a
read to the ioapic.  For other modern ioapics emperical testing has
shown that this does not work.

So it appears the only reliable way to know the last of the irqs from an
ioapic have been received from before the ioapic was reprogrammed is to
received the first irq from the ioapic from after it was reprogrammed.

Once we know the last irq message has been received from an ioapic
into a local apic we then need to know that irq message has been
processed through the local apics.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/entry.S   |    3 ++
 arch/x86_64/kernel/i8259.c   |    6 +++-
 arch/x86_64/kernel/io_apic.c |   78 +++++++++++++++++++++++++++++++++++++++---
 include/asm-x86_64/hw_irq.h  |    9 ++++-
 4 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 9f5dac6..ed4350c 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -675,6 +675,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(irq_move_cleanup_interrupt)
+	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
+END(irq_move_cleanup_interrupt)
 #endif
 
 ENTRY(apic_timer_interrupt)
diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 45d8563..21d95b7 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -450,6 +450,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
 void invalidate_interrupt2(void);
@@ -537,7 +538,10 @@ void __init init_IRQ(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-#endif	
+
+	/* Low priority IPI to cleanup after moving an irq */
+	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+#endif
 	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	set_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 8dede0b..48593f6 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -36,6 +36,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 
+#include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/desc.h>
@@ -49,7 +50,10 @@
 
 struct irq_cfg {
 	cpumask_t domain;
+	cpumask_t old_domain;
+	unsigned move_cleanup_count;
 	u8 vector;
+	u8 move_in_progress : 1;
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -652,7 +656,6 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
-	cpumask_t old_mask = CPU_MASK_NONE;
 	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
@@ -663,18 +666,20 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
 
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+		return -EBUSY;
+
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_t tmp;
 		cpus_and(tmp, cfg->domain, mask);
 		if (!cpus_empty(tmp))
 			return 0;
-		cpus_and(old_mask, cfg->domain, cpu_online_map);
 	}
 
 	for_each_cpu_mask(cpu, mask) {
 		cpumask_t domain, new_mask;
-		int new_cpu, old_cpu;
+		int new_cpu;
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
@@ -699,8 +704,10 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		for_each_cpu_mask(old_cpu, old_mask)
-			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
+		if (old_vector) {
+			cfg->move_in_progress = 1;
+			cfg->old_domain = cfg->domain;
+		}
 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
@@ -1360,8 +1367,68 @@ static int ioapic_retrigger_irq(unsigned int irq)
  * races.
  */
 
+#ifdef CONFIG_SMP
+asmlinkage void smp_irq_move_cleanup_interrupt(void)
+{
+	unsigned vector, me;
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+
+	me = smp_processor_id();
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned int irq;
+		struct irq_desc *desc;
+		struct irq_cfg *cfg;
+		irq = __get_cpu_var(vector_irq)[vector];
+		if (irq >= NR_IRQS)
+			continue;
+
+		desc = irq_desc + irq;
+		cfg = irq_cfg + irq;
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
+	struct irq_cfg *cfg = irq_cfg + irq;
+	unsigned vector, me;
+
+	if (likely(!cfg->move_in_progress))
+		return;
+
+	vector = ~get_irq_regs()->orig_rax;
+	me = smp_processor_id();
+	if ((vector == cfg->vector) &&
+	    cpu_isset(smp_processor_id(), cfg->domain)) {
+		cpumask_t cleanup_mask;
+
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+}
+#else
+static inline void irq_complete_move(unsigned int irq) {}
+#endif
+
 static void ack_apic_edge(unsigned int irq)
 {
+	irq_complete_move(irq);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
@@ -1370,6 +1437,7 @@ static void ack_apic_level(unsigned int irq)
 {
 	int do_unmask_irq = 0;
 
+	irq_complete_move(irq);
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index dc395ed..2e4b7a5 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -32,10 +32,15 @@
 #define IA32_SYSCALL_VECTOR	0x80
 
 
+/* Reserve the lowest usable priority level 0x20 - 0x2f for triggering
+ * cleanup after irq migration.
+ */
+#define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
+ 
 /*
  * Vectors 0x20-0x2f are used for ISA interrupts.
  */
-#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR
+#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
 #define IRQ1_VECTOR		IRQ0_VECTOR + 1
 #define IRQ2_VECTOR		IRQ0_VECTOR + 2
 #define IRQ3_VECTOR		IRQ0_VECTOR + 3
@@ -82,7 +87,7 @@
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
- * we start at 0x31 to spread out vectors evenly between priority
+ * we start at 0x41 to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
-- 
1.5.0.g53756

