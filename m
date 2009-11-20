Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZKTU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZKTU23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZKTU2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:28:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbZKTU14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:27:56 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 12/13] dm snapshot: redirect accesses to origin if merging snap invalidated
Date: Fri, 20 Nov 2009 15:27:52 -0500
Message-Id: <1258748873-24185-13-git-send-email-snitzer@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

If we are merging an invalidated snapshot, redirect all accesses to the
origin device.  This is safe because snapshot_merge_process() will
stop_merge() if the merging snapshot becomes invalid.

Allowing the origin device to remain functional is important because it
may contain the root filesystem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 2b5b083..74f7f38 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1554,11 +1554,9 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
 	down_write(&s->lock);
 
-	/* Full snapshots are not usable */
-	if (!s->valid) {
-		r = -EIO;
-		goto out_unlock;
-	}
+	/* Full merging snapshots are redirected to the origin */
+	if (!s->valid)
+		goto redirect_to_origin;
 
 	/* If the block is already remapped - use that */
 	e = dm_lookup_exception(&s->complete, chunk);
@@ -1581,6 +1579,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 		goto out_unlock;
 	}
 
+ redirect_to_origin:
 	bio->bi_bdev = s->origin->bdev;
 
 	if (bio_rw(bio) == WRITE) {
-- 
1.6.5.2

