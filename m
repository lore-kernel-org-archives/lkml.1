Return-Path: <linux-kernel-owner+w=401wt.eu-S1765661AbYDQJuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765661AbYDQJuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbYDQJ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763729AbYDQJ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:26 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 35/48] [GFS2] Allow bmap to allocate extents
Date: Thu, 17 Apr 2008 09:39:11 +0100
Message-Id: <12084216402644-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216391215-git-send-email-swhiteho@redhat.com>
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
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We've supported mapping of extents when no block allocation is required
for some time. This patch extends that to mapping of extents when an
allocation has been requested. In that case we try to allocate as many
blocks as are requested, but we might return fewer in case there is
something preventing us from returning the complete amount (e.g. an
already allocated block is in the way).

Currently the only code path which can actually request multiple data
blocks in a single bmap call is the page_mkwrite path and even then it
only happens if there are multiple blocks per page. What this patch does
do however, is merge the allocation requests for metadata (growing the
metadata tree in either height or depth) with the allocation of the data
blocks in the case that both are needed. This results in lower overheads
even in the single block allocation case.

The one thing which we can't handle here at the moment is unstuffing. I
would like to be able to do that, but the problem which arises is that
in order to unstuff one has to get a locked page from the page cache
which results in locking problems in the (usual) case that the caller is
holding the page lock on the page it wishes to map. So that case will
have to be addressed in future patches.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index f1f38ca..c1ee635 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -175,74 +175,13 @@ out:
 	return error;
 }
 
-/**
- * build_height - Build a metadata tree of the requested height
- * @ip: The GFS2 inode
- * @height: The height to build to
- *
- *
- * Returns: errno
- */
-
-static int build_height(struct inode *inode, struct metapath *mp, unsigned height)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	unsigned new_height = height - ip->i_height;
-	struct buffer_head *dibh = mp->mp_bh[0];
-	struct gfs2_dinode *di;
-	__be64 *bp;
-	u64 bn;
-	unsigned n, i = 0;
-
-	BUG_ON(height <= ip->i_height);
-
-	do {
-		n = new_height - i;
-		bn = gfs2_alloc_block(ip, &n);
-		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, n);
-		do {
-			mp->mp_bh[i + 1] = gfs2_meta_new(ip->i_gl, bn++);
-			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i + 1], 1);
-			i++;
-		} while(i < n);
-	} while(i < new_height);
-
-	n = 0;
-	bn = mp->mp_bh[1]->b_blocknr;
-	if (new_height > 1) {
-		for(; n < new_height-1; n++) {
-			gfs2_metatype_set(mp->mp_bh[n + 1], GFS2_METATYPE_IN,
-					  GFS2_FORMAT_IN);
-			gfs2_buffer_clear_tail(mp->mp_bh[n + 1],
-					       sizeof(struct gfs2_meta_header));
-			bp = (__be64 *)(mp->mp_bh[n + 1]->b_data +
-				     sizeof(struct gfs2_meta_header));
-			*bp = cpu_to_be64(mp->mp_bh[n+2]->b_blocknr);
-			brelse(mp->mp_bh[n+1]);
-			mp->mp_bh[n+1] = NULL;
-		}
-	}
-	gfs2_metatype_set(mp->mp_bh[n+1], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
-	gfs2_buffer_copy_tail(mp->mp_bh[n+1], sizeof(struct gfs2_meta_header),
-			      dibh, sizeof(struct gfs2_dinode));
-	brelse(mp->mp_bh[n+1]);
-	mp->mp_bh[n+1] = NULL;
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	di = (struct gfs2_dinode *)dibh->b_data;
-	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
-	*(__be64 *)(di + 1) = cpu_to_be64(bn);
-	ip->i_height += new_height;
-	gfs2_add_inode_blocks(&ip->i_inode, new_height);
-	di->di_height = cpu_to_be16(ip->i_height);
-	di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	return 0;
-}
 
 /**
  * find_metapath - Find path through the metadata tree
- * @ip: The inode pointer
+ * @sdp: The superblock
  * @mp: The metapath to return the result in
  * @block: The disk block to look up
+ * @height: The pre-calculated height of the metadata tree
  *
  *   This routine returns a struct metapath structure that defines a path
  *   through the metadata of inode "ip" to get to block "block".
@@ -297,17 +236,27 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
  *
  */
 
