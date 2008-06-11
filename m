Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYFKU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYFKU1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYFKU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:60506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYFKU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=ca6K8IOPY0zZy3UtfZ/eEhgIlfwo31YKYRrOM6RhAx+flVaNq73ObVItmoSRrSgEXi
         k3Ek3znfPYXgaFku6ZLgdkI8bhY/AwIag6pfHpGWgKFrxGKlAsKH6ZJlJkpAdbR+AF5I
         KXrmDOQgS6VRHSpNw0+4WIYGWl+vwq2dfoTYc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] sgiioc4: call ide_find_port_slot() later
Date: Wed, 11 Jun 2008 21:22:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806112122.45788.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ide_find_port_slot() call closer to ide_device_add().

This is basically a preparation for the future changes.

Cc: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -588,10 +588,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
-	hwif = ide_find_port_slot(&d);
-	if (hwif == NULL)
-		return -ENOMEM;
-
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
 	virt_base = ioremap(bar0, pci_resource_len(dev, 0));
@@ -621,6 +617,11 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
+
+	hwif = ide_find_port_slot(&d);
+	if (hwif == NULL)
+		goto err;
+
 	ide_init_port_hw(hwif, &hw);
 
 	/* The IOC4 uses MMIO rather than Port IO. */
@@ -637,6 +638,10 @@ sgiioc4_ide_setup_pci_device(struct pci_
 		return -EIO;
 
 	return 0;
+err:
+	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
+	iounmap(virt_base);
+	return -ENOMEM;
 }
 
 static unsigned int __devinit
