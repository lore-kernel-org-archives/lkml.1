Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXLTBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXLTBgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXLTBeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXLTBeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TiNa3M+fXaM7pzXXRWx/tGugqf2OuKadYfDVPRDJ1iyopr5DAFKFt0A4wyCSnJajRgv4r00A6CRzcqHdQMpsq+RKGJVjJnypsjs2u/FvrG5aoRAwJg4Y2O+SFbykRb1jqewTTdIKTuL3cEm6TS5UBiG/pVdx/86+/cnnJJ1y+mM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 06/63] ide-cd: fix error messages in cdrom_write_intr()
Date: Thu, 20 Dec 2007 01:56:13 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200156.13518.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1799,8 +1799,9 @@ static ide_startstop_t cdrom_write_intr(
 	/* Check for errors. */
 	if (dma) {
 		info->dma = 0;
-		if ((dma_error = HWIF(drive)->ide_dma_end(drive))) {
-			printk(KERN_ERR "ide-cd: write dma error\n");
+		dma_error = HWIF(drive)->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA write error\n", drive->name);
 			ide_dma_off(drive);
 		}
 	}
@@ -1833,8 +1834,9 @@ static ide_startstop_t cdrom_write_intr(
 		 */
 		uptodate = 1;
 		if (rq->current_nr_sectors > 0) {
-			printk(KERN_ERR "%s: write_intr: data underrun (%d blocks)\n",
-			drive->name, rq->current_nr_sectors);
+			printk(KERN_ERR "%s: %s: data underrun (%d blocks)\n",
+					drive->name, __FUNCTION__,
+					rq->current_nr_sectors);
 			uptodate = 0;
 		}
 		cdrom_end_request(drive, uptodate);
@@ -1854,7 +1856,8 @@ static ide_startstop_t cdrom_write_intr(
 		int this_transfer;
 
 		if (!rq->current_nr_sectors) {
-			printk(KERN_ERR "ide-cd: write_intr: oops\n");
+			printk(KERN_ERR "%s: %s: confused, missing data\n",
+					drive->name, __FUNCTION__);
 			break;
 		}
 
