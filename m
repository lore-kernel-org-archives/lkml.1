Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXILTYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXILTYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXILTYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:24:39 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57638 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXILTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:24:38 -0400
Date: Wed, 12 Sep 2007 12:31:22 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200709121231.23345.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron

So even MCFG is not there, we still can use MMCONFIG.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/i386/pci/mmconfig-shared.c	2007-09-12 10:18:09.000000000 -0700
+++ linux-2.6/arch/i386/pci/mmconfig-shared.c	2007-09-12 11:25:11.000000000 -0700
@@ -133,33 +133,79 @@
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_amd_fam10h(void)
+{
+	u32 low, high, address;
+	u64 base;
+	int i;
+	unsigned segnbits = 0, busnbits;
+
+	address = 0xc0010058;
+	if (rdmsr_safe(address, &low, &high))
+		return NULL;
+
+	/* mmconfig is not enable */
+	if (!(low & 1))
+		return NULL;
+
+	base = high & 0xffff;
+	base <<= 32;
+
+	busnbits = (low >> 2) & 0x0f;
+	if (busnbits > 8) {
+		segnbits = busnbits - 8;
+		busnbits = 8;
+	}
+
+	pci_mmcfg_config_num = (1 << segnbits);
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]) * pci_mmcfg_config_num, GFP_KERNEL);
+	if (!pci_mmcfg_config)
+		return NULL;
+
+	for (i=0; i < (1 << segnbits); i++) {
+		pci_mmcfg_config[i].address = base + (1<<28) * i;
+		pci_mmcfg_config[i].pci_segment = i;
+		pci_mmcfg_config[i].start_bus_number = 0;
+		pci_mmcfg_config[i].end_bus_number = (1 << busnbits) - 1;
+	}
+
+	return "AMD Family 10h NB";
+}
+
 struct pci_mmcfg_hostbridge_probe {
+	u32 bus;
+	u32 devfn;
 	u32 vendor;
 	u32 device;
 	const char *(*probe)(void);
 };
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0x18, 0), PCI_VENDOR_ID_AMD, 0x1200, pci_mmcfg_amd_fam10h },
+	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD, 0x1200, pci_mmcfg_amd_fam10h },
 };
 
 static int __init pci_mmcfg_check_hostbridge(void)
 {
 	u32 l;
+	u32 bus, devfn;
 	u16 vendor, device;
 	int i;
 	const char *name;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
-	vendor = l & 0xffff;
-	device = (l >> 16) & 0xffff;
-
 	pci_mmcfg_config_num = 0;
 	pci_mmcfg_config = NULL;
 	name = NULL;
 
 	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
+		bus =  pci_mmcfg_probes[i].bus;
+		devfn = pci_mmcfg_probes[i].devfn;
+		pci_conf1_read(0, bus, devfn, 0, 4, &l);
+		vendor = l & 0xffff;
+		device = (l >> 16) & 0xffff;
+
 		if (pci_mmcfg_probes[i].vendor == vendor &&
 		    pci_mmcfg_probes[i].device == device)
 			name = pci_mmcfg_probes[i].probe();
