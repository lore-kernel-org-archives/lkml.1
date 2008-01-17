Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYAQWno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYAQWno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbYAQWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10833 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbYAQWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:42 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 21/30] ocfs2: Safer read_inline_data()
Date: Thu, 17 Jan 2008 14:35:47 -0800
Message-Id: <1200609356-17788-22-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

In ocfs2_read_inline_data() we should store file size in loff_t. Although
the file size should fit in 32 bits we cannot be sure in case filesystem is
corrupted.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 2a0eaac..865684f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -217,7 +217,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 			   struct buffer_head *di_bh)
 {
 	void *kaddr;
-	unsigned int size;
+	loff_t size;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)) {
@@ -231,8 +231,9 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	if (size > PAGE_CACHE_SIZE ||
 	    size > ocfs2_max_inline_data(inode->i_sb)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %llu has with inline data has bad size: %u",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno, size);
+			    "Inode %llu has with inline data has bad size: %Lu",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    (unsigned long long)size);
 		return -EROFS;
 	}
 
-- 
1.5.3.6

