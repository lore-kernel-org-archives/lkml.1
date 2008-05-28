Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYE1Vqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYE1Vqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYE1Vov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:44:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:51223 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbYE1Vou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oMm/QDw80I62+oDHXIrwZmJBP4MzFL5Rb1qeyzsYBAZzM5Ww1aXg2eCOXaMujqtHCB3bYXEsn+ypzsFVuUUmj2tGeqwViO/d5sFpKN7hsofVcNMesak09pgds8mUmIrTgjyUGQGgDeBpiKjzdme0CXEZM623iNn6pzokihhcx5U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:23 +0200
Message-Id: <20080528214223.16327.11847.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/21] alim15x3: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig        |    1 +
 drivers/ide/pci/alim15x3.c |    6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -458,6 +458,7 @@ config BLK_DEV_AEC62XX
 
 config BLK_DEV_ALI15X3
 	tristate "ALI M15x3 chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver ensures (U)DMA support for ALI 1533, 1543 and 1543C
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -69,7 +69,8 @@ static void ali_set_pio_mode(ide_drive_t
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	int s_time, a_time, c_time;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	int s_time = t->setup, a_time = t->active, c_time = t->cycle;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
@@ -78,13 +79,10 @@ static void ali_set_pio_mode(ide_drive_t
 	u8 cd_dma_fifo = 0;
 	int unit = drive->select.b.unit & 1;
 
-	s_time = ide_pio_timings[pio].setup_time;
-	a_time = ide_pio_timings[pio].active_time;
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
 		s_clc = 0;
 	if ((a_clc = (a_time * bus_speed + 999) / 1000) >= 8)
 		a_clc = 0;
-	c_time = ide_pio_timings[pio].cycle_time;
 
 	if (!(r_clc = (c_time * bus_speed + 999) / 1000 - a_clc - s_clc)) {
 		r_clc = 1;
