Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0BMBnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:43:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:22628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0BMBkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="540400352"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:16 -0800
Subject: [PATCH 4/9] x86: Add pcibios_fixup_irqs to x86_init
Thread-Topic: [PATCH 4/9] x86: Add pcibios_fixup_irqs to x86_init
Thread-Index: AcqsTX43WpVTkAHzRfWgDEsOuvju7w==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D00@orsmsx508.amr.corp.intel.com>
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

>From 592606bef750654a2b7746bf3b35809d096ae1dd Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 29 Aug 2009 17:51:26 +0200
Subject: [PATCH 4/9] x86: Add pcibios_fixup_irqs to x86_init

Platforms like Moorestown want to override the pcibios_fixup_irqs
default function. Add it to x86_init.pci

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/pci_x86.h  |    3 +++
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/x86_init.c      |    2 ++
 arch/x86/pci/irq.c              |    4 ++--
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 46511c5..6e69edf 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -113,6 +113,7 @@ extern int __init pci_acpi_init(void);
 extern void __init pcibios_irq_init(void);
 extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
+extern void pcibios_fixup_irqs(void);
 
 /* pci-mmconfig.c */
 
@@ -188,7 +189,9 @@ static inline void mmio_config_writel(void __iomem *pos, u32 val)
 #  define x86_default_pci_init		pci_legacy_init
 # endif
 # define x86_default_pci_init_irq	pcibios_irq_init
+# define x86_default_pci_fixup_irqs	pcibios_fixup_irqs
 #else
 # define x86_default_pci_init		NULL
 # define x86_default_pci_init_irq	NULL
+# define x86_default_pci_fixup_irqs	NULL
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 34f61cd..8ef56f2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -102,10 +102,12 @@ struct x86_init_iommu {
   * struct x86_init_pci - platform specific pci init functions
  * @init:			platform specific pci init
  * @init_irq:			platform specific pci irq init
+ * @fixup_irqs:			platform specific pci irq fixup
  */
 struct x86_init_pci {
 	int (*init)(void);
 	void (*init_irq)(void);
+	void (*fixup_irqs)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 203f26f..1817cd7 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -4,6 +4,7 @@
  *  For licencing details see kernel-base/COPYING
  */
 #include <linux/init.h>
+#include <linux/ioport.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -75,6 +76,7 @@ struct x86_init_ops x86_init __initdata = {
 	.pci = {
 		.init			= x86_default_pci_init,
 		.init_irq		= x86_default_pci_init_irq,
+		.fixup_irqs		= x86_default_pci_fixup_irqs,
 	},
 };
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0f40ff2..a60deb6 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1016,7 +1016,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	return 1;
 }
 
-static void __init pcibios_fixup_irqs(void)
+void __init pcibios_fixup_irqs(void)
 {
 	struct pci_dev *dev = NULL;
 	u8 pin;
@@ -1142,7 +1142,7 @@ void __init pcibios_irq_init(void)
 			pirq_table = NULL;
 	}
 
-	pcibios_fixup_irqs();
+	x86_init.pci.fixup_irqs();
 
 	if (io_apic_assign_pci_irqs && pci_routeirq) {
 		struct pci_dev *dev = NULL;
-- 
1.6.5.3

