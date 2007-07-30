Return-Path: <linux-kernel-owner+w=401wt.eu-S939765AbXG3QWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939765AbXG3QWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938679AbXG3QO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:57 -0400
Received: from mail.suse.de ([195.135.220.2]:40570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765234AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161325.272107303@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:46 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 23/26] union-mount: copyup on rename
Content-Disposition: inline; filename=um/union-mount-coo-rename.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add copyup renaming of regular files on union mounts. Directories are still
lazyly copied with the help of user-space.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/union.c |    8 ++-
 2 files changed, 129 insertions(+), 12 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1491,6 +1491,8 @@ static int fastcall do_path_lookup(int d
 		nd->mnt = mntget(fs->pwdmnt);
 		nd->dentry = dget(fs->pwd);
 		read_unlock(&fs->lock);
+		/* Force a union_relookup() */
+		nd->um_flags = LAST_LOWLEVEL;
 	} else {
 		struct dentry *dentry;
 
@@ -3478,6 +3480,97 @@ int vfs_rename(struct inode *old_dir, st
 	return error;
 }
 
+int vfs_rename_union(struct nameidata *oldnd, struct path *old,
+		     struct nameidata *newnd, struct path *new)
+{
+	struct inode *old_dir = oldnd->dentry->d_inode;
+	struct inode *new_dir = newnd->dentry->d_inode;
+	struct qstr old_name;
+	char *name;
+	struct dentry *dentry;
+	int error;
+
+	if (old->dentry->d_inode == new->dentry->d_inode)
+		return 0;
+
+	error = may_whiteout(old->dentry, 0);
+	if (error)
+		return error;
+	if (!old_dir->i_op || !old_dir->i_op->whiteout)
+		return -EPERM;
+
+	if (!new->dentry->d_inode)
+		error = may_create(new_dir, new->dentry, NULL);
+	else
+		error = may_delete(new_dir, new->dentry, 0);
+	if (error)
+		return error;
+
+	DQUOT_INIT(old_dir);
+	DQUOT_INIT(new_dir);
+
+	error = security_inode_rename(old_dir, old->dentry,
+				      new_dir, new->dentry);
+	if (error)
+		return error;
+
+	error = -EBUSY;
+	if (d_mountpoint(old->dentry) || d_mountpoint(new->dentry))
+		return error;
+
+	error = -ENOMEM;
+	name = kmalloc(old->dentry->d_name.len, GFP_KERNEL);
+	if (!name)
+		return error;
+	strncpy(name, old->dentry->d_name.name, old->dentry->d_name.len);
+	name[old->dentry->d_name.len] = 0;
+	old_name.len = old->dentry->d_name.len;
+	old_name.hash = old->dentry->d_name.hash;
+	old_name.name = name;
+
+	/* possibly delete the existing new file */
+	if ((newnd->dentry == new->dentry->d_parent) && new->dentry->d_inode) {
+		/* FIXME: inode may be truncated while we hold a lock */
+		error = vfs_unlink(new_dir, new->dentry);
+		if (error)
+			goto freename;
+
+		dentry = __lookup_hash_kern(&new->dentry->d_name,
+					    newnd->dentry, newnd);
+		if (IS_ERR(dentry))
+			goto freename;
+
+		dput(new->dentry);
+		new->dentry = dentry;
+	}
+
+	/* copyup to the new file */
+	error = __union_copyup(old, newnd, new);
+	if (error)
+		goto freename;
+
+	/* whiteout the old file */
+	dentry = __lookup_hash_kern(&old_name, oldnd->dentry, oldnd);
+	error = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto freename;
+	error = vfs_whiteout(old_dir, dentry);
+	dput(dentry);
+
+	/* FIXME: This is acutally unlink() && create() ... */
+/*
+	if (!error) {
+		const char *new_name = old_dentry->d_name.name;
+		fsnotify_move(old_dir, new_dir, old_name.name, new_name, 0,
+			      new_dentry->d_inode, old_dentry->d_inode);
+	}
+*/
+freename:
+	kfree(old_name.name);
+	return error;
+}
+
+
 static int do_rename(int olddfd, const char *oldname,
 			int newdfd, const char *newname)
 {
@@ -3495,10 +3588,7 @@ static int do_rename(int olddfd, const c
 	if (error)
 		goto exit1;
 
-	error = -EXDEV;
-	if (oldnd.mnt != newnd.mnt)
-		goto exit2;
-
+lock:
 	old_dir = oldnd.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
@@ -3536,15 +3626,40 @@ static int do_rename(int olddfd, const c
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
-	/* renaming on unions is done by the user-space */
+	/* renaming of directories on unions is done by the user-space */
 	error = -EXDEV;
-	if (is_unionized(oldnd.dentry, oldnd.mnt))
+	if (is_unionized(oldnd.dentry, oldnd.mnt) &&
+	    S_ISDIR(old.dentry->d_inode->i_mode))
 		goto exit5;
-	if (is_unionized(newnd.dentry, newnd.mnt))
+	/* renameing of other files on unions is done by copyup */
+	if ((is_unionized(oldnd.dentry, oldnd.mnt) &&
+	     (oldnd.um_flags & LAST_LOWLEVEL)) ||
+	    (is_unionized(newnd.dentry, newnd.mnt) &&
+	     (newnd.um_flags & LAST_LOWLEVEL))) {
+		dput_path(&new, &newnd);
+		dput_path(&old, &oldnd);
+		unlock_rename(new_dir, old_dir);
+		error = union_relookup_topmost(&oldnd,
+					       oldnd.flags & ~LOOKUP_PARENT);
+		if (error)
+			goto exit2;
+		error = union_relookup_topmost(&newnd,
+					       newnd.flags & ~LOOKUP_PARENT);
+		if (error)
+			goto exit2;
+		goto lock;
+	}
+
+	error = -EXDEV;
+	if (oldnd.mnt != newnd.mnt)
 		goto exit5;
 
-	error = vfs_rename(old_dir->d_inode, old.dentry,
-			   new_dir->d_inode, new.dentry);
+	if (is_unionized(oldnd.dentry, oldnd.mnt) &&
+	    (old.dentry->d_parent != oldnd.dentry))
+		error = vfs_rename_union(&oldnd, &old, &newnd, &new);
+	else
+		error = vfs_rename(old_dir->d_inode, old.dentry,
+				   new_dir->d_inode, new.dentry);
 exit5:
 	dput_path(&new, &newnd);
 exit4:
--- a/fs/union.c
+++ b/fs/union.c
@@ -1030,9 +1030,11 @@ int __union_copyup(struct path *old, str
 		goto out;
 	}
 
-	dput_path(new, new_nd);
-	new->dentry = dentry;
-	new->mnt = new_nd->mnt;
+	if (new->dentry != dentry) {
+		dput_path(new, new_nd);
+		new->dentry = dentry;
+		new->mnt = new_nd->mnt;
+	}
 out:
 	if (new->dentry != dentry)
 		dput(dentry);

-- 

