Return-Path: <linux-kernel-owner+w=401wt.eu-S934663AbYDQJkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbYDQJkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbYDQJZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538AbYDQJZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/48] [GFS2] Introduce array of buffers to struct metapath
Date: Thu, 17 Apr 2008 09:38:50 +0100
Message-Id: <1208421597980-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215961690-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The reason for doing this is to allow all the block mapping code
to share the same array. As a result we can remove two arguments
from lookup_metapath since they are now returned via the array.

We also add a function to drop all refs to buffer heads when we
are done with the metapath. The build_height function shares the
struct metapath, but currently still frees its own buffers, and
this will change in a future patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 08d1be4..2011dd2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -33,6 +33,7 @@
  * keep it small.
  */
 struct metapath {
+	struct buffer_head *mp_bh[GFS2_MAX_META_HEIGHT];
 	__u16 mp_list[GFS2_MAX_META_HEIGHT];
 };
 
@@ -185,12 +186,11 @@ out:
  * Returns: errno
  */
 
-static int build_height(struct inode *inode, unsigned height)
+static int build_height(struct inode *inode, struct metapath *mp, unsigned height)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned new_height = height - ip->i_height;
 	struct buffer_head *dibh;
-	struct buffer_head *blocks[GFS2_MAX_META_HEIGHT];
 	struct gfs2_dinode *di;
 	int error;
 	__be64 *bp;
@@ -206,29 +206,29 @@ static int build_height(struct inode *inode, unsigned height)
 
 	for(n = 0; n < new_height; n++) {
 		bn = gfs2_alloc_meta(ip);
-		blocks[n] = gfs2_meta_new(ip->i_gl, bn);
-		gfs2_trans_add_bh(ip->i_gl, blocks[n], 1);
+		mp->mp_bh[n] = gfs2_meta_new(ip->i_gl, bn);
+		gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[n], 1);
 	}
 
 	n = 0;
