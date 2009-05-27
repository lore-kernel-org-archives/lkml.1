Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZE0LMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZE0LMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZE0LLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:11:48 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64884 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZE0LLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:11:47 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:16 +0300
Message-Id: <20090527130516.4913.76986.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/19] AFFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:19.0183 (UTC) FILETIME=[DC3A51F0:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] AFFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   11 +++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

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
index 280d361..fab17aa 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -64,9 +64,12 @@ affs_write_super(struct super_block *sb)
 				  &AFFS_ROOT_TAIL(sb, sbi->s_root_bh)->disk_change);
 		affs_fix_checksum(sb, sbi->s_root_bh);
 		mark_buffer_dirty(sbi->s_root_bh);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
+		if (clean)
+			mark_sb_clean(sb);
+		else
+			mark_sb_dirty(sb);
 	} else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
@@ -522,8 +525,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
+		mark_sb_dirty(sb);
+		while (sb_is_dirty(sb))
 			affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
-- 
1.6.0.6

