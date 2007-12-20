Return-Path: <linux-kernel-owner+w=401wt.eu-S934798AbXLTO0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbXLTO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbXLTOMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:56782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093AbXLTOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:40 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:46 2007
Message-Id: <20071220140946.206811991@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:41 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 31/47] Add d_namespace_path() to compute namespace relative pathnames
Content-Disposition: inline; filename=d_namespace_path.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In AppArmor, we are interested in pathnames relative to the namespace root.
This is the same as d_path() except for the root where the search ends. Add
a function for computing the namespace-relative path.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/dcache.c            |    4 ++--
 fs/namespace.c         |   26 ++++++++++++++++++++++++++
 include/linux/dcache.h |    1 +
 include/linux/mount.h  |    3 +++
 4 files changed, 32 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1763,8 +1763,8 @@ shouldnt_be_hashed:
  *
  * Returns the buffer or an error code.
  */
-static char *__d_path(struct path *path, struct path *root,
-                     char *buffer, int buflen, int fail_deleted)
+char *__d_path(struct path *path, struct path *root, char *buffer, int buflen,
+	       int fail_deleted)
 {
     int namelen, is_slash, vfsmount_locked = 0;
 	struct dentry *dentry = path->dentry;
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -26,6 +26,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/path.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -2167,3 +2168,28 @@ void __put_mnt_ns(struct mnt_namespace *
 	release_mounts(&umount_list);
 	kfree(ns);
 }
+
+char *d_namespace_path(struct path *path, char *buf, int buflen)
+{
+	struct path root = { NULL, NULL };
+	struct vfsmount *rootmnt;
+	char *res;
+
+	read_lock(&current->fs->lock);
+	rootmnt = mntget(current->fs->root.mnt);
+	read_unlock(&current->fs->lock);
+	spin_lock(&vfsmount_lock);
+	if (rootmnt->mnt_ns)
+		root.mnt = mntget(rootmnt->mnt_ns->root);
+	spin_unlock(&vfsmount_lock);
+	mntput(rootmnt);
+	if (root.mnt)
+		root.dentry = dget(root.mnt->mnt_root);
+	res = __d_path(path, &root, buf, buflen, 1);
+	path_put(&root);
+	/* Prevent empty path for lazily unmounted filesystems. */
+	if (!IS_ERR(res) && *res == '\0')
+		*--res = '.';
+	return res;
+}
+EXPORT_SYMBOL(d_namespace_path);
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+extern char *__d_path(struct path *, struct path *, char *, int, int);
 
 /* Allocation counts.. */
 
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
+#include <linux/path.h>
 #include <asm/atomic.h>
 
 struct super_block;
@@ -114,5 +115,7 @@ extern void shrink_submounts(struct vfsm
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+extern char *d_namespace_path(struct path *, char *, int);
+
 #endif
 #endif /* _LINUX_MOUNT_H */

-- 

