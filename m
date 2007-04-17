Return-Path: <linux-kernel-owner+w=401wt.eu-S1031266AbXDQV54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031266AbXDQV54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031267AbXDQV54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:57:56 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:58430 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031266AbXDQV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:57:54 -0400
Subject: [PATCH v3] hpet: Detect hidden HPET on NVidia motherboards
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Currid <ACurrid@nvidia.com>
In-Reply-To: <20070416214042.GB25508@one.firstfloor.org>
References: <1176708094.22969.7.camel@dual.local>
	 <p734png6s1t.fsf@bingen.suse.de>
	 <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi>
	 <20070416214042.GB25508@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 00:57:48 +0300
Message-Id: <1176847068.4865.3.camel@dual.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enables HPET for NVidia motherboards with broken BIOS. The patch reads
the HPET address from the pci config space. The patch should also work
if ACPI is disabled.

The new quirk activates use of HPET only run if
- CONFIG_HPET_NFORCE_DETECT is enabled
- nohpet boot option is not set
- main chipset is from NVidia
- ACPI tables do not list HPET
- matching PCI ID for device with HPET is found
- BIOS has set up the HPET to some address
- there is no other resource allocated at the HPET address

This is true at least for some Asus, Gigabyte and DFI motherboards.

Patch is against 2.6.21-rc6-git7 but should apply cleanly to most
kernels.

Signed-off-by: Mikko Tiihonen <mikko.tiihonen@iki.fi>

---

Changes since v2:
- removed duplicated pci scanning code and moved it to pci/early.c
- added CONFIG_HPET_NFORCE_DETECT

diff -uprN -X linux-2.6.21-rc6-git7/Documentation/dontdiff linux-2.6.21-rc6-git7/arch/i386/pci/early.c linux-2.6.21-rc6-git7.hpet/arch/i386/pci/early.c
--- linux-2.6.21-rc6-git7/arch/i386/pci/early.c	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.21-rc6-git7.hpet/arch/i386/pci/early.c	2007-04-18 00:25:35.000000000 +0300
@@ -57,3 +57,50 @@ int early_pci_allowed(void)
 	return (pci_probe & (PCI_PROBE_CONF1|PCI_PROBE_NOEARLY)) ==
 			PCI_PROBE_CONF1;
 }
+
+void __init early_pci_scan(struct pci_entry matching[])
+{
+	int num, slot, func;
+
+	/* Poor man's PCI discovery */
+	for (num = 0; num < 32; num++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u32 class;
+				u32 vendor;
+				u8 type;
+				int i;
+				class = read_pci_config(num,slot,func,
+							PCI_CLASS_REVISION);
+				if (class == 0xffffffff)
+					break;
+
+				class >>= 16;
+
+				vendor = read_pci_config(num, slot, func,
+							 PCI_VENDOR_ID);
+
+				for (i = 0; matching[i].f; i++) {
+					if (class != matching[i].class)
+						continue;
+
+					if ((vendor & 0xffff) != matching[i].vendor)
+						continue;
+
+					if (matching[i].device != 0xffff &&
+					    (vendor >> 16) != matching[i].device)
+						continue;
+
+					matching[i].f(num, slot, func);
+					return;
+				}
+
+				/* No multi-function device? */
+				type = read_pci_config_byte(num,slot,func,
+							    PCI_HEADER_TYPE);
+				if (!(type & 0x80))
+					break;
+			}
+		}
+	}
+}
diff -uprN -X linux-2.6.21-rc6-git7/Documentation/dontdiff linux-2.6.21-rc6-git7/arch/x86_64/Kconfig linux-2.6.21-rc6-git7.hpet/arch/x86_64/Kconfig
--- linux-2.6.21-rc6-git7/arch/x86_64/Kconfig	2007-04-15 13:34:28.000000000 +0300
+++ linux-2.6.21-rc6-git7.hpet/arch/x86_64/Kconfig	2007-04-17 23:53:18.000000000 +0300
@@ -453,6 +453,15 @@ config HPET_EMULATE_RTC
 	bool "Provide RTC interrupt"
 	depends on HPET_TIMER && RTC=y
 
