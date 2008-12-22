Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYLVWEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYLVWEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYLVVuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:38703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbYLVVuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:05 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 43/56] ocfs2: Narrow the transaction for deleting xattrs from a bucket.
Date: Mon, 22 Dec 2008 13:48:24 -0800
Message-Id: <1229982517-3455-44-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

We move the transaction into the loop because in
ocfs2_remove_extent, we will double the credits in function
ocfs2_extend_rotate_transaction. So if we have a large loop
number, we will soon waste much the journal space.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 6db68a2..df53a2c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5094,30 +5094,30 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(ctxt.handle)) {
-		ret = PTR_ERR(ctxt.handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
+		ctxt.handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(ctxt.handle)) {
+			ret = PTR_ERR(ctxt.handle);
+			mlog_errno(ret);
+			break;
+		}
+
 		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
+
+		ocfs2_commit_trans(osb, ctxt.handle);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
-	ret = ocfs2_commit_trans(osb, ctxt.handle);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
-out:
 	return ret;
 }
 
-- 
1.5.6

