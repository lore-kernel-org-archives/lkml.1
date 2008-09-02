Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbYIBSeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbYIBSeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYIBSd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:33:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:12565 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYIBSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ZhVl7UMATOSMp80+Ow/+yJBpBGa8rwrkYJf0kI284Yijz/fxA2HWgJfh84oY+g5wV/
         +AYQoSPdPAbsuSRbHNVLNdP1mFU/4Y0q1mv7UqAq/lT8VZm42Tyao8I4Ka5aEnpnhxc+
         tOu3+Rve1fzqtZzyT2Lt5ggzzla0uaLFkXDs0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] pmac: remove needless pmac_ide_destroy_dmatable() wrapper
Date: Tue, 2 Sep 2008 20:31:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809022031.22922.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwif->sg_nents is always != 0 when this function is called
and there is also no need to explicitely zero hwif->sg_nents.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1523,18 +1523,6 @@ use_pio_instead:
 	return 0; /* revert to PIO for this request */
 }
 
-/* Teardown mappings after DMA has completed.  */
-static void
-pmac_ide_destroy_dmatable (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if (hwif->sg_nents) {
-		ide_destroy_dmatable(drive);
-		hwif->sg_nents = 0;
-	}
-}
-
 /*
  * Prepare a DMA transfer. We build the DMA table, adjust the timings for
  * a read on KeyLargo ATA/66 and mark us as waiting for DMA completion
@@ -1606,7 +1594,9 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	drive->waiting_for_dma = 0;
 	dstat = readl(&dma->status);
 	writel(((RUN|WAKE|DEAD) << 16), &dma->control);
-	pmac_ide_destroy_dmatable(drive);
+
+	ide_destroy_dmatable(drive);
+
 	/* verify good dma status. we don't check for ACTIVE beeing 0. We should...
 	 * in theory, but with ATAPI decices doing buffer underruns, that would
 	 * cause us to disable DMA, which isn't what we want
