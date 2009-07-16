Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZGPKzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZGPKzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbZGPKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:55:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:43977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbZGPKzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="475407305"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:54:59 -0700
Subject: [PATCH v2 4/10] x86: make use of platform feature flags during setup
Thread-Topic: [PATCH v2 4/10] x86: make use of platform feature flags during
 setup
Thread-Index: AcoGA9yxkwgyCouqSiC7KddWAawTWw==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF6@orsmsx508.amr.corp.intel.com>
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

>From 20feb75bb8d273e06773a343386c5ab061d864d0 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 8 Jul 2009 16:51:42 -0700
Subject: [PATCH] x86: make use of platform feature flags during setup

This patch uses platform feature flags to selectively
perform platform initialization. Default feature flags
are set based on HW sub architecture IDs.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/setup.h    |    1 +
 arch/x86/kernel/head32.c        |    7 ++++++-
 arch/x86/kernel/probe_roms_32.c |    3 +++
 arch/x86/kernel/setup.c         |    7 +++++--
 arch/x86/pci/irq.c              |   23 +++++++++++++++++++++++
 5 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 7bf325a..c0839f7 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -32,6 +32,7 @@ struct x86_quirks {
 				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
 	void (*setup_secondary_clock)(void);
+	void (*reserve_ebda_region)(void);
 };
 
 extern void x86_quirk_intr_init(void);
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3f8579f..d31e629 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -13,6 +13,8 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
+#include <asm/bootparam.h>
+#include <asm/platform_feature.h>
 
 void __init i386_start_kernel(void)
 {
@@ -29,7 +31,10 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_ebda_region();
+	platform_feature_init_default();
+
+	if (x86_quirks->reserve_ebda_region)
+		reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
index 071e7fe..6aa4ec8 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms_32.c
@@ -19,6 +19,7 @@
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/setup_arch.h>
+#include <asm/platform_feature.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -99,6 +100,8 @@ void __init probe_roms(void)
 	unsigned char c;
 	int i;
 
+	if (!platform_has(X86_PLATFORM_FEATURE_BIOS))
+		return;
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
 	for (start = video_rom_resource.start; start < upper; start += 2048) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..e063689 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -88,6 +88,7 @@
 #include <asm/processor.h>
 #include <asm/bugs.h>
 
+#include <asm/platform_feature.h>
 #include <asm/system.h>
 #include <asm/vsyscall.h>
 #include <asm/cpu.h>
@@ -1003,9 +1004,11 @@ void __init setup_arch(char **cmdline_p)
 	e820_mark_nosave_regions(max_low_pfn);
 
 #ifdef CONFIG_X86_32
-	request_resource(&iomem_resource, &video_ram_resource);
+	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+		request_resource(&iomem_resource, &video_ram_resource);
 #endif
-	reserve_standard_io_resources();
+	if (platform_has(X86_PLATFORM_FEATURE_ISA))
+		reserve_standard_io_resources();
 
 	e820_setup_gap();
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0696d50..93b5fd3 100644
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
@@ -1022,6 +1023,10 @@ static void __init pcibios_fixup_irqs(void)
 	u8 pin;
 
 	DBG(KERN_DEBUG "PCI: IRQ fixup\n");
+	if (!platform_has(X86_PLATFORM_FEATURE_BIOS)) {
+		DBG(KERN_DEBUG "PCI: No BIOS, skip IRQ fixup\n");
+		return;
+	}
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		/*
 		 * If the BIOS has set an out of range IRQ number, just
@@ -1190,6 +1195,24 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	u8 pin;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SFI)
+	/* For platforms only have IOAPIC, the PCI irq line is 1:1 mapped to
+	 * IOAPIC RTE entries, so we just enable RTE for the device.
+	 */
+	if (platform_has(X86_PLATFORM_FEATURE_IOAPIC) &&
+		!platform_has(X86_PLATFORM_FEATURE_8259) &&
+		!platform_has(X86_PLATFORM_FEATURE_ACPI) &&
+		!platform_has(X86_PLATFORM_FEATURE_BIOS) &&
+		dev->pin) {
+		struct io_apic_irq_attr irq_attr;
+		irq_attr.ioapic = mp_sfi_find_ioapic(dev->irq);
+		irq_attr.ioapic_pin = dev->irq;
+		irq_attr.trigger = 1; /* level */
+		irq_attr.polarity = 1; /* active low */
+		io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
+		return 0;
+	}
+#endif
 	if (pin && !pcibios_lookup_irq(dev, 1)) {
 		char *msg = "";
 
-- 
1.5.6.5

