Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbYAUKOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbYAUKOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYAUKCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYAUKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:47 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 34/58] [GFS2] Remove function gfs2_get_block
Date: Mon, 21 Jan 2008 09:21:52 +0000
Message-Id: <12009074002775-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073981159-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
Message-Id: <56ee48574f36af5149e578772604f71d184ff1be.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is just a cleanup.  Function gfs2_get_block() just calls
function gfs2_block_map reversing the last two parameters.  By
reversing the parameters, gfs2_block_map() may be called directly
and function gfs2_get_block may be eliminated altogether.
Since this function is done for every block operation,
this streamlines the code and makes it a little bit more efficient.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1cfd493..4948602 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -452,8 +452,8 @@ static inline void bmap_unlock(struct inode *inode, int create)
  * Returns: errno
  */
 
-int gfs2_block_map(struct inode *inode, u64 lblock, int create,
-		   struct buffer_head *bh_map)
+int gfs2_block_map(struct inode *inode, sector_t lblock,
+		   struct buffer_head *bh_map, int create)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -559,7 +559,7 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 	BUG_ON(!new);
 
 	bh.b_size = 1 << (inode->i_blkbits + 5);
-	ret = gfs2_block_map(inode, lblock, create, &bh);
+	ret = gfs2_block_map(inode, lblock, &bh, create);
 	*extlen = bh.b_size >> inode->i_blkbits;
 	*dblock = bh.b_blocknr;
 	if (buffer_new(&bh))
@@ -909,7 +909,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 	err = 0;
 
 	if (!buffer_mapped(bh)) {
-		gfs2_get_block(inode, iblock, bh, 0);
+		gfs2_block_map(inode, iblock, bh, 0);
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh))
 			goto unlock;
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index ac2fd04..4e6cde2 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -15,7 +15,7 @@ struct gfs2_inode;
 struct page;
 
 int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page);
-int gfs2_block_map(struct inode *inode, u64 lblock, int create, struct buffer_head *bh);
+int gfs2_block_map(struct inode *inode, sector_t lblock, struct buffer_head *bh, int create);
 int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsigned *extlen);
 
 int gfs2_truncatei(struct gfs2_inode *ip, u64 size);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 143311c..7f9ab89 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -337,7 +337,7 @@ static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 	struct buffer_head bh_map = { .b_state = 0, .b_blocknr = 0 };
 
 	bh_map.b_size = 1 << inode->i_blkbits;
-	error = gfs2_block_map(inode, lbn, 0, &bh_map);
+	error = gfs2_block_map(inode, lbn, &bh_map, 0);
 	if (error || !bh_map.b_blocknr)
 		printk(KERN_INFO "error=%d, dbn=%llu lbn=%u", error,
 		       (unsigned long long)bh_map.b_blocknr, lbn);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 7353933..8f94e30 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -59,22 +59,6 @@ static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
 }
 
 /**
- * gfs2_get_block - Fills in a buffer head with details about a block
- * @inode: The inode
- * @lblock: The block number to look up
- * @bh_result: The buffer head to return the result in
- * @create: Non-zero if we may add block to the file
- *
- * Returns: errno
- */
-
-int gfs2_get_block(struct inode *inode, sector_t lblock,
-	           struct buffer_head *bh_result, int create)
-{
-	return gfs2_block_map(inode, lblock, create, bh_result);
-}
-
-/**
  * gfs2_get_block_noalloc - Fills in a buffer head with details about a block
  * @inode: The inode
  * @lblock: The block number to look up
@@ -89,7 +73,7 @@ static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
 {
 	int error;
 
-	error = gfs2_block_map(inode, lblock, 0, bh_result);
+	error = gfs2_block_map(inode, lblock, bh_result, 0);
 	if (error)
 		return error;
 	if (!buffer_mapped(bh_result))
@@ -100,7 +84,7 @@ static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
 static int gfs2_get_block_direct(struct inode *inode, sector_t lblock,
 				 struct buffer_head *bh_result, int create)
 {
-	return gfs2_block_map(inode, lblock, 0, bh_result);
+	return gfs2_block_map(inode, lblock, bh_result, 0);
 }
 
 /**
@@ -504,7 +488,7 @@ static int __gfs2_readpage(void *file, struct page *page)
 		error = stuffed_readpage(ip, page);
 		unlock_page(page);
 	} else {
-		error = mpage_readpage(page, gfs2_get_block);
+		error = mpage_readpage(page, gfs2_block_map);
 	}
 
 	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
@@ -598,7 +582,7 @@ int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
  *    Any I/O we ignore at this time will be done via readpage later.
  * 2. We don't handle stuffed files here we let readpage do the honours.
  * 3. mpage_readpages() does most of the heavy lifting in the common case.
- * 4. gfs2_get_block() is relied upon to set BH_Boundary in the right places.
+ * 4. gfs2_block_map() is relied upon to set BH_Boundary in the right places.
  */
 
 static int gfs2_readpages(struct file *file, struct address_space *mapping,
@@ -615,7 +599,7 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 	if (unlikely(ret))
 		goto out_uninit;
 	if (!gfs2_is_stuffed(ip))
-		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_get_block);
+		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_block_map);
 	gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