-static void find_metapath(struct gfs2_inode *ip, u64 block,
-			  struct metapath *mp)
+static void find_metapath(const struct gfs2_sbd *sdp, u64 block,
+			  struct metapath *mp, unsigned int height)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	unsigned int i;
 
-	for (i = ip->i_height; i--;)
+	for (i = height; i--;)
 		mp->mp_list[i] = do_div(block, sdp->sd_inptrs);
 
 }
 
+static inline unsigned int zero_metapath_length(const struct metapath *mp,
+						unsigned height)
+{
+	unsigned int i;
+	for (i = 0; i < height - 1; i++) {
+		if (mp->mp_list[i] != 0)
+			return i;
+	}
+	return height;
+}
+
 /**
  * metapointer - Return pointer to start of metadata in a buffer
  * @height: The metadata height (0 = dinode)
@@ -318,95 +267,62 @@ static void find_metapath(struct gfs2_inode *ip, u64 block,
  * metadata tree.
  */
 
-static inline __be64 *metapointer(int *boundary, unsigned int height,
-				  const struct metapath *mp)
+static inline __be64 *metapointer(unsigned int height, const struct metapath *mp)
 {
 	struct buffer_head *bh = mp->mp_bh[height];
 	unsigned int head_size = (height > 0) ?
 		sizeof(struct gfs2_meta_header) : sizeof(struct gfs2_dinode);
-	__be64 *ptr;
-	*boundary = 0;
-	ptr = ((__be64 *)(bh->b_data + head_size)) + mp->mp_list[height];
-	if (ptr + 1 == (__be64 *)(bh->b_data + bh->b_size))
-		*boundary = 1;
-	return ptr;
+	return ((__be64 *)(bh->b_data + head_size)) + mp->mp_list[height];
 }
 
 /**
- * lookup_block - Get the next metadata block in metadata tree
- * @ip: The GFS2 inode
- * @height: The height of the tree (0 = dinode)
+ * lookup_metapath - Walk the metadata tree to a specific point
+ * @ip: The inode
  * @mp: The metapath
- * @create: Non-zero if we may create a new meatdata block
- * @new: Used to indicate if we did create a new metadata block
- * @block: the returned disk block number
  *
- * Given a metatree, complete to a particular height, checks to see if the next
- * height of the tree exists. If not the next height of the tree is created.
- * The block number of the next height of the metadata tree is returned.
+ * Assumes that the inode's buffer has already been looked up and
+ * hooked onto mp->mp_bh[0] and that the metapath has been initialised
+ * by find_metapath().
  *
+ * If this function encounters part of the tree which has not been
+ * allocated, it returns the current height of the tree at the point
+ * at which it found the unallocated block. Blocks which are found are
+ * added to the mp->mp_bh[] list.
+ *
+ * Returns: error or height of metadata tree
  */
 
-static int lookup_block(struct gfs2_inode *ip, unsigned int height,
-			struct metapath *mp, int create,
-			int *new, u64 *block)
+static int lookup_metapath(struct gfs2_inode *ip, struct metapath *mp)
 {
-	int boundary;
-	__be64 *ptr = metapointer(&boundary, height, mp);
-	unsigned int n = 1;
-
-	if (*ptr) {
-		*block = be64_to_cpu(*ptr);
-		return boundary;
-	}
-
-	*block = 0;
-
-	if (!create)
-		return 0;
-
-	*block = gfs2_alloc_block(ip, &n);
-	if (height != ip->i_height - 1 || gfs2_is_dir(ip))
-		gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), *block, 1);
-
-	gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[height], 1);
-
-	*ptr = cpu_to_be64(*block);
-	gfs2_add_inode_blocks(&ip->i_inode, 1);
-
-	*new = 1;
-	return 0;
-}
-
-static int lookup_metapath(struct inode *inode, struct metapath *mp,
-			   int create, int *new, u64 *dblock)
-{
-	struct buffer_head *bh;
-	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int end_of_metadata = ip->i_height - 1;
 	unsigned int x;
+	__be64 *ptr;
+	u64 dblock;
 	int ret;
 
 	for (x = 0; x < end_of_metadata; x++) {
-		lookup_block(ip, x, mp, create, new, dblock);
-		if (!*dblock)
-			return 0;
+		ptr = metapointer(x, mp);
+		dblock = be64_to_cpu(*ptr);
+		if (!dblock)
+			return x + 1;
 
-		ret = gfs2_meta_indirect_buffer(ip, x+1, *dblock, *new, &mp->mp_bh[x+1]);
+		ret = gfs2_meta_indirect_buffer(ip, x+1, dblock, 0, &mp->mp_bh[x+1]);
 		if (ret)
 			return ret;
 	}
 
-	return lookup_block(ip, end_of_metadata, mp, create, new, dblock);
+	return ip->i_height;
 }
 
