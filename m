Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZERQOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZERQOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbZERQMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:12:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:41530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZERQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:34 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 14/32] whiteout: Add path_whiteout() helper
Date: Mon, 18 May 2009 18:09:10 +0200
Message-Id: <1242662968-11684-15-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a path_whiteout() helper for vfs_whiteout().

Signed-off-by: Jan Blunck <jblunck@suse.org>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c         |   15 ++++++++++++++-
 include/linux/fs.h |    1 -
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fe58172..9dc51b0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2172,7 +2172,7 @@ static inline int may_whiteout(struct inode *dir, struct dentry *victim,
  * After this returns with success, don't make any assumptions about the inode.
  * Just dput() it dentry.
  */
-int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
+static int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
 {
 	int err;
 	struct inode *old_inode = dentry->d_inode;
@@ -2224,6 +2224,19 @@ int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
 	return err;
 }
 
+int path_whiteout(struct path *dir_path, struct dentry *dentry, int isdir)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_whiteout(dir_path->dentry->d_inode, dentry, isdir);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_whiteout);
+
 /*
  * We try to drop the dentry early: we should have
  * a usage count of 2 if we're the only user of this
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 841bc1d..f5ca398 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1245,7 +1245,6 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
-extern int vfs_whiteout(struct inode *, struct dentry *, int);
 
 /*
  * VFS dentry helper functions.
-- 
1.6.1.3

