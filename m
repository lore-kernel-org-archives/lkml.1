Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZKWRlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZKWRlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZKWRlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbZKWRld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:41:33 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: [PATCH 1/3] vfs: force reval of target when following LAST_BIND symlinks
Date: Mon, 23 Nov 2009 12:41:22 -0500
Message-Id: <1258998084-26797-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

procfs-style symlinks return a last_type of LAST_BIND without an actual
path string. This causes __follow_link to skip calling __vfs_follow_link
and so the dentry isn't revalidated.

This is a problem when the link target sits on NFSv4 as it depends on
the VFS to revalidate the dentry before using it on an open call. Ensure
that this occurs by forcing a revalidation of the target dentry of
LAST_BIND symlinks.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3374917..2c10519 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -414,6 +414,44 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
 }
 
 /*
+ * force_reval_path - force revalidation of a dentry
+ *
+ * In some situations the path walking code will trust dentries without
+ * revalidating them. This causes problems for filesystems that depend on
+ * d_revalidate to handle file opens (e.g. NFSv4). When FS_REVAL_DOT is set
+ * (which indicates that it's possible for the dentry to go stale), force
+ * a d_revalidate call before proceeding.
+ *
+ * Returns 0 if the revalidation was successful. If the revalidation fails,
+ * either return the error returned by d_revalidate or -ESTALE if the
+ * revalidation it just returned 0. On error, references to the path are put.
+ * Note that on error, the dentry is not d_invalidated. If the VFS is assuming
+ * that the dentry is valid, then invalidating it could have adverse effects
+ * elsewhere.
+ */
+static int
+force_reval_path(struct path *path, struct nameidata *nd)
+{
+	int status;
+	struct dentry *dentry = path->dentry;
+
+	/*
+	 * only check on filesystems where it's possible for the dentry to
+	 * become stale. It's assumed that if this flag is set then the
+	 * d_revalidate op will also be defined.
+	 */
+	if (!(dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT))
+		return 0;
+
+	status = dentry->d_op->d_revalidate(dentry, nd);
+	if (status > 0)
+		return 0;
+
+	path_put(path);
+	return status ? status : -ESTALE;
+}
+
+/*
  * Internal lookup() using the new generic dcache.
  * SMP-safe
  */
@@ -641,6 +679,8 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
 		error = 0;
 		if (s)
 			error = __vfs_follow_link(nd, s);
+		else if (nd->last_type == LAST_BIND)
+			error = force_reval_path(&nd->path, nd);
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-- 
1.5.5.6

