Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbXE1Qim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbXE1Qim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXE1Qgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:36:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:54608 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXE1Qgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=c5uer1igCfUO8NtRHIdiKXLLynXHP8ZiTNXoaINYL89H2oSdBSGunxKm3fKSRUD3FGMMiFkSGRJO0T37Wwl9tGaSFy5XNd/A9/HZo4VtoRHnLJJYpTRcv3fY5Oz7fGGbNG9QBUuDw1msAqP+Lp3uW+4gRcl7UohRWZ7nUlD/YMI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/6] sysfs: implement sysfs_get_dentry()
In-Reply-To: <11803701861778-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:36:27 +0900
Message-Id: <11803701871702-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some sysfs operations require dentry and inode.  sysfs_get_dentry()
looks up and gets dentry for the specified sysfs_dirent.  It finds the
first ancestor with dentry attached and starts looking up dentries
from there.

Looking up from the nearest ancestor is necessary to support shadowed
directories because we can't reliably lookup dentry for one of the
shadows.  Dentries for each shadow will be pinned in memory such that
they can serve as the starting point for dentry lookup.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a474e54..0242cbd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -63,6 +63,98 @@ static void sysfs_unlink_sibling(struct
 }
 
 /**
+ *	sysfs_get_dentry - get dentry for the given sysfs_dirent
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Get dentry for @sd.  Dentry is looked up if currently not
+ *	present.  This function climbs sysfs_dirent tree till it
+ *	reaches a sysfs_dirent with valid dentry attached and descends
+ *	down from there looking up dentry for each step.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to found dentry on success, ERR_PTR() value on error.
+ */
+struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *cur;
+	struct dentry *parent_dentry, *dentry;
+	int i, depth;
+
+	/* Find the first parent which has valid s_dentry and get the
+	 * dentry.
+	 */
+	spin_lock(&sysfs_lock);
+ restart:
+	spin_lock(&dcache_lock);
+
+	dentry = NULL;
+	depth = 0;
+	cur = sd;
+	while (!cur->s_dentry || !cur->s_dentry->d_inode) {
+		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
+			dentry = ERR_PTR(-ENOENT);
+			depth = 0;
+			break;
+		}
+		cur = cur->s_parent;
+		depth++;
+	}
+	if (!IS_ERR(dentry))
+		dentry = dget_locked(cur->s_dentry);
+
+	spin_unlock(&dcache_lock);
+
+	/* from the found dentry, look up depth times */
+	while (depth--) {
+		/* find and get depth'th ancestor */
+		for (cur = sd, i = 0; cur && i < depth; i++)
+			cur = cur->s_parent;
+
+		/* This can happen if tree structure was modified due
+		 * to move/rename.  Restart.
+		 */
+		if (i != depth) {
+			dput(dentry);
+			goto restart;
+		}
+
+		sysfs_get(cur);
+
+		spin_unlock(&sysfs_lock);
+
+		/* look it up */
+		parent_dentry = dentry;
+		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
+					     strlen(cur->s_name));
+		dput(parent_dentry);
+
+		if (IS_ERR(dentry)) {
+			sysfs_put(cur);
+			return dentry;
+		}
+
+		spin_lock(&sysfs_lock);
+
+		/* This, again, can happen if tree structure has
+		 * changed and we looked up the wrong thing.  Restart.
+		 */
+		if (cur->s_dentry != dentry) {
+			dput(dentry);
+			sysfs_put(cur);
+			goto restart;
+		}
+
+		sysfs_put(cur);
+	}
+
+	spin_unlock(&sysfs_lock);
+	return dentry;
+}
+
+/**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
  *
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 476d58b..b11c448 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -47,6 +47,7 @@ struct sysfs_dirent {
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
+extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 extern void sysfs_put_active(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
-- 
1.4.3.4


