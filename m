Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbZFRTGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbZFRTGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZFRTGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:06:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZFRTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:06:37 -0400
Date: Thu, 18 Jun 2009 15:05:59 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: hooanon05@yahoo.co.jp
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
Subject: Re: [PATCH 15/32] union-mount: Documentation
Message-ID: <20090618190558.GB22206@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-16-git-send-email-jblunck@suse.de> <8417.1243232743@jrobl> <200905250903.08165.arnd@arndb.de> <7294.1243240990@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7294.1243240990@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:43:10PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Arnd Bergmann:
> > Right, but that is consistent with how the kernel would treat a
> > rename from one mount point to another, and tools like 'mv'
> > can handle this in user space.
> 
> Yes, that is the description in the union mount document.
> While it says to rename a regular file is implemented, the code differs
> actually.
> ----------------------------------------
> +Rename across different levels of the union is implemented as a copy-up
> +operation for regular files. Rename of directories simply returns EXDEV, the
> +same as if we tried to rename across different mounts. Most applications have
> 	:::
> ----------------------------------------

Ah, we did implement that in an earlier version.  I don't know if we
dropped the patch by accident or on purpose, but the original version
is below.  We will either put this feature back or fix the
documentation.  Thanks!

-VAL

Subject: union-mount: copyup on rename

Add copyup renaming of regular files on union mounts. Directories are still
lazyly copied with the help of user-space.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 124 insertions(+), 7 deletions(-)

Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1532,6 +1532,8 @@ static int do_path_lookup(int dfd, const
 		nd->path = fs->pwd;
 		path_get(&fs->pwd);
 		read_unlock(&fs->lock);
+		/* Force a union_relookup() */
+		nd->um_flags = LAST_LOWLEVEL;
 	} else {
 		struct dentry *dentry;
 
@@ -3684,6 +3686,97 @@ int vfs_rename(struct inode *old_dir, st
 	return error;
 }
 
+int vfs_rename_union(struct nameidata *oldnd, struct path *old,
+		     struct nameidata *newnd, struct path *new)
+{
+	struct inode *old_dir = oldnd->path.dentry->d_inode;
+	struct inode *new_dir = newnd->path.dentry->d_inode;
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
+	if ((newnd->path.dentry == new->dentry->d_parent) && new->dentry->d_inode) {
+		/* FIXME: inode may be truncated while we hold a lock */
+		error = vfs_unlink(new_dir, new->dentry);
+		if (error)
+			goto freename;
+
+		dentry = __lookup_hash(&new->dentry->d_name,
+				       newnd->path.dentry, newnd);
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
+	dentry = __lookup_hash(&old_name, oldnd->path.dentry, oldnd);
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
@@ -3701,10 +3794,7 @@ static int do_rename(int olddfd, const c
 	if (error)
 		goto exit1;
 
-	error = -EXDEV;
-	if (oldnd.path.mnt != newnd.path.mnt)
-		goto exit2;
-
+lock:
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
@@ -3742,12 +3832,39 @@ static int do_rename(int olddfd, const c
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
-	/* renaming on unions is done by the user-space */
+	/* renaming of directories on unions is done by the user-space */
+	error = -EXDEV;
+	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt) &&
+	    S_ISDIR(old.dentry->d_inode->i_mode))
+		goto exit5;
+	/* renameing of other files on unions is done by copyup */
+	if ((is_unionized(oldnd.path.dentry, oldnd.path.mnt) &&
+	     (oldnd.um_flags & LAST_LOWLEVEL)) ||
+	    (is_unionized(newnd.path.dentry, newnd.path.mnt) &&
+	     (newnd.um_flags & LAST_LOWLEVEL))) {
+		path_put_conditional(&new, &newnd);
+		path_put_conditional(&old, &oldnd);
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
 	error = -EXDEV;
-	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt))
+	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit5;
-	if (is_unionized(newnd.path.dentry, newnd.path.mnt))
+
+	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt) &&
+	    (old.dentry->d_parent != oldnd.path.dentry)) {
+		error = vfs_rename_union(&oldnd, &old, &newnd, &new);
 		goto exit5;
+	}
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)

