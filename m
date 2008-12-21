Return-Path: <linux-kernel-owner+w=401wt.eu-S1751251AbYLUVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbYLUVBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYLUVAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:00:31 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34166 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYLUVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:00:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ieFx8GtlgAMv8Fg3La7E+pwWn8RfUg3KohPMPva2dV3ahP/Ba7Tdb78l0iJ6ovmr3F
         ehL9A6AWBfsO77h723awza29JuhSlvtDDq16BcYG+gtYLBS+nPfJpQCa50BGbIc1VTpv
         V1/+w4L/bEXifs1/wijKFaRD4gGmURpzPjXOo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 22:00:29 +0100
Message-Id: <20081221210029.23795.66085.sendpatchset@localhost.localdomain>
In-Reply-To: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
References: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/7] it821x: use ide_get_pair_dev() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it821x: use ide_get_pair_dev() helper

Because presence of the peer device was not checked in
it821x_set_pio_mode() PIO0 mode was used for taskfile PIO
in single device configurations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/it821x.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -167,12 +167,10 @@ static void it821x_clock_strategy(ide_dr
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair;
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int clock, altclock, sel = 0;
 	u8 unit = drive->dn & 1, v;
 
-	pair = &hwif->drives[1 - unit];
-
 	if(itdev->want[0][0] > itdev->want[1][0]) {
 		clock = itdev->want[0][1];
 		altclock = itdev->want[1][1];
@@ -239,15 +237,13 @@ static void it821x_set_pio_mode(ide_driv
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	ide_drive_t *pair;
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	u8 unit = drive->dn & 1, set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
 	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
-	pair = &hwif->drives[1 - unit];
-
 	/*
 	 * Compute the best PIO mode we can for a given device. We must
 	 * pick a speed that does not cause problems with the other device
