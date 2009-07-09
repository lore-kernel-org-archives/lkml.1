Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbZGIHB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbZGIHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbZGIG7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:59:34 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30043 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803AbZGIG7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:59:32 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:49:53 +0300
Message-Id: <20090709084953.12122.17032.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 13/18] SYSV: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:59:22.0384 (UTC) FILETIME=[C9AD1900:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/sysv/inode.c |    6 +++---
 fs/sysv/super.c |    2 +-
 fs/sysv/sysv.h  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 9824743..7cf8d82 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -60,7 +60,7 @@ static void sysv_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		sysv_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
@@ -70,7 +70,7 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -79,7 +79,7 @@ static void sysv_put_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
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
index 53786eb..1467ff2 100644
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

