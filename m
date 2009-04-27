Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZD0OvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZD0OvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZD0OoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814AbZD0On7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 7/8] quota: cleanup dquota sync functions (version 4)
Date: Mon, 27 Apr 2009 16:43:54 +0200
Message-Id: <1240843435-1786-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Currently the VFS calls vfs_dq_sync to sync out disk quotas for a given
superblock.  This is a small wrapper around sync_dquots which for the
case of a non-NULL superblock is a small wrapper around quota_sync_sb.

Just make quota_sync_sb global (rename it to sync_quota_sb) and call it
directly.  Also call it directly for those cases in quota.c that have a
superblock and leave sync_dquots purely an iterator over sync_quota_sb and
remove it's superblock argument.

To make this nicer move the check for the lack of a quota_sync method
from the callers into sync_quota_sb.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c         |   23 ++++++++++++-----------
 fs/sync.c                |    2 +-
 include/linux/quotaops.h |   11 +++--------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index b7f5a46..5edb20d 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -159,10 +159,13 @@ static int check_quotactl_valid(struct super_block *sb, int type, int cmd,
 	return error;
 }
 
-static void quota_sync_sb(struct super_block *sb, int type)
+void sync_quota_sb(struct super_block *sb, int type)
 {
 	int cnt;
 
+	if (!sb->s_qcop->quota_sync)
+		return;
+
 	sb->s_qcop->quota_sync(sb, type);
 
 	if (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE)
@@ -192,16 +195,11 @@ static void quota_sync_sb(struct super_block *sb, int type)
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 }
 
-void sync_dquots(struct super_block *sb, int type)
+static void sync_dquots(int type)
 {
+	struct super_block *sb;
 	int cnt;
 
-	if (sb) {
-		if (sb->s_qcop->quota_sync)
-			quota_sync_sb(sb, type);
-		return;
-	}
-
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
@@ -222,8 +220,8 @@ restart:
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
-		if (sb->s_root && sb->s_qcop->quota_sync)
-			quota_sync_sb(sb, type);
+		if (sb->s_root)
+			sync_quota_sb(sb, type);
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
 		if (__put_super_and_need_restart(sb))
@@ -301,7 +299,10 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 			return sb->s_qcop->set_dqblk(sb, type, id, &idq);
 		}
 		case Q_SYNC:
-			sync_dquots(sb, type);
+			if (sb)
+				sync_quota_sb(sb, type);
+			else
+				sync_dquots(type);
 			return 0;
 
 		case Q_XQUOTAON:
diff --git a/fs/sync.c b/fs/sync.c
index c3ef04e..4914f0a 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -26,7 +26,7 @@
  */
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
-	vfs_dq_sync(sb);
+	sync_quota_sb(sb, -1);
 	sync_inodes_sb(sb, wait);
 	lock_super(sb);
 	if (sb->s_dirt && sb->s_op->write_super)
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 36353d9..047310f 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -20,7 +20,7 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 /*
  * declaration of quota_function calls in kernel.
  */
-void sync_dquots(struct super_block *sb, int type);
+void sync_quota_sb(struct super_block *sb, int type);
 
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
@@ -253,12 +253,7 @@ static inline void vfs_dq_free_inode(struct inode *inode)
 		inode->i_sb->dq_op->free_inode(inode, 1);
 }
 
-/* The following two functions cannot be called inside a transaction */
-static inline void vfs_dq_sync(struct super_block *sb)
-{
-	sync_dquots(sb, -1);
-}
-
+/* Cannot be called inside a transaction */
 static inline int vfs_dq_off(struct super_block *sb, int remount)
 {
 	int ret = -ENOSYS;
@@ -334,7 +329,7 @@ static inline void vfs_dq_free_inode(struct inode *inode)
 {
 }
 
-static inline void vfs_dq_sync(struct super_block *sb)
+static inline void sync_quota_sb(struct super_block *sb, int type)
 {
 }
 
-- 
1.6.0.2

