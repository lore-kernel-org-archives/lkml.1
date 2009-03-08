Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZCHSGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZCHSGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZCHSGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:06:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:34231 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZCHSGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:06:41 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm] nilfs2: support nanosecond timestamp
Date: Mon,  9 Mar 2009 02:58:43 +0900
Message-Id: <1236535123-15219-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 09 Mar 2009 03:06:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a review of user's feedback for finding out other compatibility
issues, I found nilfs improperly initializes timestamps in inode;
CURRENT_TIME was used there instead of CURRENT_TIME_SEC even though
nilfs didn't have nanosecond timestamps on disk.  A few users gave us
the report that the tar program sometimes failed to expand symbolic
links on nilfs, and it turned out to be the cause.

Instead of applying the above displacement, I've decided to support
nanosecond timestamps on this occation.  Fortunetaly, a needless
64-bit field was in the nilfs_inode struct, and I found it's available
for this purpose without impact for the users.

So, this will do the enhancement and resolve the tar problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/gcinode.c       |    1 -
 fs/nilfs2/inode.c         |   13 ++++++-------
 fs/nilfs2/nilfs.h         |    1 -
 fs/nilfs2/super.c         |    1 +
 include/linux/nilfs2_fs.h |   10 ++++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 77615aa..19d2102 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -226,7 +226,6 @@ static struct inode *alloc_gcinode(struct the_nilfs *nilfs, ino_t ino,
 	ii->i_flags = 0;
 	ii->i_state = 1 << NILFS_I_GCINODE;
 	ii->i_bh = NULL;
-	ii->i_dtime = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
 	return inode;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a1922b1..49ab4a4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -306,7 +306,6 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
-	ii->i_dtime = 0;
 	ii->i_dir_start_lookup = 0;
 #ifdef CONFIG_NILFS_FS_POSIX_ACL
 	ii->i_acl = NULL;
@@ -390,11 +389,10 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
 	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
-	inode->i_atime.tv_nsec = 0;
-	inode->i_ctime.tv_nsec = 0;
-	inode->i_mtime.tv_nsec = 0;
-	ii->i_dtime = le64_to_cpu(raw_inode->i_dtime);
-	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ii->i_dtime))
+	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
+	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (inode->i_nlink == 0 && inode->i_mode == 0)
 		return -EINVAL; /* this inode is deleted */
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
@@ -505,9 +503,10 @@ void nilfs_write_inode_common(struct inode *inode,
 	raw_inode->i_size = cpu_to_le64(inode->i_size);
 	raw_inode->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le64(inode->i_mtime.tv_sec);
+	raw_inode->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	raw_inode->i_mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 	raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
 
-	raw_inode->i_dtime = cpu_to_le64(ii->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index dc85a51..31038e9 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -48,7 +48,6 @@ struct nilfs_inode_info {
 	struct nilfs_bmap *i_bmap;
 	union nilfs_bmap_union i_bmap_union;
 	__u64 i_xattr;	/* sector_t ??? */
-	__u32 i_dtime;
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
 	struct address_space i_btnode_cache;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index e2ced82..e117e1e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -792,6 +792,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	sb->s_op = &nilfs_sops;
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
+	sb->s_time_gran = 1;
 
 	if (!nilfs_loaded(nilfs)) {
 		err = load_nilfs(nilfs, sbi);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 1275b30..79fec6a 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -67,9 +67,10 @@
  * struct nilfs_inode - structure of an inode on disk
  * @i_blocks: blocks count
  * @i_size: size in bytes
- * @i_ctime: creation time
- * @i_mtime: modification time
- * @i_dtime: deletion time
+ * @i_ctime: creation time (seconds)
+ * @i_mtime: modification time (seconds)
+ * @i_ctime_nsec: creation time (nano seconds)
+ * @i_mtime_nsec: modification time (nano seconds)
  * @i_uid: user id
  * @i_gid: group id
  * @i_mode: file mode
@@ -85,7 +86,8 @@ struct nilfs_inode {
 	__le64	i_size;
 	__le64	i_ctime;
 	__le64	i_mtime;
-	__le64	i_dtime;
+	__le32	i_ctime_nsec;
+	__le32	i_mtime_nsec;
 	__le32	i_uid;
 	__le32	i_gid;
 	__le16	i_mode;
-- 
1.5.6.5

