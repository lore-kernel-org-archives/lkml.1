Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbZFJJlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbZFJJlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbZFJJiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZFJJiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/24] GFS2: Add a rgrp bitmap full flag
Date: Wed, 10 Jun 2009 09:30:53 +0100
Message-Id: <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During block allocation, it is useful to know if sections of disk
are full on a finer grained basis than a single resource group.
This can make a performance difference when resource groups have
larger numbers of bitmap blocks, since we no longer have to search
them all block by block in each individual bitmap.

The full flag is set on a per-bitmap basis when it has been
searched and found to have no free space. It is then skipped in
subsequent searches until the flag is reset. The resetting
occurs if we have to drop the glock on the resource group for any
reason, or if we deallocate some blocks within that resource
group and thus free up some space.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index de50d86..dd87379 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -64,9 +64,12 @@ struct gfs2_log_element {
 	const struct gfs2_log_operations *le_ops;
 };
 
+#define GBF_FULL 1
+
 struct gfs2_bitmap {
 	struct buffer_head *bi_bh;
 	char *bi_clone;
+	unsigned long bi_flags;
 	u32 bi_offset;
 	u32 bi_start;
 	u32 bi_len;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index fbacf09..23637b9 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -442,6 +442,7 @@ static int compute_bitstructs(struct gfs2_rgrpd *rgd)
 	for (x = 0; x < length; x++) {
 		bi = rgd->rd_bits + x;
 
+		bi->bi_flags = 0;
 		/* small rgrp; bitmap stored completely in header block */
 		if (length == 1) {
 			bytes = bytes_left;
@@ -769,6 +770,8 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 	}
 
 	if (!(rgd->rd_flags & GFS2_RDF_UPTODATE)) {
+		for (x = 0; x < length; x++)
+			clear_bit(GBF_FULL, &rgd->rd_bits[x].bi_flags);
 		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
 		rgd->rd_flags |= GFS2_RDF_UPTODATE;
 	}
@@ -897,6 +900,7 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 			continue;
 		if (sdp->sd_args.ar_discard)
 			gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bi);
+		clear_bit(GBF_FULL, &bi->bi_flags);
 		memcpy(bi->bi_clone + bi->bi_offset,
 		       bi->bi_bh->b_data + bi->bi_offset, bi->bi_len);
 	}
@@ -1309,30 +1313,37 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 {
 	struct gfs2_bitmap *bi = NULL;
 	const u32 length = rgd->rd_length;
-	u32 blk = 0;
+	u32 blk = BFITNOENT;
 	unsigned int buf, x;
 	const unsigned int elen = *n;
-	const u8 *buffer;
+	const u8 *buffer = NULL;
 
 	*n = 0;
 	/* Find bitmap block that contains bits for goal block */
 	for (buf = 0; buf < length; buf++) {
 		bi = rgd->rd_bits + buf;
-		if (goal < (bi->bi_start + bi->bi_len) * GFS2_NBBY)
-			break;
+		/* Convert scope of "goal" from rgrp-wide to within found bit block */
+		if (goal < (bi->bi_start + bi->bi_len) * GFS2_NBBY) {
+			goal -= bi->bi_start * GFS2_NBBY;
+			goto do_search;
+		}
 	}
+	buf = 0;
+	goal = 0;
 
-	gfs2_assert(rgd->rd_sbd, buf < length);
-
-	/* Convert scope of "goal" from rgrp-wide to within found bit block */
-	goal -= bi->bi_start * GFS2_NBBY;
-
+do_search:
 	/* Search (up to entire) bitmap in this rgrp for allocatable block.
 	   "x <= length", instead of "x < length", because we typically start
 	   the search in the middle of a bit block, but if we can't find an
 	   allocatable block anywhere else, we want to be able wrap around and
 	   search in the first part of our first-searched bit block.  */
 	for (x = 0; x <= length; x++) {
+		bi = rgd->rd_bits + buf;
+
+		if (test_bit(GBF_FULL, &bi->bi_flags) &&
+		    (old_state == GFS2_BLKST_FREE))
+			goto skip;
+
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
 		buffer = bi->bi_bh->b_data + bi->bi_offset;
@@ -1343,33 +1354,39 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 		if (blk != BFITNOENT)
 			break;
 
+		if ((goal == 0) && (old_state == GFS2_BLKST_FREE))
+			set_bit(GBF_FULL, &bi->bi_flags);
+
 		/* Try next bitmap block (wrap back to rgrp header if at end) */
-		buf = (buf + 1) % length;
-		bi = rgd->rd_bits + buf;
+skip:
+		buf++;
+		buf %= length;
 		goal = 0;
 	}
 
-	if (blk != BFITNOENT && old_state != new_state) {
-		*n = 1;
-		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
+	if (blk == BFITNOENT)
+		return blk;
+	*n = 1;
+	if (old_state == new_state)
+		goto out;
+
+	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
+	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
+		    bi->bi_len, blk, new_state);
+	goal = blk;
+	while (*n < elen) {
+		goal++;
+		if (goal >= (bi->bi_len * GFS2_NBBY))
+			break;
+		if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
+		    GFS2_BLKST_FREE)
+			break;
 		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
-			    bi->bi_len, blk, new_state);
-		goal = blk;
-		while (*n < elen) {
-			goal++;
-			if (goal >= (bi->bi_len * GFS2_NBBY))
-				break;
-			if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
-			    GFS2_BLKST_FREE)
-				break;
-			gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone,
-				    bi->bi_offset, bi->bi_len, goal,
-				    new_state);
-			(*n)++;
-		}
+			    bi->bi_len, goal, new_state);
+		(*n)++;
 	}
-
-	return (blk == BFITNOENT) ? blk : (bi->bi_start * GFS2_NBBY) + blk;
+out:
+	return (bi->bi_start * GFS2_NBBY) + blk;
 }
 
 /**
-- 
1.6.0.6

