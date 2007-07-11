Return-Path: <linux-kernel-owner+w=401wt.eu-S936852AbXGKX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936852AbXGKX7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935233AbXGKXhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:34054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935220AbXGKXhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/61] sysfs: consolidate sysfs spinlocks
Date: Wed, 11 Jul 2007 16:32:14 -0700
Message-Id: <11841970013184-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196995958-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Replace sysfs_lock and kobj_sysfs_assoc_lock with sysfs_assoc_lock.
sysfs_lock was originally to be used to protect sysfs_dirent tree but
mutex seems better choice, so there is no reason to keep sysfs_lock
separate.  Merge the two spinlocks into one.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   19 +++++++++----------
 fs/sysfs/inode.c   |   16 ++++++++--------
 fs/sysfs/symlink.c |    6 +++---
 fs/sysfs/sysfs.h   |    3 +--
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 31b6cf3..1b56434 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,8 +15,7 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
-spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
-spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
+spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
@@ -236,10 +235,10 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
 	if (sd) {
-		/* sd->s_dentry is protected with sysfs_lock.  This
-		 * allows sysfs_drop_dentry() to dereference it.
+		/* sd->s_dentry is protected with sysfs_assoc_lock.
+		 * This allows sysfs_drop_dentry() to dereference it.
 		 */
-		spin_lock(&sysfs_lock);
+		spin_lock(&sysfs_assoc_lock);
 
 		/* The dentry might have been deleted or another
 		 * lookup could have happened updating sd->s_dentry to
@@ -248,7 +247,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 		 */
 		if (sd->s_dentry == dentry)
 			sd->s_dentry = NULL;
-		spin_unlock(&sysfs_lock);
+		spin_unlock(&sysfs_assoc_lock);
 		sysfs_put(sd);
 	}
 	iput(inode);
@@ -298,9 +297,9 @@ static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
 	dentry->d_fsdata = sysfs_get(sd);
 
 	/* protect sd->s_dentry against sysfs_d_iput */
-	spin_lock(&sysfs_lock);
+	spin_lock(&sysfs_assoc_lock);
 	sd->s_dentry = dentry;
-	spin_unlock(&sysfs_lock);
+	spin_unlock(&sysfs_assoc_lock);
 
 	d_rehash(dentry);
 }
@@ -603,9 +602,9 @@ void sysfs_remove_dir(struct kobject * kobj)
 {
 	struct sysfs_dirent *sd = kobj->sd;
 
-	spin_lock(&kobj_sysfs_assoc_lock);
+	spin_lock(&sysfs_assoc_lock);
 	kobj->sd = NULL;
-	spin_unlock(&kobj_sysfs_assoc_lock);
+	spin_unlock(&sysfs_assoc_lock);
 
 	__sysfs_remove_dir(sd);
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 1be8537..e4c2393 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -211,11 +211,11 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
  *	parent on entry to this function such that it can't be looked
  *	up anymore.
  *
- *	@sd->s_dentry which is protected with sysfs_lock points to the
- *	currently associated dentry but we're not holding a reference
- *	to it and racing with dput().  Grab dcache_lock and verify
- *	dentry before dropping it.  If @sd->s_dentry is NULL or dput()
- *	beats us, no need to bother.
+ *	@sd->s_dentry which is protected with sysfs_assoc_lock points
+ *	to the currently associated dentry but we're not holding a
+ *	reference to it and racing with dput().  Grab dcache_lock and
+ *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
+ *	dput() beats us, no need to bother.
  */
 void sysfs_drop_dentry(struct sysfs_dirent *sd)
 {
@@ -224,9 +224,9 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	struct inode *inode;
 
 	/* We're not holding a reference to ->s_dentry dentry but the
-	 * field will stay valid as long as sysfs_lock is held.
+	 * field will stay valid as long as sysfs_assoc_lock is held.
 	 */
-	spin_lock(&sysfs_lock);
+	spin_lock(&sysfs_assoc_lock);
 	spin_lock(&dcache_lock);
 
 	/* drop dentry if it's there and dput() didn't kill it yet */
@@ -238,7 +238,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	}
 
 	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_lock);
+	spin_unlock(&sysfs_assoc_lock);
 
 	dput(dentry);
 	/* XXX: unpin if directory, this will go away soon */
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 43cc522..cbd95a4 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -82,12 +82,12 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		return -EFAULT;
 
 	/* target->sd can go away beneath us but is protected with
-	 * kobj_sysfs_assoc_lock.  Fetch target_sd from it.
+	 * sysfs_assoc_lock.  Fetch target_sd from it.
 	 */
-	spin_lock(&kobj_sysfs_assoc_lock);
+	spin_lock(&sysfs_assoc_lock);
 	if (target->sd)
 		target_sd = sysfs_get(target->sd);
-	spin_unlock(&kobj_sysfs_assoc_lock);
+	spin_unlock(&sysfs_assoc_lock);
 
 	if (!target_sd)
 		return -ENOENT;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 27a5f4b..4572677 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -81,8 +81,7 @@ extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
-extern spinlock_t sysfs_lock;
-extern spinlock_t kobj_sysfs_assoc_lock;
+extern spinlock_t sysfs_assoc_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.2.2

