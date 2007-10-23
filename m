Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXJWVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXJWVb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXJWVbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:31:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:20398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXJWVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=n8+Coop136zvQQFi0dpsAPU7N4RhLXHogYXHCO7qPJS0dIfu6pglBYzqjft4wVscolUibZngIuYfKX+wMdvzliYbc8wh5fwrREw5J56QiGo1PbbKbSbSym8g8DY/rtZjCmDzw/tUiEOPl910JEtm7NoO8wFZK/Jh1zpnxYriCCg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] hpt366: fix build for CONFIG_HOTPLUG=n
Date: Tue, 23 Oct 2007 22:59:00 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "Avuton Olrich" <avuton@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710232259.00414.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 20 October 2007, Avuton Olrich wrote:

> My randconfig script the attached config caught an error on:
> drivers/ide/pci/cy82c693.c:439: error: primary causes a section type conflict
>
> My git tree: c00046c279a2521075250fad682ca0acc10d4fd7
>
> Bisected to:
> 8562043606430185cad26d085d46adcc7ad67fd1 is first bad commit
> commit 8562043606430185cad26d085d46adcc7ad67fd1
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Sat Oct 20 00:32:34 2007 +0200
>
>     ide: constify struct ide_port_info
>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

It turns out that const and __{dev}initdata cannot be mixed currently
and that hpt366 host driver is also affected by the same issue:

> drivers/ide/pci/hpt366.c:1428: error: hpt366_chipsets causes a section type
> conflict

This patch workarounds the problem by making static struct hpt_info instances
const.  Now all __devinitdata data in hpt366 host driver are read-only so it
builds again (driver's .init.data section gets marked as READONLY).

While at it:

* Bump driver version.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: "Avuton Olrich" <avuton@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/hpt366.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.20	Oct 1, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.21	Oct 23, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -433,7 +433,7 @@ static u32 *hpt37x_settings[NUM_ATA_CLOC
 	sixty_six_base_hpt37x
 };
 
-static struct hpt_info hpt36x __devinitdata = {
+static const struct hpt_info hpt36x __devinitdata = {
 	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
@@ -441,7 +441,7 @@ static struct hpt_info hpt36x __devinitd
 	.settings	= hpt36x_settings
 };
 
-static struct hpt_info hpt370 __devinitdata = {
+static const struct hpt_info hpt370 __devinitdata = {
 	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -449,7 +449,7 @@ static struct hpt_info hpt370 __devinitd
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt370a __devinitdata = {
+static const struct hpt_info hpt370a __devinitdata = {
 	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -457,7 +457,7 @@ static struct hpt_info hpt370a __devinit
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt374 __devinitdata = {
+static const struct hpt_info hpt374 __devinitdata = {
 	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
@@ -465,7 +465,7 @@ static struct hpt_info hpt374 __devinitd
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372 __devinitdata = {
+static const struct hpt_info hpt372 __devinitdata = {
 	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -473,7 +473,7 @@ static struct hpt_info hpt372 __devinitd
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372a __devinitdata = {
+static const struct hpt_info hpt372a __devinitdata = {
 	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -481,7 +481,7 @@ static struct hpt_info hpt372a __devinit
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt302 __devinitdata = {
+static const struct hpt_info hpt302 __devinitdata = {
 	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -489,7 +489,7 @@ static struct hpt_info hpt302 __devinitd
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt371 __devinitdata = {
+static const struct hpt_info hpt371 __devinitdata = {
 	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -497,7 +497,7 @@ static struct hpt_info hpt371 __devinitd
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372n __devinitdata = {
+static const struct hpt_info hpt372n __devinitdata = {
 	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -505,7 +505,7 @@ static struct hpt_info hpt372n __devinit
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt302n __devinitdata = {
+static const struct hpt_info hpt302n __devinitdata = {
 	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -513,7 +513,7 @@ static struct hpt_info hpt302n __devinit
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt371n __devinitdata = {
+static const struct hpt_info hpt371n __devinitdata = {
 	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -1508,7 +1508,7 @@ static const struct ide_port_info hpt366
  */
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct hpt_info *info = NULL;
+	const struct hpt_info *info = NULL;
 	struct pci_dev *dev2 = NULL;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
@@ -1522,7 +1522,7 @@ static int __devinit hpt366_init_one(str
 		if (rev < 3)
 			info = &hpt36x;
 		else {
-			static struct hpt_info *hpt37x_info[] =
+			static const struct hpt_info *hpt37x_info[] =
 				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
 
 			info = hpt37x_info[min_t(u8, rev, 6) - 3];
@@ -1552,7 +1552,7 @@ static int __devinit hpt366_init_one(str
 	d.name = info->chip_name;
 	d.udma_mask = info->udma_mask;
 
-	pci_set_drvdata(dev, info);
+	pci_set_drvdata(dev, (void *)info);
 
 	if (info == &hpt36x || info == &hpt374)
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
@@ -1560,7 +1560,7 @@ static int __devinit hpt366_init_one(str
 	if (dev2) {
 		int ret;
 
-		pci_set_drvdata(dev2, info);
+		pci_set_drvdata(dev2, (void *)info);
 
 		if (info == &hpt374)
 			hpt374_init(dev, dev2);
