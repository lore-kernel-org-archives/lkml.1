Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbZAOUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbZAOUdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765461AbZAOUBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:40 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56109 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762049AbZAOUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ifWwMITnrLtaw92jBp6w085T4aoy3SotV8nqe6Lc78l1XXMo0O1g8v/a0PQvKpKtrS
         OwQxC5G0DthCyX8+mGSPW7WghcsEZsC6aKcRNB7jgjRb+6EJHHrmrIKken3er+s7sRsh
         nkpBG0Ka3EjKYdb8Q+iagCwscE+W8o9mDBi74=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:01:35 +0100
Message-Id: <20090115200135.17294.24530.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: move xfer mode tuning code to ide-xfer-mode.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move xfer mode tuning code to ide-xfer-mode.c

* Move xfer mode tuning code to ide-xfer-mode.c.

* Add CONFIG_IDE_XFER_MODE config option to be selected by host drivers
  that support xfer mode tuning.

* Add CONFIG_IDE_XFER_MODE=n static inline versions of ide_set_pio()
  and ide_set_xfer_rate().

* Make IDE_TIMINGS and BLK_DEV_IDEDMA config options select IDE_XFER_MODE,
  also add explicit selects for few host drivers that need it.

* Build/link ide-xfer-mode.o and ide-pio-blacklist.o (it is needed only
  by ide-xfer-mode.o) only if CONFIG_IDE_XFER_MODE=y.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig         |    8 +
 drivers/ide/Makefile        |    4 
 drivers/ide/ide-lib.c       |  240 ------------------------------------------
 drivers/ide/ide-xfer-mode.c |  246 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ide.h         |   12 +-
 5 files changed, 263 insertions(+), 247 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -56,8 +56,12 @@ if IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_XFER_MODE
+	bool
+
 config IDE_TIMINGS
 	bool
+	select IDE_XFER_MODE
 
 config IDE_ATAPI
 	bool
@@ -698,6 +702,7 @@ config BLK_DEV_IDE_PMAC_ATA100FIRST
 config BLK_DEV_IDE_AU1XXX
        bool "IDE for AMD Alchemy Au1200"
        depends on SOC_AU1200
+       select IDE_XFER_MODE
 choice
        prompt "IDE Mode for AMD Alchemy Au1200"
        default CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
@@ -866,6 +871,7 @@ config BLK_DEV_ALI14XX
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
+	select IDE_XFER_MODE
 	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "dtc2278.probe" kernel
@@ -897,6 +903,7 @@ config BLK_DEV_QD65XX
 
 config BLK_DEV_UMC8672
 	tristate "UMC-8672 support"
+	select IDE_XFER_MODE
 	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "umc8672.probe" kernel
