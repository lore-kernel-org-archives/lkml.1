Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbZD3Ryy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbZD3Ryy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933047AbZD3RbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:31:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbZD3RbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:31:20 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] Use feature code to eliminate quota pointers from inodes for filesystems that don't need it.
Date: Thu, 30 Apr 2009 19:31:18 +0200
Message-Id: <1241112678-6615-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241112678-6615-1-git-send-email-jack@suse.cz>
References: <1241112678-6615-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h     |    1 +
 fs/ext2/super.c    |    5 ++
 fs/inode.c         |    7 ++-
 fs/nilfs2/mdt.c    |    3 -
 fs/quota/dquot.c   |  134 ++++++++++++++++++++++++++++++----------------------
 include/linux/fs.h |   10 +++-
 6 files changed, 97 insertions(+), 63 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 3203042..1e19e17 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -62,6 +62,7 @@ struct ext2_inode_info {
 	struct mutex truncate_mutex;
 	struct inode	vfs_inode;
 	struct list_head i_orphan;	/* unlinked but open inodes */
+	struct inode_quota i_quota;
 };
 
 /*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f983225..6c3dcc7 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -32,6 +32,7 @@
 #include <linux/mount.h>
 #include <linux/log2.h>
 #include <linux/quotaops.h>
+#include <linux/struct_feature.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -139,6 +140,9 @@ static void ext2_put_super (struct super_block * sb)
 }
 
 static struct kmem_cache * ext2_inode_cachep;
+static int ext2_i_features[INODE_FEATURES] = {
+	[INODE_QUOTA] = FEATURE_OFFSET(struct ext2_inode_info, vfs_inode, i_quota),
+};
 
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
@@ -152,6 +156,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 #endif
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+	ei->vfs_inode.feature_table = ext2_i_features;
 	return &ei->vfs_inode;
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index 6ad14a1..0761e5b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/inotify.h>
 #include <linux/mount.h>
 #include <linux/async.h>
+#include <linux/struct_feature.h>
 
 /*
  * This is needed for the following functions:
@@ -141,7 +142,11 @@ struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
 #ifdef CONFIG_QUOTA
-	memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
+	{
+		struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
+		if (iq)
+			memset(iq, 0, sizeof(*iq));
+	}
 #endif
 	inode->i_pipe = NULL;
 	inode->i_bdev = NULL;
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 47dd815..725cd80 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -478,9 +478,6 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		inode->i_blocks = 0;
 		inode->i_bytes = 0;
 		inode->i_generation = 0;
-#ifdef CONFIG_QUOTA
-		memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
-#endif
 		inode->i_pipe = NULL;
 		inode->i_bdev = NULL;
 		inode->i_cdev = NULL;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 607c579..d1ce6b8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -77,6 +77,7 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#include <linux/struct_feature.h>
 #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -804,14 +805,15 @@ EXPORT_SYMBOL(dqget);
 
 static int dqinit_needed(struct inode *inode, int type)
 {
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 	int cnt;
 
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		return 0;
 	if (type != -1)
-		return !inode->i_dquot[type];
+		return !iq->dquot[type];
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			return 1;
 	return 0;
 }
@@ -866,9 +868,13 @@ static inline int dqput_blocks(struct dquot *dquot)
 static int remove_inode_dquot_ref(struct inode *inode, int type,
 				  struct list_head *tofree_head)
 {
-	struct dquot *dquot = inode->i_dquot[type];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
+	struct dquot *dquot;
 
-	inode->i_dquot[type] = NULL;
+	if (!iq)
+		return 0;
+	dquot = iq->dquot[type];
+	iq->dquot[type] = NULL;
 	if (dquot) {
 		if (dqput_blocks(dquot)) {
 #ifdef __DQUOT_PARANOIA
@@ -1298,10 +1304,11 @@ int dquot_initialize(struct inode *inode, int type)
 	int cnt, ret = 0;
 	struct dquot *got[MAXQUOTAS] = { NULL, NULL };
 	struct super_block *sb = inode->i_sb;
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		return 0;
 
 	/* First get references to structures we might need. */
@@ -1329,8 +1336,8 @@ int dquot_initialize(struct inode *inode, int type)
 		/* Avoid races with quotaoff() */
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
-		if (!inode->i_dquot[cnt]) {
-			inode->i_dquot[cnt] = got[cnt];
+		if (!iq->dquot[cnt]) {
+			iq->dquot[cnt] = got[cnt];
 			got[cnt] = NULL;
 		}
 	}
