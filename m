Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXDLJya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXDLJya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXDLJy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:54:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:57877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945976AbXDLJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:32 -0400
Message-Id: <20070412090847.351285000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:42 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 33/41] Add d_namespace_path() to obtain namespace relative pathnames
Content-Disposition: inline; filename=d_namespace_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In AppArmor we are interested in pathnames relative to the namespace
root. Except for the root where the search ends, this is the same as
d_path(). Add d_namespace_path() for that.
internals.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Reviewed-by: John Johansen <jjohansen@suse.de>

---
 fs/dcache.c            |    6 +++---
 fs/namespace.c         |   22 ++++++++++++++++++++++
 include/linux/dcache.h |    2 ++
 include/linux/mount.h  |    2 ++
 4 files changed, 29 insertions(+), 3 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1750,9 +1750,9 @@ shouldnt_be_hashed:
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
@@ -1896,3 +1896,25 @@ void __put_mnt_ns(struct mnt_namespace *
 	release_mounts(&umount_list);
 	kfree(ns);
 }
+
+char *d_namespace_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		       char *buf, int buflen)
+{
+	char *res;
+	struct vfsmount *rootmnt, *nsrootmnt;
+	struct dentry *root;
+
+	read_lock(&current->fs->lock);
+	rootmnt = mntget(current->fs->rootmnt);
+	read_unlock(&current->fs->lock);
+	spin_lock(&vfsmount_lock);
+	nsrootmnt = mntget(rootmnt->mnt_ns->root);
+	root = dget(nsrootmnt->mnt_root);
+	spin_unlock(&vfsmount_lock);
+	mntput(rootmnt);
+	res = __d_path(dentry, vfsmnt, root, nsrootmnt, buf, buflen, 1);
+	dput(root);
+	mntput(nsrootmnt);
+	return res;
+}
+EXPORT_SYMBOL(d_namespace_path);
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -293,6 +293,8 @@ extern struct dentry * d_hash_and_lookup
 /* validate "insecure" dentry pointer */
 extern int d_validate(struct dentry *, struct dentry *);
 
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
