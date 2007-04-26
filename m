Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbXDZT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbXDZT1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXDZT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:27:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:50810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbXDZT1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,457,1170662400"; 
   d="scan'208";a="219937132"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] support PCI MCFG space on Intel i915 bridges
Date: Thu, 26 Apr 2007 12:27:24 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261227.25575.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Intel 915 bridge chips to the new PCI MMConfig detection
code.  Tested and works on my sole 915 based platform (a Toshiba laptop).  I
added register masking per Oliver's suggestion, and moved the __init
qualifier to after the 'static const char' to match Ogawa-san's recent
cleanup patches.

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff --git a/arch/i386/pci/mmconfig-shared.c b/arch/i386/pci/mmconfig-shared.c
index 747d8c6..1339d31 100644
--- a/arch/i386/pci/mmconfig-shared.c
+++ b/arch/i386/pci/mmconfig-shared.c
@@ -72,6 +72,26 @@ static const char __init *pci_mmcfg_e7520(void)
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_intel_915(void)
+{
+       u32 pciexbar, len = 0;
+
+       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+
+       /* No enable bit or size field, so assume 256M range is enabled. */
+       len = 0x10000000U;
+       pci_mmcfg_config_num = 1;
+       pciexbar &= 0xe0000000; /* mask out potentially bogus bits */
+
+       pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+       pci_mmcfg_config[0].address = pciexbar;
+       pci_mmcfg_config[0].pci_segment = 0;
+       pci_mmcfg_config[0].start_bus_number = 0;
+       pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
+
+       return "Intel Corporation 915PM/GM/GMS Express Memory Controller Hub";
+}
+
 static const char __init *pci_mmcfg_intel_945(void)
 {
 	u32 pciexbar, mask = 0, len = 0;
@@ -129,6 +149,7 @@ struct pci_mmcfg_hostbridge_probe {
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82915GM_HB, pci_mmcfg_intel_915 },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
 };
 
