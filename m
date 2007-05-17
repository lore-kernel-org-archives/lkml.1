Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbXEQR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbXEQR76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXEQR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:59:50 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:27562 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbXEQR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S9p0DAdoZddrwVh7dWrtsAz9xS4GT+G8Um2vosEbs7eZzcyWkVeiR7TMZ3NH15/9Ql7GrvTl3pU9nofVZk8Xa0WE842i/5FcvRzhqVCxkDEGXxkHrEBG6uzQC035Oohx7fLbxymMarbrEYcNoMXLOBx6oaOD9KPoAg/GQzqyFbk=
Message-ID: <464C9801.8000606@gmail.com>
Date: Thu, 17 May 2007 19:59:29 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com>
In-Reply-To: <464C95AB.3020209@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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

DONT APPLY JUST YET
---

Okay, here's minimal backport of synchronization fix.  kobj
directories are left alone.  sysfs_drop_dentry() modifications can be
made more efficient but are left that way on purpose.

 fs/sysfs/dir.c   |   29 ++++++++++++++++++++++++++---
 fs/sysfs/inode.c |   28 ++++++++++++++++++++++++----
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 51 insertions(+), 7 deletions(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
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
@@ -238,7 +250,10 @@ static int sysfs_attach_attr(struct sysf
         }
 
 	dentry->d_fsdata = sysfs_get(sd);
+	/* protect sd->s_dentry against sysfs_d_iput */
+	spin_lock(&sysfs_lock);
 	sd->s_dentry = dentry;
+	spin_unlock(&sysfs_lock);
 	error = sysfs_create(dentry, (attr->mode & S_IALLUGO) | S_IFREG, init);
 	if (error) {
 		sysfs_put(sd);
@@ -260,7 +275,10 @@ static int sysfs_attach_link(struct sysf
 	int err = 0;
 
 	dentry->d_fsdata = sysfs_get(sd);
+	/* protect sd->s_dentry against sysfs_d_iput */
+	spin_lock(&sysfs_lock);
 	sd->s_dentry = dentry;
+	spin_unlock(&sysfs_lock);
 	err = sysfs_create(dentry, S_IFLNK|S_IRWXUGO, init_symlink);
 	if (!err) {
 		dentry->d_op = &sysfs_dentry_ops;
@@ -329,6 +347,7 @@ void sysfs_remove_subdir(struct dentry *
 
 static void __sysfs_remove_dir(struct dentry *dentry)
 {
+	LIST_HEAD(removed);
 	struct sysfs_dirent * parent_sd;
 	struct sysfs_dirent * sd, * tmp;
 
@@ -342,11 +361,15 @@ static void __sysfs_remove_dir(struct de
 	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element || !(sd->s_type & SYSFS_NOT_PINNED))
 			continue;
+		list_move(&sd->s_sibling, &removed);
+	}
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	list_for_each_entry_safe(sd, tmp, &removed, s_sibling) {
 		list_del_init(&sd->s_sibling);
 		sysfs_drop_dentry(sd, dentry);
 		sysfs_put(sd);
 	}
-	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	remove_dir(dentry);
 	/**
Index: work/fs/sysfs/inode.c
===================================================================
--- work.orig/fs/sysfs/inode.c
+++ work/fs/sysfs/inode.c
@@ -244,9 +244,23 @@ static inline void orphan_all_buffers(st
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
@@ -266,6 +280,8 @@ void sysfs_drop_dentry(struct sysfs_dire
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 		}
+
+		dput(dentry);
 	}
 }
 
@@ -289,13 +305,17 @@ int sysfs_hash_and_remove(struct dentry 
 			continue;
 		if (!strcmp(sysfs_get_name(sd), name)) {
 			list_del_init(&sd->s_sibling);
-			sysfs_drop_dentry(sd, dir);
-			sysfs_put(sd);
 			found = 1;
 			break;
 		}
 	}
 	mutex_unlock(&dir->d_inode->i_mutex);
 
-	return found ? 0 : -ENOENT;
+	if (!found)
+		return -ENOENT;
+
+	sysfs_drop_dentry(sd, dir);
+	sysfs_put(sd);
+
+	return 0;
 }
Index: work/fs/sysfs/sysfs.h
===================================================================
--- work.orig/fs/sysfs/sysfs.h
+++ work/fs/sysfs/sysfs.h
@@ -32,6 +32,7 @@ extern const unsigned char * sysfs_get_n
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
+extern spinlock_t sysfs_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
