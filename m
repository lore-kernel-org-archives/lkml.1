Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbXFLHBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbXFLHBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXFLHAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:32 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13563 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbXFLHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/18] sys_sendfile: switch to using ->splice_read, if available
Date: Tue, 12 Jun 2007 08:57:59 +0200
Message-Id: <11816314942880-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sendfile prefer to use ->splice_read(), if it's
available in the file_operations structure.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/read_write.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4d03008..47da8a4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
+#include <linux/pipe_fs_i.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -25,7 +26,7 @@ const struct file_operations generic_ro_fops = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.mmap		= generic_file_readonly_mmap,
-	.sendfile	= generic_file_sendfile,
+	.splice_read	= generic_file_splice_read,
 };
 
 EXPORT_SYMBOL(generic_ro_fops);
@@ -708,7 +709,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	struct inode * in_inode, * out_inode;
 	loff_t pos;
 	ssize_t retval;
-	int fput_needed_in, fput_needed_out;
+	int fput_needed_in, fput_needed_out, fl;
 
 	/*
 	 * Get input file, and verify that it is ok..
@@ -723,7 +724,8 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	in_inode = in_file->f_path.dentry->d_inode;
 	if (!in_inode)
 		goto fput_in;
-	if (!in_file->f_op || !in_file->f_op->sendfile)
+	if (!in_file->f_op || (!in_file->f_op->sendfile &&
+	    !in_file->f_op->splice_read))
 		goto fput_in;
 	retval = -ESPIPE;
 	if (!ppos)
@@ -776,7 +778,21 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		count = max - pos;
 	}
 
-	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
+	if (in_file->f_op->splice_read) {
+		fl = 0;
+#if 0
+		/*
+		 * We need to debate whether we can enable this or not. The
+		 * man page documents EAGAIN return for the output at least,
+		 * and the application is arguably buggy if it doesn't expect
+		 * EAGAIN on a non-blocking file descriptor.
+		 */
+		if (in_file->f_flags & O_NONBLOCK)
+			fl = SPLICE_F_NONBLOCK;
+#endif
+		retval = do_splice_direct(in_file, ppos, out_file, count, fl);
+	} else
+		retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
 
 	if (retval > 0) {
 		add_rchar(current, retval);
-- 
1.5.2.1.174.gcd03

