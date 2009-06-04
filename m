Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZFDItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZFDItc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZFDIs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:48:58 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34053 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbZFDIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:48:56 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH v2 02/17] AFFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:39 +0300
Message-Id: <1244112114-23144-3-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:35.0638 (UTC) FILETIME=[3F430D60:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   12 ++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

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
index 280d361..8c105d5 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -64,9 +64,13 @@ affs_write_super(struct super_block *sb)
 				  &AFFS_ROOT_TAIL(sb, sbi->s_root_bh)->disk_change);
 		affs_fix_checksum(sb, sbi->s_root_bh);
 		mark_buffer_dirty(sbi->s_root_bh);
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
@@ -522,8 +526,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
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