+config HPET_NFORCE_DETECT
+	bool "Detect HPET on NForce motherboards with broken BIOS"
+	depends on HPET_TIMER
+	default y
+	help
+	  Some buggy BIOS implementations do not list HPET in ACPI
+	  tables but still have the HPET enabled. This option allows
+	  using HPET on such motherboards with NForce chipsets.
+
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config IOMMU
diff -uprN -X linux-2.6.21-rc6-git7/Documentation/dontdiff linux-2.6.21-rc6-git7/arch/x86_64/kernel/early-quirks.c linux-2.6.21-rc6-git7.hpet/arch/x86_64/kernel/early-quirks.c
--- linux-2.6.21-rc6-git7/arch/x86_64/kernel/early-quirks.c	2007-04-18 00:27:26.000000000 +0300
+++ linux-2.6.21-rc6-git7.hpet/arch/x86_64/kernel/early-quirks.c	2007-04-17 23:02:16.000000000 +0300
@@ -15,8 +15,9 @@
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
 #include <asm/dma.h>
+#include <linux/bootmem.h>
 
-static void __init via_bugs(void)
+static void __init via_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
@@ -36,7 +37,79 @@ static int __init nvidia_hpet_check(stru
 }
 #endif
 
-static void __init nvidia_bugs(void)
+#ifdef CONFIG_HPET_NFORCE_DETECT
+
+static void __init detect_nforce_hpet(int num, int slot, int func)
+{
+	u32 addr;
+	struct resource *hpet_res;
+
+	addr = read_pci_config(num, slot, func, 0x44);
+	if (!addr) {
+		return;
+	}
+
+#define HPET_RESOURCE_NAME_SIZE 12
+	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
+	if (!hpet_res) {
+		/* We could try writing to the 0x44 and see if that is enough
+		 * to enable HPET even if BIOS did not initialize it.
+		 */
+		printk(KERN_INFO "HPET not set up by BIOS.\n");
+		return;
+	}
+
+	memset(hpet_res, 0, sizeof(*hpet_res));
+	hpet_res->name = (void *)&hpet_res[1];
+	hpet_res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	strncpy((char *)hpet_res->name, "NVidia HPET", 
+		HPET_RESOURCE_NAME_SIZE);
+	hpet_res->start = addr;
+	hpet_res->end = hpet_res->start + HPET_MMAP_SIZE - 1;
+
+	if (request_resource(&iomem_resource, hpet_res)) {
+		printk(KERN_INFO "NVidia quirk failed. Could not "
+		       "reserve resources for HPET at base: %#x\n", addr);
+		return;
+	}
+
+	hpet_address = addr;
+	printk(KERN_INFO "NVidia quirk. Enabled hidden HPET that BIOS had "
+	       "configured at base: %#x\n", addr);
+}
+
+static struct pci_entry nforce_hpet_chips[] __initdata = {
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0050, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0051, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0360, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0361, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0362, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0363, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0364, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0365, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0366, detect_nforce_hpet },
+	{ PCI_CLASS_BRIDGE_ISA, PCI_VENDOR_ID_NVIDIA, 0x0367, detect_nforce_hpet },
+	{}
+};
+
+static bool __init enable_nvidia_hpet(void)
+{
+	if (hpet_address || nohpet)
+		return 0;
+
+	early_pci_scan(nforce_hpet_chips);
+
+	return hpet_address != 0;
+}
+
+#else
+static bool __init enable_nvidia_hpet(void)
+{
+	return 0;
+}
+#endif
+
+static void __init nvidia_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 	/*
@@ -50,6 +123,10 @@ static void __init nvidia_bugs(void)
 		return;
 
 	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		if (enable_nvidia_hpet()) {
+			return;
+		}
+
 		acpi_skip_timer_override = 1;
 		printk(KERN_INFO "Nvidia board "
 		       "detected. Ignoring ACPI "
@@ -57,12 +134,14 @@ static void __init nvidia_bugs(void)
 		printk(KERN_INFO "If you got timer trouble "
 			"try acpi_use_timer_override\n");
 	}
+#else
+	enable_nvidia_hpet();
 #endif
 	/* RED-PEN skip them on mptables too? */
 
 }
 
