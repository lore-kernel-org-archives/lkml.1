Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbXFLHFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbXFLHFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbXFLHAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:44 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbXFLHAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:33 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 18/18] Remove remnants of sendfile()
Date: Tue, 12 Jun 2007 08:58:14 +0200
Message-Id: <11816314953322-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are now zero users of .sendfile() in the kernel, so kill
it from the file_operations structure and in do_sendfile().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/read_write.c    |   26 +++++++++++---------------
 include/linux/fs.h |    3 +--
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 2527cf0..507ddff 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -724,8 +724,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	in_inode = in_file->f_path.dentry->d_inode;
 	if (!in_inode)
 		goto fput_in;
-	if (!in_file->f_op || (!in_file->f_op->sendfile &&
-	    !in_file->f_op->splice_read))
+	if (!in_file->f_op || !in_file->f_op->splice_read)
 		goto fput_in;
 	retval = -ESPIPE;
 	if (!ppos)
@@ -778,21 +777,18 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		count = max - pos;
 	}
 
-	if (in_file->f_op->splice_read) {
-		fl = 0;
+	fl = 0;
 #if 0
-		/*
-		 * We need to debate whether we can enable this or not. The
-		 * man page documents EAGAIN return for the output at least,
-		 * and the application is arguably buggy if it doesn't expect
-		 * EAGAIN on a non-blocking file descriptor.
-		 */
-		if (in_file->f_flags & O_NONBLOCK)
-			fl = SPLICE_F_NONBLOCK;
+	/*
+	 * We need to debate whether we can enable this or not. The
+	 * man page documents EAGAIN return for the output at least,
+	 * and the application is arguably buggy if it doesn't expect
+	 * EAGAIN on a non-blocking file descriptor.
+	 */
+	if (in_file->f_flags & O_NONBLOCK)
+		fl = SPLICE_F_NONBLOCK;
 #endif
-		retval = do_splice_direct(in_file, ppos, out_file, count, fl);
-	} else
-		retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
+	retval = do_splice_direct(in_file, ppos, out_file, count, fl);
 
 	if (retval > 0) {
 		add_rchar(current, retval);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a5bf63e..5ef52bc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1054,7 +1054,7 @@ struct block_device_operations {
 };
 
 /*
- * "descriptor" for what we're up to with a read for sendfile().
+ * "descriptor" for what we're up to with a read.
  * This allows us to use the same read code yet
  * have multiple different users of the data that
  * we read from a file.
@@ -1105,7 +1105,6 @@ struct file_operations {
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t, void *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
-- 
1.5.2.1.174.gcd03

