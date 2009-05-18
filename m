Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZERQLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZERQLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZERQJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 25/32] union-mount: check for logically empty directory (FIXME)
Date: Mon, 18 May 2009 18:09:21 +0200
Message-Id: <1242662968-11684-26-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch abuses readdir() to check if the union directory is logically
empty. We should populate the topmost directory with fallthrough entries and
after that ask the filesystem if the directory is empty.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 91486bd..78eb973 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2766,6 +2766,91 @@ int path_whiteout(struct path *dir_path, struct dentry *dentry, int isdir)
 EXPORT_SYMBOL(path_whiteout);
 
 /*
+ * This is abusing readdir to check if a union directory is logically empty.
+ * Al Viro barfed when he saw this, but Val said: "Well, at this point I'm
+ * aiming for working, pretty can come later"
+ */
+static int filldir_is_empty(void *__buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	int *is_empty = (int *)__buf;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (d_type == DT_WHT)
+		return 0;
+
+	(*is_empty) = 0;
+	return 0;
+}
+
+static int directory_is_empty(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct file *file;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
+
+	/* references for the file pointer */
+	dget(dentry);
+	mntget(mnt);
+
+	file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+	if (IS_ERR(file))
+		return 0;
+
+	err = vfs_readdir(file, filldir_is_empty, &is_empty);
+
+	fput(file);
+	return is_empty;
+}
+
+static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
+{
+	struct path safe = { .dentry = dget(nd->path.dentry),
+			     .mnt = mntget(nd->path.mnt) };
+	struct dentry *dentry = path->dentry;
+	int err;
+
+	err = may_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOTEMPTY;
+	if (isdir && !directory_is_empty(path->dentry, path->mnt))
+		goto out;
+
+	if (nd->path.dentry != dentry->d_parent) {
+		dentry = __lookup_hash(&path->dentry->d_name, nd->path.dentry,
+				       nd);
+		err = PTR_ERR(dentry);
+		if (IS_ERR(dentry))
+			goto out;
+
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		path->mnt = nd->path.mnt;
+		path->dentry = dentry;
+	}
+
+	err = vfs_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+
+out:
+	path_put(&safe);
+	return err;
+}
+
+/*
  * We try to drop the dentry early: we should have
  * a usage count of 2 if we're the only user of this
  * dentry, and if that is true (possibly after pruning
-- 
1.6.1.3

