Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXLNAj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXLNAj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932552AbXLNAjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:39:17 -0500
Received: from thunk.org ([69.25.196.29]:50303 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762844AbXLNAjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:39:15 -0500
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: What happened to this patch?  (Re: [BUG] panic after umount (biscted))
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1J2yZg-0004aQ-Rn@closure.thunk.org>
Date: Thu, 13 Dec 2007 19:38:44 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was going through my set of kernel patches that I've cherry picked on
LKML for my private kernel, and I noticed this hasn't gotten merged into
mainline yet.   The original thread was here:

	 http://lkml.org/lkml/2007/10/27/61

and addressed a panic after a umount reported by Sebastian Siewior.  Was
this addressed in some other way?

          					- Ted


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

