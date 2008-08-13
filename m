Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYHMIpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYHMIpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbYHMIjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31916 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbYHMIji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:38 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: free budget in delete_inode as well
Date: Wed, 13 Aug 2008 13:17:34 +0300
Message-Id: <1218622675-28853-6-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0206 (UTC) FILETIME=[0A349C60:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Although the inode is marked as clean when it is being deleted,
it might stay and be used as orphan, and be marked as dirty.
So we have to free the budget when we delete it.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 06e3b22..884beed 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -314,8 +314,9 @@ static void ubifs_delete_inode(struct inode *inode)
 {
 	int err;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	struct ubifs_inode *ui = ubifs_inode(inode);
 
-	if (ubifs_inode(inode)->xattr)
+	if (ui->xattr)
 		/*
 		 * Extended attribute inode deletions are fully handled in
 		 * 'ubifs_removexattr()'. These inodes are special and have
@@ -326,13 +327,12 @@ static void ubifs_delete_inode(struct inode *inode)
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
 	ubifs_assert(!atomic_read(&inode->i_count));
 	ubifs_assert(inode->i_nlink == 0);
-	ubifs_assert(!ubifs_inode(inode)->dirty);
 
 	truncate_inode_pages(&inode->i_data, 0);
 	if (is_bad_inode(inode))
 		goto out;
 
-	ubifs_inode(inode)->ui_size = inode->i_size = 0;
+	ui->ui_size = inode->i_size = 0;
 	err = ubifs_jnl_write_inode(c, inode, 1);
 	if (err)
 		/*
@@ -341,6 +341,8 @@ static void ubifs_delete_inode(struct inode *inode)
 		 */
 		ubifs_err("can't write inode %lu, error %d", inode->i_ino, err);
 out:
+	if (ui->dirty)
+		ubifs_release_dirty_inode_budget(c, ui);
 	clear_inode(inode);
 }
 
-- 
1.5.4.1

