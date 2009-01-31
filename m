Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZAaBah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZAaBah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZAaBa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:30:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:35540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZAaBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:30:28 -0500
Message-ID: <4983A977.5050208@kernel.org>
Date: Fri, 30 Jan 2009 17:29:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move default_ipi_xx back to ipi.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

only leave _default_ipi_xx etc in .h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hw_irq.h |    6 --
 arch/x86/include/asm/ipi.h    |  123 +++---------------------------------------
 arch/x86/kernel/ipi.c         |  108 ++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 120 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -73,12 +73,6 @@ extern void setup_ioapic_dest(void);
 extern void enable_IO_APIC(void);
 #endif
 
-/* IPI functions */
-#ifdef CONFIG_X86_32
-extern void default_send_IPI_self(int vector);
-#endif
-extern void default_send_IPI(int dest, int vector);
-
 /* Statistics */
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
Index: linux-2.6/arch/x86/include/asm/ipi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ipi.h
+++ linux-2.6/arch/x86/include/asm/ipi.h
@@ -119,112 +119,22 @@ static inline void
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void
-default_send_IPI_mask_sequence_phys(const struct cpumask *mask, int vector)
-{
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	/*
-	 * Hack. The clustered APIC addressing mode doesn't allow us to send
-	 * to an arbitrary mask, so I do a unicast to each CPU instead.
-	 * - mbligh
-	 */
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				query_cpu), vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
-}
-
-static inline void
-default_send_IPI_mask_allbutself_phys(const struct cpumask *mask, int vector)
-{
-	unsigned int this_cpu = smp_processor_id();
-	unsigned int query_cpu;
-	unsigned long flags;
-
-	/* See Hack comment above */
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				 query_cpu), vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
-}
-
+extern void default_send_IPI_mask_sequence_phys(const struct cpumask *mask,
+						 int vector);
+extern void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
+							 int vector);
 #include <asm/genapic.h>
 
-static inline void
-default_send_IPI_mask_sequence_logical(const struct cpumask *mask, int vector)
-{
-	unsigned long flags;
-	unsigned int query_cpu;
-
-	/*
-	 * Hack. The clustered APIC addressing mode doesn't allow us to send
-	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This
-	 * should be modified to do 1 message per cluster ID - mbligh
-	 */
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask)
-		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
-	local_irq_restore(flags);
-}
-
-static inline void
-default_send_IPI_mask_allbutself_logical(const struct cpumask *mask, int vector)
-{
-	unsigned long flags;
-	unsigned int query_cpu;
-	unsigned int this_cpu = smp_processor_id();
-
-	/* See Hack comment above */
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
-		}
-	local_irq_restore(flags);
-}
+extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
+							 int vector);
+extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
+							 int vector);
 
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
 extern int no_broadcast;
 
-#ifndef CONFIG_X86_64
-/*
- * This is only used on smaller machines.
- */
-static inline void default_send_IPI_mask_bitmask_logical(const struct cpumask *cpumask, int vector)
-{
-	unsigned long mask = cpumask_bits(cpumask)[0];
-	unsigned long flags;
-
-	local_irq_save(flags);
-	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
-	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
-	local_irq_restore(flags);
-}
-
-static inline void default_send_IPI_mask_logical(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_bitmask_logical(mask, vector);
-}
-#endif
-
 static inline void __default_local_send_IPI_allbutself(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
@@ -242,22 +152,11 @@ static inline void __default_local_send_
 }
 
 #ifdef CONFIG_X86_32
-static inline void default_send_IPI_allbutself(int vector)
-{
-	/*
-	 * if there are no other CPUs in the system then we get an APIC send 
-	 * error if we try to broadcast, thus avoid sending IPIs in this case.
-	 */
-	if (!(num_online_cpus() > 1))
-		return;
-
-	__default_local_send_IPI_allbutself(vector);
-}
-
-static inline void default_send_IPI_all(int vector)
-{
-	__default_local_send_IPI_all(vector);
-}
+extern void default_send_IPI_mask_logical(const struct cpumask *mask,
+						 int vector);
+extern void default_send_IPI_allbutself(int vector);
+extern void default_send_IPI_all(int vector);
+extern void default_send_IPI_self(int vector);
 #endif
 
 #endif
Index: linux-2.6/arch/x86/kernel/ipi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ipi.c
+++ linux-2.6/arch/x86/kernel/ipi.c
@@ -19,8 +19,116 @@
 #include <asm/proto.h>
 #include <asm/ipi.h>
 
+void default_send_IPI_mask_sequence_phys(const struct cpumask *mask, int vector)
+{
+	unsigned long query_cpu;
+	unsigned long flags;
+
+	/*
+	 * Hack. The clustered APIC addressing mode doesn't allow us to send
+	 * to an arbitrary mask, so I do a unicast to each CPU instead.
+	 * - mbligh
+	 */
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask) {
+		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
+				query_cpu), vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
+
+void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
+						 int vector)
+{
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int query_cpu;
+	unsigned long flags;
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
+				 query_cpu), vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
+
+void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
+						 int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+
+	/*
+	 * Hack. The clustered APIC addressing mode doesn't allow us to send
+	 * to an arbitrary mask, so I do a unicasts to each CPU instead. This
+	 * should be modified to do 1 message per cluster ID - mbligh
+	 */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask)
+		__default_send_IPI_dest_field(
+			apic->cpu_to_logical_apicid(query_cpu), vector,
+			apic->dest_logical);
+	local_irq_restore(flags);
+}
+
+void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
+						 int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu == this_cpu)
+			continue;
+		__default_send_IPI_dest_field(
+			apic->cpu_to_logical_apicid(query_cpu), vector,
+			apic->dest_logical);
+		}
+	local_irq_restore(flags);
+}
+
 #ifdef CONFIG_X86_32
 
+/*
+ * This is only used on smaller machines.
+ */
+void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
+{
+	unsigned long mask = cpumask_bits(cpumask)[0];
+	unsigned long flags;
+
+	local_irq_save(flags);
+	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
+	__default_send_IPI_dest_field(mask, vector, apic->dest_logical);
+	local_irq_restore(flags);
+}
+
+void default_send_IPI_allbutself(int vector)
+{
+	/*
+	 * if there are no other CPUs in the system then we get an APIC send
+	 * error if we try to broadcast, thus avoid sending IPIs in this case.
+	 */
+	if (!(num_online_cpus() > 1))
+		return;
+
+	__default_local_send_IPI_allbutself(vector);
+}
+
+void default_send_IPI_all(int vector)
+{
+	__default_local_send_IPI_all(vector);
+}
+
 void default_send_IPI_self(int vector)
 {
 	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, apic->dest_logical);
