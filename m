Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYDISji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYDISji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYDISip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:38:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:62571 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYDISic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=F/fR+a7KaMiFgobSOFnIr3ZTnnS/zFHKmYG0xjLixvgfA9bKO9neauTk1Qc4KqAdLq4zRG4IujWTeBAPVZPOA7hZ52+VO/7Yhm8lccH20lWLgEcDPpXqUc83s7t0hLVXBGlytR0THZeFGVRoSd4fCUECgf3k03Ruh5zmTrMJT9g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] siimage: remove proc_reports_siimage()
Date: Wed, 9 Apr 2008 20:52:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092052.41806.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* proc_reports_siimage() is now only called by init_chipset_siimage()
  so inline it there.

* Use array instead of switch statement for reporting clock modes.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -440,30 +440,6 @@ static void sil_sata_pre_reset(ide_drive
 }
 
 /**
- *	proc_reports_siimage		-	add siimage controller to proc
- *	@dev: PCI device
- *	@clocking: SCSC value
- *	@name: controller name
- *
- *	Report the clocking mode of the controller and add it to
- *	the /proc interface layer
- */
- 
-static void proc_reports_siimage (struct pci_dev *dev, u8 clocking, const char *name)
-{
-	if (!pdev_is_sata(dev)) {
-		printk(KERN_INFO "%s: BASE CLOCK ", name);
-		clocking &= 0x03;
-		switch (clocking) {
-			case 0x03: printk("DISABLED!\n"); break;
-			case 0x02: printk("== 2X PCI\n"); break;
-			case 0x01: printk("== 133\n"); break;
-			case 0x00: printk("== 100\n"); break;
-		}
-	}
-}
-
-/**
  *	setup_mmio_siimage	-	switch an SI controller into MMIO
  *	@dev: PCI device we are configuring
  *	@name: device name
@@ -585,7 +561,14 @@ static unsigned int __devinit init_chips
 		writel(0x00680000, ioaddr + 0x1C8);
 	}
 
-	proc_reports_siimage(dev, tmp >> 4, name);
+	/* report the clocking mode of the controller */
+	if (!pdev_is_sata(dev)) {
+		static const char *clk_str[] =
+			{ "== 100", "== 133", "== 2X PCI", "DISABLED!" };
+
+		tmp >>= 4;
+		printk(KERN_INFO "%s: BASE CLOCK %s\n", name, clk_str[tmp & 3]);
+	}
 
 	return 0;
 }
