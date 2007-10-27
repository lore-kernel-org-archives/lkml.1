Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXJ0Lj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXJ0Lj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXJ0LjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:39:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXJ0LjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:39:20 -0400
Date: Sat, 27 Oct 2007 13:39:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] panic after umount (biscted)
Message-ID: <20071027113916.GH8875@kernel.dk>
References: <20071026070110.GA8927@Chamillionaire.breakpoint.cc> <20071026092724.GC5155@kernel.dk> <20071026093242.GD5155@kernel.dk> <20071026113524.GA10130@Chamillionaire.breakpoint.cc> <20071026114230.GG5155@kernel.dk> <20071027104436.GA19482@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027104436.GA19482@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27 2007, Sebastian Siewior wrote:
> * Jens Axboe | 2007-10-26 13:42:30 [+0200]:
> 
> >> [2] http://download.breakpoint.cc/bug/bug_rc1_patch_reboot.jpeg 171 KiB
> >
> >Ah, second BUG() for same issue. Try this one. This?
> >
> >diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >index 61fdaf0..57fde7b 100644
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
> >@@ -1236,9 +1238,10 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
> > 	if (ret != BLKPREP_OK)
> > 		return ret;
> > 	/*
> >-	 * Filesystem requests must transfer data.
> >+	 * Filesystem requests must transfer data, unless it's an empty
> >+	 * barrier.
> > 	 */
> >-	BUG_ON(!req->nr_phys_segments);
> >+	BUG_ON(!req->nr_phys_segments && !bio_empty_barrier(req->bio));
> > 
> > 	cmd = scsi_get_cmd_from_req(sdev, req);
> > 	if (unlikely(!cmd))
> >
> 
> I'm afraid you did not make it to the next level. I hope you have
> another man :). [1] shows the result. I double checked it, it seems to
> be the same bug() with the second patch.
> 
> [1] http://download.breakpoint.cc/bug/bug_patch2.jpeg 134 KiB

OK, can you see what this produces?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..4042269 100644
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
@@ -1236,9 +1238,11 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (ret != BLKPREP_OK)
 		return ret;
 	/*
-	 * Filesystem requests must transfer data.
+	 * Filesystem requests must transfer data, unless it's an empty
+	 * barrier.
 	 */
-	BUG_ON(!req->nr_phys_segments);
+	if (!req->nr_phys_segments && !bio_empty_barrier(req->bio))
+		blk_dump_rq_flags(req, "scsi");
 
 	cmd = scsi_get_cmd_from_req(sdev, req);
 	if (unlikely(!cmd))

-- 
Jens Axboe

