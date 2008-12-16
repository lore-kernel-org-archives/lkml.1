Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYLPC0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYLPC0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYLPCYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:20 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40525 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637AbYLPCYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:13 -0500
Message-Id: <20081216022411.065876000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:18 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] x86: cosmetic changes apic-related files.
Content-Disposition: inline; filename=0013-x86-cosmetic-changes-apic-related-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply changes cpumask_t to struct cpumask and similar
trivial modernizations.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/bigsmp/ipi.h             |   14 ++----
 arch/x86/include/asm/es7000/ipi.h             |   13 ++----
 arch/x86/include/asm/genapic_32.h             |   11 +++--
 arch/x86/include/asm/genapic_64.h             |   11 +++--
 arch/x86/include/asm/ipi.h                    |   10 +++--
 arch/x86/include/asm/mach-default/mach_apic.h |   12 +++---
 arch/x86/include/asm/mach-default/mach_ipi.h  |   12 +++---
 arch/x86/include/asm/numaq/ipi.h              |   14 ++----
 arch/x86/include/asm/smp.h                    |    4 +-
 arch/x86/kernel/genapic_flat_64.c             |   50 +++++++++++++------------
 arch/x86/kernel/genx2apic_cluster.c           |   25 ++++++------
 arch/x86/kernel/genx2apic_phys.c              |   25 ++++++------
 arch/x86/kernel/genx2apic_uv_x.c              |   24 ++++++------
 arch/x86/kernel/ipi.c                         |   14 +++---
 arch/x86/kernel/smp.c                         |    6 +-
 arch/x86/xen/smp.c                            |   11 +++--
 16 files changed, 127 insertions(+), 129 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/ipi.h b/arch/x86/include/asm/bigsmp/ipi.h
