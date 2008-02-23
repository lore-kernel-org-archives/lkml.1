Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbYBWUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbYBWUE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbYBWUEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:04:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:17682 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762851AbYBWUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KT4RoUXyMyQ/lxjxujHUsqKNxQB54CWcuGdGvuTf8/9bc6pQScqtG4nJEvsNYw8XR/mWUMgf/sRGPC3pNMy1sEZ3tFCPL1q7mPmHhDdbLsPTzCiSEhdO3ikQ3kiGkGGqkPvIIhXYcpcTE21BsY3mhoPmlLidjxGxyIfiv/pMPFI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] it821x: fix kzalloc() failure handling
Date: Sat, 23 Feb 2008 21:13:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232113.28150.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate 'struct it821x_dev' objects for both ports in it821x_init_one().

Fixes potential OOPS in it821x_quirkproc() (uses 'itdev' unconditionally)
and other problems ('itdev' is needed for correct operation of the driver).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it821x.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -523,16 +523,12 @@ static void __devinit it821x_quirkproc(i
 static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct it821x_dev *idev = kzalloc(sizeof(struct it821x_dev), GFP_KERNEL);
+	struct it821x_dev **itdevs = (struct it821x_dev **)pci_get_drvdata(dev);
+	struct it821x_dev *idev = itdevs[hwif->channel];
 	u8 conf;
 
 	hwif->quirkproc = &it821x_quirkproc;
 
-	if (idev == NULL) {
-		printk(KERN_ERR "it821x: out of memory, falling back to legacy behaviour.\n");
-		return;
-	}
-
 	ide_set_hwifdata(hwif, idev);
 
 	pci_read_config_byte(dev, 0x50, &conf);
@@ -641,6 +637,22 @@ static const struct ide_port_info it821x
 
 static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	struct it821x_dev *itdevs[2] = { NULL, NULL} , *itdev;
+	unsigned int i;
+
+	for (i = 0; i < 2; i++) {
+		itdev = kzalloc(sizeof(*itdev), GFP_KERNEL);
+		if (itdev == NULL) {
+			kfree(itdevs[0]);
+			printk(KERN_ERR "it821x: out of memory\n");
+			return -ENOMEM;
+		}
+
+		itdevs[i] = itdev;
+	}
+
+	pci_set_drvdata(dev, itdevs);
+
 	return ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
 }
 
