Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbXJZLof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbXJZLof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXJZLo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:44:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4076 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXJZLoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:44:25 -0400
Date: Fri, 26 Oct 2007 13:42:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] panic after umount (biscted)
Message-ID: <20071026114230.GG5155@kernel.dk>
References: <20071026070110.GA8927@Chamillionaire.breakpoint.cc> <20071026092724.GC5155@kernel.dk> <20071026093242.GD5155@kernel.dk> <20071026113524.GA10130@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026113524.GA10130@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26 2007, Sebastian Siewior wrote:
> * Jens Axboe | 2007-10-26 11:32:42 [+0200]:
> 
> >On Fri, Oct 26 2007, Jens Axboe wrote:
> >> > 
> >> > I hope this was usefull. Now, I'm going to rebuild my raid now....
> >> > 
> >> Thanks a lot, a full report on this issue. Will get this fixed up asap.
> No problem, thanks for working on that :)
> 
> >
> >Does this work?
> >
> >diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >index 61fdaf0..cf47fcb 100644
> >--- a/drivers/scsi/scsi_lib.c
> >+++ b/drivers/scsi/scsi_lib.c
> >@@ -1115,6 +1115,8 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
> > 	 * kmapping pages)
> > 	 */
> > 	cmd->use_sg = req->nr_phys_segments;
> >+	if (!cmd->use_sg)
> >+		return 0;
> > 
> > 	/*
> > 	 * If sg table allocation fails, requeue request later.
> >@@ -1191,7 +1193,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
> > 	if (req->bio) {
> > 		int ret;
> > 
> >-		BUG_ON(!req->nr_phys_segments);
> >+		BUG_ON(!req->nr_phys_segments && req->bio->bi_size);
> > 
> > 		ret = scsi_init_io(cmd);
> > 		if (unlikely(ret))
> >
> 
> Nope. I get [1] on manual umount and [2] on system reboot. This is
> 24-rc1 with this patch on top.
> 
> [1] http://download.breakpoint.cc/bug/bug_rc1_patch_manual.jpeg 163 KiB
> [2] http://download.breakpoint.cc/bug/bug_rc1_patch_reboot.jpeg 171 KiB

Ah, second BUG() for same issue. Try this one. This?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..57fde7b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1115,6 +1115,8 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	 * kmapping pages)
 	 */
 	cmd->use_sg = req->nr_phys_segments;
+	if (!cmd->use_sg)
+		return 0;
 
 	/*
 	 * If sg table allocation fails, requeue request later.
@@ -1191,7 +1193,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	if (req->bio) {
 		int ret;
 
-		BUG_ON(!req->nr_phys_segments);
+		BUG_ON(!req->nr_phys_segments && req->bio->bi_size);
 
 		ret = scsi_init_io(cmd);
 		if (unlikely(ret))
@@ -1236,9 +1238,10 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (ret != BLKPREP_OK)
 		return ret;
 	/*
-	 * Filesystem requests must transfer data.
+	 * Filesystem requests must transfer data, unless it's an empty
+	 * barrier.
 	 */
-	BUG_ON(!req->nr_phys_segments);
+	BUG_ON(!req->nr_phys_segments && !bio_empty_barrier(req->bio));
 
 	cmd = scsi_get_cmd_from_req(sdev, req);
 	if (unlikely(!cmd))

-- 
Jens Axboe

