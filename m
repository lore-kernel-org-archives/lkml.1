Return-Path: <linux-kernel-owner+w=401wt.eu-S934392AbYDQJfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbYDQJfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbYDQJZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765034AbYDQJZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:17 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/48] [GFS2] Streamline indirect pointer tree height calculation
Date: Thu, 17 Apr 2008 09:38:38 +0100
Message-Id: <1208421571478-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215642582-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch improves the calculation of the tree height in order to reduce
the number of operations which are carried out on each call to gfs2_block_map.
In the common case, we now make a single comparison, rather than calculating
the required tree height from scratch each time. Also in the case that the
tree does need some extra height, we start from the current height rather from
zero when we work out what the new height ought to be.

In addition the di_height field is moved into the inode proper and reduced
in size to a u8 since the value must be between 0 and GFS2_MAX_META_HEIGHT (10).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index a25444a..5a31870 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -166,7 +166,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		di->di_blocks = cpu_to_be64(ip->i_di.di_blocks);
 	}
 
-	ip->i_di.di_height = 1;
+	ip->i_height = 1;
 	di->di_height = cpu_to_be16(1);
 
 out_brelse:
@@ -177,43 +177,6 @@ out:
 }
 
 /**
- * calc_tree_height - Calculate the height of a metadata tree
- * @ip: The GFS2 inode
- * @size: The proposed size of the file
- *
- * Work out how tall a metadata tree needs to be in order to accommodate a
- * file of a particular size. If size is less than the current size of
- * the inode, then the current size of the inode is used instead of the
- * supplied one.
- *
- * Returns: the height the tree should be
- */
-
-static unsigned int calc_tree_height(struct gfs2_inode *ip, u64 size)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	u64 *arr;
-	unsigned int max, height;
-
-	if (ip->i_di.di_size > size)
-		size = ip->i_di.di_size;
-
-	if (gfs2_is_dir(ip)) {
-		arr = sdp->sd_jheightsize;
-		max = sdp->sd_max_jheight;
-	} else {
-		arr = sdp->sd_heightsize;
-		max = sdp->sd_max_height;
-	}
-
-	for (height = 0; height < max; height++)
-		if (arr[height] >= size)
-			break;
-
-	return height;
-}
-
-/**
  * build_height - Build a metadata tree of the requested height
  * @ip: The GFS2 inode
  * @height: The height to build to
@@ -225,7 +188,7 @@ static unsigned int calc_tree_height(struct gfs2_inode *ip, u64 size)
 static int build_height(struct inode *inode, unsigned height)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	unsigned new_height = height - ip->i_di.di_height;
+	unsigned new_height = height - ip->i_height;
 	struct buffer_head *dibh;
 	struct buffer_head *blocks[GFS2_MAX_META_HEIGHT];
 	struct gfs2_dinode *di;
@@ -234,7 +197,7 @@ static int build_height(struct inode *inode, unsigned height)
 	u64 bn;
 	unsigned n;
 
-	if (height <= ip->i_di.di_height)
+	if (height <= ip->i_height)
 		return 0;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
@@ -270,10 +233,10 @@ static int build_height(struct inode *inode, unsigned height)
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	*(__be64 *)(di + 1) = cpu_to_be64(bn);
-	ip->i_di.di_height += new_height;
+	ip->i_height += new_height;
 	ip->i_di.di_blocks += new_height;
 	gfs2_set_inode_blocks(&ip->i_inode);
-	di->di_height = cpu_to_be16(ip->i_di.di_height);
+	di->di_height = cpu_to_be16(ip->i_height);
 	di->di_blocks = cpu_to_be64(ip->i_di.di_blocks);
 	brelse(dibh);
 	return error;
@@ -345,7 +308,7 @@ static void find_metapath(struct gfs2_inode *ip, u64 block,
 	u64 b = block;
 	unsigned int i;
 
-	for (i = ip->i_di.di_height; i--;)
+	for (i = ip->i_height; i--;)
 		mp->mp_list[i] = do_div(b, sdp->sd_inptrs);
 
 }
@@ -407,7 +370,7 @@ static int lookup_block(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (!create)
 		return 0;
 
-	if (height == ip->i_di.di_height - 1 && !gfs2_is_dir(ip))
+	if (height == ip->i_height - 1 && !gfs2_is_dir(ip))
 		*block = gfs2_alloc_data(ip);
 	else
 		*block = gfs2_alloc_meta(ip);
@@ -458,8 +421,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *bh;
-	unsigned int bsize;
-	unsigned int height;
+	unsigned int bsize = sdp->sd_sb.sb_bsize;
 	unsigned int end_of_metadata;
 	unsigned int x;
 	int error = 0;
@@ -470,7 +432,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	struct metapath mp;
 	u64 size;
 	struct buffer_head *dibh = NULL;
-
+	const u64 *arr = sdp->sd_heightsize;
 	BUG_ON(maxlen == 0);
 
 	if (gfs2_assert_warn(sdp, !gfs2_is_stuffed(ip)))
@@ -480,23 +442,25 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	clear_buffer_mapped(bh_map);
 	clear_buffer_new(bh_map);
 	clear_buffer_boundary(bh_map);
-	bsize = gfs2_is_dir(ip) ? sdp->sd_jbsize : sdp->sd_sb.sb_bsize;
+	if (gfs2_is_dir(ip)) {
+		bsize = sdp->sd_jbsize;
+		arr = sdp->sd_jheightsize;
+	}
 	size = (lblock + 1) * bsize;
 
-	if (size > ip->i_di.di_size) {
-		height = calc_tree_height(ip, size);
-		if (ip->i_di.di_height < height) {
-			if (!create)
-				goto out_ok;
-	
-			error = build_height(inode, height);
-			if (error)
-				goto out_fail;
-		}
+	if (size > arr[ip->i_height]) {
+		u8 height = ip->i_height;
+		if (!create)
+			goto out_ok;
+		while (size > arr[height])
+			height++;
+		error = build_height(inode, height);
+		if (error)
+			goto out_fail;
 	}
 
 	find_metapath(ip, lblock, &mp);
-	end_of_metadata = ip->i_di.di_height - 1;
+	end_of_metadata = ip->i_height - 1;
 	error = gfs2_meta_inode_buffer(ip, &bh);
 	if (error)
 		goto out_fail;
@@ -624,7 +588,7 @@ static int recursive_scan(struct gfs2_inode *ip, struct buffer_head *dibh,
 	if (error)
 		goto out;
 
-	if (height < ip->i_di.di_height - 1)
+	if (height < ip->i_height - 1)
 		for (; top < bottom; top++, first = 0) {
 			if (!*top)
 				continue;
@@ -682,7 +646,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		sm->sm_first = 0;
 	}
 
-	metadata = (height != ip->i_di.di_height - 1);
+	metadata = (height != ip->i_height - 1);
 	if (metadata)
 		revokes = (height) ? sdp->sd_inptrs : sdp->sd_diptrs;
 
@@ -807,7 +771,6 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al;
 	struct buffer_head *dibh;
-	unsigned int h;
 	int error;
 
 	al = gfs2_alloc_get(ip);
@@ -833,20 +796,23 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 		goto out_ipres;
 
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
+		const u64 *arr = sdp->sd_heightsize;
 		if (gfs2_is_stuffed(ip)) {
 			error = gfs2_unstuff_dinode(ip, NULL);
 			if (error)
 				goto out_end_trans;
 		}
 
-		h = calc_tree_height(ip, size);
-		if (ip->i_di.di_height < h) {
-			down_write(&ip->i_rw_mutex);
-			error = build_height(&ip->i_inode, h);
-			up_write(&ip->i_rw_mutex);
-			if (error)
-				goto out_end_trans;
+		down_write(&ip->i_rw_mutex);
+		if (size > arr[ip->i_height]) {
+			u8 height = ip->i_height;
+			while(size > arr[height])
+				height++;
+			error = build_height(&ip->i_inode, height);
 		}
+		up_write(&ip->i_rw_mutex);
+		if (error)
+			goto out_end_trans;
 	}
 
 	ip->i_di.di_size = size;
@@ -989,7 +955,7 @@ out:
 
 static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 {
-	unsigned int height = ip->i_di.di_height;
+	unsigned int height = ip->i_height;
 	u64 lblock;
 	struct metapath mp;
 	int error;
@@ -1040,7 +1006,7 @@ static int trunc_end(struct gfs2_inode *ip)
 		goto out;
 
 	if (!ip->i_di.di_size) {
-		ip->i_di.di_height = 0;
+		ip->i_height = 0;
 		ip->i_di.di_goal_meta =
 			ip->i_di.di_goal_data =
 			ip->i_no_addr;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 525dcae..43472ba 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -246,7 +246,6 @@ struct gfs2_dinode_host {
 	u64 di_goal_data;	/* data block goal */
 	u64 di_generation;	/* generation number for NFS */
 	u32 di_flags;		/* GFS2_DIF_... */
