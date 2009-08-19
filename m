Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZHSQGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZHSQGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZHSQGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:06:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:55955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZHSQEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:48 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
       Joel Becker <Joel.Becker@oracle.com>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 13/17] ocfs2: Update syncing after splicing to match generic version
Date: Wed, 19 Aug 2009 18:04:40 +0200
Message-Id: <1250697884-22288-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ocfs2 specific splicing code to use generic syncing helper.

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

