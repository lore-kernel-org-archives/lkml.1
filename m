Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZBDBWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZBDBWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZBDBTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:19:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbZBDBTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:19:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 4/7] PCI PCIe portdrv: Simplify suspend and resume
Date: Wed, 4 Feb 2009 02:00:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl>
In-Reply-To: <200902040154.36018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040200.12488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Simplify suspend and resume of the PCI Express port driver that
doesn't need to save and restore the standard configuration space
of the device any more, since this is now done by the PCI PM core
layer.

This patch is reported to fix the regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12598

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Parag Warudkar <parag.lkml@gmail.com>
---
 drivers/pci/pcie/portdrv_pci.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -55,25 +55,13 @@ static int pcie_portdrv_suspend(struct p
 
 }
 
-static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
-{
-	return pci_save_state(dev);
-}
-
-static int pcie_portdrv_resume_early(struct pci_dev *dev)
-{
-	return pci_restore_state(dev);
-}
-
 static int pcie_portdrv_resume(struct pci_dev *dev)
 {
-	pcie_portdrv_restore_config(dev);
+	pci_set_master(dev);
 	return pcie_port_device_resume(dev);
 }
 #else
 #define pcie_portdrv_suspend NULL
-#define pcie_portdrv_suspend_late NULL
-#define pcie_portdrv_resume_early NULL
 #define pcie_portdrv_resume NULL
 #endif
 
@@ -292,8 +280,6 @@ static struct pci_driver pcie_portdriver
 	.remove		= pcie_portdrv_remove,
 
 	.suspend	= pcie_portdrv_suspend,
-	.suspend_late	= pcie_portdrv_suspend_late,
-	.resume_early	= pcie_portdrv_resume_early,
 	.resume		= pcie_portdrv_resume,
 
 	.err_handler 	= &pcie_portdrv_err_handler,

