Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbYBTAhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbYBTAhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYBTAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:36:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:37109 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbYBTAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tHvTS/xtFDFy9g37UTsJSzD9B99okZYt+w2Tar++j/ps84iKE7Xz/NmTWiXfjdugUSnyJFwMAIGBVmsYSU25UIkpqcT3IdQORaF2BLc6MhipzeCIbjbGJ9isIfn1cMb84E+/pwGBtxf7jdqEp/pRRmXivFiFSMMItD0bEOCb6rg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] bast-ide: fix resources reservation
Date: Wed, 20 Feb 2008 01:47:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Ben Dooks <support@simtec.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200147.15040.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting
  hwif->mmio flag and request resources in bastide_init().

* Use request_mem_region() for resources reservation.

* Use driver name for resources reservation.

Cc: Ben Dooks <support@simtec.co.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -21,6 +21,8 @@
 #include <asm/arch/bast-map.h>
 #include <asm/arch/bast-irq.h>
 
+#define DRV_NAME "bast-ide"
+
 static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 {
 	ide_hwif_t *hwif;
@@ -53,6 +55,7 @@ static int __init bastide_register(unsig
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 	hwif->quirkproc = NULL;
 
 	idx[0] = i;
@@ -64,6 +67,8 @@ out:
 
 static int __init bastide_init(void)
 {
+	unsigned long base = BAST_VA_IDEPRI + BAST_IDE_CS;
+
 	/* we can treat the VR1000 and the BAST the same */
 
 	if (!(machine_is_bast() || machine_is_vr1000()))
@@ -71,6 +76,11 @@ static int __init bastide_init(void)
 
 	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
 
+	if (!request_mem_region(base, 0x400000, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		return -EBUSY;
+	}
+
 	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
 	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
 
