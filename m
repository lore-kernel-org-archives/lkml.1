Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYL0Pb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYL0Pb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYL0PbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:31:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYL0PbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:31:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PCI PM: Split PCI Express port suspend-resume
Date: Sat, 27 Dec 2008 16:28:58 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200812271627.32781.rjw@sisk.pl>
In-Reply-To: <200812271627.32781.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812271628.58748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Suspend-resume of PCI Express ports has recently been moved into
_suspend_late() and _resume_early() callbacks, but some functions
executed from there should not be called with interrupts disabled,
eg. pci_enable_device().  For this reason, split the suspend-resume
of PCI Express ports into parts to be executed with interrupts
disabled and with interrupts enabled.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_pci.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -41,7 +41,6 @@ static int pcie_portdrv_restore_config(s
 {
 	int retval;
 
-	pci_restore_state(dev);
 	retval = pci_enable_device(dev);
 	if (retval)
 		return retval;
@@ -50,23 +49,32 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
+static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	int ret = pcie_port_device_suspend(dev, state);
+	return pcie_port_device_suspend(dev, state);
+
+}
 
-	if (!ret)
-		ret = pcie_portdrv_save_config(dev);
-	return ret;
+static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
+{
+	return pci_save_state(dev);
 }
 
 static int pcie_portdrv_resume_early(struct pci_dev *dev)
 {
+	return pci_restore_state(dev);
+}
+
+static int pcie_portdrv_resume(struct pci_dev *dev)
+{
 	pcie_portdrv_restore_config(dev);
 	return pcie_port_device_resume(dev);
 }
 #else
+#define pcie_portdrv_suspend NULL
 #define pcie_portdrv_suspend_late NULL
 #define pcie_portdrv_resume_early NULL
+#define pcie_portdrv_resume NULL
 #endif
 
 /*
@@ -221,6 +229,7 @@ static pci_ers_result_t pcie_portdrv_slo
 
 	/* If fatal, restore cfg space for possible link reset at upstream */
 	if (dev->error_state == pci_channel_io_frozen) {
+		pci_restore_state(dev);
 		pcie_portdrv_restore_config(dev);
 		pci_enable_pcie_error_reporting(dev);
 	}
@@ -282,8 +291,10 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
+	.suspend	= pcie_portdrv_suspend,
 	.suspend_late	= pcie_portdrv_suspend_late,
 	.resume_early	= pcie_portdrv_resume_early,
+	.resume		= pcie_portdrv_resume,
 
 	.err_handler 	= &pcie_portdrv_err_handler,
 };

