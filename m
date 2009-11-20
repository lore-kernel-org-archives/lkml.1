Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZKTU3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZKTU3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZKTU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbZKTU1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:27:55 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 10/13] dm snapshot: do not merge a chunk until active writes to it finish
Date: Fri, 20 Nov 2009 15:27:50 -0500
Message-Id: <1258748873-24185-11-git-send-email-snitzer@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Track merging snapshot device's in-progress writes, to chunks that
were already remapped, and delay merging a chunk until all writes to
that chunk finish.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e1ec4c4..e41be70 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -784,7 +784,8 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 	s->merge_write_interlock_n = 1;
 	up_write(&s->lock);
 
-	/* !!! FIXME: wait until writes to this chunk drain */
+	while (__chunk_is_tracked(s, old_chunk))
+		msleep(1);
 
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
 	return;
@@ -1542,7 +1543,11 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 			r = DM_MAPIO_SUBMITTED;
 			goto out_unlock;
 		}
+
 		remap_exception(s, e, bio, chunk);
+
+		if (bio_rw(bio) == WRITE)
+			map_context->ptr = track_chunk(s, chunk);
 		goto out_unlock;
 	}
 
-- 
1.6.5.2

