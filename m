Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZJUTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZJUTU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZJUTU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbZJUTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:53 -0400
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
       Jan Blunck <jblunck@suse.de>, Jan Blunck <jblunck@suse.org>
Subject: [PATCH 17/41] whiteout: Add path_whiteout() helper
Date: Wed, 21 Oct 2009 12:19:15 -0700
Message-Id: <1256152779-10054-18-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-17-git-send-email-vaurora@redhat.com>
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
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add a path_whiteout() helper for vfs_whiteout().

Signed-off-by: Jan Blunck <jblunck@suse.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c         |   15 ++++++++++++++-
 include/linux/fs.h |    1 -
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9a62c75..408380d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2231,7 +2231,7 @@ static inline int may_whiteout(struct inode *dir, struct dentry *victim,
  * After this returns with success, don't make any assumptions about the inode.
  * Just dput() it dentry.
  */
-int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
+static int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
 {
 	int err;
 	struct inode *old_inode = dentry->d_inode;
@@ -2283,6 +2283,19 @@ int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
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
  * This is abusing readdir to check if a union directory is logically empty.
  * Al Viro barfed when he saw this, but Val said: "Well, at this point I'm
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b741e50..d13de8a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1426,7 +1426,6 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
-extern int vfs_whiteout(struct inode *, struct dentry *, int);
 
 /*
  * VFS dentry helper functions.
-- 
1.6.3.3

