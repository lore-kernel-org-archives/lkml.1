Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXLTBm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXLTBm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbXLTBfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbXLTBec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oPaMk6ZjpmhbU603CSOLTQk4oOtJMXt3jQjiRaGm0BymElDOKXT2RFBkJUOIYBX1iXPp9KOP4+6/y8rA9JAFE1g3cSMDZLsz0Xoosu08LXps8+wZ7TNdQ/xQ7bG/2NvYCroVWy3Z27EO6WbRRHYQRVlhmICM2be1dlOTCtTLroY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 26/63] ide-cd: kill CDROM_CONFIG_FLAGS() macro
Date: Thu, 20 Dec 2007 02:12:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200212.25036.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While at it rename 'info' variable to 'cd' in
ide_cdrom_probe_capabilities() and ide_cdrom_setup().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-47 bytes
 drivers/ide/ide-cd.c |   96 ++++++++++++++++++++++++++-------------------------
 drivers/ide/ide-cd.h |    2 -
 2 files changed, 50 insertions(+), 48 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -657,8 +657,8 @@ static ide_startstop_t cdrom_start_packe
 	/* Set up the controller registers. */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
 			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
- 
-	if (CDROM_CONFIG_FLAGS (drive)->drq_interrupt) {
+
+	if (info->config_flags.drq_interrupt) {
 		/* waiting for CDB interrupt, not DMA yet. */
 		if (info->dma)
 			drive->waiting_for_dma = 0;
@@ -694,7 +694,7 @@ static ide_startstop_t cdrom_transfer_pa
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
-	if (CDROM_CONFIG_FLAGS(drive)->drq_interrupt) {
+	if (info->config_flags.drq_interrupt) {
 		/* Here we should have been called after receiving an interrupt
 		   from the device.  DRQ should how be set. */
 
@@ -893,11 +893,11 @@ static ide_startstop_t cdrom_read_intr (
 	if ((len % SECTOR_SIZE) != 0) {
 		printk (KERN_ERR "%s: cdrom_read_intr: Bad transfer size %d\n",
 			drive->name, len);
-		if (CDROM_CONFIG_FLAGS(drive)->limit_nframes)
+		if (info->config_flags.limit_nframes)
 			printk (KERN_ERR "  This drive is not supported by this version of the driver\n");
 		else {
 			printk (KERN_ERR "  Trying to limit transfer sizes\n");
-			CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
+			info->config_flags.limit_nframes = 1;
 		}
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
@@ -1073,7 +1073,8 @@ static ide_startstop_t cdrom_seek_intr (
 
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
-	CDROM_CONFIG_FLAGS(drive)->seeking = 1;
+
+	info->config_flags.seeking = 1;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0) {
@@ -1700,7 +1701,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 	struct cdrom_info *info = drive->driver_data;
 
 	if (blk_fs_request(rq)) {
-		if (CDROM_CONFIG_FLAGS(drive)->seeking) {
+		if (info->config_flags.seeking) {
 			unsigned long elapsed = jiffies - info->start_seek;
 			int stat = HWIF(drive)->INB(IDE_STATUS_REG);
 
@@ -1711,7 +1712,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 				}
 				printk (KERN_ERR "%s: DSC timeout\n", drive->name);
 			}
-			CDROM_CONFIG_FLAGS(drive)->seeking = 0;
+			info->config_flags.seeking = 0;
 		}
 		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) 
&& drive->dsc_overlap) {
 			action = cdrom_start_seek(drive, block);
@@ -1823,6 +1824,7 @@ static int cdrom_check_status(ide_drive_
 static int
 cdrom_lockdoor(ide_drive_t *drive, int lockflag, struct request_sense *sense)
 {
+	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
 	struct request req;
 	int stat;
@@ -1831,7 +1833,7 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if (CDROM_CONFIG_FLAGS(drive)->no_doorlock) {
+	if (cd->config_flags.no_doorlock) {
 		stat = 0;
 	} else {
 		cdrom_prepare_request(drive, &req);
@@ -1848,7 +1850,7 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
 		printk (KERN_ERR "%s: door locking not supported\n",
 			drive->name);
-		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
+		cd->config_flags.no_doorlock = 1;
 		stat = 0;
 	}
 	
@@ -1873,9 +1875,9 @@ static int cdrom_eject(ide_drive_t *driv
 	struct request req;
 	char loej = 0x02;
 
-	if (CDROM_CONFIG_FLAGS(drive)->no_eject && !ejectflag)
+	if (cd->config_flags.no_eject && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
-	
+
 	/* reload fails on some drives, if the tray is locked */
 	if (CDROM_STATE_FLAGS(drive)->door_locked && ejectflag)
 		return 0;
@@ -1998,7 +2000,7 @@ static int cdrom_read_toc(ide_drive_t *d
 		return stat;
 
 #if ! STANDARD_ATAPI
-	if (CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd) {
+	if (info->config_flags.toctracks_as_bcd) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -2038,7 +2040,7 @@ static int cdrom_read_toc(ide_drive_t *d
 			return stat;
 		}
 #if ! STANDARD_ATAPI
-		if (CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd) {
+		if (info->config_flags.toctracks_as_bcd) {
 			toc->hdr.first_track = bin2bcd(CDROM_LEADOUT);
 			toc->hdr.last_track = bin2bcd(CDROM_LEADOUT);
 		} else
@@ -2055,7 +2057,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
 
 #if ! STANDARD_ATAPI
-	if (CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd) {
+	if (info->config_flags.toctracks_as_bcd) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -2063,8 +2065,8 @@ static int cdrom_read_toc(ide_drive_t *d
 
 	for (i=0; i<=ntracks; i++) {
 #if ! STANDARD_ATAPI
-		if (CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd) {
-			if (CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd)
+		if (info->config_flags.tocaddr_as_bcd) {
+			if (info->config_flags.toctracks_as_bcd)
 				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -2089,7 +2091,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	}
 
 #if ! STANDARD_ATAPI
-	if (CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd) {
+	if (info->config_flags.tocaddr_as_bcd) {
 		/* Re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -2398,6 +2400,7 @@ int ide_cdrom_get_capabilities(ide_drive
 static
 void ide_cdrom_update_speed (ide_drive_t *drive, struct atapi_capabilities_page *cap)
 {
+	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
 	/* The ACER/AOpen 24X cdrom has the speed fields byte-swapped */
@@ -2411,7 +2414,7 @@ void ide_cdrom_update_speed (ide_drive_t
 	}
 
 	CDROM_STATE_FLAGS(drive)->current_speed = (curspeed + (176/2)) / 176;
-	CDROM_CONFIG_FLAGS(drive)->max_speed = (maxspeed + (176/2)) / 176;
+	cd->config_flags.max_speed = (maxspeed + (176/2)) / 176;
 }
 
 static
@@ -2596,7 +2599,7 @@ static int ide_cdrom_register (ide_drive
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (CDROM_CONFIG_FLAGS(drive)->no_speed_select)
+	if (info->config_flags.no_speed_select)
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -2606,8 +2609,8 @@ static int ide_cdrom_register (ide_drive
 static
 int ide_cdrom_probe_capabilities (ide_drive_t *drive)
 {
-	struct cdrom_info *info = drive->driver_data;
-	struct cdrom_device_info *cdi = &info->devinfo;
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_device_info *cdi = &cd->devinfo;
 	struct atapi_capabilities_page cap;
 	int nslots = 1;
 
@@ -2621,9 +2624,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 		return nslots;
 	}
 
-	if (CDROM_CONFIG_FLAGS(drive)->nec260 ||
+	if (cd->config_flags.nec260 ||
 	    !strcmp(drive->id->model,"STINGRAY 8422 IDE 8X CD-ROM 7-27-95")) {
-		CDROM_CONFIG_FLAGS(drive)->no_eject = 0;
+		cd->config_flags.no_eject = 0;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
 	}
@@ -2642,9 +2645,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 		return 0;
 
 	if (cap.lock == 0)
-		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
+		cd->config_flags.no_doorlock = 1;
 	if (cap.eject)
-		CDROM_CONFIG_FLAGS(drive)->no_eject = 0;
+		cd->config_flags.no_eject = 0;
 	if (cap.cd_r_write)
 		cdi->mask &= ~CDC_CD_R;
 	if (cap.cd_rw_write)
@@ -2685,11 +2688,13 @@ int ide_cdrom_probe_capabilities (ide_dr
 	}
 
 	ide_cdrom_update_speed(drive, &cap);
-	/* don't print speed if the drive reported 0.
-	 */
+
 	printk(KERN_INFO "%s: ATAPI", drive->name);
-	if (CDROM_CONFIG_FLAGS(drive)->max_speed)
-		printk(" %dX", CDROM_CONFIG_FLAGS(drive)->max_speed);
+
+	/* don't print speed if the drive reported 0 */
+	if (cd->config_flags.max_speed)
+		printk(KERN_CONT " %dX", cd->config_flags.max_speed);
+
 	printk(KERN_CONT " %s", (cdi->mask & CDC_DVD) ? "CD-ROM" : "DVD-ROM");
 
 	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
@@ -2803,8 +2808,8 @@ static int ide_cdrom_prep_fn(struct requ
 static
 int ide_cdrom_setup (ide_drive_t *drive)
 {
-	struct cdrom_info *info = drive->driver_data;
-	struct cdrom_device_info *cdi = &info->devinfo;
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_device_info *cdi = &cd->devinfo;
 	int nslots;
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
@@ -2818,21 +2823,20 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	CDROM_STATE_FLAGS(drive)->media_changed = 1;
 
 #if NO_DOOR_LOCKING
-	CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
+	cd->config_flags.no_doorlock = 1;
 #endif
 	if ((drive->id->config & 0x0060) == 0x20)
-		CDROM_CONFIG_FLAGS(drive)->drq_interrupt = 1;
-	CDROM_CONFIG_FLAGS(drive)->no_eject = 1;
+		cd->config_flags.drq_interrupt = 1;
+	cd->config_flags.no_eject = 1;
 
 	/* limit transfer size per interrupt. */
 	/* a testament to the nice quality of Samsung drives... */
-	if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2430"))
-		CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
-	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2432"))
-		CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
+	if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2430") ||
+	    !strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2432"))
+		cd->config_flags.limit_nframes = 1;
 	/* the 3231 model does not support the SET_CD_SPEED command */
 	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
-		CDROM_CONFIG_FLAGS(drive)->no_speed_select = 1;
+		cd->config_flags.no_speed_select = 1;
 
 #if ! STANDARD_ATAPI
 	if (strcmp (drive->id->model, "V003S0DS") == 0 &&
@@ -2840,22 +2844,22 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	    drive->id->fw_rev[6] <= '2') {
 		/* Vertos 300.
 		   Some versions of this drive like to talk BCD. */
-		CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd = 1;
+		cd->config_flags.toctracks_as_bcd = 1;
+		cd->config_flags.tocaddr_as_bcd = 1;
 	}
 	else if (strcmp (drive->id->model, "V006E0DS") == 0 &&
 	    drive->id->fw_rev[4] == '1' &&
 	    drive->id->fw_rev[6] <= '2') {
 		/* Vertos 600 ESD. */
-		CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd = 1;
+		cd->config_flags.toctracks_as_bcd = 1;
 	}
 	else if (strcmp(drive->id->model, "NEC CD-ROM DRIVE:260") == 0 &&
 		 strncmp(drive->id->fw_rev, "1.01", 4) == 0) { /* FIXME */
 		/* Old NEC260 (not R).
 		   This drive was released before the 1.2 version
 		   of the spec. */
-		CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->nec260         = 1;
+		cd->config_flags.tocaddr_as_bcd = 1;
+		cd->config_flags.nec260 = 1;
 	}
 	/*
 	 * Sanyo 3 CD changer uses a non-standard command for CD changing
@@ -2882,7 +2886,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk (KERN_ERR "%s: ide_cdrom_setup failed to register device with the cdrom driver.\n", 
drive->name);
-		info->devinfo.handle = NULL;
+		cd->devinfo.handle = NULL;
 		return 1;
 	}
 	ide_cdrom_add_settings(drive);
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -68,9 +68,7 @@ struct ide_cd_config_flags {
 	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
 	byte max_speed;		     /* Max speed of the drive */
 };
-#define CDROM_CONFIG_FLAGS(drive) (&(((struct cdrom_info *)(drive->driver_data))->config_flags))
 
- 
 /* State flags.  These give information about the current state of the
    drive, and will change during normal operation. */
 struct ide_cd_state_flags {
