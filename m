Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbYANVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbYANVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYANVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:33:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55624 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYANVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:33:49 -0500
Date: Mon, 14 Jan 2008 13:36:35 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/3] x86_64: check MSR to get MMCONFIG for AMD Family 10h
 Opteron
In-reply-to: <200801141335.15558.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801141336.35351.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801141331.45898.yinghai.lu@sun.com>
 <200801141335.15558.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/3] x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron

So even MCFG is not there, we still can use MMCONFIG.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -133,33 +133,84 @@ static const char __init *pci_mmcfg_inte
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
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]) *
+				   pci_mmcfg_config_num, GFP_KERNEL);
+	if (!pci_mmcfg_config)
+		return NULL;
+
+	for (i = 0; i < (1 << segnbits); i++) {
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
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL,
+	  PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL,
+	  PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0x18, 0), PCI_VENDOR_ID_AMD,
+	  0x1200, pci_mmcfg_amd_fam10h },
+	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
+	  0x1200, pci_mmcfg_amd_fam10h },
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
