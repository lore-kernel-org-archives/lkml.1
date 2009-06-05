Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZFELRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZFELRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZFELOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:14:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49436 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZFELOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:14:31 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH v2.1 13/17] SYSV: do not manipulate s_dirt directly
Date: Fri,  5 Jun 2009 16:05:51 +0300
Message-Id: <1244207155-2092-14-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 05 Jun 2009 11:13:12.0937 (UTC) FILETIME=[9DBF8D90:01C9E5CE]
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
+	if (is_sb_dirty(sb))
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

