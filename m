Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXBWLeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXBWLeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXBWLeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:34:23 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45732 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXBWLeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:34:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 09/14] x86_64 irq: Begin consolidating per_irq data in structures.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
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
Date: Fri, 23 Feb 2007 04:32:47 -0700
In-Reply-To: <m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:26:53 -0700")
Message-ID: <m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently the io_apic.c has several parallel arrays for different
kinds of data that can be know about an irq.  The parallel arrays
make the code harder to maintain and make it difficult to remove
the static limits on the number of the number of irqs.

This patch pushes irq_data and irq_vector into a irq_cfg array and
updates the code to use it. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |  111 +++++++++++++++++++-----------------------
 1 files changed, 50 insertions(+), 61 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 65d7218..dd6580c 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -47,6 +47,31 @@
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 
+struct irq_cfg {
+	cpumask_t domain;
+	u8 vector;
+};
+
+/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
+struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
+	[0] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 0 },
+	[1] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 1 },
+	[2] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 2 },
+	[3] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 3 },
+	[4] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 4 },
+	[5] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 5 },
+	[6] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 6 },
+	[7] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 7 },
+	[8] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 8 },
+	[9] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 9 },
+	[10] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 10 },
+	[11] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 11 },
+	[12] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 12 },
+	[13] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 13 },
+	[14] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 14 },
+	[15] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 15 },
+};
+
 static int assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result);
 
 #define __apicdebuginit  __init
@@ -613,46 +638,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
-
-/* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQS] __read_mostly = {
-	[0] = FIRST_EXTERNAL_VECTOR + 0,
-	[1] = FIRST_EXTERNAL_VECTOR + 1,
-	[2] = FIRST_EXTERNAL_VECTOR + 2,
-	[3] = FIRST_EXTERNAL_VECTOR + 3,
-	[4] = FIRST_EXTERNAL_VECTOR + 4,
-	[5] = FIRST_EXTERNAL_VECTOR + 5,
-	[6] = FIRST_EXTERNAL_VECTOR + 6,
-	[7] = FIRST_EXTERNAL_VECTOR + 7,
-	[8] = FIRST_EXTERNAL_VECTOR + 8,
-	[9] = FIRST_EXTERNAL_VECTOR + 9,
-	[10] = FIRST_EXTERNAL_VECTOR + 10,
-	[11] = FIRST_EXTERNAL_VECTOR + 11,
-	[12] = FIRST_EXTERNAL_VECTOR + 12,
-	[13] = FIRST_EXTERNAL_VECTOR + 13,
-	[14] = FIRST_EXTERNAL_VECTOR + 14,
-	[15] = FIRST_EXTERNAL_VECTOR + 15,
-};
-
-static cpumask_t irq_domain[NR_IRQS] __read_mostly = {
-	[0] = CPU_MASK_ALL,
-	[1] = CPU_MASK_ALL,
-	[2] = CPU_MASK_ALL,
-	[3] = CPU_MASK_ALL,
-	[4] = CPU_MASK_ALL,
-	[5] = CPU_MASK_ALL,
-	[6] = CPU_MASK_ALL,
-	[7] = CPU_MASK_ALL,
-	[8] = CPU_MASK_ALL,
-	[9] = CPU_MASK_ALL,
-	[10] = CPU_MASK_ALL,
-	[11] = CPU_MASK_ALL,
-	[12] = CPU_MASK_ALL,
-	[13] = CPU_MASK_ALL,
-	[14] = CPU_MASK_ALL,
-	[15] = CPU_MASK_ALL,
-};
-
 static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 {
 	/*
@@ -670,19 +655,21 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 	cpumask_t old_mask = CPU_MASK_NONE;
 	int old_vector = -1;
 	int cpu;
+	struct irq_cfg *cfg;
 
 	BUG_ON((unsigned)irq >= NR_IRQS);
+	cfg = &irq_cfg[irq];
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
 
-	if (irq_vector[irq] > 0)
-		old_vector = irq_vector[irq];
+	if (cfg->vector > 0)
+		old_vector = cfg->vector;
 	if (old_vector > 0) {
-		cpus_and(*result, irq_domain[irq], mask);
+		cpus_and(*result, cfg->domain, mask);
 		if (!cpus_empty(*result))
 			return old_vector;
-		cpus_and(old_mask, irq_domain[irq], cpu_online_map);
+		cpus_and(old_mask, cfg->domain, cpu_online_map);
 	}
 
 	for_each_cpu_mask(cpu, mask) {
@@ -716,8 +703,8 @@ next:
 			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
-		irq_vector[irq] = vector;
-		irq_domain[irq] = domain;
+		cfg->vector = vector;
+		cfg->domain = domain;
 		cpus_and(*result, domain, mask);
 		return vector;
 	}
@@ -737,18 +724,21 @@ static int assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 
 static void __clear_irq_vector(int irq)
 {
+	struct irq_cfg *cfg;
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON(!irq_vector[irq]);
+	BUG_ON((unsigned)irq >= NR_IRQS);
+	cfg = &irq_cfg[irq];
+	BUG_ON(!cfg->vector);
 
-	vector = irq_vector[irq];
-	cpus_and(mask, irq_domain[irq], cpu_online_map);
+	vector = cfg->vector;
+	cpus_and(mask, cfg->domain, cpu_online_map);
 	for_each_cpu_mask(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
-	irq_vector[irq] = 0;
-	irq_domain[irq] = CPU_MASK_NONE;
+	cfg->vector = 0;
+	cfg->domain = CPU_MASK_NONE;
 }
 
 void __setup_vector_irq(int cpu)
@@ -759,9 +749,9 @@ void __setup_vector_irq(int cpu)
 
 	/* Mark the inuse vectors */
 	for (irq = 0; irq < NR_IRQS; ++irq) {
-		if (!cpu_isset(cpu, irq_domain[irq]))
+		if (!cpu_isset(cpu, irq_cfg[irq].domain))
 			continue;
-		vector = irq_vector[irq];
+		vector = irq_cfg[irq].vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
@@ -769,7 +759,7 @@ void __setup_vector_irq(int cpu)
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
-		if (!cpu_isset(cpu, irq_domain[irq]))
+		if (!cpu_isset(cpu, irq_cfg[irq].domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -1346,16 +1336,15 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 
 static int ioapic_retrigger_irq(unsigned int irq)
 {
+	struct irq_cfg *cfg = &irq_cfg[irq];
 	cpumask_t mask;
-	unsigned vector;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	vector = irq_vector[irq];
 	cpus_clear(mask);
-	cpu_set(first_cpu(irq_domain[irq]), mask);
+	cpu_set(first_cpu(cfg->domain), mask);
 
-	send_IPI_mask(mask, vector);
+	send_IPI_mask(mask, cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -1430,7 +1419,7 @@ static inline void init_IO_APIC_traps(void)
 	 */
 	for (irq = 0; irq < NR_IRQS ; irq++) {
 		int tmp = irq;
-		if (IO_APIC_IRQ(tmp) && !irq_vector[tmp]) {
+		if (IO_APIC_IRQ(tmp) && !irq_cfg[tmp].vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
@@ -1816,7 +1805,7 @@ int create_irq(void)
 	for (new = (NR_IRQS - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		if (irq_vector[new] != 0)
+		if (irq_cfg[new].vector != 0)
 			continue;
 		vector = __assign_irq_vector(new, TARGET_CPUS, &mask);
 		if (likely(vector > 0))
@@ -2108,7 +2097,7 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			if(!irq_vector[irq])
+			if (!irq_cfg[irq].vector)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
-- 
1.5.0.g53756

