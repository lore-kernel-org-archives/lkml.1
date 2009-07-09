Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbZGIHDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbZGIHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbZGIHAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:00:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41773 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbZGIHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:00:23 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:50:12 +0300
Message-Id: <20090709085012.12122.92210.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 16/18] VFS: use is_sb_dirty helper
X-OriginalArrivalTime: 09 Jul 2009 06:59:44.0309 (UTC) FILETIME=[D6BE9650:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... instead of checking 's_dirt' directly. This is just
a little cleaner and more consistent. We have only 3
VFS helpers which access 's_dirt' now.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/super.c |    4 ++--
 fs/sync.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 0d22ce3..b536dda 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -412,12 +412,12 @@ void sync_supers(void)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_op->write_super && sb->s_dirt) {
+		if (sb->s_op->write_super && is_sb_dirty(sb)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && is_sb_dirty(sb))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
diff --git a/fs/sync.c b/fs/sync.c
index dd20002..ba3fe8f 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -160,7 +160,7 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (is_sb_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 
 	/* .. finally sync the buffers to disk */
-- 
1.6.0.6

