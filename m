Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZHSQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZHSQHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZHSQEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZHSQEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:46 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com
Subject: [PATCH 03/17] vfs: Remove syncing from generic_file_direct_write() and generic_file_buffered_write()
Date: Wed, 19 Aug 2009 18:04:30 +0200
Message-Id: <1250697884-22288-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_direct_write() and generic_file_buffered_write() called
generic_osync_inode() if it was called on O_SYNC file or IS_SYNC inode. But
this is superfluous since generic_file_aio_write() does the syncing as well.
Also XFS and OCFS2 which call these functions directly handle syncing
themselves. So let's have a single place where syncing happens:
generic_file_aio_write().

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 554a396..3bee198 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2187,20 +2187,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 		*ppos = end;
 	}
-
-	/*
-	 * Sync the fs metadata but not the minor inode changes and
-	 * of course not the data as we did direct DMA for the IO.
-	 * i_mutex is held, which protects generic_osync_inode() from
-	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
-	 */
 out:
-	if ((written >= 0 || written == -EIOCBQUEUED) &&
-	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
-		if (err < 0)
-			written = err;
-	}
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);
@@ -2332,8 +2319,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode *inode = mapping->host;
 	ssize_t status;
 	struct iov_iter i;
 
@@ -2343,16 +2328,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	if (likely(status >= 0)) {
 		written += status;
 		*ppos = pos + status;
-
-		/*
-		 * For now, when the user asks for O_SYNC, we'll actually give
-		 * O_DSYNC
-		 */
-		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			if (!a_ops->writepage || !is_sync_kiocb(iocb))
-				status = generic_osync_inode(inode, mapping,
-						OSYNC_METADATA|OSYNC_DATA);
-		}
   	}
 	
 	/*
-- 
1.6.0.2

