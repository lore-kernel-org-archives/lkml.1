Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZFXFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZFXFbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZFXFbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:31:15 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:46662 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZFXFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:31:14 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A41BA27.4000606@lwfinger.net>
Date: Wed, 24 Jun 2009 00:31:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <4A418254.9050607@lwfinger.net>
In-Reply-To: <4A418254.9050607@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> My latest pull from Linus's tree fails to boot. Bisection leads to the
> commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
> resources and warn if exceeded" with hash
> f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
> capture the first error message as it scrolls off the screen, but the
> second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
> ahci_enable_ahci() because HOST_AHCI_EN is not set.

I have discovered a little more about this problem. Firstly, I applied
the following patch:

======================================================
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 16c3fda..5b05545 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -91,8 +91,10 @@ setup_resource(struct acpi_resource *acpi_res, void
*data)
        res->end = res->start + addr.address_length - 1;
        res->child = NULL;

-       if (bus_has_transparent_bridge(info->bus))
+       if (bus_has_transparent_bridge(info->bus)) {
                max_root_bus_resources -= 3;
+               printk(KERN_INFO "PCI: transparent bridge from %s for
%s\n", root->name, info->name);
+       }
        if (info->res_num >= max_root_bus_resources) {
                printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
                        "from %s for %s due to _CRS returning more than "
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d304ddf..117cac8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -329,7 +329,7 @@ static inline void pci_add_saved_cap(struct
pci_dev *pci_dev,
 }

 #ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES  16
+#define PCI_BUS_NUM_RESOURCES  24
 #endif

 #define PCI_REGION_FLAG_MASK   0x0fU   /* These bits of resource
flags tell us the PCI region flags */
=========================================================

By increasing PCI_BUS_NUM_RESOURCES, I got the system to boot and I
have a chance to put in some debugging statements. Now in dmesg, I get
the following:

ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.1: reg 10 io port: [0x3080-0x30bf]
pci 0000:00:01.1: reg 20 io port: [0x3040-0x307f]
pci 0000:00:01.1: reg 24 io port: [0x3000-0x303f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:01.3: reg 10 32bit mmio: [0xfc200000-0xfc27ffff]
pci 0000:00:02.0: reg 10 32bit mmio: [0xfc486000-0xfc486fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xfc489000-0xfc4890ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0xfc487000-0xfc487fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:04.1: reg 10 32bit mmio: [0xfc489400-0xfc4894ff]
pci 0000:00:04.1: supports D1 D2
pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.1: PME# disabled
pci 0000:00:06.0: reg 20 io port: [0x30c0-0x30cf]
pci 0000:00:07.0: reg 10 32bit mmio: [0xfc480000-0xfc483fff]
pci 0000:00:07.0: PME# supported from D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:09.0: reg 10 io port: [0x30f0-0x30f7]
pci 0000:00:09.0: reg 14 io port: [0x30e4-0x30e7]
pci 0000:00:09.0: reg 18 io port: [0x30e8-0x30ef]
pci 0000:00:09.0: reg 1c io port: [0x30e0-0x30e3]
pci 0000:00:09.0: reg 20 io port: [0x30d0-0x30df]
pci 0000:00:09.0: reg 24 32bit mmio: [0xfc484000-0xfc485fff]
pci 0000:00:0a.0: reg 10 32bit mmio: [0xfc488000-0xfc488fff]
pci 0000:00:0a.0: reg 14 io port: [0x30f8-0x30ff]
pci 0000:00:0a.0: reg 18 32bit mmio: [0xfc489c00-0xfc489cff]
pci 0000:00:0a.0: reg 1c 32bit mmio: [0xfc489800-0xfc48980f]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:12.0: reg 10 32bit mmio: [0xf4000000-0xf4ffffff]
pci 0000:00:12.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:12.0: reg 1c 64bit mmio: [0xf0000000-0xf0ffffff]
pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:09.0: reg 10 32bit mmio: [0x000000-0x0007ff]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.0: PME# disabled
pci 0000:01:09.1: reg 10 32bit mmio: [0xfc100800-0xfc1008ff]
pci 0000:01:09.1: supports D1 D2
pci 0000:01:09.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.1: PME# disabled
pci 0000:01:09.2: reg 10 32bit mmio: [0xfc100c00-0xfc100cff]
pci 0000:01:09.2: supports D1 D2
pci 0000:01:09.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.2: PME# disabled
pci 0000:01:09.3: reg 10 32bit mmio: [0xfc101000-0xfc1010ff]
pci 0000:01:09.3: supports D1 D2
pci 0000:01:09.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.3: PME# disabled
pci 0000:01:09.4: reg 10 32bit mmio: [0xfc101400-0xfc1014ff]
pci 0000:01:09.4: supports D1 D2
pci 0000:01:09.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.4: PME# disabled
pci 0000:00:08.0: transparent bridge
pci 0000:00:08.0: bridge 32bit mmio: [0xfc100000-0xfc1fffff]
pci 0000:00:0c.0: bridge io port: [0x4000-0x4fff]
pci 0000:00:0c.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xfc000000-0xfc003fff]
pci 0000:04:00.0: supports D1 D2
pci 0000:00:0d.0: bridge 32bit mmio: [0xfc000000-0xfc0fffff]
PCI: transparent bridge from PCI IO for PCI Bus 0000:00
PCI: transparent bridge from PCI IO for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00
PCI: transparent bridge from PCI mem for PCI Bus 0000:00

There is only a single transparent bridge at 0000:00:08.0; however, my
new printk in setup_resource() gets called a lot of times. Is this right?

The output of 'lspci' for this machine is

finger@larrylap:~/linux-2.6> lspci
00:00.0 RAM memory: nVidia Corporation MCP67 Memory Controller (rev a2)
00:01.0 ISA bridge: nVidia Corporation MCP67 ISA Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP67 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP67 Memory Controller (rev a2)
00:01.3 Co-processor: nVidia Corporation MCP67 Co-processor (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP67 OHCI USB 1.1
Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation MCP67 EHCI USB 2.0
Controller (rev a2)
00:04.0 USB Controller: nVidia Corporation MCP67 OHCI USB 1.1
Controller (rev a2)
00:04.1 USB Controller: nVidia Corporation MCP67 EHCI USB 2.0
Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation MCP67 IDE Controller (rev a1)
00:07.0 Audio device: nVidia Corporation MCP67 High Definition Audio
(rev a1)
00:08.0 PCI bridge: nVidia Corporation MCP67 PCI Bridge (rev a2)
00:09.0 IDE interface: nVidia Corporation MCP67 AHCI Controller (rev a2)
00:0a.0 Ethernet controller: nVidia Corporation MCP67 Ethernet (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP67 PCI Express Bridge (rev a2)
00:0d.0 PCI bridge: nVidia Corporation MCP67 PCI Express Bridge (rev a2)
00:12.0 VGA compatible controller: nVidia Corporation GeForce 7150M
(rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:09.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 05)
01:09.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
Host Adapter (rev 22)
01:09.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller
(rev 12)
01:09.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
Adapter (rev 12)
01:09.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller
(rev 12)
04:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g
(rev 01)

Larry
