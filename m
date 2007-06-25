Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbXFYDTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbXFYDTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXFYDT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:19:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:2525 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbXFYDTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:19:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,457,1175497200"; 
   d="scan'208";a="242783882"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH 1/2] [RESEND] PCI: read revision ID by default
To: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       davem@davemloft.net, davej@redhat.com
Date: Sun, 24 Jun 2007 20:19:18 -0700
Message-ID: <20070625031918.4711.2705.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2007 03:19:24.0271 (UTC) FILETIME=[A13D1FF0:01C7B6D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are 97 occurrences where drivers need the pci
revision ID. We can do this once for all devices. Even the pci
subsystem needs the revision several times for quirks. The extra
u8 member pads out nicely in the pci_dev struct.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 arch/powerpc/kernel/pci_64.c |    2 ++
 arch/sparc64/kernel/pci.c    |    1 +
 drivers/pci/probe.c          |    1 +
 include/linux/pci.h          |    1 +
 4 files changed, 5 insertions(+), 0 deletions(-)

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
index 81f4a5e..55ad1b8 100644
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
index e48fcf0..a574b7f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -702,6 +702,7 @@ static int pci_setup_device(struct pci_dev * dev)
 		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
+	dev->revision = class & 0xff;
 	class >>= 8;				    /* upper 3 bytes */
 	dev->class = class;
 	class >>= 8;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fbf3766..9847936 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -138,6 +138,7 @@ struct pci_dev {
 	unsigned short	subsystem_vendor;
 	unsigned short	subsystem_device;
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
+	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
