Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYFQRi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYFQRi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbYFQRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:37:29 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:58755 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYFQRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:37:28 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH 2/3] configfs: Rename CONFIGFS_USET_IN_MKDIR to CONFIGFS_USET_ATTACHING
Date: Tue, 17 Jun 2008 19:37:22 +0200
Message-Id: <1213724243-29183-3-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIGFS_USET_IN_MKDIR flag can be reused with symlink() to solve a similar
issue as mkdir() vs rmdir(). This patch renames the flag to make it more
meaningful for this purpose.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    2 +-
 fs/configfs/dir.c               |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index da015c1..a28f37d 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -48,7 +48,7 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DIR	0x0040
 #define CONFIGFS_USET_DEFAULT	0x0080
 #define CONFIGFS_USET_DROPPING	0x0100
-#define CONFIGFS_USET_IN_MKDIR	0x0200
+#define CONFIGFS_USET_ATTACHING	0x0200
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
 extern spinlock_t configfs_dirent_lock;
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index f2a12d0..629c938 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -383,7 +383,7 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
 			/* Abort if racing with mkdir() */
-			if (sd->s_type & CONFIGFS_USET_IN_MKDIR) {
+			if (sd->s_type & CONFIGFS_USET_ATTACHING) {
 				if (wait_mutex)
 					*wait_mutex = &sd->s_dentry->d_inode->i_mutex;
 				return -EAGAIN;
@@ -1127,7 +1127,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	 */
 	spin_lock(&configfs_dirent_lock);
 	/* This will make configfs_detach_prep() fail */
-	sd->s_type |= CONFIGFS_USET_IN_MKDIR;
+	sd->s_type |= CONFIGFS_USET_ATTACHING;
 	spin_unlock(&configfs_dirent_lock);
 
 	if (group)
@@ -1136,7 +1136,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		ret = configfs_attach_item(parent_item, item, dentry);
 
 	spin_lock(&configfs_dirent_lock);
-	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	sd->s_type &= ~CONFIGFS_USET_ATTACHING;
 	spin_unlock(&configfs_dirent_lock);
 
 out_unlink:
-- 
1.5.5.3

