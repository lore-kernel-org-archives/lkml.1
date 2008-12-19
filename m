Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYLSVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYLSVzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYLSVyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:57938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYLSVyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:14 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 03/45] ocfs2: Convenient access to xattr bucket data blocks.
Date: Fri, 19 Dec 2008 13:53:22 -0800
Message-Id: <1229723644-13630-4-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

The xattr code often wants to access the data pointer for blocks in an
xattr bucket.  This is usually found by dereferencing the bh array
hanging off of the ocfs2_xattr_bucket structure.  Rather than do this
all the time, let's provide a nice little macro.  The idea is ripped
from the ocfs2_path code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3cf8e80..8594df3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -155,6 +155,7 @@ static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
 }
 
 #define bucket_blkno(_b) ((_b)->bu_bhs[0]->b_blocknr)
+#define bucket_block(_b, _n) ((_b)->bu_bhs[(_n)]->b_data)
 
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
@@ -801,7 +802,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 								i,
 								&block_off,
 								&name_offset);
-			xs->base = xs->bucket.bu_bhs[block_off]->b_data;
+			xs->base = bucket_block(&xs->bucket, block_off);
 		}
 		if (ocfs2_xattr_is_local(xs->here)) {
 			memcpy(buffer, (void *)xs->base +
@@ -2280,11 +2281,11 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	}
 	xs->bucket.bu_bhs[0] = lower_bh;
 	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)
-					xs->bucket.bu_bhs[0]->b_data;
+					bucket_block(&xs->bucket, 0);
 	lower_bh = NULL;
 
 	xs->header = xs->bucket.bu_xh;
-	xs->base = xs->bucket.bu_bhs[0]->b_data;
+	xs->base = bucket_block(&xs->bucket, 0);
 	xs->end = xs->base + inode->i_sb->s_blocksize;
 
 	if (found) {
@@ -2378,7 +2379,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 			goto out;
 		}
 
-		bucket.bu_xh = (struct ocfs2_xattr_header *)bucket.bu_bhs[0]->b_data;
+		bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&bucket, 0);
 		/*
 		 * The real bucket num in this series of blocks is stored
 		 * in the 1st bucket.
@@ -2457,7 +2458,7 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 			if (ret)
 				break;
 
-			name = (const char *)bucket->bu_bhs[block_off]->b_data +
+			name = (const char *)bucket_block(bucket, block_off) +
 				new_offset;
 			ret = ocfs2_xattr_list_entry(xl->buffer,
 						     xl->buffer_size,
@@ -2630,7 +2631,7 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 
 	xs->bucket.bu_bhs[0] = new_bh;
 	get_bh(new_bh);
-	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)xs->bucket.bu_bhs[0]->b_data;
+	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&xs->bucket, 0);
 	xs->header = xs->bucket.bu_xh;
 
 	xs->base = new_bh->b_data;
@@ -3931,7 +3932,7 @@ static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
 	int block_off = offs >> inode->i_sb->s_blocksize_bits;
 
 	offs = offs % inode->i_sb->s_blocksize;
-	return bucket->bu_bhs[block_off]->b_data + offs;
+	return bucket_block(bucket, block_off) + offs;
 }
 
 /*
-- 
1.5.6

