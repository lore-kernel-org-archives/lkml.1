Return-Path: <linux-kernel-owner+w=401wt.eu-S966392AbXG3QYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966392AbXG3QYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938518AbXG3QOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:33 -0400
Received: from ns2.suse.de ([195.135.220.15]:58735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936806AbXG3QON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:13 -0400
Message-Id: <20070730161325.534313783@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:49 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 26/26] union-mount: Debug code
Content-Disposition: inline; filename=um/union-mount-debug.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugging code itself.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c            |   26 ++++++++++++++++++++++++++
 fs/union.c            |   27 +++++++++++++++++++++++++++
 include/linux/namei.h |    4 ++++
 3 files changed, 57 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -32,6 +32,7 @@
 #include <linux/fcntl.h>
 #include <linux/namei.h>
 #include <linux/union.h>
+#include <linux/union_debug.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
@@ -1794,11 +1795,15 @@ int hash_lookup_union(struct nameidata *
 	struct path safe = { .dentry = nd->dentry, .mnt = nd->mnt };
 	int res ;
 
+	UM_DEBUG_LOOKUP("name = \"%*s\"\n", name->len, name->name);
+
 	pathget(&safe);
 	res = __hash_lookup_topmost(nd, name, path);
 	if (res)
 		goto out;
 
+	UM_DEBUG_LOOKUP_DENTRY(path->dentry);
+
 	/* only directories can be part of a union stack */
 	if (!path->dentry->d_inode ||
 	    !S_ISDIR(path->dentry->d_inode->i_mode))
@@ -1813,6 +1818,7 @@ int hash_lookup_union(struct nameidata *
 		goto out;
 	}
 
+	UM_DEBUG_LOOKUP_DENTRY(path->dentry);
 out:
 	path_release(nd);
 	nd->dentry = safe.dentry;
@@ -2765,6 +2771,8 @@ out_freename:
 	kfree(name.name);
 out:
 	pathput(&safe);
+	UM_DEBUG("err = %d\n", err);
+	UM_DEBUG_DENTRY(dentry);
 	return err;
 }
 
