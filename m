Return-Path: <linux-kernel-owner+w=401wt.eu-S1762576AbYCAJE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576AbYCAJE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYCAI7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:6285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbYCAI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ltV3/Ri3qVoWtmZ4YyqApnx1Ng/N8f7oFsXRS1q+3ovoyUl1XDN9kq9gbEZyf5rDBVnxhijFZFBt8MS7TO5SWX03C+Ha4mfIZWMUTodtBjkpoYYk6fxFz4bfnx2xY8Ga9Pfqz6I7h7voRvppNcK8p2xKKbOXt/BxHXNh9Xv0ZSI=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/24] ide-tape: remove pipeline-specific code from idetape_mtioctop
Date: Sat,  1 Mar 2008 09:58:33 +0100
Message-Id: <1204361928-30229-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d4a2e73..dd11c7b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2693,7 +2693,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	case MTWEOF:
 		if (tape->write_prot)
 			return -EACCES;
-		idetape_discard_read_pipeline(drive, 1);
 		for (i = 0; i < mt_count; i++) {
 			retval = idetape_write_filemark(drive);
 			if (retval)
@@ -2701,12 +2700,10 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		}
 		return 0;
 	case MTREW:
-		idetape_discard_read_pipeline(drive, 0);
 		if (idetape_rewind_tape(drive))
 			return -EIO;
 		return 0;
 	case MTLOAD:
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					       IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2721,7 +2718,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 				if (!idetape_queue_pc_tail(drive, &pc))
 					tape->door_locked = DOOR_UNLOCKED;
 		}
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
@@ -2729,10 +2725,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
-		idetape_discard_read_pipeline(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2754,11 +2748,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_position_tape(drive,
 			mt_count * tape->user_bs_factor, tape->partition, 0);
 	case MTSETPART:
-		idetape_discard_read_pipeline(drive, 0);
 		return idetape_position_tape(drive, 0, mt_count, 0);
 	case MTFSR:
 	case MTBSR:
-- 
1.5.4.1

