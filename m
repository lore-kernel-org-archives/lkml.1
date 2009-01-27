Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZA0GTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZA0GTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZA0GTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:19:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:34420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0GTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=FP2rA+Yc5HiCt/L98s75hO5bgJxvEQWm6dWKy7Nm13VrQ/8g86tmiOYfCbTbXZz5Mh
         8n/XyrMZY7KCVFwW7gztKdMJYiVea6eatXbJRe9vWfl/C+Q987bVRL6II4JXis5Mg99m
         1eB9TLaST5riu3u+7PO9+uEkwjkRZeMZenpXc=
Date: Tue, 27 Jan 2009 07:19:07 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ide: improve debugging scheme
Message-ID: <20090127061906.GA22179@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1233002440-4325-1-git-send-email-petkovbb@gmail.com> <1233002440-4325-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1233002440-4325-2-git-send-email-petkovbb@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 09:40:39PM +0100, Borislav Petkov wrote:
> and more specifically, push __func__ into debug
> macro thus making ide_debug_log() calls shorter and more readable.

Ups, sorry, I left the debug on :). Take better that one instead.

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Fri, 2 Jan 2009 13:34:47 +0100
Subject: [PATCH 2/3] ide: improve debugging scheme

and more specifically, push __func__ into debug
macro thus making ide_debug_log() calls shorter and more readable.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c     |  124 ++++++++++++++++++++++------------------------
 drivers/ide/ide-cd.h     |    2 +-
 drivers/ide/ide-floppy.c |   35 ++++++-------
 drivers/ide/ide-gd.c     |    4 +-
 drivers/ide/ide-gd.h     |    2 +-
 include/linux/ide.h      |    9 ++--
 6 files changed, 83 insertions(+), 93 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3907466..1d10a52 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -100,8 +100,7 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 {
 	int log = 0;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, sense_key: 0x%x\n", __func__,
-		      sense->sense_key);
+	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
 
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
@@ -151,13 +150,12 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	unsigned long bio_sectors;
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, error_code: 0x%x, "
-			"sense_key: 0x%x\n", __func__, sense->error_code,
-			sense->sense_key);
+	ide_debug_log(IDE_DBG_SENSE, "error_code: 0x%x, sense_key: 0x%x",
+				     sense->error_code, sense->sense_key);
 
 	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "%s: failed cmd: 0x%x\n",
-				__func__, failed_command->cmd[0]);
+		ide_debug_log(IDE_DBG_SENSE, "failed cmd: 0x%x",
+					     failed_command->cmd[0]);
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
@@ -209,7 +207,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	struct cdrom_info *info		= drive->driver_data;
 	struct request *rq		= &drive->request_sense_rq;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_SENSE, "enter");
 
 	if (sense == NULL)
 		sense = &info->sense_data;
@@ -231,8 +229,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	rq->buffer = (void *) failed_command;
 
 	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
-			      failed_command->cmd[0]);
+		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
+					     failed_command->cmd[0]);
 
 	drive->hwif->rq = NULL;
 
@@ -244,9 +242,8 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	struct request *rq = drive->hwif->rq;
 	int nsectors = rq->hard_cur_sectors;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
-		      "nsectors: %d\n", __func__, rq->cmd[0], uptodate,
-		      nsectors);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, uptodate: 0x%x, nsectors: %d",
+				    rq->cmd[0], uptodate, nsectors);
 
 	if (blk_sense_request(rq) && uptodate) {
 		/*
@@ -287,8 +284,8 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	if (!nsectors)
 		nsectors = 1;
 
-	ide_debug_log(IDE_DBG_FUNC, "Exit %s, uptodate: 0x%x, nsectors: %d\n",
-		      __func__, uptodate, nsectors);
+	ide_debug_log(IDE_DBG_FUNC, "uptodate: 0x%x, nsectors: %d",
+				    uptodate, nsectors);
 
 	ide_end_request(drive, uptodate, nsectors);
 }
@@ -330,9 +327,10 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		return 1;
 	}
 
-	ide_debug_log(IDE_DBG_RQ, "%s: stat: 0x%x, good_stat: 0x%x, "
-		      "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x, err: 0x%x\n",
-		      __func__, stat, good_stat, rq->cmd[0], rq->cmd_type, err);
+	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
+				  "rq->cmd_type: 0x%x, err: 0x%x",
+				  stat, good_stat, rq->cmd[0], rq->cmd_type,
+				  err);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -522,8 +520,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, ireason: 0x%x, rw: 0x%x\n",
-		      __func__, ireason, rw);
+	ide_debug_log(IDE_DBG_FUNC, "ireason: 0x%x, rw: 0x%x", ireason, rw);
 
 	/*
 	 * ireason == 0: the drive wants to receive data from us
@@ -564,7 +561,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, len: %d\n", __func__, len);
+	ide_debug_log(IDE_DBG_FUNC, "len: %d", len);
 
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
@@ -586,8 +583,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 						 struct request *rq)
 {
-	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd_flags: 0x%x\n", __func__,
-		      rq->cmd_flags);
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd_flags: 0x%x", rq->cmd_flags);
 
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
@@ -631,7 +627,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n =
@@ -650,8 +646,7 @@ static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
-	ide_debug_log(IDE_DBG_FUNC, "Call %s, rq->cmd[0]: 0x%x\n",
-		      __func__, rq->cmd[0]);
+	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
 
 	/*
 	 * Some of the trailing request sense fields are optional,
@@ -678,9 +673,9 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	if (!sense)
 		sense = &local_sense;
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, cmd[0]: 0x%x, write: 0x%x, "
-		      "timeout: %d, cmd_flags: 0x%x\n", __func__, cmd[0], write,
-		      timeout, cmd_flags);
+	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x, timeout: %d, "
+				  "cmd_flags: 0x%x",
+				  cmd[0], write, timeout, cmd_flags);
 
 	/* start of retry loop */
 	do {
@@ -764,8 +759,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	u16 len;
 	u8 ireason;
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x\n",
-		      __func__, rq->cmd[0], write);
+	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
+				  rq->cmd[0], write);
 
 	/* check for errors */
 	dma = drive->dma;
