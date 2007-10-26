Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXJZJeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXJZJeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXJZJeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:34:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20542 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbXJZJeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:34:36 -0400
Date: Fri, 26 Oct 2007 11:32:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] panic after umount (biscted)
Message-ID: <20071026093242.GD5155@kernel.dk>
References: <20071026070110.GA8927@Chamillionaire.breakpoint.cc> <20071026092724.GC5155@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026092724.GC5155@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26 2007, Jens Axboe wrote:
> On Fri, Oct 26 2007, Sebastian Siewior wrote:
> > After umount of 
> > /dev/md/1 on /mnt/sec type xfs (rw,nosuid,nodev,noatime,nodiratime)
> > 
> > I end up with [1] on v2.6.24-rc1. It worked fine with v2.6.23. Bisec
> > came to conclusion that 
> > 
> > |fd5d806266935179deda1502101624832eacd01f is first bad commit
> > |commit fd5d806266935179deda1502101624832eacd01f
> > |Author: Jens Axboe <jens.axboe@oracle.com>
> > |Date:   Tue Oct 16 11:05:02 2007 +0200
> > |
> > |    block: convert blkdev_issue_flush() to use empty barriers
> > |    
> > |    Then we can get rid of ->issue_flush_fn() and all the driver private
> > |    implementations of that.
> > |    
> > |    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > |
> > |:040000 040000 75f5c511fd785fa4c75b955f1818c382593a22ec adf460e288740ca9c0b5ab823dfc2ca04980f3d2 M      block
> > |:040000 040000 a972fe9a2433a00c79fd5ead584c482cd08b4b2c 0f4534094b63fe21c5cf8a6170736abe5c518c00 M      drivers
> > |:040000 040000 ba2a9f681826db89ba5192a7db7139baecde786a fc68a77a41d25c283f39f712216566e9b36d00fc M      include
> > 
> > is the bad boy here.
> > The last panic (with first bad commit) is [2] (there is almost no 
> > difference). My .config [3], lspci [4], bisec-log [5]. The md1 
> > raid is a
> > 
> > |Personalities : [raid1] 
> > |md1 : active raid1 sda2[1]
> > |      174843328 blocks [2/1] [_U]
> > |
> > 
> > I hope this was usefull. Now, I'm going to rebuild my raid now....
> > 
> > [1] http://download.breakpoint.cc/bug/bug_rc1.jpeg 166 KiB
> > [2] http://download.breakpoint.cc/bug/bug_last_commit.jpeg 217 KiB
> > [3] http://download.breakpoint.cc/bug/config.txt 27 KiB
> > [4] http://download.breakpoint.cc/bug/lspci.txt 2.3 KiB
> > [5] http://download.breakpoint.cc/bug/git-bisect-log.txt 2.3K
> 
> Thanks a lot, a full report on this issue. Will get this fixed up asap.

Does this work?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fdaf0..cf47fcb 100644
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

-- 
Jens Axboe