-	u16 di_height;		/* height of metadata */
 	/* These only apply to directories  */
 	u16 di_depth;		/* Number of bits in the table */
 	u32 di_entries;		/* The number of entries in the directory */
@@ -268,6 +267,7 @@ struct gfs2_inode {
 	u64 i_last_rg_alloc;
 
 	struct rw_semaphore i_rw_mutex;
+	u8 i_height;
 };
 
 /*
@@ -490,9 +490,9 @@ struct gfs2_sbd {
 	u32 sd_qc_per_block;
 	u32 sd_max_dirres;	/* Max blocks needed to add a directory entry */
 	u32 sd_max_height;	/* Max height of a file's metadata tree */
-	u64 sd_heightsize[GFS2_MAX_META_HEIGHT];
+	u64 sd_heightsize[GFS2_MAX_META_HEIGHT + 1];
 	u32 sd_max_jheight; /* Max height of journaled file's meta tree */
-	u64 sd_jheightsize[GFS2_MAX_META_HEIGHT];
+	u64 sd_jheightsize[GFS2_MAX_META_HEIGHT + 1];
 
 	struct gfs2_args sd_args;	/* Mount arguments */
 	struct gfs2_tune sd_tune;	/* Filesystem tuning structure */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 37725ad..ff66ab7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -248,12 +248,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	struct gfs2_dinode_host *di = &ip->i_di;
 	const struct gfs2_dinode *str = buf;