-static void release_metapath(struct metapath *mp)
+static inline void release_metapath(struct metapath *mp)
 {
 	int i;
 
-	for (i = 0; i < GFS2_MAX_META_HEIGHT; i++)
-		if (mp->mp_bh[i])
-			brelse(mp->mp_bh[i]);
+	for (i = 0; i < GFS2_MAX_META_HEIGHT; i++) {
+		if (mp->mp_bh[i] == NULL)
+			break;
+		brelse(mp->mp_bh[i]);
+	}
 }
 
 /**
@@ -445,32 +361,208 @@ static inline unsigned int gfs2_extent_length(void *start, unsigned int len, __b
 	return (ptr - first);
 }
 
-static inline void bmap_lock(struct inode *inode, int create)
+static inline void bmap_lock(struct gfs2_inode *ip, int create)
 {
-	struct gfs2_inode *ip = GFS2_I(inode);
 	if (create)
 		down_write(&ip->i_rw_mutex);
 	else
 		down_read(&ip->i_rw_mutex);
 }
 
-static inline void bmap_unlock(struct inode *inode, int create)
+static inline void bmap_unlock(struct gfs2_inode *ip, int create)
 {
-	struct gfs2_inode *ip = GFS2_I(inode);
 	if (create)
 		up_write(&ip->i_rw_mutex);
 	else
 		up_read(&ip->i_rw_mutex);
 }
 
+static inline __be64 *gfs2_indirect_init(struct metapath *mp,
+					 struct gfs2_glock *gl, unsigned int i,
+					 unsigned offset, u64 bn)
+{
+	__be64 *ptr = (__be64 *)(mp->mp_bh[i - 1]->b_data +
+		       ((i > 1) ? sizeof(struct gfs2_meta_header) :
+				 sizeof(struct gfs2_dinode)));
+	BUG_ON(i < 1);
+	BUG_ON(mp->mp_bh[i] != NULL);
+	mp->mp_bh[i] = gfs2_meta_new(gl, bn);
+	gfs2_trans_add_bh(gl, mp->mp_bh[i], 1);
+	gfs2_metatype_set(mp->mp_bh[i], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
+	gfs2_buffer_clear_tail(mp->mp_bh[i], sizeof(struct gfs2_meta_header));
+	ptr += offset;
+	*ptr = cpu_to_be64(bn);
+	return ptr;
+}
+
+enum alloc_state {
+	ALLOC_DATA = 0,
+	ALLOC_GROW_DEPTH = 1,
+	ALLOC_GROW_HEIGHT = 2,
+	/* ALLOC_UNSTUFF = 3,   TBD and rather complicated */
+};
+
+/**
+ * gfs2_bmap_alloc - Build a metadata tree of the requested height
+ * @inode: The GFS2 inode
+ * @lblock: The logical starting block of the extent
+ * @bh_map: This is used to return the mapping details
+ * @mp: The metapath
+ * @sheight: The starting height (i.e. whats already mapped)
+ * @height: The height to build to
+ * @maxlen: The max number of data blocks to alloc
+ *
+ * In this routine we may have to alloc:
+ *   i) Indirect blocks to grow the metadata tree height
+ *  ii) Indirect blocks to fill in lower part of the metadata tree
+ * iii) Data blocks
+ *
+ * The function is in two parts. The first part works out the total
+ * number of blocks which we need. The second part does the actual
+ * allocation asking for an extent at a time (if enough contiguous free
+ * blocks are available, there will only be one request per bmap call)
+ * and uses the state machine to initialise the blocks in order.
+ *
+ * Returns: errno on error
+ */
+
+static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
+			   struct buffer_head *bh_map, struct metapath *mp,
+			   const unsigned int sheight,
+			   const unsigned int height,
+			   const unsigned int maxlen)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct buffer_head *dibh = mp->mp_bh[0];
+	u64 bn, dblock = 0;
+	unsigned n, i, blks, alloced = 0, iblks = 0, zmpl = 0;
+	unsigned dblks = 0;
+	unsigned ptrs_per_blk;
+	const unsigned end_of_metadata = height - 1;
+	int eob = 0;
+	enum alloc_state state;
+	__be64 *ptr;
+	__be64 zero_bn = 0;
+
+	BUG_ON(sheight < 1);
+	BUG_ON(dibh == NULL);
+
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+
+	if (height == sheight) {
+		struct buffer_head *bh;
+		/* Bottom indirect block exists, find unalloced extent size */
+		ptr = metapointer(end_of_metadata, mp);
+		bh = mp->mp_bh[end_of_metadata];
+		dblks = gfs2_extent_length(bh->b_data, bh->b_size, ptr, maxlen,
+					   &eob);
+		BUG_ON(dblks < 1);
+		state = ALLOC_DATA;
+	} else {
+		/* Need to allocate indirect blocks */
+		ptrs_per_blk = height > 1 ? sdp->sd_inptrs : sdp->sd_diptrs;
+		dblks = min(maxlen, ptrs_per_blk - mp->mp_list[end_of_metadata]);
+		if (height == ip->i_height) {
+			/* Writing into existing tree, extend tree down */
+			iblks = height - sheight;
+			state = ALLOC_GROW_DEPTH;
+		} else {
+			/* Building up tree height */
+			state = ALLOC_GROW_HEIGHT;
+			iblks = height - ip->i_height;
+			zmpl = zero_metapath_length(mp, height);
+			iblks -= zmpl;
+			iblks += height;
+		}
+	}
+
+	/* start of the second part of the function (state machine) */
+
+	blks = dblks + iblks;
+	i = sheight;
+	do {
+		n = blks - alloced;
+		bn = gfs2_alloc_block(ip, &n);
+		alloced += n;
+		if (state != ALLOC_DATA || gfs2_is_jdata(ip))
+			gfs2_trans_add_unrevoke(sdp, bn, n);
+		switch (state) {
+		/* Growing height of tree */
+		case ALLOC_GROW_HEIGHT:
+			if (i == 1) {
+				ptr = (__be64 *)(dibh->b_data +
+						 sizeof(struct gfs2_dinode));
+				zero_bn = *ptr;
+			}
+			for (; i - 1 < height - ip->i_height && n > 0; i++, n--)
+				gfs2_indirect_init(mp, ip->i_gl, i, 0, bn++);
+			if (i - 1 == height - ip->i_height) {
+				i--;
+				gfs2_buffer_copy_tail(mp->mp_bh[i],
+						sizeof(struct gfs2_meta_header),
+						dibh, sizeof(struct gfs2_dinode));
+				gfs2_buffer_clear_tail(dibh,
+						sizeof(struct gfs2_dinode) +
+						sizeof(__be64));
+				ptr = (__be64 *)(mp->mp_bh[i]->b_data +
+					sizeof(struct gfs2_meta_header));
+				*ptr = zero_bn;
+				state = ALLOC_GROW_DEPTH;
+				for(i = zmpl; i < height; i++) {
+					if (mp->mp_bh[i] == NULL)
+						break;
+					brelse(mp->mp_bh[i]);
+					mp->mp_bh[i] = NULL;
+				}
+				i = zmpl;
+			}
+			if (n == 0)
+				break;
+		/* Branching from existing tree */
+		case ALLOC_GROW_DEPTH:
+			if (i > 1 && i < height)
+				gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i-1], 1);
+			for (; i < height && n > 0; i++, n--)
+				gfs2_indirect_init(mp, ip->i_gl, i,
+						   mp->mp_list[i-1], bn++);
+			if (i == height)
+				state = ALLOC_DATA;
+			if (n == 0)
+				break;
+		/* Tree complete, adding data blocks */
+		case ALLOC_DATA:
+			BUG_ON(n > dblks);
+			BUG_ON(mp->mp_bh[end_of_metadata] == NULL);
+			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[end_of_metadata], 1);
+			dblks = n;
+			ptr = metapointer(end_of_metadata, mp);
+			dblock = bn;
+			while (n-- > 0)
+				*ptr++ = cpu_to_be64(bn++);
+			break;
+		}
+	} while (state != ALLOC_DATA);
+
+	ip->i_height = height;
+	gfs2_add_inode_blocks(&ip->i_inode, alloced);
+	gfs2_dinode_out(ip, mp->mp_bh[0]->b_data);
+	map_bh(bh_map, inode->i_sb, dblock);
+	bh_map->b_size = dblks << inode->i_blkbits;
+	set_buffer_new(bh_map);
+	return 0;
+}
+
 /**
  * gfs2_block_map - Map a block from an inode to a disk block
  * @inode: The inode
  * @lblock: The logical block number
  * @bh_map: The bh to be mapped
+ * @create: True if its ok to alloc blocks to satify the request
  *
- * Find the block number on the current device which corresponds to an
- * inode's block. If the block had to be created, "new" will be set.
+ * Sets buffer_mapped() if successful, sets buffer_boundary() if a
+ * read of metadata will be required before the next block can be
+ * mapped. Sets buffer_new() if new blocks were allocated.
  *
  * Returns: errno
  */
