Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZCEQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZCEQjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZCEQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:10 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42921 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZCEQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:08 -0500
Subject: [RFC][PATCH 04/11] actually use f_op in checkpoint code
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:02 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163902.C0DC6044@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Right now, we assume all normal files and directories
can be checkpointed.  However, as usual in the VFS, there
are specialized places that will always need an ability
to override these defaults.  We could do this completely
in the checkpoint code, but that would bitrot quickly.

This adds a new 'file_operations' function for
checkpointing a file.  I did this under the assumption
that we should have a dirt-simple way to make something
(un)checkpointable that fits in with current code.

As you can see in the ext[234] and /proc patches, all
that we have to do to make something simple be
supported is add a single "generic" f_op entry.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/checkpoint/ckpt_file.c |    4 ++--
 linux-2.6.git-dave/include/linux/fs.h     |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN checkpoint/ckpt_file.c~f_op-for-checkpointability checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~f_op-for-checkpointability	2009-03-05 08:37:01.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-03-05 08:37:01.000000000 -0800
@@ -106,8 +106,8 @@ static int cr_write_fd_data(struct cr_ct
 
 	hh->fd_type = CR_FD_UNSET;
 	ret = -EBADF;
-	if ((file->f_dentry->d_inode->i_mode & S_IFMT) == S_IFREG)
-		ret = generic_file_checkpoint(file, ctx, hh);
+	if (file->f_op->checkpoint)
+		ret = file->f_op->checkpoint(file, ctx, hh);
 
 	if (ret)
 		goto out;
diff -puN include/linux/fs.h~f_op-for-checkpointability include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~f_op-for-checkpointability	2009-03-05 08:37:01.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2009-03-05 08:37:01.000000000 -0800
@@ -1296,6 +1296,14 @@ int generic_osync_inode(struct inode *, 
 typedef int (*filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
 struct block_device_operations;
 
+struct cr_ctx;
+struct cr_hdr_fd;
+#ifdef CONFIG_CHECKPOINT_RESTART
+int generic_file_checkpoint(struct file *, struct cr_ctx *, struct cr_hdr_fd *);
+#else
+#define generic_file_checkpoint NULL
+#endif
+
 /* These macros are for out of kernel modules to test that
  * the kernel supports the unlocked_ioctl and compat_ioctl
  * fields in struct file_operations. */
@@ -1334,6 +1342,7 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
+	int (*checkpoint)(struct file *, struct cr_ctx *, struct cr_hdr_fd *);
 };
 
 struct inode_operations {
_
