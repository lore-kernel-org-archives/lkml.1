Return-Path: <linux-kernel-owner+w=401wt.eu-S936155AbXGKXup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936155AbXGKXup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935187AbXGKXfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935195AbXGKXfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/61] sysfs: reimplement sysfs_drop_dentry()
Date: Wed, 11 Jul 2007 16:31:57 -0700
Message-Id: <11841969142368-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969101299-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

This patch reimplements sysfs_drop_dentry() such that remove_dir() can
use it to drop dentry instead of using a separate mechanism.  With
this change, making directories reclaimable is much easier.

This patch used to contain fixes for two race conditions around
sd->s_dentry but that part has been separated out and included into
mainline early as commit 6aa054aadfea613a437ad0b15d38eca2b963fc0a and
dd14cbc994709a1c5a64ed3621f583c49a27e521.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   18 +++--------
 fs/sysfs/inode.c |   82 ++++++++++++++++++++++++++++++++++++++++--------------
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 01eeb4b..bc11a26 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -372,22 +372,19 @@ const struct inode_operations sysfs_dir_inode_operations = {
 
 static void remove_dir(struct dentry * d)
 {
-	struct dentry * parent = dget(d->d_parent);
-	struct sysfs_dirent * sd;
+	struct dentry *parent = d->d_parent;
+	struct sysfs_dirent *sd = d->d_fsdata;
 
 	mutex_lock(&parent->d_inode->i_mutex);
-	d_delete(d);
-	sd = d->d_fsdata;
+
  	list_del_init(&sd->s_sibling);
-	if (d->d_inode)
-		simple_rmdir(parent->d_inode,d);
 
 	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
 		 atomic_read(&d->d_count));
 
 	mutex_unlock(&parent->d_inode->i_mutex);
-	dput(parent);
 
+	sysfs_drop_dentry(sd);
 	sysfs_deactivate(sd);
 	sysfs_put(sd);
 }
@@ -404,7 +401,6 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 	struct sysfs_dirent * parent_sd;
 	struct sysfs_dirent * sd, * tmp;
 
-	dget(dentry);
 	if (!dentry)
 		return;
 
@@ -415,21 +411,17 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 		if (!sd->s_type || !(sd->s_type & SYSFS_NOT_PINNED))
 			continue;
 		list_move(&sd->s_sibling, &removed);
-		sysfs_drop_dentry(sd, dentry);
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	list_for_each_entry_safe(sd, tmp, &removed, s_sibling) {
 		list_del_init(&sd->s_sibling);
+		sysfs_drop_dentry(sd);
 		sysfs_deactivate(sd);
 		sysfs_put(sd);
 	}
 
 	remove_dir(dentry);
-	/**
-	 * Drop reference from dget() on entrance.
-	 */
-	dput(dentry);
 }
 
 /**
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 88857a3..6ad47c1 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -191,13 +191,25 @@ int sysfs_create(struct sysfs_dirent *sd, struct dentry *dentry, int mode,
 	return error;
 }
 
-/*
- * Unhashes the dentry corresponding to given sysfs_dirent
- * Called with parent inode's i_mutex held.
+/**
+ *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
+ *	@sd: target sysfs_dirent
+ *
+ *	Drop dentry for @sd.  @sd must have been unlinked from its
+ *	parent on entry to this function such that it can't be looked
+ *	up anymore.
+ *
+ *	@sd->s_dentry which is protected with sysfs_lock points to the
+ *	currently associated dentry but we're not holding a reference
+ *	to it and racing with dput().  Grab dcache_lock and verify
+ *	dentry before dropping it.  If @sd->s_dentry is NULL or dput()
+ *	beats us, no need to bother.
  */
-void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
+void sysfs_drop_dentry(struct sysfs_dirent *sd)
 {
-	struct dentry *dentry = NULL;
+	struct dentry *dentry = NULL, *parent = NULL;
+	struct inode *dir;
+	struct timespec curtime;
 
 	/* We're not holding a reference to ->s_dentry dentry but the
 	 * field will stay valid as long as sysfs_lock is held.
@@ -205,30 +217,57 @@ void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 	spin_lock(&sysfs_lock);
 	spin_lock(&dcache_lock);
 
-	/* dget dentry if it's still alive */
-	if (sd->s_dentry && sd->s_dentry->d_inode)
+	if (sd->s_dentry && sd->s_dentry->d_inode) {
+		/* get dentry if it's there and dput() didn't kill it yet */
 		dentry = dget_locked(sd->s_dentry);
+		parent = dentry->d_parent;
+	} else if (sd->s_parent->s_dentry->d_inode) {
+		/* We need to update the parent even if dentry for the
+		 * victim itself doesn't exist.
+		 */
+		parent = dget_locked(sd->s_parent->s_dentry);
+	}
+
+	/* drop */
+	if (dentry) {
+		spin_lock(&dentry->d_lock);
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
+	}
 
 	spin_unlock(&dcache_lock);
 	spin_unlock(&sysfs_lock);
 
-	/* drop dentry */
+	/* nothing to do if the parent isn't in dcache */
+	if (!parent)
+		return;
+
+	/* adjust nlink and update timestamp */
+	dir = parent->d_inode;
+	mutex_lock(&dir->i_mutex);
+
+	curtime = CURRENT_TIME;
+
+	dir->i_ctime = dir->i_mtime = curtime;
+
 	if (dentry) {
-		spin_lock(&dcache_lock);
-		spin_lock(&dentry->d_lock);
-		if (!d_unhashed(dentry) && dentry->d_inode) {
-			dget_locked(dentry);
-			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
-			simple_unlink(parent->d_inode, dentry);
-		} else {
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+		dentry->d_inode->i_ctime = curtime;
+		drop_nlink(dentry->d_inode);
+		if (sd->s_type & SYSFS_DIR) {
+			drop_nlink(dentry->d_inode);
+			drop_nlink(dir);
+			/* XXX: unpin if directory, this will go away soon */
+			dput(dentry);
 		}
+	}
+
+	mutex_unlock(&dir->i_mutex);
 
+	/* bye bye */
+	if (dentry)
 		dput(dentry);
-	}
+	else
+		dput(parent);
 }
 
 int sysfs_hash_and_remove(struct dentry * dir, const char * name)
@@ -251,7 +290,6 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 			continue;
 		if (!strcmp(sd->s_name, name)) {
 			list_del_init(&sd->s_sibling);
-			sysfs_drop_dentry(sd, dir);
 			found = 1;
 			break;
 		}
@@ -261,7 +299,9 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 	if (!found)
 		return -ENOENT;
 
+	sysfs_drop_dentry(sd);
 	sysfs_deactivate(sd);
 	sysfs_put(sd);
+
 	return 0;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9fa77d6..fc6aa86 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -76,7 +76,7 @@ extern struct sysfs_dirent *sysfs_find(struct sysfs_dirent *dir, const char * na
 extern int sysfs_create_subdir(struct kobject *, const char *, struct dentry **);
 extern void sysfs_remove_subdir(struct dentry *);
 
-extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
+extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_lock;
-- 
1.5.2.2

