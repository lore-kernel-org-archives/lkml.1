Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXLTB6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXLTB6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXLTBhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbXLTBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IlUzvyywRd4czcv9bbQ4ehzLYpiN6gU7Cx6oQWr7MKYBaRwSSOh8JYXBvTFvRCkLfyEbqhOz+x7zt+BKChPsHcaqNcMgZ3oPWsiMadbN5VR/Dws05RPC84Bo54h6OA3isGmZW6ezd2Ba97aXiV4KX8UwtHr2lX6HycK70OVR8aw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 27/63] ide-cd: kill CDROM_STATE_FLAGS() macro
Date: Thu, 20 Dec 2007 02:13:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200213.03084.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While at it rename 'info' variable to 'cd' in cdrom_saw_media_change().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-49 bytes
 drivers/ide/ide-cd.c |   44 ++++++++++++++++++++++++--------------------
 drivers/ide/ide-cd.h |    2 --
 2 files changed, 24 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -93,11 +93,11 @@ static void ide_cd_put(struct cdrom_info
    buffers. */
 static void cdrom_saw_media_change (ide_drive_t *drive)
 {
-	struct cdrom_info *info = drive->driver_data;
-	
-	CDROM_STATE_FLAGS (drive)->media_changed = 1;
-	CDROM_STATE_FLAGS (drive)->toc_valid = 0;
-	info->nsectors_buffered = 0;
+	struct cdrom_info *cd = drive->driver_data;
+
+	cd->state_flags.media_changed = 1;
+	cd->state_flags.toc_valid = 0;
+	cd->nsectors_buffered = 0;
 }
 
 static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
@@ -1859,7 +1859,7 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 		stat = 0;
 
 	if (stat == 0)
-		CDROM_STATE_FLAGS(drive)->door_locked = lockflag;
+		cd->state_flags.door_locked = lockflag;
 
 	return stat;
 }
@@ -1879,7 +1879,7 @@ static int cdrom_eject(ide_drive_t *driv
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if (CDROM_STATE_FLAGS(drive)->door_locked && ejectflag)
+	if (cd->state_flags.door_locked && ejectflag)
 		return 0;
 
 	cdrom_prepare_request(drive, &req);
@@ -1977,7 +1977,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	   If it is, just return. */
 	(void) cdrom_check_status(drive, sense);
 
-	if (CDROM_STATE_FLAGS(drive)->toc_valid)
+	if (info->state_flags.toc_valid)
 		return 0;
 
 	/* Try to get the total cdrom capacity and sector size. */
@@ -2116,7 +2116,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	}
 
 	/* Remember that we've read this stuff. */
-	CDROM_STATE_FLAGS(drive)->toc_valid = 1;
+	info->state_flags.toc_valid = 1;
 
 	return 0;
 }
@@ -2198,7 +2198,7 @@ static int cdrom_get_toc_entry(ide_drive
 	/*
 	 * don't serve cached data, if the toc isn't valid
 	 */
-	if (!CDROM_STATE_FLAGS(drive)->toc_valid)
+	if (!info->state_flags.toc_valid)
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
@@ -2330,6 +2330,7 @@ static
 int ide_cdrom_reset (struct cdrom_device_info *cdi)
 {
 	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense sense;
 	struct request req;
 	int ret;
@@ -2343,7 +2344,7 @@ int ide_cdrom_reset (struct cdrom_device
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (CDROM_STATE_FLAGS(drive)->door_locked)
+	if (cd->state_flags.door_locked)
 		(void) cdrom_lockdoor(drive, 1, &sense);
 
 	return ret;
@@ -2413,7 +2414,7 @@ void ide_cdrom_update_speed (ide_drive_t
 		maxspeed = be16_to_cpu(cap->maxspeed);
 	}
 
-	CDROM_STATE_FLAGS(drive)->current_speed = (curspeed + (176/2)) / 176;
+	cd->state_flags.current_speed = (curspeed + (176/2)) / 176;
 	cd->config_flags.max_speed = (maxspeed + (176/2)) / 176;
 }
 
@@ -2421,6 +2422,7 @@ static
 int ide_cdrom_select_speed (struct cdrom_device_info *cdi, int speed)
 {
 	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense sense;
 	struct atapi_capabilities_page cap;
 	int stat;
@@ -2430,7 +2432,7 @@ int ide_cdrom_select_speed (struct cdrom
 
 	if (!ide_cdrom_get_capabilities(drive, &cap)) {
 		ide_cdrom_update_speed(drive, &cap);
-		cdi->speed = CDROM_STATE_FLAGS(drive)->current_speed;
+		cdi->speed = cd->state_flags.current_speed;
 	}
         return 0;
 }
@@ -2491,7 +2493,7 @@ int ide_cdrom_get_last_session (struct c
 	struct request_sense sense;
 	int ret;
 
-	if (!CDROM_STATE_FLAGS(drive)->toc_valid || info->toc == NULL)
+	if (!info->state_flags.toc_valid || info->toc == NULL)
 		if ((ret = cdrom_read_toc(drive, &sense)))
 			return ret;
 
@@ -2533,12 +2535,13 @@ int ide_cdrom_check_media_change_real (s
 				       int slot_nr)
 {
 	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
 	int retval;
-	
+
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = CDROM_STATE_FLAGS(drive)->media_changed;
-		CDROM_STATE_FLAGS(drive)->media_changed = 0;
+		retval = cd->state_flags.media_changed;
+		cd->state_flags.media_changed = 0;
 		return retval;
 	} else {
 		return -EINVAL;
@@ -2560,9 +2563,10 @@ static
 void ide_cdrom_release_real (struct cdrom_device_info *cdi)
 {
 	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
 
 	if (!cdi->use_count)
-		CDROM_STATE_FLAGS(drive)->toc_valid = 0;
+		cd->state_flags.toc_valid = 0;
 }
 
 #define IDE_CD_CAPABILITIES \
@@ -2594,7 +2598,7 @@ static int ide_cdrom_register (ide_drive
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
 	devinfo->ops = &ide_cdrom_dops;
-	devinfo->speed = CDROM_STATE_FLAGS(drive)->current_speed;
+	devinfo->speed = info->state_flags.current_speed;
 	devinfo->capacity = nslots;
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
@@ -2820,7 +2824,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	drive->special.all	= 0;
 
-	CDROM_STATE_FLAGS(drive)->media_changed = 1;
+	cd->state_flags.media_changed = 1;
 
 #if NO_DOOR_LOCKING
 	cd->config_flags.no_doorlock = 1;
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -80,8 +80,6 @@ struct ide_cd_state_flags {
 	byte current_speed;	/* Current speed of the drive */
 };
 
-#define CDROM_STATE_FLAGS(drive) (&(((struct cdrom_info *)(drive->driver_data))->state_flags))
-
 /* Structure of a MSF cdrom address. */
 struct atapi_msf {
 	byte reserved;
