Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYHMIlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYHMIlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYHMIjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37111 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbYHMIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:24 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: fix budgeting request alignment in xattr code
Date: Wed, 13 Aug 2008 13:17:55 +0300
Message-Id: <1218622675-28853-27-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0644 (UTC) FILETIME=[0B100840:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Sogor <weth@inf.u-szeged.hu>

Data length has to be aligned in the budgeting request. Code
in xattr.c did not do this.

Signed-off-by: Zoltan Sogor <weth@inf.u-szeged.hu>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/xattr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 39e831d..6f493de 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -103,8 +103,8 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	struct inode *inode;
 	struct ubifs_inode *ui, *host_ui = ubifs_inode(host);
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-				.new_ino_d = size, .dirtied_ino = 1,
-				.dirtied_ino_d = ALIGN(host_ui->data_len, 8)};
+				.new_ino_d = ALIGN(size, 8), .dirtied_ino = 1,
+				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
 
 	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
 		return -ENOSPC;
@@ -200,7 +200,7 @@ static int change_xattr(struct ubifs_info *c, struct inode *host,
 	struct ubifs_inode *host_ui = ubifs_inode(host);
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	struct ubifs_budget_req req = { .dirtied_ino = 2,
-				.dirtied_ino_d = size + host_ui->data_len };
+		.dirtied_ino_d = ALIGN(size, 8) + ALIGN(host_ui->data_len, 8) };
 
 	ubifs_assert(ui->data_len == inode->i_size);
 	err = ubifs_budget_space(c, &req);
@@ -497,8 +497,8 @@ static int remove_xattr(struct ubifs_info *c, struct inode *host,
 	int err;
 	struct ubifs_inode *host_ui = ubifs_inode(host);
 	struct ubifs_inode *ui = ubifs_inode(inode);
-	struct ubifs_budget_req req = { .dirtied_ino = 1, .mod_dent = 1,
-					.dirtied_ino_d = host_ui->data_len };
+	struct ubifs_budget_req req = { .dirtied_ino = 2, .mod_dent = 1,
+				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
 
 	ubifs_assert(ui->data_len == inode->i_size);
 
-- 
1.5.4.1

