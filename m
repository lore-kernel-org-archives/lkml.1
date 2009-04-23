Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZDWH2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZDWH2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZDWH1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:20 -0400
Received: from sous-sol.org ([216.99.217.87]:48152 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754637AbZDWH1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:18 -0400
Message-Id: <20090423072130.073731512@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       H Peter Anvin <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 005/100] PCI/x86: detect host bridge config space size w/o using quirks
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=pci-x86-detect-host-bridge-config-space-size-w-o-using-quirks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Yinghai Lu <yinghai@kernel.org>

upstream commit: dfadd9edff498d767008edc6b2a6e86a7a19934d

Many host bridges support a 4k config space, so check them directy
instead of using quirks to add them.

We only need to do this extra check for host bridges at this point,
because only host bridges are known to have extended address space
without also having a PCI-X/PCI-E caps.  Other devices with this
property could be done with quirks (if there are any).

As a bonus, we can remove the quirks for AMD host bridges with family
10h and 11h since they're not needed any more.

With this patch, we can get correct pci cfg size of new Intel CPUs/IOHs
with host bridges.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/pci/fixup.c |   20 --------------------
 drivers/pci/probe.c  |    9 ++++++++-
 2 files changed, 8 insertions(+), 21 deletions(-)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
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
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
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
 

