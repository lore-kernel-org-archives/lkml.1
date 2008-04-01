Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYDAVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYDAVJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761209AbYDAVHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:54 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45598 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760461AbYDAVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:52 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/14] VFS: rename do_splice_to/from to vfs_splice_* and export symbols
Date: Tue,  1 Apr 2008 17:06:44 -0400
Message-Id: <12070840175-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A stackable file system which uses vm_ops->fault, and does not implement
address_space_operations, cannot use generic_file_splice_read/write, but has
to implement ->splice_read/write itself.  These two helper functions are
very useful to such a module.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/splice.c            |   20 +++++++++++---------
 include/linux/splice.h |    5 +++++
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 0670c91..62b0db2 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -899,8 +899,8 @@ EXPORT_SYMBOL(generic_splice_sendpage);
 /*
  * Attempt to initiate a splice from pipe to file.
  */
-static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
-			   loff_t *ppos, size_t len, unsigned int flags)
+long vfs_splice_from(struct pipe_inode_info *pipe, struct file *out,
+		     loff_t *ppos, size_t len, unsigned int flags)
 {
 	int ret;
 
@@ -916,13 +916,14 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
+EXPORT_SYMBOL_GPL(vfs_splice_from);
 
 /*
  * Attempt to initiate a splice from a file to a pipe.
  */
-static long do_splice_to(struct file *in, loff_t *ppos,
-			 struct pipe_inode_info *pipe, size_t len,
-			 unsigned int flags)
+long vfs_splice_to(struct file *in, loff_t *ppos,
+		   struct pipe_inode_info *pipe, size_t len,
+		   unsigned int flags)
 {
 	int ret;
 
@@ -938,6 +939,7 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
+EXPORT_SYMBOL_GPL(vfs_splice_to);
 
 /**
  * splice_direct_to_actor - splices data directly between two non-pipes
@@ -1007,7 +1009,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		size_t read_len;
 		loff_t pos = sd->pos;
 
-		ret = do_splice_to(in, &pos, pipe, len, flags);
+		ret = vfs_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
 			goto out_release;
 
@@ -1062,7 +1064,7 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return vfs_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
 }
 
 /**
@@ -1136,7 +1138,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		} else
 			off = &out->f_pos;
 
-		ret = do_splice_from(pipe, out, off, len, flags);
+		ret = vfs_splice_from(pipe, out, off, len, flags);
 
 		if (off_out && copy_to_user(off_out, off, sizeof(loff_t)))
 			ret = -EFAULT;
@@ -1157,7 +1159,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		} else
 			off = &in->f_pos;
 
-		ret = do_splice_to(in, off, pipe, len, flags);
+		ret = vfs_splice_to(in, off, pipe, len, flags);
 
 		if (off_in && copy_to_user(off_in, off, sizeof(loff_t)))
 			ret = -EFAULT;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 528dcb9..4b5727c 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -70,5 +70,10 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
+extern long vfs_splice_from(struct pipe_inode_info *pipe, struct file *out,
+			    loff_t *ppos, size_t len, unsigned int flags);
+extern long vfs_splice_to(struct file *in, loff_t *ppos,
+			  struct pipe_inode_info *pipe, size_t len,
+			  unsigned int flags);
 
 #endif
-- 
1.5.2.2

