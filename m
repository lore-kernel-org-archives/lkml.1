Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZFDIvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZFDIvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZFDItT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56774 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbZFDItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:08 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH v2 04/17] EXOFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:41 +0300
Message-Id: <1244112114-23144-5-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:38.0142 (UTC) FILETIME=[40C121E0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
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

