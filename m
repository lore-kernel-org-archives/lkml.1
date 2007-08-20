Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXHTMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXHTMi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXHTMhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:37:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:33092 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbXHTMgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=rYTIwJtpF3vcTskYcMDZH+p2MP0FhU88MirohmywLnxxm/q/ZpGgxP9ikKujAakpG/EeHMFkGbGlZJtgEx7sjB7qHa+nPceMBG7sCjld7Az8mPUBuHm7KooB8I0bFBLZQmGZXfbKSWFZawbXOlusdREC2qlT3RxEtPjRfYerYu4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 10/14] sysfs: simply sysfs_get_dentry
In-Reply-To: <11876133893720-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 20 Aug 2007 21:36:30 +0900
Message-Id: <11876133903396-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, containers@lists.osdl.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we know the sysfs tree structure cannot change under us and
sysfs shadow support is dropped, sysfs_get_dentry() can be simplified
greatly.  It can just look up from the root and there's no need to
retry on failure.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   91 ++++++++++----------------------------------------------
 1 files changed, 16 insertions(+), 75 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 740d88e..aee24e9 100644
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
1.5.0.3


