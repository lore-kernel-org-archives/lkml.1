Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbZD3IUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbZD3IUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZD3ITo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759229AbZD3ITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:19:42 -0400
Message-ID: <49F95EAE.2050903@kernel.org>
Date: Thu, 30 Apr 2009 01:17:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: using move_irq_desc -v3
References: <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org> <20090429120056.GE11586@elte.hu> <49F87FF3.1090600@kernel.org> <20090429204135.GF21421@elte.hu> <20090429212317.GA30147@elte.hu> <49F8E1DE.9010301@kernel.org> <20090430072930.GE16737@elte.hu>
In-Reply-To: <20090430072930.GE16737@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



move_irq_desc will try to move irq_desc to node wanted if allocated one is not correct.
(happen on device on different nodes that are using MSI, drivers are loaded and unloaded
randomly)

v2: fix no smp compiling
v3: add NUMA_IRQ_DESC to make MACRO simple

[ Impact: make irq_desc go with device on node ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig               |    4 ++++
 arch/x86/kernel/apic/io_apic.c |    6 +-----
 include/linux/irq.h            |   11 +++++++++--
 kernel/irq/Makefile            |    2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3155,11 +3155,7 @@ unsigned int create_irq_nr(unsigned int
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
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -206,9 +206,16 @@ extern void arch_free_chip_data(struct i
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-#else /* CONFIG_SPARSE_IRQ */
+#endif
+
+#ifdef CONFIG_NUMA_IRQ_DESC
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
-#endif /* CONFIG_SPARSE_IRQ */
+#else
+static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
+{
+	return desc;
+}
+#endif
 
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
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
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -280,6 +280,10 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say N.
 
+config NUMA_IRQ_DESC
+	def_bool y
+	depends on SPARSE_IRQ && NUMA
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
