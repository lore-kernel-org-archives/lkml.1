Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZKWRlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZKWRlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZKWRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:41:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZKWRls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:41:48 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: [PATCH 3/3] vfs: check path permissions on target of LAST_BIND symlinks
Date: Mon, 23 Nov 2009 12:41:24 -0500
Message-Id: <1258998084-26797-4-git-send-email-jlayton@redhat.com>
In-Reply-To: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because LAST_BIND symlinks aren't subject to the normal path walking
routines, they sidestep all of the permission checking that occurs while
resolving a path. Fix this by adding a routine to walk back up the
directory tree and check MAY_EXEC permission on the entire path back up to
the root.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 738b257..d4c1279 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -504,6 +504,57 @@ ok:
 }
 
 /*
+ * We have a cached struct path from a LAST_BIND symlink. The path is valid
+ * but it's possible that one of the components leading to this point
+ * might not be accessible. This check walks back up the tree to the root
+ * of the namespace and checks whether each component is accessible. The
+ * supplied path is put on error.
+ */
+static int
+check_path_accessible(struct path *path)
+{
+	int err;
+	struct dentry *parent, *tdentry = dget(path->dentry);
+	struct vfsmount *vfsmnt = mntget(path->mnt);
+	struct path root = current->fs->root;
+
+	path_get(&root);
+	for(;;) {
+		parent = dget_parent(tdentry);
+		err = inode_permission(parent->d_inode, MAY_EXEC);
+		if (err < 0) {
+			dput(parent);
+			break;
+		}
+		dput(tdentry);
+		tdentry = parent;
+
+		/* keep going if not to root of mnt */
+		if (!IS_ROOT(tdentry))
+			continue;
+
+		/* are we at global root or root of namespace? */
+		if ((tdentry == root.dentry && vfsmnt == root.mnt) ||
+		    vfsmnt->mnt_parent == vfsmnt)
+			break;
+
+		/* cross to parent mount and keep walking */
+		mntput(vfsmnt);
+		vfsmnt = mntget(vfsmnt->mnt_parent);
+		tdentry = dget(vfsmnt->mnt_mountpoint);
+		dput(parent);
+	}
+	dput(tdentry);
+	mntput(vfsmnt);
+	path_put(&root);
+
+	if (err)
+		path_put(path);
+
+	return err;
+}
+
+/*
  * This is called when everything else fails, and we actually have
  * to go to the low-level filesystem to find out what we should do..
  *
@@ -679,8 +730,12 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
 		error = 0;
 		if (s)
 			error = __vfs_follow_link(nd, s);
-		else if (nd->last_type == LAST_BIND)
+		else if (nd->last_type == LAST_BIND) {
 			error = force_reval_path(&nd->path, nd);
+			if (!error)
+				error = check_path_accessible(&nd->path);
+		}
+
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-- 
1.5.5.6

