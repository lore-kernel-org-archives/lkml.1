Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXIKWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXIKWz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbXIKWzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:55:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56441 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992AbXIKWzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:55:47 -0400
Date: Tue, 11 Sep 2007 17:52:07 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH] eCryptfs: Use generic_file_splice_read()
Message-ID: <20070911225207.GA13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs is currently just passing through splice reads to the lower
filesystem. This is obviously incorrect behavior; the decrypted data
is what needs to be read, not the lower encrypted data. I cannot think
of any good reason for eCryptfs to implement splice_read, so this
patch points the eCryptfs fops splice_read to use
generic_file_splice_read.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

--- linux-2.6.23-rc4-mm1.orig/fs/ecryptfs/file.c
+++ linux-2.6.23-rc4-mm1/fs/ecryptfs/file.c
@@ -338,21 +338,6 @@ static int ecryptfs_fasync(int fd, struc
 	return rc;
 }
 
-static ssize_t ecryptfs_splice_read(struct file *file, loff_t * ppos,
-				    struct pipe_inode_info *pipe, size_t count,
-				    unsigned int flags)
-{
-	struct file *lower_file = NULL;
-	int rc = -EINVAL;
-
-	lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file->f_op && lower_file->f_op->splice_read)
-		rc = lower_file->f_op->splice_read(lower_file, ppos, pipe,
-						count, flags);
-
-	return rc;
-}
-
 static int ecryptfs_ioctl(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);
 
@@ -365,7 +350,7 @@ const struct file_operations ecryptfs_di
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.splice_read = ecryptfs_splice_read,
+	.splice_read = generic_file_splice_read,
 };
 
 const struct file_operations ecryptfs_main_fops = {
@@ -382,7 +367,7 @@ const struct file_operations ecryptfs_ma
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.splice_read = ecryptfs_splice_read,
+	.splice_read = generic_file_splice_read,
 };
 
 static int
