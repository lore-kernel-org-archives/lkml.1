Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbXLTBtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbXLTBtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbXLTBez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbXLTBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MDKqiSYs/sJEu01/t6TrIFXEA9c3Aoc6YvrGRoxwHhI+OM/iGJkoUjR9MEIDDjlwwIqYFKjppNi1OuIov4mA4IIPSunUUK5WDATIbq+GYCrjjskgAkH1LmuDM0GJeW6eJvSlKda+vW85c5ljd1v7B0Lsj1VMcPP6VSVZrT5SmXo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 12/63] ide-cd: fix "missing data" handling in cdrom_pc_intr()
Date: Thu, 20 Dec 2007 02:01:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200201.31860.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If drive still wants to transfer the data we need to pad the transfer
instead of just finishing the request.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1500,9 +1500,11 @@ static ide_startstop_t cdrom_pc_intr (id
 
 	if (xferfunc) {
 		if (!rq->data) {
+			printk(KERN_ERR "%s: confused, missing data\n",
+					drive->name);
 			blk_dump_rq_flags(rq, write ? "cdrom_pc_intr, write"
 						    : "cdrom_pc_intr, read");
-			goto confused;
+			goto pad;
 		}
 		/* Transfer the data. */
 		xferfunc(drive, rq->data, thislen);
@@ -1515,7 +1517,6 @@ static ide_startstop_t cdrom_pc_intr (id
 		if (write && blk_sense_request(rq))
 			rq->sense_len += thislen;
 	} else {
-confused:
 		printk (KERN_ERR "%s: cdrom_pc_intr: The drive "
 			"appears confused (ireason = 0x%02x). "
 			"Trying to recover by ending request.\n",
@@ -1524,7 +1525,7 @@ confused:
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
 	}
-
+pad:
 	/*
 	 * If we haven't moved enough data to satisfy the drive,
 	 * add some padding.
