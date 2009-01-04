Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZADXDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZADXDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZADXBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbZADXBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/8] PCI PCIe portdrv: Remove root ports MSI quirk
Date: Sun, 4 Jan 2009 23:48:21 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042348.22012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver contains a quirk that prevents root
ports from using MSI, but there is no explanation for it and the
PCI Express specification clearly allows root ports to use MSI.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_core.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -17,8 +17,6 @@
 
 #include "portdrv.h"
 
-extern int pcie_mch_quirk;	/* MSI-quirk Indicator */
-
 /**
  * release_pcie_device - free PCI Express port service device structure
  * @dev: Port service device to release
@@ -31,28 +29,6 @@ static void release_pcie_device(struct d
 	kfree(to_pcie_device(dev));			
 }
 
-static int is_msi_quirked(struct pci_dev *dev)
-{
-	int port_type, quirk = 0;
-	u16 reg16;
-
-	pci_read_config_word(dev, 
-		pci_find_capability(dev, PCI_CAP_ID_EXP) + 
-		PCIE_CAPABILITIES_REG, &reg16);
-	port_type = (reg16 >> 4) & PORT_TYPE_MASK;
-	switch(port_type) {
-	case PCIE_RC_PORT:
-		if (pcie_mch_quirk == 1)
-			quirk = 1;
-		break;
-	case PCIE_SW_UPSTREAM_PORT:
-	case PCIE_SW_DOWNSTREAM_PORT:
-	default:
-		break;	
-	}
-	return quirk;
-}
-
 /**
  * assign_interrupt_mode - choose interrupt mode for PCI Express port services
  *                         (INTx, MSI-X, MSI) and set up vectors
@@ -73,10 +49,6 @@ static int assign_interrupt_mode(struct 
 			nvec++;
 		vectors[i] = dev->irq;
 	}
-	
-	/* Check MSI quirk */
-	if (is_msi_quirked(dev))
-		return interrupt_mode;
 
 	/* Select MSI-X over MSI if supported */		
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);

