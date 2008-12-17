Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757305AbYLQMfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYLQMfn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYLQM3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbYLQM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:25 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/24] GFS2: Support for FIEMAP ioctl
Date: Wed, 17 Dec 2008 11:30:00 +0000
Message-Id: <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch implements the FIEMAP ioctl for GFS2. We can use the generic
code (aside from a lock order issue, solved as per Ted Tso's suggestion)
for which I've introduced a new variant of the generic function. We also
have one exception to deal with, namely stuffed files, so we do that
"by hand", setting all the required flags.

This has been tested with a modified (I could only find an old version) of
Eric's test program, and appears to work correctly.

This patch does not currently support FIEMAP of xattrs, but the plan is to add
that feature at some future point.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index d232991..1e24b65 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -19,6 +19,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
+#include <linux/fiemap.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -1212,6 +1213,48 @@ static int gfs2_removexattr(struct dentry *dentry, const char *name)
 	return gfs2_ea_remove(GFS2_I(dentry->d_inode), &er);
 }
 
+static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		       u64 start, u64 len)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
+	if (ret)
+		return ret;
+
+	mutex_lock(&inode->i_mutex);
+
+	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	if (ret)
+		goto out;
+
+	if (gfs2_is_stuffed(ip)) {
+		u64 phys = ip->i_no_addr << inode->i_blkbits;
+		u64 size = i_size_read(inode);
+		u32 flags = FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_NOT_ALIGNED|
+			    FIEMAP_EXTENT_DATA_INLINE;
+		phys += sizeof(struct gfs2_dinode);
+		phys += start;
+		if (start + len > size)
+			len = size - start;
+		if (start < size)
+			ret = fiemap_fill_next_extent(fieinfo, start, phys,
+						      len, flags);
+		if (ret == 1)
+			ret = 0;
+	} else {
+		ret = __generic_block_fiemap(inode, fieinfo, start, len,
+					     gfs2_block_map);
+	}
+
+	gfs2_glock_dq_uninit(&gh);
+out:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
@@ -1220,6 +1263,7 @@ const struct inode_operations gfs2_file_iops = {
 	.getxattr = gfs2_getxattr,
 	.listxattr = gfs2_listxattr,
 	.removexattr = gfs2_removexattr,
+	.fiemap = gfs2_fiemap,
 };
 
 const struct inode_operations gfs2_dir_iops = {
@@ -1239,6 +1283,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.getxattr = gfs2_getxattr,
 	.listxattr = gfs2_listxattr,
 	.removexattr = gfs2_removexattr,
+	.fiemap = gfs2_fiemap,
 };
 
 const struct inode_operations gfs2_symlink_iops = {
@@ -1251,5 +1296,6 @@ const struct inode_operations gfs2_symlink_iops = {
 	.getxattr = gfs2_getxattr,
 	.listxattr = gfs2_listxattr,
 	.removexattr = gfs2_removexattr,
+	.fiemap = gfs2_fiemap,
 };
 
diff --git a/fs/ioctl.c b/fs/ioctl.c
index d152856..f9b5c24 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -231,7 +231,8 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 #define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
 #define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
 
-/*
+/**
+ * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
  * @inode - the inode to map
  * @arg - the pointer to userspace where we copy everything to
  * @get_block - the fs's get_block function
@@ -242,11 +243,15 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
  *
  * If it is possible to have data blocks beyond a hole past @inode->i_size, then
  * please do not use this function, it will stop at the first unmapped block
- * beyond i_size
+ * beyond i_size.
+ *
+ * If you use this function directly, you need to do your own locking. Use
+ * generic_block_fiemap if you want the locking done for you.
  */
-int generic_block_fiemap(struct inode *inode,
-			 struct fiemap_extent_info *fieinfo, u64 start,
-			 u64 len, get_block_t *get_block)
+
+int __generic_block_fiemap(struct inode *inode,
+			   struct fiemap_extent_info *fieinfo, u64 start,
+			   u64 len, get_block_t *get_block)
 {
 	struct buffer_head tmp;
 	unsigned int start_blk;
@@ -260,9 +265,6 @@ int generic_block_fiemap(struct inode *inode,
 
 	start_blk = logical_to_blk(inode, start);
 
-	/* guard against change */
-	mutex_lock(&inode->i_mutex);
-
 	length = (long long)min_t(u64, len, i_size_read(inode));
 	map_len = length;
 
@@ -334,14 +336,36 @@ int generic_block_fiemap(struct inode *inode,
 		cond_resched();
 	} while (1);
 
-	mutex_unlock(&inode->i_mutex);
-
 	/* if ret is 1 then we just hit the end of the extent array */
 	if (ret == 1)
 		ret = 0;
 
 	return ret;
 }
+EXPORT_SYMBOL(__generic_block_fiemap);
+
+/**
+ * generic_block_fiemap - FIEMAP for block based inodes
+ * @inode: The inode to map
+ * @fieinfo: The mapping information
+ * @start: The initial block to map
+ * @len: The length of the extect to attempt to map
+ * @get_block: The block mapping function for the fs
+ *
+ * Calls __generic_block_fiemap to map the inode, after taking
+ * the inode's mutex lock.
+ */
+
+int generic_block_fiemap(struct inode *inode,
+			 struct fiemap_extent_info *fieinfo, u64 start,
+			 u64 len, get_block_t *get_block)
+{
+	int ret;
+	mutex_lock(&inode->i_mutex);
+	ret = __generic_block_fiemap(inode, fieinfo, start, len, get_block);
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
 EXPORT_SYMBOL(generic_block_fiemap);
 
 #endif  /*  CONFIG_BLOCK  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..e12e9e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2043,6 +2043,9 @@ extern int vfs_fstat(unsigned int, struct kstat *);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
+extern int __generic_block_fiemap(struct inode *inode,
+				  struct fiemap_extent_info *fieinfo, u64 start,
+				  u64 len, get_block_t *get_block);
 extern int generic_block_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo, u64 start,
 				u64 len, get_block_t *get_block);
-- 
1.6.0.3

