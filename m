Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZD1Vml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZD1Vml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbZD1Vm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:42:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759060AbZD1VmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:42:23 -0400
Message-ID: <49F777F8.7070102@kernel.org>
Date: Tue, 28 Apr 2009 14:41:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: use move_irq_desc only when CONFIG_NUMA_IRQ_DESC
 is set
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu>
In-Reply-To: <20090428143254.GA24351@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


add config NUMA_IRQ_DESC, and create_irq_nr(), it will call move_irq_desc.

move_irq_desc will try to move irq_desc to node wanted if allocated one is not correct.
(happen on device on different nodes that are using MSI, driver are loaded and unloaded
randomly)

[ Impact: make irq_desc go with device on node ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig               |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c |   18 +++++++++++-------
 include/linux/irq.h            |   11 +++++++++--
 kernel/irq/Makefile            |    2 +-
 4 files changed, 30 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -280,6 +280,15 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say N.
 
+config NUMA_IRQ_DESC
+       bool "put irq desc on numa node memory"
+       depends on SPARSE_IRQ && NUMA
+       default n
+       ---help---
+         This enables irq_desc to cpu/node that that device is connected.
+
+         If you don't know what to do here, say N.
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -246,7 +246,7 @@ int arch_init_chip_data(struct irq_desc
 	return 0;
 }
 
-/* for move_irq_desc */
+#ifdef CONFIG_NUMA_IRQ_DESC
 static void
 init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
 {
@@ -347,7 +347,7 @@ void arch_free_chip_data(struct irq_desc
 		old_desc->chip_data = NULL;
 	}
 }
-/* end for move_irq_desc */
+#endif
 
 #else
 static struct irq_cfg *irq_cfg(unsigned int irq)
@@ -3143,6 +3143,10 @@ unsigned int create_irq_nr(unsigned int
 	if (irq_want < nr_irqs_gsi)
 		irq_want = nr_irqs_gsi;
 
+#ifndef CONFIG_NUMA_IRQ_DESC
+	node = cpu_to_node(boot_cpu_id);
+#endif
+
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
 		desc_new = irq_to_desc_alloc_node(new, node);
@@ -3155,11 +3159,7 @@ unsigned int create_irq_nr(unsigned int
 		if (cfg_new->vector != 0)
 			continue;
 
-#ifdef CONFIG_NUMA_IRQ_DESC
-		/* different node ?*/
-		if (desc_new->node != node)
-			desc = move_irq_desc(desc, node);
-#endif
+		desc_new = move_irq_desc(desc_new, node);
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
@@ -3938,10 +3938,14 @@ int io_apic_set_pci_routing(struct devic
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_NUMA_IRQ_DESC
 	if (dev)
 		node = dev_to_node(dev);
 	else
 		node = cpu_to_node(boot_cpu_id);
+#else
+	node = cpu_to_node(boot_cpu_id);
+#endif
 
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -206,10 +206,17 @@ extern void arch_free_chip_data(struct i
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-#else /* CONFIG_SPARSE_IRQ */
-extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
 #endif /* CONFIG_SPARSE_IRQ */
 
+#ifdef CONFIG_NUMA_IRQ_DESC
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
+#else
+static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
+{
+	return desc;
+}
+#endif
+
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 /*
Index: linux-2.6/kernel/irq/Makefile
===================================================================
--- linux-2.6.orig/kernel/irq/Makefile
+++ linux-2.6/kernel/irq/Makefile
@@ -3,5 +3,5 @@ obj-y := handle.o manage.o spurious.o re
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_SPARSE_IRQ) += numa_migrate.o
+obj-$(CONFIG_NUMA_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
