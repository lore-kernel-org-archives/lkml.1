Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYLVVzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYLVVzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYLVVtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYLVVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:16 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 18/56] quota: Implement function for scanning active dquots
Date: Mon, 22 Dec 2008 13:47:59 -0800
Message-Id: <1229982517-3455-19-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

OCFS2 needs to scan all active dquots once in a while and sync quota
information among cluster nodes. Provide a helper function for it so
that it does not have to reimplement internally a list which VFS
already has. Moreover this function is probably going to be useful
for other clustered filesystems if they decide to use VFS quotas.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c               |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/quotaops.h |    3 +++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 8774be6..6f7df91 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -476,6 +476,41 @@ restart:
 	spin_unlock(&dq_list_lock);
 }
 
+/* Call callback for every active dquot on given filesystem */
+int dquot_scan_active(struct super_block *sb,
+		      int (*fn)(struct dquot *dquot, unsigned long priv),
+		      unsigned long priv)
+{
+	struct dquot *dquot, *old_dquot = NULL;
+	int ret = 0;
+
+	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
+	spin_lock(&dq_list_lock);
+	list_for_each_entry(dquot, &inuse_list, dq_inuse) {
+		if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
+			continue;
+		if (dquot->dq_sb != sb)
+			continue;
+		/* Now we have active dquot so we can just increase use count */
+		atomic_inc(&dquot->dq_count);
+		dqstats.lookups++;
+		spin_unlock(&dq_list_lock);
+		dqput(old_dquot);
+		old_dquot = dquot;
+		ret = fn(dquot, priv);
+		if (ret < 0)
+			goto out;
+		spin_lock(&dq_list_lock);
+		/* We are safe to continue now because our dquot could not
+		 * be moved out of the inuse list while we hold the reference */
+	}
+	spin_unlock(&dq_list_lock);
+out:
+	dqput(old_dquot);
+	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+	return ret;
+}
+
 int vfs_quota_sync(struct super_block *sb, int type)
 {
 	struct list_head *dirty;
@@ -2318,6 +2353,7 @@ EXPORT_SYMBOL(vfs_quota_on_path);
 EXPORT_SYMBOL(vfs_quota_on_mount);
 EXPORT_SYMBOL(vfs_quota_disable);
 EXPORT_SYMBOL(vfs_quota_off);
+EXPORT_SYMBOL(dquot_scan_active);
 EXPORT_SYMBOL(vfs_quota_sync);
 EXPORT_SYMBOL(vfs_get_dqinfo);
 EXPORT_SYMBOL(vfs_set_dqinfo);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index e3a1027..f491394 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -28,6 +28,9 @@ int dquot_drop_locked(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
 void dqput(struct dquot *dquot);
 int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
+int dquot_scan_active(struct super_block *sb,
+		      int (*fn)(struct dquot *dquot, unsigned long priv),
+		      unsigned long priv);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.5.6

