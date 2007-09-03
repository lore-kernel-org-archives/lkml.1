Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbXICC2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbXICC2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbXICCZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57623 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXICCY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:27 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 08/32] Unionfs: cache-coherency - update inode times
Date: Sun,  2 Sep 2007 22:20:31 -0400
Message-Id: <1188786056593-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Part of cache-coherency support (as per OLS'07 talk and
Documentation/filesystems/unionfs/concepts.txt): update our inode time if
lower had changed.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/file.c   |    7 +++++--
 fs/unionfs/inode.c  |   11 +++++++++++
 fs/unionfs/unlink.c |    3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index ad6821c..47b63f3 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -67,17 +67,20 @@ out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
-static ssize_t unionfs_write(struct file * file, const char __user * buf,
+
+static ssize_t unionfs_write(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	int err = 0;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 
 	err = do_sync_write(file, buf, count, ppos);
+	/* update our inode times upon a successful lower write */
+	if (err >= 0)
+		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 9261bed..66614e3 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -245,6 +245,12 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 		nd->dentry = path_save.dentry;
 		nd->mnt = path_save.mnt;
 	}
+	if (!IS_ERR(ret)) {
+		if (ret)
+			dentry = ret;
+		/* parent times may have changed */
+		unionfs_copy_attr_times(dentry->d_parent->d_inode);
+	}
 
 	unionfs_read_unlock(dentry->d_sb);
 
@@ -675,8 +681,11 @@ out:
 
 	kfree(name);
 
+	if (!err)
+		unionfs_copy_attr_times(dentry->d_inode);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
@@ -1006,6 +1015,8 @@ static int unionfs_permission(struct inode *inode, int mask,
 			break;
 		}
 	}
+	/* sync times which may have changed (asynchronously) below */
+	unionfs_copy_attr_times(inode);
 
 out:
 	return err;
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 822bffe..7ad19ec 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -41,6 +41,9 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	dget(lower_dentry);
 	if (!(err = is_robranch_super(dentry->d_sb, bindex)))
 		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	/* if vfs_unlink succeeded, update our inode's times */
+	if (!err)
+		unionfs_copy_attr_times(dentry->d_inode);
 	dput(lower_dentry);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	unlock_dir(lower_dir_dentry);
-- 
1.5.2.2.238.g7cbf2f2

