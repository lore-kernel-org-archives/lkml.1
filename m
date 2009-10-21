Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbZJUTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbZJUTUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZJUTUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZJUTU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:29 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 12/41] union-mount: Allow removal of a directory
Date: Wed, 21 Oct 2009 12:19:10 -0700
Message-Id: <1256152779-10054-13-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-12-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

do_whiteout() allows removal of a directory when it has whiteouts but
is logically empty.

XXX - This patch abuses readdir() to check if the union directory is
logically empty - that is, all the entries are whiteouts (or "." or
"..").  Currently, we have no clean VFS interface to ask the lower
file system if a directory is empty.

Fixes:
 - Add ->is_directory_empty() op
 - Add is_directory_empty flag to dentry (ugly dcache populate)
 - Ask underlying fs to remove it and look for an error return
 - (your idea here)

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5da1635..9a62c75 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2284,6 +2284,91 @@ int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
 }
 
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
1.6.3.3

