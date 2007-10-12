Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbXJLQYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbXJLQYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbXJLQIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXJLQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 37/52] CRED: Pass credentials to the get_sb() op and various
	fill_super() ops
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:28 +0100
Message-ID: <20071012160828.15119.56131.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials to the get_sb() filesystem operation and various fill_super()
operations required by get_sb_*() helpers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/super.c               |    3 ++-
 fs/anon_inodes.c             |    2 +-
 fs/autofs4/autofs_i.h        |    2 +-
 fs/autofs4/init.c            |    6 ++++--
 fs/autofs4/inode.c           |    3 ++-
 fs/binfmt_misc.c             |    8 +++++---
 fs/block_dev.c               |    3 ++-
 fs/devpts/inode.c            |    7 ++++---
 fs/ext3/super.c              |   10 ++++++----
 fs/inotify_user.c            |    3 ++-
 fs/nfs/super.c               |   32 +++++++++++++++++---------------
 fs/pipe.c                    |    2 +-
 fs/proc/inode.c              |    3 ++-
 fs/proc/root.c               |    5 +++--
 fs/ramfs/inode.c             |   14 ++++++++------
 fs/super.c                   |   15 ++++++++-------
 fs/sysfs/mount.c             |    8 +++++---
 fs/vfat/namei.c              |    7 ++++---
 include/linux/fs.h           |    9 +++++----
 include/linux/proc_fs.h      |    2 +-
 include/linux/ramfs.h        |    3 ++-
 kernel/futex.c               |    2 +-
 mm/shmem.c                   |    9 +++++----
 net/socket.c                 |    2 +-
 net/sunrpc/rpc_pipe.c        |    8 +++++---
 security/inode.c             |    7 ++++---
 security/selinux/selinuxfs.c |    7 ++++---
 27 files changed, 105 insertions(+), 77 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index b8808b4..82ccd94 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -31,7 +31,7 @@ static void afs_i_init_once(void *foo, struct kmem_cache *cachep,
 			    unsigned long flags);
 static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name,
-		      void *data, struct vfsmount *mnt);
+		      void *data, struct cred *cred, struct vfsmount *mnt);
 static struct inode *afs_alloc_inode(struct super_block *sb);
 static void afs_put_super(struct super_block *sb);
 static void afs_destroy_inode(struct inode *inode);
@@ -352,6 +352,7 @@ static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags,
 		      const char *dev_name,
 		      void *options,
+		      struct cred *cred,
 		      struct vfsmount *mnt)
 {
 	struct afs_mount_params params;
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index de05856..4ee735a 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -27,7 +27,7 @@ static const struct file_operations anon_inode_fops;
 
 static int anon_inodefs_get_sb(struct file_system_type *fs_type, int flags,
 			       const char *dev_name, void *data,
-			       struct vfsmount *mnt)
+			       struct cred *cred, struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "anon_inode:", NULL, ANON_INODE_FS_MAGIC,
 			     mnt);
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index d85f42f..41c15fe 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -182,7 +182,7 @@ extern const struct file_operations autofs4_root_operations;
 
 /* Initializing function */
 
-int autofs4_fill_super(struct super_block *, void *, int);
+int autofs4_fill_super(struct super_block *, void *, int, struct cred *);
 struct autofs_info *autofs4_init_ino(struct autofs_info *, struct autofs_sb_info *sbi, mode_t mode);
 
 /* Queue management functions */
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 723a1c5..74a601a 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -15,9 +15,11 @@
 #include "autofs_i.h"
 
 static int autofs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
