Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbYGZNox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbYGZNox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYGZNnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:43:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYGZNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dVeHzhTbDSE0nCqseeDx3NkYPOlW69PXAI57W8EnIYCS4MdME4GRXzkCDC2e1m9D6K
         aGj+iOmK20zPPwdAI4LH1URWwOpRxDssOShhD58E+NM6zT+Gv/L768JUdeYbPSFktlz3
         R+7PzXC2AakkQ7JJ2UEiQWkVUNWT6jNYews0U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:57 +0200
Message-Id: <20080726134057.10589.10226.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/10] ide: check drive->present in ide_get_paired_drive()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Change ide_get_paired_drive() to return NULL if peer device
  is not present and update all users accordingly.

While at it:

* ide_get_paired_drive() -> ide_get_pair_dev()

* Use ide_get_pair_dev() in cs5530.c, sc1200.c and via82cxxx.c.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    4 ++--
 drivers/ide/pci/cs5530.c      |    4 ++--
 drivers/ide/pci/cs5535.c      |    4 ++--
 drivers/ide/pci/opti621.c     |    4 ++--
 drivers/ide/pci/sc1200.c      |    4 ++--
 drivers/ide/pci/siimage.c     |    4 ++--
 drivers/ide/pci/via82cxxx.c   |    4 ++--
 include/linux/ide.h           |    6 +++---
 8 files changed, 17 insertions(+), 17 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -180,7 +180,7 @@ static void palm_bk3710_setpiomode(void 
 	val32 |= (t2i << (dev ? 8 : 0));
 	writel(val32, base + BK3710_DATRCVR);
 
-	if (mate && mate->present) {
+	if (mate) {
 		u8 mode2 = ide_get_best_pio_mode(mate, 255, 4);
 
 		if (mode2 < mode)
@@ -230,7 +230,7 @@ static void palm_bk3710_set_pio_mode(ide
 	 * Obtain the drive PIO data for tuning the Palm Chip registers
 	 */
 	cycle_time = ide_pio_cycle_time(drive, pio);
-	mate = ide_get_paired_drive(drive);
+	mate = ide_get_pair_dev(drive);
 	palm_bk3710_setpiomode(base, mate, is_slave, cycle_time, pio);
 }
 
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -81,11 +81,11 @@ static void cs5530_set_pio_mode(ide_driv
 static u8 cs5530_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
+	ide_drive_t *mate = ide_get_pair_dev(drive);
 	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
-	if (mate->present == 0)
+	if (mate == NULL)
 		goto out;
 
 	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -80,12 +80,12 @@ static void cs5535_set_speed(ide_drive_t
 
 	/* Set the PIO timings */
 	if (speed < XFER_SW_DMA_0) {
-		ide_drive_t *pair = ide_get_paired_drive(drive);
+		ide_drive_t *pair = ide_get_pair_dev(drive);
 		u8 cmd, pioa;
 
 		cmd = pioa = speed - XFER_PIO_0;
 
-		if (pair->present) {
+		if (pair) {
 			u8 piob = ide_get_best_pio_mode(pair, 255, 4);
 
 			if (piob < cmd)
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -137,7 +137,7 @@ static u8 read_reg(int reg)
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *pair = ide_get_paired_drive(drive);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	unsigned long flags;
 	u8 tim, misc, addr_pio = pio, clk;
 
@@ -153,7 +153,7 @@ static void opti621_set_pio_mode(ide_dri
 
 	drive->drive_data = XFER_PIO_0 + pio;
 
-	if (pair->present) {
+	if (pair) {
 		if (pair->drive_data && pair->drive_data < drive->drive_data)
 			addr_pio = pair->drive_data - XFER_PIO_0;
 	}
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -104,11 +104,11 @@ static void sc1200_tunepio(ide_drive_t *
 static u8 sc1200_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
+	ide_drive_t *mate = ide_get_pair_dev(drive);
 	u16 *mateid = mate->id;
 	u8 mask = hwif->ultra_mask;
 
-	if (mate->present == 0)
+	if (mate == NULL)
 		goto out;
 
 	if (ata_id_has_dma(mateid) && __ide_dma_bad_drive(mate) == 0) {
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -245,7 +245,7 @@ static void sil_set_pio_mode(ide_drive_t
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	ide_drive_t *pair	= ide_get_paired_drive(drive);
+	ide_drive_t *pair	= ide_get_pair_dev(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
@@ -259,7 +259,7 @@ static void sil_set_pio_mode(ide_drive_t
 	u8 unit			= drive->select.b.unit;
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
-	if (pair->present) {
+	if (pair) {
 		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
 
 		if (pair_pio < tf_pio)
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -154,7 +154,7 @@ static void via_set_speed(ide_hwif_t *hw
 static void via_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
+	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
@@ -173,7 +173,7 @@ static void via_set_drive(ide_drive_t *d
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->present) {
+	if (peer) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1460,10 +1460,10 @@ static inline int hwif_to_node(ide_hwif_
 	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
 }
 
-static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
+static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
 
-	return &hwif->drives[(drive->dn ^ 1) & 1];
+	return peer->present ? peer : NULL;
 }
 #endif /* _IDE_H */