@@ -481,21 +573,21 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned int bsize = sdp->sd_sb.sb_bsize;
-	int error = 0;
-	int new = 0;
-	u64 dblock = 0;
-	int boundary;
-	unsigned int maxlen = bh_map->b_size >> inode->i_blkbits;
-	struct metapath mp;
-	u64 size;
+	const unsigned int maxlen = bh_map->b_size >> inode->i_blkbits;
 	const u64 *arr = sdp->sd_heightsize;
-	BUG_ON(maxlen == 0);
+	__be64 *ptr;
+	u64 size;
+	struct metapath mp;
+	int ret;
+	int eob;
+	unsigned int len;
+	struct buffer_head *bh;
+	u8 height;
 
-	if (gfs2_assert_warn(sdp, !gfs2_is_stuffed(ip)))
-		return 0;
+	BUG_ON(maxlen == 0);
 
 	memset(mp.mp_bh, 0, sizeof(mp.mp_bh));
-	bmap_lock(inode, create);
+	bmap_lock(ip, create);
 	clear_buffer_mapped(bh_map);
 	clear_buffer_new(bh_map);
 	clear_buffer_boundary(bh_map);
@@ -503,56 +595,50 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 		bsize = sdp->sd_jbsize;
 		arr = sdp->sd_jheightsize;
 	}