+	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, cred,
+			    mnt);
 }
 
 static struct file_system_type autofs_fs_type = {
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 692364e..437c5c8 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -303,7 +303,8 @@ static struct dentry_operations autofs4_sb_dentry_operations = {
 	.d_release      = autofs4_dentry_release,
 };
 
-int autofs4_fill_super(struct super_block *s, void *data, int silent)
+int autofs4_fill_super(struct super_block *s, void *data, int silent,
+		       struct cred *cred)
 {
 	struct inode * root_inode;
 	struct dentry * root;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 42e94b3..c202450 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -715,7 +715,8 @@ static const struct super_operations s_ops = {
 	.clear_inode	= bm_clear_inode,
 };
 
-static int bm_fill_super(struct super_block * sb, void * data, int silent)
+static int bm_fill_super(struct super_block * sb, void * data, int silent,
+			 struct cred *cred)
 {
 	static struct tree_descr bm_files[] = {
 		[2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
@@ -729,9 +730,10 @@ static int bm_fill_super(struct super_block * sb, void * data, int silent)
 }
 
 static int bm_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, bm_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, bm_fill_super, cred, mnt);
 }
 
 static struct linux_binfmt misc_format = {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ef70bba..170c3ea 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -499,7 +499,8 @@ static const struct super_operations bdev_sops = {
 };
 
 static int bd_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "bdev:", &bdev_sops, 0x62646576, mnt);
 }
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index b6829ab..58c2c99 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -98,7 +98,7 @@ static const struct super_operations devpts_sops = {
 };
 
 static int
-devpts_fill_super(struct super_block *s, void *data, int silent)
+devpts_fill_super(struct super_block *s, void *data, int silent, struct cred *cred)
 {
 	struct inode * inode;
 
@@ -131,9 +131,10 @@ fail:
 }
 
 static int devpts_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, devpts_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, devpts_fill_super, cred, mnt);
 }
 
 static struct file_system_type devpts_fs_type = {
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2be33c1..3b89509 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1396,9 +1396,9 @@ static ext3_fsblk_t descriptor_loc(struct super_block *sb,
 }
 
 
-static int ext3_fill_super (struct super_block *sb, void *data, int silent)
+static int ext3_fill_super (struct super_block *sb, void *data, int silent,
+			    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct buffer_head * bh;
 	struct ext3_super_block *es = NULL;
 	struct ext3_sb_info *sbi;
@@ -2779,9 +2779,11 @@ out:
 #endif
 
 static int ext3_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, ext3_fill_super, mnt);
+	return get_sb_bdev(fs_type, flags, dev_name, data, ext3_fill_super,
+			   cred, mnt);
 }
 
 static struct file_system_type ext3_fs_type = {
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 9bf2f6c..0e42196 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -682,7 +682,8 @@ out:
 
 static int
 inotify_get_sb(struct file_system_type *fs_type, int flags,
-	       const char *dev_name, void *data, struct vfsmount *mnt)
+	       const char *dev_name, void *data, struct cred *cred,
+	       struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "inotify", NULL, 0xBAD1DEA, mnt);
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0988df4..44e2583 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -223,9 +223,11 @@ static void nfs_umount_begin(struct vfsmount *, int);
 static int  nfs_statfs(struct dentry *, struct kstatfs *);
 static int  nfs_show_options(struct seq_file *, struct vfsmount *);
 static int  nfs_show_stats(struct seq_file *, struct vfsmount *);
-static int nfs_get_sb(struct file_system_type *, int, const char *, void *, struct vfsmount *);
+static int nfs_get_sb(struct file_system_type *, int, const char *, void *,
+		      struct cred *, struct vfsmount *);
 static int nfs_xdev_get_sb(struct file_system_type *fs_type,
-		int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
+		int flags, const char *dev_name, void *raw_data,
+		struct cred *acred, struct vfsmount *mnt);
 static void nfs_kill_super(struct super_block *);
 
 static struct file_system_type nfs_fs_type = {
@@ -257,11 +259,14 @@ static const struct super_operations nfs_sops = {
 
 #ifdef CONFIG_NFS_V4
 static int nfs4_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
+	int flags, const char *dev_name, void *raw_data, struct cred *acred,
+	struct vfsmount *mnt);
 static int nfs4_xdev_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
+	int flags, const char *dev_name, void *raw_data, struct cred *acred,
+	struct vfsmount *mnt);
 static int nfs4_referral_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
