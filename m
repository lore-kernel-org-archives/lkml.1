Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbYJSODU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbYJSODU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJSODI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:03:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35875 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYJSODF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:03:05 -0400
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] fs: truncate blocks outside i_size after generic_file_direct_write error
Date: Sun, 19 Oct 2008 18:03:00 +0400
Message-Id: <1224424981-5144-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to remove block that was allocated in generic_file_direct_write()
if we fail. We have to do it *regardless* to blocksize. At least ext2,
ext3 and reiserfs interpret (i_size < biggest block) condition as error.
Fsck will complain about wrong i_size. Then fsck will fix the error
by changing i_size according to the biggest block. This is bad because
this blocks contain gurbage from previous write attempt. And result in
data corruption.

In order to call vmtruncate() we have to hold host->i_mutex. This is true
for generic_file_aio_write(). In fact occasionally it is also true for all
generic_file_aio_write_nolock() callers except blockdev. But this situation
may change someday. This patch fix only generic_write_aio_write() case.
BTW: update generic_file_direct_write's comment with currently outdated.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 mm/filemap.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3d5a2e7..1e911e5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2186,8 +2186,10 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	/*
 	 * Sync the fs metadata but not the minor inode changes and
 	 * of course not the data as we did direct DMA for the IO.
-	 * i_mutex is held, which protects generic_osync_inode() from
-	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
+	 * i_mutex is held in case of DIO_LOCKING, which protects
+	 * generic_osync_inode() from livelocking. If it is not held, then
+	 * the filesystem must prevent this livelock by its own meaner.
+	 * AIO O_DIRECT ops attempt to sync metadata here.
 	 */
 out:
 	if ((written >= 0 || written == -EIOCBQUEUED) &&
@@ -2529,7 +2531,8 @@ EXPORT_SYMBOL(generic_file_buffered_write);
 
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t *ppos)
+				unsigned long nr_segs, loff_t *ppos,
+				int lock_type)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space * mapping = file->f_mapping;
@@ -2574,7 +2577,18 @@ __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
 
 		written = generic_file_direct_write(iocb, iov, &nr_segs, pos,
 							ppos, count, ocount);
-		if (written < 0 || written == count)
+		if (written < 0) {
+			if (lock_type == DIO_LOCKING) {
+				/*
+				 * direct write may have instantiated a few
+				 * blocks outside i_size. Trim these off again.
+				 */
+				if (pos + count > inode->i_size)
+					vmtruncate(inode, inode->i_size);
+			}
+			goto out;
+		}
+		if (written == count)
 			goto out;
 		/*
 		 * direct-io write to a hole: fall through to buffered I/O
@@ -2638,7 +2652,7 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 	BUG_ON(iocb->ki_pos != pos);
 
 	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+					&iocb->ki_pos, DIO_OWN_LOCKING);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
@@ -2663,7 +2677,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+					&iocb->ki_pos, DIO_LOCKING);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-- 
1.5.4.3

