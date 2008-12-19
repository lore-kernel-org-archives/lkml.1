Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYLSWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYLSWJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYLSVz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:55:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbYLSVzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:55:25 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 42/45] ocfs2: Convert ocfs2_read_dir_block() to ocfs2_read_virt_blocks()
Date: Fri, 19 Dec 2008 13:54:01 -0800
Message-Id: <1229723644-13630-43-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Now that we've centralized the ocfs2_read_virt_blocks() code, let's use
it in ocfs2_read_dir_block().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c |   38 +++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7e863d4..d83cff9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -231,44 +231,16 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
-	u64 p_blkno;
 
-	if (((u64)v_block << inode->i_sb->s_blocksize_bits) >=
-	    i_size_read(inode)) {
-		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
-		goto out;
-	}
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	rc = ocfs2_extent_map_get_blocks(inode, v_block, &p_blkno, NULL,
-					 NULL);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (rc) {
+	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, flags,
+				    ocfs2_validate_dir_block);
+	if (rc)
 		mlog_errno(rc);
-		goto out;
-	}
 
-	if (!p_blkno) {
-		rc = -EIO;
-		mlog(ML_ERROR,
-		     "Directory #%llu contains a hole at offset %llu\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     (unsigned long long)v_block << inode->i_sb->s_blocksize_bits);
-		goto out;
-	}
-
-	rc = ocfs2_read_blocks(inode, p_blkno, 1, &tmp, flags,
-			       ocfs2_validate_dir_block);
-	if (rc) {
-		mlog_errno(rc);
-		goto out;
-	}
-
-	/* If ocfs2_read_blocks() got us a new bh, pass it up.  */
-	if (!*bh)
+	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
+	if (!rc && !*bh)
 		*bh = tmp;
 
-out:
 	return rc ? -EIO : 0;
 }
 
-- 
1.5.6

