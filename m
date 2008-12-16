Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYLPTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYLPTca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYLPTbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:31:55 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:37539 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYLPTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dimtu7u4lx/U8u6OXJiMcvORHzwirmu3r17otKLTUdpAZohBBG1p9NeJQsWB62ybF3
         MLHbl29nLmkA29+CyJfF1VgJHzWxUVvLZqYIkRN8w6legf43Da27LoF1bySC4uKSv9lY
         oQlj7/83aUhL8aV4EN1wsKXO8takCqUD1GcPM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:31:43 +0100
Message-Id: <20081216193143.3959.78861.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: move ide_init_port_data() and friends to ide-probe.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_init_port_data() and friends to ide-probe.c

* Move IDE_DEFAULT_MAX_FAILURES to <linux/ide.h>.

* Move ide_cfg_mtx, ide_hwif_to_major[], ide_port_init_devices_data(),
  ide_init_port_data(), ide_init_port_hw() and ide_unregister() to
  ide-probe.c from ide.c.

* Make ide_unregister(), ide_init_port_data(), ide_init_port_hw()
  and ide_cfg_mtx static.

While at it:

* Remove stale ide_init_port_data() documentation and ide_lock extern.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |  135 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c       |  146 ------------------------------------------------
 include/linux/ide.h     |    9 --
 3 files changed, 136 insertions(+), 154 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -918,6 +918,8 @@ static int ide_init_queue(ide_drive_t *d
 	return 0;
 }
 
