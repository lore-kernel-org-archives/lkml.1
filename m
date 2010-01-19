Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759Ab0ASW2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0ASW2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635Ab0ASW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:28:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:36529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0ASW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:27:59 -0500
Date: Tue, 19 Jan 2010 22:27:36 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
References: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Don't block IRQ0_VECTOR..IRQ15_VECTOR's on all cpu's
Message-ID: <tip-97943390b043bcafca69f9163b86bbf627b75589@git.kernel.org>
Git-Commit-ID: 97943390b043bcafca69f9163b86bbf627b75589
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 22:27:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97943390b043bcafca69f9163b86bbf627b75589
Gitweb:     http://git.kernel.org/tip/97943390b043bcafca69f9163b86bbf627b75589
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 19 Jan 2010 12:20:54 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 19 Jan 2010 13:40:29 -0800

x86, irq: Don't block IRQ0_VECTOR..IRQ15_VECTOR's on all cpu's

Currently IRQ0..IRQ15 are assigned to IRQ0_VECTOR..IRQ15_VECTOR's on
all the cpu's.

If these IRQ's are handled by legacy pic controller, then the kernel
handles them only on cpu 0. So there is no need to block this vector
space on all cpu's.

Similarly if these IRQ's are handled by IO-APIC, then the IRQ affinity
will determine on which cpu's we need allocate the vector resource for
that particular IRQ. This can be done dynamically and here also there
is no need to block 16 vectors for IRQ0..IRQ15 on all cpu's.

Fix this by initially assigning IRQ0..IRQ15 to IRQ0_VECTOR..IRQ15_VECTOR's only
on cpu 0. If the legacy controllers like pic handles these irq's, then
this configuration will be fixed. If more modern controllers like IO-APIC
handle these IRQ's, then we start with this configuration and as IRQ's
migrate, vectors (/and cpu's) associated with these IRQ's change dynamically.

This will freeup the block of 16 vectors on other cpu's which don't handle
IRQ0..IRQ15, which can now be used for other IRQ's that the particular cpu
handle.

[ hpa: this also an architectural cleanup for future legacy-PIC-free
  configurations. ]
[ hpa: fixed typo NR_LEGACY_IRQS -> NR_IRQS_LEGACY ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/irq.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |   33 ++++++++++-----------------------
 arch/x86/kernel/irqinit.c      |   35 +++++++++++++++++------------------
 arch/x86/kernel/vmiclock_32.c  |    2 ++
 4 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..2622927 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -48,5 +48,6 @@ extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
+extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 409f494..1a30587 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -94,8 +94,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* Number of legacy interrupts */
-static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
@@ -140,27 +138,10 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[] = {
+static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
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
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d593222..fce55d5 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
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
@@ -116,6 +99,9 @@ int vector_used_by_percpu_irq(unsigned int vector)
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
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 1268d99..2f1ca56 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -235,6 +235,8 @@ void __init vmi_time_init(void)
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
+	for_each_possible_cpu(cpu)
+		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
