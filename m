Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbYF3Pay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbYF3Pay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYF3P14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:56 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60348 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753244AbYF3P1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:51 -0400
Message-Id: <20080630152750.578945866@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:26:04 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 17/17] MMC: S3C24XX:
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-check-unaligned.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware does not support any multi-block transfers
with an block-size that is not aligned. Also the driver
itself does not support single block non-32bit transfers
either.

Ensure that the s3cmci_setup_data() returns the appropriate
error if we encounter this.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:38:22.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:38:46.000000000 +0100
@@ -808,6 +808,17 @@ static int s3cmci_setup_data(struct s3cm
 		return 0;
 	}
 
+	if ((data->blksz & 3) != 0) {
+		/* We cannot deal with unaligned blocks with more than
+		 * one block being transfered. */
+
+		if (data->blocks > 1)
+			return -EINVAL;
+
+		/* No support yet for non-word block transfers. */
+		return -EINVAL;
+	}
+
 	while (readl(host->base + S3C2410_SDIDSTA) &
 	       (S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
