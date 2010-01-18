Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0ARRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0ARRPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723Ab0ARRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:15:16 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63659 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0ARRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Cc+gtXtviYAQGwHuTEHq/M0oahtVSenFBBQZ2Mwmnerqgeqf/A0U6+KTch5ui/lBGc
         VBHPqC5B7A0bTfPAVlq3QeKDGRvQgQ2YZ8VBPnqxz7ITdWkzE2iaFIpsfLD5th1TtZMF
         LMVMCEPVb+Tq1rJy+7ng9Ch3Ahn7urKxYA3Ys=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:13:57 +0100
Message-Id: <20100118171357.14623.36435.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 01/64] libata: fix CFA handling in ide_timing_compute()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: fix CFA handling in ide_timing_compute()

Use standard cycle timing for CFA PIO5 and PIO6 modes.

Based on commit 74638c8 for IDE subsystem.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3211,6 +3211,7 @@ const struct ata_timing *ata_timing_find
 int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 		       struct ata_timing *t, int T, int UT)
 {
+	const u16 *id = adev->id;
 	const struct ata_timing *s;
 	struct ata_timing p;
 
@@ -3228,14 +3229,18 @@ int ata_timing_compute(struct ata_device
 	 * PIO/MW_DMA cycle timing.
 	 */
 
-	if (adev->id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
+	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
+
 		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
-			if (speed <= XFER_PIO_2) p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO];
-					    else p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO_IORDY];
-		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2) {
-			p.cycle = adev->id[ATA_ID_EIDE_DMA_MIN];
-		}
+			if (speed <= XFER_PIO_2)
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
+			else if ((speed <= XFER_PIO_4) ||
+				 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
+		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
+
 		ata_timing_merge(&p, t, t, ATA_TIMING_CYCLE | ATA_TIMING_CYC8B);
 	}
 