@@ -799,8 +794,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
-	ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
-		      __func__, stat, thislen);
+	ide_debug_log(IDE_DBG_PC, "DRQ: stat: 0x%x, thislen: %d",
+				  stat, thislen);
 
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & ATA_DRQ) == 0) {
@@ -865,8 +860,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = hwif->tp_ops->input_data;
 	}
 
-	ide_debug_log(IDE_DBG_PC, "%s: data transfer, rq->cmd_type: 0x%x, "
-		      "ireason: 0x%x\n", __func__, rq->cmd_type, ireason);
+	ide_debug_log(IDE_DBG_PC, "data transfer, rq->cmd_type: 0x%x, "
+				  "ireason: 0x%x",
+				  rq->cmd_type, ireason);
 
 	/* transfer data */
 	while (thislen > 0) {
@@ -977,9 +973,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
-		      "secs_per_frame: %u\n",
-		      __func__, rq->cmd[0], write, sectors_per_frame);
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, write: 0x%x, "
+				  "secs_per_frame: %u",
+				  rq->cmd[0], write, sectors_per_frame);
 
 	if (write) {
 		/* disk has become write protected */
@@ -1015,9 +1011,8 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, "
-		      "rq->cmd_type: 0x%x\n", __func__, rq->cmd[0],
-		      rq->cmd_type);
+	ide_debug_log(IDE_DBG_PC, "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x",
+				  rq->cmd[0], rq->cmd_type);
 
 	if (blk_pc_request(rq))
 		rq->cmd_flags |= REQ_QUIET;
@@ -1056,10 +1051,11 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, "
-		      "rq->cmd_type: 0x%x, block: %llu\n",
-		      __func__, rq->cmd[0], rq->cmd_type,
-		      (unsigned long long)block);
+	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
+				  rq->cmd[0], (unsigned long long)block);
+
+	if (drive->debug_mask & IDE_DBG_RQ)
+		blk_dump_rq_flags(rq, "ide_cd_do_request");
 
 	if (blk_fs_request(rq)) {
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
@@ -1108,7 +1104,7 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	struct cdrom_device_info *cdi = &info->devinfo;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_TEST_UNIT_READY;
@@ -1136,7 +1132,7 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	unsigned len = sizeof(capbuf);
 	u32 blocklen;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
@@ -1168,8 +1164,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
 	*sectors_per_frame = blocklen >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_PROBE, "%s: cap: %lu, sectors_per_frame: %lu\n",
-		      __func__, *capacity, *sectors_per_frame);
+	ide_debug_log(IDE_DBG_PROBE, "cap: %lu, sectors_per_frame: %lu",
+				     *capacity, *sectors_per_frame);
 
 	return 0;
 }
@@ -1180,7 +1176,7 @@ static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
 {
 	unsigned char cmd[BLK_MAX_CDB];
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	memset(cmd, 0, BLK_MAX_CDB);
 
@@ -1210,7 +1206,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	long last_written;
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (toc == NULL) {
 		/* try to allocate space */
@@ -1372,7 +1368,7 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
@@ -1392,7 +1388,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
@@ -1402,8 +1398,8 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 		maxspeed = be16_to_cpup((__be16 *)&buf[8 + 8]);
 	}
 
-	ide_debug_log(IDE_DBG_PROBE, "%s: curspeed: %u, maxspeed: %u\n",
-		      __func__, curspeed, maxspeed);
+	ide_debug_log(IDE_DBG_PROBE, "curspeed: %u, maxspeed: %u",
+				     curspeed, maxspeed);
 
 	cd->current_speed = (curspeed + (176/2)) / 176;
 	cd->max_speed = (maxspeed + (176/2)) / 176;
@@ -1437,7 +1433,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, nslots: %d\n", __func__, nslots);
+	ide_debug_log(IDE_DBG_PROBE, "nslots: %d", nslots);
 
 	devinfo->ops = &ide_cdrom_dops;
 	devinfo->speed = info->current_speed;
@@ -1460,9 +1456,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	mechtype_t mechtype;
 	int nslots = 1;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->media: 0x%x, "
-		      "drive->atapi_flags: 0x%lx\n", __func__, drive->media,
-		      drive->atapi_flags);
+	ide_debug_log(IDE_DBG_PROBE, "media: 0x%x, atapi_flags: 0x%lx",
+				     drive->media, drive->atapi_flags);
 
 	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
 		     CDC_DVD_RAM | CDC_SELECT_DISC | CDC_PLAY_AUDIO |
