Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZCCIfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZCCIfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZCCIfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:35:16 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37908 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZCCIfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=c2afR/MPKI8SWFvmF7nZ9ypwUnH5fkhAJ6cl9uW2HUWg1i+2kSePr0O7OF7fMJ96ix
         DYoE81JgP5baDUaxKaY3Ti+B9wDgBSrqo1qIGzk7BBvFldXB07P+cUEHH6kFxqoYOC8O
         OpbC5UdH1moFVa2zG6n7YJoV9pfP7lRCr6+m4=
Date: Tue, 3 Mar 2009 09:35:06 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090225: ide-cd triggers BUG at
	arch/x86/mm/ioremap.c:80!
Message-ID: <20090303083506.GA5172@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-kernel@vger.kernel.org
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp> <200903020215.n222FBpu067502@www262.sakura.ne.jp> <9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com> <200903021627.23585.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200903021627.23585.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > @Bart: I'm open for suggestions wrt to a more elegant solution :).
> 
> Seems like we should check for blk_fs_request(fs) || rq->data_len
> instead of unconditionally sg mapping all requests in ->do_request.
> 
> [ Sigh, I thought it is harmless to always call sg_init_one()...
>   probably because it was true back when I added this helper :) ]

how about something like that:

We map to sg once in ide_issue_pc since all drivers call into that.
We have to exclude ide_tape for now since it doesn't do that and uses
its own io buffers-method. Then, we do for both ide-cd and ide-floppy
blk_rq_bytes(rq) in ide_init_sg_cmd() after I've fixed the partial
completions issue later.

Lightly tested with ide-cd for now.

@Tetsuo: please do test, this should fix your OOPS.

Thanks.

--

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index ff6adea..3c7992a 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -625,7 +625,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	struct ide_atapi_pc *pc;
+	struct ide_atapi_pc *uninitialized_var(pc);
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
@@ -642,6 +642,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		if (drive->dma)
 			drive->dma = !ide_dma_prepare(drive, cmd);
+
 	} else {
 		pc = drive->pc;
 
@@ -669,6 +670,17 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 						       : WAIT_TAPE_CMD;
 	}
 
+	if (drive->media != ide_tape &&
+	      !drive->dma && (blk_fs_request(rq) || rq->data_len)) {
+		ide_init_sg_cmd(cmd, blk_rq_bytes(rq));
+		ide_map_sg(drive, cmd);
+
+		if (drive->media == ide_floppy) {
+			pc->sg = hwif->sg_table;
+			pc->sg_cnt = cmd->sg_nents;
+		}
+	}
+
 	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
 
 	(void)do_rw_taskfile(drive, cmd);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9e19aec..e7c278c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -916,10 +916,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd,
-		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
-	ide_map_sg(drive, &cmd);
-
 	return ide_issue_pc(drive, &cmd);
 out_end:
 	nsectors = rq->hard_nr_sectors;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b7f0206..9a58db3 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -244,7 +244,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					     struct request *rq, sector_t block)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
@@ -292,13 +291,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
 	cmd.rq = rq;
-
-	ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
-	ide_map_sg(drive, &cmd);
-
-	pc->sg = hwif->sg_table;
-	pc->sg_cnt = cmd.sg_nents;
-
 	pc->rq = rq;
 
 	return ide_floppy_issue_pc(drive, &cmd, pc);

