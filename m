Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYLPC2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYLPC2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYLPCY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:27 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40562 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751995AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022409.977486000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:10 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 01/16] x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
Content-Disposition: inline; filename=0002-x86-smp-modify-send_IPI_mask-interface-to-accept-cp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, change parameter passing

  * Change genapic interfaces to accept cpumask_t pointers where possible.

  * Modify external callers to use cpumask_t pointers in function calls.

  * Create new send_IPI_mask_allbutself which is the same as the
    send_IPI_mask functions but removes smp_processor_id() from list.
    This removes another common need for a temporary cpumask_t variable.

  * Functions that used a temp cpumask_t variable for:

	cpumask_t allbutme = cpu_online_map;

	cpu_clear(smp_processor_id(), allbutme);
	if (!cpus_empty(allbutme))
		...

    become:

	if (!cpus_equal(cpu_online_map, cpumask_of_cpu(cpu)))
		...

  * Other minor code optimizations (like using cpus_clear instead of
    CPU_MASK_NONE, etc.)

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |   14 +-
 arch/x86/include/asm/bigsmp/ipi.h             |    9 -
 arch/x86/include/asm/es7000/apic.h            |   38 +++----
 arch/x86/include/asm/es7000/ipi.h             |    9 -
 arch/x86/include/asm/genapic_32.h             |    9 -
 arch/x86/include/asm/genapic_64.h             |   11 +-
 arch/x86/include/asm/ipi.h                    |   21 +++
 arch/x86/include/asm/mach-default/mach_apic.h |   17 +--
 arch/x86/include/asm/mach-default/mach_ipi.h  |   18 +--
 arch/x86/include/asm/numaq/apic.h             |    6 -
 arch/x86/include/asm/numaq/ipi.h              |    9 -
 arch/x86/include/asm/smp.h                    |    6 -
 arch/x86/include/asm/summit/apic.h            |   12 +-
 arch/x86/include/asm/summit/ipi.h             |    9 -
 arch/x86/kernel/apic.c                        |    6 -
 arch/x86/kernel/crash.c                       |    5 
 arch/x86/kernel/genapic_flat_64.c             |   76 +++++++++-----
 arch/x86/kernel/genx2apic_cluster.c           |   60 +++++++----
 arch/x86/kernel/genx2apic_phys.c              |   55 +++++++---
 arch/x86/kernel/genx2apic_uv_x.c              |   43 ++++---
 arch/x86/kernel/io_apic.c                     |  141 +++++++++++++-------------
 arch/x86/kernel/ipi.c                         |   26 +++-
 arch/x86/kernel/smp.c                         |    8 -
 arch/x86/kernel/tlb_32.c                      |    2 
 arch/x86/kernel/tlb_64.c                      |    2 
 arch/x86/mach-generic/bigsmp.c                |    5 
 arch/x86/mach-generic/es7000.c                |    5 
 arch/x86/mach-generic/numaq.c                 |    5 
 arch/x86/mach-generic/summit.c                |    5 
 arch/x86/xen/smp.c                            |   17 +--
 30 files changed, 378 insertions(+), 271 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/include/asm/bigsmp/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/bigsmp/apic.h
@@ -9,12 +9,12 @@ static inline int apic_id_registered(voi
 	return (1);
 }
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
 #ifdef CONFIG_SMP
-        return cpu_online_map;
+	return &cpu_online_map;
 #else
-        return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 #endif
 }
 
@@ -79,7 +79,7 @@ static inline int apicid_to_node(int log
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-	if (mps_cpu < NR_CPUS)
+	if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 
 	return BAD_APICID;
@@ -94,7 +94,7 @@ extern u8 cpu_2_logical_apicid[];
 /* Mapping from cpu number to logical apicid */
 static inline int cpu_to_logical_apicid(int cpu)
 {
-	if (cpu >= NR_CPUS)
+	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
 	return cpu_physical_id(cpu);
 }
@@ -119,12 +119,12 @@ static inline int check_phys_apicid_pres
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 	int apicid;	
 
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	return apicid;
 }
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/bigsmp/ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/bigsmp/ipi.h
@@ -1,9 +1,10 @@
 #ifndef __ASM_MACH_IPI_H
 #define __ASM_MACH_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
