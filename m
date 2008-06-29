Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbYF2LEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbYF2LEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbYF2K7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57300 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbYF2K7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ZMVuPunlNJKydAshU4y5t7lHluvthGbDHj5ZagSYZ68SWIltRXvmg+yNMgeY4rSWTU
         2HqtQoERYcHewX+77GSSFg+Gr45fTjbkvU053BaE20GjPfB7BCNKktA4fq6dc/4bEUBI
         FPh4cPaOCHcP/pxB89Z4fjFdJQFOFueet/eZo=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 16/16] ide-cd: convert to using the new dev_flags
Date: Sun, 29 Jun 2008 12:59:19 +0200
Message-Id: <1214737159-1078-17-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c       |  108 +++++++++++++++++++++-----------------------
 drivers/ide/ide-cd.h       |   38 ---------------
 drivers/ide/ide-cd_ioctl.c |   27 +++++------
 3 files changed, 64 insertions(+), 109 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index b5ec249..c3ed2f1 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -85,10 +85,8 @@ static void ide_cd_put(struct cdrom_info *cd)
 /* Mark that we've seen a media change and invalidate our internal buffers. */
 static void cdrom_saw_media_change(ide_drive_t *drive)
 {
-	struct cdrom_info *cd = drive->driver_data;
-
-	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
-	cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
+	drive->dev_flags |= IDE_FLAG_MEDIA_CHANGED;
+	drive->dev_flags &= ~IDE_FLAG_TOC_VALID;
 }
 
 static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
@@ -528,7 +526,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
 			   xferlen, info->dma);
 
