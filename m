Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0BMBoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:44:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:22628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab0BMBkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="772528556"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:13 -0800
Subject: PATCH 3/9] x86: Add pci_init_irq to x86_init
Thread-Topic: PATCH 3/9] x86: Add pci_init_irq to x86_init
Thread-Index: AcqsTXxmHyjv8A4QR0SchkmqdKnZ1Q==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80CFF@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cfab24ca34cb4e9de284cea8a5688f4293b4ae76 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 29 Aug 2009 17:47:33 +0200
Subject: [PATCH 3/9] x86: Add pci_init_irq to x86_init

Moorestown wants to reuse pcibios_init_irq but needs to provide its
own implementation of pci_enable_irq. After we distangled the init we
can move the init_irq call to x86_init and remove the pci_enable_irq
!= NULL check in pcibios_init_irq. pci_enable_irq is compile time
initialized to pirq_enable_irq and the special cases which override it
(visws and acpi) set the x86_init function pointer to noop. That
allows MSRT to override pci_enable_irq and otherwise run
pcibios_init_irq unmodified.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/pci_x86.h  |    4 +++-
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/visws_quirks.c  |    1 +
 arch/x86/kernel/x86_init.c      |    1 +
 arch/x86/pci/acpi.c             |    1 +
 arch/x86/pci/irq.c              |   12 ++++--------
 arch/x86/pci/legacy.c           |    2 +-
 7 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 440124f..46511c5 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -110,7 +110,7 @@ extern void __init dmi_check_skip_isa_align(void);
 
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
-extern int __init pcibios_irq_init(void);
+extern void __init pcibios_irq_init(void);
 extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
 
@@ -187,6 +187,8 @@ static inline void mmio_config_writel(void __iomem *pos, u32 val)
 # else
 #  define x86_default_pci_init		pci_legacy_init
 # endif
+# define x86_default_pci_init_irq	pcibios_irq_init
 #else
 # define x86_default_pci_init		NULL
+# define x86_default_pci_init_irq	NULL
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index f145d84..34f61cd 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -101,9 +101,11 @@ struct x86_init_iommu {
  /*
   * struct x86_init_pci - platform specific pci init functions
  * @init:			platform specific pci init
+ * @init_irq:			platform specific pci irq init
  */
 struct x86_init_pci {
 	int (*init)(void);
+	void (*init_irq)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 843e9d3..b48ef6c 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -238,6 +238,7 @@ void __init visws_early_detect(void)
 	x86_init.irqs.trap_init = visws_trap_init;
 	x86_init.timers.timer_init = visws_time_init;
 	x86_init.pci.init = pci_visws_init;
+	x86_init.pci.init_irq = x86_init_noop;
 
 	/*
 	 * Install reboot quirks:
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 81faa6d..203f26f 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -74,6 +74,7 @@ struct x86_init_ops x86_init __initdata = {
 
 	.pci = {
 		.init			= x86_default_pci_init,
+		.init_irq		= x86_default_pci_init_irq,
 	},
 };
 
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 73b3fe9..b53f048 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -289,6 +289,7 @@ int __init pci_acpi_init(void)
 	acpi_irq_penalty_init();
 	pcibios_enable_irq = acpi_pci_irq_enable;
 	pcibios_disable_irq = acpi_pci_irq_disable;
+	x86_init.pci.init_irq = x86_init_noop;
 
 	if (pci_routeirq) {
 		/*
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0696d50..0f40ff2 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -53,7 +53,7 @@ struct irq_router_handler {
 	int (*probe)(struct irq_router *r, struct pci_dev *router, u16 device);
 };
 
-int (*pcibios_enable_irq)(struct pci_dev *dev) = NULL;
+int (*pcibios_enable_irq)(struct pci_dev *dev) = pirq_enable_irq;
 void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
 
 /*
@@ -1110,12 +1110,12 @@ static struct dmi_system_id __initdata pciirq_dmi_table[] = {
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
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 0daf264..0db5eaf 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -60,7 +60,7 @@ int __init pci_subsys_init(void)
 		pci_legacy_init();
 
 	pcibios_fixup_peer_bridges();
-	pcibios_irq_init();
+	x86_init.pci.init_irq();
 	pcibios_init();
 
 	return 0;
-- 
1.6.5.3