-	bn = blocks[0]->b_blocknr;
+	bn = mp->mp_bh[0]->b_blocknr;
 	if (new_height > 1) {
 		for(; n < new_height-1; n++) {
-			gfs2_metatype_set(blocks[n], GFS2_METATYPE_IN,
+			gfs2_metatype_set(mp->mp_bh[n], GFS2_METATYPE_IN,
 					  GFS2_FORMAT_IN);
-			gfs2_buffer_clear_tail(blocks[n],
+			gfs2_buffer_clear_tail(mp->mp_bh[n],
 					       sizeof(struct gfs2_meta_header));
-			bp = (__be64 *)(blocks[n]->b_data +
+			bp = (__be64 *)(mp->mp_bh[n]->b_data +
 				     sizeof(struct gfs2_meta_header));
-			*bp = cpu_to_be64(blocks[n+1]->b_blocknr);
-			brelse(blocks[n]);
-			blocks[n] = NULL;
+			*bp = cpu_to_be64(mp->mp_bh[n+1]->b_blocknr);
+			brelse(mp->mp_bh[n]);
+			mp->mp_bh[n] = NULL;
 		}
 	}
-	gfs2_metatype_set(blocks[n], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
-	gfs2_buffer_copy_tail(blocks[n], sizeof(struct gfs2_meta_header),
+	gfs2_metatype_set(mp->mp_bh[n], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
+	gfs2_buffer_copy_tail(mp->mp_bh[n], sizeof(struct gfs2_meta_header),
 			      dibh, sizeof(struct gfs2_dinode));
-	brelse(blocks[n]);
+	brelse(mp->mp_bh[n]);
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
@@ -314,7 +314,6 @@ static void find_metapath(struct gfs2_inode *ip, u64 block,
 
 /**
  * metapointer - Return pointer to start of metadata in a buffer
- * @bh: The buffer
  * @height: The metadata height (0 = dinode)
  * @mp: The metapath
  *
@@ -323,9 +322,10 @@ static void find_metapath(struct gfs2_inode *ip, u64 block,
  * metadata tree.
  */
 
-static inline __be64 *metapointer(struct buffer_head *bh, int *boundary,
-			       unsigned int height, const struct metapath *mp)
+static inline __be64 *metapointer(int *boundary, unsigned int height,
+				  const struct metapath *mp)
 {
+	struct buffer_head *bh = mp->mp_bh[height];
 	unsigned int head_size = (height > 0) ?
 		sizeof(struct gfs2_meta_header) : sizeof(struct gfs2_dinode);
 	__be64 *ptr;
@@ -339,7 +339,6 @@ static inline __be64 *metapointer(struct buffer_head *bh, int *boundary,
 /**
  * lookup_block - Get the next metadata block in metadata tree
  * @ip: The GFS2 inode
- * @bh: Buffer containing the pointers to metadata blocks
  * @height: The height of the tree (0 = dinode)
  * @mp: The metapath
  * @create: Non-zero if we may create a new meatdata block
@@ -352,12 +351,12 @@ static inline __be64 *metapointer(struct buffer_head *bh, int *boundary,
  *
  */
 
-static int lookup_block(struct gfs2_inode *ip, struct buffer_head *bh,
-			unsigned int height, struct metapath *mp, int create,
+static int lookup_block(struct gfs2_inode *ip, unsigned int height,
+			struct metapath *mp, int create,
 			int *new, u64 *block)
 {
 	int boundary;
-	__be64 *ptr = metapointer(bh, &boundary, height, mp);
+	__be64 *ptr = metapointer(&boundary, height, mp);
 
 	if (*ptr) {
 		*block = be64_to_cpu(*ptr);
@@ -374,7 +373,7 @@ static int lookup_block(struct gfs2_inode *ip, struct buffer_head *bh,
 	else
 		*block = gfs2_alloc_meta(ip);
 
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[height], 1);
 
 	*ptr = cpu_to_be64(*block);
 	ip->i_di.di_blocks++;
@@ -385,32 +384,38 @@ static int lookup_block(struct gfs2_inode *ip, struct buffer_head *bh,
 }
 
 static int lookup_metapath(struct inode *inode, struct metapath *mp,
-			   int create, int *new, u64 *dblock,
-			   struct buffer_head **dibh, struct buffer_head **bh)
+			   int create, int *new, u64 *dblock)
 {
+	struct buffer_head *bh;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int end_of_metadata = ip->i_height - 1;
 	unsigned int x;
-	int ret = gfs2_meta_inode_buffer(ip, bh);
+	int ret = gfs2_meta_inode_buffer(ip, &bh);
 	if (ret)
 		return ret;
 
-	*dibh = *bh;
-	get_bh(*dibh);
+	mp->mp_bh[0] = bh;
 
 	for (x = 0; x < end_of_metadata; x++) {
-		lookup_block(ip, *bh, x, mp, create, new, dblock);
-		brelse(*bh);
-		*bh = NULL;
+		lookup_block(ip, x, mp, create, new, dblock);
 		if (!dblock)
 			return 0;
 
-		ret = gfs2_meta_indirect_buffer(ip, x+1, *dblock, *new, bh);
+		ret = gfs2_meta_indirect_buffer(ip, x+1, *dblock, *new, &mp->mp_bh[x+1]);
 		if (ret)
 			return ret;
 	}
 
-	return lookup_block(ip, *bh, end_of_metadata, mp, create, new, dblock);
+	return lookup_block(ip, end_of_metadata, mp, create, new, dblock);
+}
+
+static void release_metapath(struct metapath *mp)
+{
+	int i;
+
+	for (i = 0; i < GFS2_MAX_META_HEIGHT; i++)
+		if (mp->mp_bh[i])
+			brelse(mp->mp_bh[i]);
 }
 
 static inline void bmap_lock(struct inode *inode, int create)
@@ -449,7 +454,6 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned int bsize = sdp->sd_sb.sb_bsize;
-	struct buffer_head *bh = NULL;
 	int error = 0;
 	int new = 0;
 	u64 dblock = 0;
@@ -457,13 +461,13 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	unsigned int maxlen = bh_map->b_size >> inode->i_blkbits;
 	struct metapath mp;
 	u64 size;
-	struct buffer_head *dibh = NULL;
 	const u64 *arr = sdp->sd_heightsize;
 	BUG_ON(maxlen == 0);
 
 	if (gfs2_assert_warn(sdp, !gfs2_is_stuffed(ip)))
 		return 0;
 
+	memset(mp.mp_bh, 0, sizeof(mp.mp_bh));
 	bmap_lock(inode, create);
 	clear_buffer_mapped(bh_map);
 	clear_buffer_new(bh_map);
@@ -480,13 +484,13 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 			goto out_ok;
 		while (size > arr[height])
 			height++;
-		error = build_height(inode, height);
+		error = build_height(inode, &mp, height);
 		if (error)
 			goto out_fail;
 	}
 
 	find_metapath(ip, lblock, &mp);
-	error = lookup_metapath(inode, &mp, create, &new, &dblock, &dibh, &bh);
+	error = lookup_metapath(inode, &mp, create, &new, &dblock);
 	if (error < 0)
 		goto out_fail;
 	boundary = error;
@@ -496,17 +500,15 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 		if (boundary)
 			set_buffer_boundary(bh_map);
 		if (new) {
-			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-			gfs2_dinode_out(ip, dibh->b_data);
+			gfs2_trans_add_bh(ip->i_gl, mp.mp_bh[0], 1);
+			gfs2_dinode_out(ip, mp.mp_bh[0]->b_data);
 			set_buffer_new(bh_map);
-			goto out_brelse;
+			goto out_ok;
 		}
 		while(--maxlen && !buffer_boundary(bh_map)) {
-			unsigned int end_of_metadata = ip->i_height - 1;
 			u64 eblock;
-
-			mp.mp_list[end_of_metadata]++;
-			boundary = lookup_block(ip, bh, end_of_metadata, &mp, 0, &new, &eblock);
+			mp.mp_list[ip->i_height - 1]++;
+			boundary = lookup_block(ip, ip->i_height - 1, &mp, 0, &new, &eblock);
 			if (eblock != ++dblock)
 				break;
 			bh_map->b_size += (1 << inode->i_blkbits);
@@ -514,14 +516,10 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 				set_buffer_boundary(bh_map);
 		}
 	}
-out_brelse:
-	if (bh)
-		brelse(bh);
 out_ok:
 	error = 0;
 out_fail:
-	if (dibh)
-		brelse(dibh);
+	release_metapath(&mp);
 	bmap_unlock(inode, create);
 	return error;
 }
@@ -819,10 +817,11 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 
 		down_write(&ip->i_rw_mutex);
 		if (size > arr[ip->i_height]) {
+			struct metapath mp;
 			u8 height = ip->i_height;
 			while(size > arr[height])
 				height++;
-			error = build_height(&ip->i_inode, height);
+			error = build_height(&ip->i_inode, &mp, height);
 		}
 		up_write(&ip->i_rw_mutex);
 		if (error)
-- 
1.5.1.2

