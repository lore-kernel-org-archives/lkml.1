Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZLTS1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZLTS1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZLTS1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:27:47 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:52738 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZLTS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=YZVTmk92VA0AtzJ5FzT/odm67p//8J1LpcOdMNnCCkifWeA4J8pHS7p+cUtp9QMxBB
         31lHCoVeT5pN/KDgNyLeROUIhZJA9uez0Hv9wMJWO3+2HzCqc3UfC0MlN1CT664fdkXE
         7AO1nPOiqicfpYWxuZM02iLTAG9l7mb3fOokQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_cmd64x: fix overclocking of UDMA0-2 modes
Date: Sun, 20 Dec 2009 19:22:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
MIME-Version: 1.0
Message-Id: <200912201922.33210.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


adev->dma_mode stores the transfer mode value not UDMA mode number
so the condition in cmd64x_set_dmamode() is always true and the higher
UDMA clock is always selected.  This can potentially result in data
corruption when UDMA33 device is used, when 40-wire cable is used or
when the error recovery code decides to lower the device speed down.

The issue was introduced in the commit 6a40da0 ("libata cmd64x: whack
into a shape that looks like the documentation") which goes back to
kernel 2.6.20.

Cc: stable@kernel.org
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
it is patch #116 in my local working queue but I thought it would
be nice to get it upstream ahead of other patches..

 drivers/ata/pata_cmd64x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -254,7 +254,7 @@ static void cmd64x_set_dmamode(struct at
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
 		/* Merge the control bits */
 		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > 2)	/* 15nS timing */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
 			regU |= 4 << adev->devno;
 	} else {
 		regU &= ~ (1 << adev->devno);	/* UDMA off */
