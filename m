Return-Path: <linux-kernel-owner+w=401wt.eu-S939719AbXG3QVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939719AbXG3QVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938601AbXG3QOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:40582 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764281AbXG3QOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:08 -0400
Message-Id: <20070730161324.160845468@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:34 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 11/26] tmpfs white-out support
Content-Disposition: inline; filename=um/tmpfs-whiteout.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce white-out support to tmpfs.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -33,6 +33,7 @@ struct shmem_sb_info {
 	int policy;		    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
 	spinlock_t    stat_lock;
+	struct inode *whiteout_inode;
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1784,6 +1784,42 @@ static int shmem_create(struct inode *di
 }
 
 /*
+ * This is the whiteout support for tmpfs. It uses one singleton whiteout
+ * inode per superblock thus it is very similar to shmem_link().
+ */
+static int shmem_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
+	struct inode *inode = sbinfo->whiteout_inode;
+
+	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
+		return -EPERM;
+
+	/*
+	 * No ordinary (disk based) filesystem counts whiteouts as inodes;
+	 * but each new link needs a new dentry, pinning lowmem, and
+	 * tmpfs dentries cannot be pruned until they are unlinked.
+	 */
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOSPC;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+
+	dir->i_size += BOGO_DIRENT_SIZE;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	inc_nlink(inode);
+	atomic_inc(&inode->i_count);	/* New dentry reference */
+	dget(dentry);		/* Extra pinning count for the created dentry */
+	d_instantiate(dentry, inode);
+	return 0;
+}
+
+/*
  * Link a file..
  */
 static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
@@ -2231,6 +2267,9 @@ out:
 
 static void shmem_put_super(struct super_block *sb)
 {
+	struct shmem_sb_info *sbinfo = sb->s_fs_info;
+
+	iput(sbinfo->whiteout_inode);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -2305,6 +2344,19 @@ static int shmem_fill_super(struct super
 	if (!root)
 		goto failed_iput;
 	sb->s_root = root;
+
+#ifdef CONFIG_TMPFS
+	if (!(sb->s_flags & MS_NOUSER)) {
+		inode = shmem_get_inode(sb, S_IRUGO | S_IWUGO | S_IFWHT, 0);
+		if (!inode) {
+			dput(root);
+			goto failed;
+		}
+		sbinfo->whiteout_inode = inode;
+		sb->s_flags |= MS_WHITEOUT;
+	}
+#endif
+
 	return 0;
 
 failed_iput:
@@ -2410,6 +2462,7 @@ static const struct inode_operations shm
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.whiteout       = shmem_whiteout,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
@@ -2464,6 +2517,7 @@ static struct file_system_type tmpfs_fs_
 	.name		= "tmpfs",
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
+	.fs_flags	= FS_WHT,
 };
 static struct vfsmount *shm_mnt;
 

-- 

