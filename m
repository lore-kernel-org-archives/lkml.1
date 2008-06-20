Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYFTS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYFTS17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYFTS1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:27:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:17187 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYFTS1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Z5kgbJmPu4y7v68ZU5pFRYQmp5vB+IU64H1QyE8xj6H4KtC8GVXsjKNQ9aCyDqWNeo
         7otrIIPDiclQAc6w9Zj8CoBeCaK7ya0+iH963iT2OkFbsG9EAvFgB0l1Cz0xzYc9LTb1
         4X9fJc5o7ytZ1VvSkICSi/Op1RNIsY9WoQhDA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: move ide_pci_setup_ports() call out from do_ide_setup_pci_device()
Date: Fri, 20 Jun 2008 20:27:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806202027.14924.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move ide_pci_setup_ports() call out from do_ide_setup_pci_device()
  to ide_setup_pci_device[s]().

* Drop no longer needed idx argument from do_ide_setup_pci_device().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against IDE tree + the recent ide-pmac patches

 drivers/ide/setup-pci.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -479,7 +479,7 @@ EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
  */
 static int do_ide_setup_pci_device(struct pci_dev *dev,
 				   const struct ide_port_info *d,
-				   u8 *idx, u8 noisy)
+				   u8 noisy)
 {
 	int tried_config = 0;
 	int pciirq, ret;
@@ -528,9 +528,7 @@ static int do_ide_setup_pci_device(struc
 				d->name, pciirq);
 	}
 
-	/* FIXME: silent failure can happen */
-
-	ide_pci_setup_ports(dev, d, pciirq, idx);
+	ret = pciirq;
 out:
 	return ret;
 }
@@ -540,10 +538,14 @@ int ide_setup_pci_device(struct pci_dev 
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int ret;
 
-	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
+	ret = do_ide_setup_pci_device(dev, d, 1);
+
+	if (ret >= 0) {
+		/* FIXME: silent failure can happen */
+		ide_pci_setup_ports(dev, d, ret, &idx[0]);
 
-	if (ret >= 0)
 		ide_device_add(idx, d);
+	}
 
 	return ret;
 }
@@ -557,13 +559,17 @@ int ide_setup_pci_devices(struct pci_dev
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	for (i = 0; i < 2; i++) {
-		ret = do_ide_setup_pci_device(pdev[i], d, &idx[i*2], !i);
+		ret = do_ide_setup_pci_device(pdev[i], d, !i);
+
 		/*
 		 * FIXME: Mom, mom, they stole me the helper function to undo
 		 * do_ide_setup_pci_device() on the first device!
 		 */
 		if (ret < 0)
 			goto out;
+
+		/* FIXME: silent failure can happen */
+		ide_pci_setup_ports(pdev[i], d, ret, &idx[i*2]);
 	}
 
 	ide_device_add(idx, d);
