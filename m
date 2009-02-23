Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZBWHEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZBWHEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZBWHE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:04:26 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63313 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZBWHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=LpHac6xGM9rN3xGMpAvi28MqAC4s9TuFP8RLiWEBewS/rX8H/I73O1eEJyzuW5E4pp
         R/YNwy0iEn/y17p2e/VGuSGLm7wE/2RLqUpAFIGeCbaONbKzqZbtuOagCU8k/1aNxcCA
         zOrY5IwAOGTIa679OPh7yx04Iv+DfYbdb63lo=
Date: Mon, 23 Feb 2009 08:04:13 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] ide: flags query macros
Message-ID: <20090223070413.GA17783@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <200902171533.29135.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200902171533.29135.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since it is not a lot of modified lines and the change is rather
> straightforward it could as well be done in a single patch...

here's version 2:
--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Mon, 23 Feb 2009 07:58:23 +0100
Subject: [PATCH] ide: flags query macros

Add drive->atapi_flags and drive->dev_flags macro wrappers

v2:
- use static inlines for better typechecking
- use macro indirection for convenience

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/cmd640.c           |    2 +-
 drivers/ide/ht6560b.c          |    3 +-
 drivers/ide/ide-atapi.c        |   15 ++++-----
 drivers/ide/ide-cd.c           |   40 ++++++++++++-----------
 drivers/ide/ide-cd_ioctl.c     |   18 +++++------
 drivers/ide/ide-devsets.c      |    8 ++---
 drivers/ide/ide-disk.c         |   32 +++++++++---------
 drivers/ide/ide-disk_proc.c    |    2 +-
 drivers/ide/ide-dma.c          |    3 +-
 drivers/ide/ide-eh.c           |   17 +++++-----
 drivers/ide/ide-floppy.c       |    6 ++--
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 drivers/ide/ide-gd.c           |   14 ++++----
 drivers/ide/ide-io.c           |    9 ++---
 drivers/ide/ide-ioctls.c       |    6 ++--
 drivers/ide/ide-iops.c         |    6 ++--
 drivers/ide/ide-lib.c          |    2 +-
 drivers/ide/ide-park.c         |   11 +++---
 drivers/ide/ide-pm.c           |    2 +-
 drivers/ide/ide-probe.c        |   36 +++++++++++----------
 drivers/ide/ide-proc.c         |    2 +-
 drivers/ide/ide-tape.c         |   12 +++---
 drivers/ide/ide-taskfile.c     |   16 +++------
 drivers/ide/ns87415.c          |    5 +--
 drivers/ide/pdc202xx_old.c     |    4 +-
 drivers/ide/sc1200.c           |    2 +-
 drivers/ide/trm290.c           |    4 +-
 include/linux/ide.h            |   68 ++++++++++++++++++++++++++++++++++++++++
 28 files changed, 202 insertions(+), 145 deletions(-)

diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 8890276..61cd602 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -625,7 +625,7 @@ static void cmd640_init_dev(ide_drive_t *drive)
 	 */
 	check_prefetch(drive, i);
 	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
-		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
+		i, ide_dev_no_32bit_io(drive) ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index c7e5c22..6da6bfd 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -120,8 +120,7 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 	 * Need to enforce prefetch sometimes because otherwise
 	 * it'll hang (hard).
 	 */
