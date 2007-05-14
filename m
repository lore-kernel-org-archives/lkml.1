Return-Path: <linux-kernel-owner+w=401wt.eu-S1032349AbXENLts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032349AbXENLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966149AbXENLeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:34:17 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27947 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760496AbXENLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:37 -0400
Message-Id: <20070514110618.903992193@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:38 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 31/45] Add d_namespace_path() to compute namespace relative pathnames
Content-Disposition: inline; filename=d_namespace_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In AppArmor, we are interested in pathnames relative to the namespace root.
This is the same as d_path() except for the root where the search ends. Add
a function for computing the namespace-relative path.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Reviewed-by: John Johansen <jjohansen@suse.de>

---
 fs/dcache.c            |    6 +++---
 fs/namespace.c         |   27 +++++++++++++++++++++++++++
 include/linux/dcache.h |    2 ++
 include/linux/mount.h  |    2 ++
 4 files changed, 34 insertions(+), 3 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1779,9 +1779,9 @@ shouldnt_be_hashed:
  *
  * Returns the buffer or an error code.
  */
-static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-		      struct dentry *root, struct vfsmount *rootmnt,
-		      char *buffer, int buflen, int fail_deleted)
+char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+	       struct dentry *root, struct vfsmount *rootmnt,
+	       char *buffer, int buflen, int fail_deleted)
 {
 	int namelen, is_slash, vfsmount_locked = 0;
 
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1868,3 +1868,30 @@ void __put_mnt_ns(struct mnt_namespace *
 	release_mounts(&umount_list);
 	kfree(ns);
 }
+
+char *d_namespace_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		       char *buf, int buflen)
+{
+	struct vfsmount *rootmnt, *nsrootmnt = NULL;
+	struct dentry *root = NULL;
+	char *res;
+
+	read_lock(&current->fs->lock);
+	rootmnt = mntget(current->fs->rootmnt);
+	read_unlock(&current->fs->lock);
+	spin_lock(&vfsmount_lock);
+	if (rootmnt->mnt_ns)
+		nsrootmnt = mntget(rootmnt->mnt_ns->root);
+	spin_unlock(&vfsmount_lock);
+	mntput(rootmnt);
+	if (nsrootmnt)
+		root = dget(nsrootmnt->mnt_root);
+	res = __d_path(dentry, vfsmnt, root, nsrootmnt, buf, buflen, 1);
+	dput(root);
+	mntput(nsrootmnt);
+	/* Prevent empty path for lazily unmounted filesystems. */
+	if (!IS_ERR(res) && *res == '\0')
+		*--res = '.';
+	return res;
+}
+EXPORT_SYMBOL(d_namespace_path);
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -299,6 +299,8 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
+extern char *__d_path(struct dentry *, struct vfsmount *, struct dentry *,
+		      struct vfsmount *, char *, int, int);
 extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
   
 /* Allocation counts.. */
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -103,5 +103,7 @@ extern void shrink_submounts(struct vfsm
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+extern char *d_namespace_path(struct dentry *, struct vfsmount *, char *, int);
+
 #endif
 #endif /* _LINUX_MOUNT_H */

-- 
