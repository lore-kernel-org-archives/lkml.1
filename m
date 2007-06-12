Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXFLHE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXFLHE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXFLHAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:41 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/18] sendfile: remove .sendfile from filesystems that use generic_file_sendfile()
Date: Tue, 12 Jun 2007 08:58:00 +0200
Message-Id: <1181631495561-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

They can use generic_file_splice_read() instead. Since sys_sendfile() now
prefers that, there should be no change in behaviour.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/adfs/file.c               |    2 +-
 fs/affs/file.c               |    2 +-
 fs/afs/file.c                |    2 +-
 fs/bfs/file.c                |    2 +-
 fs/block_dev.c               |    1 -
 fs/cifs/cifsfs.c             |    8 +++---
 fs/coda/file.c               |   11 +++++----
 fs/ecryptfs/file.c           |   15 +++++++------
 fs/ext2/file.c               |    1 -
 fs/ext3/file.c               |    1 -
 fs/ext4/file.c               |    1 -
 fs/fat/file.c                |    2 +-
 fs/fuse/file.c               |    4 +-
 fs/gfs2/ops_file.c           |    1 -
 fs/hfs/inode.c               |    2 +-
 fs/hfsplus/inode.c           |    2 +-
 fs/hostfs/hostfs_kern.c      |    2 +-
 fs/hpfs/file.c               |    2 +-
 fs/jffs2/file.c              |    2 +-
 fs/jfs/file.c                |    1 -
 fs/minix/file.c              |    2 +-
 fs/ntfs/file.c               |    2 +-
 fs/ocfs2/file.c              |    1 -
 fs/qnx4/file.c               |    2 +-
 fs/ramfs/file-mmu.c          |    2 +-
 fs/ramfs/file-nommu.c        |    2 +-
 fs/reiserfs/file.c           |    1 -
 fs/smbfs/file.c              |    9 ++++---
 fs/sysv/file.c               |    2 +-
 fs/udf/file.c                |    2 +-
 fs/ufs/file.c                |    2 +-
 fs/xfs/linux-2.6/xfs_file.c  |   26 ------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c   |   44 ------------------------------------------
 fs/xfs/linux-2.6/xfs_lrw.h   |    3 --
 fs/xfs/linux-2.6/xfs_vnode.h |    6 -----
 fs/xfs/xfs_vnodeops.c        |    3 --
 37 files changed, 43 insertions(+), 131 deletions(-)