@@ -2802,6 +2810,9 @@ int vfs_unlink_whiteout(struct inode *di
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
+	UM_DEBUG("err = %d\n", error);
+	UM_DEBUG_DENTRY(dentry);
+
 	/*
 	 * We can call dentry_iput() since nobody could actually do something
 	 * useful with a whiteout. So dropping the reference to the inode
@@ -3490,6 +3501,10 @@ int vfs_rename_union(struct nameidata *o
 	struct dentry *dentry;
 	int error;
 
+	UM_DEBUG_DENTRY(old->dentry);
+	UM_DEBUG_DENTRY(new->dentry);
+/*	return -EPERM; */
+
 	if (old->dentry->d_inode == new->dentry->d_inode)
 		return 0;
 
@@ -3530,6 +3545,9 @@ int vfs_rename_union(struct nameidata *o
 
 	/* possibly delete the existing new file */
 	if ((newnd->dentry == new->dentry->d_parent) && new->dentry->d_inode) {
+		UM_DEBUG("unlink:\n");
+		UM_DEBUG_DENTRY(new->dentry);
+
 		/* FIXME: inode may be truncated while we hold a lock */
 		error = vfs_unlink(new_dir, new->dentry);
 		if (error)
@@ -3540,6 +3558,9 @@ int vfs_rename_union(struct nameidata *o
 		if (IS_ERR(dentry))
 			goto freename;
 
+		UM_DEBUG("new target:\n");
+		UM_DEBUG_DENTRY(new->dentry);
+
 		dput(new->dentry);
 		new->dentry = dentry;
 	}
@@ -3554,6 +3575,10 @@ int vfs_rename_union(struct nameidata *o
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto freename;
+
+	UM_DEBUG("whiteout:\n");
+	UM_DEBUG_DENTRY(dentry);
+
 	error = vfs_whiteout(old_dir, dentry);
 	dput(dentry);
 
@@ -3567,6 +3592,7 @@ int vfs_rename_union(struct nameidata *o
 */
 freename:
 	kfree(old_name.name);
+	UM_DEBUG("err = %d\n", error);
 	return error;
 }
 
--- a/fs/union.c
+++ b/fs/union.c
@@ -18,6 +18,7 @@
 #include <linux/hash.h>
 #include <linux/fs.h>
 #include <linux/union.h>
+#include <linux/union_debug.h>
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/mm.h>
@@ -253,6 +254,9 @@ int append_to_union(struct vfsmount *mnt
 
 	BUG_ON(!IS_MNT_UNION(mnt));
 
+	UM_DEBUG_DENTRY(dentry);
+	UM_DEBUG_DENTRY(dest_dentry);
+
 	this = union_alloc(dentry, mnt, dest_dentry, dest_mnt);
 	if (!this)
 		return -ENOMEM;
@@ -822,6 +826,8 @@ int union_relookup_topmost(struct nameid
 	char *kbuf, *name;
 	struct nameidata this;
 
+	UM_DEBUG_DENTRY(nd->dentry);
+
 	kbuf = (char *)__get_free_page(GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
@@ -838,6 +844,7 @@ int union_relookup_topmost(struct nameid
 	path_release(nd);
 	nd->dentry = this.dentry;
 	nd->mnt = this.mnt;
+	UM_DEBUG_DENTRY(nd->dentry);
 
 	/*
 	 * the nd->flags should be unchanged
@@ -846,6 +853,7 @@ int union_relookup_topmost(struct nameid
 	nd->um_flags &= ~LAST_LOWLEVEL;
  free_page:
 	free_page((unsigned long)kbuf);
+	UM_DEBUG("err = %d\n", err);
 	return err;
 }
 
@@ -895,6 +903,8 @@ struct dentry *union_create_topmost(stru
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
+	UM_DEBUG_DENTRY(dentry);
+
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		/*
@@ -916,6 +926,9 @@ struct dentry *union_create_topmost(stru
 			dentry = ERR_PTR(res);
 			goto out_unlock;
 		}
+
+		UM_DEBUG_DENTRY(dentry);
+
 		break;
 	case S_IFDIR:
 		res = vfs_mkdir(parent->d_inode, dentry, mode);
@@ -925,6 +938,8 @@ struct dentry *union_create_topmost(stru
 			goto out_unlock;
 		}
 
+		UM_DEBUG_DENTRY(dentry);
+
 		res = append_to_union(nd->mnt, dentry, path->mnt,
 				      path->dentry);
 		if (res) {
@@ -944,6 +959,7 @@ struct dentry *union_create_topmost(stru
 
  out_unlock:
 	mutex_unlock(&parent->d_inode->i_mutex);
+	UM_DEBUG("err = %d\n", IS_ERR(dentry) ? PTR_ERR(dentry) : 0);
 	return dentry;
 }
 
@@ -980,9 +996,14 @@ static int union_copy_file(struct dentry
 	if (ret >= 0)
 		ret = 0;
  fput_new:
+	UM_DEBUG("new_dentry:\n");
+	UM_DEBUG_DENTRY(new_dentry);
 	fput(new_file);
  fput_old:
+	UM_DEBUG("old_dentry:\n");
+	UM_DEBUG_DENTRY(old_dentry);
 	fput(old_file);
+	UM_DEBUG("err = %d\n", ret);
 	return ret;
 }
 
@@ -1059,6 +1080,8 @@ int union_copyup(struct nameidata *nd, i
 	if (!S_ISREG(nd->dentry->d_inode->i_mode))
 		return 0;
 
+	UM_DEBUG_DENTRY(nd->dentry);
+
 	/* safe the name for hash_lookup_union() */
 	this.len = nd->dentry->d_name.len;
 	this.hash = nd->dentry->d_name.hash;
@@ -1084,6 +1107,8 @@ int union_copyup(struct nameidata *nd, i
 	if (err)
 		return err;
 
+	UM_DEBUG_DENTRY(path.dentry);
+
 	err = -ENOENT;
 	if (!path.dentry->d_inode)
 		goto exit_dput;
@@ -1106,9 +1131,11 @@ int union_copyup(struct nameidata *nd, i
 	}
 
 	path_to_nameidata(&path, nd);
+	UM_DEBUG("err = 0\n");
 	return 0;
 
 exit_dput:
 	dput_path(&path, nd);
+	UM_DEBUG("err = %d\n", err);
 	return err;
 }
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -117,17 +117,20 @@ static inline char *nd_get_link(struct n
 
 static inline void pathget(struct path *path)
 {
+	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 	mntget(path->mnt);
 	dget(path->dentry);
 }
 
 static inline void pathput(struct path *path)
 {
+	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 	dput(path->dentry);
 	mntput(path->mnt);
 }
 static inline void dput_path(struct path *path, struct nameidata *nd)
 {
+	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 	dput(path->dentry);
 	if (path->mnt != nd->mnt)
 		mntput(path->mnt);
@@ -135,6 +138,7 @@ static inline void dput_path(struct path
 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
+	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 	dput(nd->dentry);
 	if (nd->mnt != path->mnt)
 		mntput(nd->mnt);

-- 

