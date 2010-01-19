Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118Ab0ASUWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0ASUWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559Ab0ASUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:22:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:39432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0ASUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:22:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,305,1262592000"; 
   d="scan'208";a="532637172"
Subject: [patch] x86, irq: don't block IRQ0_VECTOR..IRQ15_VECTOR's on all
 cpu's
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H.PeterA" <nvin@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 19 Jan 2010 12:20:53 -0800
Message-Id: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IRQ0..IRQ15 are assigned to IRQ0_VECTOR..IRQ15_VECTOR's on
all the cpu's.

If these IRQ's are handled by legacy pic controller, then the kernel
handles them only on cpu 0. So there is no need to block this vector
space on all cpu's.

Similarly if these IRQ's are handled by IO-APIC, then the irq affinity
will determine on which cpu's we need allocate the vector resource for that
particular IRQ. This can be done dynamically and here also there is no need
to block 16 vectors for IRQ0..IRQ15 on all cpu's.

Fix this by initially assigning IRQ0..IRQ15 to IRQ0_VECTOR..IRQ15_VECTOR's only
on cpu 0. If the legacy controllers like pic handles these irq's, then
this configuration will be fixed. If more modern controllers like IO-APIC
handle these IRQ's, then we start with this configuration and as IRQ's
migrate, vectors (/and cpu's) associated with these IRQ's change dynamically.

This will freeup the block of 16 vectors on other cpu's which don't handle
IRQ0..IRQ15, which can now be used for other IRQ's that the particular cpu
handle.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/irq.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |   33 ++++++++++-----------------------
 arch/x86/kernel/irqinit.c      |   35 +++++++++++++++++------------------
 arch/x86/kernel/vmiclock_32.c  |    2 ++
 4 files changed, 30 insertions(+), 41 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -94,8 +94,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCE
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* Number of legacy interrupts */
-static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
@@ -140,27 +138,10 @@ static struct irq_pin_list *get_one_free
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[] = {
+static struct irq_cfg irq_cfgx[NR_LEGACY_IRQS];
 #else
-static struct irq_cfg irq_cfgx[NR_IRQS] = {
+static struct irq_cfg irq_cfgx[NR_IRQS];
 #endif
-	[0]  = { .vector = IRQ0_VECTOR,  },
-	[1]  = { .vector = IRQ1_VECTOR,  },
-	[2]  = { .vector = IRQ2_VECTOR,  },
-	[3]  = { .vector = IRQ3_VECTOR,  },
-	[4]  = { .vector = IRQ4_VECTOR,  },
-	[5]  = { .vector = IRQ5_VECTOR,  },
-	[6]  = { .vector = IRQ6_VECTOR,  },
-	[7]  = { .vector = IRQ7_VECTOR,  },
-	[8]  = { .vector = IRQ8_VECTOR,  },
-	[9]  = { .vector = IRQ9_VECTOR,  },
-	[10] = { .vector = IRQ10_VECTOR, },
-	[11] = { .vector = IRQ11_VECTOR, },
-	[12] = { .vector = IRQ12_VECTOR, },
-	[13] = { .vector = IRQ13_VECTOR, },
-	[14] = { .vector = IRQ14_VECTOR, },
-	[15] = { .vector = IRQ15_VECTOR, },
-};
 
 void __init io_apic_disable_legacy(void)
 {
@@ -185,8 +166,14 @@ int __init arch_early_irq_init(void)
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
-		if (i < nr_legacy_irqs)
-			cpumask_setall(cfg[i].domain);
+		/*
+		 * For legacy IRQ's, start with assigning irq0 to irq15 to
+		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
+		 */
+		if (i < nr_legacy_irqs) {
+			cfg[i].vector = IRQ0_VECTOR + i;
+			cpumask_set_cpu(0, cfg[i].domain);
+		}
 	}
 
 	return 0;
Index: tip/arch/x86/kernel/irqinit.c
===================================================================
--- tip.orig/arch/x86/kernel/irqinit.c
+++ tip/arch/x86/kernel/irqinit.c
@@ -84,24 +84,7 @@ static struct irqaction irq2 = {
 };
 
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
+	[0 ... NR_VECTORS - 1] = -1,
 };
 
 int vector_used_by_percpu_irq(unsigned int vector)
@@ -116,6 +99,9 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
+/* Number of legacy interrupts */
+int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
+
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -142,6 +128,19 @@ void __init init_ISA_irqs(void)
 
 void __init init_IRQ(void)
 {
+	int i;
+
+	/*
+	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
+	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
+	 * then this configuration will likely be static after the boot. If
+	 * these IRQ's are handled by more mordern controllers like IO-APIC,
+	 * then this vector space can be freed and re-used dynamically as the
+	 * irq's migrate etc.
+	 */
+	for (i = 0; i < nr_legacy_irqs; i++)
+		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
+
 	x86_init.irqs.intr_init();
 }
 
Index: tip/arch/x86/kernel/vmiclock_32.c
===================================================================
--- tip.orig/arch/x86/kernel/vmiclock_32.c
+++ tip/arch/x86/kernel/vmiclock_32.c
@@ -235,6 +235,8 @@ void __init vmi_time_init(void)
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
+	for_each_possible_cpu(cpu)
+		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
Index: tip/arch/x86/include/asm/irq.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq.h
+++ tip/arch/x86/include/asm/irq.h
@@ -48,5 +48,6 @@ extern DECLARE_BITMAP(used_vectors, NR_V
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
+extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */


