Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZFELQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZFELQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZFELOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:14:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49381 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZFELOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:14:19 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH v2.1 04/17] EXOFS: do not manipulate s_dirt directly
Date: Fri,  5 Jun 2009 16:05:42 +0300
Message-Id: <1244207155-2092-5-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 05 Jun 2009 11:12:52.0063 (UTC) FILETIME=[914E6EF0:01C9E5CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
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

