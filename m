Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbYLUVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbYLUVCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYLUVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:00:45 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34166 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYLUVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eKymElZzXCEDM8OFX48F+kOkJi4sENm+Y3CERGinhZYym0wgs1Cnj0FRD5J5ECvmO9
         0zkVR1LcFqrF2VnqJlfARkPDMF7kER7kaZpCyDpffaqD4BKeBVKo4Y6P/RbOHD6vciNh
         9/G4/ezMwvsGn9IWs/YedLM6QKtwAVjG8SDHI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 22:00:42 +0100
Message-Id: <20081221210042.23795.65249.sendpatchset@localhost.localdomain>
In-Reply-To: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
References: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/7] ide: dynamic allocation of device structures
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: dynamic allocation of device structures

Allocate device structures dynamically instead of having them embedded
in ide_hwif_t:

* Remove needless zeroing of port structure from ide_init_port_data().

* Add ide_hwif_t.devices[MAX_DRIVES] (table of pointers to the devices).

* Add ide_port_{alloc,free}_devices() helpers and use them respectively
  in ide_{host,free}_alloc().

* Convert all users of ->drives[] to use ->devices[] instead.

While at it:

* Use drive->dn for the slave device check in scc_pata.c.

As a nice side-effect this patch cuts ~1kB (x86-32) from the resulting
code size:

   text    data     bss     dec     hex filename
  53963    1244     237   55444    d894 drivers/ide/ide-core.o.before
  52981    1244     237   54462    d4be drivers/ide/ide-core.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c  |   10 +++---
 drivers/ide/ide-iops.c  |    4 +-
 drivers/ide/ide-probe.c |   71 ++++++++++++++++++++++++++++++++++--------------
 drivers/ide/ide-proc.c  |    2 -
 drivers/ide/ide.c       |    2 -
 drivers/ide/scc_pata.c  |    5 ++-
 include/linux/ide.h     |    4 +-
 7 files changed, 65 insertions(+), 33 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -656,7 +656,7 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 	if (on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		if (!drive->acpidata->obj_handle)
 			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
@@ -711,14 +711,14 @@ void ide_acpi_port_init_devices(ide_hwif
 	 * for both drives, regardless whether they are connected
 	 * or not.
 	 */
-	hwif->drives[0].acpidata = &hwif->acpidata->master;
-	hwif->drives[1].acpidata = &hwif->acpidata->slave;
+	hwif->devices[0]->acpidata = &hwif->acpidata->master;
+	hwif->devices[1]->acpidata = &hwif->acpidata->slave;
 
 	/*
 	 * Send IDENTIFY for each drive
 	 */
 	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = &hwif->drives[i];
+		drive = hwif->devices[i];
 
 		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
 
@@ -745,7 +745,7 @@ void ide_acpi_port_init_devices(ide_hwif
 	ide_acpi_push_timing(hwif);
 
 	for (i = 0; i < MAX_DRIVES; i++) {
-		drive = &hwif->drives[i];
+		drive = hwif->devices[i];
 
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			/* Execute ACPI startup code */
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1111,7 +1111,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
 		for (unit = 0; unit < MAX_DRIVES; unit++) {
-			ide_drive_t *tdrive = &hwif->drives[unit];
+			ide_drive_t *tdrive = hwif->devices[unit];
 
 			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
 			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
@@ -1134,7 +1134,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * for any of the drives on this interface.
 	 */
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
-		pre_reset(&hwif->drives[unit]);
+		pre_reset(hwif->devices[unit]);
 
 	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&hwif->lock, flags);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -463,7 +463,7 @@ static int do_probe (ide_drive_t *drive,
 	if (ide_read_device(drive) != drive->select && present == 0) {
 		if (drive->dn & 1) {
 			/* exit with drive0 selected */
-			SELECT_DRIVE(&hwif->drives[0]);
+			SELECT_DRIVE(hwif->devices[0]);
 			/* allow ATA_BUSY to assert & clear */
 			msleep(50);
 		}
@@ -509,7 +509,7 @@ static int do_probe (ide_drive_t *drive,
 	}
 	if (drive->dn & 1) {
 		/* exit with drive0 selected */
-		SELECT_DRIVE(&hwif->drives[0]);
+		SELECT_DRIVE(hwif->devices[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
 		(void)tp_ops->read_status(hwif);
@@ -715,7 +715,7 @@ static int ide_port_wait_ready(ide_hwif_
 
 	/* Now make sure both master & slave are ready */
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		/* Ignore disks that we will not probe for later. */
 		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
@@ -733,7 +733,7 @@ static int ide_port_wait_ready(ide_hwif_
 out:
 	/* Exit function with master reselected (let's be sane) */
 	if (unit)
-		SELECT_DRIVE(&hwif->drives[0]);
+		SELECT_DRIVE(hwif->devices[0]);
 
 	return rc;
 }
@@ -749,7 +749,7 @@ out:
 
 void ide_undecoded_slave(ide_drive_t *dev1)
 {
-	ide_drive_t *dev0 = &dev1->hwif->drives[0];
+	ide_drive_t *dev0 = dev1->hwif->devices[0];
 
 	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return;
@@ -784,8 +784,8 @@ static int ide_probe_port(ide_hwif_t *hw
 
 	BUG_ON(hwif->present);
 
-	if ((hwif->drives[0].dev_flags & IDE_DFLAG_NOPROBE) &&
-	    (hwif->drives[1].dev_flags & IDE_DFLAG_NOPROBE))
+	if ((hwif->devices[0]->dev_flags & IDE_DFLAG_NOPROBE) &&
+	    (hwif->devices[1]->dev_flags & IDE_DFLAG_NOPROBE))
 		return -EACCES;
 
 	/*
@@ -807,7 +807,7 @@ static int ide_probe_port(ide_hwif_t *hw
 	 * but a lot of cdrom drives are configured as single slaves.
 	 */
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		(void) probe_for_drive(drive);
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
@@ -832,7 +832,7 @@ static void ide_port_tune_devices(ide_hw
 	int unit;
 
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			if (port_ops && port_ops->quirkproc)
@@ -841,7 +841,7 @@ static void ide_port_tune_devices(ide_hw
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			ide_set_max_pio(drive);
@@ -854,7 +854,7 @@ static void ide_port_tune_devices(ide_hw
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 
 		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
 		    drive->id[ATA_ID_DWORD_IO])
@@ -931,7 +931,7 @@ static int ide_port_setup_devices(ide_hw
 
 	mutex_lock(&ide_cfg_mtx);
 	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
+		ide_drive_t *drive = hwif->devices[i];
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
@@ -1017,7 +1017,7 @@ static struct kobject *ata_probe(dev_t d
 {
 	ide_hwif_t *hwif = data;
 	int unit = *part >> PARTN_BITS;
-	ide_drive_t *drive = &hwif->drives[unit];
+	ide_drive_t *drive = hwif->devices[unit];
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return NULL;
@@ -1164,7 +1164,7 @@ static void hwif_register_devices(ide_hw
 	unsigned int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
+		ide_drive_t *drive = hwif->devices[i];
 		struct device *dev = &drive->gendev;
 		int ret;
 
@@ -1190,7 +1190,7 @@ static void ide_port_init_devices(ide_hw
 	int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
+		ide_drive_t *drive = hwif->devices[i];
 
 		drive->dn = i + hwif->channel * 2;
 
@@ -1285,7 +1285,7 @@ static void ide_port_init_devices_data(i
 	int unit;
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+		ide_drive_t *drive = hwif->devices[unit];
 		u8 j = (hwif->index * MAX_DRIVES) + unit;
 
 		memset(drive, 0, sizeof(*drive));
@@ -1309,9 +1309,6 @@ static void ide_port_init_devices_data(i
 
 static void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 {
-	/* bulk initialize hwif & drive info with zeros */
-	memset(hwif, 0, sizeof(ide_hwif_t));
-
 	/* fill in any non-zero initial values */
 	hwif->index	= index;
 	hwif->major	= ide_hwif_to_major[index];
@@ -1388,6 +1385,34 @@ static void ide_free_port_slot(int idx)
 	mutex_unlock(&ide_cfg_mtx);
 }
 
+static void ide_port_free_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++)
+		kfree(hwif->devices[i]);
+}
+
+static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive;
+
+		drive = kzalloc_node(sizeof(*drive), GFP_KERNEL, node);
+		if (drive == NULL)
+			goto out_nomem;
+
+		hwif->devices[i] = drive;
+	}
+	return 0;
+
+out_nomem:
+	ide_port_free_devices(hwif);
+	return -ENOMEM;
+}
+
 struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 {
 	struct ide_host *host;
@@ -1410,6 +1435,11 @@ struct ide_host *ide_host_alloc(const st
 		if (hwif == NULL)
 			continue;
 
+		if (ide_port_alloc_devices(hwif, node) < 0) {
+			kfree(hwif);
+			continue;
+		}
+
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
 			printk(KERN_ERR "%s: no free slot for interface\n",
@@ -1575,7 +1605,7 @@ static void __ide_port_unregister_device
 	int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive = &hwif->drives[i];
+		ide_drive_t *drive = hwif->devices[i];
 
 		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			device_unregister(&drive->gendev);
@@ -1651,6 +1681,7 @@ void ide_host_free(struct ide_host *host
 		if (hwif == NULL)
 			continue;
 
+		ide_port_free_devices(hwif);
 		ide_free_port_slot(hwif->index);
 		kfree(hwif);
 	}
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -599,7 +599,7 @@ void ide_proc_port_register_devices(ide_
 	char name[64];
 
 	for (d = 0; d < MAX_DRIVES; d++) {
-		ide_drive_t *drive = &hwif->drives[d];
+		ide_drive_t *drive = hwif->devices[d];
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
 			continue;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -497,7 +497,7 @@ void ide_port_apply_params(ide_hwif_t *h
 	}
 
 	for (i = 0; i < MAX_DRIVES; i++)
-		ide_dev_apply_params(&hwif->drives[i], i);
+		ide_dev_apply_params(hwif->devices[i], i);
 }
 
 /*
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -259,7 +259,7 @@ static void scc_set_dma_mode(ide_drive_t
 	unsigned long scrcst_port = ctl_base + 0x014;
 	unsigned long udenvt_port = ctl_base + 0x018;
 	unsigned long tdvhsel_port   = ctl_base + 0x020;
-	int is_slave = (&hwif->drives[1] == drive);
+	int is_slave = drive->dn & 1;
 	int offset, idx;
 	unsigned long reg;
 	unsigned long jcactsel;
@@ -413,7 +413,8 @@ static int scc_dma_end(ide_drive_t *driv
 				if (rq)
 					rq->errors |= ERROR_RESET;
 				for (unit = 0; unit < MAX_DRIVES; unit++) {
-					ide_drive_t *drive = &hwif->drives[unit];
+					ide_drive_t *drive = hwif->devices[unit];
+
 					drive->crc_count++;
 				}
 			}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -753,7 +753,7 @@ typedef struct hwif_s {
 
 	unsigned long	sata_scr[SATA_NR_PORTS];
 
-	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
+	ide_drive_t	*devices[MAX_DRIVES];
 
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
@@ -1599,7 +1599,7 @@ static inline int hwif_to_node(ide_hwif_
 
 static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 {
-	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
+	ide_drive_t *peer = drive->hwif->devices[(drive->dn ^ 1) & 1];
 
 	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
