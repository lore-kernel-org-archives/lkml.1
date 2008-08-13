Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYHMIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYHMIoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYHMIjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31898 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbYHMIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:33 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: align inode data to eight
Date: Wed, 13 Aug 2008 13:17:47 +0300
Message-Id: <1218622675-28853-19-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0800 (UTC) FILETIME=[0A8F3F80:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

UBIFS aligns node lengths to 8, so budgeting has to do the
same. Well, direntry, inode, and page budgets are already
aligned, but not inode data budget (e.g., data in special
devices or symlinks). Do this for inode data as well.
Also, add corresponding debugging checks.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |   10 +++++++++-
 fs/ubifs/dir.c    |   10 ++++++----
 fs/ubifs/file.c   |    4 ++--
 fs/ubifs/ubifs.h  |    4 ++++
 fs/ubifs/xattr.c  |    4 ++--
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index f5afce5..a3978ba 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -551,6 +551,8 @@ int ubifs_budget_space(struct ubifs_info *c, struct ubifs_budget_req *req)
 	ubifs_assert(req->new_ino_d <= UBIFS_MAX_INO_DATA);
 	ubifs_assert(req->dirtied_ino <= 4);
 	ubifs_assert(req->dirtied_ino_d <= UBIFS_MAX_INO_DATA * 4);
+	ubifs_assert(!(req->new_ino_d & 7));
+	ubifs_assert(!(req->dirtied_ino_d & 7));
 
 	data_growth = calc_data_growth(c, req);
 	dd_growth = calc_dd_growth(c, req);
@@ -632,6 +634,8 @@ void ubifs_release_budget(struct ubifs_info *c, struct ubifs_budget_req *req)
 	ubifs_assert(req->new_ino_d <= UBIFS_MAX_INO_DATA);
 	ubifs_assert(req->dirtied_ino <= 4);
 	ubifs_assert(req->dirtied_ino_d <= UBIFS_MAX_INO_DATA * 4);
+	ubifs_assert(!(req->new_ino_d & 7));
+	ubifs_assert(!(req->dirtied_ino_d & 7));
 	if (!req->recalculate) {
 		ubifs_assert(req->idx_growth >= 0);
 		ubifs_assert(req->data_growth >= 0);
@@ -659,7 +663,11 @@ void ubifs_release_budget(struct ubifs_info *c, struct ubifs_budget_req *req)
 
 	ubifs_assert(c->budg_idx_growth >= 0);
 	ubifs_assert(c->budg_data_growth >= 0);
+	ubifs_assert(c->budg_dd_growth >= 0);
 	ubifs_assert(c->min_idx_lebs < c->main_lebs);
+	ubifs_assert(!(c->budg_idx_growth & 7));
+	ubifs_assert(!(c->budg_data_growth & 7));
+	ubifs_assert(!(c->budg_dd_growth & 7));
 	spin_unlock(&c->space_lock);
 }
 
@@ -701,7 +709,7 @@ void ubifs_release_dirty_inode_budget(struct ubifs_info *c,
 	struct ubifs_budget_req req;
 
 	memset(&req, 0, sizeof(struct ubifs_budget_req));
-	req.dd_growth = c->inode_budget + ui->data_len;
+	req.dd_growth = c->inode_budget + ALIGN(ui->data_len, 8);
 	ubifs_release_budget(c, &req);
 }
 
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a79e850..eba3a8a 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -525,7 +525,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
 	struct ubifs_budget_req req = { .new_dent = 1, .dirtied_ino = 2,
-					.dirtied_ino_d = ui->data_len };
+				.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 
 	/*
 	 * Budget request settings: new direntry, changing the target inode,
@@ -788,7 +788,8 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
 	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
 	int err, devlen = 0;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = devlen, .dirtied_ino = 1 };
+					.new_ino_d = ALIGN(devlen, 8),
+					.dirtied_ino = 1 };
 
 	/*
 	 * Budget request settings: new inode, new direntry and changing parent
@@ -862,7 +863,8 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, len = strlen(symname);
 	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = len, .dirtied_ino = 1 };
+					.new_ino_d = ALIGN(len, 8),
+					.dirtied_ino = 1 };
 
 	/*
 	 * Budget request settings: new inode, new direntry and changing parent
@@ -1011,7 +1013,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ubifs_budget_req req = { .new_dent = 1, .mod_dent = 1,
 					.dirtied_ino = 3 };
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
-				.dirtied_ino_d = old_inode_ui->data_len };
+			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
 
 	/*
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 01598f2..9fecab2 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -890,7 +890,7 @@ static int do_setattr(struct ubifs_info *c, struct inode *inode,
 	loff_t new_size = attr->ia_size;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	struct ubifs_budget_req req = { .dirtied_ino = 1,
-					.dirtied_ino_d = ui->data_len };
+				.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 
 	err = ubifs_budget_space(c, &req);
 	if (err)
@@ -1052,7 +1052,7 @@ static int update_mctime(struct ubifs_info *c, struct inode *inode)
 	if (mctime_update_needed(inode, &now)) {
 		int err, release;
 		struct ubifs_budget_req req = { .dirtied_ino = 1,
-						.dirtied_ino_d = ui->data_len };
+				.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 
 		err = ubifs_budget_space(c, &req);
 		if (err)
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 565dca2..73ca8a0 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -808,6 +808,10 @@ struct ubifs_compressor {
  * An inode may contain 4KiB of data at max., thus the widths of @new_ino_d
  * is 13 bits, and @dirtied_ino_d - 15, because up to 4 inodes may be made
  * dirty by the re-name operation.
+ *
+ * Note, UBIFS aligns node lengths to 8-bytes boundary, so the requester has to
+ * make sure the amount of inode data which contribute to @new_ino_d and
+ * @dirtied_ino_d fields are aligned.
  */
 struct ubifs_budget_req {
 	unsigned int fast:1;
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 1388a07..39e831d 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -103,8 +103,8 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	struct inode *inode;
 	struct ubifs_inode *ui, *host_ui = ubifs_inode(host);
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = size, .dirtied_ino = 1,
-					.dirtied_ino_d = host_ui->data_len};
+				.new_ino_d = size, .dirtied_ino = 1,
+				.dirtied_ino_d = ALIGN(host_ui->data_len, 8)};
 
 	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
 		return -ENOSPC;
-- 
1.5.4.1

