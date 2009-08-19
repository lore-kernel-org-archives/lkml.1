Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbZHSQHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbZHSQHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZHSQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:07:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:55953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZHSQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:47 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 11/17] fat: Opencode sync_page_range_nolock()
Date: Wed, 19 Aug 2009 18:04:38 +0200
Message-Id: <1250697884-22288-12-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat_cont_expand() is the only user of sync_page_range_nolock(). It's also the
only user of generic_osync_inode() which does not have a file open.  So
opencode needed actions for FAT so that we can convert generic_osync_inode() to
a standard syncing path.

Update a comment about generic_osync_inode().

CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c |   22 ++++++++++++++++++++--
 fs/fat/misc.c |    4 ++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index f042b96..e8c159d 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -176,8 +176,26 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	if (IS_SYNC(inode))
-		err = sync_page_range_nolock(inode, mapping, start, count);
+	if (IS_SYNC(inode)) {
+		int err2;
+
+		/*
+		 * Opencode syncing since we don't have a file open to use
+		 * standard fsync path.
+		 */
+		err = filemap_fdatawrite_range(mapping, start,
+					       start + count - 1);
+		err2 = sync_mapping_buffers(mapping);
+		if (!err)
+			err = err2;
+		err2 = write_inode_now(inode, 1);
+		if (!err)
+			err = err2;
+		if (!err) {
+			err =  filemap_fdatawait_range(mapping, start,
+						       start + count - 1);
+		}
+	}
 out:
 	return err;
 }
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index a6c2047..4e35be8 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -119,8 +119,8 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		MSDOS_I(inode)->i_start = new_dclus;
 		MSDOS_I(inode)->i_logstart = new_dclus;
 		/*
-		 * Since generic_osync_inode() synchronize later if
-		 * this is not directory, we don't here.
+		 * Since generic_write_sync() synchronizes regular files later,
+		 * we sync here only directories.
 		 */
 		if (S_ISDIR(inode->i_mode) && IS_DIRSYNC(inode)) {
 			ret = fat_sync_inode(inode);
-- 
1.6.0.2

