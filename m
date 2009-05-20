Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZETPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZETPdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZETPcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:20 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56712 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZETPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=wBVOlFMuPnnixrKEnWvghvzBZvj+GlwCo2DNhLdTXC1QODwmmly5jsD0g1QwI+fhDU
         8Ekd1wr8warmVSB3teESi4ZOSbpGqExj9AV2XKjxGbH36fk7et6IqJrE1aNvAOXnSe6Q
         JH6dSeTbprLNpckgZ1xImA95a8kKezWzk9c/0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: respect quirk_drives[] list on all controllers
Date: Wed, 20 May 2009 17:34:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201734.42093.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_check_nien_quirk_list() helper to the core code
  and then use it in ide_port_tune_devices().

* Remove no longer needed ->quirkproc methods from hpt366.c
  and pdc202xx_{new,old}.c.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/hpt366.c       |   27 ---------------------------
 drivers/ide/ide-iops.c     |   25 +++++++++++++++++++++++++
 drivers/ide/ide-probe.c    |    2 ++
 drivers/ide/pdc202xx_new.c |   26 --------------------------
 drivers/ide/pdc202xx_old.c |   27 ---------------------------
 include/linux/ide.h        |    1 +
 6 files changed, 28 insertions(+), 80 deletions(-)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -138,18 +138,6 @@
 #undef	HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
 
-static const char *quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP KA9.1",
-	"QUANTUM FIREBALLP KX13.6",
-	"QUANTUM FIREBALLP KX20.5",
-	"QUANTUM FIREBALLP KX27.3",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static const char *bad_ata100_5[] = {
 	"IBM-DTLA-307075",
 	"IBM-DTLA-307060",
@@ -733,20 +721,6 @@ static void hpt3xx_set_pio_mode(ide_driv
 	hpt3xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static void hpt3xx_quirkproc(ide_drive_t *drive)
-{
-	char *m			= (char *)&drive->id[ATA_ID_PROD];
-	const  char **list	= quirk_drives;
-
-	while (*list)
-		if (strstr(m, *list++)) {
-			drive->quirk_list = 2;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= drive->hwif;
@@ -1408,7 +1382,6 @@ static int __devinit hpt36x_init(struct 
 static const struct ide_port_ops hpt3xx_port_ops = {
 	.set_pio_mode		= hpt3xx_set_pio_mode,
 	.set_dma_mode		= hpt3xx_set_mode,
-	.quirkproc		= hpt3xx_quirkproc,
 	.maskproc		= hpt3xx_maskproc,
 	.mdma_filter		= hpt3xx_mdma_filter,
 	.udma_filter		= hpt3xx_udma_filter,
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -269,6 +269,31 @@ no_80w:
 	return 0;
 }
 
+static const char *nien_quirk_list[] = {
+	"QUANTUM FIREBALLlct08 08",
+	"QUANTUM FIREBALLP KA6.4",
+	"QUANTUM FIREBALLP KA9.1",
+	"QUANTUM FIREBALLP KX13.6",
+	"QUANTUM FIREBALLP KX20.5",
+	"QUANTUM FIREBALLP KX27.3",
+	"QUANTUM FIREBALLP LM20.4",
+	"QUANTUM FIREBALLP LM20.5",
+	NULL
+};
+
+void ide_check_nien_quirk_list(ide_drive_t *drive)
+{
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
+
+	for (list = nien_quirk_list; *list != NULL; list++)
+		if (strstr(m, *list) != NULL) {
+			drive->quirk_list = 2;
+			return;
+		}
+
+	drive->quirk_list = 0;
+}
+
 int ide_driveid_update(ide_drive_t *drive)
 {
 	u16 *id;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -729,6 +729,8 @@ static void ide_port_tune_devices(ide_hw
 	int i;
 
 	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_check_nien_quirk_list(drive);
+
 		if (port_ops && port_ops->quirkproc)
 			port_ops->quirkproc(drive);
 	}
Index: b/drivers/ide/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -40,18 +40,6 @@
 #define DBG(fmt, args...)
 #endif
 
-static const char *pdc_quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP KA9.1",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP KX13.6",
-	"QUANTUM FIREBALLP KX20.5",
-	"QUANTUM FIREBALLP KX27.3",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static u8 max_dma_rate(struct pci_dev *pdev)
 {
 	u8 mode;
@@ -200,19 +188,6 @@ static u8 pdcnew_cable_detect(ide_hwif_t
 		return ATA_CBL_PATA80;
 }
 
-static void pdcnew_quirkproc(ide_drive_t *drive)
-{
-	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
-
-	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(m, *list) != NULL) {
-			drive->quirk_list = 2;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void pdcnew_reset(ide_drive_t *drive)
 {
 	/*
@@ -473,7 +448,6 @@ static struct pci_dev * __devinit pdc202
 static const struct ide_port_ops pdcnew_port_ops = {
 	.set_pio_mode		= pdcnew_set_pio_mode,
 	.set_dma_mode		= pdcnew_set_dma_mode,
-	.quirkproc		= pdcnew_quirkproc,
 	.resetproc		= pdcnew_reset,
 	.cable_detect		= pdcnew_cable_detect,
 };
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -23,18 +23,6 @@
 
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
-static const char *pdc_quirk_drives[] = {
-	"QUANTUM FIREBALLlct08 08",
-	"QUANTUM FIREBALLP KA6.4",
-	"QUANTUM FIREBALLP KA9.1",
-	"QUANTUM FIREBALLP LM20.4",
-	"QUANTUM FIREBALLP KX13.6",
-	"QUANTUM FIREBALLP KX20.5",
-	"QUANTUM FIREBALLP KX27.3",
-	"QUANTUM FIREBALLP LM20.5",
-	NULL
-};
-
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
@@ -151,19 +139,6 @@ static void pdc_old_disable_66MHz_clock(
 	outb(clock & ~(hwif->channel ? 0x08 : 0x02), clock_reg);
 }
 
-static void pdc202xx_quirkproc(ide_drive_t *drive)
-{
-	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
-
-	for (list = pdc_quirk_drives; *list != NULL; list++)
-		if (strstr(m, *list) != NULL) {
-			drive->quirk_list = 2;
-			return;
-		}
-
-	drive->quirk_list = 0;
-}
-
 static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
@@ -311,13 +286,11 @@ static void __devinit pdc202ata4_fixup_i
 static const struct ide_port_ops pdc20246_port_ops = {
 	.set_pio_mode		= pdc202xx_set_pio_mode,
 	.set_dma_mode		= pdc202xx_set_mode,
-	.quirkproc		= pdc202xx_quirkproc,
 };
 
 static const struct ide_port_ops pdc2026x_port_ops = {
 	.set_pio_mode		= pdc202xx_set_pio_mode,
 	.set_dma_mode		= pdc202xx_set_mode,
-	.quirkproc		= pdc202xx_quirkproc,
 	.resetproc		= pdc202xx_reset,
 	.cable_detect		= pdc2026x_cable_detect,
 };
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1464,6 +1464,7 @@ static inline void ide_acpi_set_state(id
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
+void ide_check_nien_quirk_list(ide_drive_t *);
 void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
