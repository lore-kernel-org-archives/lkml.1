Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1761224AbYLQMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbYLQMiY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYLQM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53756 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYLQM3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:32 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/24] GFS2: Streamline alloc calculations for writes
Date: Wed, 17 Dec 2008 11:30:23 +0000
Message-Id: <1229513423-19105-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-24-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-22-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-23-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-24-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch removes some unused code, and make the calculation
of the number of blocks required conditional in order to reduce
the number of times this (potentially expensive) calculation
is done.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 789f28c..11ffc56 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1231,35 +1231,6 @@ int gfs2_file_dealloc(struct gfs2_inode *ip)
 }
 
 /**
- * gfs2_write_calc_reserv - calculate number of blocks needed to write to a file
- * @ip: the file
- * @len: the number of bytes to be written to the file
- * @data_blocks: returns the number of data blocks required
- * @ind_blocks: returns the number of indirect blocks required
- *
- */
-
-void gfs2_write_calc_reserv(struct gfs2_inode *ip, unsigned int len,
-			    unsigned int *data_blocks, unsigned int *ind_blocks)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	unsigned int tmp;
-
-	if (gfs2_is_dir(ip)) {
-		*data_blocks = DIV_ROUND_UP(len, sdp->sd_jbsize) + 2;
-		*ind_blocks = 3 * (sdp->sd_max_jheight - 1);
-	} else {
-		*data_blocks = (len >> sdp->sd_sb.sb_bsize_shift) + 3;
-		*ind_blocks = 3 * (sdp->sd_max_height - 1);
-	}
-
-	for (tmp = *data_blocks; tmp > sdp->sd_diptrs;) {
-		tmp = DIV_ROUND_UP(tmp, sdp->sd_inptrs);
-		*ind_blocks += tmp;
-	}
-}
-
-/**
  * gfs2_write_alloc_required - figure out if a write will require an allocation
  * @ip: the file being written to
  * @offset: the offset to write to
@@ -1276,6 +1247,7 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 	struct buffer_head bh;
 	unsigned int shift;
 	u64 lblock, lblock_stop, size;
+	u64 end_of_file;
 
 	*alloc_required = 0;
 
@@ -1291,19 +1263,12 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 
 	*alloc_required = 1;
 	shift = sdp->sd_sb.sb_bsize_shift;
-	if (gfs2_is_dir(ip)) {
-		unsigned int bsize = sdp->sd_jbsize;
-		lblock = offset;
-		do_div(lblock, bsize);
-		lblock_stop = offset + len + bsize - 1;
-		do_div(lblock_stop, bsize);
-	} else {
-		u64 end_of_file = (ip->i_disksize + sdp->sd_sb.sb_bsize - 1) >> shift;
-		lblock = offset >> shift;
-		lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
-		if (lblock_stop > end_of_file)
-			return 0;
-	}
+	BUG_ON(gfs2_is_dir(ip));
+	end_of_file = (ip->i_disksize + sdp->sd_sb.sb_bsize - 1) >> shift;
+	lblock = offset >> shift;
+	lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
+	if (lblock_stop > end_of_file)
+		return 0;
 
 	size = (lblock_stop - lblock) << shift;
 	do {
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 4e6cde2..c983177 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -10,10 +10,40 @@
 #ifndef __BMAP_DOT_H__
 #define __BMAP_DOT_H__
 
+#include "inode.h"
+
 struct inode;
 struct gfs2_inode;
 struct page;
 
+
+/**
+ * gfs2_write_calc_reserv - calculate number of blocks needed to write to a file
+ * @ip: the file
+ * @len: the number of bytes to be written to the file
+ * @data_blocks: returns the number of data blocks required
+ * @ind_blocks: returns the number of indirect blocks required
+ *
+ */
+
+static inline void gfs2_write_calc_reserv(const struct gfs2_inode *ip,
+					  unsigned int len,
+					  unsigned int *data_blocks,
+					  unsigned int *ind_blocks)
+{
+	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	unsigned int tmp;
+
+	BUG_ON(gfs2_is_dir(ip));
+	*data_blocks = (len >> sdp->sd_sb.sb_bsize_shift) + 3;
+	*ind_blocks = 3 * (sdp->sd_max_height - 1);
+
+	for (tmp = *data_blocks; tmp > sdp->sd_diptrs;) {
+		tmp = DIV_ROUND_UP(tmp, sdp->sd_inptrs);
+		*ind_blocks += tmp;
+	}
+}
+
 int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page);
 int gfs2_block_map(struct inode *inode, sector_t lblock, struct buffer_head *bh, int create);
 int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsigned *extlen);
@@ -21,10 +51,6 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 int gfs2_truncatei(struct gfs2_inode *ip, u64 size);
 int gfs2_truncatei_resume(struct gfs2_inode *ip);
 int gfs2_file_dealloc(struct gfs2_inode *ip);
-
-void gfs2_write_calc_reserv(struct gfs2_inode *ip, unsigned int len,
-			    unsigned int *data_blocks,
-			    unsigned int *ind_blocks);
 int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 			      unsigned int len, int *alloc_required);
 
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 82a1db6..3cea2a2 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -625,7 +625,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 {
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
-	unsigned int data_blocks, ind_blocks, rblocks;
+	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	int alloc_required;
 	int error = 0;
 	struct gfs2_alloc *al;
@@ -639,11 +639,13 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (unlikely(error))
 		goto out_uninit;
 
-	gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
 	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
 	if (error)
 		goto out_unlock;
 
+	if (alloc_required || gfs2_is_jdata(ip))
+		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
+
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
 		if (!al) {
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index a6b7a73..289c5f5 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -355,7 +355,6 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 		goto out;
 
 	set_bit(GIF_SW_PAGED, &ip->i_flags);
-	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
 	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
 	if (ret || !alloc_required)
 		goto out_unlock;
@@ -367,6 +366,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	ret = gfs2_quota_lock_check(ip);
 	if (ret)
 		goto out_alloc_put;
+	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
 	al->al_requested = data_blocks + ind_blocks;
 	ret = gfs2_inplace_reserve(ip);
 	if (ret)
-- 
1.6.0.3

