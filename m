Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZGIHAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZGIHAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZGIG6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:53 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41623 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbZGIG6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:50 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:49:11 +0300
Message-Id: <20090709084911.12122.76873.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 07/18] FAT: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:42.0622 (UTC) FILETIME=[B1F9E5E0:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fat/fatent.c |    8 ++++----
 fs/fat/inode.c  |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index a810377..46db5e5 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -498,7 +498,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				mark_sb_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -520,7 +520,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -581,7 +581,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -671,7 +671,7 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..cdf552e 100644
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
@@ -453,7 +453,7 @@ static int fat_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	fat_clusters_flush(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 
 	return 0;
@@ -465,7 +465,7 @@ static void fat_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		fat_write_super(sb);
 
 	iput(sbi->fat_inode);
-- 
1.6.0.6

