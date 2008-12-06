Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYLFOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYLFOLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYLFOKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:10:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbYLFOKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:10:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with interrupts disabled
Date: Sat, 6 Dec 2008 15:07:59 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl>
In-Reply-To: <200812061505.33815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061508.00277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Suspend and resume PCI Express ports with interrupts disabled

I don't see why the suspend and resume of PCI Express ports should be
handled with interrupts enabled and it may even lead to problems in
some situations.  For this reason, move the suspending and resuming
of PCI Express ports into ->suspend_late() and ->resume_early()
callbacks executed with interrupts disabled.

This patch addresses the regression from 2.6.26 tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12121 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_pci.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -50,7 +50,7 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
+static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
 {
 	int ret = pcie_port_device_suspend(dev, state);
 
@@ -59,14 +59,14 @@ static int pcie_portdrv_suspend(struct p
 	return ret;
 }
 
-static int pcie_portdrv_resume(struct pci_dev *dev)
+static int pcie_portdrv_resume_early(struct pci_dev *dev)
 {
 	pcie_portdrv_restore_config(dev);
 	return pcie_port_device_resume(dev);
 }
 #else
-#define pcie_portdrv_suspend NULL
-#define pcie_portdrv_resume NULL
+#define pcie_portdrv_suspend_late NULL
+#define pcie_portdrv_resume_early NULL
 #endif
 
 /*
@@ -282,8 +282,8 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
-	.suspend	= pcie_portdrv_suspend,
-	.resume		= pcie_portdrv_resume,
+	.suspend_late	= pcie_portdrv_suspend_late,
+	.resume_early	= pcie_portdrv_resume_early,
 
 	.err_handler 	= &pcie_portdrv_err_handler,
 };

