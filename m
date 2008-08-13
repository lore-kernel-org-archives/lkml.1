Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYHMIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYHMIl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYHMIj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37127 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYHMIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:26 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: do not write orphans back
Date: Wed, 13 Aug 2008 13:17:38 +0300
Message-Id: <1218622675-28853-10-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0316 (UTC) FILETIME=[0A456540:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Orphan inodes are deleted inodes which will disappear after FS
re-mount. There is not need to write orphan inodes back, because
they are not needed on the flash media.

So optimize orphans a little by not writing them back. Just mark
them as clean, free the budget, and report success to VFS.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 884beed..13e90b0 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -278,7 +278,7 @@ static void ubifs_destroy_inode(struct inode *inode)
  */
 static int ubifs_write_inode(struct inode *inode, int wait)
 {
-	int err;
+	int err = 0;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
@@ -299,10 +299,18 @@ static int ubifs_write_inode(struct inode *inode, int wait)
 		return 0;
 	}
 
-	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	err = ubifs_jnl_write_inode(c, inode, 0);
-	if (err)
-		ubifs_err("can't write inode %lu, error %d", inode->i_ino, err);
+	/*
+	 * As an optimization, do not write orphan inodes to the media just
+	 * because this is not needed.
+	 */
+	dbg_gen("inode %lu, mode %#x, nlink %u",
+		inode->i_ino, (int)inode->i_mode, inode->i_nlink);
+	if (inode->i_nlink) {
+		err = ubifs_jnl_write_inode(c, inode, 0);
+		if (err)
+			ubifs_err("can't write inode %lu, error %d",
+				  inode->i_ino, err);
+	}
 
 	ui->dirty = 0;
 	mutex_unlock(&ui->ui_mutex);
-- 
1.5.4.1

