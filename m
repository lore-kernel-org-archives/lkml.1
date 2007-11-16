Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbXKPSzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbXKPSzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbXKPSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:55:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46938 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761721AbXKPSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:55:28 -0500
Date: Fri, 16 Nov 2007 10:50:21 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.7
Message-ID: <20071116185021.GN9807@kroah.com>
References: <20071116183752.GA9807@kroah.com> <20071116185008.GM9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116185008.GM9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 798ffe9..c0feac2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .6
+EXTRAVERSION = .7
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 1a5f3bf..82d6554 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -23,11 +23,16 @@ static inline block_t *i_data(struct inode *inode)
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index ad8f0de..f230109 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -23,12 +23,17 @@ static inline block_t *i_data(struct inode *inode)
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 	struct super_block *sb = inode->i_sb;
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 256) {
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0d7a77c..a2a4865 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -167,8 +167,6 @@ static void nfs_mark_uptodate(struct page *page, unsigned int base, unsigned int
 		return;
 	if (count != nfs_page_length(page))
 		return;
-	if (count != PAGE_CACHE_SIZE)
-		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 
@@ -643,7 +641,8 @@ static struct nfs_page * nfs_update_request(struct nfs_open_context* ctx,
 				return ERR_PTR(error);
 			}
 			spin_unlock(&inode->i_lock);
-			return new;
+			req = new;
+			goto zero_page;
 		}
 		spin_unlock(&inode->i_lock);
 
@@ -671,13 +670,23 @@ static struct nfs_page * nfs_update_request(struct nfs_open_context* ctx,
 	if (offset < req->wb_offset) {
 		req->wb_offset = offset;
 		req->wb_pgbase = offset;
-		req->wb_bytes = rqend - req->wb_offset;
+		req->wb_bytes = max(end, rqend) - req->wb_offset;
+		goto zero_page;
 	}
 
 	if (end > rqend)
 		req->wb_bytes = end - req->wb_offset;
 
 	return req;
+zero_page:
+	/* If this page might potentially be marked as up to date,
+	 * then we need to zero any uninitalised data. */
+	if (req->wb_pgbase == 0 && req->wb_bytes != PAGE_CACHE_SIZE
+			&& !PageUptodate(req->wb_page))
+		zero_user_page(req->wb_page, req->wb_bytes,
+				PAGE_CACHE_SIZE - req->wb_bytes,
+				KM_USER0);
+	return req;
 }
 
 int nfs_flush_incompatible(struct file *file, struct page *page)
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f37f25c..0b5e35f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -661,6 +661,27 @@ static void ocfs2_clear_page_regions(struct page *page,
 }
 
 /*
+ * Nonsparse file systems fully allocate before we get to the write
+ * code. This prevents ocfs2_write() from tagging the write as an
+ * allocating one, which means ocfs2_map_page_blocks() might try to
+ * read-in the blocks at the tail of our file. Avoid reading them by
+ * testing i_size against each block offset.
+ */
+static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
+				 unsigned int block_start)
+{
+	u64 offset = page_offset(page) + block_start;
+
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		return 1;
+
+	if (i_size_read(inode) > offset)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Some of this taken from block_prepare_write(). We already have our
  * mapping by now though, and the entire write will be allocating or
  * it won't, so not much need to use BH_New.
@@ -713,6 +734,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 				set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
+			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