+	int flags, const char *dev_name, void *raw_data, struct cred *acred,
+	struct vfsmount *mnt);
 static void nfs4_kill_super(struct super_block *sb);
 
 static struct file_system_type nfs4_fs_type = {
@@ -1377,9 +1382,9 @@ static int nfs_compare_super(struct super_block *sb, void *data)
 }
 
 static int nfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *raw_data, struct cred *acred,
+	struct vfsmount *mnt)
 {
-	struct cred *acred = current->cred;
 	struct nfs_server *server = NULL;
 	struct super_block *s;
 	struct nfs_fh mntfh;
@@ -1466,9 +1471,8 @@ static void nfs_kill_super(struct super_block *s)
  */
 static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 			   const char *dev_name, void *raw_data,
-			   struct vfsmount *mnt)
+			   struct cred *acred, struct vfsmount *mnt)
 {
-	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1732,9 +1736,9 @@ out_no_client_address:
  * Get the superblock for an NFS4 mountpoint
  */
 static int nfs4_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *raw_data, struct cred *acred,
+	struct vfsmount *mnt)
 {
-	struct cred *acred = current->cred;
 	struct nfs4_mount_data *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1827,9 +1831,8 @@ static void nfs4_kill_super(struct super_block *sb)
  */
 static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 			    const char *dev_name, void *raw_data,
-			    struct vfsmount *mnt)
+			    struct cred *acred, struct vfsmount *mnt)
 {
-	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1902,9 +1905,8 @@ error_splat_super:
  */
 static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 				const char *dev_name, void *raw_data,
-				struct vfsmount *mnt)
+				struct cred *acred, struct vfsmount *mnt)
 {
-	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
diff --git a/fs/pipe.c b/fs/pipe.c
index 5143262..47e7dcf 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1084,7 +1084,7 @@ int do_pipe(int *fd)
  */
 static int pipefs_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data,
-			 struct vfsmount *mnt)
+			 struct cred *cred, struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC, mnt);
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7a563c5..6b56b70 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -446,7 +446,8 @@ out_mod:
 	return NULL;
 }			
 
