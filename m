Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXFIUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXFIUMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbXFIUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:12:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:20905 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbXFIUM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,403,1175497200"; 
   d="scan'208";a="255120517"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH] PCI: also read revision ID for sparc64, ppc,
	read class at the same time
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Cc: grundler@parisc-linux.org, davem@davemloft.net
Date: Sat, 09 Jun 2007 13:12:21 -0700
Message-ID: <20070609201221.5868.31948.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 20:12:22.0594 (UTC) FILETIME=[7D553A20:01C7AAD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the PCI bus class and revision are in the same dword, we
can fill in both in the same read.

Other non-x86 arches use different methods to fill in these values,
make sure to adjust those too.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 arch/powerpc/kernel/pci_64.c |    2 ++
 arch/sparc64/kernel/pci.c    |    1 +
 drivers/pci/probe.c          |    4 +---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 249cca2..b2c55ca 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -367,8 +367,10 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
 		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 	dev->class = get_int_prop(node, "class-code", 0);
+	dev->revision = get_int_prop(node, "revision-id", 0);
 
 	DBG("    class: 0x%x\n", dev->class);
+	DBG("    revision: 0x%x\n", dev->revision);
 
 	dev->current_state = 4;		/* unknown power state */
 	dev->error_state = pci_channel_io_normal;
diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index 38a32bc..759cc20 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -448,6 +448,7 @@ struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 		 */
 		pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 		dev->class = class >> 8;
+		dev->revision = class & 0xff;
 
 		sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
 			dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0fdb71d..a574b7f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -702,6 +702,7 @@ static int pci_setup_device(struct pci_dev * dev)
 		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
+	dev->revision = class & 0xff;
 	class >>= 8;				    /* upper 3 bytes */
 	dev->class = class;
 	class >>= 8;
@@ -918,9 +919,6 @@ pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
 
-	/* read the PCI revision: 1 byte */
-	pci_read_config_byte(dev, PCI_REVISION_ID, &dev->revision);
-
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
 	dev->dma_mask = 0xffffffff;