-	size = (lblock + 1) * bsize;
 
-	error = gfs2_meta_inode_buffer(ip, &mp.mp_bh[0]);
-	if (error)
-		goto out_fail;
-
-	if (size > arr[ip->i_height]) {
-		u8 height = ip->i_height;
-		if (!create)
-			goto out_ok;
-		while (size > arr[height])
-			height++;
-		error = build_height(inode, &mp, height);
-		if (error)
-			goto out_fail;
-	}
+	ret = gfs2_meta_inode_buffer(ip, &mp.mp_bh[0]);
+	if (ret)
+		goto out;
 
-	find_metapath(ip, lblock, &mp);
-	error = lookup_metapath(inode, &mp, create, &new, &dblock);
-	if (error < 0)
-		goto out_fail;
-	boundary = error;
-
-	if (new) {
-		map_bh(bh_map, inode->i_sb, dblock);
-		if (boundary)
-			set_buffer_boundary(bh_map);
-		gfs2_trans_add_bh(ip->i_gl, mp.mp_bh[0], 1);
-		gfs2_dinode_out(ip, mp.mp_bh[0]->b_data);
-		set_buffer_new(bh_map);
-		goto out_ok;
-	}
+	height = ip->i_height;
+	size = (lblock + 1) * bsize;
+	while (size > arr[height])
+		height++;
+	find_metapath(sdp, lblock, &mp, height);
+	ret = 1;
+	if (height > ip->i_height || gfs2_is_stuffed(ip))
+		goto do_alloc;
+	ret = lookup_metapath(ip, &mp);
+	if (ret < 0)
+		goto out;
+	if (ret != ip->i_height)
+		goto do_alloc;
+	ptr = metapointer(ip->i_height - 1, &mp);
+	if (*ptr == 0)
+		goto do_alloc;
+	map_bh(bh_map, inode->i_sb, be64_to_cpu(*ptr));
+	bh = mp.mp_bh[ip->i_height - 1];
+	len = gfs2_extent_length(bh->b_data, bh->b_size, ptr, maxlen, &eob);
+	bh_map->b_size = (len << inode->i_blkbits);
+	if (eob)
+		set_buffer_boundary(bh_map);
+	ret = 0;
+out:
+	release_metapath(&mp);
+	bmap_unlock(ip, create);
+	return ret;
 
