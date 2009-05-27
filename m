Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZE0LMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZE0LMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZE0LLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:11:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49363 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbZE0LLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:11:54 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:23 +0300
Message-Id: <20090527130523.4913.9362.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/19] BFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:22.0885 (UTC) FILETIME=[DE6F3350:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] BFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/bfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 3a9a136..7ab0792 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -219,7 +219,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (sb_is_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -255,7 +255,7 @@ static void bfs_write_super(struct super_block *s)
 	mutex_lock(&info->bfs_lock);
 	if (!(s->s_flags & MS_RDONLY))
 		mark_buffer_dirty(info->si_sbh);
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 	mutex_unlock(&info->bfs_lock);
 }
 
@@ -464,7 +464,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
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

