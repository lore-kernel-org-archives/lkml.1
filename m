Return-Path: <linux-kernel-owner+w=401wt.eu-S966706AbXIKGWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966706AbXIKGWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbXIKGGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56574 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762086AbXIKGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:36 -0400
Message-Id: <20070911060434.199209710@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:27 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takashi Sato <sho@tnes.nec.co.jp>, Mingming Cao <cmm@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [37/41] ext2: fix rec_len overflow for 64KB block size
Content-Disposition: inline; filename=0039-From-Mingming-Cao-cmm-us.ibm.com.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[2/4]  ext2: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext2/dir.c           |   46 ++++++++++++++++++++++++++++++++++++----------
 include/linux/ext2_fs.h |   13 +++++++++++++
 2 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index d72926f..4934860 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -97,9 +97,9 @@ static void ext2_check_page(struct page *page)
 			goto out;
 	}
 	for (offs = 0; offs <= limit - EXT2_DIR_REC_LEN(1); offs += rec_len) {
+		offs = EXT2_DIR_ADJUST_TAIL_OFFS(offs, chunk_size);
 		p = (ext2_dirent *)(kaddr + offs);
 		rec_len = le16_to_cpu(p->rec_len);
-
 		if (rec_len < EXT2_DIR_REC_LEN(1))
 			goto Eshort;
 		if (rec_len & 3)
@@ -111,6 +111,7 @@ static void ext2_check_page(struct page *page)
 		if (le32_to_cpu(p->inode) > max_inumber)
 			goto Einumber;
 	}
+	offs = EXT2_DIR_ADJUST_TAIL_OFFS(offs, chunk_size);
 	if (offs != limit)
 		goto Eend;
 out:
@@ -287,6 +288,7 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 		de = (ext2_dirent *)(kaddr+offset);
 		limit = kaddr + ext2_last_byte(inode, n) - EXT2_DIR_REC_LEN(1);
 		for ( ;(char*)de <= limit; de = ext2_next_entry(de)) {
+			de = EXT2_DIR_ADJUST_TAIL_ADDR(kaddr, de, sb->s_blocksize);
 			if (de->rec_len == 0) {
 				ext2_error(sb, __FUNCTION__,
 					"zero-length directory entry");
@@ -309,8 +311,10 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 					return 0;
 				}
 			}
+			filp->f_pos = EXT2_DIR_ADJUST_TAIL_OFFS(filp->f_pos, sb->s_blocksize);
 			filp->f_pos += le16_to_cpu(de->rec_len);
 		}
+		filp->f_pos = EXT2_DIR_ADJUST_TAIL_OFFS(filp->f_pos, sb->s_blocksize);
 		ext2_put_page(page);
 	}
 	return 0;
