Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbYDQJns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbYDQJns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763585AbYDQJ0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/48] [GFS2] Add extent allocation to block allocator
Date: Thu, 17 Apr 2008 09:39:01 +0100
Message-Id: <12084216204027-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216182363-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Rather than having to allocate a single block at a time, this patch
allows the block allocator to allocate an extent. Since there is
no difference (so far as the block allocator is concerned) between
data blocks and indirect blocks, it is posible to allocate a single
extent and for the caller to unrevoke just the blocks required
for indirect blocks.

Currently the only bit of GFS2 to make use of this feature is the
build height function. The intention is that gfs2_block_map will
be changed to make use of this feature in future patches.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e3a75a2..1fda731 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -136,8 +136,9 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		/* Get a free block, fill it with the stuffed data,
 		   and write it out to disk */
 
+		unsigned int n = 1;
+		block = gfs2_alloc_block(ip, &n);
 		if (isdir) {
-			block = gfs2_alloc_block(ip);
 			gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), block, 1);
 			error = gfs2_dir_get_new_buffer(ip, block, &bh);
 			if (error)
@@ -146,8 +147,6 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 					      dibh, sizeof(struct gfs2_dinode));
 			brelse(bh);
 		} else {
-			block = gfs2_alloc_block(ip);
-
 			error = gfs2_unstuffer_page(ip, dibh, block, page);
 			if (error)
 				goto out_brelse;
@@ -195,7 +194,7 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 	int error;
 	__be64 *bp;
 	u64 bn;
-	unsigned n;
+	unsigned n, i = 0;
 
 	if (height <= ip->i_height)
 		return 0;
@@ -204,12 +203,16 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 	if (error)
 		return error;
 
-	for(n = 0; n < new_height; n++) {
-		bn = gfs2_alloc_block(ip);
-		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
-		mp->mp_bh[n] = gfs2_meta_new(ip->i_gl, bn);
-		gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[n], 1);
-	}
+	do {
+		n = new_height - i;
+		bn = gfs2_alloc_block(ip, &n);
+		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, n);
+		do {
+			mp->mp_bh[i] = gfs2_meta_new(ip->i_gl, bn++);
+			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i], 1);
+			i++;
+		} while(i < n);
+	} while(i < new_height);
 
 	n = 0;
 	bn = mp->mp_bh[0]->b_blocknr;
@@ -358,6 +361,7 @@ static int lookup_block(struct gfs2_inode *ip, unsigned int height,
 {
 	int boundary;
 	__be64 *ptr = metapointer(&boundary, height, mp);
+	unsigned int n = 1;
 
 	if (*ptr) {
 		*block = be64_to_cpu(*ptr);
@@ -369,7 +373,7 @@ static int lookup_block(struct gfs2_inode *ip, unsigned int height,
 	if (!create)
 		return 0;
 
-	*block = gfs2_alloc_block(ip);
+	*block = gfs2_alloc_block(ip, &n);
 	if (height != ip->i_height - 1 || gfs2_is_dir(ip))
 		gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), *block, 1);
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index fbdf319..93a2e6a 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -803,7 +803,8 @@ got_dent:
 static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh, u16 depth)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	u64 bn = gfs2_alloc_block(ip);
+	unsigned int n = 1;
+	u64 bn = gfs2_alloc_block(ip, &n);
 	struct buffer_head *bh = gfs2_meta_new(ip->i_gl, bn);
 	struct gfs2_leaf *leaf;
 	struct gfs2_dirent *dent;
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index f9f63bc..0e79cd5 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -582,9 +582,10 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_ea_header *ea;
+	unsigned int n = 1;
 	u64 block;
 
-	block = gfs2_alloc_block(ip);
+	block = gfs2_alloc_block(ip, &n);
 	gfs2_trans_add_unrevoke(sdp, block, 1);
 	*bhp = gfs2_meta_new(ip->i_gl, block);
 	gfs2_trans_add_bh(ip->i_gl, *bhp, 1);
@@ -642,8 +643,9 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			struct buffer_head *bh;
 			u64 block;
 			int mh_size = sizeof(struct gfs2_meta_header);
+			unsigned int n = 1;
 
-			block = gfs2_alloc_block(ip);
+			block = gfs2_alloc_block(ip, &n);
 			gfs2_trans_add_unrevoke(sdp, block, 1);
 			bh = gfs2_meta_new(ip->i_gl, block);
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
@@ -966,8 +968,8 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
 	} else {
 		u64 blk;
-
-		blk = gfs2_alloc_block(ip);
+		unsigned int n = 1;
+		blk = gfs2_alloc_block(ip, &n);
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
 		indbh = gfs2_meta_new(ip->i_gl, blk);
 		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 274a2df..77eba0a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -53,7 +53,8 @@ static const char valid_change[16] = {
 };
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-                        unsigned char old_state, unsigned char new_state);
+                        unsigned char old_state, unsigned char new_state,
+			unsigned int *n);
 
 /**
  * gfs2_setbit - Set a bit in the bitmaps
@@ -64,26 +65,32 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
  *
  */
 
