Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZFELPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZFELPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZFELNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:13:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36837 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZFELNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:13:40 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: [PATCH v2.1 03/17] BFS: do not manipulate s_dirt directly
Date: Fri,  5 Jun 2009 16:05:41 +0300
Message-Id: <1244207155-2092-4-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 05 Jun 2009 11:12:50.0337 (UTC) FILETIME=[90471110:01C9E5CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Tigran A. Aivazian <tigran@aivazian.fsnet.co.uk>
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
+	if (is_sb_dirty(s))
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