index 63553e9..27fcd01 100644
--- a/arch/x86/include/asm/bigsmp/ipi.h
+++ b/arch/x86/include/asm/bigsmp/ipi.h
@@ -1,26 +1,22 @@
 #ifndef __ASM_MACH_IPI_H
 #define __ASM_MACH_IPI_H
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(&mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(&cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_MACH_IPI_H */
diff --git a/arch/x86/include/asm/es7000/ipi.h b/arch/x86/include/asm/es7000/ipi.h
index 1a85072..7e8ed24 100644
--- a/arch/x86/include/asm/es7000/ipi.h
+++ b/arch/x86/include/asm/es7000/ipi.h
@@ -1,25 +1,22 @@
 #ifndef __ASM_ES7000_IPI_H
 #define __ASM_ES7000_IPI_H
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(&mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(&cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_ES7000_IPI_H */
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index eed6e30..746f37a 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -24,7 +24,7 @@ struct genapic {
 	int (*probe)(void);
 
 	int (*apic_id_registered)(void);
-	const cpumask_t *(*target_cpus)(void);
+	const struct cpumask *(*target_cpus)(void);
 	int int_delivery_mode;
 	int int_dest_mode;
 	int ESR_DISABLE;
@@ -57,15 +57,16 @@ struct genapic {
 
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
-	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
 	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
 					       const struct cpumask *andmask);
-	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
-	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
-	void (*send_IPI_mask_allbutself)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
+					 int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
index 244b717..adf32fb 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -20,17 +20,18 @@ struct genapic {
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
-	const cpumask_t *(*target_cpus)(void);
-	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
+	const struct cpumask *(*target_cpus)(void);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
-	void (*send_IPI_mask_allbutself)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
+					 int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 	/* */
-	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
 	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
 					       const struct cpumask *andmask);
 	unsigned int (*phys_pkg_id)(int index_msb);
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index 24b6e61..c745a30 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -117,7 +117,8 @@ static inline void __send_IPI_dest_field(unsigned int mask, int vector,
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask_sequence(const struct cpumask *mask,
+					  int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -128,14 +129,15 @@ static inline void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask) {
+	for_each_cpu(query_cpu, mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
-static inline void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -144,7 +146,7 @@ static inline void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
 	/* See Hack comment above */
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu(query_cpu, mask)
 		if (query_cpu != this_cpu)
 			__send_IPI_dest_field(
 				per_cpu(x86_cpu_to_apicid, query_cpu),
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index df8e024..8863d97 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -8,12 +8,12 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
 
-static inline const cpumask_t *target_cpus(void)
+static inline const struct cpumask *target_cpus(void)
 { 
 #ifdef CONFIG_SMP
-	return &cpu_online_map;
+	return cpu_online_mask;
 #else
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 #endif
 } 
 
@@ -62,9 +62,9 @@ static inline int apic_id_registered(void)
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return cpus_addr(*cpumask)[0];
+	return cpumask_bits(cpumask)[0];
 }
 
 static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -98,7 +98,7 @@ static inline int apicid_to_node(int logical_apicid)
 #endif
 }
 
-static inline void vector_allocation_domain(int cpu, cpumask_t *retmask)
+static inline void vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
         /* Careful. Some cpus do not strictly honor the set of cpus
          * specified in the interrupt destination when using lowest
diff --git a/arch/x86/include/asm/mach-default/mach_ipi.h b/arch/x86/include/asm/mach-default/mach_ipi.h
index 9353ab8..191312d 100644
--- a/arch/x86/include/asm/mach-default/mach_ipi.h
+++ b/arch/x86/include/asm/mach-default/mach_ipi.h
@@ -4,8 +4,8 @@
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
-void send_IPI_mask_bitmask(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 void __send_IPI_shortcut(unsigned int shortcut, int vector);
 
 extern int no_broadcast;
@@ -15,17 +15,17 @@ extern int no_broadcast;
 #define send_IPI_mask (genapic->send_IPI_mask)
 #define send_IPI_mask_allbutself (genapic->send_IPI_mask_allbutself)
 #else
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_bitmask(mask, vector);
 }
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 #endif
 
 static inline void __local_send_IPI_allbutself(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask_allbutself(&cpu_online_map, vector);
+		send_IPI_mask_allbutself(cpu_online_mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }
@@ -33,7 +33,7 @@ static inline void __local_send_IPI_allbutself(int vector)
 static inline void __local_send_IPI_all(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(&cpu_online_map, vector);
+		send_IPI_mask(cpu_online_mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
diff --git a/arch/x86/include/asm/numaq/ipi.h b/arch/x86/include/asm/numaq/ipi.h
index c734d7a..a8374c6 100644
--- a/arch/x86/include/asm/numaq/ipi.h
+++ b/arch/x86/include/asm/numaq/ipi.h
@@ -1,26 +1,22 @@
 #ifndef __ASM_NUMAQ_IPI_H
 #define __ASM_NUMAQ_IPI_H
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(&mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(&cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_NUMAQ_IPI_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index c4a9aa5..830b9fc 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -60,7 +60,7 @@ struct smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
 
-	void (*send_call_func_ipi)(const cpumask_t *mask);
+	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -138,7 +138,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 
-void native_send_call_func_ipi(const cpumask_t *mask);
+void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 
 extern void prefill_possible_map(void);
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index c772bb1..7fa5f49 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -30,12 +30,12 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 1;
 }
 
-static const cpumask_t *flat_target_cpus(void)
+static const struct cpumask *flat_target_cpus(void)
 {
-	return &cpu_online_map;
+	return cpu_online_mask;
 }
 
-static void flat_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -45,7 +45,8 @@ static void flat_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t) { {[0] = APIC_ALL_CPUS, } };
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 /*
@@ -77,16 +78,17 @@ static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 	local_irq_restore(flags);
 }
 
-static void flat_send_IPI_mask(const cpumask_t *cpumask, int vector)
+static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(*cpumask)[0];
+	unsigned long mask = cpumask_bits(cpumask)[0];
 
 	_flat_send_IPI_mask(mask, vector);
 }
 
-static void flat_send_IPI_mask_allbutself(const cpumask_t *cpumask, int vector)
+static void flat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
+					  int vector)
 {
-	unsigned long mask = cpus_addr(*cpumask)[0];
+	unsigned long mask = cpumask_bits(cpumask)[0];
 	int cpu = smp_processor_id();
 
 	if (cpu < BITS_PER_LONG)
@@ -103,8 +105,8 @@ static void flat_send_IPI_allbutself(int vector)
 	int hotplug = 0;
 #endif
 	if (hotplug || vector == NMI_VECTOR) {
-		if (!cpus_equal(cpu_online_map, cpumask_of_cpu(cpu))) {
-			unsigned long mask = cpus_addr(cpu_online_map)[0];
+		if (!cpumask_equal(cpu_online_mask, cpumask_of(cpu))) {
+			unsigned long mask = cpumask_bits(cpu_online_mask)[0];
 
 			if (cpu < BITS_PER_LONG)
 				clear_bit(cpu, &mask);
@@ -119,7 +121,7 @@ static void flat_send_IPI_allbutself(int vector)
 static void flat_send_IPI_all(int vector)
 {
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(&cpu_online_map, vector);
+		flat_send_IPI_mask(cpu_online_mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -153,9 +155,9 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int flat_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
+	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static unsigned int flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -217,23 +219,23 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static const cpumask_t *physflat_target_cpus(void)
+static const struct cpumask *physflat_target_cpus(void)
 {
-	return &cpu_online_map;
+	return cpu_online_mask;
 }
 
-static void physflat_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
-static void physflat_send_IPI_mask(const cpumask_t *cpumask, int vector)
+static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
 	send_IPI_mask_sequence(cpumask, vector);
 }
 
-static void physflat_send_IPI_mask_allbutself(const cpumask_t *cpumask,
+static void physflat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
 					      int vector)
 {
 	send_IPI_mask_allbutself(cpumask, vector);
@@ -241,15 +243,15 @@ static void physflat_send_IPI_mask_allbutself(const cpumask_t *cpumask,
 
 static void physflat_send_IPI_allbutself(int vector)
 {
-	send_IPI_mask_allbutself(&cpu_online_map, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(&cpu_online_map, vector);
+	physflat_send_IPI_mask(cpu_online_mask, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -257,7 +259,7 @@ static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index e7d16f5..4716a0c 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -22,18 +22,18 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static const cpumask_t *x2apic_target_cpus(void)
+static const struct cpumask *x2apic_target_cpus(void)
 {
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
 /*
  * for now each logical cpu is in its own vector allocation domain.
  */
-static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -55,27 +55,28 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu(query_cpu, mask)
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 			vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu(query_cpu, mask)
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
@@ -100,7 +101,7 @@ static void x2apic_send_IPI_allbutself(int vector)
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(&cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -108,7 +109,7 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -116,7 +117,7 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 9d0386c..b255507 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -29,15 +29,15 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static const cpumask_t *x2apic_target_cpus(void)
+static const struct cpumask *x2apic_target_cpus(void)
 {
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
-static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -53,27 +53,28 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
 	x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask) {
+	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 	unsigned long this_cpu = smp_processor_id();
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask) {
+	for_each_cpu(query_cpu, mask) {
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_apicid, query_cpu),
@@ -99,7 +100,7 @@ static void x2apic_send_IPI_allbutself(int vector)
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(&cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -107,7 +108,7 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -115,7 +116,7 @@ static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 22596ec..3984682 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -75,15 +75,15 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static const cpumask_t *uv_target_cpus(void)
+static const struct cpumask *uv_target_cpus(void)
 {
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
-static void uv_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
@@ -122,20 +122,20 @@ static void uv_send_IPI_one(int cpu, int vector)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(const cpumask_t *mask, int vector)
+static void uv_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		uv_send_IPI_one(cpu, vector);
 }
 
-static void uv_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+static void uv_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned int cpu;
 	unsigned int this_cpu = smp_processor_id();
 
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		if (cpu != this_cpu)
 			uv_send_IPI_one(cpu, vector);
 }
@@ -152,7 +152,7 @@ static void uv_send_IPI_allbutself(int vector)
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(&cpu_online_map, vector);
+	uv_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int uv_apic_id_registered(void)
@@ -164,7 +164,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -172,7 +172,7 @@ static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index 86aa50f..285bbf8 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -116,18 +116,18 @@ static inline void __send_IPI_dest_field(unsigned long mask, int vector)
 /*
  * This is only used on smaller machines.
  */
-void send_IPI_mask_bitmask(const cpumask_t *cpumask, int vector)
+void send_IPI_mask_bitmask(const struct cpumask *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(*cpumask)[0];
+	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
-	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
+	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
 	__send_IPI_dest_field(mask, vector);
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -139,12 +139,12 @@ void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
 	 */
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu(query_cpu, mask)
 		__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu), vector);
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -153,7 +153,7 @@ void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
 	/* See Hack comment above */
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu(query_cpu, mask)
 		if (query_cpu != this_cpu)
 			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
 					      vector);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index f1c7fa4..dd88196 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,15 +118,15 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(&cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+	send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(&cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(const cpumask_t *mask)
+void native_send_call_func_ipi(const struct cpumask *mask)
 {
 	cpumask_t allbutself;
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index b3a9586..c44e206 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -411,22 +411,23 @@ static void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(const cpumask_t *mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const struct cpumask *mask,
+			      enum ipi_vector vector)
 {
 	unsigned cpu;
 
-	for_each_cpu_and(cpu, mask, &cpu_online_map)
+	for_each_cpu_and(cpu, mask, cpu_online_mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(const cpumask_t *mask)
+static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 {
 	int cpu;
 
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
@@ -436,7 +437,7 @@ static void xen_smp_send_call_function_ipi(const cpumask_t *mask)
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(&cpumask_of_cpu(cpu),
+	xen_send_IPI_mask(cpumask_of(cpu),
 			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-- 
1.6.0

-- 