-	if (dblock) {
-		unsigned int len;
-		struct buffer_head *bh = mp.mp_bh[ip->i_height - 1];
-		__be64 *ptr = metapointer(&boundary, ip->i_height - 1, &mp);
-		map_bh(bh_map, inode->i_sb, dblock);
-		len = gfs2_extent_length(bh->b_data, bh->b_size, ptr, maxlen,
-					 &boundary);
-		bh_map->b_size = (len << inode->i_blkbits);
-		if (boundary)
-			set_buffer_boundary(bh_map);
+do_alloc:
+	/* All allocations are done here, firstly check create flag */
+	if (!create) {
+		BUG_ON(gfs2_is_stuffed(ip));
+		ret = 0;
+		goto out;
 	}
-out_ok:
-	error = 0;
-out_fail:
-	release_metapath(&mp);
-	bmap_unlock(inode, create);
-	return error;
+
+	/* At this point ret is the tree depth of already allocated blocks */
+	ret = gfs2_bmap_alloc(inode, lblock, bh_map, &mp, ret, height, maxlen);
+	goto out;
 }
 
 /*
@@ -568,7 +654,7 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 	BUG_ON(!dblock);
 	BUG_ON(!new);
 
-	bh.b_size = 1 << (inode->i_blkbits + 5);
+	bh.b_size = 1 << (inode->i_blkbits + (create ? 0 : 5));
 	ret = gfs2_block_map(inode, lblock, &bh, create);
 	*extlen = bh.b_size >> inode->i_blkbits;
 	*dblock = bh.b_blocknr;
@@ -835,38 +921,25 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 	if (error)
 		goto out_ipres;
 
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error)
+		goto out_end_trans;
+
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
-		const u64 *arr = sdp->sd_heightsize;
 		if (gfs2_is_stuffed(ip)) {
 			error = gfs2_unstuff_dinode(ip, NULL);
 			if (error)
-				goto out_end_trans;
-		}
-
-		down_write(&ip->i_rw_mutex);
-		if (size > arr[ip->i_height]) {
-			struct metapath mp;
-			u8 height = ip->i_height;
-			while(size > arr[height])
-				height++;
-			error = build_height(&ip->i_inode, &mp, height);
+				goto out_brelse;
 		}
-		up_write(&ip->i_rw_mutex);
-		if (error)
-			goto out_end_trans;
 	}
 
 	ip->i_di.di_size = size;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto out_end_trans;
-
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
 
+out_brelse:
+	brelse(dibh);
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_ipres:
@@ -996,6 +1069,7 @@ out:
 
 static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	unsigned int height = ip->i_height;
 	u64 lblock;
 	struct metapath mp;
@@ -1004,9 +1078,9 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 	if (!size)
 		lblock = 0;
 	else
-		lblock = (size - 1) >> GFS2_SB(&ip->i_inode)->sd_sb.sb_bsize_shift;
+		lblock = (size - 1) >> sdp->sd_sb.sb_bsize_shift;
 
-	find_metapath(ip, lblock, &mp);
+	find_metapath(sdp, lblock, &mp, ip->i_height);
 	gfs2_alloc_get(ip);
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 34dc8df..a3753c7 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -159,6 +159,7 @@ static int gfs2_dir_write_data(struct gfs2_inode *ip, const char *buf,
 	unsigned int o;
 	int copied = 0;
 	int error = 0;
+	int new = 0;
 
 	if (!size)
 		return 0;
@@ -183,7 +184,6 @@ static int gfs2_dir_write_data(struct gfs2_inode *ip, const char *buf,
 	while (copied < size) {
 		unsigned int amount;
 		struct buffer_head *bh;
-		int new = 0;
 
 		amount = size - copied;
 		if (amount > sdp->sd_sb.sb_bsize - o)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 77eba0a..4291375 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1357,16 +1357,18 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
 			    bi->bi_len, blk, new_state);
-		while(*n < elen) {
+		goal = blk;
+		while (*n < elen) {
 			goal++;
-			if (goal >= (bi->bi_len / GFS2_NBBY))
+			if (goal >= (bi->bi_len * GFS2_NBBY))
 				break;
 			if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
 			    GFS2_BLKST_FREE)
 				break;
-			(*n)++;
 			gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone,
-				    bi->bi_offset, bi->bi_len, blk, new_state);
+				    bi->bi_offset, bi->bi_len, goal,
+				    new_state);
+			(*n)++;
 		}
 	}
 
-- 
1.5.1.2

