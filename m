Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbZFDIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbZFDIvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbZFDIt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56814 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZFDItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:23 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 17/17] VFS: use sb_is_dirty helper
Date: Thu,  4 Jun 2009 13:41:54 +0300
Message-Id: <1244112114-23144-18-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:45.0127 (UTC) FILETIME=[44EAF570:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... instead of checking 's_dirt' directly. This is just
a little cleaner and more consistent. We have only 3
VFS helpers which access 's_dirt' now.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

