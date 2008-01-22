Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYAVDDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYAVDDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYAVDCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:02:53 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64634 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYAVDCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:02:51 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 15/49] ext4: store maxbytes for bitmapped  files and return EFBIG as appropriate
Date: Mon, 21 Jan 2008 22:01:54 -0500
Message-Id: <1200970948-17903-16-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-15-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Calculate & store the max offset for bitmapped files, and
catch too-large seeks, truncates, and writes in ext4, shortening
or rejecting as appropriate.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/file.c             |   19 ++++++++++++++++++-
 fs/ext4/inode.c            |   16 +++++++++++++++-
 fs/ext4/super.c            |    1 +
 include/linux/ext4_fs_sb.h |    1 +
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1a81cd6..a6b2aa1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -56,8 +56,25 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t ret;
 	int err;
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	/*
+	 * If we have encountered a bitmap-format file, the size limit
+	 * is smaller than s_maxbytes, which is for extent-mapped files.
+	 */
+
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		size_t length = iov_length(iov, nr_segs);
 
+		if (pos > sbi->s_bitmap_maxbytes)
+			return -EFBIG;
+
+		if (pos + length > sbi->s_bitmap_maxbytes) {
+			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
+					      sbi->s_bitmap_maxbytes - pos);
+		}
+	}
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
 	/*
 	 * Skip flushing if there was an error, or if nothing was written.
 	 */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9cf8572..eaace13 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -314,7 +314,10 @@ static int ext4_block_to_path(struct inode *inode,
 		offsets[n++] = i_block & (ptrs - 1);
 		final = ptrs;
 	} else {
-		ext4_warning(inode->i_sb, "ext4_block_to_path", "block > big");
+		ext4_warning(inode->i_sb, "ext4_block_to_path",
+				"block %u > max",
+				i_block + direct_blocks +
+				indirect_blocks + double_blocks);
 	}
 	if (boundary)
 		*boundary = final - 1 - (i_block & (ptrs - 1));
@@ -3092,6 +3095,17 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_journal_stop(handle);
 	}
 
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
+				error = -EFBIG;
+				goto err_out;
+			}
+		}
+	}
+
 	if (S_ISREG(inode->i_mode) &&
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c79e46b..0931831 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1922,6 +1922,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		}
 	}
 
+	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index f15821c..38a47ec 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -38,6 +38,7 @@ struct ext4_sb_info {
 	ext4_group_t s_groups_count;	/* Number of groups in the fs */
 	unsigned long s_overhead_last;  /* Last calculated overhead */
 	unsigned long s_blocks_last;    /* Last seen block count */
+	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
-- 
1.5.4.rc3.31.g1271-dirty

