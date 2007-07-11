Return-Path: <linux-kernel-owner+w=401wt.eu-S936515AbXGKX5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936515AbXGKX5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935276AbXGKXgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:34020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935270AbXGKXgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/61] sysfs: make sysfs_drop_dentry() access inodes using ilookup()
Date: Wed, 11 Jul 2007 16:32:09 -0700
Message-Id: <11841969771935-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969731234-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs_drop_dentry() used to go through sd->s_dentry and
sd->s_parent->s_dentry to access the inodes.  This is incorrect
because inode can be cached without dentry.

This patch makes sysfs_drop_dentry() access inodes using ilookup() on
sd->s_ino.  This is both correct and simpler.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.5.2.2

