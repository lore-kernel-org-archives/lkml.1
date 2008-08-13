Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYHMIqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYHMIqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbYHMIjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37196 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbYHMIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:40 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: improve debugging
Date: Wed, 13 Aug 2008 13:17:33 +0300
Message-Id: <1218622675-28853-5-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0175 (UTC) FILETIME=[0A2FE170:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

1. Print inode mode in some of debugging messages
2. Add few more useful assertions

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/file.c  |    3 ++-
 fs/ubifs/super.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 8565e58..01598f2 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -941,7 +941,8 @@ int ubifs_setattr(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 
-	dbg_gen("ino %lu, ia_valid %#x", inode->i_ino, attr->ia_valid);
+	dbg_gen("ino %lu, mode %#x, ia_valid %#x",
+		inode->i_ino, inode->i_mode, attr->ia_valid);
 	err = inode_change_ok(inode, attr);
 	if (err)
 		return err;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 43af934..06e3b22 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -299,7 +299,7 @@ static int ubifs_write_inode(struct inode *inode, int wait)
 		return 0;
 	}
 
-	dbg_gen("inode %lu", inode->i_ino);
+	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
 	err = ubifs_jnl_write_inode(c, inode, 0);
 	if (err)
 		ubifs_err("can't write inode %lu, error %d", inode->i_ino, err);
@@ -323,9 +323,10 @@ static void ubifs_delete_inode(struct inode *inode)
 		 */
 		goto out;
 
-	dbg_gen("inode %lu", inode->i_ino);
+	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
 	ubifs_assert(!atomic_read(&inode->i_count));
 	ubifs_assert(inode->i_nlink == 0);
+	ubifs_assert(!ubifs_inode(inode)->dirty);
 
 	truncate_inode_pages(&inode->i_data, 0);
 	if (is_bad_inode(inode))
@@ -1469,6 +1470,7 @@ static void ubifs_put_super(struct super_block *sb)
 	 */
 	ubifs_assert(atomic_long_read(&c->dirty_pg_cnt) == 0);
 	ubifs_assert(c->budg_idx_growth == 0);
+	ubifs_assert(c->budg_dd_growth == 0);
 	ubifs_assert(c->budg_data_growth == 0);
 
 	/*
-- 
1.5.4.1

