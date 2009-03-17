Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZCQVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZCQVXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZCQVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:23:13 -0400
Received: from ns1.suse.de ([195.135.220.2]:52806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbZCQVXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:23:13 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 13/32] ocfs2: fix leaf start calculation in ocfs2_dx_dir_rebalance()
Date: Tue, 17 Mar 2009 13:01:03 -0700
Message-Id: <1237320082-12921-14-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2_dx_dir_rebalance() is passed the block offset of a dx leaf which needs
rebalancing. Since we rebalance an entire cluster at a time however, this
function needs to calculate the beginning of that cluster, in blocks. The
calculation was wrong, which would result in a read of non-leaf blocks. Fix
the calculation by adding ocfs2_block_to_cluster_start() which is a more
straight-forward way of determining this.

Reported-by: Tristan Ye <tristan.ye@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c   |    3 +--
 fs/ocfs2/ocfs2.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 5e6aeb0..e71160c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3941,8 +3941,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 		goto out_commit;
 	}
 
-	orig_leaves_start = leaf_blkno & ~(osb->s_clustersize_bits -
-				      osb->sb->s_blocksize_bits);
+	orig_leaves_start = ocfs2_block_to_cluster_start(dir->i_sb, leaf_blkno);
 	ret = ocfs2_read_dx_leaves(dir, orig_leaves_start, num_dx_leaves,
 				   orig_dx_leaves);
 	if (ret) {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index fa3c6d3..e1844d5 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -582,6 +582,16 @@ static inline u64 ocfs2_clusters_to_bytes(struct super_block *sb,
 	return (u64)clusters << OCFS2_SB(sb)->s_clustersize_bits;
 }
 
+static inline u64 ocfs2_block_to_cluster_start(struct super_block *sb,
+					       u64 blocks)
+{
+	int bits = OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits;
+	unsigned int clusters;
+
+	clusters = ocfs2_blocks_to_clusters(sb, blocks);
+	return (u64)clusters << bits;
+}
+
 static inline u64 ocfs2_align_bytes_to_clusters(struct super_block *sb,
 						u64 bytes)
 {
-- 
1.5.6

