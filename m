Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbXJLWpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbXJLWpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932683AbXJLWVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:49871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXJLWVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/75] sysfs: Rewrite sysfs_drop_dentry.
Date: Fri, 12 Oct 2007 15:16:49 -0700
Message-Id: <1192227653165-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276471365-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently we find the dentry to drop by looking at sd->s_dentry.
We can just as easily accomplish the same task by looking up the
sysfs inode and finding all of the dentries from there, with the
added bonus that we don't need to play with the sysfs_assoc_lock.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   53 ++++++++++++++++++++++++++---------------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 953e843..1af963e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -565,50 +565,49 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  *	Drop dentry for @sd.  @sd must have been unlinked from its
  *	parent on entry to this function such that it can't be looked
  *	up anymore.
- *
- *	@sd->s_dentry which is protected with sysfs_assoc_lock points
- *	to the currently associated dentry but we're not holding a
- *	reference to it and racing with dput().  Grab dcache_lock and
- *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
- *	dput() beats us, no need to bother.
  */
 static void sysfs_drop_dentry(struct sysfs_dirent *sd)
 {
-	struct dentry *dentry = NULL;
 	struct inode *inode;
+	struct dentry *dentry;
+
+	inode = ilookup(sysfs_sb, sd->s_ino);
+	if (!inode)
+		return;
 
-	/* We're not holding a reference to ->s_dentry dentry but the
-	 * field will stay valid as long as sysfs_assoc_lock is held.
+	/* Drop any existing dentries associated with sd.
+	 *
+	 * For the dentry to be properly freed we need to grab a
+	 * reference to the dentry under the dcache lock,  unhash it,
+	 * and then put it.  The playing with the dentry count allows
+	 * dput to immediately free the dentry  if it is not in use.
 	 */
-	spin_lock(&sysfs_assoc_lock);
+repeat:
 	spin_lock(&dcache_lock);
-
-	/* drop dentry if it's there and dput() didn't kill it yet */
-	if (sd->s_dentry && sd->s_dentry->d_inode) {
-		dentry = dget_locked(sd->s_dentry);
+	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+		if (d_unhashed(dentry))
+			continue;
+		dget_locked(dentry);
 		spin_lock(&dentry->d_lock);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		dput(dentry);
+		goto repeat;
 	}
-
 	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_assoc_lock);
-
-	dput(dentry);
 
 	/* adjust nlink and update timestamp */
-	inode = ilookup(sysfs_sb, sd->s_ino);
-	if (inode) {
-		mutex_lock(&inode->i_mutex);
+	mutex_lock(&inode->i_mutex);
 
-		inode->i_ctime = CURRENT_TIME;
+	inode->i_ctime = CURRENT_TIME;
+	drop_nlink(inode);
+	if (sysfs_type(sd) == SYSFS_DIR)
 		drop_nlink(inode);
-		if (sysfs_type(sd) == SYSFS_DIR)
-			drop_nlink(inode);
 
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
+	mutex_unlock(&inode->i_mutex);
+
+	iput(inode);
 }
 
 /**
-- 
1.5.3.4

