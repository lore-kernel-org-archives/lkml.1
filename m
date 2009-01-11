Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZAKTLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZAKTLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAKTKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:10:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:36460 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZAKTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OJOGO7pvHwFORHvhrppWykM891f/bBXN4PKsPcYvQn8bFOac9UXMZp8VFa2+vqJdW1
         1S8NAsYQ2zaCWWmVWp66cyYvZ7ubiK6dP4WKSzlZDcrQu5hmryzVzxGuBYY8SrvK0+oI
         6gREFR80u6+5FESpy/zvSt7yvaCrhvNzSLe3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:11:40 +0100
Message-Id: <20090111191140.17361.43805.sendpatchset@localhost.localdomain>
In-Reply-To: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
References: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] ide: add ide_for_each_present_dev() iterator
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ide_for_each_present_dev() iterator

* Add ide_for_each_present_dev() iterator and convert IDE code to use it.

* Do some drive-by CodingStyle fixups in ide-acpi.c while at it.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c  |   30 ++++++++++--------------------
 drivers/ide/ide-iops.c  |    5 ++---
 drivers/ide/ide-probe.c |   38 +++++++++++++-------------------------
 include/linux/ide.h     |    4 ++++
 4 files changed, 29 insertions(+), 48 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -614,17 +614,17 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 		DEBPRINT("no ACPI data for %s\n", hwif->name);
 		return;
 	}
+
 	/* channel first and then drives for power on and verse versa for power off */
 	if (on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->acpidata->obj_handle &&
-		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		if (drive->acpidata->obj_handle)
 			acpi_bus_set_power(drive->acpidata->obj_handle,
-				on? ACPI_STATE_D0: ACPI_STATE_D3);
-		}
+					   on ? ACPI_STATE_D0 : ACPI_STATE_D3);
 	}
+
 	if (!on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
 }
@@ -673,12 +673,9 @@ void ide_acpi_port_init_devices(ide_hwif
 	hwif->devices[1]->acpidata = &hwif->acpidata->slave;
 
 	/* get _ADR info for each device */
-	ide_port_for_each_dev(i, drive, hwif) {
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		acpi_handle dev_handle;
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
 		DEBPRINT("ENTER: %s at channel#: %d port#: %d\n",
 			 drive->name, hwif->channel, drive->dn & 1);
 
@@ -691,13 +688,8 @@ void ide_acpi_port_init_devices(ide_hwif
 		drive->acpidata->obj_handle = dev_handle;
 	}
 
-	/*
-	 * Send IDENTIFY for each drive
-	 */
-	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
+	/* send IDENTIFY for each device */
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
 		if (err)
 			DEBPRINT("identify device %s failed (%d)\n",
@@ -717,9 +709,7 @@ void ide_acpi_port_init_devices(ide_hwif
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT)
-			/* Execute ACPI startup code */
-			ide_acpi_exec_tfs(drive);
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_acpi_exec_tfs(drive);
 	}
 }
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1101,9 +1101,8 @@ static ide_startstop_t do_reset1 (ide_dr
 
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
-		ide_port_for_each_dev(i, tdrive, hwif) {
-			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
-			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
+		ide_port_for_each_present_dev(i, tdrive, hwif) {
+			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
 			    time_after(tdrive->sleep, timeout))
 				timeout = tdrive->sleep;
 		}
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -824,22 +824,18 @@ static void ide_port_tune_devices(ide_hw
 	ide_drive_t *drive;
 	int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			if (port_ops && port_ops->quirkproc)
-				port_ops->quirkproc(drive);
-		}
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		if (port_ops && port_ops->quirkproc)
+			port_ops->quirkproc(drive);
 	}
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			ide_set_max_pio(drive);
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		ide_set_max_pio(drive);
 
-			drive->dev_flags |= IDE_DFLAG_NICE1;
+		drive->dev_flags |= IDE_DFLAG_NICE1;
 
-			if (hwif->dma_ops)
-				ide_set_dma(drive);
-		}
+		if (hwif->dma_ops)
+			ide_set_dma(drive);
 	}
 }
 
@@ -910,10 +906,7 @@ static int ide_port_setup_devices(ide_hw
 	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (ide_init_queue(drive)) {
 			printk(KERN_ERR "ide: failed to init %s\n",
 					drive->name);
@@ -1125,13 +1118,10 @@ static void hwif_register_devices(ide_hw
 	ide_drive_t *drive;
 	unsigned int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
+	ide_port_for_each_present_dev(i, drive, hwif) {
 		struct device *dev = &drive->gendev;
 		int ret;
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
 		dev_set_name(dev, "%u.%u", hwif->index, i);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
@@ -1574,11 +1564,9 @@ static void __ide_port_unregister_device
 	ide_drive_t *drive;
 	int i;
 
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
-			device_unregister(&drive->gendev);
-			wait_for_completion(&drive->gendev_rel_comp);
-		}
+	ide_port_for_each_present_dev(i, drive, hwif) {
+		device_unregister(&drive->gendev);
+		wait_for_completion(&drive->gendev_rel_comp);
 	}
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1607,6 +1607,10 @@ static inline ide_drive_t *ide_get_pair_
 #define ide_port_for_each_dev(i, dev, port) \
 	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++)
 
+#define ide_port_for_each_present_dev(i, dev, port) \
+	for ((i) = 0; ((dev) = (port)->devices[i]) || (i) < MAX_DRIVES; (i)++) \
+		if ((dev)->dev_flags & IDE_DFLAG_PRESENT)
+
 #define ide_host_for_each_port(i, port, host) \
 	for ((i) = 0; ((port) = (host)->ports[i]) || (i) < MAX_HOST_PORTS; (i)++)
 