-static void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
-			unsigned int buflen, u32 block,
-			unsigned char new_state)
+static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf1,
+			       unsigned char *buf2, unsigned int offset,
+			       unsigned int buflen, u32 block,
+			       unsigned char new_state)
 {
-	unsigned char *byte, *end, cur_state;
-	unsigned int bit;
+	unsigned char *byte1, *byte2, *end, cur_state;
+	const unsigned int bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
 
-	byte = buffer + (block / GFS2_NBBY);
-	bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
-	end = buffer + buflen;
+	byte1 = buf1 + offset + (block / GFS2_NBBY);
+	end = buf1 + offset + buflen;
 
-	gfs2_assert(rgd->rd_sbd, byte < end);
+	BUG_ON(byte1 >= end);
 
-	cur_state = (*byte >> bit) & GFS2_BIT_MASK;
+	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
 
-	if (valid_change[new_state * 4 + cur_state]) {
-		*byte ^= cur_state << bit;
-		*byte |= new_state << bit;
-	} else
+	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
 		gfs2_consist_rgrpd(rgd);
+		return;
+	}
+	*byte1 ^= (cur_state ^ new_state) << bit;
+
+	if (buf2) {
+		byte2 = buf2 + offset + (block / GFS2_NBBY);
+		cur_state = (*byte2 >> bit) & GFS2_BIT_MASK;
+		*byte2 ^= (cur_state ^ new_state) << bit;
+	}
 }
 
 /**
@@ -94,10 +101,12 @@ static void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
  *
  */
 
-static unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
-				  unsigned int buflen, u32 block)
+static inline unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd,
+					 const unsigned char *buffer,
+					 unsigned int buflen, u32 block)
 {
-	unsigned char *byte, *end, cur_state;
+	const unsigned char *byte, *end;
+	unsigned char cur_state;
 	unsigned int bit;
 
 	byte = buffer + (block / GFS2_NBBY);
@@ -877,13 +886,15 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 	u32 goal = 0, block;
 	u64 no_addr;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
+	unsigned int n;
 
 	for(;;) {
 		if (goal >= rgd->rd_data)
 			break;
 		down_write(&sdp->sd_log_flush_lock);
+		n = 1;
 		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
-				     GFS2_BLKST_UNLINKED);
+				     GFS2_BLKST_UNLINKED, &n);
 		up_write(&sdp->sd_log_flush_lock);
 		if (block == BFITNOENT)
 			break;
@@ -1280,6 +1291,7 @@ unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  * @goal: the goal block within the RG (start here to search for avail block)
  * @old_state: GFS2_BLKST_XXX the before-allocation state to find
  * @new_state: GFS2_BLKST_XXX the after-allocation block state
+ * @n: The extent length
  *
  * Walk rgrp's bitmap to find bits that represent a block in @old_state.
  * Add the found bitmap buffer to the transaction.
