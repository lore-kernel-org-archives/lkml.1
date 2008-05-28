Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYE1Vo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYE1Vo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYE1Vmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49842 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYE1Vmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IKeKVGLTXD/B0JAPSfLmtFZtRqCibsqG9irteV2JZ57fS+LW21TPtZM82tKBMfCLvQ4N2Cq+1bYxgEZAbIAd0qsCX59WiMfk8aI3WPcFdlvsxkpVfXEfh+SIJdBHn/xdC9SvQmp2nEbXspyKBdn3YfAGMcBJAMQdEcSGhHBDlUA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:27 +0200
Message-Id: <20080528214027.16327.95083.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/21] ide: remove XFER_* masks from ide-timing.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Check requested xfer mode against xfer modes instead of XFER_* masks
  in ide_timing_compute() and cs5535.c::cs5535_set_speed().

* Remove XFER_[MODE,MWDMA,EPIO,PIO] masks.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timing.h |   24 +++++++-----------------
 drivers/ide/pci/cs5535.c |    4 +---
 2 files changed, 8 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -70,11 +70,6 @@ static struct ide_timing ide_timing[] = 
 #define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
-#define XFER_MODE	0xf0
-#define XFER_MWDMA	0x20
-#define XFER_EPIO	0x01
-#define XFER_PIO	0x00
-
 static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q, int T, int UT)
 {
 	q->setup   = EZ(t->setup   * 1000,  T);
@@ -137,17 +132,12 @@ static int ide_timing_compute(ide_drive_
 
 		memset(&p, 0, sizeof(p));
 
-		switch (speed & XFER_MODE) {
-
-			case XFER_PIO:
-				if (speed <= XFER_PIO_2) p.cycle = p.cyc8b = id->eide_pio;
-						    else p.cycle = p.cyc8b = id->eide_pio_iordy;
-				break;
-
-			case XFER_MWDMA:
-				p.cycle = id->eide_dma_min;
-				break;
-		}
+		if (speed <= XFER_PIO_2)
+			p.cycle = p.cyc8b = id->eide_pio;
+		else if (speed <= XFER_PIO_5)
+			p.cycle = p.cyc8b = id->eide_pio_iordy;
+		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+			p.cycle = id->eide_dma_min;
 
 		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
 	}
@@ -164,7 +154,7 @@ static int ide_timing_compute(ide_drive_
  * slower/equal than the fastest PIO timing.
  */
 
-	if ((speed & XFER_MODE) != XFER_PIO) {
+	if (speed >= XFER_SW_DMA_0) {
 		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
 		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
 		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -75,13 +75,11 @@ static unsigned int cs5535_udma_timings[
  */
 static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 {
-
 	u32 reg = 0, dummy;
 	int unit = drive->select.b.unit;
 
-
 	/* Set the PIO timings */
-	if ((speed & XFER_MODE) == XFER_PIO) {
+	if (speed < XFER_SW_DMA_0) {
 		ide_drive_t *pair = ide_get_paired_drive(drive);
 		u8 cmd, pioa;
 
