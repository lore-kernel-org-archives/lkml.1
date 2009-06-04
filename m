Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZFDIu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZFDIu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZFDItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:16 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34119 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbZFDItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:11 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH v2 13/17] SYSV: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:50 +0300
Message-Id: <1244112114-23144-14-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:43.0189 (UTC) FILETIME=[43C33E50:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/sysv/inode.c |    8 ++++----
 fs/sysv/super.c |    2 +-
 fs/sysv/sysv.h  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index a3f45fc..3c5ea5c 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -31,7 +31,7 @@
 #include <asm/byteorder.h>
 #include "sysv.h"
 
-/* This is only called on sync() and umount(), when s_dirt=1. */
+/* This is only called on sync() and umount(), when the super block is dirty. */
 static void sysv_write_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
@@ -55,7 +55,7 @@ static void sysv_write_super(struct super_block *sb)
 		mark_buffer_dirty(sbi->s_bh2);
 	}
 clean:
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_kernel();
 	unlock_super(sb);
 }
@@ -67,7 +67,7 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -78,7 +78,7 @@ static void sysv_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		sysv_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..f0d3679 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -347,7 +347,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
 		sb->s_root->d_op = &sysv_dentry_operations;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	return 1;
 }
 
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 5784a31..4d1b784 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -118,7 +118,7 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 
-- 
1.6.0.6

