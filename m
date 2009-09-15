Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZIOGHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZIOGHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZIOGHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:07:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53893 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZIOGHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:07:41 -0400
Date: Tue, 15 Sep 2009 16:07:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: drbd tree build failure
Message-Id: <20090915160739.86e85ab3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
drivers/block/drbd/drbd_req.c:45: error: lvalue required as increment operand
drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
drivers/block/drbd/drbd_req.c:58: error: lvalue required as decrement operand

Caused by commit 954749162c98ca45c42cbc00c9ed6d5d6c0b8bb7 ("DRBD:
request") from the drbd tree interacting with commit
a9327cac440be4d8333bba975cbbf76045096275 ("Seperate read and write
statistics of in_flight requests") from the block tree.

I have applied the following merge fix for today, but there may be a
better fix.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Sep 2009 16:03:50 +1000
Subject: [PATCH] drbd: fix for in_flight change in block tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/drbd/drbd_req.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index cbdc257..0656cf1 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -42,7 +42,7 @@ static void _drbd_start_io_acct(struct drbd_conf *mdev, struct drbd_request *req
 	part_stat_inc(cpu, &mdev->vdisk->part0, ios[rw]);
 	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], bio_sectors(bio));
 	part_stat_unlock();
-	mdev->vdisk->part0.in_flight++;
+	mdev->vdisk->part0.in_flight[rw]++;
 }
 
 /* Update disk stats when completing request upwards */
@@ -55,7 +55,7 @@ static void _drbd_end_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
 	part_stat_add(cpu, &mdev->vdisk->part0, ticks[rw], duration);
 	part_round_stats(cpu, &mdev->vdisk->part0);
 	part_stat_unlock();
-	mdev->vdisk->part0.in_flight--;
+	mdev->vdisk->part0.in_flight[rw]--;
 }
 
 static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const int rw)
-- 
1.6.3.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