@@ -1350,11 +1357,15 @@ int dquot_drop(struct inode *inode)
 {
 	int cnt;
 	struct dquot *put[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
+
+	if (!iq)
+		return 0;
 
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		put[cnt] = inode->i_dquot[cnt];
-		inode->i_dquot[cnt] = NULL;
+		put[cnt] = iq->dquot[cnt];
+		iq->dquot[cnt] = NULL;
 	}
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 
@@ -1373,13 +1384,17 @@ void vfs_dq_drop(struct inode *inode)
 	if (!IS_NOQUOTA(inode) && inode->i_sb && inode->i_sb->dq_op
 	    && inode->i_sb->dq_op->drop) {
 		int cnt;
+		struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
+
 		/* Test before calling to rule out calls from proc and such
                  * where we are not allowed to block. Note that this is
 		 * actually reliable test even without the lock - the caller
 		 * must assure that nobody can come after the DQUOT_DROP and
 		 * add quota pointers back anyway */
+		if (!iq)
+			return;
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt])
+			if (iq->dquot[cnt])
 				break;
 		if (cnt < MAXQUOTAS)
 			inode->i_sb->dq_op->drop(inode);
@@ -1399,50 +1414,52 @@ EXPORT_SYMBOL(vfs_dq_drop);
 /*
  * This operation can block, but only after everything is updated
  */