diff --git a/fs/adfs/file.c b/fs/adfs/file.c
index f544a28..36e381c 100644
--- a/fs/adfs/file.c
+++ b/fs/adfs/file.c
@@ -33,7 +33,7 @@ const struct file_operations adfs_file_operations = {
 	.fsync		= file_fsync,
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 const struct inode_operations adfs_file_inode_operations = {
diff --git a/fs/affs/file.c b/fs/affs/file.c
index c879690..c314a35 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -35,7 +35,7 @@ const struct file_operations affs_file_operations = {
 	.open		= affs_file_open,
 	.release	= affs_file_release,
 	.fsync		= file_fsync,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 const struct inode_operations affs_file_inode_operations = {
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 9c0e721..aede7eb 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -32,7 +32,7 @@ const struct file_operations afs_file_operations = {
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= afs_file_write,
 	.mmap		= generic_file_readonly_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
 };
 
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index ef4d1fa..24310e9 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -24,7 +24,7 @@ const struct file_operations bfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 static int bfs_move_block(unsigned long from, unsigned long to, struct super_block *sb)
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea1480a..b3e9bfa 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1346,7 +1346,6 @@ const struct file_operations def_blk_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
-	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7c04752..8b0cbf4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -616,7 +616,7 @@ const struct file_operations cifs_file_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
-	.sendfile = generic_file_sendfile,
+	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.ioctl	= cifs_ioctl,
@@ -637,7 +637,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.lock = cifs_lock,
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
-	.sendfile = generic_file_sendfile, /* BB removeme BB */
+	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
 	.ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -656,7 +656,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
-	.sendfile = generic_file_sendfile,
+	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.ioctl	= cifs_ioctl,
@@ -676,7 +676,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.release = cifs_close,
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
-	.sendfile = generic_file_sendfile, /* BB removeme BB */
+	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
 	.ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 5ef2b60..99dbe86 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -47,8 +47,9 @@ coda_file_read(struct file *coda_file, char __user *buf, size_t count, loff_t *p
 }
 
 static ssize_t
-coda_file_sendfile(struct file *coda_file, loff_t *ppos, size_t count,
-		   read_actor_t actor, void *target)
+coda_file_splice_read(struct file *coda_file, loff_t *ppos,
+		      struct pipe_inode_info *pipe, size_t count,
+		      unsigned int flags)
 {
 	struct coda_file_info *cfi;
 	struct file *host_file;
@@ -57,10 +58,10 @@ coda_file_sendfile(struct file *coda_file, loff_t *ppos, size_t count,
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 	host_file = cfi->cfi_container;
 
-	if (!host_file->f_op || !host_file->f_op->sendfile)
+	if (!host_file->f_op || !host_file->f_op->splice_read)
 		return -EINVAL;
 
-	return host_file->f_op->sendfile(host_file, ppos, count, actor, target);
+	return host_file->f_op->splice_read(host_file, ppos, pipe, count,flags);
 }
 
 static ssize_t
@@ -295,6 +296,6 @@ const struct file_operations coda_file_operations = {
 	.flush		= coda_flush,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
-	.sendfile	= coda_file_sendfile,
+	.splice_read	= coda_file_splice_read,
 };
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 59288d8..94f456f 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -338,16 +338,17 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	return rc;
 }
 
-static ssize_t ecryptfs_sendfile(struct file *file, loff_t * ppos,
-				 size_t count, read_actor_t actor, void *target)
+static ssize_t ecryptfs_splice_read(struct file *file, loff_t * ppos,
+				    struct pipe_inode_info *pipe, size_t count,
+				    unsigned int flags)
 {
 	struct file *lower_file = NULL;
 	int rc = -EINVAL;
 
 	lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file->f_op && lower_file->f_op->sendfile)
-		rc = lower_file->f_op->sendfile(lower_file, ppos, count,
-						actor, target);
+	if (lower_file->f_op && lower_file->f_op->splice_read)
+		rc = lower_file->f_op->splice_read(lower_file, ppos, pipe,
+						count, flags);
 
 	return rc;
 }
@@ -364,7 +365,7 @@ const struct file_operations ecryptfs_dir_fops = {
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.sendfile = ecryptfs_sendfile,
+	.splice_read = ecryptfs_splice_read,
 };
 
 const struct file_operations ecryptfs_main_fops = {
@@ -381,7 +382,7 @@ const struct file_operations ecryptfs_main_fops = {
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.sendfile = ecryptfs_sendfile,
+	.splice_read = ecryptfs_splice_read,
 };
 
 static int
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 566d4e2..072a190 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -53,7 +53,6 @@ const struct file_operations ext2_file_operations = {
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_sync_file,
-	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 1e6f138..acc4913 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -120,7 +120,6 @@ const struct file_operations ext3_file_operations = {
 	.open		= generic_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
-	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3c6c1fd..d4c8186 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -120,7 +120,6 @@ const struct file_operations ext4_file_operations = {
 	.open		= generic_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
-	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 55d3c74..69a83b5 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -134,7 +134,7 @@ const struct file_operations fat_file_operations = {
 	.release	= fat_file_release,
 	.ioctl		= fat_generic_ioctl,
 	.fsync		= file_fsync,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index adf7995..f79de7c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -802,7 +802,7 @@ static const struct file_operations fuse_file_operations = {
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
@@ -814,7 +814,7 @@ static const struct file_operations fuse_direct_io_file_operations = {
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
-	/* no mmap and sendfile */
+	/* no mmap and splice_read */
 };
 
 static const struct address_space_operations fuse_file_aops  = {
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 064df88..7dc3be1 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -635,7 +635,6 @@ const struct file_operations gfs2_file_fops = {
 	.release	= gfs2_close,
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
-	.sendfile	= generic_file_sendfile,
 	.flock		= gfs2_flock,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 9a934db..bc835f2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -607,7 +607,7 @@ static const struct file_operations hfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 	.fsync		= file_fsync,
 	.open		= hfs_file_open,
 	.release	= hfs_file_release,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 45dab5d..409ce54 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -288,7 +288,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 	.fsync		= file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 8286491..c778620 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -390,7 +390,7 @@ int hostfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 static const struct file_operations hostfs_file_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.write		= do_sync_write,
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index b4eafc0..5b53e5c 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -129,7 +129,7 @@ const struct file_operations hpfs_file_ops =
 	.mmap		= generic_file_mmap,
 	.release	= hpfs_file_release,
 	.fsync		= hpfs_file_fsync,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 const struct inode_operations hpfs_file_iops =
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 9987127..c253019 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -47,7 +47,7 @@ const struct file_operations jffs2_file_operations =
 	.ioctl =	jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
-	.sendfile =	generic_file_sendfile
+	.splice_read =	generic_file_splice_read,
 };
 
 /* jffs2_file_inode_operations */
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index f7f8eff..87eb936 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -108,7 +108,6 @@ const struct file_operations jfs_file_operations = {
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
-	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 	.fsync		= jfs_fsync,
diff --git a/fs/minix/file.c b/fs/minix/file.c
index f92baa1..17765f6 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -23,7 +23,7 @@ const struct file_operations minix_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= minix_sync_file,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 const struct inode_operations minix_file_inode_operations = {
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 7ed5639..ffcc504 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2276,7 +2276,7 @@ const struct file_operations ntfs_file_ops = {
 						    mounted filesystem. */
 	.mmap		= generic_file_mmap,	 /* Mmap file. */
 	.open		= ntfs_file_open,	 /* Open file. */
-	.sendfile	= generic_file_sendfile, /* Zero-copy data send with
+	.splice_read	= generic_file_splice_read /* Zero-copy data send with
 						    the data source being on
 						    the ntfs partition.  We do
 						    not need to care about the
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index eb97b20..4f6033a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1822,7 +1822,6 @@ const struct inode_operations ocfs2_special_file_iops = {
 const struct file_operations ocfs2_fops = {
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.sendfile	= generic_file_sendfile,
 	.mmap		= ocfs2_mmap,
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_file_release,
diff --git a/fs/qnx4/file.c b/fs/qnx4/file.c
index 4464998..867f42b 100644
--- a/fs/qnx4/file.c
+++ b/fs/qnx4/file.c
@@ -25,7 +25,7 @@ const struct file_operations qnx4_file_operations =
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.mmap		= generic_file_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 #ifdef CONFIG_QNX4FS_RW
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 2f14774..97bdc0b 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -41,7 +41,7 @@ const struct file_operations ramfs_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= simple_sync_file,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 	.llseek		= generic_file_llseek,
 };
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 5d258c4..cad2b7a 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -42,7 +42,7 @@ const struct file_operations ramfs_file_operations = {
 	.write			= do_sync_write,
 	.aio_write		= generic_file_aio_write,
 	.fsync			= simple_sync_file,
-	.sendfile		= generic_file_sendfile,
+	.splice_read		= generic_file_splice_read,
 	.llseek			= generic_file_llseek,
 };
 
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 9e451a6..30eebfb 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -1531,7 +1531,6 @@ const struct file_operations reiserfs_file_operations = {
 	.open = generic_file_open,
 	.release = reiserfs_file_release,
 	.fsync = reiserfs_sync_file,
-	.sendfile = generic_file_sendfile,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
 	.splice_read = generic_file_splice_read,
diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index aea3f8a..c5d78a7 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -262,8 +262,9 @@ out:
 }
 
 static ssize_t
-smb_file_sendfile(struct file *file, loff_t *ppos,
-		  size_t count, read_actor_t actor, void *target)
+smb_file_splice_read(struct file *file, loff_t *ppos,
+		     struct pipe_inode_info *pipe, size_t count,
+		     unsigned int flags)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	ssize_t status;
@@ -277,7 +278,7 @@ smb_file_sendfile(struct file *file, loff_t *ppos,
 			 DENTRY_PATH(dentry), status);
 		goto out;
 	}
-	status = generic_file_sendfile(file, ppos, count, actor, target);
+	status = generic_file_splice_read(file, ppos, pipe, count, flags);
 out:
 	return status;
 }
@@ -416,7 +417,7 @@ const struct file_operations smb_file_operations =
 	.open		= smb_file_open,
 	.release	= smb_file_release,
 	.fsync		= smb_fsync,
-	.sendfile	= smb_file_sendfile,
+	.splice_read	= smb_file_splice_read,
 };
 
 const struct inode_operations smb_file_inode_operations =
diff --git a/fs/sysv/file.c b/fs/sysv/file.c
index 0732ddb..589be21 100644
--- a/fs/sysv/file.c
+++ b/fs/sysv/file.c
@@ -27,7 +27,7 @@ const struct file_operations sysv_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= sysv_sync_file,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 const struct inode_operations sysv_file_inode_operations = {
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 51b5764..df070be 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -261,7 +261,7 @@ const struct file_operations udf_file_operations = {
 	.aio_write		= udf_file_aio_write,
 	.release		= udf_release_file,
 	.fsync			= udf_fsync_file,
-	.sendfile		= generic_file_sendfile,
+	.splice_read		= generic_file_splice_read,
 };
 
 const struct inode_operations udf_file_inode_operations = {
diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index 1e09632..6705d74 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -60,5 +60,5 @@ const struct file_operations ufs_file_operations = {
 	.mmap		= generic_file_mmap,
 	.open           = generic_file_open,
 	.fsync		= ufs_sync_file,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index cb51dc9..8c43cd2 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -124,30 +124,6 @@ xfs_file_aio_write_invis(
 }
 
 STATIC ssize_t
-xfs_file_sendfile(
-	struct file		*filp,
-	loff_t			*pos,
-	size_t			count,
-	read_actor_t		actor,
-	void			*target)
-{
-	return bhv_vop_sendfile(vn_from_inode(filp->f_path.dentry->d_inode),
-				filp, pos, 0, count, actor, target, NULL);
-}
-
-STATIC ssize_t
-xfs_file_sendfile_invis(
-	struct file		*filp,
-	loff_t			*pos,
-	size_t			count,
-	read_actor_t		actor,
-	void			*target)
-{
-	return bhv_vop_sendfile(vn_from_inode(filp->f_path.dentry->d_inode),
-				filp, pos, IO_INVIS, count, actor, target, NULL);
-}
-
-STATIC ssize_t
 xfs_file_splice_read(
 	struct file		*infilp,
 	loff_t			*ppos,
@@ -452,7 +428,6 @@ const struct file_operations xfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= xfs_file_aio_read,
 	.aio_write	= xfs_file_aio_write,
-	.sendfile	= xfs_file_sendfile,
 	.splice_read	= xfs_file_splice_read,
 	.splice_write	= xfs_file_splice_write,
 	.unlocked_ioctl	= xfs_file_ioctl,
@@ -475,7 +450,6 @@ const struct file_operations xfs_invis_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= xfs_file_aio_read_invis,
 	.aio_write	= xfs_file_aio_write_invis,
-	.sendfile	= xfs_file_sendfile_invis,
 	.splice_read	= xfs_file_splice_read_invis,
 	.splice_write	= xfs_file_splice_write_invis,
 	.unlocked_ioctl	= xfs_file_ioctl_invis,
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 715adad..af24a45 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -101,7 +101,6 @@
  * Feature macros (disable/enable)
  */
 #undef  HAVE_REFCACHE	/* reference cache not needed for NFS in 2.6 */
-#define HAVE_SENDFILE	/* sendfile(2) exists in 2.6, but not in 2.4 */
 #define HAVE_SPLICE	/* a splice(2) exists in 2.6, but not in 2.4 */
 #ifdef CONFIG_SMP
 #define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 86fb671..23978d3 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -287,50 +287,6 @@ xfs_read(
 }
 
 ssize_t
-xfs_sendfile(
-	bhv_desc_t		*bdp,
-	struct file		*filp,
-	loff_t			*offset,
-	int			ioflags,
-	size_t			count,
-	read_actor_t		actor,
-	void			*target,
-	cred_t			*credp)
-{
-	xfs_inode_t		*ip = XFS_BHVTOI(bdp);
-	xfs_mount_t		*mp = ip->i_mount;
-	ssize_t			ret;
-
-	XFS_STATS_INC(xs_read_calls);
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-
-	if (DM_EVENT_ENABLED(BHV_TO_VNODE(bdp)->v_vfsp, ip, DM_EVENT_READ) &&
-	    (!(ioflags & IO_INVIS))) {
-		bhv_vrwlock_t locktype = VRWLOCK_READ;
-		int error;
-
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, BHV_TO_VNODE(bdp),
-				      *offset, count,
-				      FILP_DELAY_FLAG(filp), &locktype);
-		if (error) {
-			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-			return -error;
-		}
-	}
-	xfs_rw_enter_trace(XFS_SENDFILE_ENTER, &ip->i_iocore,
-		   (void *)(unsigned long)target, count, *offset, ioflags);
-	ret = generic_file_sendfile(filp, offset, count, actor, target);
-	if (ret > 0)
-		XFS_STATS_ADD(xs_read_bytes, ret);
-
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-	return ret;
-}
-
-ssize_t
 xfs_splice_read(
 	bhv_desc_t		*bdp,
 	struct file		*infilp,
diff --git a/fs/xfs/linux-2.6/xfs_lrw.h b/fs/xfs/linux-2.6/xfs_lrw.h
index 7ac51b1..7c60a1e 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.h
+++ b/fs/xfs/linux-2.6/xfs_lrw.h
@@ -90,9 +90,6 @@ extern ssize_t xfs_read(struct bhv_desc *, struct kiocb *,
 extern ssize_t xfs_write(struct bhv_desc *, struct kiocb *,
 				const struct iovec *, unsigned int,
 				loff_t *, int, struct cred *);
-extern ssize_t xfs_sendfile(struct bhv_desc *, struct file *,
-				loff_t *, int, size_t, read_actor_t,
-				void *, struct cred *);
 extern ssize_t xfs_splice_read(struct bhv_desc *, struct file *, loff_t *,
 				struct pipe_inode_info *, size_t, int, int,
 				struct cred *);
diff --git a/fs/xfs/linux-2.6/xfs_vnode.h b/fs/xfs/linux-2.6/xfs_vnode.h
index d1b2d01..013048a 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.h
+++ b/fs/xfs/linux-2.6/xfs_vnode.h
@@ -139,9 +139,6 @@ typedef ssize_t (*vop_read_t)(bhv_desc_t *, struct kiocb *,
 typedef ssize_t (*vop_write_t)(bhv_desc_t *, struct kiocb *,
 				const struct iovec *, unsigned int,
 				loff_t *, int, struct cred *);
-typedef ssize_t (*vop_sendfile_t)(bhv_desc_t *, struct file *,
-				loff_t *, int, size_t, read_actor_t,
-				void *, struct cred *);
 typedef ssize_t (*vop_splice_read_t)(bhv_desc_t *, struct file *, loff_t *,
 				struct pipe_inode_info *, size_t, int, int,
 				struct cred *);
@@ -206,7 +203,6 @@ typedef struct bhv_vnodeops {
 	vop_close_t		vop_close;
 	vop_read_t		vop_read;
 	vop_write_t		vop_write;
-	vop_sendfile_t		vop_sendfile;
 	vop_splice_read_t	vop_splice_read;
 	vop_splice_write_t	vop_splice_write;
 	vop_ioctl_t		vop_ioctl;
@@ -254,8 +250,6 @@ typedef struct bhv_vnodeops {
 		VOP(vop_read, vp)(VNHEAD(vp),file,iov,segs,offset,ioflags,cr)
 #define bhv_vop_write(vp,file,iov,segs,offset,ioflags,cr)		\
 		VOP(vop_write, vp)(VNHEAD(vp),file,iov,segs,offset,ioflags,cr)
-#define bhv_vop_sendfile(vp,f,off,ioflags,cnt,act,targ,cr)		\
-		VOP(vop_sendfile, vp)(VNHEAD(vp),f,off,ioflags,cnt,act,targ,cr)
 #define bhv_vop_splice_read(vp,f,o,pipe,cnt,fl,iofl,cr)			\
 		VOP(vop_splice_read, vp)(VNHEAD(vp),f,o,pipe,cnt,fl,iofl,cr)
 #define bhv_vop_splice_write(vp,f,o,pipe,cnt,fl,iofl,cr)		\
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index de17aed..70bc82f 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -4680,9 +4680,6 @@ bhv_vnodeops_t xfs_vnodeops = {
 	.vop_open		= xfs_open,
 	.vop_close		= xfs_close,
 	.vop_read		= xfs_read,
-#ifdef HAVE_SENDFILE
-	.vop_sendfile		= xfs_sendfile,
-#endif
 #ifdef HAVE_SPLICE
 	.vop_splice_read	= xfs_splice_read,
 	.vop_splice_write	= xfs_splice_write,
-- 
1.5.2.1.174.gcd03

