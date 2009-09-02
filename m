Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZIBN7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZIBN7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZIBN7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:59:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:49727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZIBN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:27 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>,
       linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: [PATCH 10/16] ext4: Remove syncing logic from ext4_file_write
Date: Wed,  2 Sep 2009 15:59:20 +0200
Message-Id: <1251899966-7316-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syncing is now properly handled by generic_file_aio_write() so
no special ext4 code is needed.

CC: linux-ext4@vger.kernel.org
CC: tytso@mit.edu
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c |   53 ++---------------------------------------------------
 1 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3f1873f..aafe432 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -58,10 +58,7 @@ static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	ssize_t ret;
-	int err;
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
@@ -81,53 +78,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	/*
-	 * Skip flushing if there was an error, or if nothing was written.
-	 */
-	if (ret <= 0)
-		return ret;
-
-	/*
-	 * If the inode is IS_SYNC, or is O_SYNC and we are doing data
-	 * journalling then we need to make sure that we force the transaction
-	 * to disk to keep all metadata uptodate synchronously.
-	 */
-	if (file->f_flags & O_SYNC) {
-		/*
-		 * If we are non-data-journaled, then the dirty data has
-		 * already been flushed to backing store by generic_osync_inode,
-		 * and the inode has been flushed too if there have been any
-		 * modifications other than mere timestamp updates.
-		 *
-		 * Open question --- do we care about flushing timestamps too
-		 * if the inode is IS_SYNC?
-		 */
-		if (!ext4_should_journal_data(inode))
-			return ret;
-
-		goto force_commit;
-	}
-
-	/*
-	 * So we know that there has been no forced data flush.  If the inode
-	 * is marked IS_SYNC, we need to force one ourselves.
-	 */
-	if (!IS_SYNC(inode))
-		return ret;
-
-	/*
-	 * Open question #2 --- should we force data to disk here too?  If we
-	 * don't, the only impact is that data=writeback filesystems won't
-	 * flush data to disk automatically on IS_SYNC, only metadata (but
-	 * historically, that is what ext2 has done.)
-	 */
-
-force_commit:
-	err = ext4_force_commit(inode->i_sb);
-	if (err)
-		return err;
-	return ret;
+	return generic_file_aio_write(iocb, iov, nr_segs, pos);
 }
 
 static struct vm_operations_struct ext4_file_vm_ops = {
-- 
1.6.0.2

