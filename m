Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXFMTaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXFMTaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXFMT1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:27:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:18033 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXFMT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=gGPZdRz/ui5EmWOPvo+V/XKeLUHDhv7S7twozyNXzoSNdFgdf+LBR6uWJjdSccdXLiZGXZt71Q8tTWrc7ufR/HFCjlmPilOY9w+K+eAhnJUWwd7nL+EjLOtyZqmKTMIUsKZvCvshQsjjv7IDdjQglzxpbyvDyJKlp30kT9INONg=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/11] sysfs: move sysfs_drop_dentry() to dir.c and make it static
In-Reply-To: <1181762840495-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 14 Jun 2007 04:27:24 +0900
Message-Id: <11817628444043-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: greg@kroah.com, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After add/remove path restructuring, the only user of
sysfs_drop_dentry() is sysfs_addrm_finish().  Move sysfs_drop_dentry()
to dir.c and make it static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/inode.c |   56 ------------------------------------------------------
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index dce74ef..c141391 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -435,6 +435,62 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
+ *	@sd: target sysfs_dirent
+ *
+ *	Drop dentry for @sd.  @sd must have been unlinked from its
+ *	parent on entry to this function such that it can't be looked
+ *	up anymore.
+ *
+ *	@sd->s_dentry which is protected with sysfs_assoc_lock points
+ *	to the currently associated dentry but we're not holding a
+ *	reference to it and racing with dput().  Grab dcache_lock and
+ *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
+ *	dput() beats us, no need to bother.
+ */
+static void sysfs_drop_dentry(struct sysfs_dirent *sd)
+{
+	struct dentry *dentry = NULL;
+	struct inode *inode;
+
+	/* We're not holding a reference to ->s_dentry dentry but the
+	 * field will stay valid as long as sysfs_assoc_lock is held.
+	 */
+	spin_lock(&sysfs_assoc_lock);
+	spin_lock(&dcache_lock);
+
+	/* drop dentry if it's there and dput() didn't kill it yet */
+	if (sd->s_dentry && sd->s_dentry->d_inode) {
+		dentry = dget_locked(sd->s_dentry);
+		spin_lock(&dentry->d_lock);
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
+	}
+
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sysfs_assoc_lock);
+
+	dput(dentry);
+	/* XXX: unpin if directory, this will go away soon */
+	if (sysfs_type(sd) == SYSFS_DIR)
+		dput(dentry);
+
+	/* adjust nlink and update timestamp */
+	inode = ilookup(sysfs_sb, sd->s_ino);
+	if (inode) {
+		mutex_lock(&inode->i_mutex);
+
+		inode->i_ctime = CURRENT_TIME;
+		drop_nlink(inode);
+		if (sysfs_type(sd) == SYSFS_DIR)
+			drop_nlink(inode);
+
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
+	}
+}
+
+/**
  *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
  *	@acxt: addrm context to finish up
  *
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index f959668..3756e15 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -197,62 +197,6 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 	d_instantiate(dentry, inode);
 }
 
-/**
- *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
- *	@sd: target sysfs_dirent
- *
- *	Drop dentry for @sd.  @sd must have been unlinked from its
- *	parent on entry to this function such that it can't be looked
- *	up anymore.
- *
- *	@sd->s_dentry which is protected with sysfs_assoc_lock points
- *	to the currently associated dentry but we're not holding a
- *	reference to it and racing with dput().  Grab dcache_lock and
- *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
- *	dput() beats us, no need to bother.
- */
-void sysfs_drop_dentry(struct sysfs_dirent *sd)
-{
-	struct dentry *dentry = NULL;
-	struct inode *inode;
-
-	/* We're not holding a reference to ->s_dentry dentry but the
-	 * field will stay valid as long as sysfs_assoc_lock is held.
-	 */
-	spin_lock(&sysfs_assoc_lock);
-	spin_lock(&dcache_lock);
-
-	/* drop dentry if it's there and dput() didn't kill it yet */
-	if (sd->s_dentry && sd->s_dentry->d_inode) {
-		dentry = dget_locked(sd->s_dentry);
-		spin_lock(&dentry->d_lock);
-		__d_drop(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
-
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_assoc_lock);
-
-	dput(dentry);
-	/* XXX: unpin if directory, this will go away soon */
-	if (sysfs_type(sd) == SYSFS_DIR)
-		dput(dentry);
-
-	/* adjust nlink and update timestamp */
-	inode = ilookup(sysfs_sb, sd->s_ino);
-	if (inode) {
-		mutex_lock(&inode->i_mutex);
-
-		inode->i_ctime = CURRENT_TIME;
-		drop_nlink(inode);
-		if (sysfs_type(sd) == SYSFS_DIR)
-			drop_nlink(inode);
-
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
-}
-
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3e9a5ee..92fe1e5 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -90,7 +90,6 @@ extern int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			       struct sysfs_dirent **p_sd);
 extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_assoc_lock;
-- 
1.5.0.3


