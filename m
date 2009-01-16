Return-Path: <linux-kernel-owner+w=401wt.eu-S936710AbZAPSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936710AbZAPSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763957AbZAPSJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:09:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:47997 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761814AbZAPSIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:23 -0500
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH 10/11] ext4: Remove unnecessary quota functions
Date: Fri, 16 Jan 2009 19:08:18 +0100
Message-Id: <1232129299-22018-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232129299-22018-10-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
 <1232129299-22018-4-git-send-email-jack@suse.cz>
 <1232129299-22018-5-git-send-email-jack@suse.cz>
 <1232129299-22018-6-git-send-email-jack@suse.cz>
 <1232129299-22018-7-git-send-email-jack@suse.cz>
 <1232129299-22018-8-git-send-email-jack@suse.cz>
 <1232129299-22018-9-git-send-email-jack@suse.cz>
 <1232129299-22018-10-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_dquot_initialize() and ext4_dquot_drop() is no longer
needed because of modified quota locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   44 ++------------------------------------------
 1 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e5f06a5..f0785fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -926,8 +926,6 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page, gfp_
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
 #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
 
-static int ext4_dquot_initialize(struct inode *inode, int type);
-static int ext4_dquot_drop(struct inode *inode);
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
 static int ext4_release_dquot(struct dquot *dquot);
@@ -942,8 +940,8 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
 static struct dquot_operations ext4_quota_operations = {
-	.initialize	= ext4_dquot_initialize,
-	.drop		= ext4_dquot_drop,
+	.initialize	= dquot_initialize,
+	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
@@ -3378,44 +3376,6 @@ static inline struct inode *dquot_to_inode(struct dquot *dquot)
 	return sb_dqopt(dquot->dq_sb)->files[dquot->dq_type];
 }
 
-static int ext4_dquot_initialize(struct inode *inode, int type)
-{
-	handle_t *handle;
-	int ret, err;
-
-	/* We may create quota structure so we need to reserve enough blocks */
-	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_INIT_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
-	ret = dquot_initialize(inode, type);
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
-	return ret;
-}
-
-static int ext4_dquot_drop(struct inode *inode)
-{
-	handle_t *handle;
-	int ret, err;
-
-	/* We may delete quota structure so we need to reserve enough blocks */
-	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle)) {
-		/*
-		 * We call dquot_drop() anyway to at least release references
-		 * to quota structures so that umount does not hang.
-		 */
-		dquot_drop(inode);
-		return PTR_ERR(handle);
-	}
-	ret = dquot_drop(inode);
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
-	return ret;
-}
-
 static int ext4_write_dquot(struct dquot *dquot)
 {
 	int ret, err;
-- 
1.6.0.2

