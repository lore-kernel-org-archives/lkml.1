Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZH1Vxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZH1Vxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZH1Vxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:53:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:12203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZH1Vxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="488365545"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:53:21 -0700
Subject: [RFC PATCH 7/7] x86: add more platform_setup functions
Thread-Topic: [RFC PATCH 7/7] x86: add more platform_setup functions
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFeVRHg
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA87A@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
 <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
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

>From fbfe65d64e4dbb31940d31a59e080bfa15d121bb Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 8 Jul 2009 16:51:42 -0700
Subject: [PATCH] x86: RFC add more platform_setup functions

check_timer can be abstracted so that we don't have to do the complicated
checks for platform timer for all platforms. pci irq enable/disable can also
benefit from the platform setup layer, but this part is not complete in this
patch, should be able to include visws. e.g.

pcibios_enable_irq = &pci_visws_enable_irq;
pcibios_disable_irq = &pci_visws_disable_irq;

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/apic.h      |    2 ++
 arch/x86/include/asm/pci_x86.h   |    2 ++
 arch/x86/include/asm/platform.h  |   11 +++++++++++
 arch/x86/kernel/apic/io_apic.c   |    6 +++---
 arch/x86/kernel/platform_setup.c |    4 ++++
 arch/x86/pci/irq.c               |   11 +++++++----
 6 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4f2d26d..6698f3b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -85,6 +85,8 @@ extern u32 safe_xapic_wait_icr_idle(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 extern void pre_init_apic_IRQ(void);
+extern void default_check_timer(void);
+extern int timer_irq_works(void);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
 {
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b399988..118a62d 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -116,6 +116,8 @@ extern int __init pci_visws_init(void);
 extern int __init pci_numaq_init(void);
 extern int __init pcibios_init(void);
 
+extern int pirq_enable_irq(struct pci_dev *dev);
+
 /* pci-mmconfig.c */
 
 extern int __init pci_mmcfg_arch_init(void);
diff --git a/arch/x86/include/asm/platform.h b/arch/x86/include/asm/platform.h
index 1cea28c..d698f68 100644
--- a/arch/x86/include/asm/platform.h
+++ b/arch/x86/include/asm/platform.h
@@ -6,6 +6,7 @@
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
+struct pci_dev;
 
 /**
  * struct platform_setup_quirks - platform specific quirks
@@ -62,6 +63,11 @@ struct platform_setup_irqs {
 	void (*pre_vector_init)(void);
 	void (*intr_init)(void);
 	void (*trap_init)(void);
+
+#ifdef CONFIG_PCI
+	int (*pci_enable_irq)(struct pci_dev *dev);
+	void (*pci_disable_irq)(struct pci_dev *dev);
+#endif
 };
 
 /**
@@ -97,6 +103,7 @@ struct platform_setup_timers {
 	void (*tsc_pre_init)(void);
 	void (*timer_init)(void);
 	unsigned long (*calibrate_tsc)(void);
+	void (*check_timers)(void);
 };
 
 /**
@@ -127,4 +134,8 @@ extern struct platform_setup_cpuhotplug platform_cpuhotplug_setup;
 extern void platform_setup_noop(void);
 extern void platform_setup_uint_noop(unsigned int unused);
 
+#ifdef CONFIG_PCI
+extern int pirq_enable_irq(struct pci_dev *dev);
+#endif
+
 #endif
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 25a5b72..4418daa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2155,7 +2155,7 @@ __setup("no_timer_check", notimercheck);
  *	- if this function detects that timer IRQs are defunct, then we fall
  *	  back to ISA timer IRQs
  */
-static int __init timer_irq_works(void)
+int __init timer_irq_works(void)
 {
 	unsigned long t1 = jiffies;
 	unsigned long flags;
@@ -2868,7 +2868,7 @@ int timer_through_8259 __initdata;
  *
  * FIXME: really need to revamp this for all platforms.
  */
-static inline void __init check_timer(void)
+inline void __init default_check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
@@ -3084,7 +3084,7 @@ void __init setup_IO_APIC(void)
 	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
-	check_timer();
+	platform_setup.timers.check_timers();
 }
 
 /*
diff --git a/arch/x86/kernel/platform_setup.c b/arch/x86/kernel/platform_setup.c
index 9752eff..b60fb5b 100644
--- a/arch/x86/kernel/platform_setup.c
+++ b/arch/x86/kernel/platform_setup.c
@@ -44,6 +44,9 @@ struct __initdata platform_setup_ops platform_setup = {
 		.pre_vector_init = init_ISA_irqs,
 		.intr_init = native_init_IRQ,
 		.trap_init = platform_setup_noop,
+#ifdef CONFIG_PCI
+		.pci_enable_irq = pirq_enable_irq,
+#endif
 	},
 
 	.oem = {
@@ -61,6 +64,7 @@ struct __initdata platform_setup_ops platform_setup = {
 		.tsc_pre_init = platform_setup_noop,
 		.timer_init = hpet_time_init,
 		.calibrate_tsc = native_calibrate_tsc,
+		.check_timers = default_check_timer,
 	},
 
 	.quirks = {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0696d50..c31bd03 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 #include <linux/smp.h>
 #include <asm/io_apic.h>
+#include <asm/platform_feature.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
 #include <asm/pci_x86.h>
@@ -26,8 +27,6 @@ static int acer_tm360_irqrouting;
 
 static struct irq_routing_table *pirq_table;
 
-static int pirq_enable_irq(struct pci_dev *dev);
-
 /*
  * Never use: 0, 1, 2 (timer, keyboard, and cascade)
  * Avoid using: 13, 14 and 15 (FP error and IDE).
@@ -1022,6 +1021,10 @@ static void __init pcibios_fixup_irqs(void)
 	u8 pin;
 
 	DBG(KERN_DEBUG "PCI: IRQ fixup\n");
+	if (!platform_has(X86_PLATFORM_FEATURE_BIOS)) {
+		DBG(KERN_DEBUG "PCI: No BIOS, skip IRQ fixup\n");
+		return;
+	}
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		/*
 		 * If the BIOS has set an out of range IRQ number, just
@@ -1142,7 +1145,7 @@ int __init pcibios_irq_init(void)
 			pirq_table = NULL;
 	}
 
-	pcibios_enable_irq = pirq_enable_irq;
+	pcibios_enable_irq = platform_setup.irqs.pci_enable_irq;
 
 	pcibios_fixup_irqs();
 
@@ -1185,7 +1188,7 @@ void pcibios_penalize_isa_irq(int irq, int active)
 		pirq_penalize_isa_irq(irq, active);
 }
 
-static int pirq_enable_irq(struct pci_dev *dev)
+int pirq_enable_irq(struct pci_dev *dev)
 {
 	u8 pin;
 
-- 
1.5.6.5

