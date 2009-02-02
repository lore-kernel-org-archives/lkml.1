Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZBBVj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZBBVj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZBBVjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:39:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:9188 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205AbZBBVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=enUmNlKb2Y+XddGUc/7UFm+YZJgkVVGGADxB/xR56kNo4CrER+YM9FFwEwi/m1Q2VG
         XMPwBcb3usO6EwI/7nBJA8e/mk9SU70Ges8jqMQsPSjL34UInBJWwvcsfc4doHVbGWG4
         0RftWlpuSN1/32TVcpVvjIBBqKndnyA3VPaQ8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:40:00 +0100
Message-Id: <20090202214000.17960.75917.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/14] ide: task_error() -> task_error_cmd()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: task_error() -> task_error_cmd()

* Move ide_error() call from task_error() to task_pio_intr()
  (the only user).

* Drop no longer used arguments from task_error().

* Rename task_error() to ide_error_cmd().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -276,8 +276,7 @@ static void ide_pio_datablock(ide_drive_
 	drive->io_32bit = saved_io_32bit;
 }
 
-static ide_startstop_t task_error(ide_drive_t *drive, struct ide_cmd *cmd,
-				  const char *s, u8 stat)
+static void ide_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (cmd->tf_flags & IDE_TFLAG_FS) {
 		int sectors = cmd->nsect - cmd->nleft;
@@ -293,7 +292,6 @@ static ide_startstop_t task_error(ide_dr
 		if (sectors > 0)
 			ide_end_request(drive, 1, sectors);
 	}
-	return ide_error(drive, s, stat);
 }
 
 void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
@@ -364,7 +362,8 @@ out_end:
 	ide_finish_cmd(drive, cmd, stat);
 	return ide_stopped;
 out_err:
-	return task_error(drive, cmd, __func__, stat);
+	ide_error_cmd(drive, cmd);
+	return ide_error(drive, __func__, stat);
 }
 
 static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
