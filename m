Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYAVCYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYAVCYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 21:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYAVCYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 21:24:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYAVCX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 21:23:59 -0500
Date: Tue, 22 Jan 2008 11:23:45 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: linux-kernel@vger.kernel.org, inux-fsdevel@vger.kernel.org
Subject: [PATCH] CRAMFS: Uncompressed files support
Message-ID: <20080122022345.GA3678@party>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch enables the uncompressed files support in cramfs.

The word 'uncompressed file' is from linear cramfs (aka Application XIP).
In linear cramfs, it is used to suport XIP on NOR. However it is also helpful on OneNAND. It makes a filesystem faster by removing compression overhead.
In XIP mode it runs XIP, But non-XIP mode. It copies data to ram and runs.

In my simple test, copy busybox (compressed or uncompressed).
It reduces the about 50% time saving from 0.40s to 0.19s.
Yes, it incrases the file system size, but nowadays flash has big capacity.
It's trade-off between size and performance.

Also this patch uses the page cache directly.
In previous implementation, it used the local buffer. why?
It's already uncompressed and fits to page size. So It uses the page directly to remove useless memory copy.

It's compatible the existing linear cramfs image and original one.

Any comments are welcome.

Thank you,
Kyungmin Park

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 3d194a2..edba28f 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -40,6 +40,7 @@ static DEFINE_MUTEX(read_mutex);
 #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
 #define OFFSET(x)	((x)->i_ino)
 
+#define CRAMFS_INODE_IS_XIP(x)	((x)->i_mode & S_ISVTX)
 
 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
@@ -143,8 +144,9 @@ static int next_buffer;
 /*
  * Returns a pointer to a buffer containing at least LEN bytes of
  * filesystem starting at byte offset OFFSET into the filesystem.
+ * If the @pg has the page, it returns the page buffer address
  */
-static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned int len)
+static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned int len, struct page **pg)
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 	struct page *pages[BLKS_PER_BUF];
@@ -174,6 +176,22 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 
 	devsize = mapping->host->i_size >> PAGE_CACHE_SHIFT;
 
+	/*
+	 * Use page directly either 
+	 * - uncompressed page or
+	 * - comprssed page which has all required data
+	 */
+	if (pg && offset + len <= PAGE_CACHE_SIZE) {
+		struct page *page = NULL;
+		page = read_mapping_page(mapping, blocknr, NULL);
+		if (!IS_ERR(page)) {
+			*pg = page;
+			data = kmap(page);
+			data += offset;
+			return data;
+		}
+	}
+
 	/* Ok, read in BLKS_PER_BUF pages completely first. */
 	unread = 0;
 	for (i = 0; i < BLKS_PER_BUF; i++) {
@@ -253,14 +271,14 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		buffer_blocknr[i] = -1;
 
 	/* Read the first block and get the superblock from it */
-	memcpy(&super, cramfs_read(sb, 0, sizeof(super)), sizeof(super));
+	memcpy(&super, cramfs_read(sb, 0, sizeof(super), NULL), sizeof(super));
 	mutex_unlock(&read_mutex);
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
 		/* check at 512 byte offset */
 		mutex_lock(&read_mutex);
-		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
+		memcpy(&super, cramfs_read(sb, 512, sizeof(super), NULL), sizeof(super));
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (!silent)
@@ -367,7 +385,7 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		int namelen, error;
 
 		mutex_lock(&read_mutex);
-		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+256);
+		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+256, NULL);
 		name = (char *)(de+1);
 
 		/*
@@ -417,7 +435,7 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 		char *name;
 		int namelen, retval;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+256);
+		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+256, NULL);
 		name = (char *)(de+1);
 
 		/* Try to take advantage of sorted directories */
@@ -463,21 +481,44 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 static int cramfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
+	struct super_block *sb = inode->i_sb;
 	u32 maxblock, bytes_filled;
+	struct page *pg = NULL;
 	void *pgdata;
 
 	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	bytes_filled = 0;
-	if (page->index < maxblock) {
-		struct super_block *sb = inode->i_sb;
+
+	/* Handle uncompressed files */
+	if (CRAMFS_INODE_IS_XIP(inode) && page->index < maxblock) {
+		u32 blkptr_offset = PAGE_ALIGN(OFFSET(inode)) +
+				(page->index << PAGE_CACHE_SHIFT);
+
+		pgdata = kmap(page);
+		mutex_lock(&read_mutex);
+		memcpy(pgdata,
+			cramfs_read(sb, blkptr_offset, PAGE_CACHE_SIZE, &pg),
+			PAGE_CACHE_SIZE);
+		if (pg) {
+			kunmap(pg);
+			page_cache_release(pg);
+		}
+		mutex_unlock(&read_mutex);
+		bytes_filled = PAGE_CACHE_SIZE;
+	} else if (page->index < maxblock) {
 		u32 blkptr_offset = OFFSET(inode) + page->index*4;
 		u32 start_offset, compr_len;
 
 		start_offset = OFFSET(inode) + maxblock*4;
 		mutex_lock(&read_mutex);
 		if (page->index)
-			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
-		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
+			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4, NULL);
+		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4, &pg) - start_offset);
+		if (pg) {
+			kunmap(pg);
+			page_cache_release(pg);
+			pg = NULL;
+		}
 		mutex_unlock(&read_mutex);
 		pgdata = kmap(page);
 		if (compr_len == 0)
@@ -487,9 +528,13 @@ static int cramfs_readpage(struct file *file, struct page * page)
 		else {
 			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
-				 PAGE_CACHE_SIZE,
-				 cramfs_read(sb, start_offset, compr_len),
-				 compr_len);
+				PAGE_CACHE_SIZE,
+				cramfs_read(sb, start_offset, compr_len, &pg),
+				compr_len);
+			if (pg) {
+				kunmap(pg);
+				page_cache_release(pg);
+			}
 			mutex_unlock(&read_mutex);
 		}
 	} else
