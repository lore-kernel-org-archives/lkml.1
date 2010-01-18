Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448Ab0ARRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0ARRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373Ab0ARRWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:38 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab0ARRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=umSRutKfHmZ2P1uzbdrRDwHhemZlx1dNNN+MXxb/8mDCSldUnawkvSeDqB4cK8xWkk
         m3r906dNaQNYjkgl6z/vNjAEitzM/Fk5oCbhZ++6X7XVkTtU+g0Ubf/Rg8OSr4RvFap+
         WdhJ821ts8OWstnWahkyqX+g4iuhBn4tT+UQ0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:12 +0100
Message-Id: <20100118172112.14623.45532.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 52/64] alim15x3: fix handling of command timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: fix handling of command timings

Stop depending on the BIOS setup.

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -84,14 +84,18 @@ static void ali_set_pio_mode(ide_hwif_t
 		struct ide_timing p;
 
 		ide_timing_compute(pair, pair->pio_mode, &p, T, 1);
-		ide_timing_merge(&p, &t, &t, IDE_TIMING_SETUP);
+		ide_timing_merge(&p, &t, &t,
+			IDE_TIMING_SETUP | IDE_TIMING_8BIT);
 		if (pair->dma_mode) {
 			ide_timing_compute(pair, pair->dma_mode, &p, T, 1);
-			ide_timing_merge(&p, &t, &t, IDE_TIMING_SETUP);
+			ide_timing_merge(&p, &t, &t,
+				IDE_TIMING_SETUP | IDE_TIMING_8BIT);
 		}
 	}
 
 	t.setup = clamp_val(t.setup, 1, 8) & 7;
+	t.act8b = clamp_val(t.act8b, 1, 8) & 7;
+	t.rec8b = clamp_val(t.rec8b, 1, 16) & 15;
 	t.active = clamp_val(t.active, 1, 8) & 7;
 	t.recover = clamp_val(t.recover, 1, 16) & 15;
 
@@ -101,6 +105,7 @@ static void ali_set_pio_mode(ide_hwif_t
 	ali_fifo_control(hwif, drive, (drive->media == ide_disk) ? 0x05 : 0x00);
 
 	pci_write_config_byte(dev, port, t.setup);
+	pci_write_config_byte(dev, port + 1, (t.act8b << 4) | t.rec8b);
 	pci_write_config_byte(dev, port + unit + 2,
 			      (t.active << 4) | t.recover);
 }
