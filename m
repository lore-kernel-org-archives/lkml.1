Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXDEEfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXDEEfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXDEEfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:35:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48652 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbXDEEfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:35:03 -0400
Date: Wed, 4 Apr 2007 21:36:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] various drivers PCI must_checks
Message-Id: <20070404213632.fae3fcb7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Check PCI interface function results in parport, serial, & video drivers.

drivers/parport/parport_serial.c:402: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result
drivers/serial/8250_pci.c:1826: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result
drivers/video/s3fb.c:1078: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/parport/parport_serial.c |    8 +++++++-
 drivers/serial/8250_pci.c        |   10 +++++++++-
 drivers/video/s3fb.c             |    9 ++++++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc5-mm4.orig/drivers/parport/parport_serial.c
+++ linux-2.6.21-rc5-mm4/drivers/parport/parport_serial.c
@@ -392,6 +392,7 @@ static int parport_serial_pci_suspend(st
 static int parport_serial_pci_resume(struct pci_dev *dev)
 {
 	struct parport_serial_private *priv = pci_get_drvdata(dev);
+	int err;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -399,7 +400,12 @@ static int parport_serial_pci_resume(str
 	/*
 	 * The device may have been disabled.  Re-enable it.
 	 */
-	pci_enable_device(dev);
+	err = pci_enable_device(dev);
+	if (err) {
+		printk(KERN_ERR "parport_serial: %s: error enabling "
+			"device for resume (%d)\n", pci_name(dev), err);
+		return err;
+	}
 
 	if (priv->serial)
 		pciserial_resume_ports(priv->serial);
--- linux-2.6.21-rc5-mm4.orig/drivers/serial/8250_pci.c
+++ linux-2.6.21-rc5-mm4/drivers/serial/8250_pci.c
@@ -1820,10 +1820,18 @@ static int pciserial_resume_one(struct p
 	pci_restore_state(dev);
 
 	if (priv) {
+		int err;
+
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		err = pci_enable_device(dev);
+		if (err) {
+			printk(KERN_ERR "8250_pci: %s: error %d "
+				"enabling device for resume\n",
+				pci_name(dev), err);
+			return err;
+		}
 
 		pciserial_resume_ports(priv);
 	}
--- linux-2.6.21-rc5-mm4.orig/drivers/video/s3fb.c
+++ linux-2.6.21-rc5-mm4/drivers/video/s3fb.c
@@ -1061,6 +1061,7 @@ static int s3_pci_resume(struct pci_dev*
 {
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct s3fb_info *par = info->par;
+	int err;
 
 	dev_info(&(dev->dev), "resume\n");
 
@@ -1075,7 +1076,13 @@ static int s3_pci_resume(struct pci_dev*
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
-	pci_enable_device(dev);
+	err = pci_enable_device(dev);
+	if (err) {
+		mutex_unlock(&(par->open_lock));
+		release_console_sem();
+		dev_err(&(dev->dev), "error %d enabling device for resume\n", err);
+		return err;
+	}
 	pci_set_master(dev);
 
 	s3fb_set_par(info);
