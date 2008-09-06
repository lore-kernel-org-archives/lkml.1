Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYIFXzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYIFXzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYIFXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59428 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753170AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235038.561025000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:48 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 12/13] genapic: reduce stack pressuge in io_apic.c step 4 vector allocation
Content-Disposition: inline; filename=stack-hogs-io_apic_c-step-4-vector_allocation_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Step 4 "vector allocation" of cleaning up io_apic.c modifies the
    vector_allocation_domain genapic interface to pass a pointer to
    the returned mask removing yet another "cpumask_t variable on the stack".

	domain = vector_allocation_domain(cpu);

    becomes:

	vector_allocation_domain(cpu, &domain);

  * All the appropriate genapic "vector_allocation_domain" functions
    are modified to use this new interface.


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genapic_flat_64.c        |    9 ++++-----
 arch/x86/kernel/genx2apic_cluster.c      |    6 ++----
 arch/x86/kernel/genx2apic_phys.c         |    6 ++----
 arch/x86/kernel/genx2apic_uv_x.c         |    6 ++----
 arch/x86/kernel/io_apic.c                |    2 +-
 arch/x86/mach-generic/bigsmp.c           |    4 ++--
 arch/x86/mach-generic/es7000.c           |    5 ++---
 arch/x86/mach-generic/numaq.c            |    5 ++---
 arch/x86/mach-generic/summit.c           |    5 ++---
 include/asm-x86/genapic_32.h             |    4 ++--
 include/asm-x86/genapic_64.h             |    2 +-
 include/asm-x86/mach-default/mach_apic.h |    5 ++---
 12 files changed, 24 insertions(+), 35 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -36,7 +36,7 @@ static void flat_target_cpus(cpumask_t *
 	*retmask = cpu_online_map;
 }
 
-static cpumask_t flat_vector_allocation_domain(int cpu)
+static void flat_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -46,8 +46,7 @@ static cpumask_t flat_vector_allocation_
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 /*
@@ -199,9 +198,9 @@ static void physflat_target_cpus(cpumask
 	*retmask = cpu_online_map;
 }
 
-static cpumask_t physflat_vector_allocation_domain(int cpu)
+static void physflat_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	return cpumask_of_cpu(cpu);
+	*retmask = cpumask_of_cpu(cpu);
 }
 
 static void physflat_send_IPI_mask(const cpumask_t *cpumask, int vector)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_cluster.c
@@ -31,11 +31,9 @@ static void x2apic_target_cpus(cpumask_t
 /*
  * for now each logical cpu is in its own vector allocation domain.
  */
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	*retmask = cpumask_of_cpu(cpu);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_phys.c
@@ -34,11 +34,9 @@ static void x2apic_target_cpus(cpumask_t
 	*retmask = cpumask_of_cpu(0);
 }
 
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	*retmask = cpumask_of_cpu(cpu);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -82,11 +82,9 @@ static uv_target_cpus(cpumask_t *retmask
 	*retmask = cpumask_of_cpu(0);
 }
 
-static cpumask_t uv_vector_allocation_domain(int cpu)
+static void uv_vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	*retmask = cpumask_of_cpu(cpu);
 }
 
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
--- linux-2.6.tip.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic.c
@@ -1292,7 +1292,7 @@ static int __assign_irq_vector(int irq, 
 		int new_cpu;
 		int vector, offset;
 
-		*tmpmask = vector_allocation_domain(cpu);
+		vector_allocation_domain(cpu, tmpmask);
 
 		vector = current_vector;
 		offset = current_offset;
--- linux-2.6.tip.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6.tip/arch/x86/mach-generic/bigsmp.c
@@ -41,9 +41,9 @@ static const struct dmi_system_id bigsmp
 	 { }
 };
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-        return cpumask_of_cpu(cpu);
+	*retmask = cpumask_of_cpu(cpu);
 }
 
 static int probe_bigsmp(void)
--- linux-2.6.tip.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6.tip/arch/x86/mach-generic/es7000.c
@@ -65,7 +65,7 @@ static int __init acpi_madt_oem_check(ch
 }
 #endif
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -75,8 +75,7 @@ static cpumask_t vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
--- linux-2.6.tip.orig/arch/x86/mach-generic/numaq.c
+++ linux-2.6.tip/arch/x86/mach-generic/numaq.c
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
--- linux-2.6.tip.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6.tip/arch/x86/mach-generic/summit.c
@@ -23,7 +23,7 @@ static int probe_summit(void)
 	return 0;
 }
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -33,8 +33,7 @@ static cpumask_t vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic apic_summit = APIC_INIT("summit", probe_summit);
--- linux-2.6.tip.orig/include/asm-x86/genapic_32.h
+++ linux-2.6.tip/include/asm-x86/genapic_32.h
@@ -58,7 +58,7 @@ struct genapic {
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
@@ -106,7 +106,7 @@ struct genapic {
 	APICFUNC(get_apic_id)				\
 	.apic_id_mask = APIC_ID_MASK,			\
 	APICFUNC(cpu_mask_to_apicid)			\
-	APICFUNC(vector_allocation_domain)			\
+	APICFUNC(vector_allocation_domain)		\
 	APICFUNC(acpi_madt_oem_check)			\
 	IPIFUNC(send_IPI_mask)				\
 	IPIFUNC(send_IPI_allbutself)			\
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -21,7 +21,7 @@ struct genapic {
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
 	void (*target_cpus)(cpumask_t *retmask);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 	void (*init_apic_ldr)(void);
 	/* ipi */
 	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
--- linux-2.6.tip.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6.tip/include/asm-x86/mach-default/mach_apic.h
@@ -92,7 +92,7 @@ static inline int apicid_to_node(int log
 #endif
 }
 
-static inline cpumask_t vector_allocation_domain(int cpu)
+static inline void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
         /* Careful. Some cpus do not strictly honor the set of cpus
          * specified in the interrupt destination when using lowest
@@ -102,8 +102,7 @@ static inline cpumask_t vector_allocatio
          * deliver interrupts to the wrong hyperthread when only one
          * hyperthread was specified in the interrupt desitination.
          */
-        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-        return domain;
+        *retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 #endif
 

-- 
