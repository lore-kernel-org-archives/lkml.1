Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZGIG7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZGIG7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZGIG63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:29965 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZGIG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:27 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:42 +0300
Message-Id: <20090709084842.12122.68350.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 03/18] BFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:14.0279 (UTC) FILETIME=[A1151970:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/bfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 6f60336..8373016 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -222,7 +222,7 @@ static int bfs_sync_fs(struct super_block *sb, int wait)
 
 	mutex_lock(&info->bfs_lock);
 	mark_buffer_dirty(info->si_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	mutex_unlock(&info->bfs_lock);
 
 	return 0;
@@ -233,7 +233,7 @@ static void bfs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		bfs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void bfs_put_super(struct super_block *s)
@@ -245,7 +245,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (is_sb_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -480,7 +480,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
-		s->s_dirt = 1;
+		mark_sb_dirty(s);
 	} 
 	dump_imap("read_super", s);
 	mutex_init(&info->bfs_lock);
-- 
1.6.0.6

