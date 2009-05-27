Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZE0LNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZE0LNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbZE0LME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49387 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364AbZE0LMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:01 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:29 +0300
Message-Id: <20090527130529.4913.69959.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/19] EXOFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:31.0916 (UTC) FILETIME=[E3D138C0:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] EXOFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/exofs/inode.c |    2 +-
 fs/exofs/super.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index ba8d9fa..80d3d03 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1066,7 +1066,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 
 	sbi = sb->s_fs_info;
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	inode->i_uid = current->cred->fsuid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 49e16af..9cf9738 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -241,7 +241,7 @@ static void exofs_write_super(struct super_block *sb)
 		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
 		goto out;
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 out:
 	if (or)
@@ -262,7 +262,7 @@ static void exofs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_write_super(sb);
 
 	/* make sure there are no pending commands */
-- 
1.6.0.6

