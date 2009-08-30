Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZH3NFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZH3NFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZH3NFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:05:53 -0400
Received: from www.tglx.de ([62.245.132.106]:56894 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbZH3NFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:05:52 -0400
Message-Id: <20090830122528.673443272@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:05:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 3/4] x86: Add pcibios_fixup_irqs to x86_init
References: <20090830122225.608718729@linutronix.de>
Content-Disposition: inline;
	filename=x86-add-pcibios_fixup_irqs-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms like Moorestown want to override the pcibios_fixup_irqs
default function. Add it to x86_init.pci

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pci_x86.h  |    3 +++
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/x86_init.c      |    1 +
 arch/x86/pci/irq.c              |    4 ++--
 4 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6-tip/arch/x86/include/asm/pci_x86.h
@@ -113,6 +113,7 @@ extern int __init pci_acpi_init(void);
 extern void __init pcibios_irq_init(void);
 extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
+extern void pcibios_fixup_irqs(void);
 
 /* pci-mmconfig.c */
 
@@ -172,7 +173,9 @@ static inline void mmio_config_writel(vo
 #  define x86_default_pci_init		pci_legacy_init
 # endif
 # define x86_default_pci_init_irq	pcibios_irq_init
+# define x86_default_pci_fixup_irqs	pcibios_fixup_irqs
 #else
 # define x86_default_pci_init		NULL
 # define x86_default_pci_init_irq	NULL
+# define x86_default_pci_fixup_irqs	NULL
 #endif
Index: linux-2.6-tip/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6-tip/arch/x86/include/asm/x86_init.h
@@ -95,10 +95,12 @@ struct x86_init_timers {
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
Index: linux-2.6-tip/arch/x86/kernel/x86_init.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/x86_init.c
+++ linux-2.6-tip/arch/x86/kernel/x86_init.c
@@ -68,6 +68,7 @@ struct __initdata x86_init_ops x86_init 
 	.pci = {
 		.init			= x86_default_pci_init,
 		.init_irq		= x86_default_pci_init_irq,
+		.fixup_irqs		= x86_default_pci_fixup_irqs,
 	},
 };
 
Index: linux-2.6-tip/arch/x86/pci/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/irq.c
+++ linux-2.6-tip/arch/x86/pci/irq.c
@@ -1016,7 +1016,7 @@ static int pcibios_lookup_irq(struct pci
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


