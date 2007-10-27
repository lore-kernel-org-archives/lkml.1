Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXJ0Kor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXJ0Kor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXJ0Koi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:44:38 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58258 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXJ0Koh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:44:37 -0400
Date: Sat, 27 Oct 2007 12:44:36 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] panic after umount (biscted)
Message-ID: <20071027104436.GA19482@Chamillionaire.breakpoint.cc>
References: <20071026070110.GA8927@Chamillionaire.breakpoint.cc> <20071026092724.GC5155@kernel.dk> <20071026093242.GD5155@kernel.dk> <20071026113524.GA10130@Chamillionaire.breakpoint.cc> <20071026114230.GG5155@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071026114230.GG5155@kernel.dk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe | 2007-10-26 13:42:30 [+0200]:

>> [2] http://download.breakpoint.cc/bug/bug_rc1_patch_reboot.jpeg 171 KiB
>
>Ah, second BUG() for same issue. Try this one. This?
>
>diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>index 61fdaf0..57fde7b 100644
>--- a/drivers/scsi/scsi_lib.c
>+++ b/drivers/scsi/scsi_lib.c
>@@ -1115,6 +1115,8 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
> 	 * kmapping pages)
> 	 */
> 	cmd->use_sg = req->nr_phys_segments;
>+	if (!cmd->use_sg)
>+		return 0;
> 
> 	/*
> 	 * If sg table allocation fails, requeue request later.
>@@ -1191,7 +1193,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
> 	if (req->bio) {
> 		int ret;
> 
>-		BUG_ON(!req->nr_phys_segments);
>+		BUG_ON(!req->nr_phys_segments && req->bio->bi_size);
> 
> 		ret = scsi_init_io(cmd);
> 		if (unlikely(ret))
>@@ -1236,9 +1238,10 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
> 	if (ret != BLKPREP_OK)
> 		return ret;
> 	/*
>-	 * Filesystem requests must transfer data.
>+	 * Filesystem requests must transfer data, unless it's an empty
>+	 * barrier.
> 	 */
>-	BUG_ON(!req->nr_phys_segments);
>+	BUG_ON(!req->nr_phys_segments && !bio_empty_barrier(req->bio));
> 
> 	cmd = scsi_get_cmd_from_req(sdev, req);
> 	if (unlikely(!cmd))
>

I'm afraid you did not make it to the next level. I hope you have
another man :). [1] shows the result. I double checked it, it seems to
be the same bug() with the second patch.

[1] http://download.breakpoint.cc/bug/bug_patch2.jpeg 134 KiB

>Jens Axboe

Sebastian
