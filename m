Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYAPXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYAPXVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbYAPXPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbYAPXPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GeBg0RwpKontps1cKryHoJ9tEXplcVZw+EdknnUx2UU+xQ4/9MsE+GiaDnEvi/hy9GsiwtzQVqGmOYPTyeQUcPPfWnDtkqL4dvsTMw1UbgmqsEvzifk2/wNJxIsesOkliiCpKFXKbOos0yqP8hVgq3m1qlTQnNMOoFmJNfLrdC4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:28:25 +0100
Message-Id: <20080116232825.9166.31653.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/22] ide: factor out devices setup from ide_acpi_init()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out devices setup from ide_acpi_init() to
  ide_acpi_port_init_devices().

* Call ide_acpi_port_init_devices() in ide_device_add_all().

While at it:
* Remove no longer needed 'drive' field from struct ide_acpi_drive_link.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c  |   49 +++++++++++++++++++-----------------------------
 drivers/ide/ide-probe.c |    1 
 include/linux/ide.h     |    2 +
 3 files changed, 23 insertions(+), 29 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -39,7 +39,6 @@ struct GTM_buffer {
 };
 
 struct ide_acpi_drive_link {
-	ide_drive_t	*drive;
 	acpi_handle	 obj_handle;
 	u8		 idbuff[512];
 };
@@ -675,11 +674,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif
  */
 void ide_acpi_init(ide_hwif_t *hwif)
 {
-	int unit;
-	int			err;
-	struct ide_acpi_drive_link	*master;
-	struct ide_acpi_drive_link	*slave;
-
 	ide_acpi_blacklist();
 
 	hwif->acpidata = kzalloc(sizeof(struct ide_acpi_hwif_link), GFP_KERNEL);
@@ -691,40 +685,38 @@ void ide_acpi_init(ide_hwif_t *hwif)
 		DEBPRINT("no ACPI object for %s found\n", hwif->name);
 		kfree(hwif->acpidata);
 		hwif->acpidata = NULL;
-		return;
 	}
+}
+
+void ide_acpi_port_init_devices(ide_hwif_t *hwif)
+{
+	ide_drive_t *drive;
+	int i, err;
+
+	if (hwif->acpidata == NULL)
+		return;
 
 	/*
 	 * The ACPI spec mandates that we send information
 	 * for both drives, regardless whether they are connected
 	 * or not.
 	 */
-	hwif->acpidata->master.drive = &hwif->drives[0];
 	hwif->drives[0].acpidata = &hwif->acpidata->master;
-	master = &hwif->acpidata->master;
-
-	hwif->acpidata->slave.drive = &hwif->drives[1];
 	hwif->drives[1].acpidata = &hwif->acpidata->slave;
-	slave = &hwif->acpidata->slave;
-
 
 	/*
 	 * Send IDENTIFY for each drive
 	 */
-	if (master->drive->present) {
-		err = taskfile_lib_get_identify(master->drive, master->idbuff);
-		if (err) {
-			DEBPRINT("identify device %s failed (%d)\n",
-				 master->drive->name, err);
-		}
-	}
+	for (i = 0; i < MAX_DRIVES; i++) {
+		drive = &hwif->drives[i];
+
+		if (!drive->present)
+			continue;
 
-	if (slave->drive->present) {
-		err = taskfile_lib_get_identify(slave->drive, slave->idbuff);
-		if (err) {
+		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
+		if (err)
 			DEBPRINT("identify device %s failed (%d)\n",
-				 slave->drive->name, err);
-		}
+				 drive->name, err);
 	}
 
 	if (ide_noacpionboot) {
@@ -740,12 +732,11 @@ void ide_acpi_init(ide_hwif_t *hwif)
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+	for (i = 0; i < MAX_DRIVES; i++) {
+		drive = &hwif->drives[i];
 
-		if (drive->present) {
+		if (drive->present)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
-		}
 	}
 }
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1430,6 +1430,7 @@ int ide_device_add_all(u8 idx[MAX_HWIFS]
 		}
 
 		ide_acpi_init(hwif);
+		ide_acpi_port_init_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1205,12 +1205,14 @@ extern int ide_acpi_exec_tfs(ide_drive_t
 extern void ide_acpi_get_timing(ide_hwif_t *hwif);
 extern void ide_acpi_push_timing(ide_hwif_t *hwif);
 extern void ide_acpi_init(ide_hwif_t *hwif);
+void ide_acpi_port_init_devices(ide_hwif_t *);
 extern void ide_acpi_set_state(ide_hwif_t *hwif, int on);
 #else
 static inline int ide_acpi_exec_tfs(ide_drive_t *drive) { return 0; }
 static inline void ide_acpi_get_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_push_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_init(ide_hwif_t *hwif) { ; }
+static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