-int __dquot_alloc_space(struct inode *inode, qsize_t number,
-			int warn, int reserve)
+static int __dquot_alloc_space(struct inode *inode, qsize_t number,
+			       int warn, int reserve)
 {
 	int cnt, ret = QUOTA_OK;
 	char warntype[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
-		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
+		if (check_bdq(iq->dquot[cnt], number, warn, warntype+cnt)
 		    == NO_QUOTA) {
 			ret = NO_QUOTA;
 			goto out_unlock;
 		}
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
 		if (reserve)
-			dquot_resv_space(inode->i_dquot[cnt], number);
+			dquot_resv_space(iq->dquot[cnt], number);
 		else
-			dquot_incr_space(inode->i_dquot[cnt], number);
+			dquot_incr_space(iq->dquot[cnt], number);
 	}
 	if (!reserve)
 		inode_add_bytes(inode, number);
 out_unlock:
 	spin_unlock(&dq_data_lock);
-	flush_warnings(inode->i_dquot, warntype);
+	flush_warnings(iq->dquot, warntype);
 	return ret;
 }
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
 {
 	int cnt, ret = QUOTA_OK;
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
 	 * re-enter the quota code and are already holding the mutex
 	 */
-	if (IS_NOQUOTA(inode)) {
+	if (IS_NOQUOTA(inode) || !iq) {
 		inode_add_bytes(inode, number);
 		goto out;
 	}
@@ -1459,8 +1476,8 @@ int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
 
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (inode->i_dquot[cnt])
-			mark_dquot_dirty(inode->i_dquot[cnt]);
+		if (iq->dquot[cnt])
+			mark_dquot_dirty(iq->dquot[cnt]);
 out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 out:
@@ -1494,10 +1511,11 @@ int dquot_alloc_inode(const struct inode *inode, qsize_t number)
 {
 	int cnt, ret = NO_QUOTA;
 	char warntype[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		return QUOTA_OK;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
@@ -1508,17 +1526,17 @@ int dquot_alloc_inode(const struct inode *inode, qsize_t number)
 	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
-		if (check_idq(inode->i_dquot[cnt], number, warntype+cnt)
+		if (check_idq(iq->dquot[cnt], number, warntype+cnt)
 		    == NO_QUOTA)
 			goto warn_put_all;
 	}
 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
-		dquot_incr_inodes(inode->i_dquot[cnt], number);
+		dquot_incr_inodes(iq->dquot[cnt], number);
 	}
 	ret = QUOTA_OK;
 warn_put_all:
@@ -1526,9 +1544,9 @@ warn_put_all:
 	if (ret == QUOTA_OK)
 		/* Dirtify all the dquots - this can block when journalling */
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt])
-				mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings(inode->i_dquot, warntype);
+			if (iq->dquot[cnt])
+				mark_dquot_dirty(iq->dquot[cnt]);
+	flush_warnings(iq->dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
@@ -1538,8 +1556,9 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 {
 	int cnt;
 	int ret = QUOTA_OK;
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
-	if (IS_NOQUOTA(inode)) {
+	if (IS_NOQUOTA(inode) || !iq) {
 		inode_add_bytes(inode, number);
 		goto out;
 	}
@@ -1554,17 +1573,16 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
-			dquot_claim_reserved_space(inode->i_dquot[cnt],
-							number);
+		if (iq->dquot[cnt])
+			dquot_claim_reserved_space(iq->dquot[cnt], number);
 	}
 	/* Update inode bytes */
 	inode_add_bytes(inode, number);
 	spin_unlock(&dq_data_lock);
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (inode->i_dquot[cnt])
-			mark_dquot_dirty(inode->i_dquot[cnt]);
+		if (iq->dquot[cnt])
+			mark_dquot_dirty(iq->dquot[cnt]);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 out:
 	return ret;
@@ -1577,8 +1595,9 @@ EXPORT_SYMBOL(dquot_claim_space);
 void dquot_release_reserved_space(struct inode *inode, qsize_t number)
 {
 	int cnt;
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		goto out;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
@@ -1588,8 +1607,8 @@ void dquot_release_reserved_space(struct inode *inode, qsize_t number)
 	spin_lock(&dq_data_lock);
 	/* Release reserved dquots */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
-			dquot_free_reserved_space(inode->i_dquot[cnt], number);
+		if (iq->dquot[cnt])
+			dquot_free_reserved_space(iq->dquot[cnt], number);
 	}
 	spin_unlock(&dq_data_lock);
 
@@ -1607,10 +1626,11 @@ int dquot_free_space(struct inode *inode, qsize_t number)
 {
 	unsigned int cnt;
 	char warntype[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode)) {
+	if (IS_NOQUOTA(inode) || !iq) {
 out_sub:
 		inode_sub_bytes(inode, number);
 		return QUOTA_OK;
@@ -1624,18 +1644,18 @@ out_sub:
 	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
-		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
-		dquot_decr_space(inode->i_dquot[cnt], number);
+		warntype[cnt] = info_bdq_free(iq->dquot[cnt], number);
+		dquot_decr_space(iq->dquot[cnt], number);
 	}
 	inode_sub_bytes(inode, number);
 	spin_unlock(&dq_data_lock);
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (inode->i_dquot[cnt])
-			mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings(inode->i_dquot, warntype);
+		if (iq->dquot[cnt])
+			mark_dquot_dirty(iq->dquot[cnt]);
+	flush_warnings(iq->dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1648,10 +1668,11 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 {
 	unsigned int cnt;
 	char warntype[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		return QUOTA_OK;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
@@ -1662,17 +1683,17 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!iq->dquot[cnt])
 			continue;
-		warntype[cnt] = info_idq_free(inode->i_dquot[cnt], number);
-		dquot_decr_inodes(inode->i_dquot[cnt], number);
+		warntype[cnt] = info_idq_free(iq->dquot[cnt], number);
+		dquot_decr_inodes(iq->dquot[cnt], number);
 	}
 	spin_unlock(&dq_data_lock);
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (inode->i_dquot[cnt])
-			mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings(inode->i_dquot, warntype);
+		if (iq->dquot[cnt])
+			mark_dquot_dirty(iq->dquot[cnt]);
+	flush_warnings(iq->dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1708,10 +1729,11 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	    chgid = iattr->ia_valid & ATTR_GID && inode->i_gid != iattr->ia_gid;
 	char warntype_to[MAXQUOTAS];
 	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
+	struct inode_quota *iq = GET_FEATURE(inode, INODE_QUOTA);
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode))
+	if (IS_NOQUOTA(inode) || !iq)
 		return QUOTA_OK;
 	/* Initialize the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1740,7 +1762,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!transfer_to[cnt])
 			continue;
-		transfer_from[cnt] = inode->i_dquot[cnt];
+		transfer_from[cnt] = iq->dquot[cnt];
 		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
 		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
 		    warntype_to + cnt) == NO_QUOTA)
@@ -1773,7 +1795,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		dquot_incr_space(transfer_to[cnt], cur_space);
 		dquot_resv_space(transfer_to[cnt], rsv_space);
 
-		inode->i_dquot[cnt] = transfer_to[cnt];
+		iq->dquot[cnt] = transfer_to[cnt];
 	}
 	spin_unlock(&dq_data_lock);
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2404b16..beb9aa7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -711,9 +711,16 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
 #endif
 
 enum {
+	INODE_QUOTA,
 	INODE_FEATURES
 };
 
+#ifdef CONFIG_QUOTA
+struct inode_quota {
+	struct dquot		*dquot[MAXQUOTAS];
+};
+#endif
+
 struct inode {
 	struct hlist_node	i_hash;
 	struct list_head	i_list;
@@ -746,9 +753,6 @@ struct inode {
 	struct file_lock	*i_flock;
 	struct address_space	*i_mapping;
 	struct address_space	i_data;
-#ifdef CONFIG_QUOTA
-	struct dquot		*i_dquot[MAXQUOTAS];
-#endif
 	struct list_head	i_devices;
 	union {
 		struct pipe_inode_info	*i_pipe;
-- 
1.6.0.2

