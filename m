Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZDWVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZDWVfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbZDWVfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:35:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:34554 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667AbZDWVfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:35:38 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] vfs: Call ->sync_fs() even if s_dirt is 0 (version 3)
Date: Thu, 23 Apr 2009 23:35:34 +0200
Message-Id: <1240522536-2994-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240522536-2994-1-git-send-email-jack@suse.cz>
References: <1240522536-2994-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_filesystems() has a condition that if wait == 0 and s_dirt == 0, then
->sync_fs() isn't called. This does not really make much sence since s_dirt is
generally used by a filesystem to mean that ->write_super() needs to be called.
But ->sync_fs() does different things. I even suspect that some filesystems
(btrfs?) sets s_dirt just to fool this logic.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 4826540..d9759e0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -490,7 +490,7 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		async_synchronize_full_domain(&sb->s_async_list);
-		if (sb->s_root && (wait || sb->s_dirt))
+		if (sb->s_root)
 			sb->s_op->sync_fs(sb, wait);
 		up_read(&sb->s_umount);
 		/* restart only when sb is no longer on the list */
-- 
1.6.0.2

