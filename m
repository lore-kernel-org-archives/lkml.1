Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZKPJsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZKPJsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZKPJsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:48:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:33065 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZKPJsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:48:02 -0500
Date: Mon, 16 Nov 2009 18:48:00 +0900 (JST)
Message-Id: <20091116.184800.34161391.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes #2 for 2.6.32
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 16 Nov 2009 18:48:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive a few additional patches, one of which fixes a lock order
reversal detected in an ioctl operation, and others for trivial
cleanups.

Thanks!

Ryusuke Konishi
--
The following changes since commit 156171c71a0dc4bce12b4408bb1591f8fe32dc1a:
  Linus Torvalds (1):
        Linux 2.6.32-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Jiro SEKIBA (2):
      nilfs2: deleted struct nilfs_dat_group_desc
      nilfs2: deleted inconsistent comment in nilfs_load_inode_block()

Ryusuke Konishi (1):
      nilfs2: fix lock order reversal in chcp operation

 fs/nilfs2/cpfile.c        |    2 --
 fs/nilfs2/inode.c         |    1 -
 fs/nilfs2/ioctl.c         |    6 +++++-
 include/linux/nilfs2_fs.h |    9 ---------
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 1c6cfb5..3f5d5d0 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -871,7 +871,6 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 		 * exclusive with a new mount job.  Though it doesn't cover
 		 * umount, it's enough for the purpose.
 		 */
-		mutex_lock(&nilfs->ns_mount_mutex);
 		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
 			/* Current implementation does not have to protect
 			   plain read-only mounts since they are exclusive
@@ -880,7 +879,6 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 			ret = -EBUSY;
 		} else
 			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
-		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_set_snapshot(cpfile, cno);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5040220..2a0a5a3 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -664,7 +664,6 @@ int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
 	int err;
 
 	spin_lock(&sbi->s_inode_lock);
-	/* Caller of this function MUST lock s_inode_lock */
 	if (ii->i_bh == NULL) {
 		spin_unlock(&sbi->s_inode_lock);
 		err = nilfs_ifile_get_inode_block(sbi->s_ifile, inode->i_ino,
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index d24057d..f6af760 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -99,7 +99,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
 {
-	struct inode *cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct inode *cpfile = nilfs->ns_cpfile;
 	struct nilfs_transaction_info ti;
 	struct nilfs_cpmode cpmode;
 	int ret;
@@ -109,14 +110,17 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
 		return -EFAULT;
 
+	mutex_lock(&nilfs->ns_mount_mutex);
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
 		cpfile, cpmode.cm_cno, cpmode.cm_mode);
 	if (unlikely(ret < 0)) {
 		nilfs_transaction_abort(inode->i_sb);
+		mutex_unlock(&nilfs->ns_mount_mutex);
 		return ret;
 	}
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
+	mutex_unlock(&nilfs->ns_mount_mutex);
 	return ret;
 }
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 79fec6a..ce52040 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -425,15 +425,6 @@ struct nilfs_dat_entry {
 };
 
 /**
- * struct nilfs_dat_group_desc - block group descriptor
- * @dg_nfrees: number of free virtual block numbers in block group
- */
-struct nilfs_dat_group_desc {
-	__le32 dg_nfrees;
-};
-
-
-/**
  * struct nilfs_snapshot_list - snapshot list
  * @ssl_next: next checkpoint number on snapshot list
  * @ssl_prev: previous checkpoint number on snapshot list
