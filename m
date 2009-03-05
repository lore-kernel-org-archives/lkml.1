Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZCEQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZCEQlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZCEQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:22 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:54533 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZCEQjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:19 -0500
Subject: [RFC][PATCH 03/11] Introduce generic_file_checkpoint()
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:01 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163901.02518456@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In a bit we will introduce a f_op to do per-file
checkpointing.  But, before I do that, I want to
demonstrate how it splices in here.

So, introduce generic_file_checkpoint() and use it
only for regular files.

I'm also removing the CR_FD_DIR type.  We treat
normal files and directories the same way, so just
call it CR_FD_GENERIC to make it more clear that
we always follow the same generic behavior.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/checkpoint/ckpt_file.c         |   50 ++++++++++++----------
 linux-2.6.git-dave/checkpoint/rstr_file.c         |    3 -
 linux-2.6.git-dave/include/linux/checkpoint_hdr.h |    4 -
 3 files changed, 32 insertions(+), 25 deletions(-)

diff -puN checkpoint/ckpt_file.c~generic_file_checkpoint checkpoint/ckpt_file.c
--- linux-2.6.git/checkpoint/ckpt_file.c~generic_file_checkpoint	2009-03-05 08:37:00.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/ckpt_file.c	2009-03-05 08:37:00.000000000 -0800
@@ -72,42 +72,50 @@ int cr_scan_fds(struct files_struct *fil
 	return n;
 }
 
+int generic_file_checkpoint(struct file *file, struct cr_ctx *ctx,
+			    struct cr_hdr_fd *hh)
+{
+	hh->f_flags = file->f_flags;
+	hh->f_mode = file->f_mode;
+	hh->f_pos = file->f_pos;
+	hh->f_version = file->f_version;
+	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
+
+	/*
+	 * CR_FD_GENERIC basically means that this can simply be
+	 * open()'d on restore.  Nothing special.  Note that this
+	 * includes directories.
+	 */
+	hh->fd_type = CR_FD_GENERIC;
+
+	/* FIX: check if the file/dir/link is unlinked */
+
+	return 0;
+}
+
 /* cr_write_fd_data - dump the state of a given file pointer */
 static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
 {
 	struct cr_hdr h;
 	struct cr_hdr_fd *hh = cr_hbuf_get(ctx, sizeof(*hh));
-	struct dentry *dent = file->f_dentry;
-	struct inode *inode = dent->d_inode;
-	enum fd_type fd_type;
 	int ret;
 
 	h.type = CR_HDR_FD_DATA;
 	h.len = sizeof(*hh);
 	h.parent = parent;
 
-	hh->f_flags = file->f_flags;
-	hh->f_mode = file->f_mode;
-	hh->f_pos = file->f_pos;
-	hh->f_version = file->f_version;
-	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
+	hh->fd_type = CR_FD_UNSET;
+	ret = -EBADF;
+	if ((file->f_dentry->d_inode->i_mode & S_IFMT) == S_IFREG)
+		ret = generic_file_checkpoint(file, ctx, hh);
 
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFREG:
-		fd_type = CR_FD_FILE;
-		break;
-	case S_IFDIR:
-		fd_type = CR_FD_DIR;
-		break;
-	default:
-		cr_hbuf_put(ctx, sizeof(*hh));
-		return -EBADF;
-	}
+	if (ret)
+		goto out;
 
-	/* FIX: check if the file/dir/link is unlinked */
-	hh->fd_type = fd_type;
+	WARN_ON(hh->fd_type == CR_FD_UNSET);
 
 	ret = cr_write_obj(ctx, &h, hh);
+out:
 	cr_hbuf_put(ctx, sizeof(*hh));
 	if (ret < 0)
 		return ret;
diff -puN checkpoint/rstr_file.c~generic_file_checkpoint checkpoint/rstr_file.c
--- linux-2.6.git/checkpoint/rstr_file.c~generic_file_checkpoint	2009-03-05 08:37:00.000000000 -0800
+++ linux-2.6.git-dave/checkpoint/rstr_file.c	2009-03-05 08:37:00.000000000 -0800
@@ -92,8 +92,7 @@ cr_read_fd_data(struct cr_ctx *ctx, stru
 	/* FIX: more sanity checks on f_flags, f_mode etc */
 
 	switch (hh->fd_type) {
-	case CR_FD_FILE:
-	case CR_FD_DIR:
+	case CR_FD_GENERIC:
 		file = cr_read_open_fname(ctx, hh->f_flags, hh->f_mode);
 		break;
 	default:
diff -puN include/linux/checkpoint_hdr.h~generic_file_checkpoint include/linux/checkpoint_hdr.h
--- linux-2.6.git/include/linux/checkpoint_hdr.h~generic_file_checkpoint	2009-03-05 08:37:00.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint_hdr.h	2009-03-05 08:37:00.000000000 -0800
@@ -133,8 +133,8 @@ struct cr_hdr_fd_ent {
 
 /* fd types */
 enum  fd_type {
-	CR_FD_FILE = 1,
-	CR_FD_DIR,
+	CR_FD_UNSET   = 0,
+	CR_FD_GENERIC = 1,
 };
 
 struct cr_hdr_fd {
_
