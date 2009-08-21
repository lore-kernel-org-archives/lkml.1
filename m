Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbZHUR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbZHUR1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbZHUR1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:27:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbZHURYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       Joel Becker <Joel.Becker@oracle.com>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 12/17] ocfs2: Update syncing after splicing to match generic version
Date: Fri, 21 Aug 2009 19:24:02 +0200
Message-Id: <1250875447-15622-13-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ocfs2 specific splicing code to use generic syncing helper. The sync now
does not happen under rw_lock because generic_write_sync() acquires i_mutex
which ranks above rw_lock. That should not matter because standard fsync path
does not hold it either.

CC: Joel Becker <Joel.Becker@oracle.com>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   27 ++++++---------------------
 1 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1c71f0a..bd7fdf8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1990,31 +1990,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 
 	if (ret > 0) {
 		unsigned long nr_pages;
+		int err;
 
-		*ppos += ret;
 		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-		/*
-		 * If file or inode is SYNC and we actually wrote some data,
-		 * sync it.
-		 */
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			int err;
-
-			mutex_lock(&inode->i_mutex);
-			err = ocfs2_rw_lock(inode, 1);
-			if (err < 0) {
-				mlog_errno(err);
-			} else {
-				err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-				ocfs2_rw_unlock(inode, 1);
-			}
-			mutex_unlock(&inode->i_mutex);
+		err = generic_write_sync(out, *ppos, ret);
+		if (err)
+			ret = err;
+		else
+			*ppos += ret;
 
-			if (err)
-				ret = err;
-		}
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
 
-- 
1.6.0.2

