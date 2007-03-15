Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXCOUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXCOUpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXCOUpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:45:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:29584 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbXCOUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kuoYQLtnihBylTouRcHfX1pHrEOpTQg/YeK1FhvKHHhfAUV++h9kmXV9+bNeU1v8rhpvMp6bS6f0AviQ638hQ/ptWEWO8WyZRUbtOcJCNGKD1s5TerlR3WDiqnNUfQztLZicqnyJPP0hWzViOcuZNhe6p/shtH4fxQelhzsP/hY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n
Date: Thu, 15 Mar 2007 21:45:40 +0100
User-Agent: KMail/1.9.6
Cc: Patrick Horn <phrh@yahoo.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152145.40644.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n

For CONFIG_IDEDMA_{ICS,PCI}_AUTO=n and/or "ide=nodma" option the host/device
are not programmed for DMA and it is also explicitly disabled by ide_set_dma()
(->ide_dma_check returns "-1").  However the code responsible for manually
enabling DMA ("hdparm -d 1") has a bug which results in DMA being erroneously
enabled - ide_set_dma() incorrectly passes "0" return value to set_using_dma().
This may work if BIOS/firmware configured the host/device for DMA and chipset
allows independent configuration of DMA/PIO modes but won't work after suspend
and is generally unsafe on many chipsets (possibly including data corruption
if the same registers are used for DMA/PIO timings).

This patch fixes kernel bugzilla bug #8169 (piix host driver fixes for
setting PIO mode exposed the problem described above).  The side-effect of
the fix is that some rare configuration may be forced to PIO mode when DMA
mode was previously used - this is addressed by the next patch which removes
CONFIG_IDEDMA_{PCI,ICS}_AUTO config option completely.

Thanks goes out to Patrick Horn for reporting the issue, narrowing it down
to the specific commit and testing the fix.  Also thanks to Sergei Shtylyov
for help in debugging the problem.

Cc: Patrick Horn <phrh@yahoo.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ide/ide-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -767,7 +767,7 @@ int ide_set_dma(ide_drive_t *drive)
 	switch(rc) {
 	case -1: /* DMA needs to be disabled */
 		hwif->dma_off_quietly(drive);
-		return 0;
+		return -1;
 	case  0: /* DMA needs to be enabled */
 		return hwif->ide_dma_on(drive);
 	case  1: /* DMA setting cannot be changed */
