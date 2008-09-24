Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYIXWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYIXWN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYIXWCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:02:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYIXWAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:44 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 34/39] ocfs2: bug-fix for journal extend in xattr.
Date: Wed, 24 Sep 2008 15:01:15 -0700
Message-Id: <1222293680-15451-35-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

In ocfs2_extend_trans, when we can't extend the current
transaction, it will commit current transaction and restart
a new one. So if the previous credits we have allocated aren't
used(the block isn't dirtied before our extend), we will not
have enough credits for any future operation(it will cause jbd
complain and bug out). So check this and re-extend it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1a4de3d..38e3e5e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1336,8 +1336,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		/*set extended attribue in external blcok*/
+		/* set extended attribute in external block. */
 		ret = ocfs2_extend_trans(handle,
+					 OCFS2_INODE_UPDATE_CREDITS +
 					 OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
 		if (ret) {
 			mlog_errno(ret);
@@ -3701,6 +3702,18 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 
+	if (handle->h_buffer_credits < credits) {
+		/*
+		 * The journal has been restarted before, and don't
+		 * have enough space for the insertion, so extend it
+		 * here.
+		 */
+		ret = ocfs2_extend_trans(handle, credits);
+		if (ret) {
+			mlog_errno(ret);
+			goto leave;
+		}
+	}
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
-- 
1.5.4.5

