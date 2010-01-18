Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598Ab0ARRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0ARRYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468Ab0ARRYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:24:44 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0ARRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=j6/kGqknO4+LodH6RRWPbxdhFMPffoBkhWAtz8G7sj9kuLs9O2b/WpQuJ56rHtA3oI
         FKIa0PHAF7FWIV9Vq0g9ktmodqW2PfqCZw9rR/9BPJ7ZVQQW2XfX8AbFf3QO0tRwXaGH
         bGjltaIKJbrLyz43zbx8/Sx1q/FFJtEuRMh+k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:41 +0100
Message-Id: <20100118172141.14623.95484.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 56/64] cmd64x: fix handling of address setup timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd64x: fix handling of address setup timings

Account for the requirements of the DMA mode currently used.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd64x.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -87,9 +87,6 @@ static void cmd64x_program_timings(ide_d
 	pci_write_config_byte(dev, drwtim_regs[drive->dn],
 			      (t.active << 4) | t.recover);
 
-	if (mode >= XFER_SW_DMA_0)
-		return;
-
 	/*
 	 * The primary channel has individual address setup timing registers
 	 * for each drive and the hardware selects the slowest timing itself.
@@ -99,11 +96,17 @@ static void cmd64x_program_timings(ide_d
 	if (hwif->channel) {
 		ide_drive_t *pair = ide_get_pair_dev(drive);
 
-		ide_set_drivedata(drive, (void *)(unsigned long)t.setup);
+		if (pair) {
+			struct ide_timing tp;
 
-		if (pair)
-			t.setup = max_t(u8, t.setup,
-					(unsigned long)ide_get_drivedata(pair));
+			ide_timing_compute(pair, pair->pio_mode, &tp, T, 0);
+			ide_timing_merge(&t, &tp, &t, IDE_TIMING_SETUP);
+			if (pair->dma_mode) {
+				ide_timing_compute(pair, pair->dma_mode,
+						&tp, T, 0);
+				ide_timing_merge(&tp, &t, &t, IDE_TIMING_SETUP);
+			}
+		}
 	}
 
 	if (t.setup > 5)		/* shouldn't actually happen... */
