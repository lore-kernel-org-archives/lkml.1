Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYI2GbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYI2GbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYI2GaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:30:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:55845 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYI2GaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=f9XYiDr22md4FyYBXW9NOqaD+f44wm6xb95xV0Xf5HOZozyiS942FtBvrY0xtp8Ofe
         y5mskhG+CotcPXPpA+ZRPkCSDCaVR6pqN6hPPBh4fcUzL7bC3FWfH3vP81Yt+XMxcbyK
         Jn3F8Coyp90cXspCdOXbOegUL7VQpIIT+sLVM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/3] ide-cd: debug log enhancements
Date: Mon, 29 Sep 2008 08:29:57 +0200
Message-Id: <1222669799-6565-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some more verbosity to key function calls in ide-cd debug code. While at it,
delete a superfluous comment.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 474bb1d..9ffce7f 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -340,8 +340,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	}
 
 	ide_debug_log(IDE_DBG_RQ, "%s: stat: 0x%x, good_stat: 0x%x, "
-		      "rq->cmd_type: 0x%x, err: 0x%x\n", __func__, stat,
-		      good_stat, rq->cmd_type, err);
+		      "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x, err: 0x%x\n",
+		      __func__, stat, good_stat, rq->cmd[0], rq->cmd_type, err);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -849,7 +849,8 @@ static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, rq->cmd[0]: 0x%x\n",
+		      __func__, rq->cmd[0]);
 
 	/*
 	 * Some of the trailing request sense fields are optional,
@@ -876,7 +877,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	if (!sense)
 		sense = &local_sense;
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
+	ide_debug_log(IDE_DBG_PC, "Call %s, cmd[0]: 0x%x, write: 0x%x, "
 		      "timeout: %d, cmd_flags: 0x%x\n", __func__, cmd[0], write,
 		      timeout, cmd_flags);
 
@@ -1177,8 +1178,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_RQ, "Call %s, write: 0x%x, secs_per_frame: %u\n",
-		      __func__, write, sectors_per_frame);
+	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
+		      "secs_per_frame: %u\n",
+		      __func__, rq->cmd[0], write, sectors_per_frame);
 
 	if (write) {
 		/* disk has become write protected */
@@ -1221,7 +1223,8 @@ static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 
-	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd_type: 0x%x\n", __func__,
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, "
+		      "rq->cmd_type: 0x%x\n", __func__, rq->cmd[0],
 		      rq->cmd_type);
 
 	if (blk_pc_request(rq))
@@ -1257,9 +1260,6 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	}
 }
 
-/*
- * cdrom driver request routine.
- */
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
@@ -1267,8 +1267,10 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	ide_handler_t *fn;
 	int xferlen;
 
-	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd_type: 0x%x, block: %llu\n",
-		      __func__, rq->cmd_type, (unsigned long long)block);
+	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd[0]: 0x%x, "
+		      "rq->cmd_type: 0x%x, block: %llu\n",
+		      __func__, rq->cmd[0], rq->cmd_type,
+		      (unsigned long long)block);
 
 	if (blk_fs_request(rq)) {
 		if (drive->atapi_flags & IDE_AFLAG_SEEKING) {
@@ -1412,6 +1414,10 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
 	*sectors_per_frame = blocklen >> SECTOR_BITS;
+
+	ide_debug_log(IDE_DBG_PROBE, "%s: cap: %lu, sectors_per_frame: %lu\n",
+		      __func__, *capacity, *sectors_per_frame);
+
 	return 0;
 }
 
@@ -1643,6 +1649,9 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 		maxspeed = be16_to_cpup((__be16 *)&buf[8 + 8]);
 	}
 
+	ide_debug_log(IDE_DBG_PROBE, "%s: curspeed: %u, maxspeed: %u\n",
+		      __func__, curspeed, maxspeed);
+
 	cd->current_speed = (curspeed + (176/2)) / 176;
 	cd->max_speed = (maxspeed + (176/2)) / 176;
 }
-- 
1.5.5.4

