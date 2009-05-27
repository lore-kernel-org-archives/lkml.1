Return-Path: <linux-kernel-owner+w=401wt.eu-S1763251AbZE0LRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763251AbZE0LRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbZE0LNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:13:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54728 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761261AbZE0LNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:13:12 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:53 +0300
Message-Id: <20090527130653.4913.89984.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/19] VFS: use sb_is_dirty helper
X-OriginalArrivalTime: 27 May 2009 11:12:52.0775 (UTC) FILETIME=[14035370:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] VFS: use sb_is_dirty helper

... instead of checking 's_dirt' directly. This is just
a little cleaner and more consistent. We have only 3
VFS helpers which access 's_dirt' now.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/super.c |    4 ++--
 fs/sync.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2ea1586..ef9a24a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -415,12 +415,12 @@ void sync_supers(void)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_op->write_super && sb->s_dirt) {
+		if (sb->s_op->write_super && sb_is_dirty(sb)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && sb_is_dirty(sb))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
diff --git a/fs/sync.c b/fs/sync.c
index e9d56f6..12f36d7 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -33,7 +33,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 	else
 		sync_quota_sb(sb, -1);
 	sync_inodes_sb(sb, wait);
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (sb_is_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, wait);
@@ -162,7 +162,7 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (sb_is_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 
 	/* .. finally sync the buffers to disk */
-- 
1.6.0.6