@@ -1743,7 +1738,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_PROBE, "enter");
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
@@ -1786,7 +1781,7 @@ static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	ide_proc_unregister_driver(drive, info->driver);
 
@@ -1802,7 +1797,7 @@ static void ide_cd_release(struct kref *kref)
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	kfree(info->toc);
 	if (devinfo->handle == drive)
@@ -1961,9 +1956,8 @@ static int ide_cd_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	struct request_sense sense;
 
-	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->driver_req: %s, "
-		      "drive->media: 0x%x\n", __func__, drive->driver_req,
-		      drive->media);
+	ide_debug_log(IDE_DBG_PROBE, "driver_req: %s, media: 0x%x",
+				     drive->driver_req, drive->media);
 
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index ac40d6c..0b82233 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -11,7 +11,7 @@
 #define IDECD_DEBUG_LOG		0
 
 #if IDECD_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, ## args)
 #else
 #define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3eab1c6..93e68ec 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -74,7 +74,7 @@ static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = drive->hwif->rq;
 	int error;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	switch (uptodate) {
 	case 0:
@@ -121,7 +121,7 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (floppy->failed_pc == pc)
 		floppy->failed_pc = NULL;
@@ -140,11 +140,11 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
 			if (floppy->failed_pc)
-				ide_debug_log(IDE_DBG_PC, "pc = %x, ",
+				ide_debug_log(IDE_DBG_PC, "pc = %x",
 					      floppy->failed_pc->c[0]);
 
 			ide_debug_log(IDE_DBG_SENSE, "sense key = %x, asc = %x,"
-				      "ascq = %x\n", floppy->sense_key,
+				      "ascq = %x", floppy->sense_key,
 				      floppy->asc, floppy->ascq);
 		} else
 			printk(KERN_ERR PFX "Error in REQUEST SENSE itself - "
@@ -193,7 +193,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: Retry #%d\n", __func__, pc->retries);
+	ide_debug_log(IDE_DBG_FUNC, "retry #%d", pc->retries);
 
 	pc->retries++;
 
@@ -242,8 +242,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: block: %d, blocks: %d\n", __func__,
-		      block, blocks);
+	ide_debug_log(IDE_DBG_FUNC, "block: %d, blocks: %d", block, blocks);
 
 	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
@@ -287,15 +286,10 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc;
 
-	ide_debug_log(IDE_DBG_FUNC, "%s: dev: %s, cmd: 0x%x, cmd_type: %x, "
-		      "errors: %d\n",
-		      __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		      rq->cmd[0], rq->cmd_type, rq->errors);
-
-	ide_debug_log(IDE_DBG_FUNC, "%s: sector: %ld, nr_sectors: %ld, "
-		      "current_nr_sectors: %d\n",
-		      __func__, (long)rq->sector, rq->nr_sectors,
-		      rq->current_nr_sectors);
+	if (drive->debug_mask & IDE_DBG_RQ)
+		blk_dump_rq_flags(rq, (rq->rq_disk
+					? rq->rq_disk->disk_name
+					: "dev?"));
 
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc)
@@ -436,8 +430,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
-			      "%d sector size\n",
-			      i, blocks * length / 1024, blocks, length);
+					     "%d sector size",
+					     i, blocks * length / 1024,
+					     blocks, length);
 
 		if (i)
 			continue;
@@ -493,8 +488,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 				"in drive\n", drive->name);
 			break;
 		}
-		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d\n",
-			      pc.buf[desc_start + 4] & 0x03);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d",
+					     pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 7857b20..b99fd23 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -181,7 +181,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 
 	drive = idkp->drive;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	idkp->openers++;
 
@@ -231,7 +231,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
diff --git a/drivers/ide/ide-gd.h b/drivers/ide/ide-gd.h
index a86779f..ae61a6c 100644
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -8,7 +8,7 @@
 #define IDE_GD_DEBUG_LOG	0
 
 #if IDE_GD_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, ## args)
 #else
 #define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index b3688fc..fe2cb43 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1043,10 +1043,11 @@ enum {
 };
 
 /* DRV_NAME has to be defined in the driver before using the macro below */
-#define __ide_debug_log(lvl, fmt, args...)			\
-{								\
-	if (unlikely(drive->debug_mask & lvl))			\
-		printk(KERN_INFO DRV_NAME ": " fmt, ## args);	\
+#define __ide_debug_log(lvl, fmt, args...)				\
+{									\
+	if (unlikely(drive->debug_mask & lvl))				\
+		printk(KERN_INFO DRV_NAME ": %s: " fmt "\n",		\
+					  __func__, ## args);		\
 }
 
 /*
-- 
1.6.0.4

-- 
Regards/Gruss,
    Boris.
