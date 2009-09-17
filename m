Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZIQXCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZIQXCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZIQXCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:02:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZIQXCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:02:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:from:date:message-id:subject:to:cc:
	content-type:x-system-of-record;
	b=QB8kxuSHPa1ukT7XEdmHHO0C6zTpbRsoCdmq9p9hkO6/8LWB0JsCgQccv77x+FMs3
	QfGnM5a7BqkFL2W2JCffA==
MIME-Version: 1.0
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Thu, 17 Sep 2009 16:02:31 -0700
Message-ID: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com>
Subject: [PATCH] libata:ide: Fix udma timings of pdc202xx_old controllers
To: sshtylyov@ru.mvista.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John(Jung-Ik) Lee <jilee@google.com>

Fix udma timings of pdc202xx_old controllers.
MB=1, MC=1 (0x20, 0x01) for all UDMA modes of pdc2026{57}.

Signed-off-by: John(Jung-Ik) Lee <jilee@google.com>
---

 drivers/ata/pata_pdc202xx_old.c |   15 +++------------
 drivers/ide/pdc202xx_old.c      |    8 +++++---
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 2f3c9be..ae76a9e 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -97,14 +97,6 @@ static void pdc202xx_set_dmamode(struct ata_port
*ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
-	static u8 udma_timing[6][2] = {
-		{ 0x60, 0x03 },	/* 33 Mhz Clock */
-		{ 0x40, 0x02 },
-		{ 0x20, 0x01 },
-		{ 0x40, 0x02 },	/* 66 Mhz Clock */
-		{ 0x20, 0x01 },
-		{ 0x20, 0x01 }
-	};
 	static u8 mdma_timing[3][2] = {
 		{ 0xe0, 0x0f },
 		{ 0x60, 0x04 },
@@ -119,10 +111,9 @@ static void pdc202xx_set_dmamode(struct ata_port
*ap, struct ata_device *adev)
 	r_cp &= ~0x0F;

 	if (adev->dma_mode >= XFER_UDMA_0) {
-		int speed = adev->dma_mode - XFER_UDMA_0;
-		r_bp |= udma_timing[speed][0];
-		r_cp |= udma_timing[speed][1];
-
+		/* MB=1, MC=1 for all UDMA modes of pdc2026{57} */
+		r_bp |= 0x20;
+		r_cp |= 0x01;
 	} else {
 		int speed = adev->dma_mode - XFER_MW_DMA_0;
 		r_bp |= mdma_timing[speed][0];
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index cb812f3..95c58dd 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -51,11 +51,13 @@ static void pdc202xx_set_mode(ide_drive_t *drive,
const u8 speed)

 	switch(speed) {
 		case XFER_UDMA_5:
-		case XFER_UDMA_4:	TB = 0x20; TC = 0x01; break;
-		case XFER_UDMA_2:	TB = 0x20; TC = 0x01; break;
+		case XFER_UDMA_4:
 		case XFER_UDMA_3:
-		case XFER_UDMA_1:	TB = 0x40; TC = 0x02; break;
+		case XFER_UDMA_2:
+		case XFER_UDMA_1:
 		case XFER_UDMA_0:
+		/* MB=1, MC=1 for all UDMA modes of pdc2026{57} */
+					TB = 0x20; TC = 0x01; break;
 		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
 		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
 		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;
