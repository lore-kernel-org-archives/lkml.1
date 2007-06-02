Return-Path: <linux-kernel-owner+w=401wt.eu-S1763110AbXFBS76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763110AbXFBS76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 14:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXFBS7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 14:59:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbXFBS7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 14:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ovMt9+q66RBWbc+Lm500LMFvqmMLoyrFLcKcvGcb7c4uqR1GnNA9LfyR7DJqQk+YkqI/UQp87aGle0ke9H2C7lmdECTOl612ZR8SMgE3DT8n1OZoGFKJIus44H4d3dXmb+R6nn6cKXStYpR9FTnJLLiM0tu2dU2XsL/eGawb/iI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] serverworks: remove crappy code
Date: Sat, 2 Jun 2007 21:05:28 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706022105.28680.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove crappy code noticed by Linus, see

	http://lkml.org/lkml/2007/5/23/476

for details.

While at it simplify logic a bit.

There should be no functionality changes caused by this patch.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/serverworks.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.9	Mar 4 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.10	Jun 2 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -170,7 +170,6 @@ static int svwks_tune_chipset (ide_drive
 		if (!drive->init_speed) {
 			u8 dma_stat = inb(hwif->dma_status);
 
-dma_pio:
 			if (((ultra_enable << (7-drive->dn) & 0x80) == 0x80) &&
 			    ((dma_stat & (1<<(5+unit))) == (1<<(5+unit)))) {
 				drive->current_speed = drive->init_speed = XFER_UDMA_0 + udma_modes[(ultra_timing >> (4*unit)) & ~(0xF0)];
@@ -179,7 +178,6 @@ dma_pio:
 				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
 				u8 dmaspeed = dma_timing;
 
-				dma_timing &= ~0xFFU;
 				if ((dmaspeed & 0x20) == 0x20)
 					dmaspeed = XFER_MW_DMA_2;
 				else if ((dmaspeed & 0x21) == 0x21)
@@ -190,10 +188,11 @@ dma_pio:
 					goto dma_pio;
 				drive->current_speed = drive->init_speed = dmaspeed;
 				return 0;
-			} else if (pio_timing) {
+			}
+dma_pio:
+			if (pio_timing) {
 				u8 piospeed = pio_timing;
 
-				pio_timing &= ~0xFFU;
 				if ((piospeed & 0x20) == 0x20)
 					piospeed = XFER_PIO_4;
 				else if ((piospeed & 0x22) == 0x22)
@@ -214,8 +213,8 @@ dma_pio:
 
 oem_setup_failed:
 
-	pio_timing	&= ~0xFFU;
-	dma_timing	&= ~0xFFU;
+	pio_timing	= 0;
+	dma_timing	= 0;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
