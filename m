Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXH1TWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXH1TWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761344AbXH1TJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:09:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755854AbXH1THd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:33 -0400
Message-Id: <20070828190731.162945859@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:06 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [15/36] Use page_cache_xxx functions in fs/ext2
Content-Disposition: inline; filename=0015-Use-page_cache_xxx-functions-in-fs-ext2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx functions in fs/ext2

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ext2/dir.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2bf49d7..d72926f 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -43,7 +43,8 @@ static inline void ext2_put_page(struct page *page)
 
 static inline unsigned long dir_pages(struct inode *inode)
 {
-	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
+	return (inode->i_size+page_cache_size(inode->i_mapping)-1)>>
+			page_cache_shift(inode->i_mapping);
 }
 
 /*
@@ -54,10 +55,11 @@ static unsigned
 ext2_last_byte(struct inode *inode, unsigned long page_nr)
 {
 	unsigned last_byte = inode->i_size;
+	struct address_space *mapping = inode->i_mapping;
 
-	last_byte -= page_nr << PAGE_CACHE_SHIFT;
-	if (last_byte > PAGE_CACHE_SIZE)
-		last_byte = PAGE_CACHE_SIZE;
+	last_byte -= page_nr << page_cache_shift(mapping);
+	if (last_byte > page_cache_size(mapping))
+		last_byte = page_cache_size(mapping);
 	return last_byte;
 }
 
@@ -76,18 +78,19 @@ static int ext2_commit_chunk(struct page *page, unsigned from, unsigned to)
 
 static void ext2_check_page(struct page *page)
 {
-	struct inode *dir = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned chunk_size = ext2_chunk_size(dir);
 	char *kaddr = page_address(page);
 	u32 max_inumber = le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count);
 	unsigned offs, rec_len;
-	unsigned limit = PAGE_CACHE_SIZE;
+	unsigned limit = page_cache_size(mapping);
 	ext2_dirent *p;
 	char *error;
 
-	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
-		limit = dir->i_size & ~PAGE_CACHE_MASK;
+	if (page_cache_index(mapping, dir->i_size) == page->index) {
+		limit = page_cache_offset(mapping, dir->i_size);
 		if (limit & (chunk_size - 1))
 			goto Ebadsize;
 		if (!limit)
@@ -139,7 +142,7 @@ Einumber:
 bad_entry:
 	ext2_error (sb, "ext2_check_page", "bad entry in directory #%lu: %s - "
 		"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		dir->i_ino, error, page_cache_pos(mapping, page->index, offs),
 		(unsigned long) le32_to_cpu(p->inode),
 		rec_len, p->name_len);
 	goto fail;
@@ -148,7 +151,7 @@ Eend:
 	ext2_error (sb, "ext2_check_page",
 		"entry in directory #%lu spans the page boundary"
 		"offset=%lu, inode=%lu",
-		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		dir->i_ino, page_cache_pos(mapping, page->index, offs),
 		(unsigned long) le32_to_cpu(p->inode));
 fail:
 	SetPageChecked(page);
@@ -246,8 +249,9 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 	loff_t pos = filp->f_pos;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
-	unsigned int offset = pos & ~PAGE_CACHE_MASK;
-	unsigned long n = pos >> PAGE_CACHE_SHIFT;
+	struct address_space *mapping = inode->i_mapping;
+	unsigned int offset = page_cache_offset(mapping, pos);
+	unsigned long n = page_cache_index(mapping, pos);
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
 	unsigned char *types = NULL;
@@ -268,14 +272,14 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 			ext2_error(sb, __FUNCTION__,
 				   "bad page in #%lu",
 				   inode->i_ino);
-			filp->f_pos += PAGE_CACHE_SIZE - offset;
+			filp->f_pos += page_cache_size(mapping) - offset;
 			return -EIO;
 		}
 		kaddr = page_address(page);
 		if (unlikely(need_revalidate)) {
 			if (offset) {
 				offset = ext2_validate_entry(kaddr, offset, chunk_mask);
-				filp->f_pos = (n<<PAGE_CACHE_SHIFT) + offset;
+				filp->f_pos = page_cache_pos(mapping, n, offset);
 			}
 			filp->f_version = inode->i_version;
 			need_revalidate = 0;
@@ -298,7 +302,7 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 
 				offset = (char *)de - kaddr;
 				over = filldir(dirent, de->name, de->name_len,
-						(n<<PAGE_CACHE_SHIFT) | offset,
+						page_cache_pos(mapping, n, offset),
 						le32_to_cpu(de->inode), d_type);
 				if (over) {
 					ext2_put_page(page);
@@ -324,6 +328,7 @@ struct ext2_dir_entry_2 * ext2_find_entry (struct inode * dir,
 			struct dentry *dentry, struct page ** res_page)
 {
 	const char *name = dentry->d_name.name;
+	struct address_space *mapping = dir->i_mapping;
 	int namelen = dentry->d_name.len;
 	unsigned reclen = EXT2_DIR_REC_LEN(namelen);
 	unsigned long start, n;
@@ -365,7 +370,7 @@ struct ext2_dir_entry_2 * ext2_find_entry (struct inode * dir,
 		if (++n >= npages)
 			n = 0;
 		/* next page is past the blocks we've got */
-		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+		if (unlikely(n > (dir->i_blocks >> (page_cache_shift(mapping) - 9)))) {
 			ext2_error(dir->i_sb, __FUNCTION__,
 				"dir %lu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
@@ -434,6 +439,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 int ext2_add_link (struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
+	struct address_space *mapping = inode->i_mapping;
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
 	unsigned chunk_size = ext2_chunk_size(dir);
@@ -463,7 +469,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 		kaddr = page_address(page);
 		dir_end = kaddr + ext2_last_byte(dir, n);
 		de = (ext2_dirent *)kaddr;
-		kaddr += PAGE_CACHE_SIZE - reclen;
+		kaddr += page_cache_size(mapping) - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
-- 
1.5.2.4

-- 
