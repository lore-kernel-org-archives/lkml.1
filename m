Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbZE0LO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbZE0LO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbZE0LMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49418 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbZE0LML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:11 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:49 +0300
Message-Id: <20090527130549.4913.58661.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/19] FAT: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:48.0198 (UTC) FILETIME=[ED85A860:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] FAT: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/fat/fatent.c |    8 ++++----
 fs/fat/inode.c  |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index da6eea4..fa19a9d 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -495,7 +495,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				mark_sb_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -517,7 +517,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -578,7 +578,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -668,7 +668,7 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 2292cbf..f3b6410 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -442,7 +442,7 @@ static void fat_clear_inode(struct inode *inode)
 static void fat_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
 		fat_clusters_flush(sb);
@@ -455,7 +455,7 @@ static void fat_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		fat_write_super(sb);
 
 	if (sbi->nls_disk) {
-- 
1.6.0.6

