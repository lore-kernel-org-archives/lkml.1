Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYLUVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYLUVCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYLUVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:00:51 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34166 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYLUVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AR+8qQfvgqGYq104yXTUF86NpBsG1wAVSvpyq2c/T5ysfHMUg+mTO+0qdhmLNT99Ao
         9Hj73Jm3IAICCJTWVHd8RmgakjBHY+AKxf4enE2i4qfq2GnJHqDuLqAkzyVr4OkHNTw3
         Aqqwgdebmx3bYs9bGL/zq4CIw3XJ/mbRv1EIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 22:00:49 +0100
Message-Id: <20081221210049.23795.39812.sendpatchset@localhost.localdomain>
In-Reply-To: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
References: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/7] ide: add port and host iterators
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add port and host iterators

Add ide_port_for_each_dev() / ide_host_for_each_port() iterators
and update IDE code to use them.

While at it:
- s/unit/i/ variable in ide_port_wait_ready(), ide_probe_port(),
  ide_port_tune_devices(), ide_port_init_devices_data(), do_reset1(),
  ide_acpi_set_state() and scc_dma_end()
- s/d/i/ variable in ide_proc_port_register_devices()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c  |   14 ++-----
 drivers/ide/ide-iops.c  |   15 +++----
 drivers/ide/ide-probe.c |   96 +++++++++++++++++++-----------------------------
 drivers/ide/ide-proc.c  |    7 +--
 drivers/ide/ide.c       |    5 +-
 drivers/ide/scc_pata.c  |    8 ++--
 include/linux/ide.h     |   11 ++++-
 7 files changed, 69 insertions(+), 87 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -641,7 +641,8 @@ void ide_acpi_push_timing(ide_hwif_t *hw
  */
 void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 {
-	int unit;
+	ide_drive_t *drive;
+	int i;
 
 	if (ide_noacpi || ide_noacpi_psx)
 		return;
@@ -655,9 +656,8 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 	/* channel first and then drives for power on and verse versa for power off */
 	if (on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = hwif->devices[unit];
 
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (!drive->acpidata->obj_handle)
 			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
 
@@ -717,9 +717,7 @@ void ide_acpi_port_init_devices(ide_hwif
 	/*
 	 * Send IDENTIFY for each drive
 	 */
-	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = hwif->devices[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
@@ -744,9 +742,7 @@ void ide_acpi_port_init_devices(ide_hwif
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = hwif->devices[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1081,8 +1081,9 @@ static ide_startstop_t do_reset1 (ide_dr
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_port_ops *port_ops;
+	ide_drive_t *tdrive;
 	unsigned long flags, timeout;
-	unsigned int unit;
+	int i;
 	DEFINE_WAIT(wait);
 
 	spin_lock_irqsave(&hwif->lock, flags);
@@ -1110,11 +1111,9 @@ static ide_startstop_t do_reset1 (ide_dr
 
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
-		for (unit = 0; unit < MAX_DRIVES; unit++) {
-			ide_drive_t *tdrive = hwif->devices[unit];
-
-			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
-			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
+		ide_port_for_each_dev(i, tdrive, hwif) {
+			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
+			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
 			    time_after(tdrive->sleep, timeout))
 				timeout = tdrive->sleep;
 		}
@@ -1133,8 +1132,8 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * First, reset any device state data we were maintaining
 	 * for any of the drives on this interface.
 	 */
-	for (unit = 0; unit < MAX_DRIVES; ++unit)
-		pre_reset(hwif->devices[unit]);
+	ide_port_for_each_dev(i, tdrive, hwif)
+		pre_reset(tdrive);
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&hwif->lock, flags);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -697,7 +697,8 @@ out:
 
 static int ide_port_wait_ready(ide_hwif_t *hwif)
 {
-	int unit, rc;
+	ide_drive_t *drive;
+	int i, rc;
 
 	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -714,9 +715,7 @@ static int ide_port_wait_ready(ide_hwif_
 		return rc;
 
 	/* Now make sure both master & slave are ready */
-	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = hwif->devices[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		/* Ignore disks that we will not probe for later. */
 		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
 		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
@@ -732,7 +731,7 @@ static int ide_port_wait_ready(ide_hwif_
 	}
 out:
 	/* Exit function with master reselected (let's be sane) */
-	if (unit)
+	if (i)
 		SELECT_DRIVE(hwif->devices[0]);
 
 	return rc;
@@ -778,9 +777,10 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 
 static int ide_probe_port(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	unsigned long flags;
 	unsigned int irqd;
-	int unit, rc = -ENODEV;
+	int i, rc = -ENODEV;
 
 	BUG_ON(hwif->present);
 
@@ -806,9 +806,7 @@ static int ide_probe_port(ide_hwif_t *hw
 	 * Second drive should only exist if first drive was found,
 	 * but a lot of cdrom drives are configured as single slaves.
 	 */
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = hwif->devices[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		(void) probe_for_drive(drive);
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
@@ -829,20 +827,17 @@ static int ide_probe_port(ide_hwif_t *hw
 static void ide_port_tune_devices(ide_hwif_t *hwif)
 {
 	const struct ide_port_ops *port_ops = hwif->port_ops;
-	int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = hwif->devices[unit];
+	ide_drive_t *drive;
+	int i;
 
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			if (port_ops && port_ops->quirkproc)
 				port_ops->quirkproc(drive);
 		}
 	}
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = hwif->devices[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			ide_set_max_pio(drive);
 
@@ -853,9 +848,7 @@ static void ide_port_tune_devices(ide_hw
 		}
 	}
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = hwif->devices[unit];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
 		    drive->id[ATA_ID_DWORD_IO])
 			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
@@ -927,12 +920,11 @@ static DEFINE_MUTEX(ide_cfg_mtx);
  */
 static int ide_port_setup_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = hwif->devices[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
@@ -1161,10 +1153,10 @@ out:
 
 static void hwif_register_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	unsigned int i;
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = hwif->devices[i];
+	ide_port_for_each_dev(i, drive, hwif) {
 		struct device *dev = &drive->gendev;
 		int ret;
 
@@ -1187,11 +1179,10 @@ static void hwif_register_devices(ide_hw
 static void ide_port_init_devices(ide_hwif_t *hwif)
 {
 	const struct ide_port_ops *port_ops = hwif->port_ops;
+	ide_drive_t *drive;
 	int i;
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = hwif->devices[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		drive->dn = i + hwif->channel * 2;
 
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
@@ -1282,16 +1273,16 @@ static const u8 ide_hwif_to_major[] =
 
 static void ide_port_init_devices_data(ide_hwif_t *hwif)
 {
-	int unit;
+	ide_drive_t *drive;
+	int i;
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = hwif->devices[unit];
-		u8 j = (hwif->index * MAX_DRIVES) + unit;
+	ide_port_for_each_dev(i, drive, hwif) {
+		u8 j = (hwif->index * MAX_DRIVES) + i;
 
 		memset(drive, 0, sizeof(*drive));
 
 		drive->media			= ide_disk;
-		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
+		drive->select			= (i << 4) | ATA_DEVICE_OBS;
 		drive->hwif			= hwif;
 		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
@@ -1387,10 +1378,11 @@ static void ide_free_port_slot(int idx)
 
 static void ide_port_free_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i;
 
-	for (i = 0; i < MAX_DRIVES; i++)
-		kfree(hwif->devices[i]);
+	ide_port_for_each_dev(i, drive, hwif)
+		kfree(drive);
 }
 
 static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
@@ -1478,9 +1470,7 @@ int ide_host_register(struct ide_host *h
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL) {
 			mate = NULL;
 			continue;
@@ -1506,9 +1496,7 @@ int ide_host_register(struct ide_host *h
 		ide_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1523,9 +1511,7 @@ int ide_host_register(struct ide_host *h
 			ide_port_tune_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1550,9 +1536,7 @@ int ide_host_register(struct ide_host *h
 			ide_acpi_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1560,9 +1544,7 @@ int ide_host_register(struct ide_host *h
 			hwif_register_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1602,11 +1584,10 @@ EXPORT_SYMBOL_GPL(ide_host_add);
 
 static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i;
 
-	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = hwif->devices[i];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			device_unregister(&drive->gendev);
 			wait_for_completion(&drive->gendev_rel_comp);
@@ -1675,9 +1656,7 @@ void ide_host_free(struct ide_host *host
 	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		hwif = host->ports[i];
-
+	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
 
@@ -1692,11 +1671,12 @@ EXPORT_SYMBOL_GPL(ide_host_free);
 
 void ide_host_remove(struct ide_host *host)
 {
+	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HOST_PORTS; i++) {
-		if (host->ports[i])
-			ide_unregister(host->ports[i]);
+	ide_host_for_each_port(i, hwif, host) {
+		if (hwif)
+			ide_unregister(hwif);
 	}
 
 	ide_host_free(host);
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -593,14 +593,13 @@ EXPORT_SYMBOL(ide_proc_unregister_driver
 
 void ide_proc_port_register_devices(ide_hwif_t *hwif)
 {
-	int	d;
 	struct proc_dir_entry *ent;
 	struct proc_dir_entry *parent = hwif->proc;
+	ide_drive_t *drive;
 	char name[64];
+	int i;
 
-	for (d = 0; d < MAX_DRIVES; d++) {
-		ide_drive_t *drive = hwif->devices[d];
-
+	ide_port_for_each_dev(i, drive, hwif) {
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
 			continue;
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -488,6 +488,7 @@ MODULE_PARM_DESC(ignore_cable, "ignore c
 
 void ide_port_apply_params(ide_hwif_t *hwif)
 {
+	ide_drive_t *drive;
 	int i;
 
 	if (ide_ignore_cable & (1 << hwif->index)) {
@@ -496,8 +497,8 @@ void ide_port_apply_params(ide_hwif_t *h
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
 
-	for (i = 0; i < MAX_DRIVES; i++)
-		ide_dev_apply_params(hwif->devices[i], i);
+	ide_port_for_each_dev(i, drive, hwif)
+		ide_dev_apply_params(drive, i);
 }
 
 /*
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -406,17 +406,17 @@ static int scc_dma_end(ide_drive_t *driv
 			data_loss = 1;
 			if (retry++) {
 				struct request *rq = hwif->rq;
-				int unit;
+				ide_drive_t *drive;
+				int i;
+
 				/* ERROR_RESET and drive->crc_count are needed
 				 * to reduce DMA transfer mode in retry process.
 				 */
 				if (rq)
 					rq->errors |= ERROR_RESET;
-				for (unit = 0; unit < MAX_DRIVES; unit++) {
-					ide_drive_t *drive = hwif->devices[unit];
 
+				ide_port_for_each_dev(i, drive, hwif)
 					drive->crc_count++;
-				}
 			}
 		}
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -753,7 +753,7 @@ typedef struct hwif_s {
 
 	unsigned long	sata_scr[SATA_NR_PORTS];
 
-	ide_drive_t	*devices[MAX_DRIVES];
+	ide_drive_t	*devices[MAX_DRIVES + 1];
 
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
@@ -860,7 +860,7 @@ typedef struct hwif_s {
 #define MAX_HOST_PORTS 4
 
 struct ide_host {
-	ide_hwif_t	*ports[MAX_HOST_PORTS];
+	ide_hwif_t	*ports[MAX_HOST_PORTS + 1];
 	unsigned int	n_ports;
 	struct device	*dev[2];
 	unsigned int	(*init_chipset)(struct pci_dev *);
@@ -1603,4 +1603,11 @@ static inline ide_drive_t *ide_get_pair_
 
 	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
+
+#define ide_port_for_each_dev(i, dev, port) \
+	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++)
+
+#define ide_host_for_each_port(i, port, host) \
+	for ((i) = 0; ((port) = (host)->ports[i]) || (i) < MAX_HOST_PORTS; (i)++)
+
 #endif /* _IDE_H */