+static DEFINE_MUTEX(ide_cfg_mtx);
+
 /*
  * For any present drive:
  * - allocate the block device queue
@@ -1273,6 +1275,69 @@ static void ide_port_cable_detect(ide_hw
 	}
 }
 
+static const u8 ide_hwif_to_major[] =
+	{ IDE0_MAJOR, IDE1_MAJOR, IDE2_MAJOR, IDE3_MAJOR, IDE4_MAJOR,
+	  IDE5_MAJOR, IDE6_MAJOR, IDE7_MAJOR, IDE8_MAJOR, IDE9_MAJOR };
+
+static void ide_port_init_devices_data(ide_hwif_t *hwif)
+{
+	int unit;
+
+	for (unit = 0; unit < MAX_DRIVES; ++unit) {
+		ide_drive_t *drive = &hwif->drives[unit];
+		u8 j = (hwif->index * MAX_DRIVES) + unit;
+
+		memset(drive, 0, sizeof(*drive));
+
+		drive->media			= ide_disk;
+		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
+		drive->hwif			= hwif;
+		drive->ready_stat		= ATA_DRDY;
+		drive->bad_wstat		= BAD_W_STAT;
+		drive->special.b.recalibrate	= 1;
+		drive->special.b.set_geometry	= 1;
+		drive->name[0]			= 'h';
+		drive->name[1]			= 'd';
+		drive->name[2]			= 'a' + j;
+		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
+
+		INIT_LIST_HEAD(&drive->list);
+		init_completion(&drive->gendev_rel_comp);
+	}
+}
+
+static void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
+{
+	/* bulk initialize hwif & drive info with zeros */
+	memset(hwif, 0, sizeof(ide_hwif_t));
+
+	/* fill in any non-zero initial values */
+	hwif->index	= index;
+	hwif->major	= ide_hwif_to_major[index];
+
+	hwif->name[0]	= 'i';
+	hwif->name[1]	= 'd';
+	hwif->name[2]	= 'e';
+	hwif->name[3]	= '0' + index;
+
+	init_completion(&hwif->gendev_rel_comp);
+
+	hwif->tp_ops = &default_tp_ops;
+
+	ide_port_init_devices_data(hwif);
+}
+
+static void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
+{
+	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
+	hwif->irq = hw->irq;
+	hwif->chipset = hw->chipset;
+	hwif->dev = hw->dev;
+	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
+	hwif->ack_intr = hw->ack_intr;
+	hwif->config_data = hw->config;
+}
+
 static unsigned int ide_indexes;
 
 /**
@@ -1503,6 +1568,76 @@ int ide_host_add(const struct ide_port_i
 }
 EXPORT_SYMBOL_GPL(ide_host_add);
 
+static void __ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+			device_unregister(&drive->gendev);
+			wait_for_completion(&drive->gendev_rel_comp);
+		}
+	}
+}
+
+void ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	mutex_lock(&ide_cfg_mtx);
+	__ide_port_unregister_devices(hwif);
+	hwif->present = 0;
+	ide_port_init_devices_data(hwif);
+	mutex_unlock(&ide_cfg_mtx);
+}
+EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
+
+/**
+ *	ide_unregister		-	free an IDE interface
+ *	@hwif: IDE interface
+ *
+ *	Perform the final unregister of an IDE interface.
+ *
+ *	Locking:
+ *	The caller must not hold the IDE locks.
+ *
+ *	It is up to the caller to be sure there is no pending I/O here,
+ *	and that the interface will not be reopened (present/vanishing
+ *	locking isn't yet done BTW).
+ */
+
+static void ide_unregister(ide_hwif_t *hwif)
+{
+	BUG_ON(in_interrupt());
+	BUG_ON(irqs_disabled());
+
+	mutex_lock(&ide_cfg_mtx);
+
+	if (hwif->present) {
+		__ide_port_unregister_devices(hwif);
+		hwif->present = 0;
+	}
+
+	ide_proc_unregister_port(hwif);
+
+	free_irq(hwif->irq, hwif);
+
+	device_unregister(hwif->portdev);
+	device_unregister(&hwif->gendev);
+	wait_for_completion(&hwif->gendev_rel_comp);
+
+	/*
+	 * Remove us from the kernel's knowledge
+	 */
+	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
+	kfree(hwif->sg_table);
+	unregister_blkdev(hwif->major, hwif->name);
+
+	ide_release_dma_engine(hwif);
+
+	mutex_unlock(&ide_cfg_mtx);
+}
+
 void ide_host_free(struct ide_host *host)
 {
 	ide_hwif_t *hwif;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -60,154 +60,8 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 
-
-/* default maximum number of failures */
-#define IDE_DEFAULT_MAX_FAILURES 	1
-
 struct class *ide_port_class;
 
-static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
-					IDE2_MAJOR, IDE3_MAJOR,
-					IDE4_MAJOR, IDE5_MAJOR,
-					IDE6_MAJOR, IDE7_MAJOR,
-					IDE8_MAJOR, IDE9_MAJOR };
-
-DEFINE_MUTEX(ide_cfg_mtx);
-
-static void ide_port_init_devices_data(ide_hwif_t *);
-
-/*
- * Do not even *think* about calling this!
- */
-void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
-{
-	/* bulk initialize hwif & drive info with zeros */
-	memset(hwif, 0, sizeof(ide_hwif_t));
-
-	/* fill in any non-zero initial values */
-	hwif->index	= index;
-	hwif->major	= ide_hwif_to_major[index];
-
-	hwif->name[0]	= 'i';
-	hwif->name[1]	= 'd';
-	hwif->name[2]	= 'e';
-	hwif->name[3]	= '0' + index;
-
-	init_completion(&hwif->gendev_rel_comp);
-
-	hwif->tp_ops = &default_tp_ops;
-
-	ide_port_init_devices_data(hwif);
-}
-
-static void ide_port_init_devices_data(ide_hwif_t *hwif)
-{
-	int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
-		u8 j = (hwif->index * MAX_DRIVES) + unit;
-
-		memset(drive, 0, sizeof(*drive));
-
-		drive->media			= ide_disk;
-		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
-		drive->hwif			= hwif;
-		drive->ready_stat		= ATA_DRDY;
-		drive->bad_wstat		= BAD_W_STAT;
-		drive->special.b.recalibrate	= 1;
-		drive->special.b.set_geometry	= 1;
-		drive->name[0]			= 'h';
-		drive->name[1]			= 'd';
-		drive->name[2]			= 'a' + j;
-		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
-
-		INIT_LIST_HEAD(&drive->list);
-		init_completion(&drive->gendev_rel_comp);
-	}
-}
-
-static void __ide_port_unregister_devices(ide_hwif_t *hwif)
-{
-	int i;
-
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
-
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			device_unregister(&drive->gendev);
-			wait_for_completion(&drive->gendev_rel_comp);
-		}
-	}
-}
-
-void ide_port_unregister_devices(ide_hwif_t *hwif)
-{
-	mutex_lock(&ide_cfg_mtx);
-	__ide_port_unregister_devices(hwif);
-	hwif->present = 0;
-	ide_port_init_devices_data(hwif);
-	mutex_unlock(&ide_cfg_mtx);
-}
-EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
-
-/**
- *	ide_unregister		-	free an IDE interface
- *	@hwif: IDE interface
- *
- *	Perform the final unregister of an IDE interface.
- *
- *	Locking:
- *	The caller must not hold the IDE locks.
- *
- *	It is up to the caller to be sure there is no pending I/O here,
- *	and that the interface will not be reopened (present/vanishing
- *	locking isn't yet done BTW).
- */
-
-void ide_unregister(ide_hwif_t *hwif)
-{
-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());
-
-	mutex_lock(&ide_cfg_mtx);
-
-	if (hwif->present) {
-		__ide_port_unregister_devices(hwif);
-		hwif->present = 0;
-	}
-
-	ide_proc_unregister_port(hwif);
-
-	free_irq(hwif->irq, hwif);
-
-	device_unregister(hwif->portdev);
-	device_unregister(&hwif->gendev);
-	wait_for_completion(&hwif->gendev_rel_comp);
-
-	/*
-	 * Remove us from the kernel's knowledge
-	 */
-	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
-	kfree(hwif->sg_table);
-	unregister_blkdev(hwif->major, hwif->name);
-
-	ide_release_dma_engine(hwif);
-
-	mutex_unlock(&ide_cfg_mtx);
-}
-
-void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
-{
-	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
-	hwif->irq = hw->irq;
-	hwif->chipset = hw->chipset;
-	hwif->dev = hw->dev;
-	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
-	hwif->ack_intr = hw->ack_intr;
-	hwif->config_data = hw->config;
-}
-
 /*
  *	Locks for IDE setting functionality
  */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -37,6 +37,7 @@ typedef unsigned char	byte;	/* used ever
 /*
  * Probably not wise to fiddle with these
  */
+#define IDE_DEFAULT_MAX_FAILURES	1
 #define ERROR_MAX	8	/* Max read/write errors per sector */
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
@@ -184,9 +185,6 @@ typedef struct hw_regs_s {
 	unsigned long	config;
 } hw_regs_t;
 
-void ide_init_port_data(struct hwif_s *, unsigned int);
-void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
@@ -1505,8 +1503,6 @@ static inline void ide_acpi_port_init_de
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_unregister(ide_hwif_t *);
-
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
@@ -1591,9 +1587,6 @@ static inline void ide_set_max_pio(ide_d
 	ide_set_pio(drive, 255);
 }
 
-extern spinlock_t ide_lock;
-extern struct mutex ide_cfg_mtx;
-
 #define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
 char *ide_media_string(ide_drive_t *);
