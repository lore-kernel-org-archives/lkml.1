Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXJLQ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXJLQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbXJLQJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585AbXJLQJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 43/52] CRED: Pass credentials through the statfs() superblock
	op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:59 +0100
Message-ID: <20071012160859.15119.52857.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the statfs() superblock operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/super.c     |    6 ++++--
 fs/ext3/super.c    |    6 ++++--
 fs/fat/inode.c     |    3 ++-
 fs/libfs.c         |    2 +-
 fs/nfs/super.c     |    6 +++---
 fs/open.c          |    3 ++-
 include/linux/fs.h |    4 ++--
 mm/shmem.c         |    3 ++-
 8 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 82ccd94..c7d7c1c 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -35,7 +35,8 @@ static int afs_get_sb(struct file_system_type *fs_type,
 static struct inode *afs_alloc_inode(struct super_block *sb);
 static void afs_put_super(struct super_block *sb);
 static void afs_destroy_inode(struct inode *inode);
-static int afs_statfs(struct dentry *dentry, struct kstatfs *buf);
+static int afs_statfs(struct dentry *dentry, struct kstatfs *buf,
+		      struct cred *cred);
 
 struct file_system_type afs_fs_type = {
 	.owner		= THIS_MODULE,
@@ -511,7 +512,8 @@ static void afs_destroy_inode(struct inode *inode)
 /*
  * return information about an AFS volume
  */
-static int afs_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int afs_statfs(struct dentry *dentry, struct kstatfs *buf,
+		      struct cred *cred)
 {
 	struct afs_volume_status vs;
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 348bb6b..29a41cc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -59,7 +59,8 @@ static int ext3_sync_fs(struct super_block *sb, int wait);
 static const char *ext3_decode_error(struct super_block * sb, int errno,
 				     char nbuf[16]);
 static int ext3_remount (struct super_block * sb, int * flags, char * data);
-static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf);
+static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf,
+			struct cred *cred);
 static void ext3_unlockfs(struct super_block *sb);
 static void ext3_write_super (struct super_block * sb);
 static void ext3_write_super_lockfs(struct super_block *sb);
@@ -2429,7 +2430,8 @@ restore_opts:
 	return err;
 }
 
-static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
+static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf,
+			struct cred *cred)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 519e1b4..a224325 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -537,7 +537,8 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
-static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int fat_statfs(struct dentry *dentry, struct kstatfs *buf,
+		      struct cred *cred)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 107412e..e214329 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -20,7 +20,7 @@ int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
-int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
+int simple_statfs(struct dentry *dentry, struct kstatfs *buf, struct cred *cred)
 {
 	buf->f_type = dentry->d_sb->s_magic;
 	buf->f_bsize = PAGE_CACHE_SIZE;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 44e2583..524e8a1 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -220,7 +220,7 @@ static match_table_t nfs_secflavor_tokens = {
 
 
 static void nfs_umount_begin(struct vfsmount *, int);
-static int  nfs_statfs(struct dentry *, struct kstatfs *);
+static int  nfs_statfs(struct dentry *, struct kstatfs *, struct cred *);
 static int  nfs_show_options(struct seq_file *, struct vfsmount *);
 static int  nfs_show_stats(struct seq_file *, struct vfsmount *);
 static int nfs_get_sb(struct file_system_type *, int, const char *, void *,
@@ -358,9 +358,9 @@ void __exit unregister_nfs_fs(void)
 /*
  * Deliver file system statistics to userspace
  */
-static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf,
+		      struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct nfs_server *server = NFS_SB(dentry->d_sb);
 	unsigned char blockbits;
 	unsigned long blockres;
diff --git a/fs/open.c b/fs/open.c
index c383efe..291f875 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
+	struct cred *cred = current->cred;
 	int retval = -ENODEV;
 
 	if (dentry) {
@@ -39,7 +40,7 @@ int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			retval = security_sb_statfs(dentry);
 			if (retval)
 				return retval;
-			retval = dentry->d_sb->s_op->statfs(dentry, buf);
+			retval = dentry->d_sb->s_op->statfs(dentry, buf, cred);
 			if (retval == 0 && buf->f_frsize == 0)
 				buf->f_frsize = buf->f_bsize;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 658bdc8..2fec09a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1199,7 +1199,7 @@ struct super_operations {
 	int (*sync_fs)(struct super_block *sb, int wait);
 	void (*write_super_lockfs) (struct super_block *);
 	void (*unlockfs) (struct super_block *);
-	int (*statfs) (struct dentry *, struct kstatfs *);
+	int (*statfs) (struct dentry *, struct kstatfs *, struct cred *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct vfsmount *, int);
@@ -1801,7 +1801,7 @@ extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int simple_statfs(struct dentry *, struct kstatfs *);
+extern int simple_statfs(struct dentry *, struct kstatfs *, struct cred *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *,
 		       struct cred *);
 extern int simple_unlink(struct inode *, struct dentry *, struct cred *);
diff --git a/mm/shmem.c b/mm/shmem.c
index 4bcfdb8..432f023 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1682,7 +1682,8 @@ static ssize_t shmem_file_read(struct file *filp, char __user *buf, size_t count
 	return desc.error;
 }
 
-static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf,
+			struct cred *cred)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
 

