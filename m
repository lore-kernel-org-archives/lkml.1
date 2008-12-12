Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYLLFWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYLLFWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbYLLFVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:21:33 -0500
Received: from sh.osrg.net ([192.16.179.4]:37939 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbYLLFV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:21:29 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 2/5] nilfs2: cleanup nilfs_clear_inode
Date: Fri, 12 Dec 2008 14:16:58 +0900
Message-Id: <1229059021-9538-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will remove the following unnecessary locks and cleanup code in
nilfs_clear_inode():

- unnecessary protection using nilfs_transaction_begin() and
  nilfs_transaction_end().

- cleanup code of i_dirty list field which is never chained
  when this function is called.

- spinlock used when releasing i_bh field.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 046368b..6d5ca65 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -184,8 +184,6 @@ static inline void nilfs_destroy_inode_cache(void)
 static void nilfs_clear_inode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct nilfs_transaction_info ti;
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 
 #ifdef CONFIG_NILFS_POSIX_ACL
 	if (ii->i_acl && ii->i_acl != NILFS_ACL_NOT_CACHED) {
@@ -200,21 +198,14 @@ static void nilfs_clear_inode(struct inode *inode)
 	/*
 	 * Free resources allocated in nilfs_read_inode(), here.
 	 */
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-
-	spin_lock(&sbi->s_inode_lock);
-	if (!list_empty(&ii->i_dirty))
-		list_del_init(&ii->i_dirty);
+	BUG_ON(!list_empty(&ii->i_dirty));
 	brelse(ii->i_bh);
 	ii->i_bh = NULL;
-	spin_unlock(&sbi->s_inode_lock);
 
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
-
-	nilfs_transaction_end(inode->i_sb, 0);
 }
 
 /**
-- 
1.5.6.5

