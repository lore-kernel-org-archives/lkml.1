Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHMIjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHMIjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYHMIjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37063 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYHMIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:15 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: fix budgeting calculations
Date: Wed, 13 Aug 2008 13:17:32 +0300
Message-Id: <1218622675-28853-4-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0144 (UTC) FILETIME=[0A2B2680:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'ubifs_release_dirty_inode_budget()' was buggy and incorrectly
freed the budget, which led to not freeing all dirty data budget.
This patch fixes that.

Also, this patch fixes ubifs_mkdir() which passed 1 in dirty_ino_d,
which makes no sense. Well, it is harmless though.

Also, add few more useful assertions. And improve few debugging
messages.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |    5 +++--
 fs/ubifs/dir.c    |    3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index d81fb9e..12a1717 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -686,9 +686,10 @@ void ubifs_convert_page_budget(struct ubifs_info *c)
 void ubifs_release_dirty_inode_budget(struct ubifs_info *c,
 				      struct ubifs_inode *ui)
 {
-	struct ubifs_budget_req req = {.dd_growth = c->inode_budget,
-				       .dirtied_ino_d = ui->data_len};
+	struct ubifs_budget_req req;
 
+	memset(&req, 0, sizeof(struct ubifs_budget_req));
+	req.dd_growth = c->inode_budget + ui->data_len;
 	ubifs_release_budget(c, &req);
 }
 
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index e90374b..a79e850 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -727,8 +727,7 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.dirtied_ino_d = 1 };
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
 
 	/*
 	 * Budget request settings: new inode, new direntry and changing parent
-- 
1.5.4.1