@@ -910,5 +917,6 @@ endif
 config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	select IDE_XFER_MODE
 
 endif # IDE
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,10 +5,10 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o \
-	      ide-sysfs.o ide-devsets.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_XFER_MODE)	+= ide-pio-blacklist.o ide-xfer-mode.o
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -5,163 +5,6 @@
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
-static const char *udma_str[] =
-	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
-	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
-static const char *mwdma_str[] =
-	{ "MWDMA0", "MWDMA1", "MWDMA2" };
-static const char *swdma_str[] =
-	{ "SWDMA0", "SWDMA1", "SWDMA2" };
-static const char *pio_str[] =
-	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
-
-/**
- *	ide_xfer_verbose	-	return IDE mode names
- *	@mode: transfer mode
- *
- *	Returns a constant string giving the name of the mode
- *	requested.
- */
-
-const char *ide_xfer_verbose(u8 mode)
-{
-	const char *s;
-	u8 i = mode & 0xf;
-
-	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
-		s = udma_str[i];
-	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
-		s = mwdma_str[i];
-	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
-		s = swdma_str[i];
-	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
-		s = pio_str[i & 0x7];
-	else if (mode == XFER_PIO_SLOW)
-		s = "PIO SLOW";
-	else
-		s = "XFER ERROR";
-
-	return s;
-}
-EXPORT_SYMBOL(ide_xfer_verbose);
-
-/**
- *	ide_rate_filter		-	filter transfer mode
- *	@drive: IDE device
- *	@speed: desired speed
- *
- *	Given the available transfer modes this function returns
- *	the best available speed at or below the speed requested.
- *
- *	TODO: check device PIO capabilities
- */
-
-static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 mode = ide_find_dma_mode(drive, speed);
-
-	if (mode == 0) {
-		if (hwif->pio_mask)
-			mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
-		else
-			mode = XFER_PIO_4;
-	}
-
-/*	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed); */
-
-	return min(speed, mode);
-}
-
-/**
- *	ide_get_best_pio_mode	-	get PIO mode from drive
- *	@drive: drive to consider
- *	@mode_wanted: preferred mode
- *	@max_mode: highest allowed mode
- *
- *	This routine returns the recommended PIO settings for a given drive,
- *	based on the drive->id information and the ide_pio_blacklist[].
- *
- *	Drive PIO mode is auto-selected if 255 is passed as mode_wanted.
- *	This is used by most chipset support modules when "auto-tuning".
- */
-
-u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
-{
-	u16 *id = drive->id;
-	int pio_mode = -1, overridden = 0;
-
-	if (mode_wanted != 255)
-		return min_t(u8, mode_wanted, max_mode);
-
-	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
-		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
-
-	if (pio_mode != -1) {
-		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
-	} else {
-		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
-		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
-			pio_mode = 2;
-			overridden = 1;
-		}
-
-		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
-			if (ata_id_has_iordy(id)) {
-				if (id[ATA_ID_PIO_MODES] & 7) {
-					overridden = 0;
-					if (id[ATA_ID_PIO_MODES] & 4)
-						pio_mode = 5;
-					else if (id[ATA_ID_PIO_MODES] & 2)
-						pio_mode = 4;
-					else
-						pio_mode = 3;
-				}
-			}
-		}
-
-		if (overridden)
-			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
-					 drive->name);
-	}
-
-	if (pio_mode > max_mode)
-		pio_mode = max_mode;
-
-	return pio_mode;
-}
-EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
-
-/* req_pio == "255" for auto-tune */
-void ide_set_pio(ide_drive_t *drive, u8 req_pio)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-	u8 host_pio, pio;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return;
-
-	BUG_ON(hwif->pio_mask == 0x00);
-
-	host_pio = fls(hwif->pio_mask) - 1;
-
-	pio = ide_get_best_pio_mode(drive, req_pio, host_pio);
-
-	/*
-	 * TODO:
-	 * - report device max PIO mode
-	 * - check req_pio != 255 against device max PIO mode
-	 */
-	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
-			  drive->name, host_pio, req_pio,
-			  req_pio == 255 ? "(auto-tune)" : "", pio);
-
-	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
-}
-EXPORT_SYMBOL_GPL(ide_set_pio);
-
 /**
  *	ide_toggle_bounce	-	handle bounce buffering
  *	@drive: drive to update
@@ -188,89 +31,6 @@ void ide_toggle_bounce(ide_drive_t *driv
 		blk_queue_bounce_limit(drive->queue, addr);
 }
 
-int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL)
-		return -1;
-
-	/*
-	 * TODO: temporary hack for some legacy host drivers that didn't
-	 * set transfer mode on the device in ->set_pio_mode method...
-	 */
-	if (port_ops->set_dma_mode == NULL) {
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return 0;
-	}
-
-	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
-		if (ide_config_drive_speed(drive, mode))
-			return -1;
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return 0;
-	} else {
-		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
-		return ide_config_drive_speed(drive, mode);
-	}
-}
-
-int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
-
-	if (port_ops == NULL || port_ops->set_dma_mode == NULL)
-		return -1;
-
-	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
-		if (ide_config_drive_speed(drive, mode))
-			return -1;
-		port_ops->set_dma_mode(drive, mode);
-		return 0;
-	} else {
-		port_ops->set_dma_mode(drive, mode);
-		return ide_config_drive_speed(drive, mode);
-	}
-}
-EXPORT_SYMBOL_GPL(ide_set_dma_mode);
-
-/**
- *	ide_set_xfer_rate	-	set transfer rate
- *	@drive: drive to set
- *	@rate: speed to attempt to set
- *
- *	General helper for setting the speed of an IDE device. This
- *	function knows about user enforced limits from the configuration
- *	which ->set_pio_mode/->set_dma_mode does not.
- */
-
-int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return -1;
-
-	rate = ide_rate_filter(drive, rate);
-
-	BUG_ON(rate < XFER_PIO_0);
-
-	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
-		return ide_set_pio_mode(drive, rate);
-
-	return ide_set_dma_mode(drive, rate);
-}
-
 static void ide_dump_opcode(ide_drive_t *drive)
 {
 	struct request *rq = drive->hwif->rq;
Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-xfer-mode.c
@@ -0,0 +1,246 @@
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/ide.h>
+#include <linux/bitops.h>
+
+static const char *udma_str[] =
+	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
+	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
+static const char *mwdma_str[] =
+	{ "MWDMA0", "MWDMA1", "MWDMA2" };
+static const char *swdma_str[] =
+	{ "SWDMA0", "SWDMA1", "SWDMA2" };
+static const char *pio_str[] =
+	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
+
+/**
+ *	ide_xfer_verbose	-	return IDE mode names
+ *	@mode: transfer mode
+ *
+ *	Returns a constant string giving the name of the mode
+ *	requested.
+ */
+
+const char *ide_xfer_verbose(u8 mode)
+{
+	const char *s;
+	u8 i = mode & 0xf;
+
+	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		s = udma_str[i];
+	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
+		s = mwdma_str[i];
+	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
+		s = swdma_str[i];
+	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
+		s = pio_str[i & 0x7];
+	else if (mode == XFER_PIO_SLOW)
+		s = "PIO SLOW";
+	else
+		s = "XFER ERROR";
+
+	return s;
+}
+EXPORT_SYMBOL(ide_xfer_verbose);
+
+/**
+ *	ide_get_best_pio_mode	-	get PIO mode from drive
+ *	@drive: drive to consider
+ *	@mode_wanted: preferred mode
+ *	@max_mode: highest allowed mode
+ *
+ *	This routine returns the recommended PIO settings for a given drive,
+ *	based on the drive->id information and the ide_pio_blacklist[].
+ *
+ *	Drive PIO mode is auto-selected if 255 is passed as mode_wanted.
+ *	This is used by most chipset support modules when "auto-tuning".
+ */
+
+u8 ide_get_best_pio_mode(ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
+{
+	u16 *id = drive->id;
+	int pio_mode = -1, overridden = 0;
+
+	if (mode_wanted != 255)
+		return min_t(u8, mode_wanted, max_mode);
+
+	if ((drive->hwif->host_flags & IDE_HFLAG_PIO_NO_BLACKLIST) == 0)
+		pio_mode = ide_scan_pio_blacklist((char *)&id[ATA_ID_PROD]);
+
+	if (pio_mode != -1) {
+		printk(KERN_INFO "%s: is on PIO blacklist\n", drive->name);
+	} else {
+		pio_mode = id[ATA_ID_OLD_PIO_MODES] >> 8;
+		if (pio_mode > 2) {	/* 2 is maximum allowed tPIO value */
+			pio_mode = 2;
+			overridden = 1;
+		}
+
+		if (id[ATA_ID_FIELD_VALID] & 2) {	      /* ATA2? */
+			if (ata_id_has_iordy(id)) {
+				if (id[ATA_ID_PIO_MODES] & 7) {
+					overridden = 0;
+					if (id[ATA_ID_PIO_MODES] & 4)
+						pio_mode = 5;
+					else if (id[ATA_ID_PIO_MODES] & 2)
+						pio_mode = 4;
+					else
+						pio_mode = 3;
+				}
+			}
+		}
+
+		if (overridden)
+			printk(KERN_INFO "%s: tPIO > 2, assuming tPIO = 2\n",
+					 drive->name);
+	}
+
+	if (pio_mode > max_mode)
+		pio_mode = max_mode;
+
+	return pio_mode;
+}
+EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
+
+int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL)
+		return -1;
+
+	/*
+	 * TODO: temporary hack for some legacy host drivers that didn't
+	 * set transfer mode on the device in ->set_pio_mode method...
+	 */
+	if (port_ops->set_dma_mode == NULL) {
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	}
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	} else {
+		port_ops->set_pio_mode(drive, mode - XFER_PIO_0);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+
+int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL)
+		return -1;
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		port_ops->set_dma_mode(drive, mode);
+		return 0;
+	} else {
+		port_ops->set_dma_mode(drive, mode);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+EXPORT_SYMBOL_GPL(ide_set_dma_mode);
+
+/* req_pio == "255" for auto-tune */
+void ide_set_pio(ide_drive_t *drive, u8 req_pio)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+	u8 host_pio, pio;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return;
+
+	BUG_ON(hwif->pio_mask == 0x00);
+
+	host_pio = fls(hwif->pio_mask) - 1;
+
+	pio = ide_get_best_pio_mode(drive, req_pio, host_pio);
+
+	/*
+	 * TODO:
+	 * - report device max PIO mode
+	 * - check req_pio != 255 against device max PIO mode
+	 */
+	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
+			  drive->name, host_pio, req_pio,
+			  req_pio == 255 ? "(auto-tune)" : "", pio);
+
+	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
+}
+EXPORT_SYMBOL_GPL(ide_set_pio);
+
+/**
+ *	ide_rate_filter		-	filter transfer mode
+ *	@drive: IDE device
+ *	@speed: desired speed
+ *
+ *	Given the available transfer modes this function returns
+ *	the best available speed at or below the speed requested.
+ *
+ *	TODO: check device PIO capabilities
+ */
+
+static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mode = ide_find_dma_mode(drive, speed);
+
+	if (mode == 0) {
+		if (hwif->pio_mask)
+			mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
+		else
+			mode = XFER_PIO_4;
+	}
+
+/*	printk("%s: mode 0x%02x, speed 0x%02x\n", __func__, mode, speed); */
+
+	return min(speed, mode);
+}
+
+/**
+ *	ide_set_xfer_rate	-	set transfer rate
+ *	@drive: drive to set
+ *	@rate: speed to attempt to set
+ *
+ *	General helper for setting the speed of an IDE device. This
+ *	function knows about user enforced limits from the configuration
+ *	which ->set_pio_mode/->set_dma_mode does not.
+ */
+
+int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (port_ops == NULL || port_ops->set_dma_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return -1;
+
+	rate = ide_rate_filter(drive, rate);
+
+	BUG_ON(rate < XFER_PIO_0);
+
+	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
+		return ide_set_pio_mode(drive, rate);
+
+	return ide_set_dma_mode(drive, rate);
+}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1529,9 +1529,7 @@ static inline void ide_set_hwifdata (ide
 	hwif->hwif_data = data;
 }
 
-const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
-extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
@@ -1570,14 +1568,18 @@ void ide_timing_merge(struct ide_timing 
 		      struct ide_timing *, unsigned int);
 int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
 
+#ifdef CONFIG_IDE_XFER_MODE
 int ide_scan_pio_blacklist(char *);
-
+const char *ide_xfer_verbose(u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
-
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
-
 void ide_set_pio(ide_drive_t *, u8);
+int ide_set_xfer_rate(ide_drive_t *, u8);
+#else
+static inline void ide_set_pio(ide_drive_t *drive, u8 pio) { ; }
+static inline int ide_set_xfer_rate(ide_drive_t *drive, u8 rate) { return -1; }
+#endif
 
 static inline void ide_set_max_pio(ide_drive_t *drive)
 {