-	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
+	if (drive->dev_flags & IDE_FLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
 		if (info->dma)
 			drive->waiting_for_dma = 0;
@@ -560,7 +558,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
-	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
+	if (drive->dev_flags & IDE_FLAG_DRQ_INTERRUPT) {
 		/*
 		 * Here we should have been called after receiving an interrupt
 		 * from the device.  DRQ should how be set.
@@ -645,20 +643,18 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
-	struct cdrom_info *cd = drive->driver_data;
-
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
 
 	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
 			drive->name, __func__, len);
 
-	if (cd->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
+	if (drive->dev_flags & IDE_FLAG_LIMIT_NFRAMES)
 		printk(KERN_ERR "  This drive is not supported by "
 				"this version of the driver\n");
 	else {
 		printk(KERN_ERR "  Trying to limit transfer sizes\n");
-		cd->cd_flags |= IDE_CD_FLAG_LIMIT_NFRAMES;
+		drive->dev_flags |= IDE_FLAG_LIMIT_NFRAMES;
 	}
 
 	return 1;
@@ -735,7 +731,7 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
-	info->cd_flags |= IDE_CD_FLAG_SEEKING;
+	drive->dev_flags |= IDE_FLAG_SEEKING;
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0)
@@ -1187,7 +1183,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	int xferlen;
 
 	if (blk_fs_request(rq)) {
-		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
+		if (drive->dev_flags & IDE_FLAG_SEEKING) {
 			unsigned long elapsed = jiffies - info->start_seek;
 			int stat = ide_read_status(drive);
 
@@ -1200,7 +1196,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 				printk(KERN_ERR "%s: DSC timeout\n",
 						drive->name);
 			}
-			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
+			drive->dev_flags &= ~IDE_FLAG_SEEKING;
 		}
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
@@ -1358,7 +1354,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	 */
 	(void) cdrom_check_status(drive, sense);
 
-	if (info->cd_flags & IDE_CD_FLAG_TOC_VALID)
+	if (drive->dev_flags & IDE_FLAG_TOC_VALID)
 		return 0;
 
 	/* try to get the total cdrom capacity and sector size */
@@ -1380,7 +1376,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+	if (drive->dev_flags & IDE_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
 		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
@@ -1421,7 +1417,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+		if (drive->dev_flags & IDE_FLAG_TOCTRACKS_AS_BCD) {
 			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
 			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
 		} else {
@@ -1435,14 +1431,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
+	if (drive->dev_flags & IDE_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
 		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
-		if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
-			if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD)
+		if (drive->dev_flags & IDE_FLAG_TOCADDR_AS_BCD) {
+			if (drive->dev_flags & IDE_FLAG_TOCTRACKS_AS_BCD)
 				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -1465,7 +1461,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
-	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
+	if (drive->dev_flags & IDE_FLAG_TOCADDR_AS_BCD) {
 		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -1489,7 +1485,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	}
 
 	/* Remember that we've read this stuff. */
-	info->cd_flags |= IDE_CD_FLAG_TOC_VALID;
+	drive->dev_flags |= IDE_FLAG_TOC_VALID;
 
 	return 0;
 }
@@ -1501,7 +1497,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
-	if ((info->cd_flags & IDE_CD_FLAG_FULL_CAPS_PAGE) == 0)
+	if ((drive->dev_flags & IDE_FLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
@@ -1522,7 +1518,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	curspeed = *(u16 *)&buf[8 + 14];
 	maxspeed = *(u16 *)&buf[8 +  8];
 
-	if (cd->cd_flags & IDE_CD_FLAG_LE_SPEED_FIELDS) {
+	if (drive->dev_flags & IDE_FLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpu(curspeed);
 		maxspeed = le16_to_cpu(maxspeed);
 	} else {
@@ -1568,7 +1564,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (info->cd_flags & IDE_CD_FLAG_NO_SPEED_SELECT)
+	if (drive->dev_flags & IDE_FLAG_NO_SPEED_SELECT)
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -1594,8 +1590,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return nslots;
 	}
 
-	if (cd->cd_flags & IDE_CD_FLAG_PRE_ATAPI12) {
-		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
+	if (drive->dev_flags & IDE_FLAG_PRE_ATAPI12) {
+		drive->dev_flags &= ~IDE_FLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
 	}
@@ -1613,9 +1609,9 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return 0;
 
 	if ((buf[8 + 6] & 0x01) == 0)
-		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
+		drive->dev_flags |= IDE_FLAG_NO_DOORLOCK;
 	if (buf[8 + 6] & 0x08)
-		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
+		drive->dev_flags &= ~IDE_FLAG_NO_EJECT;
 	if (buf[8 + 3] & 0x01)
 		cdi->mask &= ~CDC_CD_R;
 	if (buf[8 + 3] & 0x02)
@@ -1626,7 +1622,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if ((buf[8 + 4] & 0x01) || (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK))
+	if ((buf[8 + 4] & 0x01) || (drive->dev_flags & IDE_FLAG_PLAY_AUDIO_OK))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
@@ -1791,43 +1787,43 @@ static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
 	/* Limit transfer size per interrupt. */
-	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
-	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
+	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_FLAG_LIMIT_NFRAMES	    },
+	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_FLAG_LIMIT_NFRAMES	    },
 	/* SCR-3231 doesn't support the SET_CD_SPEED command. */
-	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_CD_FLAG_NO_SPEED_SELECT    },
+	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_FLAG_NO_SPEED_SELECT       },
 	/* Old NEC260 (not R) was released before ATAPI 1.2 spec. */
-	{ "NEC CD-ROM DRIVE:260",    "1.01", IDE_CD_FLAG_TOCADDR_AS_BCD |
-					     IDE_CD_FLAG_PRE_ATAPI12,	    },
+	{ "NEC CD-ROM DRIVE:260",    "1.01", IDE_FLAG_TOCADDR_AS_BCD |
+					     IDE_FLAG_PRE_ATAPI12,	    },
 	/* Vertos 300, some versions of this drive like to talk BCD. */
-	{ "V003S0DS",		     NULL,   IDE_CD_FLAG_VERTOS_300_SSD,    },
+	{ "V003S0DS",		     NULL,   IDE_FLAG_VERTOS_300_SSD,       },
 	/* Vertos 600 ESD. */
-	{ "V006E0DS",		     NULL,   IDE_CD_FLAG_VERTOS_600_ESD,    },
+	{ "V006E0DS",		     NULL,   IDE_FLAG_VERTOS_600_ESD,       },
 	/*
 	 * Sanyo 3 CD changer uses a non-standard command for CD changing
 	 * (by default standard ATAPI support for CD changers is used).
 	 */
-	{ "CD-ROM CDR-C3 G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
-	{ "CD-ROM CDR-C3G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
-	{ "CD-ROM CDR_C36",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
+	{ "CD-ROM CDR-C3 G",	     NULL,   IDE_FLAG_SANYO_3CD	            },
+	{ "CD-ROM CDR-C3G",	     NULL,   IDE_FLAG_SANYO_3CD		    },
+	{ "CD-ROM CDR_C36",	     NULL,   IDE_FLAG_SANYO_3CD		    },
 	/* Stingray 8X CD-ROM. */
-	{ "STINGRAY 8422 IDE 8X CD-ROM 7-27-95", NULL, IDE_CD_FLAG_PRE_ATAPI12},
+	{ "STINGRAY 8422 IDE 8X CD-ROM 7-27-95", NULL, IDE_FLAG_PRE_ATAPI12},
 	/*
 	 * ACER 50X CD-ROM and WPI 32X CD-ROM require the full spec length
 	 * mode sense page capabilities size, but older drives break.
 	 */
-	{ "ATAPI CD ROM DRIVE 50X MAX",	NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
-	{ "WPI CDS-32X",		NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
+	{ "ATAPI CD ROM DRIVE 50X MAX",	NULL,	IDE_FLAG_FULL_CAPS_PAGE     },
+	{ "WPI CDS-32X",		NULL,	IDE_FLAG_FULL_CAPS_PAGE     },
 	/* ACER/AOpen 24X CD-ROM has the speed fields byte-swapped. */
-	{ "",			     "241N", IDE_CD_FLAG_LE_SPEED_FIELDS    },
+	{ "",			     "241N", IDE_FLAG_LE_SPEED_FIELDS       },
 	/*
 	 * Some drives used by Apple don't advertise audio play
 	 * but they do support reading TOC & audio datas.
 	 */
-	{ "MATSHITADVD-ROM SR-8187", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
-	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK      },
+	{ "MATSHITADVD-ROM SR-8187", NULL,   IDE_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_FLAG_PLAY_AUDIO_OK	    },
+	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_FLAG_PLAY_AUDIO_OK         },
 	{ NULL, NULL, 0 }
 };
 
@@ -1861,20 +1857,20 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	drive->special.all	= 0;
 
-	cd->cd_flags = IDE_CD_FLAG_MEDIA_CHANGED | IDE_CD_FLAG_NO_EJECT |
+	drive->dev_flags = IDE_FLAG_MEDIA_CHANGED | IDE_FLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
 	if ((id->config & 0x0060) == 0x20)
-		cd->cd_flags |= IDE_CD_FLAG_DRQ_INTERRUPT;
+		drive->dev_flags |= IDE_FLAG_DRQ_INTERRUPT;
 
-	if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_300_SSD) &&
+	if ((drive->dev_flags & IDE_FLAG_VERTOS_300_SSD) &&
 	    id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
-		cd->cd_flags |= (IDE_CD_FLAG_TOCTRACKS_AS_BCD |
-				 IDE_CD_FLAG_TOCADDR_AS_BCD);
-	else if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_600_ESD) &&
+		drive->dev_flags |= (IDE_FLAG_TOCTRACKS_AS_BCD |
+				 IDE_FLAG_TOCADDR_AS_BCD);
+	else if ((drive->dev_flags & IDE_FLAG_VERTOS_600_ESD) &&
 		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
-		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
-	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
+		drive->dev_flags |= IDE_FLAG_TOCTRACKS_AS_BCD;
+	else if (drive->dev_flags & IDE_FLAG_SANYO_3CD)
 		/* 3 => use CD in slot 0 */
 		cdi->sanyo_slot = 3;
 
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index fe0ea36..61a4599 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -27,42 +27,6 @@
 #define ATAPI_CAPABILITIES_PAGE_SIZE		(8 + 20)
 #define ATAPI_CAPABILITIES_PAGE_PAD_SIZE	4
 
-enum {
-	/* Device sends an interrupt when ready for a packet command. */
-	IDE_CD_FLAG_DRQ_INTERRUPT	= (1 << 0),
-	/* Drive cannot lock the door. */
-	IDE_CD_FLAG_NO_DOORLOCK		= (1 << 1),
-	/* Drive cannot eject the disc. */
-	IDE_CD_FLAG_NO_EJECT		= (1 << 2),
-	/* Drive is a pre ATAPI 1.2 drive. */
-	IDE_CD_FLAG_PRE_ATAPI12		= (1 << 3),
-	/* TOC addresses are in BCD. */
-	IDE_CD_FLAG_TOCADDR_AS_BCD	= (1 << 4),
-	/* TOC track numbers are in BCD. */
-	IDE_CD_FLAG_TOCTRACKS_AS_BCD	= (1 << 5),
-	/*
-	 * Drive does not provide data in multiples of SECTOR_SIZE
-	 * when more than one interrupt is needed.
-	 */
-	IDE_CD_FLAG_LIMIT_NFRAMES	= (1 << 6),
-	/* Seeking in progress. */
-	IDE_CD_FLAG_SEEKING		= (1 << 7),
-	/* Driver has noticed a media change. */
-	IDE_CD_FLAG_MEDIA_CHANGED	= (1 << 8),
-	/* Saved TOC information is current. */
-	IDE_CD_FLAG_TOC_VALID		= (1 << 9),
-	/* We think that the drive door is locked. */
-	IDE_CD_FLAG_DOOR_LOCKED		= (1 << 10),
-	/* SET_CD_SPEED command is unsupported. */
-	IDE_CD_FLAG_NO_SPEED_SELECT	= (1 << 11),
-	IDE_CD_FLAG_VERTOS_300_SSD	= (1 << 12),
-	IDE_CD_FLAG_VERTOS_600_ESD	= (1 << 13),
-	IDE_CD_FLAG_SANYO_3CD		= (1 << 14),
-	IDE_CD_FLAG_FULL_CAPS_PAGE	= (1 << 15),
-	IDE_CD_FLAG_PLAY_AUDIO_OK	= (1 << 16),
-	IDE_CD_FLAG_LE_SPEED_FIELDS	= (1 << 17),
-};
-
 /* Structure of a MSF cdrom address. */
 struct atapi_msf {
 	byte reserved;
@@ -128,8 +92,6 @@ struct cdrom_info {
 	unsigned long last_block;
 	unsigned long start_seek;
 
-	unsigned int cd_flags;
-
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 24d002a..c53778a 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -27,10 +27,9 @@ int ide_cdrom_open_real(struct cdrom_device_info *cdi, int purpose)
 void ide_cdrom_release_real(struct cdrom_device_info *cdi)
 {
 	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
 
 	if (!cdi->use_count)
-		cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
+		drive->dev_flags &= ~IDE_FLAG_TOC_VALID;
 }
 
 /*
@@ -83,13 +82,12 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
 				       int slot_nr)
 {
 	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
 	int retval;
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = (cd->cd_flags & IDE_CD_FLAG_MEDIA_CHANGED) ? 1 : 0;
-		cd->cd_flags &= ~IDE_CD_FLAG_MEDIA_CHANGED;
+		retval = (drive->dev_flags & IDE_FLAG_MEDIA_CHANGED) ? 1 : 0;
+		drive->dev_flags &= ~IDE_FLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
 		return -EINVAL;
@@ -107,11 +105,11 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	char loej = 0x02;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
+	if ((drive->dev_flags & IDE_FLAG_NO_EJECT) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
+	if ((drive->dev_flags & IDE_FLAG_DOOR_LOCKED) && ejectflag)
 		return 0;
 
 	/* only tell drive to close tray if open, if it can do that */
@@ -131,7 +129,6 @@ static
 int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		    struct request_sense *sense)
 {
-	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
 	int stat;
 
@@ -139,7 +136,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
+	if (drive->dev_flags & IDE_FLAG_NO_DOORLOCK) {
 		stat = 0;
 	} else {
 		unsigned char cmd[BLK_MAX_CDB];
@@ -160,7 +157,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
 		printk(KERN_ERR "%s: door locking not supported\n",
 			drive->name);
-		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
+		drive->dev_flags |= IDE_FLAG_NO_DOORLOCK;
 		stat = 0;
 	}
 
@@ -170,9 +167,9 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 
 	if (stat == 0) {
 		if (lockflag)
-			cd->cd_flags |= IDE_CD_FLAG_DOOR_LOCKED;
+			drive->dev_flags |= IDE_FLAG_DOOR_LOCKED;
 		else
-			cd->cd_flags &= ~IDE_CD_FLAG_DOOR_LOCKED;
+			drive->dev_flags &= ~IDE_FLAG_DOOR_LOCKED;
 	}
 
 	return stat;
@@ -250,7 +247,7 @@ int ide_cdrom_get_last_session(struct cdrom_device_info *cdi,
 	struct request_sense sense;
 	int ret;
 
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || !info->toc) {
+	if ((drive->dev_flags & IDE_FLAG_TOC_VALID) == 0 || !info->toc) {
 		ret = ide_cd_read_toc(drive, &sense);
 		if (ret)
 			return ret;
@@ -308,7 +305,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
+	if (drive->dev_flags & IDE_FLAG_DOOR_LOCKED)
 		(void)ide_cd_lockdoor(drive, 1, &sense);
 
 	return ret;
@@ -324,7 +321,7 @@ static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
 	/*
 	 * don't serve cached data, if the toc isn't valid
 	 */
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0)
+	if ((drive->dev_flags & IDE_FLAG_TOC_VALID) == 0)
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
-- 
1.5.5.4

