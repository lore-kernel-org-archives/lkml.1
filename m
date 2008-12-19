Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYLSV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYLSV6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYLSVyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:48924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYLSVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:30 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 13/45] ocfs2: Use buckets in ocfs2_xattr_set_entry_in_bucket().
Date: Fri, 19 Dec 2008 13:53:32 -0800
Message-Id: <1229723644-13630-14-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

The ocfs2_xattr_set_entry_in_bucket() function is already working on an
ocfs2_xattr_bucket structure, so let's use the bucket API.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 127a628..029a9f4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4083,25 +4083,24 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 {
 	int ret;
 	handle_t *handle = NULL;
-	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u64 blkno;
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
 	     (unsigned long)xi->value_len, xi->name_index,
 	     (unsigned long long)bucket_blkno(xs->bucket));
 
 	if (!xs->bucket->bu_bhs[1]) {
-		ret = ocfs2_read_blocks(inode,
-					bucket_blkno(xs->bucket) + 1,
-					blk_per_bucket - 1, &xs->bucket->bu_bhs[1],
-					0);
+		blkno = bucket_blkno(xs->bucket);
+		ocfs2_xattr_bucket_relse(xs->bucket);
+		ret = ocfs2_read_xattr_bucket(xs->bucket, blkno);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, blk_per_bucket);
+	handle = ocfs2_start_trans(osb, xs->bucket->bu_blocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		handle = NULL;
-- 
1.5.6

