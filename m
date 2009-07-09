Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZGIG7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZGIG7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZGIG6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:35 -0400
Received: from smtp.nokia.com ([192.100.122.233]:29969 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZGIG6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:30 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:49 +0300
Message-Id: <20090709084849.12122.23929.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 04/18] EXOFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:21.0525 (UTC) FILETIME=[A566C050:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/inode.c |    2 +-
 fs/exofs/super.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 77d0a29..cb20f1c 100644
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
index 8216c5b..14263ff 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -241,7 +241,7 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
 		goto out;
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 out:
 	if (or)
@@ -257,7 +257,7 @@ static void exofs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		exofs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 /*
@@ -271,7 +271,7 @@ static void exofs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_write_super(sb);
 
 	/* make sure there are no pending commands */
-- 
1.6.0.6

