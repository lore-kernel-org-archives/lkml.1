Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZIBN7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZIBN7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZIBN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:59:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZIBN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:27 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 05/16] ocfs2: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
Date: Wed,  2 Sep 2009 15:59:15 +0200
Message-Id: <1251899966-7316-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper. We have to submit data pages ourselves in case of O_SYNC
write because __generic_file_aio_write does not do it for us. OCFS2 developpers
might think about moving the sync out of i_mutex which seems to be easily
possible but that's out of scope of this patch.

CC: ocfs2-devel@oss.oracle.com
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index aa501d3..6002273 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1871,8 +1871,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = generic_file_aio_write_nolock(iocb, iov, nr_segs,
-							*ppos);
+		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
 	}
 
 out_dio:
@@ -1880,18 +1879,21 @@ out_dio:
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

