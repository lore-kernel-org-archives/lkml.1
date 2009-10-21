Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZJUTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZJUTUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZJUTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbZJUTU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:27 -0400
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
Subject: [PATCH 11/41] whiteout: Set S_OPAQUE inode flag when creating directories
Date: Wed, 21 Oct 2009 12:19:09 -0700
Message-Id: <1256152779-10054-12-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-11-git-send-email-vaurora@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

In case of an union directory we don't want that the directories on lower
layers of the union "show through". So to prevent that the contents of
underlying directories magically shows up after a mkdir() we set the S_OPAQUE
flag if directories are created where a whiteout existed before.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c         |   12 +++++++++++-
 include/linux/fs.h |    3 +++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d2fc8c9..5da1635 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2108,6 +2108,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int error = may_create(dir, dentry);
+	int opaque = 0;
 
 	if (error)
 		return error;
@@ -2121,9 +2122,18 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return error;
 
 	vfs_dq_init(dir);
+
+	if (d_is_whiteout(dentry))
+		opaque = 1;
+
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
+	if (!error) {
 		fsnotify_mkdir(dir, dentry);
+		if (opaque) {
+			dentry->d_inode->i_flags |= S_OPAQUE;
+			mark_inode_dirty(dentry->d_inode);
+		}
+	}
 	return error;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04a9870..b741e50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -232,6 +232,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPAQUE	1024	/* Directory is opaque */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -267,6 +268,8 @@ struct inodes_stat_t {
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
 
+#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
-- 
1.6.3.3

