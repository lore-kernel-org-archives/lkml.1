Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZHSQFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZHSQFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZHSQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZHSQEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:46 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 05/17] ocfs2: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
Date: Wed, 19 Aug 2009 18:04:32 +0200
Message-Id: <1250697884-22288-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper. We have to submit data pages ourselves in case of O_SYNC
write because __generic_file_aio_write does not do it for us. OCFS2 developpers
might think about moving the sync out of i_mutex which seems to be easily
possible but that's out of scope of this patch.

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 62442e4..1c71f0a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1870,8 +1870,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = generic_file_aio_write_nolock(iocb, iov, nr_segs,
-							*ppos);
+		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
 	}
 
 out_dio:
@@ -1879,18 +1878,21 @@ out_dio:
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
 	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
-		/*
-		 * The generic write paths have handled getting data
-		 * to disk, but since we don't make use of the dirty
-		 * inode list, a manual journal commit is necessary
-		 * here.
-		 */
-		if (old_size != i_size_read(inode) ||
-		    old_clusters != OCFS2_I(inode)->ip_clusters) {
+		ret = filemap_fdatawrite_range(file->f_mapping, pos,
+					       pos + count - 1);
+		if (ret < 0)
+			written = ret;
+
+		if (!ret && (old_size != i_size_read(inode) ||
+		    old_clusters != OCFS2_I(inode)->ip_clusters)) {
 			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
 				written = ret;
 		}
+
+		if (!ret)
+			ret = filemap_fdatawait_range(file->f_mapping, pos,
+						      pos + count - 1);
 	}
 
 	/* 
-- 
1.6.0.2

