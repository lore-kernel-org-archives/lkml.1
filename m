Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZCGAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZCGAwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCGAwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:52:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:39433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZCGAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:52:14 -0500
Message-ID: <49B1C50E.5010209@kernel.org>
Date: Fri, 06 Mar 2009 16:51:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: get correct pci_cfg_size for host_bridge

more host bridges support 4k cfg, so check them directly
instead of quirks.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/fixup.c |   20 --------------------
 drivers/pci/probe.c  |    9 ++++++++-
 2 files changed, 8 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/fixup.c
+++ linux-2.6/arch/x86/pci/fixup.c
@@ -495,26 +495,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 			  pci_siemens_interrupt_controller);
 
 /*
- * Regular PCI devices have 256 bytes, but AMD Family 10h/11h CPUs have
- * 4096 bytes configuration space for each function of their processor
- * configuration space.
- */
-static void amd_cpu_pci_cfg_space_size(struct pci_dev *dev)
-{
-	dev->cfg_size = pci_cfg_space_size_ext(dev);
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1300, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1301, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1302, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1303, amd_cpu_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1304, amd_cpu_pci_cfg_space_size);
-
-/*
  * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
  * confusing the PCI engine:
  */
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -847,6 +847,11 @@ int pci_cfg_space_size(struct pci_dev *d
 {
 	int pos;
 	u32 status;
+	u16 class;
+
+	class = dev->class >> 8;
+	if (class == PCI_CLASS_BRIDGE_HOST)
+		return pci_cfg_space_size_ext(dev);
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
@@ -936,7 +941,6 @@ static struct pci_dev *pci_scan_device(s
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
-	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
 	set_pcie_port_type(dev);
 
@@ -952,6 +956,9 @@ static struct pci_dev *pci_scan_device(s
 		return NULL;
 	}
 
+	/* need to have dev->class ready */
+	dev->cfg_size = pci_cfg_space_size(dev);
+
 	return dev;
 }
 
