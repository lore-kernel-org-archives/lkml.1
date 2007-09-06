Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbXIFFsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbXIFFsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXIFFr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:47:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:55390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXIFFr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:47:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,213,1186383600"; 
   d="scan'208";a="294810478"
Subject: [RFC] disable PCIE 'Enable No Snoop' bit by default
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 13:35:08 +0800
Message-Id: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCIE 'Enable No Snoop' bit is set by default per PCIE spec, but OS
assumes PCI DMA is snooped, which is legacy PCI device does. Enabling no
snoop might cause potential DMA issues. This patch disables it, if a
driver can work with no snoop, we can provide a helper to enable it.

I didn't see any real breaks, but did see some devices with the bit enabled

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c	2007-09-06 13:18:07.000000000 +0800
+++ linux/drivers/pci/probe.c	2007-09-06 13:21:30.000000000 +0800
@@ -694,6 +694,19 @@ static void pci_read_irq(struct pci_dev 
 
 #define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
+static void pcie_setup_device(struct pci_dev *dev)
+{
+	u16 reg16;
+	int pos;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
+		reg16 &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
+	}
+}
+
 /**
  * pci_setup_device - fill in class and map information of a device
  * @dev: the device structure to fill
@@ -795,6 +808,7 @@ static int pci_setup_device(struct pci_d
 		dev->class = PCI_CLASS_NOT_DEFINED;
 	}
 
+	pcie_setup_device(dev);
 	/* We found a fine healthy device, go go go... */
 	return 0;
 }
