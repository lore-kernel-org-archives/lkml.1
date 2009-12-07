Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbZLGATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbZLGATi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbZLGASt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:18:49 -0500
Received: from kroah.org ([198.145.64.141]:34719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbZLGANx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:58 2009
Message-Id: <20091207000657.982743086@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [098/119] block: use after free bug in __blkdev_get
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=block-use-after-free-bug-in-__blkdev_get.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Neil Brown <neilb@suse.de>

commit 960cc0f4fef607baabc2232fbd7cce5368a9dcfd upstream.

commit 0762b8bde9729f10f8e6249809660ff2ec3ad735
(from 14 months ago) introduced a use-after-free bug which has just
recently started manifesting in my md testing.
I tried git bisect to find out what caused the bug to start
manifesting, and it could have been the recent change to
blk_unregister_queue (48c0d4d4c04) but the results were inconclusive.

This patch certainly fixes my symptoms and looks correct as the two
calls are now in the same order as elsewhere in that function.

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1243,8 +1243,8 @@ static int __blkdev_get(struct block_dev
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		put_disk(disk);
 		module_put(disk->fops->owner);
+		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {


