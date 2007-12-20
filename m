Return-Path: <linux-kernel-owner+w=401wt.eu-S1762376AbXLTB52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376AbXLTB52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbXLTBhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbXLTBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OilsGVzQwaPBBeF9JJ99uNhsQDRwYe1LIbU50gAStUe61lzTqFhOAM8S3NVcxMCpzNhnnJDl23jlEtS1HwX0ojF6vCM6FizQGgIwRLIx9nsFUOLXGJc1pnS04EHW3lVRCwsqr8ppf+rhLhSNqLAQr/d2mtvuLKU4ktTEqyWrPuk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 29/63] ide-cd: remove struct ide_cd_{config,state}_flags
Date: Thu, 20 Dec 2007 02:14:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200214.39112.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remove unused ->{writing,reserved} fields from struct ide_cd_config_flags.

* Move ->max_speed from struct ide_cd_config_flags to struct cdrom_info.

* Move ->current_speed from struct ide_cd_state_flags to struct cdrom_info.

* Add defines for config and state flags.

* Add 'unsigned int cd_flags' to struct cdrom_info and use ->cd_flags
  instead of ->{config,state}_flags.

* Remove no longer needed struct ide_cd_{config,state}_flags.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-45 bytes
 drivers/ide/ide-cd.c |  106 ++++++++++++++++++++++++++-------------------------
 drivers/ide/ide-cd.h |   62 +++++++++++++++--------------
 2 files changed, 87 insertions(+), 81 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -95,8 +95,8 @@ static void cdrom_saw_media_change (ide_
 {
 	struct cdrom_info *cd = drive->driver_data;
 
-	cd->state_flags.media_changed = 1;
-	cd->state_flags.toc_valid = 0;
+	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
+	cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
 	cd->nsectors_buffered = 0;
 }
 
@@ -658,7 +658,7 @@ static ide_startstop_t cdrom_start_packe
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
 			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
 
-	if (info->config_flags.drq_interrupt) {
+	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
 		if (info->dma)
 			drive->waiting_for_dma = 0;
@@ -694,7 +694,7 @@ static ide_startstop_t cdrom_transfer_pa
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
-	if (info->config_flags.drq_interrupt) {
+	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
 		/* Here we should have been called after receiving an interrupt
 		   from the device.  DRQ should how be set. */
 
@@ -893,11 +893,11 @@ static ide_startstop_t cdrom_read_intr (
 	if ((len % SECTOR_SIZE) != 0) {
 		printk (KERN_ERR "%s: cdrom_read_intr: Bad transfer size %d\n",
 			drive->name, len);
-		if (info->config_flags.limit_nframes)
+		if (info->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
 			printk (KERN_ERR "  This drive is not supported by this version of the driver\n");
 		else {
 			printk (KERN_ERR "  Trying to limit transfer sizes\n");
-			info->config_flags.limit_nframes = 1;
+			info->cd_flags |= IDE_CD_FLAG_LIMIT_NFRAMES;
 		}
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
@@ -1074,7 +1074,7 @@ static ide_startstop_t cdrom_seek_intr (
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
-	info->config_flags.seeking = 1;
+	info->cd_flags |= IDE_CD_FLAG_SEEKING;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0) {
@@ -1701,7 +1701,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 	struct cdrom_info *info = drive->driver_data;
 
 	if (blk_fs_request(rq)) {
-		if (info->config_flags.seeking) {
+		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
 			unsigned long elapsed = jiffies - info->start_seek;
 			int stat = HWIF(drive)->INB(IDE_STATUS_REG);
 
@@ -1712,7 +1712,7 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
 				}
 				printk (KERN_ERR "%s: DSC timeout\n", drive->name);
 			}
-			info->config_flags.seeking = 0;
+			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
 		}
 		if ((rq_data_dir(rq) == READ) && IDE_LARGE_SEEK(info->last_block, block, IDECD_SEEK_THRESHOLD) 
&& drive->dsc_overlap) {
 			action = cdrom_start_seek(drive, block);
@@ -1833,7 +1833,7 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if (cd->config_flags.no_doorlock) {
+	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
 		stat = 0;
 	} else {
 		cdrom_prepare_request(drive, &req);
@@ -1850,7 +1850,7 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
 		printk (KERN_ERR "%s: door locking not supported\n",
 			drive->name);
-		cd->config_flags.no_doorlock = 1;
+		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
 		stat = 0;
 	}
 	
@@ -1858,8 +1858,12 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 	if (stat != 0 && sense->sense_key == NOT_READY && sense->asc == 0x3a)
 		stat = 0;
 
-	if (stat == 0)
-		cd->state_flags.door_locked = lockflag;
+	if (stat == 0) {
+		if (lockflag)
+			cd->cd_flags |= IDE_CD_FLAG_DOOR_LOCKED;
+		else
+			cd->cd_flags &= ~IDE_CD_FLAG_DOOR_LOCKED;
+	}
 
 	return stat;
 }
@@ -1875,11 +1879,11 @@ static int cdrom_eject(ide_drive_t *driv
 	struct request req;
 	char loej = 0x02;
 
-	if (cd->config_flags.no_eject && !ejectflag)
+	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if (cd->state_flags.door_locked && ejectflag)
+	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
 		return 0;
 
 	cdrom_prepare_request(drive, &req);
@@ -1977,7 +1981,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	   If it is, just return. */
 	(void) cdrom_check_status(drive, sense);
 
-	if (info->state_flags.toc_valid)
+	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
 		return 0;
 
 	/* Try to get the total cdrom capacity and sector size. */
@@ -2000,7 +2004,7 @@ static int cdrom_read_toc(ide_drive_t *d
 		return stat;
 
 #if ! STANDARD_ATAPI
-	if (info->config_flags.toctracks_as_bcd) {
+	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -2040,7 +2044,7 @@ static int cdrom_read_toc(ide_drive_t *d
 			return stat;
 		}
 #if ! STANDARD_ATAPI
-		if (info->config_flags.toctracks_as_bcd) {
+		if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 			toc->hdr.first_track = bin2bcd(CDROM_LEADOUT);
 			toc->hdr.last_track = bin2bcd(CDROM_LEADOUT);
 		} else
@@ -2057,7 +2061,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
 
 #if ! STANDARD_ATAPI
-	if (info->config_flags.toctracks_as_bcd) {
+	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -2065,8 +2069,8 @@ static int cdrom_read_toc(ide_drive_t *d
 
 	for (i=0; i<=ntracks; i++) {
 #if ! STANDARD_ATAPI
-		if (info->config_flags.tocaddr_as_bcd) {
-			if (info->config_flags.toctracks_as_bcd)
+		if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
+			if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD)
 				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -2091,7 +2095,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	}
 
 #if ! STANDARD_ATAPI
-	if (info->config_flags.tocaddr_as_bcd) {
+	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
 		/* Re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -2116,7 +2120,7 @@ static int cdrom_read_toc(ide_drive_t *d
 	}
 
 	/* Remember that we've read this stuff. */
-	info->state_flags.toc_valid = 1;
+	info->cd_flags |= IDE_CD_FLAG_TOC_VALID;
 
 	return 0;
 }
@@ -2198,7 +2202,7 @@ static int cdrom_get_toc_entry(ide_drive
 	/*
 	 * don't serve cached data, if the toc isn't valid
 	 */
-	if (!info->state_flags.toc_valid)
+	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0)
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
@@ -2344,7 +2348,7 @@ int ide_cdrom_reset (struct cdrom_device
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (cd->state_flags.door_locked)
+	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
 		(void) cdrom_lockdoor(drive, 1, &sense);
 
 	return ret;
@@ -2415,8 +2419,8 @@ static void ide_cdrom_update_speed(ide_d
 		maxspeed = be16_to_cpu(maxspeed);
 	}
 
-	cd->state_flags.current_speed = (curspeed + (176/2)) / 176;
-	cd->config_flags.max_speed = (maxspeed + (176/2)) / 176;
+	cd->current_speed = (curspeed + (176/2)) / 176;
+	cd->max_speed = (maxspeed + (176/2)) / 176;
 }
 
 static
@@ -2433,7 +2437,7 @@ int ide_cdrom_select_speed (struct cdrom
 
 	if (!ide_cdrom_get_capabilities(drive, buf)) {
 		ide_cdrom_update_speed(drive, buf);
-		cdi->speed = cd->state_flags.current_speed;
+		cdi->speed = cd->current_speed;
 	}
         return 0;
 }
@@ -2494,7 +2498,7 @@ int ide_cdrom_get_last_session (struct c
 	struct request_sense sense;
 	int ret;
 
-	if (!info->state_flags.toc_valid || info->toc == NULL)
+	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || info->toc == NULL)
 		if ((ret = cdrom_read_toc(drive, &sense)))
 			return ret;
 
@@ -2541,8 +2545,8 @@ int ide_cdrom_check_media_change_real (s
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = cd->state_flags.media_changed;
-		cd->state_flags.media_changed = 0;
+		retval = (cd->cd_flags & IDE_CD_FLAG_MEDIA_CHANGED) ? 1 : 0;
+		cd->cd_flags &= ~IDE_CD_FLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
 		return -EINVAL;
@@ -2567,7 +2571,7 @@ void ide_cdrom_release_real (struct cdro
 	struct cdrom_info *cd = drive->driver_data;
 
 	if (!cdi->use_count)
-		cd->state_flags.toc_valid = 0;
+		cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
 }
 
 #define IDE_CD_CAPABILITIES \
@@ -2599,12 +2603,12 @@ static int ide_cdrom_register (ide_drive
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
 	devinfo->ops = &ide_cdrom_dops;
-	devinfo->speed = info->state_flags.current_speed;
+	devinfo->speed = info->current_speed;
 	devinfo->capacity = nslots;
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (info->config_flags.no_speed_select)
+	if (info->cd_flags & IDE_CD_FLAG_NO_SPEED_SELECT)
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -2630,9 +2634,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 		return nslots;
 	}
 
-	if (cd->config_flags.nec260 ||
+	if ((cd->cd_flags & IDE_CD_FLAG_NEC260) ||
 	    !strcmp(drive->id->model,"STINGRAY 8422 IDE 8X CD-ROM 7-27-95")) {
-		cd->config_flags.no_eject = 0;
+		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
 	}
@@ -2651,9 +2655,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 		return 0;
 
 	if ((buf[8 + 6] & 0x01) == 0)
-		cd->config_flags.no_doorlock = 1;
+		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
 	if (buf[8 + 6] & 0x08)
-		cd->config_flags.no_eject = 0;
+		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
 	if (buf[8 + 3] & 0x01)
 		cdi->mask &= ~CDC_CD_R;
 	if (buf[8 + 3] & 0x02)
@@ -2700,8 +2704,8 @@ int ide_cdrom_probe_capabilities (ide_dr
 	printk(KERN_INFO "%s: ATAPI", drive->name);
 
 	/* don't print speed if the drive reported 0 */
-	if (cd->config_flags.max_speed)
-		printk(KERN_CONT " %dX", cd->config_flags.max_speed);
+	if (cd->max_speed)
+		printk(KERN_CONT " %dX", cd->max_speed);
 
 	printk(KERN_CONT " %s", (cdi->mask & CDC_DVD) ? "CD-ROM" : "DVD-ROM");
 
@@ -2828,23 +2832,23 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	drive->special.all	= 0;
 
-	cd->state_flags.media_changed = 1;
+	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
 
 #if NO_DOOR_LOCKING
-	cd->config_flags.no_doorlock = 1;
+	cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
 #endif
 	if ((drive->id->config & 0x0060) == 0x20)
-		cd->config_flags.drq_interrupt = 1;
-	cd->config_flags.no_eject = 1;
+		cd->cd_flags |= IDE_CD_FLAG_DRQ_INTERRUPT;
+	cd->cd_flags |= IDE_CD_FLAG_NO_EJECT;
 
 	/* limit transfer size per interrupt. */
 	/* a testament to the nice quality of Samsung drives... */
 	if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2430") ||
 	    !strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2432"))
-		cd->config_flags.limit_nframes = 1;
+		cd->cd_flags |= IDE_CD_FLAG_LIMIT_NFRAMES;
 	/* the 3231 model does not support the SET_CD_SPEED command */
 	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
-		cd->config_flags.no_speed_select = 1;
+		cd->cd_flags |= IDE_CD_FLAG_NO_SPEED_SELECT;
 
 #if ! STANDARD_ATAPI
 	if (strcmp (drive->id->model, "V003S0DS") == 0 &&
@@ -2852,22 +2856,22 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	    drive->id->fw_rev[6] <= '2') {
 		/* Vertos 300.
 		   Some versions of this drive like to talk BCD. */
-		cd->config_flags.toctracks_as_bcd = 1;
-		cd->config_flags.tocaddr_as_bcd = 1;
+		cd->cd_flags |= (IDE_CD_FLAG_TOCTRACKS_AS_BCD |
+				 IDE_CD_FLAG_TOCADDR_AS_BCD);
 	}
 	else if (strcmp (drive->id->model, "V006E0DS") == 0 &&
 	    drive->id->fw_rev[4] == '1' &&
 	    drive->id->fw_rev[6] <= '2') {
 		/* Vertos 600 ESD. */
-		cd->config_flags.toctracks_as_bcd = 1;
+		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
 	}
 	else if (strcmp(drive->id->model, "NEC CD-ROM DRIVE:260") == 0 &&
 		 strncmp(drive->id->fw_rev, "1.01", 4) == 0) { /* FIXME */
 		/* Old NEC260 (not R).
 		   This drive was released before the 1.2 version
 		   of the spec. */
-		cd->config_flags.tocaddr_as_bcd = 1;
-		cd->config_flags.nec260 = 1;
+		cd->cd_flags |= (IDE_CD_FLAG_TOCADDR_AS_BCD |
+				 IDE_CD_FLAG_NEC260);
 	}
 	/*
 	 * Sanyo 3 CD changer uses a non-standard command for CD changing
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -54,34 +54,34 @@
 #define ATAPI_CAPABILITIES_PAGE_SIZE		(8 + 20)
 #define ATAPI_CAPABILITIES_PAGE_PAD_SIZE	4
 
-/* Configuration flags.  These describe the capabilities of the drive.
-   They generally do not change after initialization, unless we learn
-   more about the drive from stuff failing. */
-struct ide_cd_config_flags {
-	__u8 drq_interrupt	: 1; /* Device sends an interrupt when ready
-					for a packet command. */
-	__u8 no_doorlock	: 1; /* Drive cannot lock the door. */
-	__u8 no_eject		: 1; /* Drive cannot eject the disc. */
-	__u8 nec260		: 1; /* Drive is a pre-1.2 NEC 260 drive. */
-	__u8 tocaddr_as_bcd	: 1; /* TOC addresses are in BCD. */
-	__u8 toctracks_as_bcd	: 1; /* TOC track numbers are in BCD. */
-	__u8 limit_nframes	: 1; /* Drive does not provide data in
-					multiples of SECTOR_SIZE when more
-					than one interrupt is needed. */
-	__u8 seeking		: 1; /* Seeking in progress */
-	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
-	byte max_speed;		     /* Max speed of the drive */
-};
-
-/* State flags.  These give information about the current state of the
-   drive, and will change during normal operation. */
-struct ide_cd_state_flags {
-	__u8 media_changed : 1; /* Driver has noticed a media change. */
-	__u8 toc_valid     : 1; /* Saved TOC information is current. */
-	__u8 door_locked   : 1; /* We think that the drive door is locked. */
-	__u8 writing       : 1; /* the drive is currently writing */
-	__u8 reserved      : 4;
-	byte current_speed;	/* Current speed of the drive */
+enum {
+	/* Device sends an interrupt when ready for a packet command. */
+	IDE_CD_FLAG_DRQ_INTERRUPT	= (1 << 0),
+	/* Drive cannot lock the door. */
+	IDE_CD_FLAG_NO_DOORLOCK		= (1 << 1),
+	/* Drive cannot eject the disc. */
+	IDE_CD_FLAG_NO_EJECT		= (1 << 2),
+	/* Drive is a pre-1.2 NEC 260 drive. */
+	IDE_CD_FLAG_NEC260		= (1 << 3),
+	/* TOC addresses are in BCD. */
+	IDE_CD_FLAG_TOCADDR_AS_BCD	= (1 << 4),
+	/* TOC track numbers are in BCD. */
+	IDE_CD_FLAG_TOCTRACKS_AS_BCD	= (1 << 5),
+	/*
+	 * Drive does not provide data in multiples of SECTOR_SIZE
+	 * when more than one interrupt is needed.
+	 */
+	IDE_CD_FLAG_LIMIT_NFRAMES	= (1 << 6),
+	/* Seeking in progress. */
+	IDE_CD_FLAG_SEEKING		= (1 << 7),
+	/* Driver has noticed a media change. */
+	IDE_CD_FLAG_MEDIA_CHANGED	= (1 << 8),
+	/* Saved TOC information is current. */
+	IDE_CD_FLAG_TOC_VALID		= (1 << 9),
+	/* We think that the drive door is locked. */
+	IDE_CD_FLAG_DOOR_LOCKED		= (1 << 10),
+	/* SET_CD_SPEED command is unsupported. */
+	IDE_CD_FLAG_NO_SPEED_SELECT	= (1 << 11),
 };
 
 /* Structure of a MSF cdrom address. */
@@ -153,8 +153,10 @@ struct cdrom_info {
 	unsigned long last_block;
 	unsigned long start_seek;
 
-	struct ide_cd_config_flags	config_flags;
-	struct ide_cd_state_flags	state_flags;
+	unsigned int cd_flags;
+
+	u8 max_speed;		/* Max speed of the drive. */
+	u8 current_speed;	/* Current speed of the drive. */
 
         /* Per-device info needed by cdrom.c generic driver. */
         struct cdrom_device_info devinfo;
