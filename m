Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbYLYSGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbYLYSGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYLYSFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbYLYSFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:01 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 04/35] ocfs2: Add a validation hook for quota block reads.
Date: Thu, 25 Dec 2008 10:04:19 -0800
Message-Id: <1230228290-22803-5-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Add a currently-returns-success hook for quota block reads.  We'll be
adding checks to this.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 4b38a2e..5b05f94 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -85,13 +85,25 @@ struct qtree_fmt_operations ocfs2_global_ops = {
 	.is_id = ocfs2_global_is_id,
 };
 
+static int ocfs2_validate_quota_block(struct super_block *sb,
+				      struct buffer_head *bh)
+{
+	struct ocfs2_disk_dqtrailer *dqt = ocfs2_dq_trailer(sb, bh->b_data);
+
+	mlog(0, "Validating quota block %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
+	return 0;
+}
+
 int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 			   struct buffer_head **bh)
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0, NULL);
+	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
+				    ocfs2_validate_quota_block);
 	if (rc)
 		mlog_errno(rc);
 
-- 
1.5.6

