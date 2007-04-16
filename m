Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXDPHpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXDPHpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXDPHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:45:04 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:42648 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbXDPHpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:45:03 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 03:45:03 EDT
Subject: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: clemens@ladisch.de, bob.picco@hp.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 10:21:33 +0300
Message-Id: <1176708094.22969.7.camel@dual.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enables HPET for NVidia motherboards with broken BIOS. The patch reads
the HPET address from the pci config space. The patch should also work
if ACPI is disabled.

The HPET search is done in early-quirks because even 
DECLARE_PCI_FIXUP_EARLY was too late. If the new quirk causes problems
it can be disabled with the nohpet boot option.

The patch assumes that the BIOS has done the basic setup of HPET, but
has not published the result in ACPI tables. This is at least true for
some Asus and Gigabyte motherboards.

Patch is against 2.6.21-rc6-git7 but should apply cleanly to most
kernels.

Signed-off-by: Mikko Tiihonen <mikko.tiihonen@iki.fi>

---

It looks probable that most NVidia chipsets have the HPET address at
0x44. It might be possible to enable the HPET even if BIOS did not
initialize it properly by writing the wanted address there. Some other
pci config space bits might need to be fiddled around too, most likely
candidates are 0x74 bit 2 and 0xA3 bit ?. One or both of them have been
identified to change in some motherboards when HPET is enabled/disabled
in BIOS.

--- arch/x86_64/kernel/early-quirks.c.orig	2007-04-16 01:30:33.000000000 +0300
+++ arch/x86_64/kernel/early-quirks.c	2007-04-16 01:27:23.000000000 +0300
@@ -15,6 +15,7 @@
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
 #include <asm/dma.h>
+#include <linux/bootmem.h>
 
 static void __init via_bugs(void)
 {
@@ -36,6 +37,104 @@ static int __init nvidia_hpet_check(stru
 }
 #endif
 
+#ifdef CONFIG_HPET
+
+static u32 nvidia_hpet_chips[] __initdata = {
+	/* ISA Bridge */
+	PCI_VENDOR_ID_NVIDIA | (0x0050 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0051 << 16),
+	/* LPC Bridge */
+	PCI_VENDOR_ID_NVIDIA | (0x0360 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0361 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0362 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0363 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0364 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0365 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0366 << 16),
+	PCI_VENDOR_ID_NVIDIA | (0x0367 << 16),
+	0,
+};
+
+static int __init force_enable_nvidia_hpet(void)
+{
+	int num, slot, func;
+	u32 addr;
+	struct resource *hpet_res;
+
+	if (hpet_address || nohpet)
+		return 0;
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
+				vendor = read_pci_config(num, slot, func,
+							 PCI_VENDOR_ID);
+
+				for (i = 0; nvidia_hpet_chips[i]; i++)
+					if (nvidia_hpet_chips[i] == vendor) {
+						goto found;
+					}
+
+				type = read_pci_config_byte(num, slot, func,
+							    PCI_HEADER_TYPE);
+				if (!(type & 0x80))
+					break;
+			}
+		}
+	}
+	return 0;
+
+ found:
+	addr = read_pci_config(num, slot, func, 0x44);
+	if (!addr) {
+		return 0;
+	}
+
+#define HPET_RESOURCE_NAME_SIZE 12
+	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
+	if (!hpet_res) {
+		/* We could try writing to the 0x44 and see if that is enough
+		 * to enable HPET even if BIOS did not initialize it.
+		 */
+		printk(KERN_INFO "HPET not set up by BIOS.\n");
+		return 0;
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
+		return 0;
+	}
+
+	hpet_address = addr;
+	printk(KERN_INFO "NVidia quirk. Enabled hidden HPET that BIOS had "
+	       "configured at base: %#x\n", addr);
+	return 1;
+}
+#else
+static int __init force_enable_nvidia_hpet(void)
+{
+	return 0;
+}
+#endif
+
 static void __init nvidia_bugs(void)
 {
 #ifdef CONFIG_ACPI
@@ -50,6 +149,10 @@ static void __init nvidia_bugs(void)
 		return;
 
 	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		if (force_enable_nvidia_hpet()) {
+			return;
+		}
+
 		acpi_skip_timer_override = 1;
 		printk(KERN_INFO "Nvidia board "
 		       "detected. Ignoring ACPI "
@@ -57,6 +160,8 @@ static void __init nvidia_bugs(void)
 		printk(KERN_INFO "If you got timer trouble "
 			"try acpi_use_timer_override\n");
 	}
+#else
+	force_enable_nvidia_hpet();
 #endif
 	/* RED-PEN skip them on mptables too? */
 


