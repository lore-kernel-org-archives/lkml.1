Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433Ab0ARRWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0ARRWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418Ab0ARRW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:27 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0ARRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=g/9FmGQDtZwx71EHgoNmK+ak+pk9rlU2sZEAv2tEH0PCHLTsEY34T1geN9F5SVmyLF
         Mfl7pokVTqsnNyrJhfxzaEta3FDQw9BSnsbxLfUBTu8YZCPGHaXnHO1OD3Ri1cm95G5M
         82aHQerJL3NhLbyjB3p3V0LR14XgvtsmNVzUA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:05 +0100
Message-Id: <20100118172105.14623.5133.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 51/64] alim15x3: fix handling of address setup timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: fix handling of address setup timings

Account for the requirements of the other device on the port.

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -72,6 +72,7 @@ static void ali_fifo_control(ide_hwif_t
 static void ali_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
 	int port = hwif->channel ? 0x5c : 0x58;
@@ -79,6 +80,16 @@ static void ali_set_pio_mode(ide_hwif_t
 	struct ide_timing t;
 
 	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
+	if (pair) {
+		struct ide_timing p;
+
+		ide_timing_compute(pair, pair->pio_mode, &p, T, 1);
+		ide_timing_merge(&p, &t, &t, IDE_TIMING_SETUP);
+		if (pair->dma_mode) {
+			ide_timing_compute(pair, pair->dma_mode, &p, T, 1);
+			ide_timing_merge(&p, &t, &t, IDE_TIMING_SETUP);
+		}
+	}
 
 	t.setup = clamp_val(t.setup, 1, 8) & 7;
 	t.active = clamp_val(t.active, 1, 8) & 7;
