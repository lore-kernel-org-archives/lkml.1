Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXFMT2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXFMT2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbXFMT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:27:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61081 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXFMT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=k35UZJSzlg7x7MI+YgjlvPASVFM8evMhVFyZpgCYZyZ3gBPF2YVjQjaeLe7JTWO/wjIhaeCCqw6PmCJe9sp6y2CN8YJY8ysxOm9yiLFikF/FBOY4qdZj/n/hzbgEiJsgvD853NtfMeQ1o2q0LKsQ5gqtnO4RQjDh5GdaNOcVXg0=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/11] sysfs: make sysfs_drop_dentry() access inodes using ilookup()
In-Reply-To: <1181762840495-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 14 Jun 2007 04:27:21 +0900
Message-Id: <11817628414141-git-send-email-htejun@gmail.com>
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

sysfs_drop_dentry() used to go through sd->s_dentry and
sd->s_parent->s_dentry to access the inodes.  This is incorrect
because inode can be cached without dentry.

This patch makes sysfs_drop_dentry() access inodes using ilookup() on
sd->s_ino.  This is both correct and simpler.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/inode.c |   63 ++++++++++++++++++++++++------------------------------
 1 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index ee31bf3..63daa06 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -219,9 +219,9 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
  */
 void sysfs_drop_dentry(struct sysfs_dirent *sd)
 {
-	struct dentry *dentry = NULL, *parent = NULL;
-	struct inode *dir;
+	struct dentry *dentry = NULL;
 	struct timespec curtime;
+	struct inode *inode;
 
 	/* We're not holding a reference to ->s_dentry dentry but the
 	 * field will stay valid as long as sysfs_lock is held.
@@ -229,19 +229,9 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	spin_lock(&sysfs_lock);
 	spin_lock(&dcache_lock);
 
+	/* drop dentry if it's there and dput() didn't kill it yet */
 	if (sd->s_dentry && sd->s_dentry->d_inode) {
-		/* get dentry if it's there and dput() didn't kill it yet */
 		dentry = dget_locked(sd->s_dentry);
-		parent = dentry->d_parent;
-	} else if (sd->s_parent->s_dentry->d_inode) {
-		/* We need to update the parent even if dentry for the
-		 * victim itself doesn't exist.
-		 */
-		parent = dget_locked(sd->s_parent->s_dentry);
-	}
-
-	/* drop */
-	if (dentry) {
 		spin_lock(&dentry->d_lock);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
@@ -250,36 +240,39 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	spin_unlock(&dcache_lock);
 	spin_unlock(&sysfs_lock);
 
-	/* nothing to do if the parent isn't in dcache */
-	if (!parent)
-		return;
+	dput(dentry);
+	/* XXX: unpin if directory, this will go away soon */
+	if (sd->s_type & SYSFS_DIR)
+		dput(dentry);
 
 	/* adjust nlink and update timestamp */
-	dir = parent->d_inode;
-	mutex_lock(&dir->i_mutex);
-
 	curtime = CURRENT_TIME;
 
-	dir->i_ctime = dir->i_mtime = curtime;
+	inode = ilookup(sysfs_sb, sd->s_ino);
+	if (inode) {
+		mutex_lock(&inode->i_mutex);
 
-	if (dentry) {
-		dentry->d_inode->i_ctime = curtime;
-		drop_nlink(dentry->d_inode);
-		if (sd->s_type & SYSFS_DIR) {
-			drop_nlink(dentry->d_inode);
-			drop_nlink(dir);
-			/* XXX: unpin if directory, this will go away soon */
-			dput(dentry);
-		}
+		inode->i_ctime = curtime;
+		drop_nlink(inode);
+		if (sd->s_type & SYSFS_DIR)
+			drop_nlink(inode);
+
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
 	}
 
-	mutex_unlock(&dir->i_mutex);
+	/* adjust nlink and udpate timestamp of the parent */
+	inode = ilookup(sysfs_sb, sd->s_parent->s_ino);
+	if (inode) {
+		mutex_lock(&inode->i_mutex);
 
-	/* bye bye */
-	if (dentry)
-		dput(dentry);
-	else
-		dput(parent);
+		inode->i_ctime = inode->i_mtime = curtime;
+		if (sd->s_type & SYSFS_DIR)
+			drop_nlink(inode);
+
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
+	}
 }
 
 int sysfs_hash_and_remove(struct dentry * dir, const char * name)
-- 
1.5.0.3


