Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZAKTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZAKTL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZAKTKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:10:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:63160 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbZAKTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=A82GkPT7dbChFr+F7fnOwhmp2kUlUZ7P2JJpZY0SLSwRdepnPgstlsxK5BLsuL3SE2
         R036emuy1UfzvXHE9UTXH6hB8cbBF7B98VMBiBalc/1AijtNS82CZxaEKVsRel9KsI0e
         Ss7eRsXfah3RWe+K/CqVTwvjiOKD9VeMiX5HA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:11:33 +0100
Message-Id: <20090111191133.17361.73085.sendpatchset@localhost.localdomain>
In-Reply-To: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
References: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/8] ide-acpi: init ACPI handles early for devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-acpi: init ACPI handles early for devices

Init ACPI handles for devices in ide_acpi_port_init_devices()
and remove no longer needed ide_acpi_drive_get_handle().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |   65 +++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -208,40 +208,6 @@ static acpi_handle ide_acpi_hwif_get_han
 }
 
 /**
- * ide_acpi_drive_get_handle - Get ACPI object handle for a given drive
- * @drive: device to locate
- *
- * Retrieves the object handle of a given drive. According to the ACPI
- * spec the drive is a child of the hwif.
- *
- * Returns handle on success, 0 on error.
- */
-static acpi_handle ide_acpi_drive_get_handle(ide_drive_t *drive)
-{
-	ide_hwif_t	*hwif = drive->hwif;
-	int		 port;
-	acpi_handle	 drive_handle;
-
-	if (!hwif->acpidata)
-		return NULL;
-
-	if (!hwif->acpidata->obj_handle)
-		return NULL;
-
-	port = hwif->channel ? drive->dn - 2: drive->dn;
-
-	DEBPRINT("ENTER: %s at channel#: %d port#: %d\n",
-		 drive->name, hwif->channel, port);
-
-
-	/* TBD: could also check ACPI object VALID bits */
-	drive_handle = acpi_get_child(hwif->acpidata->obj_handle, port);
-	DEBPRINT("drive %s handle 0x%p\n", drive->name, drive_handle);
-
-	return drive_handle;
-}
-
-/**
  * do_drive_get_GTF - get the drive bootup default taskfile settings
  * @drive: the drive for which the taskfile settings should be retrieved
  * @gtf_length: number of bytes of _GTF data returned at @gtf_address
@@ -296,14 +262,9 @@ static int do_drive_get_GTF(ide_drive_t 
 		goto out;
 	}
 
-	/* Get this drive's _ADR info. if not already known. */
 	if (!drive->acpidata->obj_handle) {
-		drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
-		if (!drive->acpidata->obj_handle) {
-			DEBPRINT("No ACPI object found for %s\n",
-				 drive->name);
-			goto out;
-		}
+		DEBPRINT("No ACPI object found for %s\n", drive->name);
+		goto out;
 	}
 
 	/* Setting up output buffer */
@@ -658,9 +619,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
 
 	ide_port_for_each_dev(i, drive, hwif) {
-		if (!drive->acpidata->obj_handle)
-			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
-
 		if (drive->acpidata->obj_handle &&
 		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
 			acpi_bus_set_power(drive->acpidata->obj_handle,
@@ -714,6 +672,25 @@ void ide_acpi_port_init_devices(ide_hwif
 	hwif->devices[0]->acpidata = &hwif->acpidata->master;
 	hwif->devices[1]->acpidata = &hwif->acpidata->slave;
 
+	/* get _ADR info for each device */
+	ide_port_for_each_dev(i, drive, hwif) {
+		acpi_handle dev_handle;
+
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+			continue;
+
+		DEBPRINT("ENTER: %s at channel#: %d port#: %d\n",
+			 drive->name, hwif->channel, drive->dn & 1);
+
+		/* TBD: could also check ACPI object VALID bits */
+		dev_handle = acpi_get_child(hwif->acpidata->obj_handle,
+					    drive->dn & 1);
+
+		DEBPRINT("drive %s handle 0x%p\n", drive->name, dev_handle);
+
+		drive->acpidata->obj_handle = dev_handle;
+	}
+
 	/*
 	 * Send IDENTIFY for each drive
 	 */
