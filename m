Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXHHKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXHHKKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXHHKKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:10:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51868 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbXHHKKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:10:16 -0400
Date: Wed, 8 Aug 2007 15:40:11 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 18/26] union-mount: Changes to the namespace handling
Message-ID: <20070808101011.GA6294@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.806938495@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161324.806938495@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:41PM +0200, Jan Blunck wrote:
> Creates the proper struct union_mount when mounting something into a
> union. If the topmost filesystem isn't capable of handling the white-out
> filetype it could only be mount read-only.
>

Jan,

I think it is important to allow pivot_root of union mount points. Here
is an attempt to achieve that.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Allow pivot_root to  work with union mount points.

If the current root filesystem is a union, then allow pivot_root
only if it's last component is a root, which allows it to be detached as a
complete union. Similarly if the new root filesystem is a union,
it's last component should be a root, so that it can be completely detached
from it's current mount point as a union and mounted back as root filesystem.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namespace.c        |   17 +++++++++++++++--
 fs/union.c            |   12 ++++++++++++
 include/linux/union.h |    2 ++
 3 files changed, 29 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -171,6 +171,13 @@ static void detach_mnt(struct vfsmount *
 	old_nd->dentry->d_mounted--;
 }
 
+static void detach_last_mnt(struct nameidata *nd, struct nameidata *old_nd)
+{
+	if (IS_MNT_UNION(nd->mnt))
+		while (follow_union_down(&nd->mnt, &nd->dentry));
+	detach_mnt(nd->mnt, old_nd);
+}
+
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
 			struct vfsmount *child_mnt)
 {
@@ -1878,6 +1885,9 @@ asmlinkage long sys_pivot_root(const cha
 	if (!check_mnt(new_nd.mnt))
 		goto out1;
 
+	if (IS_MNT_UNION(new_nd.mnt) && !last_union_is_root(&new_nd))
+		goto out1;
+
 	error = __user_walk(put_old, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &old_nd);
 	if (error)
 		goto out1;
@@ -1901,6 +1911,9 @@ asmlinkage long sys_pivot_root(const cha
 		goto out2;
 	if (!check_mnt(user_nd.mnt))
 		goto out2;
+	if (IS_MNT_UNION(user_nd.mnt) && !last_union_is_root(&user_nd))
+		goto out2;
+
 	error = -ENOENT;
 	if (IS_DEADDIR(new_nd.dentry->d_inode))
 		goto out2;
@@ -1934,8 +1947,8 @@ asmlinkage long sys_pivot_root(const cha
 			goto out3;
 	} else if (!is_subdir(old_nd.dentry, new_nd.dentry))
 		goto out3;
-	detach_mnt(new_nd.mnt, &parent_nd);
-	detach_mnt(user_nd.mnt, &root_parent);
+	detach_last_mnt(&new_nd, &parent_nd);
+	detach_last_mnt(&user_nd, &root_parent);
 	attach_mnt(user_nd.mnt, &old_nd);     /* mount old root on put_old */
 	attach_mnt(new_nd.mnt, &root_parent); /* mount new_root on / */
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
--- a/fs/union.c
+++ b/fs/union.c
@@ -507,6 +507,18 @@ void detach_mnt_union(struct vfsmount *m
 	return;
 }
 
+/*
+ * last_union_is_root - Check if the last component of the union stack
+ * is a root.
+ */
+int last_union_is_root(struct nameidata *nd)
+{
+	struct vfsmount *mnt = nd->mnt;
+	struct dentry *dentry = nd->dentry;
+
+	while (follow_union_down(&mnt, &dentry));
+	return IS_ROOT(dentry) ? 1: 0;
+}
 
 /*
  * Union mounts support for readdir.
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -53,6 +53,7 @@ extern void __shrink_d_unions(struct den
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
+extern int last_union_is_root(struct nameidata *nd);
 extern int readdir_union(struct file *, void *, filldir_t);
 extern int is_dir_unioned(struct path *);
 extern int union_relookup_topmost(struct nameidata *, int);
@@ -74,6 +75,7 @@ extern int union_copyup(struct nameidata
 #define __shrink_d_unions(x)		do { } while (0)
 #define attach_mnt_union(x, y, z)	do { } while (0)
 #define detach_mnt_union(x)		do { } while (0)
+#define last_union_is_root(x)		({ (0); })
 #define union_relookup_topmost(x, y)	({ BUG(); (0); })
 #define union_create_topmost(x, y, z)	({ BUG(); (NULL); })
 #define __union_copyup(x, y, z)		({ BUG(); (0); })

This applies on top of your patchset plus my subsequent fixes [1] and
[2].

[1] http://lkml.org/lkml/2007/8/6/10.
[2] http://lkml.org/lkml/2007/8/6/114.

Regards,
Bharata.
