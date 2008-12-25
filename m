Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbYLYSIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbYLYSIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYLYSFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:60629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYLYSFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:10 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 09/35] ocfs2: Add ecc and checksums to ocfs2 xattr buckets.
Date: Thu, 25 Dec 2008 10:04:24 -0800
Message-Id: <1230228290-22803-10-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

The xattr bucket can span multiple blocks on disk.  We have wrappers
for this structure in the code.  We use the new multi-block ecc calls to
calculate and validate the bucket.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bc822d6..7c2f4c9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -273,6 +273,15 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	rc = ocfs2_read_blocks(bucket->bu_inode, xb_blkno,
 			       bucket->bu_blocks, bucket->bu_bhs, 0,
 			       NULL);
+	if (!rc) {
+		rc = ocfs2_validate_meta_ecc_bhs(bucket->bu_inode->i_sb,
+						 bucket->bu_bhs,
+						 bucket->bu_blocks,
+						 &bucket_xh(bucket)->xh_check);
+		if (rc)
+			mlog_errno(rc);
+	}
+
 	if (rc)
 		ocfs2_xattr_bucket_relse(bucket);
 	return rc;
@@ -301,6 +310,10 @@ static void ocfs2_xattr_bucket_journal_dirty(handle_t *handle,
 {
 	int i;
 
+	ocfs2_compute_meta_ecc_bhs(bucket->bu_inode->i_sb,
+				   bucket->bu_bhs, bucket->bu_blocks,
+				   &bucket_xh(bucket)->xh_check);
+
 	for (i = 0; i < bucket->bu_blocks; i++)
 		ocfs2_journal_dirty(handle, bucket->bu_bhs[i]);
 }
-- 
1.5.6