@@ -348,13 +352,14 @@ struct ext2_dir_entry_2 * ext2_find_entry (struct inode * dir,
 		start = 0;
 	n = start;
 	do {
-		char *kaddr;
+		char *kaddr, *page_start;
 		page = ext2_get_page(dir, n);
 		if (!IS_ERR(page)) {
-			kaddr = page_address(page);
+			kaddr = page_start = page_address(page);
 			de = (ext2_dirent *) kaddr;
 			kaddr += ext2_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
+				de = EXT2_DIR_ADJUST_TAIL_ADDR(page_start, de, dir->i_sb->s_blocksize);
 				if (de->rec_len == 0) {
 					ext2_error(dir->i_sb, __FUNCTION__,
 						"zero-length directory entry");
@@ -421,6 +426,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	unsigned to = from + le16_to_cpu(de->rec_len);
 	int err;
 
+	to = EXT2_DIR_ADJUST_TAIL_OFFS(to, inode->i_sb->s_blocksize);
 	lock_page(page);
 	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
 	BUG_ON(err);
@@ -452,6 +458,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 	char *kaddr;
 	unsigned from, to;
 	int err;
+	char *page_start = NULL;
 
 	/*
 	 * We take care of directory expansion in the same loop.
@@ -466,16 +473,28 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 		if (IS_ERR(page))
 			goto out;
 		lock_page(page);
-		kaddr = page_address(page);
+		kaddr = page_start = page_address(page);
 		dir_end = kaddr + ext2_last_byte(dir, n);
 		de = (ext2_dirent *)kaddr;
-		kaddr += page_cache_size(mapping) - reclen;
+		if (chunk_size < EXT2_DIR_MAX_REC_LEN) {
+			kaddr += page_cache_size(mapping) - reclen;
+		} else {
+			kaddr += page_cache_size(mapping) -
+				(chunk_size - EXT2_DIR_MAX_REC_LEN) - reclen;
+		}
 		while ((char *)de <= kaddr) {
+			de = EXT2_DIR_ADJUST_TAIL_ADDR(page_start, de, chunk_size);
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
 				name_len = 0;
-				rec_len = chunk_size;
-				de->rec_len = cpu_to_le16(chunk_size);
+				if (chunk_size  < EXT2_DIR_MAX_REC_LEN) {
+					rec_len = chunk_size;
+					de->rec_len = cpu_to_le16(chunk_size);
+				} else {
+					rec_len = EXT2_DIR_MAX_REC_LEN;
+					de->rec_len =
+					cpu_to_le16(EXT2_DIR_MAX_REC_LEN);
+				}
 				de->inode = 0;
 				goto got_it;
 			}
@@ -505,6 +524,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 got_it:
 	from = (char*)de - (char*)page_address(page);
 	to = from + rec_len;
+	to = EXT2_DIR_ADJUST_TAIL_OFFS(to, chunk_size);
 	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
 	if (err)
 		goto out_unlock;
@@ -547,6 +567,7 @@ int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
 	ext2_dirent * de = (ext2_dirent *) (kaddr + from);
 	int err;
 
+	to = EXT2_DIR_ADJUST_TAIL_OFFS(to, inode->i_sb->s_blocksize);
 	while ((char*)de < (char*)dir) {
 		if (de->rec_len == 0) {
 			ext2_error(inode->i_sb, __FUNCTION__,
@@ -604,7 +625,11 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 
 	de = (struct ext2_dir_entry_2 *)(kaddr + EXT2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	de->rec_len = cpu_to_le16(chunk_size - EXT2_DIR_REC_LEN(1));
+	if (chunk_size < EXT2_DIR_MAX_REC_LEN) {
+		de->rec_len = cpu_to_le16(chunk_size - EXT2_DIR_REC_LEN(1));
+	} else {
+		de->rec_len = cpu_to_le16(EXT2_DIR_MAX_REC_LEN - EXT2_DIR_REC_LEN(1));
+	}
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
@@ -624,18 +649,19 @@ int ext2_empty_dir (struct inode * inode)
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
-		char *kaddr;
+		char *kaddr, *page_start;
 		ext2_dirent * de;
 		page = ext2_get_page(inode, i);
 
 		if (IS_ERR(page))
 			continue;
 
-		kaddr = page_address(page);
+		kaddr = page_start = page_address(page);
 		de = (ext2_dirent *)kaddr;
 		kaddr += ext2_last_byte(inode, i) - EXT2_DIR_REC_LEN(1);
 
 		while ((char *)de <= kaddr) {
+			de = EXT2_DIR_ADJUST_TAIL_ADDR(page_start, de, inode->i_sb->s_blocksize);
 			if (de->rec_len == 0) {
 				ext2_error(inode->i_sb, __FUNCTION__,
 					"zero-length directory entry");
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 910a705..e8dd546 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -557,5 +557,18 @@ enum {
 #define EXT2_DIR_ROUND 			(EXT2_DIR_PAD - 1)
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
+#define	EXT2_DIR_MAX_REC_LEN		65532
+
+/*
+ * Align a tail offset(address) to the end of a directory block
+ */
+#define EXT2_DIR_ADJUST_TAIL_OFFS(offs, bsize) \
+	((((offs) & ((bsize) -1)) == EXT2_DIR_MAX_REC_LEN) ? \
+	((offs) + (bsize) - EXT2_DIR_MAX_REC_LEN):(offs))
+
+#define EXT2_DIR_ADJUST_TAIL_ADDR(page, de, bsize) \
+	(((((char*)(de) - (page)) & ((bsize) - 1)) == EXT2_DIR_MAX_REC_LEN) ? \
+	((ext2_dirent*)((char*)(de) + (bsize) - EXT2_DIR_MAX_REC_LEN)):(de))
 
 #endif	/* _LINUX_EXT2_FS_H */
+
-- 
1.5.2.5

-- 
