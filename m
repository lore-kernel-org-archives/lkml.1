Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZCIEhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZCIEhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 00:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZCIEg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 00:36:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZCIEg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 00:36:57 -0400
Message-ID: <49B49C99.3030603@kernel.org>
Date: Sun, 08 Mar 2009 21:35:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <gregkh@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: [PATCH] pci/x86: try to detect host_bridge pci_cfg_space -v2
References: <49B1C81B.5010904@zytor.com> <20090308110437.GA27811@elte.hu>	 <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com>	 <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com>	 <49B436E4.1050103@kernel.org>	 <20090308220100.GO25995@parisc-linux.org> <49B44182.1030707@zytor.com>	 <20090308222804.GA25376@elte.hu> <86802c440903081600l517c22ccj6328633c01131cb1@mail.gmail.com>
In-Reply-To: <86802c440903081600l517c22ccj6328633c01131cb1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: get correct pci_cfg_size for host_bridge

more host bridges support 4k cfg, so check them directy instead of quirks.

only need to do this extra check for host_bridge at this point, because only
host bridges are known to have extended address space without also having a
PCI-X/PCI-E caps.
other devices we could still do quirks for them if there is any.

also remove the quirks for AMD host bridges with family 10h and 11h that is not
needed any more

with this patch, we can get correct pci cfg size of new Intel CPUs/IOHs with
host bridges

v2: updated commit log.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: <stable@kernel.org>

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
 
