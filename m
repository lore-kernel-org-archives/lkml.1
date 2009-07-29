Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZG2F3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZG2F3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZG2F3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:29:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41213 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZG2F3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:29:36 -0400
Date: Wed, 29 Jul 2009 15:29:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: drbd tree build failure
Message-Id: <20090729152933.47664b18.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/drbd/drbd_req.c: In function 'drbd_make_request_26':
drivers/block/drbd/drbd_req.c:1023: error: implicit declaration of function 'bio_barrier'
drivers/block/drbd/drbd_actlog.c: In function '_drbd_md_sync_page_io':
drivers/block/drbd/drbd_actlog.c:120: error: implicit declaration of function 'bio_barrier'
drivers/block/drbd/drbd_main.c: In function 'drbd_send_dblock':
drivers/block/drbd/drbd_main.c:2373: error: implicit declaration of function 'bio_barrier'
drivers/block/drbd/drbd_main.c:2375: error: implicit declaration of function 'bio_sync'

Caused by commit d206aaff0c5ee065f382c626ea21c5166a3047a7 ("bio: first
step in sanitizing the bio->bi_rw flag testing") from the block tree.

I applied the following patch for today.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 29 Jul 2009 15:13:31 +1000
Subject: [PATCH] drbd: fixups for block api changes

bio_barrier() and bio_sync() are going away.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 drivers/block/drbd/drbd_main.c   |    4 ++--
 drivers/block/drbd/drbd_req.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 1e53d16..3851869 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -117,7 +117,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	/* check for unsupported barrier op.
 	 * would rather check on EOPNOTSUPP, but that is not reliable.
 	 * don't try again for ANY return value != 0 */
-	if (unlikely(bio_barrier(bio) && !ok)) {
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER) && !ok)) {
 		/* Try again with no barrier */
 		dev_warn(DEV, "Barriers not supported on meta data device - disabling\n");
 		set_bit(MD_NO_BARRIER, &mdev->flags);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 20f4d40..9e051a8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2370,9 +2370,9 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	/* NOTE: no need to check if barriers supported here as we would
 	 *       not pass the test in make_request_common in that case
 	 */
-	if (bio_barrier(req->master_bio))
+	if (bio_rw_flagged(req->master_bio, BIO_RW_BARRIER))
 		dp_flags |= DP_HARDBARRIER;
-	if (bio_sync(req->master_bio))
+	if (bio_rw_flagged(req->master_bio, BIO_RW_SYNCIO))
 		dp_flags |= DP_RW_SYNC;
 	if (mdev->state.conn >= C_SYNC_SOURCE &&
 	    mdev->state.conn <= C_PAUSED_SYNC_T)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index d2b941c..fc8d835 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1020,7 +1020,7 @@ int drbd_make_request_26(struct request_queue *q, struct bio *bio)
 	 * because of those XXX, this is not yet enabled,
 	 * i.e. in drbd_init_set_defaults we set the NO_BARRIER_SUPP bit.
 	 */
-	if (unlikely(bio_barrier(bio) && test_bit(NO_BARRIER_SUPP, &mdev->flags))) {
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER) && test_bit(NO_BARRIER_SUPP, &mdev->flags))) {
 		/* dev_warn(DEV, "Rejecting barrier request as underlying device does not support\n"); */
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
-- 
1.6.3.3

