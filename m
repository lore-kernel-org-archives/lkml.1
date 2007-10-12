Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbXJLQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbXJLQLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbXJLQG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760226AbXJLQGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/52] CRED: Give the get_block() callback a credentials
	pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:15 +0100
Message-ID: <20071012160615.15119.3876.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the get_block() callback a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/block_dev.c     |    6 ++++--
 fs/buffer.c        |   18 ++++++++++++------
 fs/direct-io.c     |    3 ++-
 fs/ext3/inode.c    |    7 ++++---
 fs/fat/inode.c     |    3 ++-
 fs/mpage.c         |    6 ++++--
 include/linux/fs.h |    3 ++-
 7 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6339a30..1a51716 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -112,7 +112,8 @@ EXPORT_SYMBOL(sb_min_blocksize);
 
 static int
 blkdev_get_block(struct inode *inode, sector_t iblock,
-		struct buffer_head *bh, int create)
+		struct buffer_head *bh, int create,
+		struct cred *cred)
 {
 	if (iblock >= max_block(I_BDEV(inode))) {
 		if (create)
@@ -134,7 +135,8 @@ blkdev_get_block(struct inode *inode, sector_t iblock,
 
 static int
 blkdev_get_blocks(struct inode *inode, sector_t iblock,
-		struct buffer_head *bh, int create)
+		struct buffer_head *bh, int create,
+		struct cred *cred)
 {
 	sector_t end_block = max_block(I_BDEV(inode));
 	unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
diff --git a/fs/buffer.c b/fs/buffer.c
index 75b51df..c5b2ebc 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1599,6 +1599,7 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
 static int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc)
 {
+	struct cred *cred = current->cred;
 	int err;
 	sector_t block;
 	sector_t last_block;
@@ -1647,7 +1648,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			set_buffer_uptodate(bh);
 		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
+			err = get_block(inode, block, bh, 1, cred);
 			if (err)
 				goto recover;
 			if (buffer_new(bh)) {
@@ -1760,6 +1761,7 @@ recover:
 static int __block_prepare_write(struct inode *inode, struct page *page,
 		unsigned from, unsigned to, get_block_t *get_block)
 {
+	struct cred *cred = current->cred;
 	unsigned block_start, block_end;
 	sector_t block;
 	int err = 0;
@@ -1793,7 +1795,7 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
+			err = get_block(inode, block, bh, 1, cred);
 			if (err)
 				break;
 			if (buffer_new(bh)) {
@@ -1917,6 +1919,7 @@ static int __block_commit_write(struct inode *inode, struct page *page,
  */
 int block_read_full_page(struct page *page, get_block_t *get_block)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = page->mapping->host;
 	sector_t iblock, lblock;
 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
@@ -1946,7 +1949,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 			fully_mapped = 0;
 			if (iblock < lblock) {
 				WARN_ON(bh->b_size != blocksize);
-				err = get_block(inode, iblock, bh, 0);
+				err = get_block(inode, iblock, bh, 0, cred);
 				if (err)
 					SetPageError(page);
 			}
@@ -2269,6 +2272,7 @@ static void end_buffer_read_nobh(struct buffer_head *bh, int uptodate)
 int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
@@ -2306,7 +2310,7 @@ int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
 			create = 0;
 		map_bh.b_size = blocksize;
 		ret = get_block(inode, block_in_file + block_in_page,
-					&map_bh, create);
+					&map_bh, create, cred);
 		if (ret)
 			goto failed;
 		if (!buffer_mapped(&map_bh))
@@ -2511,6 +2515,7 @@ EXPORT_SYMBOL(nobh_truncate_page);
 int block_truncate_page(struct address_space *mapping,
 			loff_t from, get_block_t *get_block)
 {
+	struct cred *cred = current->cred;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
 	unsigned blocksize;
@@ -2551,7 +2556,7 @@ int block_truncate_page(struct address_space *mapping,
 	err = 0;
 	if (!buffer_mapped(bh)) {
 		WARN_ON(bh->b_size != blocksize);
-		err = get_block(inode, iblock, bh, 0);
+		err = get_block(inode, iblock, bh, 0, cred);
 		if (err)
 			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
@@ -2625,12 +2630,13 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
 {
+	struct cred *cred = current->cred;
 	struct buffer_head tmp;
 	struct inode *inode = mapping->host;
 	tmp.b_state = 0;
 	tmp.b_blocknr = 0;
 	tmp.b_size = 1 << inode->i_blkbits;
-	get_block(inode, block, &tmp, 0);
+	get_block(inode, block, &tmp, 0, cred);
 	return tmp.b_blocknr;
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index b5928a7..dacd0e8 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -499,6 +499,7 @@ static int dio_bio_reap(struct dio *dio)
 static int get_more_blocks(struct dio *dio)
 {
 	int ret;
+	struct cred *cred = current->cred;
 	struct buffer_head *map_bh = &dio->map_bh;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
@@ -539,7 +540,7 @@ static int get_more_blocks(struct dio *dio)
 		 * writes.
 		 */
 		ret = (*dio->get_block)(dio->inode, fs_startblk,
-						map_bh, create);
+						map_bh, create, cred);
 	}
 	return ret;
 }
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 57a2e74..a7ef05c 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -948,9 +948,9 @@ out:
 #define DIO_CREDITS (EXT3_RESERVE_TRANS_BLOCKS + 32)
 
 static int ext3_get_block(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create)
+			struct buffer_head *bh_result, int create,
+			struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle = ext3_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
@@ -1769,6 +1769,7 @@ void ext3_set_aops(struct inode *inode)
 static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from)
 {
+	struct cred *cred = current->cred;
 	ext3_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
 	unsigned blocksize, iblock, length, pos;
@@ -1811,7 +1812,7 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext3_get_block(inode, iblock, bh, 0);
+		ext3_get_block(inode, iblock, bh, 0, cred);
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 9ae2e9f..43c6f4a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -106,7 +106,8 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 }
 
 static int fat_get_block(struct inode *inode, sector_t iblock,
-			 struct buffer_head *bh_result, int create)
+			 struct buffer_head *bh_result, int create,
+			 struct cred *cred)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
diff --git a/fs/mpage.c b/fs/mpage.c
index b1c3e58..7fc2dce 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -169,6 +169,7 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
 		unsigned long *first_logical_block, get_block_t get_block)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
@@ -229,7 +230,7 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 
 		if (block_in_file < last_block) {
 			map_bh->b_size = (last_block-block_in_file) << blkbits;
-			if (get_block(inode, block_in_file, map_bh, 0))
+			if (get_block(inode, block_in_file, map_bh, 0, cred))
 				goto confused;
 			*first_logical_block = block_in_file;
 		}
@@ -456,6 +457,7 @@ struct mpage_data {
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 			     void *data)
 {
+	struct cred *cred = current->cred;
 	struct mpage_data *mpd = data;
 	struct bio *bio = mpd->bio;
 	struct address_space *mapping = page->mapping;
@@ -538,7 +540,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh, 1, cred))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1be33c8..6d9bfc4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -309,7 +309,8 @@ extern void __init files_init(unsigned long);
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create);
+			struct buffer_head *bh_result, int create,
+			struct cred *cred);
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 

