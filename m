Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYAQWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYAQWnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYAQWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:52 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10823 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYAQWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:41 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>
Subject: [PATCH 10/30] ocfs2: Initalize bitmap_cpg of ocfs2_super to be the maximum.
Date: Thu, 17 Jan 2008 14:35:36 -0800
Message-Id: <1200609356-17788-11-git-send-email-mark.fasheh@oracle.com>
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

From: Tao Ma <tao.ma@oracle.com>

This value is initialized from global_bitmap->id2.i_chain.cl_cpg. If there
is only 1 group, it will be equal to the total clusters in the volume. So
as for online resize, it should change for all the nodes in the cluster.
It isn't easy and there is no corresponding lock for it.

bitmap_cpg is only used in 2 areas:
1. Check whether the suballoc is too large for us to allocate from the global
   bitmap, so it is little used. And now the suballoc size is 2048, it rarely
   meet this situation and the check is almost useless.
2. Calculate which group a cluster belongs to. We use it during truncate to
   figure out which cluster group an extent belongs too. But we should be OK
   if we increase it though as the cluster group calculated shouldn't change
   and we only ever have a small bitmap_cpg on file systems with a single
   cluster group.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/super.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7708df3..479ac50 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1280,7 +1280,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
-	struct buffer_head *bitmap_bh = NULL;
 	struct ocfs2_journal *journal;
 	__le32 uuid_net_key;
 	struct ocfs2_super *osb;
@@ -1497,25 +1496,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
-
-	/* We don't have a cluster lock on the bitmap here because
-	 * we're only interested in static information and the extra
-	 * complexity at mount time isn't worht it. Don't pass the
-	 * inode in to the read function though as we don't want it to
-	 * be put in the cache. */
-	status = ocfs2_read_block(osb, osb->bitmap_blkno, &bitmap_bh, 0,
-				  NULL);
 	iput(inode);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
 
-	di = (struct ocfs2_dinode *) bitmap_bh->b_data;
-	osb->bitmap_cpg = le16_to_cpu(di->id2.i_chain.cl_cpg);
-	brelse(bitmap_bh);
-	mlog(0, "cluster bitmap inode: %llu, clusters per group: %u\n",
-	     (unsigned long long)osb->bitmap_blkno, osb->bitmap_cpg);
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
1.5.3.6

