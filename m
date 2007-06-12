Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbXFLHDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbXFLHDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXFLHAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:39 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/18] sendfile: convert nfs to using splice_read()
Date: Tue, 12 Jun 2007 08:58:04 +0200
Message-Id: <11816314953814-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/nfs/file.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 9eb8eb4..8689b73 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -41,7 +41,9 @@ static int nfs_file_open(struct inode *, struct file *);
 static int nfs_file_release(struct inode *, struct file *);
 static loff_t nfs_file_llseek(struct file *file, loff_t offset, int origin);
 static int  nfs_file_mmap(struct file *, struct vm_area_struct *);
-static ssize_t nfs_file_sendfile(struct file *, loff_t *, size_t, read_actor_t, void *);
+static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
+					struct pipe_inode_info *pipe,
+					size_t count, unsigned int flags);
 static ssize_t nfs_file_read(struct kiocb *, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
@@ -65,7 +67,7 @@ const struct file_operations nfs_file_operations = {
 	.fsync		= nfs_fsync,
 	.lock		= nfs_lock,
 	.flock		= nfs_flock,
-	.sendfile	= nfs_file_sendfile,
+	.splice_read	= nfs_file_splice_read,
 	.check_flags	= nfs_check_flags,
 };
 
@@ -224,20 +226,21 @@ nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 }
 
 static ssize_t
-nfs_file_sendfile(struct file *filp, loff_t *ppos, size_t count,
-		read_actor_t actor, void *target)
+nfs_file_splice_read(struct file *filp, loff_t *ppos,
+		     struct pipe_inode_info *pipe, size_t count,
+		     unsigned int flags)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	ssize_t res;
 
-	dfprintk(VFS, "nfs: sendfile(%s/%s, %lu@%Lu)\n",
+	dfprintk(VFS, "nfs: splice_read(%s/%s, %lu@%Lu)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		(unsigned long) count, (unsigned long long) *ppos);
 
 	res = nfs_revalidate_mapping(inode, filp->f_mapping);
 	if (!res)
-		res = generic_file_sendfile(filp, ppos, count, actor, target);
+		res = generic_file_splice_read(filp, ppos, pipe, count, flags);
 	return res;
 }
 
-- 
1.5.2.1.174.gcd03

