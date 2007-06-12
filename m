Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXFLXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXFLXXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbXFLXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:23:05 -0400
Received: from ns.suse.de ([195.135.220.2]:48712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXFLXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:23:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] sysfs: fix race condition around sd->s_dentry, take#2
Date: Tue, 12 Jun 2007 16:22:46 -0700
Message-Id: <1181690573359-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11816905694164-git-send-email-gregkh@suse.de>
References: <20070612232159.GA12971@suse.de>
 <11816905661989-git-send-email-gregkh@suse.de>
 <11816905694164-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Allowing attribute and symlink dentries to be reclaimed means
sd->s_dentry can change dynamically.  However, updates to the field
are unsynchronized leading to race conditions.  This patch adds
sysfs_lock and use it to synchronize updates to sd->s_dentry.

Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
validity of the dentry is protected by dcache_lock, so whether dentry
is alive or not can only be tested while holding both locks.

This is minimal backport of sysfs_drop_dentry() rewrite in devel
branch.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   22 ++++++++++++++++++++--
 fs/sysfs/inode.c |   18 +++++++++++++++++-
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 17a8191..c4342a0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -13,14 +13,26 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
+spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
 
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
 	if (sd) {
-		BUG_ON(sd->s_dentry != dentry);
-		sd->s_dentry = NULL;
+		/* sd->s_dentry is protected with sysfs_lock.  This
+		 * allows sysfs_drop_dentry() to dereference it.
+		 */
+		spin_lock(&sysfs_lock);
+
+		/* The dentry might have been deleted or another
+		 * lookup could have happened updating sd->s_dentry to
+		 * point the new dentry.  Ignore if it isn't pointing
+		 * to this dentry.
+		 */
+		if (sd->s_dentry == dentry)
+			sd->s_dentry = NULL;
+		spin_unlock(&sysfs_lock);
 		sysfs_put(sd);
 	}
 	iput(inode);
@@ -247,7 +259,10 @@ static int sysfs_attach_attr(struct sysfs_dirent * sd, struct dentry * dentry)
         }
 
 	dentry->d_fsdata = sysfs_get(sd);
+	/* protect sd->s_dentry against sysfs_d_iput */
+	spin_lock(&sysfs_lock);
 	sd->s_dentry = dentry;
+	spin_unlock(&sysfs_lock);
 	error = sysfs_create(dentry, (attr->mode & S_IALLUGO) | S_IFREG, init);
 	if (error) {
 		sysfs_put(sd);
@@ -269,7 +284,10 @@ static int sysfs_attach_link(struct sysfs_dirent * sd, struct dentry * dentry)
 	int err = 0;
 
 	dentry->d_fsdata = sysfs_get(sd);
+	/* protect sd->s_dentry against sysfs_d_iput */
+	spin_lock(&sysfs_lock);
 	sd->s_dentry = dentry;
+	spin_unlock(&sysfs_lock);
 	err = sysfs_create(dentry, S_IFLNK|S_IRWXUGO, init_symlink);
 	if (!err) {
 		dentry->d_op = &sysfs_dentry_ops;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 38bbe07..5266eec 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -246,9 +246,23 @@ static inline void orphan_all_buffers(struct inode *node)
  */
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
-	struct dentry * dentry = sd->s_dentry;
+	struct dentry *dentry = NULL;
 	struct inode *inode;
 
+	/* We're not holding a reference to ->s_dentry dentry but the
+	 * field will stay valid as long as sysfs_lock is held.
+	 */
+	spin_lock(&sysfs_lock);
+	spin_lock(&dcache_lock);
+
+	/* dget dentry if it's still alive */
+	if (sd->s_dentry && sd->s_dentry->d_inode)
+		dentry = dget_locked(sd->s_dentry);
+
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sysfs_lock);
+
+	/* drop dentry */
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
@@ -268,6 +282,8 @@ void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 		}
+
+		dput(dentry);
 	}
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 1966e1a..502c949 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -33,6 +33,7 @@ extern const unsigned char * sysfs_get_name(struct sysfs_dirent *sd);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
+extern spinlock_t sysfs_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.2.1