@@ -1295,13 +1307,17 @@ unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  */
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state, unsigned char new_state)
+			unsigned char old_state, unsigned char new_state,
+			unsigned int *n)
 {
 	struct gfs2_bitmap *bi = NULL;
-	u32 length = rgd->rd_length;
+	const u32 length = rgd->rd_length;
 	u32 blk = 0;
 	unsigned int buf, x;
+	const unsigned int elen = *n;
+	const u8 *buffer;
 
+	*n = 0;
 	/* Find bitmap block that contains bits for goal block */
 	for (buf = 0; buf < length; buf++) {
 		bi = rgd->rd_bits + buf;
@@ -1322,7 +1338,7 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 	for (x = 0; x <= length; x++) {
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
-		const u8 *buffer = bi->bi_bh->b_data + bi->bi_offset;
+		buffer = bi->bi_bh->b_data + bi->bi_offset;
 		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
 			buffer = bi->bi_clone + bi->bi_offset;
 
@@ -1337,12 +1353,21 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 	}
 
 	if (blk != BFITNOENT && old_state != new_state) {
+		*n = 1;
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-		gfs2_setbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
+		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
 			    bi->bi_len, blk, new_state);
-		if (bi->bi_clone)
-			gfs2_setbit(rgd, bi->bi_clone + bi->bi_offset,
-				    bi->bi_len, blk, new_state);
+		while(*n < elen) {
+			goal++;
+			if (goal >= (bi->bi_len / GFS2_NBBY))
+				break;
+			if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
+			    GFS2_BLKST_FREE)
+				break;
+			(*n)++;
+			gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone,
+				    bi->bi_offset, bi->bi_len, blk, new_state);
+		}
 	}
 
 	return (blk == BFITNOENT) ? blk : (bi->bi_start * GFS2_NBBY) + blk;
@@ -1397,7 +1422,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 			       bi->bi_len);
 		}
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-		gfs2_setbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
+		gfs2_setbit(rgd, bi->bi_bh->b_data, NULL, bi->bi_offset,
 			    bi->bi_len, buf_blk, new_state);
 	}
 
@@ -1411,7 +1436,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
  * Returns: the allocated block
  */
 
-u64 gfs2_alloc_block(struct gfs2_inode *ip)
+u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
@@ -1424,26 +1449,26 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip)
 	else
 		goal = rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED, n);
 	BUG_ON(blk == BFITNOENT);
-	rgd->rd_last_alloc = blk;
 
+	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
 	ip->i_goal = block;
 
-	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
-	rgd->rd_rg.rg_free--;
+	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free >= *n);
+	rgd->rd_rg.rg_free -= *n;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-	al->al_alloced++;
+	al->al_alloced += *n;
 
-	gfs2_statfs_change(sdp, 0, -1, 0);
-	gfs2_quota_change(ip, +1, ip->i_inode.i_uid, ip->i_inode.i_gid);
+	gfs2_statfs_change(sdp, 0, -*n, 0);
+	gfs2_quota_change(ip, *n, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
 	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone--;
+	rgd->rd_free_clone -= *n;
 	spin_unlock(&sdp->sd_rindex_spin);
 
 	return block;
@@ -1463,9 +1488,10 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	struct gfs2_rgrpd *rgd = al->al_rgd;
 	u32 blk;
 	u64 block;
+	unsigned int n = 1;
 
 	blk = rgblk_search(rgd, rgd->rd_last_alloc,
-			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE);
+			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE, &n);
 	BUG_ON(blk == BFITNOENT);
 
 	rgd->rd_last_alloc = blk;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 5e66613..3181c7e 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -46,7 +46,7 @@ void gfs2_inplace_release(struct gfs2_inode *ip);
 
 unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
 
-u64 gfs2_alloc_block(struct gfs2_inode *ip);
+u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n);
 u64 gfs2_alloc_di(struct gfs2_inode *ip, u64 *generation);
 
 void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
-- 
1.5.1.2

