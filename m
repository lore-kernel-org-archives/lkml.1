Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbXFQTPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbXFQTPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761308AbXFQTKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:39 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36887 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761197AbXFQTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/16] Unionfs: call statfs on lower file system properly
Date: Sun, 17 Jun 2007 15:09:12 -0400
Message-Id: <11821073632124-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Get the correct lower dentry to use to statfs the first branch (always),

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index b3a5e64..a7ff06c 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -112,18 +112,23 @@ static void unionfs_put_super(struct super_block *sb)
 static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	int err	= 0;
-	struct super_block *sb, *hidden_sb;
+	struct super_block *sb;
+	struct dentry *lower_dentry;
 
 	BUG_ON(!is_valid_dentry(dentry));
 
 	sb = dentry->d_sb;
 
-	unionfs_read_lock(sb);
-	hidden_sb = unionfs_lower_super_idx(sb, sbstart(sb));
-	unionfs_read_unlock(sb);
-	err = vfs_statfs(hidden_sb->s_root, buf);
+	lower_dentry = unionfs_lower_dentry(sb->s_root);
+	err = vfs_statfs(lower_dentry, buf);
 
+	/* set return buf to our f/s to avoid confusing user-level utils */
 	buf->f_type = UNIONFS_SUPER_MAGIC;
+
+	/*
+	 * Our maximum file name can is shorter by a few bytes because every
+	 * file name could potentially be whited-out.
+	 */
 	buf->f_namelen -= UNIONFS_WHLEN;
 
 	memset(&buf->f_fsid, 0, sizeof(__kernel_fsid_t));
-- 
1.5.2.rc1.165.gaf9b

