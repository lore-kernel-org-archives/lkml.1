Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZBOMKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZBOMKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZBOMI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:32749 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZBOMIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LPAVhNai9p1u6CZ7sceihMI5twZ0n9Pc+j2+nA5+ONATthN0mKrlWTGZZOC80NKvpJ
         WxrxIxZpH0Ipzwyf5rJ/je/PRZR4cpnG+J5Q16/O0IQpwK3Jz8fa7NtIOfsK1z37wV4t
         8pofCzq/0F3hR5ezmrrhFl54yFMyeFLaHTWWQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/10] ide-cd: use flags query macros
Date: Sun, 15 Feb 2009 13:08:04 +0100
Message-Id: <1234699692-9452-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c       |   44 +++++++++++++++++++++++---------------------
 drivers/ide/ide-cd_ioctl.c |   18 ++++++++----------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c53fdf1..6817332 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -572,7 +572,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 	printk(KERN_ERR PFX "%s: %s: Bad transfer size %d\n", drive->name,
 			__func__, len);
 
-	if (drive->atapi_flags & IDE_AFLAG_LIMIT_NFRAMES)
+	if (ide_drv_limit_nframes(drive))
 		printk(KERN_ERR PFX "This drive is not supported by this "
 				"version of the driver\n");
 	else {
@@ -1008,7 +1008,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		}
 		drive->dma = 0;
 	} else
-		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+		drive->dma = !!ide_drv_using_dma(drive);
 
 	if (write)
 		cd->devinfo.media_written = 1;
@@ -1040,7 +1040,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		else
 			buf = rq->data;
 
-		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+		drive->dma = !!ide_drv_using_dma(drive);
 
 		/*
 		 * check if dma is safe
@@ -1242,7 +1242,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	 */
 	(void) cdrom_check_status(drive, sense);
 
-	if (drive->atapi_flags & IDE_AFLAG_TOC_VALID)
+	if (ide_drv_toc_valid(drive))
 		return 0;
 
 	/* try to get the total cdrom capacity and sector size */
@@ -1264,7 +1264,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+	if (ide_drv_toctracks_bcd(drive)) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -1305,7 +1305,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+		if (ide_drv_toctracks_bcd(drive)) {
 			toc->hdr.first_track = (u8)bin2bcd(CDROM_LEADOUT);
 			toc->hdr.last_track = (u8)bin2bcd(CDROM_LEADOUT);
 		} else {
@@ -1319,14 +1319,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+	if (ide_drv_toctracks_bcd(drive)) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
-		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
-			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
+		if (ide_drv_tocaddr_bcd(drive)) {
+			if (ide_drv_toctracks_bcd(drive))
 				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -1349,7 +1349,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
+	if (ide_drv_tocaddr_bcd(drive)) {
 		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -1387,7 +1387,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
+	if (!ide_drv_full_caps(drive))
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
@@ -1407,7 +1407,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
+	if (ide_drv_le_speed_fields(drive)) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
 		maxspeed = le16_to_cpup((__le16 *)&buf[8 + 8]);
 	} else {
@@ -1458,7 +1458,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (drive->atapi_flags & IDE_AFLAG_NO_SPEED_SELECT)
+	if (ide_drv_no_speed_select(drive))
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -1487,7 +1487,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return nslots;
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_PRE_ATAPI12) {
+	if (ide_drv_pre_atapi12(drive)) {
 		drive->atapi_flags &= ~IDE_AFLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
@@ -1519,13 +1519,13 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if ((buf[8 + 4] & 0x01) || (drive->atapi_flags & IDE_AFLAG_PLAY_AUDIO_OK))
+	if ((buf[8 + 4] & 0x01) || ide_drv_can_play_audio(drive))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
 	if (mechtype == mechtype_caddy ||
 	    mechtype == mechtype_popup ||
-	    (drive->atapi_flags & IDE_AFLAG_NO_AUTOCLOSE))
+	    ide_drv_no_autoclose(drive))
 		cdi->mask |= CDC_CLOSE_TRAY;
 
 	if (cdi->sanyo_slot > 0) {
@@ -1767,14 +1767,16 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
 
-	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
-	    fw_rev[4] == '1' && fw_rev[6] <= '2')
+	if (ide_drv_vertos_300_ssd(drive) &&
+	     fw_rev[4] == '1' &&
+	     fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
 				     IDE_AFLAG_TOCADDR_AS_BCD);
-	else if ((drive->atapi_flags & IDE_AFLAG_VERTOS_600_ESD) &&
-		 fw_rev[4] == '1' && fw_rev[6] <= '2')
+	else if (ide_drv_vertos_600_esd(drive) &&
+		  fw_rev[4] == '1' &&
+		  fw_rev[6] <= '2')
 		drive->atapi_flags |= IDE_AFLAG_TOCTRACKS_AS_BCD;
-	else if (drive->atapi_flags & IDE_AFLAG_SANYO_3CD)
+	else if (ide_drv_sanyo_3cd(drive))
 		/* 3 => use CD in slot 0 */
 		cdi->sanyo_slot = 3;
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index df3df00..5551bc0 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -86,7 +86,7 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
+		retval = ide_drv_media_changed(drive) ? 1 : 0;
 		drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
@@ -105,11 +105,11 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	char loej = 0x02;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	if ((drive->atapi_flags & IDE_AFLAG_NO_EJECT) && !ejectflag)
+	if (ide_drv_no_eject(drive) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if ((drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED) && ejectflag)
+	if (ide_drv_door_locked(drive) && ejectflag)
 		return 0;
 
 	/* only tell drive to close tray if open, if it can do that */
@@ -136,7 +136,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0) {
+	if (!ide_drv_doorlocking(drive)) {
 		stat = 0;
 	} else {
 		unsigned char cmd[BLK_MAX_CDB];
@@ -247,7 +247,7 @@ int ide_cdrom_get_last_session(struct cdrom_device_info *cdi,
 	struct request_sense sense;
 	int ret;
 
-	if ((drive->atapi_flags & IDE_AFLAG_TOC_VALID) == 0 || !info->toc) {
+	if (!ide_drv_toc_valid(drive) || !info->toc) {
 		ret = ide_cd_read_toc(drive, &sense);
 		if (ret)
 			return ret;
@@ -305,7 +305,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED)
+	if (ide_drv_door_locked(drive))
 		(void)ide_cd_lockdoor(drive, 1, &sense);
 
 	return ret;
@@ -318,10 +318,8 @@ static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
 	struct atapi_toc *toc = info->toc;
 	int ntracks;
 
-	/*
-	 * don't serve cached data, if the toc isn't valid
-	 */
-	if ((drive->atapi_flags & IDE_AFLAG_TOC_VALID) == 0)
+	/* don't serve cached data, if the toc isn't valid */
+	if (!ide_drv_toc_valid(drive))
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
-- 
1.6.0.4