@@ -710,7 +694,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	}
 
 prepare_write:
-	error = block_prepare_write(page, from, to, gfs2_get_block);
+	error = block_prepare_write(page, from, to, gfs2_block_map);
 out:
 	if (error == 0)
 		return 0;
@@ -923,7 +907,7 @@ static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
 		return 0;
 
 	if (!gfs2_is_stuffed(ip))
-		dblock = generic_block_bmap(mapping, lblock, gfs2_get_block);
+		dblock = generic_block_bmap(mapping, lblock, gfs2_block_map);
 
 	gfs2_glock_dq_uninit(&i_gh);
 
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
index d3b76d0..5da2128 100644
--- a/fs/gfs2/ops_address.h
+++ b/fs/gfs2/ops_address.h
@@ -14,8 +14,6 @@
 #include <linux/buffer_head.h>
 #include <linux/mm.h>
 
-extern int gfs2_get_block(struct inode *inode, sector_t lblock,
-			  struct buffer_head *bh_result, int create);
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
 extern int gfs2_internal_read(struct gfs2_inode *ip,
 			      struct file_ra_state *ra_state,
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 2569c13..597f7ff 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -323,7 +323,7 @@ static int gfs2_allocate_page_backing(struct page *page)
 	do {
 		bh.b_state = 0;
 		bh.b_size = size;
-		gfs2_block_map(inode, lblock, 1, &bh);
+		gfs2_block_map(inode, lblock, &bh, 1);
 		if (!buffer_mapped(&bh))
 			return -EIO;
 		size -= bh.b_size;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 4996f0e..8b4c20c 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -276,7 +276,7 @@ static int bh_get(struct gfs2_quota_data *qd)
 	offset = qd->qd_slot % sdp->sd_qc_per_block;;
 
 	bh_map.b_size = 1 << ip->i_inode.i_blkbits;
-	error = gfs2_block_map(&ip->i_inode, block, 0, &bh_map);
+	error = gfs2_block_map(&ip->i_inode, block, &bh_map, 0);
 	if (error)
 		goto fail;
 	error = gfs2_meta_read(ip->i_gl, bh_map.b_blocknr, DIO_WAIT, &bh);
@@ -645,7 +645,7 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	}
 
 	if (!buffer_mapped(bh)) {
-		gfs2_get_block(inode, iblock, bh, 1);
+		gfs2_block_map(inode, iblock, bh, 1);
 		if (!buffer_mapped(bh))
 			goto unlock;
 	}
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index beb6c7a..27c994f 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -391,7 +391,7 @@ static int clean_journal(struct gfs2_jdesc *jd, struct gfs2_log_header_host *hea
 	lblock = head->lh_blkno;
 	gfs2_replay_incr_blk(sdp, &lblock);
 	bh_map.b_size = 1 << ip->i_inode.i_blkbits;
-	error = gfs2_block_map(&ip->i_inode, lblock, 0, &bh_map);
+	error = gfs2_block_map(&ip->i_inode, lblock, &bh_map, 0);
 	if (error)
 		return error;
 	if (!bh_map.b_blocknr) {
-- 
1.5.1.2

