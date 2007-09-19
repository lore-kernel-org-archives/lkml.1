Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXISV07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXISV07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbXISVZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52807 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbXISVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:03 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 5/6] Unionfs: unionfs_lookup locking consistency
Date: Wed, 19 Sep 2007 17:24:39 -0400
Message-Id: <11902370832415-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that our lookup locking is consistent and symmetric: if a lock
existed before calling lookup_backend, it should remain so; only if
performing a lookup of a known new dentry, should lookup_backend return a
newly-locked dentry-inode info (and only if there was no error).  Document
this behavior.  This cleanup allowed us to remove two unnecessary int
declarations.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/inode.c  |    6 +++++-
 fs/unionfs/lookup.c |   38 +++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 687b9a7..9638b64 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -163,7 +163,10 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 		path_save.mnt = nd->mnt;
 	}
 
-	/* The locking is done by unionfs_lookup_backend. */
+	/*
+	 * unionfs_lookup_backend returns a locked dentry upon success,
+	 * so we'll have to unlock it below.
+	 */
 	ret = unionfs_lookup_backend(dentry, nd, INTERPOSE_LOOKUP);
 
 	/* restore the dentry & vfsmnt in namei */
@@ -176,6 +179,7 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 			dentry = ret;
 		/* parent times may have changed */
 		unionfs_copy_attr_times(dentry->d_parent->d_inode);
+		unionfs_unlock_dentry(dentry);
 	}
 
 	unionfs_check_inode(parent);
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 7fa6310..8eb9749 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -77,6 +77,11 @@ out:
  *
  * Returns: NULL (ok), ERR_PTR if an error occurred, or a non-null non-error
  * PTR if d_splice returned a different dentry.
+ *
+ * If lookupmode is INTERPOSE_PARTIAL/REVAL/REVAL_NEG, the passed dentry's
+ * inode info must be locked.  If lookupmode is INTERPOSE_LOOKUP (i.e., a
+ * newly looked-up dentry), then unionfs_lookup_backend will return a locked
+ * dentry's info, which the caller must unlock.
  */
 struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 				      struct nameidata *nd, int lookupmode)
@@ -94,8 +99,6 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	struct dentry *first_lower_dentry = NULL;
 	struct vfsmount *first_lower_mnt = NULL;
 	int locked_parent = 0;
-	int locked_child = 0;
-	int allocated_new_info = 0;
 	int opaque;
 	char *whname = NULL;
 	const char *name;
@@ -109,24 +112,21 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	if (lookupmode == INTERPOSE_PARTIAL || lookupmode == INTERPOSE_REVAL ||
 	    lookupmode == INTERPOSE_REVAL_NEG)
 		verify_locked(dentry);
-	else {
+	else			/* this could only be INTERPOSE_LOOKUP */
 		BUG_ON(UNIONFS_D(dentry) != NULL);
-		locked_child = 1;
-	}
 
-	switch(lookupmode) {
-		case INTERPOSE_PARTIAL:
-			break;
-		case INTERPOSE_LOOKUP:
-			if ((err = new_dentry_private_data(dentry)))
-				goto out;
-			allocated_new_info = 1;
-			break;
-		default:
-			if ((err = realloc_dentry_private_data(dentry)))
-				goto out;
-			allocated_new_info = 1;
-			break;
+	switch (lookupmode) {
+	case INTERPOSE_PARTIAL:
+		break;
+	case INTERPOSE_LOOKUP:
+		if ((err = new_dentry_private_data(dentry)))
+			goto out;
+		break;
+	default:
+		/* default: can only be INTERPOSE_REVAL/REVAL_NEG */
+		if ((err = realloc_dentry_private_data(dentry)))
+			goto out;
+		break;
 	}
 
 	/* must initialize dentry operations */
@@ -419,7 +419,7 @@ out:
 	if (locked_parent)
 		unionfs_unlock_dentry(parent_dentry);
 	dput(parent_dentry);
-	if (locked_child || (err && allocated_new_info))
+	if (err && (lookupmode == INTERPOSE_LOOKUP))
 		unionfs_unlock_dentry(dentry);
 	if (!err && d_interposed)
 		return d_interposed;
-- 
1.5.2.2