@@ -14,12 +15,12 @@ static inline void send_IPI_allbutself(i
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(&cpu_online_map, vector);
 }
 
 #endif /* __ASM_MACH_IPI_H */
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/es7000/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/es7000/apic.h
@@ -9,14 +9,14 @@ static inline int apic_id_registered(voi
 	        return (1);
 }
 
-static inline cpumask_t target_cpus_cluster(void)
+static inline const cpumask_t *target_cpus_cluster(void)
 {
-	return CPU_MASK_ALL;
+	return &CPU_MASK_ALL;
 }
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
-	return cpumask_of_cpu(smp_processor_id());
+	return &cpumask_of_cpu(smp_processor_id());
 }
 
 #define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
@@ -80,9 +80,10 @@ extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
+	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
-		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(target_cpus())[0]);
+			"Physical Cluster" : "Logical Cluster",
+			nr_ioapics, cpus_addr(*target_cpus())[0]);
 }
 
 static inline int multi_timer_check(int apic, int irq)
@@ -100,7 +101,7 @@ static inline int cpu_present_to_apicid(
 {
 	if (!mps_cpu)
 		return boot_cpu_physical_apicid;
-	else if (mps_cpu < NR_CPUS)
+	else if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
@@ -120,9 +121,9 @@ extern u8 cpu_2_logical_apicid[];
 static inline int cpu_to_logical_apicid(int cpu)
 {
 #ifdef CONFIG_SMP
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
-       return (int)cpu_2_logical_apicid[cpu];
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
 #else
 	return logical_smp_processor_id();
 #endif
@@ -146,14 +147,15 @@ static inline int check_phys_apicid_pres
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid_cluster(cpumask_t cpumask)
+static inline unsigned int
+cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpumask_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return 0xFF;
@@ -161,10 +163,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
@@ -179,14 +181,14 @@ static inline unsigned int cpu_mask_to_a
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return cpu_to_logical_apicid(0);
@@ -194,10 +196,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/es7000/ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/es7000/ipi.h
@@ -1,9 +1,10 @@
 #ifndef __ASM_ES7000_IPI_H
 #define __ASM_ES7000_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
@@ -13,12 +14,12 @@ static inline void send_IPI_allbutself(i
 	cpumask_t mask = cpu_online_map;
 	cpu_clear(smp_processor_id(), mask);
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(&cpu_online_map, vector);
 }
 
 #endif /* __ASM_ES7000_IPI_H */
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/genapic_32.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/genapic_32.h
@@ -24,7 +24,7 @@ struct genapic {
 	int (*probe)(void);
 
 	int (*apic_id_registered)(void);
-	cpumask_t (*target_cpus)(void);
+	const cpumask_t *(*target_cpus)(void);
 	int int_delivery_mode;
 	int int_dest_mode;
 	int ESR_DISABLE;
@@ -57,12 +57,13 @@ struct genapic {
 
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/genapic_64.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/genapic_64.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_GENAPIC_64_H
 #define _ASM_X86_GENAPIC_64_H
 
+#include <linux/cpumask.h>
+
 /*
  * Copyright 2004 James Cleverdon, IBM.
  * Subject to the GNU Public License, v.2
@@ -18,16 +20,17 @@ struct genapic {
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
-	cpumask_t (*target_cpus)(void);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	const cpumask_t *(*target_cpus)(void);
+	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 	/* */
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/ipi.h
@@ -117,7 +117,7 @@ static inline void __send_IPI_dest_field
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
+static inline void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -128,11 +128,28 @@ static inline void send_IPI_mask_sequenc
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, mask) {
+	for_each_cpu_mask_nr(query_cpu, *mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
+static inline void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu_mask_nr(query_cpu, *mask)
+		if (query_cpu != this_cpu)
+			__send_IPI_dest_field(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	local_irq_restore(flags);
+}
+
 #endif /* _ASM_X86_IPI_H */
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/mach-default/mach_apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/mach-default/mach_apic.h
@@ -8,12 +8,12 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 { 
 #ifdef CONFIG_SMP
-	return cpu_online_map;
+	return &cpu_online_map;
 #else
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 #endif
 } 
 
@@ -61,9 +61,9 @@ static inline int apic_id_registered(voi
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	return cpus_addr(cpumask)[0];
+	return cpus_addr(*cpumask)[0];
 }
 
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
@@ -88,7 +88,7 @@ static inline int apicid_to_node(int log
 #endif
 }
 
-static inline cpumask_t vector_allocation_domain(int cpu)
+static inline void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
         /* Careful. Some cpus do not strictly honor the set of cpus
          * specified in the interrupt destination when using lowest
@@ -98,8 +98,7 @@ static inline cpumask_t vector_allocatio
          * deliver interrupts to the wrong hyperthread when only one
          * hyperthread was specified in the interrupt desitination.
          */
-        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-        return domain;
+	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
 }
 #endif
 
@@ -131,7 +130,7 @@ static inline int cpu_to_logical_apicid(
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-	if (mps_cpu < NR_CPUS && cpu_present(mps_cpu))
+	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/mach-default/mach_ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/mach-default/mach_ipi.h
@@ -4,7 +4,8 @@
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
-void send_IPI_mask_bitmask(cpumask_t mask, int vector);
+void send_IPI_mask_bitmask(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 void __send_IPI_shortcut(unsigned int shortcut, int vector);
 
 extern int no_broadcast;
@@ -12,28 +13,27 @@ extern int no_broadcast;
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
 #define send_IPI_mask (genapic->send_IPI_mask)
+#define send_IPI_mask_allbutself (genapic->send_IPI_mask_allbutself)
 #else
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_bitmask(mask, vector);
 }
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 #endif
 
 static inline void __local_send_IPI_allbutself(int vector)
 {
-	if (no_broadcast || vector == NMI_VECTOR) {
-		cpumask_t mask = cpu_online_map;
-
-		cpu_clear(smp_processor_id(), mask);
-		send_IPI_mask(mask, vector);
-	} else
+	if (no_broadcast || vector == NMI_VECTOR)
+		send_IPI_mask_allbutself(&cpu_online_map, vector);
+	else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }
 
 static inline void __local_send_IPI_all(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(cpu_online_map, vector);
+		send_IPI_mask(&cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/numaq/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/numaq/apic.h
@@ -7,9 +7,9 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
-	return CPU_MASK_ALL;
+	return &CPU_MASK_ALL;
 }
 
 #define NO_BALANCE_IRQ (1)
@@ -122,7 +122,7 @@ static inline void enable_apic_mode(void
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	return (int) 0xF;
 }
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/numaq/ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/numaq/ipi.h
@@ -1,9 +1,10 @@
 #ifndef __ASM_NUMAQ_IPI_H
 #define __ASM_NUMAQ_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t, int vector);
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
@@ -14,12 +15,12 @@ static inline void send_IPI_allbutself(i
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(&cpu_online_map, vector);
 }
 
 #endif /* __ASM_NUMAQ_IPI_H */
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/smp.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/smp.h
@@ -60,7 +60,7 @@ struct smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
 
-	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_ipi)(const cpumask_t *mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -125,7 +125,7 @@ static inline void arch_send_call_functi
 
 static inline void arch_send_call_function_ipi(cpumask_t mask)
 {
-	smp_ops.send_call_func_ipi(mask);
+	smp_ops.send_call_func_ipi(&mask);
 }
 
 void cpu_disable_common(void);
@@ -138,7 +138,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 
-void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_ipi(const cpumask_t *mask);
 void native_send_call_func_single_ipi(int cpu);
 
 extern void prefill_possible_map(void);
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/summit/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/summit/apic.h
@@ -14,13 +14,13 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
 	/* CPU_MASK_ALL (0xff) has undefined behaviour with
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
 	 * Just start on cpu 0.  IRQ balancing will spread load
 	 */
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 }
 
 #define INT_DELIVERY_MODE (dest_LowestPrio)
@@ -137,14 +137,14 @@ static inline void enable_apic_mode(void
 {
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return (int) 0xFF;
@@ -152,10 +152,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/summit/ipi.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/summit/ipi.h
@@ -1,9 +1,10 @@
 #ifndef __ASM_SUMMIT_IPI_H
 #define __ASM_SUMMIT_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
@@ -14,12 +15,12 @@ static inline void send_IPI_allbutself(i
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(&cpu_online_map, vector);
 }
 
 #endif /* __ASM_SUMMIT_IPI_H */
--- linux-2.6-for-ingo.orig/arch/x86/kernel/apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/apic.c
@@ -141,7 +141,7 @@ static int lapic_next_event(unsigned lon
 			    struct clock_event_device *evt);
 static void lapic_timer_setup(enum clock_event_mode mode,
 			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(const struct cpumask *mask);
+static void lapic_timer_broadcast(const cpumask_t *mask);
 static void apic_pm_activate(void);
 
 /*
@@ -453,10 +453,10 @@ static void lapic_timer_setup(enum clock
 /*
  * Local APIC timer broadcast function
  */
-static void lapic_timer_broadcast(const struct cpumask *mask)
+static void lapic_timer_broadcast(const cpumask_t *mask)
 {
 #ifdef CONFIG_SMP
-	send_IPI_mask(*mask, LOCAL_TIMER_VECTOR);
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/crash.c
+++ linux-2.6-for-ingo/arch/x86/kernel/crash.c
@@ -77,10 +77,7 @@ static int crash_nmi_callback(struct not
 
 static void smp_send_nmi_allbutself(void)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(safe_smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, NMI_VECTOR);
+	send_IPI_allbutself(NMI_VECTOR);
 }
 
 static struct notifier_block crash_nmi_nb = {
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genapic_flat_64.c
@@ -30,12 +30,12 @@ static int flat_acpi_madt_oem_check(char
 	return 1;
 }
 
-static cpumask_t flat_target_cpus(void)
+static const cpumask_t *flat_target_cpus(void)
 {
-	return cpu_online_map;
+	return &cpu_online_map;
 }
 
-static cpumask_t flat_vector_allocation_domain(int cpu)
+static void flat_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -45,8 +45,7 @@ static cpumask_t flat_vector_allocation_
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t) { {[0] = APIC_ALL_CPUS, } };
 }
 
 /*
@@ -69,9 +68,8 @@ static void flat_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
+static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -79,20 +77,40 @@ static void flat_send_IPI_mask(cpumask_t
 	local_irq_restore(flags);
 }
 
+static void flat_send_IPI_mask(const cpumask_t *cpumask, int vector)
+{
+	unsigned long mask = cpus_addr(*cpumask)[0];
+
+	_flat_send_IPI_mask(mask, vector);
+}
+
+static void flat_send_IPI_mask_allbutself(const cpumask_t *cpumask, int vector)
+{
+	unsigned long mask = cpus_addr(*cpumask)[0];
+	int cpu = smp_processor_id();
+
+	if (cpu < BITS_PER_LONG)
+		clear_bit(cpu, &mask);
+	_flat_send_IPI_mask(mask, vector);
+}
+
 static void flat_send_IPI_allbutself(int vector)
 {
+	int cpu = smp_processor_id();
 #ifdef	CONFIG_HOTPLUG_CPU
 	int hotplug = 1;
 #else
 	int hotplug = 0;
 #endif
 	if (hotplug || vector == NMI_VECTOR) {
-		cpumask_t allbutme = cpu_online_map;
+		if (!cpus_equal(cpu_online_map, cpumask_of_cpu(cpu))) {
+			unsigned long mask = cpus_addr(cpu_online_map)[0];
 
-		cpu_clear(smp_processor_id(), allbutme);
+			if (cpu < BITS_PER_LONG)
+				clear_bit(cpu, &mask);
 
-		if (!cpus_empty(allbutme))
-			flat_send_IPI_mask(allbutme, vector);
+			_flat_send_IPI_mask(mask, vector);
+		}
 	} else if (num_online_cpus() > 1) {
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
 	}
@@ -101,7 +119,7 @@ static void flat_send_IPI_allbutself(int
 static void flat_send_IPI_all(int vector)
 {
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(cpu_online_map, vector);
+		flat_send_IPI_mask(&cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -135,9 +153,9 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	return cpus_addr(cpumask)[0] & APIC_ALL_CPUS;
+	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static unsigned int phys_pkg_id(int index_msb)
@@ -157,6 +175,7 @@ struct genapic apic_flat =  {
 	.send_IPI_all = flat_send_IPI_all,
 	.send_IPI_allbutself = flat_send_IPI_allbutself,
 	.send_IPI_mask = flat_send_IPI_mask,
+	.send_IPI_mask_allbutself = flat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
@@ -188,35 +207,39 @@ static int physflat_acpi_madt_oem_check(
 	return 0;
 }
 
-static cpumask_t physflat_target_cpus(void)
+static const cpumask_t *physflat_target_cpus(void)
 {
-	return cpu_online_map;
+	return &cpu_online_map;
 }
 
-static cpumask_t physflat_vector_allocation_domain(int cpu)
+static void physflat_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	return cpumask_of_cpu(cpu);
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
-static void physflat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void physflat_send_IPI_mask(const cpumask_t *cpumask, int vector)
 {
 	send_IPI_mask_sequence(cpumask, vector);
 }
 
-static void physflat_send_IPI_allbutself(int vector)
+static void physflat_send_IPI_mask_allbutself(const cpumask_t *cpumask,
+					      int vector)
 {
-	cpumask_t allbutme = cpu_online_map;
+	send_IPI_mask_allbutself(cpumask, vector);
+}
 
-	cpu_clear(smp_processor_id(), allbutme);
-	physflat_send_IPI_mask(allbutme, vector);
+static void physflat_send_IPI_allbutself(int vector)
+{
+	send_IPI_mask_allbutself(&cpu_online_map, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_map, vector);
+	physflat_send_IPI_mask(&cpu_online_map, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -224,7 +247,7 @@ static unsigned int physflat_cpu_mask_to
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
@@ -243,6 +266,7 @@ struct genapic apic_physflat =  {
 	.send_IPI_all = physflat_send_IPI_all,
 	.send_IPI_allbutself = physflat_send_IPI_allbutself,
 	.send_IPI_mask = physflat_send_IPI_mask,
+	.send_IPI_mask_allbutself = physflat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_cluster.c
@@ -22,19 +22,18 @@ static int x2apic_acpi_madt_oem_check(ch
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static const cpumask_t *x2apic_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 }
 
 /*
  * for now each logical cpu is in its own vector allocation domain.
  */
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -56,32 +55,52 @@ static void __x2apic_send_IPI_dest(unsig
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				       vector, APIC_DEST_LOGICAL);
-	}
+	for_each_cpu_mask_nr(query_cpu, *mask)
+		__x2apic_send_IPI_dest(
+			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_allbutself(int vector)
+static void x2apic_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
 
-	cpu_clear(smp_processor_id(), mask);
+	local_irq_save(flags);
+	for_each_cpu_mask_nr(query_cpu, *mask)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				vector, APIC_DEST_LOGICAL);
+	local_irq_restore(flags);
+}
 
-	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
+
+	local_irq_save(flags);
+	for_each_online_cpu(query_cpu)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				vector, APIC_DEST_LOGICAL);
+	local_irq_restore(flags);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -89,7 +108,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -97,8 +116,8 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = first_cpu(*cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
 		return BAD_APICID;
@@ -150,6 +169,7 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_all = x2apic_send_IPI_all,
 	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
 	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_phys.c
@@ -29,16 +29,15 @@ static int x2apic_acpi_madt_oem_check(ch
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static const cpumask_t *x2apic_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 }
 
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -54,32 +53,53 @@ static void __x2apic_send_IPI_dest(unsig
 	x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
+	for_each_cpu_mask_nr(query_cpu, *mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_allbutself(int vector)
+static void x2apic_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
+
+	local_irq_save(flags);
+	for_each_cpu_mask_nr(query_cpu, *mask) {
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
 
-	cpu_clear(smp_processor_id(), mask);
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
 
-	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+	local_irq_save(flags);
+	for_each_online_cpu(query_cpu)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	local_irq_restore(flags);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -87,7 +107,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -95,8 +115,8 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = first_cpu(*cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
@@ -145,6 +165,7 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_all = x2apic_send_IPI_all,
 	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
 	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_uv_x.c
@@ -75,16 +75,15 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t uv_target_cpus(void)
+static const cpumask_t *uv_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 }
 
-static cpumask_t uv_vector_allocation_domain(int cpu)
+static void uv_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
@@ -123,28 +122,37 @@ static void uv_send_IPI_one(int cpu, int
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(cpumask_t mask, int vector)
+static void uv_send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	unsigned int cpu;
 
-	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, mask))
+	for_each_cpu_mask_nr(cpu, *mask)
+		uv_send_IPI_one(cpu, vector);
+}
+
+static void uv_send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+{
+	unsigned int cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	for_each_cpu_mask_nr(cpu, *mask)
+		if (cpu != this_cpu)
 			uv_send_IPI_one(cpu, vector);
 }
 
 static void uv_send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-
-	cpu_clear(smp_processor_id(), mask);
+	unsigned int cpu;
+	unsigned int this_cpu = smp_processor_id();
 
-	if (!cpus_empty(mask))
-		uv_send_IPI_mask(mask, vector);
+	for_each_online_cpu(cpu)
+		if (cpu != this_cpu)
+			uv_send_IPI_one(cpu, vector);
 }
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(cpu_online_map, vector);
+	uv_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int uv_apic_id_registered(void)
@@ -156,7 +164,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -164,7 +172,7 @@ static unsigned int uv_cpu_mask_to_apici
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
@@ -218,6 +226,7 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
+	.send_IPI_mask_allbutself = uv_send_IPI_mask_allbutself,
 	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
--- linux-2.6-for-ingo.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/io_apic.c
@@ -231,7 +231,8 @@ static struct irq_cfg *irq_cfg(unsigned 
 
 #endif
 
-static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+static inline void
+set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 }
 
@@ -396,7 +397,8 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
+static int
+assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
 
 static void set_ioapic_affinity_irq_desc(struct irq_desc *desc,
 					 const struct cpumask *mask)
@@ -412,13 +414,13 @@ static void set_ioapic_affinity_irq_desc
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, *mask);
+	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 	/*
 	 * Only the high 8 bits are valid.
 	 */
@@ -1099,7 +1101,8 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
+static int
+__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1115,35 +1118,32 @@ static int __assign_irq_vector(int irq, 
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
 	int cpu;
+	cpumask_t tmp_mask;
 
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
-	/* Only try and allocate irqs on cpus that are present */
-	cpus_and(mask, mask, cpu_online_map);
-
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpumask_t tmp;
-		cpus_and(tmp, cfg->domain, mask);
-		if (!cpus_empty(tmp))
+		cpus_and(tmp_mask, *mask, cpu_online_map);
+		cpus_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpus_empty(tmp_mask))
 			return 0;
 	}
 
-	for_each_cpu_mask_nr(cpu, mask) {
-		cpumask_t domain, new_mask;
+	/* Only try and allocate irqs on cpus that are present */
+	for_each_cpu_and(cpu, mask, &cpu_online_map) {
 		int new_cpu;
 		int vector, offset;
 
-		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
+		vector_allocation_domain(cpu, &tmp_mask);
 
 		vector = current_vector;
 		offset = current_offset;
 next:
 		vector += 8;
 		if (vector >= first_system_vector) {
-			/* If we run out of vectors on large boxen, must share them. */
+			/* If out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
 			vector = FIRST_DEVICE_VECTOR + offset;
 		}
@@ -1156,7 +1156,7 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+		for_each_cpu_and(new_cpu, &tmp_mask, &cpu_online_map)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1166,16 +1166,17 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+		for_each_cpu_and(new_cpu, &tmp_mask, &cpu_online_map)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
-		cfg->domain = domain;
+		cfg->domain = tmp_mask;
 		return 0;
 	}
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
+static int
+assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
@@ -1384,8 +1385,8 @@ static void setup_IO_APIC_irq(int apic, 
 
 	cfg = desc->chip_data;
 
-	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, cfg, mask))
+	mask = *TARGET_CPUS;
+	if (assign_irq_vector(irq, cfg, &mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1398,7 +1399,7 @@ static void setup_IO_APIC_irq(int apic, 
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(mask), trigger, polarity,
+			       cpu_mask_to_apicid(&mask), trigger, polarity,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
@@ -2121,7 +2122,7 @@ static int ioapic_retrigger_irq(unsigned
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	send_IPI_mask(&cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -2170,18 +2171,19 @@ static DECLARE_DELAYED_WORK(ir_migration
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
+static void
+migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	cpumask_t tmp, cleanup_mask;
+	cpumask_t tmpmask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 	unsigned int irq;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	cpus_and(tmpmask, *mask, cpu_online_map);
+	if (cpus_empty(tmpmask))
 		return;
 
 	irq = desc->irq;
@@ -2194,8 +2196,8 @@ static void migrate_ioapic_irq_desc(stru
 
 	set_extra_move_desc(desc, mask);
 
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(tmpmask, cfg->domain, *mask);
+	dest = cpu_mask_to_apicid(&tmpmask);
 
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
@@ -2213,13 +2215,13 @@ static void migrate_ioapic_irq_desc(stru
 	modify_irte(irq, &irte);
 
 	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cpus_and(tmpmask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(tmpmask);
+		send_IPI_mask(&tmpmask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
-	desc->affinity = mask;
+	desc->affinity = *mask;
 }
 
 static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
@@ -2241,7 +2243,7 @@ static int migrate_irq_remapped_level_de
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq_desc(desc, desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, &desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
@@ -2359,7 +2361,7 @@ static void irq_complete_move(struct irq
 
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 }
@@ -3089,13 +3091,13 @@ static int msi_compose_msg(struct pci_de
 	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, cfg, tmp);
+	tmp = *TARGET_CPUS;
+	err = assign_irq_vector(irq, cfg, &tmp);
 	if (err)
 		return err;
 
 	cpus_and(tmp, cfg->domain, tmp);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3161,13 +3163,13 @@ static void set_msi_irq_affinity(unsigne
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, *mask);
+	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 	read_msi_msg_desc(desc, &msg);
 
@@ -3184,8 +3186,8 @@ static void set_msi_irq_affinity(unsigne
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq,
-				    const struct cpumask *mask)
+static void
+ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3200,13 +3202,13 @@ static void ir_set_msi_irq_affinity(unsi
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3224,7 +3226,7 @@ static void ir_set_msi_irq_affinity(unsi
 	if (cfg->move_in_progress) {
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
@@ -3419,7 +3421,7 @@ void arch_teardown_msi_irq(unsigned int 
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static void dmar_msi_set_affinity(unsigned int irq, const cpumask_t *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3431,13 +3433,13 @@ static void dmar_msi_set_affinity(unsign
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, *mask);
+	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3481,7 +3483,7 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static void hpet_msi_set_affinity(unsigned int irq, const cpumask_t *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3493,13 +3495,13 @@ static void hpet_msi_set_affinity(unsign
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, *mask);
+	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3564,7 +3566,7 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static void set_ht_irq_affinity(unsigned int irq, const cpumask_t *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3575,13 +3577,13 @@ static void set_ht_irq_affinity(unsigned
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, *mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, *mask);
+	set_extra_move_desc(desc, mask);
 
 	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid(&tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	cpumask_copy(&desc->affinity, mask);
@@ -3607,14 +3609,13 @@ int arch_setup_ht_irq(unsigned int irq, 
 	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, cfg, tmp);
+	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
 		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(tmp);
+		dest = cpu_mask_to_apicid(&tmp);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3650,7 +3651,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset)
 {
-	const cpumask_t *eligible_cpu = get_cpu_mask(cpu);
+	const cpumask_t *eligible_cpu = &cpumask_of_cpu(cpu);
 	struct irq_cfg *cfg;
 	int mmr_pnode;
 	unsigned long mmr_value;
@@ -3660,7 +3661,7 @@ int arch_enable_uv_irq(char *irq_name, u
 
 	cfg = irq_cfg(irq);
 
-	err = assign_irq_vector(irq, cfg, *eligible_cpu);
+	err = assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3679,7 +3680,7 @@ int arch_enable_uv_irq(char *irq_name, u
 	entry->polarity = 0;
 	entry->trigger = 0;
 	entry->mask = 0;
-	entry->dest = cpu_mask_to_apicid(*eligible_cpu);
+	entry->dest = cpu_mask_to_apicid(eligible_cpu);
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
@@ -3890,7 +3891,7 @@ void __init setup_ioapic_dest(void)
 	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	cpumask_t mask;
+	const cpumask_t *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3921,16 +3922,16 @@ void __init setup_ioapic_dest(void)
 			 */
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = desc->affinity;
+				mask = &desc->affinity;
 			else
 				mask = TARGET_CPUS;
 
 #ifdef CONFIG_INTR_REMAP
 			if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq_desc(desc, &mask);
+				set_ir_ioapic_affinity_irq_desc(desc, mask);
 			else
 #endif
-				set_ioapic_affinity_irq_desc(desc, &mask);
+				set_ioapic_affinity_irq_desc(desc, mask);
 		}
 
 	}
--- linux-2.6-for-ingo.orig/arch/x86/kernel/ipi.c
+++ linux-2.6-for-ingo/arch/x86/kernel/ipi.c
@@ -116,9 +116,9 @@ static inline void __send_IPI_dest_field
 /*
  * This is only used on smaller machines.
  */
-void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
+void send_IPI_mask_bitmask(const cpumask_t *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long mask = cpus_addr(*cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -127,7 +127,7 @@ void send_IPI_mask_bitmask(cpumask_t cpu
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector)
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -139,12 +139,24 @@ void send_IPI_mask_sequence(cpumask_t ma
 	 */
 
 	local_irq_save(flags);
-	for_each_possible_cpu(query_cpu) {
-		if (cpu_isset(query_cpu, mask)) {
+	for_each_cpu_mask_nr(query_cpu, *mask)
+		__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu), vector);
+	local_irq_restore(flags);
+}
+
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu_mask_nr(query_cpu, *mask)
+		if (query_cpu != this_cpu)
 			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
 					      vector);
-		}
-	}
 	local_irq_restore(flags);
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/smp.c
+++ linux-2.6-for-ingo/arch/x86/kernel/smp.c
@@ -118,22 +118,22 @@ static void native_smp_send_reschedule(i
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+	send_IPI_mask(&cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	send_IPI_mask(&cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(cpumask_t mask)
+void native_send_call_func_ipi(const cpumask_t *mask)
 {
 	cpumask_t allbutself;
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
-	if (cpus_equal(mask, allbutself) &&
+	if (cpus_equal(*mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
--- linux-2.6-for-ingo.orig/arch/x86/kernel/tlb_32.c
+++ linux-2.6-for-ingo/arch/x86/kernel/tlb_32.c
@@ -164,7 +164,7 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
 
 	while (!cpus_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
--- linux-2.6-for-ingo.orig/arch/x86/kernel/tlb_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/tlb_64.c
@@ -191,7 +191,7 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpus_empty(f->flush_cpumask))
 		cpu_relax();
--- linux-2.6-for-ingo.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6-for-ingo/arch/x86/mach-generic/bigsmp.c
@@ -42,9 +42,10 @@ static const struct dmi_system_id bigsmp
 	 { }
 };
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-        return cpumask_of_cpu(cpu);
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
 static int probe_bigsmp(void)
--- linux-2.6-for-ingo.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6-for-ingo/arch/x86/mach-generic/es7000.c
@@ -87,7 +87,7 @@ static int __init acpi_madt_oem_check(ch
 }
 #endif
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -97,8 +97,7 @@ static cpumask_t vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
--- linux-2.6-for-ingo.orig/arch/x86/mach-generic/numaq.c
+++ linux-2.6-for-ingo/arch/x86/mach-generic/numaq.c
@@ -38,7 +38,7 @@ static int acpi_madt_oem_check(char *oem
 	return 0;
 }
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -48,8 +48,7 @@ static cpumask_t vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic apic_numaq = APIC_INIT("NUMAQ", probe_numaq);
--- linux-2.6-for-ingo.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6-for-ingo/arch/x86/mach-generic/summit.c
@@ -24,7 +24,7 @@ static int probe_summit(void)
 	return 0;
 }
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -34,8 +34,7 @@ static cpumask_t vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic apic_summit = APIC_INIT("summit", probe_summit);
--- linux-2.6-for-ingo.orig/arch/x86/xen/smp.c
+++ linux-2.6-for-ingo/arch/x86/xen/smp.c
@@ -158,7 +158,7 @@ static void __init xen_fill_possible_map
 {
 	int i, rc;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0) {
 			num_processors++;
@@ -196,7 +196,7 @@ static void __init xen_smp_prepare_cpus(
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
-		for (cpu = NR_CPUS - 1; !cpu_possible(cpu); cpu--)
+		for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
 			continue;
 		cpu_clear(cpu, cpu_possible_map);
 	}
@@ -408,24 +408,22 @@ static void xen_smp_send_reschedule(int 
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const cpumask_t *mask, enum ipi_vector vector)
 {
 	unsigned cpu;
 
-	cpus_and(mask, mask, cpu_online_map);
-
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_and(cpu, mask, &cpu_online_map)
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(cpumask_t mask)
+static void xen_smp_send_call_function_ipi(const cpumask_t *mask)
 {
 	int cpu;
 
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, *mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
@@ -435,7 +433,8 @@ static void xen_smp_send_call_function_i
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	xen_send_IPI_mask(&cpumask_of_cpu(cpu),
+			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)

-- 
