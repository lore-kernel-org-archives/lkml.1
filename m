Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbXLTBwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbXLTBwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbXLTBhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:12429 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbXLTBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KBGnNkKK+MH2QNl28SDAzuECBFsApOmQWy/1rJpZ3kjfHcX8JP0TrlOrxTmpGD/YEhGF8dv6lKTHpKPrnGsvc7+GuPkXk/RoZ8FJtd+64KyMe7IwGXwlwFuwBpunCQcCo2JTYKJRKvbXmtSosSvLJuRstIy4xQsdzC14r0MLFjk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 43/63] ide-cd: rename cdrom_* functions to ide_cd_*
Date: Thu, 20 Dec 2007 02:25:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200225.48667.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* cdrom_prepare_request() -> ide_cd_init_rq()
* cdrom_queue_packet_command() -> ide_cd_queue_pc()
* cdrom_lockdoor() -> ide_cd_lockdoor()
* cdrom_read_toc() -> ide_cd_read_toc()
* cdrom_get_toc_entry() -> ide_cd_get_toc_entry()

This is a preparation to move code handling cdrom.c IOCTLs out of ide-cd.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   83 +++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -206,7 +206,7 @@ void cdrom_analyze_sense_data(ide_drive_
 /*
  * Initialize a ide-cd packet command request
  */
-static void cdrom_prepare_request(ide_drive_t *drive, struct request *rq)
+static void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
 
@@ -225,7 +225,7 @@ static void cdrom_queue_request_sense(id
 		sense = &info->sense_data;
 
 	/* stuff the sense request in front of our current request */
-	cdrom_prepare_request(drive, rq);
+	ide_cd_init_rq(drive, rq);
 
 	rq->data = sense;
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
@@ -1168,8 +1168,7 @@ static ide_startstop_t cdrom_do_packet_c
 	return cdrom_start_packet_command(drive, len, cdrom_do_pc_continuation);
 }
 
-
-static int cdrom_queue_packet_command(ide_drive_t *drive, struct request *rq)
+static int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 {
 	struct request_sense sense;
 	int retries = 10;
@@ -1649,7 +1648,7 @@ static int cdrom_check_status(ide_drive_
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
 
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 
 	req.sense = sense;
 	req.cmd[0] = GPCMD_TEST_UNIT_READY;
@@ -1661,13 +1660,12 @@ static int cdrom_check_status(ide_drive_
 	 */
 	req.cmd[7] = cdi->sanyo_slot % 3;
 
-	return cdrom_queue_packet_command(drive, &req);
+	return ide_cd_queue_pc(drive, &req);
 }
 
-
 /* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
-static int
-cdrom_lockdoor(ide_drive_t *drive, int lockflag, struct request_sense *sense)
+static int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
+			   struct request_sense *sense)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
@@ -1681,11 +1679,11 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
 		stat = 0;
 	} else {
-		cdrom_prepare_request(drive, &req);
+		ide_cd_init_rq(drive, &req);
 		req.sense = sense;
 		req.cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
 		req.cmd[4] = lockflag ? 1 : 0;
-		stat = cdrom_queue_packet_command(drive, &req);
+		stat = ide_cd_queue_pc(drive, &req);
 	}
 
 	/* If we got an illegal field error, the drive
@@ -1731,7 +1729,7 @@ static int cdrom_eject(ide_drive_t *driv
 	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
 		return 0;
 
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 
 	/* only tell drive to close tray if open, if it can do that */
 	if (ejectflag && (cdi->mask & CDC_CLOSE_TRAY))
@@ -1740,7 +1738,8 @@ static int cdrom_eject(ide_drive_t *driv
 	req.sense = sense;
 	req.cmd[0] = GPCMD_START_STOP_UNIT;
 	req.cmd[4] = loej | (ejectflag != 0);
-	return cdrom_queue_packet_command(drive, &req);
+
+	return ide_cd_queue_pc(drive, &req);
 }
 
 static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
@@ -1755,7 +1754,7 @@ static int cdrom_read_capacity(ide_drive
 	int stat;
 	struct request req;
 
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 
 	req.sense = sense;
 	req.cmd[0] = GPCMD_READ_CDVD_CAPACITY;
@@ -1763,7 +1762,7 @@ static int cdrom_read_capacity(ide_drive
 	req.data_len = sizeof(capbuf);
 	req.cmd_flags |= REQ_QUIET;
 
-	stat = cdrom_queue_packet_command(drive, &req);
+	stat = ide_cd_queue_pc(drive, &req);
 	if (stat == 0) {
 		*capacity = 1 + be32_to_cpu(capbuf.lba);
 		*sectors_per_frame =
@@ -1779,7 +1778,7 @@ static int cdrom_read_tocentry(ide_drive
 {
 	struct request req;
 
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 
 	req.sense = sense;
 	req.data =  buf;
@@ -1794,12 +1793,12 @@ static int cdrom_read_tocentry(ide_drive
 	if (msf_flag)
 		req.cmd[1] = 2;
 
-	return cdrom_queue_packet_command(drive, &req);
+	return ide_cd_queue_pc(drive, &req);
 }
 
 
 /* Try to read the entire TOC for the disk into our internal buffer. */
-static int cdrom_read_toc(ide_drive_t *drive, struct request_sense *sense)
+static int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 {
 	int stat, ntracks, i;
 	struct cdrom_info *info = drive->driver_data;
@@ -1967,7 +1966,7 @@ static int ide_cd_read_tochdr(ide_drive_
 	int stat;
 
 	/* Make sure our saved TOC is valid. */
-	stat = cdrom_read_toc(drive, NULL);
+	stat = ide_cd_read_toc(drive, NULL);
 	if (stat)
 		return stat;
 
@@ -1978,7 +1977,7 @@ static int ide_cd_read_tochdr(ide_drive_
 	return 0;
 }
 
-static int cdrom_get_toc_entry(ide_drive_t *drive, int track,
+static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
 				struct atapi_toc_entry **ent)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -2013,7 +2012,7 @@ static int ide_cd_read_tocentry(ide_driv
 	struct atapi_toc_entry *toce;
 	int stat;
 
-	stat = cdrom_get_toc_entry(drive, tocentry->cdte_track, &toce);
+	stat = ide_cd_get_toc_entry(drive, tocentry->cdte_track, &toce);
 	if (stat)
 		return stat;
 
@@ -2039,11 +2038,11 @@ static int ide_cd_fake_play_trkind(ide_d
 	struct request rq;
 	struct request_sense sense;
 
-	stat = cdrom_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
+	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
 	if (stat)
 		return stat;
 
-	stat = cdrom_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
+	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
 	if (stat)
 		return stat;
 
@@ -2055,14 +2054,14 @@ static int ide_cd_fake_play_trkind(ide_d
 	if (lba_end <= lba_start)
 		return -EINVAL;
 
-	cdrom_prepare_request(drive, &rq);
+	ide_cd_init_rq(drive, &rq);
 
 	rq.sense = &sense;
 	rq.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
 	lba_to_msf(lba_start,   &rq.cmd[3], &rq.cmd[4], &rq.cmd[5]);
 	lba_to_msf(lba_end - 1, &rq.cmd[6], &rq.cmd[7], &rq.cmd[8]);
 
-	return cdrom_queue_packet_command(drive, &rq);
+	return ide_cd_queue_pc(drive, &rq);
 }
 
 /* the generic packet interface to cdrom.c */
@@ -2078,7 +2077,7 @@ static int ide_cdrom_packet(struct cdrom
 	/* here we queue the commands from the uniform CD-ROM
 	   layer. the packet must be complete, as we do not
 	   touch it at all. */
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));
@@ -2090,7 +2089,7 @@ static int ide_cdrom_packet(struct cdrom
 		req.cmd_flags |= REQ_QUIET;
 
 	req.sense = cgc->sense;
-	cgc->stat = cdrom_queue_packet_command(drive, &req);
+	cgc->stat = ide_cd_queue_pc(drive, &req);
 	if (!cgc->stat)
 		cgc->buflen -= req.data_len;
 	return cgc->stat;
@@ -2126,7 +2125,7 @@ int ide_cdrom_reset (struct cdrom_device
 	struct request req;
 	int ret;
 
-	cdrom_prepare_request(drive, &req);
+	ide_cd_init_rq(drive, &req);
 	req.cmd_type = REQ_TYPE_SPECIAL;
 	req.cmd_flags = REQ_QUIET;
 	ret = ide_do_drive_cmd(drive, &req, ide_wait);
@@ -2136,7 +2135,7 @@ int ide_cdrom_reset (struct cdrom_device
 	 * lock it again.
 	 */
 	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
-		(void) cdrom_lockdoor(drive, 1, &sense);
+		(void)ide_cd_lockdoor(drive, 1, &sense);
 
 	return ret;
 }
@@ -2149,7 +2148,8 @@ int ide_cdrom_tray_move (struct cdrom_de
 	struct request_sense sense;
 
 	if (position) {
-		int stat = cdrom_lockdoor(drive, 0, &sense);
+		int stat = ide_cd_lockdoor(drive, 0, &sense);
+
 		if (stat)
 			return stat;
 	}
@@ -2161,7 +2161,8 @@ static
 int ide_cdrom_lock_door (struct cdrom_device_info *cdi, int lock)
 {
 	ide_drive_t *drive = cdi->handle;
-	return cdrom_lockdoor(drive, lock, NULL);
+
+	return ide_cd_lockdoor(drive, lock, NULL);
 }
 
 static int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
@@ -2216,7 +2217,7 @@ static int ide_cdrom_select_speed(struct
 	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
 	int stat;
 
-	cdrom_prepare_request(drive, &rq);
+	ide_cd_init_rq(drive, &rq);
 
 	rq.sense = &sense;
 
@@ -2236,7 +2237,7 @@ static int ide_cdrom_select_speed(struct
 		rq.cmd[5] = speed & 0xff;
 	}
 
-	stat = cdrom_queue_packet_command(drive, &rq);
+	stat = ide_cd_queue_pc(drive, &rq);
 
 	if (!ide_cdrom_get_capabilities(drive, buf)) {
 		ide_cdrom_update_speed(drive, buf);
@@ -2302,9 +2303,11 @@ int ide_cdrom_get_last_session (struct c
 	struct request_sense sense;
 	int ret;
 
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || info->toc == NULL)
-		if ((ret = cdrom_read_toc(drive, &sense)))
+	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || !info->toc) {
+		ret = ide_cd_read_toc(drive, &sense);
+		if (ret)
 			return ret;
+	}
 
 	toc = info->toc;
 	ms_info->addr.lba = toc->last_session_lba;
@@ -2321,7 +2324,7 @@ static int ide_cdrom_get_mcn(struct cdro
 	struct request rq;
 	char buf[24];
 
-	cdrom_prepare_request(drive, &rq);
+	ide_cd_init_rq(drive, &rq);
 
 	rq.data = buf;
 	rq.data_len = sizeof(buf);
@@ -2332,7 +2335,7 @@ static int ide_cdrom_get_mcn(struct cdro
 	rq.cmd[3] = 2;		/* format */
 	rq.cmd[8] = sizeof(buf);
 
-	stat = cdrom_queue_packet_command(drive, &rq);
+	stat = ide_cd_queue_pc(drive, &rq);
 	if (stat)
 		return stat;
 
@@ -2916,7 +2919,9 @@ static int idecd_revalidate_disk(struct 
 {
 	struct cdrom_info *info = ide_cd_g(disk);
 	struct request_sense sense;
-	cdrom_read_toc(info->drive, &sense);
+
+	ide_cd_read_toc(info->drive, &sense);
+
 	return  0;
 }
 
@@ -2991,7 +2996,7 @@ static int ide_cd_probe(ide_drive_t *dri
 		goto failed;
 	}
 
-	cdrom_read_toc(drive, &sense);
+	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
 	add_disk(g);
