Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZJZFCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZJZFCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZJZFCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:02:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:40874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbZJZFCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:02:19 -0400
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Date: Mon, 26 Oct 2009 16:03:50 +1100
Message-ID: <19173.11702.129258.49993@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] use after free bug in __blkdev_get
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



commit 0762b8bde9729f10f8e6249809660ff2ec3ad735
(from 14 months ago) introduced a use-after-free bug which has just
recently started manifesting in my md testing.
I tried git bisect to find out what caused the bug to start
manifesting, and it could have been the recent change to
blk_unregister_queue (48c0d4d4c04) but the results were inconclusive.

This patch certainly fixes my symptoms and looks correct as the two
calls are now in the same order as elsewhere in that function.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9cf4b92..8bed055 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1248,8 +1248,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		put_disk(disk);
 		module_put(disk->fops->owner);
+		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
