Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZIBOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZIBOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZIBOCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:02:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZIBN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:28 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 12/16] ocfs2: Update syncing after splicing to match generic version
Date: Wed,  2 Sep 2009 15:59:22 +0200
Message-Id: <1251899966-7316-13-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ocfs2 specific splicing code to use generic syncing helper. The sync now
does not happen under rw_lock because generic_write_sync() acquires i_mutex
which ranks above rw_lock. That should not matter because standard fsync path
does not hold it either.

Acked-by: Joel Becker <Joel.Becker@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   27 ++++++---------------------
 1 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6002273..221c5e9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1993,31 +1993,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 
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