-static void __init ati_bugs(void)
+static void __init ati_bugs(int num, int slot, int func)
 {
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
@@ -71,7 +150,7 @@ static void __init ati_bugs(void)
 	}
 }
 
-static void intel_bugs(void)
+static void intel_bugs(int num, int slot, int func)
 {
 	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
 
@@ -83,57 +162,18 @@ static void intel_bugs(void)
 #endif
 }
 
-struct chipset {
-	u16 vendor;
-	void (*f)(void);
-};
-
-static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
-	{ PCI_VENDOR_ID_VIA, via_bugs },
-	{ PCI_VENDOR_ID_ATI, ati_bugs },
-	{ PCI_VENDOR_ID_INTEL, intel_bugs},
+static struct pci_entry early_qrk[] __initdata = {
+	{ PCI_CLASS_BRIDGE_PCI, PCI_VENDOR_ID_NVIDIA, 0xffff, nvidia_bugs },
+	{ PCI_CLASS_BRIDGE_PCI, PCI_VENDOR_ID_VIA, 0xffff, via_bugs },
+	{ PCI_CLASS_BRIDGE_PCI, PCI_VENDOR_ID_ATI, 0xffff, ati_bugs },
+	{ PCI_CLASS_BRIDGE_PCI, PCI_VENDOR_ID_INTEL, 0xffff, intel_bugs},
 	{}
 };
 
 void __init early_quirks(void)
 {
-	int num, slot, func;
-
 	if (!early_pci_allowed())
 		return;
 
-	/* Poor man's PCI discovery */
-	for (num = 0; num < 32; num++) {
-		for (slot = 0; slot < 32; slot++) {
-			for (func = 0; func < 8; func++) {
-				u32 class;
-				u32 vendor;
-				u8 type;
-				int i;
-				class = read_pci_config(num,slot,func,
-							PCI_CLASS_REVISION);
-				if (class == 0xffffffff)
-					break;
-
-		       		if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
-					continue;
-
-				vendor = read_pci_config(num, slot, func,
-							 PCI_VENDOR_ID);
-				vendor &= 0xffff;
-
-				for (i = 0; early_qrk[i].f; i++)
-					if (early_qrk[i].vendor == vendor) {
-						early_qrk[i].f();
-						return;
-					}
-
-				type = read_pci_config_byte(num, slot, func,
-							    PCI_HEADER_TYPE);
-				if (!(type & 0x80))
-					break;
-			}
-		}
-	}
+	early_pci_scan(early_qrk);
 }
diff -uprN -X linux-2.6.21-rc6-git7/Documentation/dontdiff linux-2.6.21-rc6-git7/include/asm-x86_64/pci-direct.h linux-2.6.21-rc6-git7.hpet/include/asm-x86_64/pci-direct.h
--- linux-2.6.21-rc6-git7/include/asm-x86_64/pci-direct.h	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.21-rc6-git7.hpet/include/asm-x86_64/pci-direct.h	2007-04-17 23:04:12.000000000 +0300
@@ -6,6 +6,20 @@
 /* Direct PCI access. This is used for PCI accesses in early boot before
    the PCI subsystem works. */ 
 
+/**
+ * struct pci_entry - simple pci device matching struct with callback
+ * @class: class to match - mandatory
+ * @vendor: vendor to match - mandatory
+ * @device: device to match - use 0xffff to ignore
+ * @f: callback function - called on matching entry
+ */
+struct pci_entry {
+	u16 class;
+	u16 vendor;
+	u16 device;
+	void (*f)(int num, int slot, int func);
+};
+
 extern u32 read_pci_config(u8 bus, u8 slot, u8 func, u8 offset);
 extern u8 read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset);
 extern u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset);
@@ -13,5 +27,6 @@ extern void write_pci_config(u8 bus, u8 
 extern void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val);
 
 extern int early_pci_allowed(void);
+extern void early_pci_scan(struct pci_entry matching[]);
 
 #endif


