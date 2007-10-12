Return-Path: <linux-kernel-owner+w=401wt.eu-S934254AbXJLWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254AbXJLWqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932607AbXJLWVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:21 -0400
Received: from mail.suse.de ([195.135.220.2]:53424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbXJLWVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/75] sysfs: simply sysfs_get_dentry
Date: Fri, 12 Oct 2007 15:16:51 -0700
Message-Id: <11922276622731-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276572176-git-send-email-gregkh@suse.de>
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
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Now that we know the sysfs tree structure cannot change under us and
sysfs shadow support is dropped, sysfs_get_dentry() can be simplified
greatly.  It can just look up from the root and there's no need to
retry on failure.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   91 ++++++++++----------------------------------------------
 1 files changed, 16 insertions(+), 75 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 9fe83d2..1c3dc5d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -78,9 +78,8 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  *	@sd: sysfs_dirent of interest
  *
  *	Get dentry for @sd.  Dentry is looked up if currently not
- *	present.  This function climbs sysfs_dirent tree till it
- *	reaches a sysfs_dirent with valid dentry attached and descends
- *	down from there looking up dentry for each step.
+ *	present.  This function descends from the root looking up
+ *	dentry for each step.
  *
  *	LOCKING:
  *	mutex_lock(sysfs_rename_mutex)
@@ -90,86 +89,28 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  */
 struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent *cur;
-	struct dentry *parent_dentry, *dentry;
-	int i, depth;
+	struct dentry *dentry = dget(sysfs_sb->s_root);
 
-	/* Find the first parent which has valid s_dentry and get the
-	 * dentry.
-	 */
-	mutex_lock(&sysfs_mutex);
- restart0:
-	spin_lock(&sysfs_assoc_lock);
- restart1:
-	spin_lock(&dcache_lock);
-
-	dentry = NULL;
-	depth = 0;
-	cur = sd;
-	while (!cur->s_dentry || !cur->s_dentry->d_inode) {
-		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
-			dentry = ERR_PTR(-ENOENT);
-			depth = 0;
-			break;
-		}
-		cur = cur->s_parent;
-		depth++;
-	}
-	if (!IS_ERR(dentry))
-		dentry = dget_locked(cur->s_dentry);
+	while (dentry->d_fsdata != sd) {
+		struct sysfs_dirent *cur;
+		struct dentry *parent;
 
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_assoc_lock);
-
-	/* from the found dentry, look up depth times */
-	while (depth--) {
-		/* find and get depth'th ancestor */
-		for (cur = sd, i = 0; cur && i < depth; i++)
+		/* find the first ancestor which hasn't been looked up */
+		cur = sd;
+		while (cur->s_parent != dentry->d_fsdata)
 			cur = cur->s_parent;
 
-		/* This can happen if tree structure was modified due
-		 * to move/rename.  Restart.
-		 */
-		if (i != depth) {
-			dput(dentry);
-			goto restart0;
-		}
-
-		sysfs_get(cur);
-
-		mutex_unlock(&sysfs_mutex);
-
 		/* look it up */
-		parent_dentry = dentry;
-		mutex_lock(&parent_dentry->d_inode->i_mutex);
-		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
+		parent = dentry;
+		mutex_lock(&parent->d_inode->i_mutex);
+		dentry = lookup_one_len_kern(cur->s_name, parent,
 					     strlen(cur->s_name));
-		mutex_unlock(&parent_dentry->d_inode->i_mutex);
-		dput(parent_dentry);
-
-		if (IS_ERR(dentry)) {
-			sysfs_put(cur);
-			return dentry;
-		}
+		mutex_unlock(&parent->d_inode->i_mutex);
+		dput(parent);
 
-		mutex_lock(&sysfs_mutex);
-		spin_lock(&sysfs_assoc_lock);
-
-		/* This, again, can happen if tree structure has
-		 * changed and we looked up the wrong thing.  Restart.
-		 */
-		if (cur->s_dentry != dentry) {
-			dput(dentry);
-			sysfs_put(cur);
-			goto restart1;
-		}
-
-		spin_unlock(&sysfs_assoc_lock);
-
-		sysfs_put(cur);
+		if (IS_ERR(dentry))
+			break;
 	}
-
-	mutex_unlock(&sysfs_mutex);
 	return dentry;
 }
 
-- 
1.5.3.4

