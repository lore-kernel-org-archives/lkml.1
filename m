Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZLNWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZLNWLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbZLNWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:11:47 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:45094 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbZLNWLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:11:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] tmio_nand.c: use dev_get_platdata() and resource_size()
Date: Mon, 14 Dec 2009 17:11:44 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA6E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tmio_nand.c: use dev_get_platdata() and resource_size()
Thread-Index: Acp9CmuovGHMhO8NTCqlSFdXrMMVSQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 22:11:42.0281 (UTC) FILETIME=[6A770390:01CA7D0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary casts and use dev_get_platdata() to retrieve the
struct mfd_cell data from the platform.

Use resource_size() for the ioremap()'s.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 92c7334..65fa469 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -318,7 +318,7 @@ static int tmio_nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
 
 static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 {
-	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell *cell = dev_get_platdata(&dev->dev);
 	int ret;
 
 	if (cell->enable) {
@@ -362,7 +362,7 @@ static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 
 static void tmio_hw_stop(struct platform_device *dev, struct tmio_nand *tmio)
 {
-	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell *cell = dev_get_platdata(&dev->dev);
 
 	tmio_iowrite8(FCR_MODE_POWER_OFF, tmio->fcr + FCR_MODE);
 	if (cell->disable)
@@ -371,7 +371,7 @@ static void tmio_hw_stop(struct platform_device *dev, struct tmio_nand *tmio)
 
 static int tmio_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell *cell = dev_get_platdata(&dev->dev);
 	struct tmio_nand_data *data = cell->driver_data;
 	struct resource *fcr = platform_get_resource(dev,
 			IORESOURCE_MEM, 0);
@@ -404,14 +404,14 @@ static int tmio_probe(struct platform_device *dev)
 	mtd->priv = nand_chip;
 	mtd->name = "tmio-nand";
 
-	tmio->ccr = ioremap(ccr->start, ccr->end - ccr->start + 1);
+	tmio->ccr = ioremap(ccr->start, resource_size(ccr));
 	if (!tmio->ccr) {
 		retval = -EIO;
 		goto err_iomap_ccr;
 	}
 
 	tmio->fcr_base = fcr->start & 0xfffff;
-	tmio->fcr = ioremap(fcr->start, fcr->end - fcr->start + 1);
+	tmio->fcr = ioremap(fcr->start, resource_size(fcr));
 	if (!tmio->fcr) {
 		retval = -EIO;
 		goto err_iomap_fcr;
@@ -515,7 +515,7 @@ static int tmio_remove(struct platform_device *dev)
 #ifdef CONFIG_PM
 static int tmio_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell *cell = dev_get_platdata(&dev->dev);
 
 	if (cell->suspend)
 		cell->suspend(dev);
@@ -526,7 +526,7 @@ static int tmio_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tmio_resume(struct platform_device *dev)
 {
-	struct mfd_cell *cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell *cell = dev_get_platdata(&dev->dev);
 
 	/* FIXME - is this required or merely another attack of the broken
 	 * SHARP platform? Looks suspicious. 