-	if (drive->media != ide_disk ||
-	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (drive->media != ide_disk || !ide_dev_present(drive))
 		select |= HT_PREFETCH_MODE;
 
 	if (select != current_select || timing != current_timing) {
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index c807515..d9e71b8 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -202,7 +202,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 {
 	struct ide_atapi_pc pc;
 
-	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
+	if (!ide_dev_doorlocking(drive))
 		return 0;
 
 	ide_init_pc(&pc);
@@ -547,7 +547,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		return startstop;
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+	if (ide_dev_drq_int(drive)) {
 		if (drive->dma)
 			drive->waiting_for_dma = 1;
 	}
@@ -570,7 +570,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		 * miliseconds later in ide_delayed_transfer_pc() after the
 		 * device says it's ready for a packet.
 		 */
-		if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
+		if (ide_dev_zip(drive)) {
 			timeout = drive->pc_delay;
 			expiry = &ide_delayed_transfer_pc;
 		} else {
@@ -611,7 +611,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	/* Send the actual packet */
-	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+	if (!ide_dev_zip(drive))
 		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	return ide_started;
@@ -627,7 +627,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
-	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
@@ -659,7 +658,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 		}
 
 		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+		     ide_dev_using_dma(drive)) {
 			if (ide_build_sglist(drive, cmd))
 				drive->dma = !dma_ops->dma_setup(drive, cmd);
 			else
@@ -677,7 +676,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	(void)do_rw_taskfile(drive, cmd);
 
-	if (drq_int) {
+	if (ide_dev_drq_int(drive)) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
 		hwif->expiry = expiry;
@@ -685,6 +684,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	ide_execute_command(drive, cmd, ide_transfer_pc, timeout);
 
-	return drq_int ? ide_started : ide_transfer_pc(drive);
+	return ide_dev_drq_int(drive) ? ide_started : ide_transfer_pc(drive);
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ee082ce..01d18ca 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -859,7 +859,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		else
 			buf = rq->data;
 
-		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+		drive->dma = ide_dev_using_dma(drive);
 
 		/*
 		 * check if dma is safe
@@ -1073,7 +1073,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	 */
 	(void) cdrom_check_status(drive, sense);
 
-	if (drive->atapi_flags & IDE_AFLAG_TOC_VALID)
+	if (ide_dev_toc_valid(drive))
 		return 0;
 
 	/* try to get the total cdrom capacity and sector size */
@@ -1095,7 +1095,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+	if (ide_dev_toctracks_bcd(drive)) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
@@ -1136,7 +1136,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		if (stat)
 			return stat;
 
-		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+		if (ide_dev_toctracks_bcd(drive)) {
 			toc->hdr.first_track = (u8)bin2bcd(CDROM_LEADOUT);
 			toc->hdr.last_track = (u8)bin2bcd(CDROM_LEADOUT);
 		} else {
@@ -1150,14 +1150,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
+	if (ide_dev_toctracks_bcd(drive)) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
-		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
-			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
+		if (ide_dev_tocaddr_bcd(drive)) {
+			if (ide_dev_toctracks_bcd(drive))
 				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
@@ -1180,7 +1180,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
+	if (ide_dev_tocaddr_bcd(drive)) {
 		/* re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
 					   sizeof(ms_tmp), sense);
@@ -1218,7 +1218,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
+	if (!ide_dev_full_caps(drive))
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
@@ -1238,7 +1238,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
+	if (ide_dev_le_speed_fields(drive)) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
 		maxspeed = le16_to_cpup((__le16 *)&buf[8 + 8]);
 	} else {
@@ -1289,7 +1289,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
 
-	if (drive->atapi_flags & IDE_AFLAG_NO_SPEED_SELECT)
+	if (ide_dev_no_speed_select(drive))
 		devinfo->mask |= CDC_SELECT_SPEED;
 
 	devinfo->disk = info->disk;
@@ -1318,7 +1318,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		return nslots;
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_PRE_ATAPI12) {
+	if (ide_dev_pre_atapi12(drive)) {
 		drive->atapi_flags &= ~IDE_AFLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
@@ -1350,13 +1350,13 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if ((buf[8 + 4] & 0x01) || (drive->atapi_flags & IDE_AFLAG_PLAY_AUDIO_OK))
+	if ((buf[8 + 4] & 0x01) || ide_dev_can_play_audio(drive))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
 	if (mechtype == mechtype_caddy ||
 	    mechtype == mechtype_popup ||
-	    (drive->atapi_flags & IDE_AFLAG_NO_AUTOCLOSE))
+	    ide_dev_no_autoclose(drive))
 		cdi->mask |= CDC_CLOSE_TRAY;
 
 	if (cdi->sanyo_slot > 0) {
@@ -1595,14 +1595,16 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
 
-	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
-	    fw_rev[4] == '1' && fw_rev[6] <= '2')
+	if (ide_dev_vertos_300_ssd(drive) &&
+	     fw_rev[4] == '1' &&
+	     fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
 				     IDE_AFLAG_TOCADDR_AS_BCD);
-	else if ((drive->atapi_flags & IDE_AFLAG_VERTOS_600_ESD) &&
-		 fw_rev[4] == '1' && fw_rev[6] <= '2')
+	else if (ide_dev_vertos_600_esd(drive) &&
+		  fw_rev[4] == '1' &&
+		  fw_rev[6] <= '2')
 		drive->atapi_flags |= IDE_AFLAG_TOCTRACKS_AS_BCD;
-	else if (drive->atapi_flags & IDE_AFLAG_SANYO_3CD)
+	else if (ide_dev_sanyo_3cd(drive))
 		/* 3 => use CD in slot 0 */
 		cdi->sanyo_slot = 3;
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index df3df00..3553759 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -86,7 +86,7 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
+		retval = ide_dev_media_changed(drive) ? 1 : 0;
 		drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
@@ -105,11 +105,11 @@ int cdrom_eject(ide_drive_t *drive, int ejectflag,
 	char loej = 0x02;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	if ((drive->atapi_flags & IDE_AFLAG_NO_EJECT) && !ejectflag)
+	if (ide_dev_no_eject(drive) && !ejectflag)
 		return -EDRIVE_CANT_DO_THIS;
 
 	/* reload fails on some drives, if the tray is locked */
-	if ((drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED) && ejectflag)
+	if (ide_dev_door_locked(drive) && ejectflag)
 		return 0;
 
 	/* only tell drive to close tray if open, if it can do that */
@@ -136,7 +136,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0) {
+	if (!ide_dev_doorlocking(drive)) {
 		stat = 0;
 	} else {
 		unsigned char cmd[BLK_MAX_CDB];
@@ -247,7 +247,7 @@ int ide_cdrom_get_last_session(struct cdrom_device_info *cdi,
 	struct request_sense sense;
 	int ret;
 
-	if ((drive->atapi_flags & IDE_AFLAG_TOC_VALID) == 0 || !info->toc) {
+	if (!ide_dev_toc_valid(drive) || !info->toc) {
 		ret = ide_cd_read_toc(drive, &sense);
 		if (ret)
 			return ret;
@@ -305,7 +305,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
 	 */
-	if (drive->atapi_flags & IDE_AFLAG_DOOR_LOCKED)
+	if (ide_dev_door_locked(drive))
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
+	if (!ide_dev_toc_valid(drive))
 		return -EINVAL;
 
 	/* Check validity of requested track number. */
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index 5bf958e..b9156de 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -8,7 +8,7 @@ ide_devset_get(io_32bit, io_32bit);
 
 static int set_io_32bit(ide_drive_t *drive, int arg)
 {
-	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
+	if (ide_dev_no_32bit_io(drive))
 		return -EPERM;
 
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
@@ -115,12 +115,10 @@ static int set_pio_mode(ide_drive_t *drive, int arg)
 		} else
 			port_ops->set_pio_mode(drive, arg);
 	} else {
-		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-
 		ide_set_pio(drive, arg);
 
 		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-			if (keep_dma)
+			if (ide_dev_using_dma(drive))
 				ide_dma_on(drive);
 		}
 	}
@@ -132,7 +130,7 @@ ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
 
 static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
-	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
+	if (ide_dev_no_unmask(drive))
 		return -EPERM;
 
 	if (arg < 0 || arg > 1)
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index ca934c8..9cd9a52 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -83,8 +83,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	u16 nsectors		= (u16)rq->nr_sectors;
-	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
-	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+	u8 lba48		= ide_dev_lba48(drive);
+	u8 dma			= ide_dev_using_dma(drive);
 	struct ide_cmd		cmd;
 	struct ide_taskfile	*tf = &cmd.tf;
 	ide_startstop_t		rc;
@@ -99,7 +99,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (drive->dev_flags & IDE_DFLAG_LBA) {
+	if (ide_dev_does_lba(drive)) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
 					(unsigned long long)block);
@@ -180,7 +180,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
+	BUG_ON(ide_dev_blocked(drive));
 
 	if (!blk_fs_request(rq)) {
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
@@ -359,7 +359,7 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	}
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
-	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
+	if (!ide_dev_lba48(drive) &&
 	    drive->capacity64 > 1ULL << 28) {
 		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
 		       "%llu sectors (%llu MB)\n",
@@ -369,7 +369,7 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
 	}
 
 	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
-	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
+	    ide_dev_lba48(drive)) {
 		if (drive->capacity64 > 1ULL << 28) {
 			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
 					 " will be used for accessing sectors "
@@ -468,7 +468,7 @@ static void update_ordered(ide_drive_t *drive)
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
 
-	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
+	if (ide_dev_wcache_enabled(drive)) {
 		unsigned long long capacity;
 		int barrier;
 		/*
@@ -481,8 +481,8 @@ static void update_ordered(ide_drive_t *drive)
 		 */
 		capacity = ide_gd_capacity(drive);
 		barrier = ata_id_flush_enabled(id) &&
-			(drive->dev_flags & IDE_DFLAG_NOFLUSH) == 0 &&
-			((drive->dev_flags & IDE_DFLAG_LBA48) == 0 ||
+			!ide_dev_noflush(drive) &&
+			(!ide_dev_lba48(drive) ||
 			 capacity <= (1ULL << 28) ||
 			 ata_id_flush_ext_enabled(id));
 
@@ -604,10 +604,10 @@ static void ide_disk_setup(ide_drive_t *drive)
 
 	ide_proc_register_driver(drive, idkp->driver);
 
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0)
+	if (!ide_dev_id_read(drive))
 		return;
 
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE) {
+	if (ide_dev_removable(drive)) {
 		/*
 		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
@@ -617,7 +617,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 
 	(void)set_addressing(drive, 1);
 
-	if (drive->dev_flags & IDE_DFLAG_LBA48) {
+	if (ide_dev_lba48(drive)) {
 		int max_s = 2048;
 
 		if (max_s > hwif->rqsize)
@@ -641,7 +641,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 	 */
 	capacity = ide_gd_capacity(drive);
 
-	if ((drive->dev_flags & IDE_DFLAG_FORCED_GEOM) == 0) {
+	if (!ide_dev_forced_geom(drive)) {
 		if (ata_id_lba48_enabled(drive->id)) {
 			/* compatibility */
 			drive->bios_sect = 63;
@@ -680,7 +680,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 
 	set_wcache(drive, 1);
 
-	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
+	if (!ide_dev_does_lba(drive) &&
 	    (drive->head == 0 || drive->head > 16)) {
 		printk(KERN_ERR "%s: invalid geometry: %d physical heads?\n",
 			drive->name, drive->head);
@@ -692,7 +692,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 static void ide_disk_flush(ide_drive_t *drive)
 {
 	if (ata_id_flush_enabled(drive->id) == 0 ||
-	    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0)
+	    !ide_dev_wcache_enabled(drive))
 		return;
 
 	if (do_idedisk_flushcache(drive))
@@ -710,7 +710,7 @@ static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 	struct ide_cmd cmd;
 	int ret;
 
-	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
+	if (!ide_dev_doorlocking(drive))
 		return 0;
 
 	memset(&cmd, 0, sizeof(cmd));
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 3f2a078..540fe00 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -42,7 +42,7 @@ static int proc_idedisk_read_cache
 	char		*out = page;
 	int		len;
 
-	if (drive->dev_flags & IDE_DFLAG_ID_READ)
+	if (ide_dev_id_read(drive))
 		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
 	else
 		len = sprintf(out, "(none)\n");
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 3dbf80c..bf4d55f 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -353,8 +353,7 @@ static int ide_tune_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (ata_id_has_dma(drive->id) == 0 ||
-	    (drive->dev_flags & IDE_DFLAG_NODMA))
+	if (ata_id_has_dma(drive->id) == 0 || ide_dev_nodma(drive))
 		return 0;
 
 	/* consult the list of known "bad" drives */
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 1166497..cc9c223 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -9,13 +9,13 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+	    ((stat & ATA_DF) && !ide_dev_ignore_write_err(drive))) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
-			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
+			if (ide_dev_does_lba(drive) &&
 			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
 			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
@@ -65,7 +65,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+	    ((stat & ATA_DF) && !ide_dev_ignore_write_err(drive))) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
@@ -274,8 +274,7 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 	drive->mult_count = 0;
 	drive->dev_flags &= ~IDE_DFLAG_PARKED;
 
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
+	if (!(ide_dev_keep_settings(drive) || ide_dev_using_dma(drive)))
 		drive->mult_req = 0;
 
 	if (drive->mult_req != drive->mult_count)
@@ -291,15 +290,15 @@ static void pre_reset(ide_drive_t *drive)
 	else
 		drive->dev_flags |= IDE_DFLAG_POST_RESET;
 
-	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
+	if (ide_dev_using_dma(drive)) {
 		if (drive->crc_count)
 			ide_check_dma_crc(drive);
 		else
 			ide_dma_off(drive);
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+	if (!ide_dev_keep_settings(drive)) {
+		if (!ide_dev_using_dma(drive)) {
 			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 			drive->io_32bit = 0;
 		}
@@ -366,7 +365,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
 		ide_port_for_each_present_dev(i, tdrive, hwif) {
-			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
+			if (ide_dev_heads_parked(tdrive) &&
 			    time_after(tdrive->sleep, timeout))
 				timeout = tdrive->sleep;
 		}
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b7f0206..1192f5d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -336,7 +336,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	else
 		drive->dev_flags &= ~IDE_DFLAG_WP;
 
-	set_disk_ro(disk, !!(drive->dev_flags & IDE_DFLAG_WP));
+	set_disk_ro(disk, ide_dev_write_protected(drive));
 
 	page = &pc->buf[8];
 
@@ -421,7 +421,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
+			if (!ide_dev_clik(drive))
 				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -471,7 +471,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
+	if (!ide_dev_clik(drive))
 		(void) ide_floppy_get_flexible_disk_page(drive, &pc);
 
 	return rc;
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 8f8be85..8362ad6 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -195,7 +195,7 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 	struct ide_disk_obj *floppy = drive->driver_data;
 	int progress_indication = 0x10000;
 
-	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
+	if (ide_dev_srfp(drive)) {
 		ide_create_request_sense_cmd(drive, pc);
 		if (ide_queue_pc_tail(drive, floppy->disk, pc))
 			return -EIO;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index d0573aa..ccef390 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -179,7 +179,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 
 	idkp->openers++;
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+	if (ide_dev_removable(drive) && idkp->openers == 1) {
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
@@ -195,7 +195,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 			goto out_put_idkp;
 		}
 
-		if ((drive->dev_flags & IDE_DFLAG_WP) && (mode & FMODE_WRITE)) {
+		if (ide_dev_write_protected(drive) && (mode & FMODE_WRITE)) {
 			ret = -EROFS;
 			goto out_put_idkp;
 		}
@@ -208,7 +208,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 		drive->disk_ops->set_doorlock(drive, disk, 1);
 		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 		check_disk_change(bdev);
-	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
+	} else if (ide_dev_format_in_progress(drive)) {
 		ret = -EBUSY;
 		goto out_put_idkp;
 	}
@@ -230,7 +230,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+	if (ide_dev_removable(drive) && idkp->openers == 1) {
 		drive->disk_ops->set_doorlock(drive, disk, 0);
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 	}
@@ -260,12 +260,12 @@ static int ide_gd_media_changed(struct gendisk *disk)
 	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+	if (ide_dev_attach(drive)) {
 		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
 
-	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	ret = ide_dev_media_changed(drive);
 	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 
 	return ret;
@@ -361,7 +361,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 	g->minors = IDE_DISK_MINORS;
 	g->driverfs_dev = &drive->gendev;
 	g->flags |= GENHD_FL_EXT_DEVT;
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+	if (ide_dev_removable(drive))
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
 	add_disk(g);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 481fb1b..d161ebf 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -61,8 +61,7 @@ int ide_end_rq(ide_drive_t *drive, struct request *rq, int error,
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
 	 * if we DMA timeout more than 3 times, just stay in PIO
 	 */
-	if ((drive->dev_flags & IDE_DFLAG_DMA_PIO_RETRY) &&
-	    drive->retry_pio <= 3) {
+	if (ide_dev_dma_retry_pio(drive) && drive->retry_pio <= 3) {
 		drive->dev_flags &= ~IDE_DFLAG_DMA_PIO_RETRY;
 		ide_dma_on(drive);
 	}
@@ -481,7 +480,7 @@ repeat:
 		prev_port = hwif->host->cur_port;
 		hwif->rq = NULL;
 
-		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
+		if (ide_dev_sleeping(drive)) {
 			if (time_before(drive->sleep, jiffies)) {
 				ide_unlock_port(hwif);
 				goto plug_device;
@@ -530,7 +529,7 @@ repeat:
 		 * unless the subdriver triggers such a thing in its own PM
 		 * state machine.
 		 */
-		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
+		if (ide_dev_blocked(drive) &&
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
@@ -839,7 +838,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	if (hwif->port_ops && hwif->port_ops->clear_irq)
 		hwif->port_ops->clear_irq(drive);
 
-	if (drive->dev_flags & IDE_DFLAG_UNMASK)
+	if (ide_dev_unmask_irqs(drive))
 		local_irq_enable_in_hardirq();
 
 	/* service this interrupt, may set handler for next interrupt */
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 7701427..8c6e076 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -59,7 +59,7 @@ static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
 	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
 	int rc = 0;
 
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+	if (!ide_dev_id_read(drive)) {
 		rc = -ENOMSG;
 		goto out;
 	}
@@ -83,9 +83,9 @@ out:
 
 static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 {
-	return put_user((!!(drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)
+	return put_user((ide_dev_dsc_overlap(drive)
 			 << IDE_NICE_DSC_OVERLAP) |
-			(!!(drive->dev_flags & IDE_DFLAG_NICE1)
+			(ide_dev_nice1(drive)
 			 << IDE_NICE_1), (long __user *)arg);
 }
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 5403e4a..7353cf9 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -274,7 +274,7 @@ u8 eighty_ninty_three(ide_drive_t *drive)
 		return 1;
 
 no_80w:
-	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
+	if (ide_dev_udma33_warned(drive))
 		return 0;
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
@@ -310,7 +310,7 @@ int ide_driveid_update(ide_drive_t *drive)
 
 	kfree(id);
 
-	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) && ide_id_dma_bug(drive))
+	if (ide_dev_using_dma(drive) && ide_id_dma_bug(drive))
 		ide_dma_off(drive);
 
 	return 1;
@@ -392,7 +392,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (speed >= XFER_SW_DMA_0 && (drive->dev_flags & IDE_DFLAG_USING_DMA))
+	if (speed >= XFER_SW_DMA_0 && ide_dev_using_dma(drive))
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 217b7fd..dc2ff8b 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -68,7 +68,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 {
 	struct ide_cmd cmd;
 	struct ide_taskfile *tf = &cmd.tf;
-	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
+	u8 lba48 = ide_dev_lba48(drive);
 
 	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 9490b44..a2ebba0 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -14,7 +14,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 
 	timeout += jiffies;
 	spin_lock_irq(&hwif->lock);
-	if (drive->dev_flags & IDE_DFLAG_PARKED) {
+	if (ide_dev_heads_parked(drive)) {
 		int reset_timer = time_before(timeout, drive->sleep);
 		int start_queue = 0;
 
@@ -94,13 +94,12 @@ ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 	unsigned long now;
 	unsigned int msecs;
 
-	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+	if (ide_dev_no_unload_feature(drive))
 		return -EOPNOTSUPP;
 
 	spin_lock_irq(&hwif->lock);
 	now = jiffies;
-	if (drive->dev_flags & IDE_DFLAG_PARKED &&
-	    time_after(drive->sleep, now))
+	if (ide_dev_heads_parked(drive) && time_after(drive->sleep, now))
 		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
@@ -127,9 +126,9 @@ ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&ide_setting_mtx);
 	if (input >= 0) {
-		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+		if (ide_dev_no_unload_feature(drive))
 			rc = -EOPNOTSUPP;
-		else if (input || drive->dev_flags & IDE_DFLAG_PARKED)
+		else if (input || ide_dev_heads_parked(drive))
 			issue_park_cmd(drive, msecs_to_jiffies(input));
 	} else {
 		if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index ebf2d21..ce28e16 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -118,7 +118,7 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			break;
 		/* Not supported? Switch to next step now. */
 		if (ata_id_flush_enabled(drive->id) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
+		    !ide_dev_wcache_enabled(drive)) {
 			ide_complete_power_step(drive, rq);
 			return ide_stopped;
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 203224c..18fd6ac 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -374,7 +374,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u16 *id = drive->id;
 	int rc;
-	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
+	u8 present = ide_dev_present(drive), stat;
 
 	/* avoid waiting for inappropriate probes */
 	if (present && drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
@@ -488,7 +488,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	strcpy(m, "UNKNOWN");
 
 	/* skip probing? */
-	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
+	if (!ide_dev_noprobe(drive)) {
 		/* if !(success||timed-out) */
 		cmd = ATA_CMD_ID_ATA;
 		rc = do_probe(drive, cmd);
@@ -498,20 +498,22 @@ static u8 probe_for_drive(ide_drive_t *drive)
 			rc = do_probe(drive, cmd);
 		}
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+		if (!ide_dev_present(drive))
 			goto out_free;
 
 		/* identification failed? */
-		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+		if (!ide_dev_id_read(drive)) {
 			if (drive->media == ide_disk) {
-				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
+				pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
 					drive->head, drive->sect);
 			} else if (drive->media == ide_cdrom) {
-				printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
+				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
 			} else {
 				/* nuke it */
-				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
+				pr_warning("%s: Unknown device on bus refused "
+					   "identification, ignoring.\n",
+					   drive->name);
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		} else {
@@ -522,11 +524,11 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		}
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (!ide_dev_present(drive))
 		goto out_free;
 
 	/* The drive wasn't being helpful. Add generic info only */
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+	if (!ide_dev_id_read(drive)) {
 		generic_id(drive);
 		return 1;
 	}
@@ -625,8 +627,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 	/* Now make sure both master & slave are ready */
 	ide_port_for_each_dev(i, drive, hwif) {
 		/* Ignore disks that we will not probe for later. */
-		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
+		if (!ide_dev_noprobe(drive) || ide_dev_present(drive)) {
 			SELECT_DRIVE(drive);
 			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
@@ -658,7 +659,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 {
 	ide_drive_t *dev0 = dev1->hwif->devices[0];
 
-	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if ((dev1->dn & 1) == 0 || !ide_dev_present(dev0))
 		return;
 
 	/* If the models don't match they are not the same product */
@@ -691,8 +692,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
 	BUG_ON(hwif->present);
 
-	if ((hwif->devices[0]->dev_flags & IDE_DFLAG_NOPROBE) &&
-	    (hwif->devices[1]->dev_flags & IDE_DFLAG_NOPROBE))
+	if (ide_dev_noprobe(hwif->devices[0]) &&
+	    ide_dev_noprobe(hwif->devices[1]))
 		return -EACCES;
 
 	/*
@@ -704,7 +705,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		disable_irq(hwif->irq);
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
-		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
+		pr_debug("%s: Wait for ready failed before probe!\n",
+			 hwif->name);
 
 	/*
 	 * Second drive should only exist if first drive was found,
@@ -712,7 +714,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	 */
 	ide_port_for_each_dev(i, drive, hwif) {
 		(void) probe_for_drive(drive);
-		if (drive->dev_flags & IDE_DFLAG_PRESENT)
+		if (ide_dev_present(drive))
 			rc = 0;
 	}
 
@@ -874,7 +876,7 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 	int unit = *part >> PARTN_BITS;
 	ide_drive_t *drive = hwif->devices[unit];
 
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (!ide_dev_present(drive))
 		return NULL;
 
 	if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 0ee8887..cc05db0 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -600,7 +600,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 	int i;
 
 	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+		if (!ide_dev_present(drive))
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1b97d7a..7323ead 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -792,11 +792,11 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
+	if (!ide_dev_dsc_overlap(drive) &&
 	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
-	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
+	if (ide_dev_post_reset(drive)) {
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
@@ -1328,7 +1328,7 @@ static int idetape_init_read(ide_drive_t *drive)
 		 * No point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		if (ide_dev_dsc_overlap(drive)) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
 							tape->merge_bh);
@@ -1604,7 +1604,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		 * point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		if (ide_dev_dsc_overlap(drive)) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
 							tape->merge_bh);
@@ -2216,7 +2216,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
 		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
-		(drive->dev_flags & IDE_DFLAG_USING_DMA) ? ", DMA" : "");
+		ide_dev_using_dma(drive) ? ", DMA" : "");
 
 	ide_proc_register_driver(drive, tape->driver);
 }
@@ -2357,7 +2357,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 	if (drive->media != ide_tape)
 		goto failed;
 
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
+	if (ide_dev_id_read(drive) &&
 	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a3b7a50..6015ac1 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -100,7 +100,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+		if (!ide_dev_using_dma(drive) ||
 		    ide_build_sglist(drive, cmd) == 0 ||
 		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
@@ -370,11 +370,11 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 			drive->name,
 			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
-			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
+			ide_dev_lba48(drive) ? "_EXT" : "");
 		return startstop;
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
+	if (!ide_dev_unmask_irqs(drive))
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
@@ -440,8 +440,6 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	u16 nsect		= 0;
 	char __user *buf = (char __user *)arg;
 
-//	printk("IDE Taskfile ...\n");
-
 	req_task = kzalloc(tasksize, GFP_KERNEL);
 	if (req_task == NULL) return -ENOMEM;
 	if (copy_from_user(req_task, buf, tasksize)) {
@@ -451,7 +449,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	taskout = req_task->out_size;
 	taskin  = req_task->in_size;
-	
+
 	if (taskin > 65536 || taskout > 65536) {
 		err = -EINVAL;
 		goto abort;
@@ -493,7 +491,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
 			 IDE_TFLAG_IN_TF;
 
-	if (drive->dev_flags & IDE_DFLAG_LBA48)
+	if (ide_dev_lba48(drive))
 		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
@@ -610,7 +608,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	if ((cmd.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
-		if (drive->dev_flags & IDE_DFLAG_LBA48)
+		if (ide_dev_lba48(drive))
 			req_task->in_flags.all |= (IDE_HOB_STD_IN_FLAGS << 8);
 	}
 
@@ -637,8 +635,6 @@ abort:
 	kfree(outbuf);
 	kfree(inbuf);
 
-//	printk("IDE Taskfile ioctl ended. rc = %i\n", err);
-
 	return err;
 }
 #endif
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 7b65fe5..a10b6fc 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -155,7 +155,7 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	/* Adjust IRQ enable bit */
 	bit = 1 << (8 + hwif->channel);
 
-	if (drive->dev_flags & IDE_DFLAG_PRESENT)
+	if (ide_dev_present(drive))
 		new &= ~bit;
 	else
 		new |= bit;
@@ -192,8 +192,7 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void ns87415_selectproc (ide_drive_t *drive)
 {
-	ns87415_prepare_drive(drive,
-			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+	ns87415_prepare_drive(drive, ide_dev_using_dma(drive));
 }
 
 static int ns87415_dma_end(ide_drive_t *drive)
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index f7536d1..f5bfa8a 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -168,7 +168,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
-	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
+	if (drive->media != ide_disk || ide_dev_lba48(drive)) {
 		ide_hwif_t *hwif	= drive->hwif;
 		struct request *rq	= hwif->rq;
 		unsigned long high_16	= hwif->extra_base - 16;
@@ -188,7 +188,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
-	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
+	if (drive->media != ide_disk || ide_dev_lba48(drive)) {
 		ide_hwif_t *hwif	= drive->hwif;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index 1c3a829..2305cfb 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -217,7 +217,7 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
 		if (ide_set_dma_mode(drive, mode) == 0 &&
-		    (drive->dev_flags & IDE_DFLAG_USING_DMA))
+		    ide_dev_using_dma(drive))
 			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index ed14968..9bd3617 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -161,7 +161,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	}
 
 	/* enable IRQ if not probing */
-	if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+	if (ide_dev_present(drive)) {
 		reg = inw(hwif->config_data + 3);
 		reg &= 0x13;
 		reg &= ~(1 << hwif->channel);
@@ -173,7 +173,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void trm290_selectproc (ide_drive_t *drive)
 {
-	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+	trm290_prepare_drive(drive, ide_dev_using_dma(drive));
 }
 
 static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5e03b22..cd41502 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -652,6 +652,74 @@ typedef struct ide_drive_s ide_drive_t;
 #define ide_drv_g(disk, cont_type)	\
 	container_of((disk)->private_data, struct cont_type, driver)
 
+#define IDE_AFLAG_CHECK(name, flag) \
+static inline int ide_dev_##name(ide_drive_t *drive) \
+{ \
+	return !!(drive->atapi_flags & flag); \
+}
+
+IDE_AFLAG_CHECK(drq_int, IDE_AFLAG_DRQ_INTERRUPT);
+IDE_AFLAG_CHECK(no_eject, IDE_AFLAG_NO_EJECT);
+IDE_AFLAG_CHECK(pre_atapi12, IDE_AFLAG_PRE_ATAPI12);
+IDE_AFLAG_CHECK(tocaddr_bcd, IDE_AFLAG_TOCADDR_AS_BCD);
+IDE_AFLAG_CHECK(toctracks_bcd, IDE_AFLAG_TOCTRACKS_AS_BCD);
+IDE_AFLAG_CHECK(toc_valid, IDE_AFLAG_TOC_VALID);
+IDE_AFLAG_CHECK(door_locked, IDE_AFLAG_DOOR_LOCKED);
+IDE_AFLAG_CHECK(no_speed_select, IDE_AFLAG_NO_SPEED_SELECT);
+IDE_AFLAG_CHECK(vertos_300_ssd, IDE_AFLAG_VERTOS_300_SSD);
+IDE_AFLAG_CHECK(vertos_600_esd, IDE_AFLAG_VERTOS_600_ESD);
+IDE_AFLAG_CHECK(sanyo_3cd, IDE_AFLAG_SANYO_3CD);
+IDE_AFLAG_CHECK(full_caps, IDE_AFLAG_FULL_CAPS_PAGE);
+IDE_AFLAG_CHECK(can_play_audio, IDE_AFLAG_PLAY_AUDIO_OK);
+IDE_AFLAG_CHECK(le_speed_fields, IDE_AFLAG_LE_SPEED_FIELDS);
+IDE_AFLAG_CHECK(clik, IDE_AFLAG_CLIK_DRIVE);
+IDE_AFLAG_CHECK(zip, IDE_AFLAG_ZIP_DRIVE);
+IDE_AFLAG_CHECK(srfp, IDE_AFLAG_SRFP);
+IDE_AFLAG_CHECK(ignore_dsc, IDE_AFLAG_IGNORE_DSC);
+IDE_AFLAG_CHECK(address_valid, IDE_AFLAG_ADDRESS_VALID);
+IDE_AFLAG_CHECK(busy, IDE_AFLAG_BUSY);
+IDE_AFLAG_CHECK(detect_bs, IDE_AFLAG_DETECT_BS);
+IDE_AFLAG_CHECK(filemark, IDE_AFLAG_FILEMARK);
+IDE_AFLAG_CHECK(medium_present, IDE_AFLAG_MEDIUM_PRESENT);
+IDE_AFLAG_CHECK(no_autoclose, IDE_AFLAG_NO_AUTOCLOSE);
+
+#define IDE_DFLAG_CHECK(name, flag) \
+static inline int ide_dev_##name(ide_drive_t *drive) \
+{ \
+	return !!(drive->dev_flags & flag); \
+}
+
+IDE_DFLAG_CHECK(keep_settings, IDE_DFLAG_KEEP_SETTINGS);
+IDE_DFLAG_CHECK(using_dma, IDE_DFLAG_USING_DMA);
+IDE_DFLAG_CHECK(unmask_irqs, IDE_DFLAG_UNMASK);
+IDE_DFLAG_CHECK(noflush, IDE_DFLAG_NOFLUSH);
+IDE_DFLAG_CHECK(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
+IDE_DFLAG_CHECK(nice1, IDE_DFLAG_NICE1);
+IDE_DFLAG_CHECK(present, IDE_DFLAG_PRESENT);
+IDE_DFLAG_CHECK(id_read, IDE_DFLAG_ID_READ);
+IDE_DFLAG_CHECK(noprobe, IDE_DFLAG_NOPROBE);
+IDE_DFLAG_CHECK(removable, IDE_DFLAG_REMOVABLE);
+IDE_DFLAG_CHECK(attach, IDE_DFLAG_ATTACH);
+IDE_DFLAG_CHECK(forced_geom, IDE_DFLAG_FORCED_GEOM);
+IDE_DFLAG_CHECK(no_unmask, IDE_DFLAG_NO_UNMASK);
+IDE_DFLAG_CHECK(no_32bit_io, IDE_DFLAG_NO_IO_32BIT);
+IDE_DFLAG_CHECK(doorlocking, IDE_DFLAG_DOORLOCKING);
+IDE_DFLAG_CHECK(nodma, IDE_DFLAG_NODMA);
+IDE_DFLAG_CHECK(blocked, IDE_DFLAG_BLOCKED);
+IDE_DFLAG_CHECK(sleeping, IDE_DFLAG_SLEEPING);
+IDE_DFLAG_CHECK(post_reset, IDE_DFLAG_POST_RESET);
+IDE_DFLAG_CHECK(udma33_warned, IDE_DFLAG_UDMA33_WARNED);
+IDE_DFLAG_CHECK(lba48, IDE_DFLAG_LBA48);
+IDE_DFLAG_CHECK(wcache_enabled, IDE_DFLAG_WCACHE);
+IDE_DFLAG_CHECK(ignore_write_err, IDE_DFLAG_NOWERR);
+IDE_DFLAG_CHECK(dma_retry_pio, IDE_DFLAG_DMA_PIO_RETRY);
+IDE_DFLAG_CHECK(does_lba, IDE_DFLAG_LBA);
+IDE_DFLAG_CHECK(no_unload_feature, IDE_DFLAG_NO_UNLOAD);
+IDE_DFLAG_CHECK(heads_parked, IDE_DFLAG_PARKED);
+IDE_DFLAG_CHECK(media_changed, IDE_DFLAG_MEDIA_CHANGED);
+IDE_DFLAG_CHECK(write_protected, IDE_DFLAG_WP);
+IDE_DFLAG_CHECK(format_in_progress, IDE_DFLAG_FORMAT_IN_PROGRESS);
+
 struct ide_port_info;
 
 struct ide_tp_ops {
-- 
1.6.1.3



-- 
Regards/Gruss,
    Boris.
