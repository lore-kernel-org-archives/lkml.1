Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZH3NFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZH3NFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZH3NFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:05:47 -0400
Received: from www.tglx.de ([62.245.132.106]:56887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZH3NFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:05:45 -0400
Message-Id: <20090830122528.615886724@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:05:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 2/4] x86: Add pci_init_irq to x86_init
References: <20090830122225.608718729@linutronix.de>
Content-Disposition: inline; filename=x86-move-pci-init-irq-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown wants to reuse pcibios_init_irq but needs to provide its
own implementation of pci_enable_irq. After we distangled the init we
can move the init_irq call to x86_init and remove the pci_enable_irq
!= NULL check in pcibios_init_irq. pci_enable_irq is compile time
initialized to pirq_enable_irq and the special cases which override it
(visws and acpi) set the x86_init function pointer to noop. That
allows MSRT to override pci_enable_irq and otherwise run
pcibios_init_irq unmodified.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pci_x86.h  |    4 +++-
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/visws_quirks.c  |    1 +
 arch/x86/kernel/x86_init.c      |    1 +
 arch/x86/pci/acpi.c             |    1 +
 arch/x86/pci/irq.c              |   12 ++++--------
 arch/x86/pci/legacy.c           |    2 +-
 7 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6-tip/arch/x86/include/asm/pci_x86.h
@@ -110,7 +110,7 @@ extern void __init dmi_check_skip_isa_al
 
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
-extern int __init pcibios_irq_init(void);
+extern void __init pcibios_irq_init(void);
 extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
 
@@ -171,6 +171,8 @@ static inline void mmio_config_writel(vo
 # else
 #  define x86_default_pci_init		pci_legacy_init
 # endif
+# define x86_default_pci_init_irq	pcibios_irq_init
 #else
 # define x86_default_pci_init		NULL
+# define x86_default_pci_init_irq	NULL
 #endif
Index: linux-2.6-tip/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6-tip/arch/x86/include/asm/x86_init.h
@@ -94,9 +94,11 @@ struct x86_init_timers {
 /**
  * struct x86_init_pci - platform specific pci init functions
  * @init:			platform specific pci init
+ * @init_irq:			platform specific pci irq init
  */
 struct x86_init_pci {
 	int (*init)(void);
+	void (*init_irq)(void);
 };
 
 /**
Index: linux-2.6-tip/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6-tip/arch/x86/kernel/visws_quirks.c
@@ -238,6 +238,7 @@ void __init visws_early_detect(void)
 	x86_init.irqs.trap_init = visws_trap_init;
 	x86_init.timers.timer_init = visws_time_init;
 	x86_init.pci.init = pci_visws_init;
+	x86_init.pci.init_irq = x86_init_noop;
 
 	/*
 	 * Install reboot quirks:
Index: linux-2.6-tip/arch/x86/kernel/x86_init.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/x86_init.c
+++ linux-2.6-tip/arch/x86/kernel/x86_init.c
@@ -67,6 +67,7 @@ struct __initdata x86_init_ops x86_init 
 
 	.pci = {
 		.init			= x86_default_pci_init,
+		.init_irq		= x86_default_pci_init_irq,
 	},
 };
 
Index: linux-2.6-tip/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/acpi.c
+++ linux-2.6-tip/arch/x86/pci/acpi.c
@@ -243,6 +243,7 @@ int __init pci_acpi_init(void)
 	acpi_irq_penalty_init();
 	pcibios_enable_irq = acpi_pci_irq_enable;
 	pcibios_disable_irq = acpi_pci_irq_disable;
+	x86_init.pci.init_irq = x86_init_noop;
 
 	if (pci_routeirq) {
 		/*
Index: linux-2.6-tip/arch/x86/pci/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/irq.c
+++ linux-2.6-tip/arch/x86/pci/irq.c
@@ -53,7 +53,7 @@ struct irq_router_handler {
 	int (*probe)(struct irq_router *r, struct pci_dev *router, u16 device);
 };
 
-int (*pcibios_enable_irq)(struct pci_dev *dev) = NULL;
+int (*pcibios_enable_irq)(struct pci_dev *dev) = pirq_enable_irq;
 void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
 
 /*
@@ -1110,12 +1110,12 @@ static struct dmi_system_id __initdata p
 	{ }
 };
 
-int __init pcibios_irq_init(void)
+void __init pcibios_irq_init(void)
 {
 	DBG(KERN_DEBUG "PCI: IRQ init\n");
 
-	if (pcibios_enable_irq || raw_pci_ops == NULL)
-		return 0;
+	if (raw_pci_ops == NULL)
+		return;
 
 	dmi_check_system(pciirq_dmi_table);
 
@@ -1142,8 +1142,6 @@ int __init pcibios_irq_init(void)
 			pirq_table = NULL;
 	}
 
-	pcibios_enable_irq = pirq_enable_irq;
-
 	pcibios_fixup_irqs();
 
 	if (io_apic_assign_pci_irqs && pci_routeirq) {
@@ -1157,8 +1155,6 @@ int __init pcibios_irq_init(void)
 		for_each_pci_dev(dev)
 			pirq_enable_irq(dev);
 	}
-
-	return 0;
 }
 
 static void pirq_penalize_isa_irq(int irq, int active)
Index: linux-2.6-tip/arch/x86/pci/legacy.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/legacy.c
+++ linux-2.6-tip/arch/x86/pci/legacy.c
@@ -60,7 +60,7 @@ int __init pci_subsys_init(void)
 		pci_legacy_init();
 
 	pcibios_fixup_peer_bridges();
-	pcibios_irq_init();
+	x86_init.pci.init_irq();
 	pcibios_init();
 
 	return 0;


