Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYIFXwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYIFXwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYIFXuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54625 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753036AbYIFXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235037.070162000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:37 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 01/13] smp: modify send_IPI_mask interface to accept cpumask_t pointers
Content-Disposition: inline; filename=send_IPI_mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Change the send_IPI_mask interface for x86_64 to accept a pointer
    to the cpumask_t argument.


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genapic_flat_64.c       |   16 ++++++++--------
 arch/x86/kernel/genx2apic_cluster.c     |    8 ++++----
 arch/x86/kernel/genx2apic_phys.c        |    8 ++++----
 arch/x86/kernel/genx2apic_uv_x.c        |    8 ++++----
 arch/x86/xen/smp.c                      |    9 ++++++---
 include/asm-x86/genapic_64.h            |    2 +-
 include/asm-x86/mach-default/mach_ipi.h |    2 +-
 include/asm-x86/mach-generic/mach_ipi.h |    4 ++++
 8 files changed, 32 insertions(+), 25 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -69,9 +69,9 @@ static void flat_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void flat_send_IPI_mask(const cpumask_t *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long mask = cpus_addr(*cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -92,7 +92,7 @@ static void flat_send_IPI_allbutself(int
 		cpu_clear(smp_processor_id(), allbutme);
 
 		if (!cpus_empty(allbutme))
-			flat_send_IPI_mask(allbutme, vector);
+			flat_send_IPI_mask(&allbutme, vector);
 	} else if (num_online_cpus() > 1) {
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
 	}
@@ -101,7 +101,7 @@ static void flat_send_IPI_allbutself(int
 static void flat_send_IPI_all(int vector)
 {
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(cpu_online_map, vector);
+		flat_send_IPI_mask(&cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -196,9 +196,9 @@ static cpumask_t physflat_vector_allocat
 	return cpumask_of_cpu(cpu);
 }
 
-static void physflat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void physflat_send_IPI_mask(const cpumask_t *cpumask, int vector)
 {
-	send_IPI_mask_sequence(cpumask, vector);
+	send_IPI_mask_sequence(*cpumask, vector);
 }
 
 static void physflat_send_IPI_allbutself(int vector)
@@ -206,12 +206,12 @@ static void physflat_send_IPI_allbutself
 	cpumask_t allbutme = cpu_online_map;
 
 	cpu_clear(smp_processor_id(), allbutme);
-	physflat_send_IPI_mask(allbutme, vector);
+	physflat_send_IPI_mask(&allbutme, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_map, vector);
+	physflat_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_cluster.c
@@ -56,13 +56,13 @@ static void __x2apic_send_IPI_dest(unsig
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
+	for_each_cpu_mask_nr(query_cpu, *mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_logical_apicid, query_cpu),
 				       vector, APIC_DEST_LOGICAL);
 	}
@@ -76,12 +76,12 @@ static void x2apic_send_IPI_allbutself(i
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+		x2apic_send_IPI_mask(&mask, vector);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_phys.c
@@ -54,13 +54,13 @@ static void __x2apic_send_IPI_dest(unsig
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
@@ -74,12 +74,12 @@ static void x2apic_send_IPI_allbutself(i
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+		x2apic_send_IPI_mask(&mask, vector);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -124,12 +124,12 @@ static void uv_send_IPI_one(int cpu, int
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(cpumask_t mask, int vector)
+static void uv_send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	unsigned int cpu;
 
 	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, mask))
+		if (cpu_isset(cpu, *mask))
 			uv_send_IPI_one(cpu, vector);
 }
 
@@ -140,12 +140,12 @@ static void uv_send_IPI_allbutself(int v
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		uv_send_IPI_mask(mask, vector);
+		uv_send_IPI_mask(&mask, vector);
 }
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(cpu_online_map, vector);
+	uv_send_IPI_mask(&cpu_online_map, vector);
 }
 
 static int uv_apic_id_registered(void)
--- linux-2.6.tip.orig/arch/x86/xen/smp.c
+++ linux-2.6.tip/arch/x86/xen/smp.c
@@ -358,10 +358,12 @@ static void xen_smp_send_reschedule(int 
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const cpumask_t *inmask, enum ipi_vector vector)
 {
 	unsigned cpu;
+	cpumask_t mask;
 
+	mask = *inmask;
 	cpus_and(mask, mask, cpu_online_map);
 
 	for_each_cpu_mask_nr(cpu, mask)
@@ -372,7 +374,7 @@ static void xen_smp_send_call_function_i
 {
 	int cpu;
 
-	xen_send_IPI_mask(*mask, XEN_CALL_FUNCTION_VECTOR);
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu_mask_nr(cpu, *mask) {
@@ -385,7 +387,8 @@ static void xen_smp_send_call_function_i
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	xen_send_IPI_mask(&cpumask_of_cpu(cpu),
+			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -22,7 +22,7 @@ struct genapic {
 	cpumask_t (*vector_allocation_domain)(int cpu);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
--- linux-2.6.tip.orig/include/asm-x86/mach-default/mach_ipi.h
+++ linux-2.6.tip/include/asm-x86/mach-default/mach_ipi.h
@@ -11,7 +11,7 @@ extern int no_broadcast;
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define send_IPI_mask (genapic->send_IPI_mask)
+#define send_IPI_mask(mask, vector) (genapic->send_IPI_mask)(&(mask), vector)
 #else
 static inline void send_IPI_mask(cpumask_t mask, int vector)
 {
--- linux-2.6.tip.orig/include/asm-x86/mach-generic/mach_ipi.h
+++ linux-2.6.tip/include/asm-x86/mach-generic/mach_ipi.h
@@ -3,7 +3,11 @@
 
 #include <asm/genapic.h>
 
+#ifdef CONFIG_X86_64
+#define send_IPI_mask(mask, vector) (genapic->send_IPI_mask)(&(mask), vector)
+#else
 #define send_IPI_mask (genapic->send_IPI_mask)
+#endif
 #define send_IPI_allbutself (genapic->send_IPI_allbutself)
 #define send_IPI_all (genapic->send_IPI_all)
 

-- 