+	u16 height;
 
-	if (ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		return -EIO;
-	}
+	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
+		goto corrupt;
 	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
 	ip->i_inode.i_mode = be32_to_cpu(str->di_mode);
 	ip->i_inode.i_rdev = 0;
@@ -290,7 +288,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 
 	di->di_flags = be32_to_cpu(str->di_flags);
 	gfs2_set_inode_flags(&ip->i_inode);
-	di->di_height = be16_to_cpu(str->di_height);
+	height = be16_to_cpu(str->di_height);
+	if (unlikely(height > GFS2_MAX_META_HEIGHT))
+		goto corrupt;
+	ip->i_height = (u8)height;
 
 	di->di_depth = be16_to_cpu(str->di_depth);
 	di->di_entries = be32_to_cpu(str->di_entries);
@@ -300,6 +301,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		gfs2_set_aops(&ip->i_inode);
 
 	return 0;
+corrupt:
+	if (gfs2_consist_inode(ip))
+		gfs2_dinode_print(ip);
+	return -EIO;
 }
 
 /**
@@ -1401,7 +1406,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_generation = cpu_to_be64(di->di_generation);
 
 	str->di_flags = cpu_to_be32(di->di_flags);
-	str->di_height = cpu_to_be16(di->di_height);
+	str->di_height = cpu_to_be16(ip->i_height);
 	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
 					     !(ip->i_di.di_flags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
@@ -1430,7 +1435,6 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  di_goal_data = %llu\n",
 	       (unsigned long long)di->di_goal_data);
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
-	printk(KERN_INFO "  di_height = %u\n", di->di_height);
 	printk(KERN_INFO "  di_depth = %u\n", di->di_depth);
 	printk(KERN_INFO "  di_entries = %u\n", di->di_entries);
 	printk(KERN_INFO "  di_eattr = %llu\n",
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index d446506..db73868 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -12,7 +12,7 @@
 
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
 {
-	return !ip->i_di.di_height;
+	return !ip->i_height;
 }
 
 static inline int gfs2_is_jdata(const struct gfs2_inode *ip)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ef0562c..88497b0 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -316,6 +316,7 @@ int gfs2_read_sb(struct gfs2_sbd *sdp, struct gfs2_glock *gl, int silent)
 		sdp->sd_heightsize[x] = space;
 	}
 	sdp->sd_max_height = x;
+	sdp->sd_heightsize[x] = ~0;
 	gfs2_assert(sdp, sdp->sd_max_height <= GFS2_MAX_META_HEIGHT);
 
 	sdp->sd_jheightsize[0] = sdp->sd_sb.sb_bsize -
@@ -334,6 +335,7 @@ int gfs2_read_sb(struct gfs2_sbd *sdp, struct gfs2_glock *gl, int silent)
 		sdp->sd_jheightsize[x] = space;
 	}
 	sdp->sd_max_jheight = x;
+	sdp->sd_jheightsize[x] = ~0;
 	gfs2_assert(sdp, sdp->sd_max_jheight <= GFS2_MAX_META_HEIGHT);
 
 	return 0;
-- 
1.5.1.2

