Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXDSXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXDSXzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXDSXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:55:04 -0400
Received: from mail.suse.de ([195.135.220.2]:35290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422982AbXDSXy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:56 -0400
Message-Id: <20070419234704.123573327@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:06 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 3/7] Add d_namespace_path() to compute namespace relative pathnames
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
@@ -1877,3 +1877,30 @@ void __put_mnt_ns(struct mnt_namespace *
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
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

