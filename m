Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZGIG7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZGIG7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbZGIG6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39931 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbZGIG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:45 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:36 +0300
Message-Id: <20090709084836.12122.75889.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 02/18] AFFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:05.0072 (UTC) FILETIME=[9B983900:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index dc5ef14..0be510c 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -102,7 +102,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	bm->bm_free++;
 
 	mutex_unlock(&sbi->s_bmlock);
@@ -247,7 +247,7 @@ find_bit:
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	mutex_unlock(&sbi->s_bmlock);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 104fdcb..3b3c770 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -68,9 +68,13 @@ affs_write_super(struct super_block *sb)
 		//		if (buffer_dirty(sbi->s_bitmap[i].bm_bh)) {
 		//			clean = 0;
 		affs_commit_super(sb, clean);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
+		/* redo until bitmap synced */
+		if (clean)
+			mark_sb_clean(sb);
+		else
+			mark_sb_dirty(sb);
 	} else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
@@ -81,7 +85,7 @@ affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	affs_commit_super(sb, 2);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -540,8 +544,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
+		mark_sb_dirty(sb);
+		while (is_sb_dirty(sb))
 			affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
-- 
1.6.0.6