-int proc_fill_super(struct super_block *s, void *data, int silent)
+int proc_fill_super(struct super_block *s, void *data, int silent,
+		    struct cred *cred)
 {
 	struct inode * root_inode;
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index cf30466..03bfde1 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -24,7 +24,8 @@
 struct proc_dir_entry *proc_bus, *proc_root_fs, *proc_root_driver;
 
 static int proc_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
 	if (proc_mnt) {
 		/* Seed the root directory with a pid so it doesn't need
@@ -37,7 +38,7 @@ static int proc_get_sb(struct file_system_type *fs_type,
 		if (!ei->pid)
 			ei->pid = find_get_pid(1);
 	}
-	return get_sb_single(fs_type, flags, data, proc_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, proc_fill_super, cred, mnt);
 }
 
 static struct file_system_type proc_fs_type = {
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 9903253..0b8d868 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -165,9 +165,9 @@ static const struct super_operations ramfs_ops = {
 	.drop_inode	= generic_delete_inode,
 };
 
-static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
+static int ramfs_fill_super(struct super_block * sb, void * data, int silent,
+			    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode * inode;
 	struct dentry * root;
 
@@ -191,16 +191,18 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 }
 
 int ramfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, ramfs_fill_super, mnt);
+	return get_sb_nodev(fs_type, flags, data, ramfs_fill_super, cred, mnt);
 }
 
 static int rootfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
 	return get_sb_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super,
-			    mnt);
+			    cred, mnt);
 }
 
 static struct file_system_type ramfs_fs_type = {
diff --git a/fs/super.c b/fs/super.c
index fc8ebed..2a90d66 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -728,7 +728,7 @@ static int test_bdev_super(struct super_block *s, void *data)
 
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt)
 {
 	struct block_device *bdev;
@@ -765,7 +765,7 @@ int get_sb_bdev(struct file_system_type *fs_type,
 		s->s_flags = flags;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
-		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0, cred);
 		if (error) {
 			up_write(&s->s_umount);
 			deactivate_super(s);
@@ -801,7 +801,7 @@ EXPORT_SYMBOL(kill_block_super);
 
 int get_sb_nodev(struct file_system_type *fs_type,
 	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt)
 {
 	int error;
@@ -812,7 +812,7 @@ int get_sb_nodev(struct file_system_type *fs_type,
 
 	s->s_flags = flags;
 
-	error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+	error = fill_super(s, data, flags & MS_SILENT ? 1 : 0, cred);
 	if (error) {
 		up_write(&s->s_umount);
 		deactivate_super(s);
@@ -831,7 +831,7 @@ static int compare_single(struct super_block *s, void *p)
 
 int get_sb_single(struct file_system_type *fs_type,
 	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt)
 {
 	struct super_block *s;
@@ -842,7 +842,7 @@ int get_sb_single(struct file_system_type *fs_type,
 		return PTR_ERR(s);
 	if (!s->s_root) {
 		s->s_flags = flags;
-		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0, cred);
 		if (error) {
 			up_write(&s->s_umount);
 			deactivate_super(s);
@@ -859,6 +859,7 @@ EXPORT_SYMBOL(get_sb_single);
 struct vfsmount *
 vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void *data)
 {
+	struct cred *cred = current->cred;
 	struct vfsmount *mnt;
 	char *secdata = NULL;
 	int error;
@@ -881,7 +882,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 			goto out_free_secdata;
 	}
 
-	error = type->get_sb(type, flags, name, data, mnt);
+	error = type->get_sb(type, flags, name, data, cred, mnt);
 	if (error < 0)
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index fbc7b65..d382ced 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -31,7 +31,8 @@ struct sysfs_dirent sysfs_root = {
 	.s_ino		= 1,
 };
 
-static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
+static int sysfs_fill_super(struct super_block *sb, void *data, int silent,
+			    struct cred *cred)
 {
 	struct inode *inode;
 	struct dentry *root;
@@ -69,9 +70,10 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 }
 
 static int sysfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, sysfs_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, sysfs_fill_super, cred, mnt);
 }
 
 static struct file_system_type sysfs_fs_type = {
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 0502bb3..78a6854 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -1011,7 +1011,8 @@ static const struct inode_operations vfat_dir_inode_operations = {
 	.getattr	= fat_getattr,
 };
 
-static int vfat_fill_super(struct super_block *sb, void *data, int silent)
+static int vfat_fill_super(struct super_block *sb, void *data, int silent,
+			   struct cred *cred)
 {
 	int res;
 
@@ -1029,10 +1030,10 @@ static int vfat_fill_super(struct super_block *sb, void *data, int silent)
 
 static int vfat_get_sb(struct file_system_type *fs_type,
 		       int flags, const char *dev_name,
-		       void *data, struct vfsmount *mnt)
+		       void *data, struct cred *cred, struct vfsmount *mnt)
 {
 	return get_sb_bdev(fs_type, flags, dev_name, data, vfat_fill_super,
-			   mnt);
+			   cred, mnt);
 }
 
 static struct file_system_type vfat_fs_type = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e321a7c..53130df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1301,7 +1301,7 @@ struct file_system_type {
 	const char *name;
 	int fs_flags;
 	int (*get_sb) (struct file_system_type *, int,
-		       const char *, void *, struct vfsmount *);
+		       const char *, void *, struct cred *, struct vfsmount *);
 	void (*kill_sb) (struct super_block *);
 	struct module *owner;
 	struct file_system_type * next;
@@ -1310,17 +1310,18 @@ struct file_system_type {
 	struct lock_class_key s_umount_key;
 };
 
+typedef int (*fill_super_t)(struct super_block *, void *, int, struct cred *);
 extern int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt);
 extern int get_sb_single(struct file_system_type *fs_type,
 	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt);
 extern int get_sb_nodev(struct file_system_type *fs_type,
 	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
+	fill_super_t fill_super, struct cred *cred,
 	struct vfsmount *mnt);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 20741f6..a297a65 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -125,7 +125,7 @@ extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 extern struct vfsmount *proc_mnt;
-extern int proc_fill_super(struct super_block *,void *,int);
+extern int proc_fill_super(struct super_block *,void *,int, struct cred *);
 extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
 
 /*
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index 124b0c3..aaf7c0f 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -4,7 +4,8 @@
 struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev,
 			      struct cred *cred);
 extern int ramfs_get_sb(struct file_system_type *fs_type,
-	 int flags, const char *dev_name, void *data, struct vfsmount *mnt);
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt);
 
 #ifndef CONFIG_MMU
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
diff --git a/kernel/futex.c b/kernel/futex.c
index fcc94e7..a69a44d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2078,7 +2078,7 @@ asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
 			  int flags, const char *dev_name, void *data,
-			  struct vfsmount *mnt)
+			  struct cred *cred, struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "futex", NULL, 0xBAD1DEA, mnt);
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index ab44c06..4bcfdb8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2217,9 +2217,9 @@ static void shmem_put_super(struct super_block *sb)
 }
 
 static int shmem_fill_super(struct super_block *sb,
-			    void *data, int silent)
+			    void *data, int silent,
+			    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode;
 	struct dentry *root;
 	int mode   = S_IRWXUGO | S_ISVTX;
@@ -2436,9 +2436,10 @@ static struct vm_operations_struct shmem_vm_ops = {
 
 
 static int shmem_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *dev_name, void *data, struct cred *cred,
+	struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, shmem_fill_super, mnt);
+	return get_sb_nodev(fs_type, flags, data, shmem_fill_super, cred, mnt);
 }
 
 static struct file_system_type tmpfs_fs_type = {
diff --git a/net/socket.c b/net/socket.c
index dc40a5e..c19bd71 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -287,7 +287,7 @@ static struct super_operations sockfs_ops = {
 
 static int sockfs_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data,
-			 struct vfsmount *mnt)
+			 struct cred *cred, struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "socket:", &sockfs_ops, SOCKFS_MAGIC,
 			     mnt);
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index c38cc0d..2f6e630 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -800,7 +800,8 @@ static struct super_operations s_ops = {
 #define RPCAUTH_GSSMAGIC 0x67596969
 
 static int
-rpc_fill_super(struct super_block *sb, void *data, int silent)
+rpc_fill_super(struct super_block *sb, void *data, int silent,
+	       struct cred *cred)
 {
 	struct inode *inode;
 	struct dentry *root;
@@ -831,9 +832,10 @@ out:
 
 static int
 rpc_get_sb(struct file_system_type *fs_type,
-		int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+		int flags, const char *dev_name, void *data, struct cred *cred,
+		struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, rpc_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, rpc_fill_super, cred, mnt);
 }
 
 static struct file_system_type rpc_pipe_fs_type = {
diff --git a/security/inode.c b/security/inode.c
index 0ea9f41..37cfb40 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -126,7 +126,8 @@ static inline int positive(struct dentry *dentry)
 	return dentry->d_inode && !d_unhashed(dentry);
 }
 
-static int fill_super(struct super_block *sb, void *data, int silent)
+static int fill_super(struct super_block *sb, void *data, int silent,
+		      struct cred *cred)
 {
 	static struct tree_descr files[] = {{""}};
 
@@ -135,9 +136,9 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 
 static int get_sb(struct file_system_type *fs_type,
 		  int flags, const char *dev_name,
-		  void *data, struct vfsmount *mnt)
+		  void *data, struct cred *cred, struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, fill_super, cred, mnt);
 }
 
 static struct file_system_type fs_type = {
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 728b631..655bc2d 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1554,7 +1554,8 @@ out:
 	return ret;
 }
 
-static int sel_fill_super(struct super_block * sb, void * data, int silent)
+static int sel_fill_super(struct super_block * sb, void * data, int silent,
+			  struct cred *cred)
 {
 	int ret;
 	struct dentry *dentry;
@@ -1666,9 +1667,9 @@ err:
 
 static int sel_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name, void *data,
-		      struct vfsmount *mnt)
+		      struct cred *cred, struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, sel_fill_super, mnt);
+	return get_sb_single(fs_type, flags, data, sel_fill_super, cred, mnt);
 }
 
 static struct file_system_type sel_fs_type = {

