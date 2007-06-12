Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXFLHFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXFLHFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXFLHAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:42 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13578 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbXFLHAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:33 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 16/18] splice: completely document external interface with kerneldoc
Date: Tue, 12 Jun 2007 08:58:12 +0200
Message-Id: <11816314953416-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also add fs/splice.c as a kerneldoc target with a smaller blurb that
should be expanded to better explain the overview of splice.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |   11 ++++
 fs/splice.c                           |  101 +++++++++++++++++++++++++++------
 2 files changed, 94 insertions(+), 18 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 38f88b6..8c5698a 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -643,4 +643,15 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/spi/spi.c
   </chapter>
 
+  <chapter id="splice">
+      <title>splice API</title>
+  <para>)
+	splice is a method for moving blocks of data around inside the
+	kernel, without continually transferring it between the kernel
+	and user space.
+  </para>
+!Iinclude/linux/splice.h
+!Ffs/splice.c
+  </chapter>
+
 </book>
diff --git a/fs/splice.c b/fs/splice.c
index ff62ac9..f24e367 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -153,9 +153,16 @@ static const struct pipe_buf_operations user_page_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
-/*
- * Pipe output worker. This fills a pipe with the information contained
- * from splice_pipe_desc().
+/**
+ * splice_to_pipe - fill passed data into a pipe
+ * @pipe:	pipe to fill
+ * @spd:	data to fill
+ *
+ * Description:
+ *    @spd contains a map of pages and len/offset tupples, a long with
+ *    the struct pipe_buf_operations associated with these pages. This
+ *    function will link that data to the pipe.
+ *
  */
 ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		       struct splice_pipe_desc *spd)
@@ -453,11 +460,16 @@ fill_it:
 /**
  * generic_file_splice_read - splice data from file to a pipe
  * @in:		file to splice from
+ * @ppos:	position in @in
  * @pipe:	pipe to splice to
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
  *
- * Will read pages from given file and fill them into a pipe.
+ * Description:
+ *    Will read pages from given file and fill them into a pipe. Can be
+ *    used as long as the address_space operations for the source implements
+ *    a readpage() hook.
+ *
  */
 ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
@@ -646,10 +658,18 @@ out_ret:
 	return ret;
 }
 
-/*
- * Pipe input worker. Most of this logic works like a regular pipe, the
- * key here is the 'actor' worker passed in that actually moves the data
- * to the wanted destination. See pipe_to_file/pipe_to_sendpage above.
+/**
+ * __splice_from_pipe - splice data from a pipe to given actor
+ * @pipe:	pipe to splice from
+ * @sd:		information to @actor
+ * @actor:	handler that splices the data
+ *
+ * Description:
+ *    This function does little more than loop over the pipe and call
+ *    @actor to do the actual moving of a single struct pipe_buffer to
+ *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    pipe_to_user.
+ *
  */
 ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 			   splice_actor *actor)
@@ -742,6 +762,20 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 }
 EXPORT_SYMBOL(__splice_from_pipe);
 
+/**
+ * splice_from_pipe - splice data from a pipe to a file
+ * @pipe:	pipe to splice from
+ * @out:	file to splice to
+ * @ppos:	position in @out
+ * @len:	how many bytes to splice
+ * @flags:	splice modifier flags
+ * @actor:	handler that splices the data
+ *
+ * Description:
+ *    See __splice_from_pipe. This function locks the input and output inodes,
+ *    otherwise it's identical to __splice_from_pipe().
+ *
+ */
 ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 			 loff_t *ppos, size_t len, unsigned int flags,
 			 splice_actor *actor)
@@ -773,12 +807,14 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
  * generic_file_splice_write_nolock - generic_file_splice_write without mutexes
  * @pipe:	pipe info
  * @out:	file to write to
+ * @ppos:	position in @out
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
  *
- * Will either move or copy pages (determined by @flags options) from
- * the given pipe inode to the given file. The caller is responsible
- * for acquiring i_mutex on both inodes.
+ * Description:
+ *    Will either move or copy pages (determined by @flags options) from
+ *    the given pipe inode to the given file. The caller is responsible
+ *    for acquiring i_mutex on both inodes.
  *
  */
 ssize_t
@@ -827,11 +863,13 @@ EXPORT_SYMBOL(generic_file_splice_write_nolock);
  * generic_file_splice_write - splice data from a pipe to a file
  * @pipe:	pipe info
  * @out:	file to write to
+ * @ppos:	position in @out
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
  *
- * Will either move or copy pages (determined by @flags options) from
- * the given pipe inode to the given file.
+ * Description:
+ *    Will either move or copy pages (determined by @flags options) from
+ *    the given pipe inode to the given file.
  *
  */
 ssize_t
@@ -879,13 +917,15 @@ EXPORT_SYMBOL(generic_file_splice_write);
 
 /**
  * generic_splice_sendpage - splice data from a pipe to a socket
- * @inode:	pipe inode
+ * @pipe:	pipe to splice from
  * @out:	socket to write to
+ * @ppos:	position in @out
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
  *
- * Will send @len bytes from the pipe to a network socket. No data copying
- * is involved.
+ * Description:
+ *    Will send @len bytes from the pipe to a network socket. No data copying
+ *    is involved.
  *
  */
 ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
@@ -939,8 +979,18 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
 
-/*
- * Splices from an input file to an actor, using a 'direct' pipe.
+/**
+ * splice_direct_to_actor - splices data directly between two non-pipes
+ * @in:		file to splice from
+ * @sd:		actor information on where to splice to
+ * @actor:	handles the data splicing
+ *
+ * Description:
+ *    This is a special case helper to splice directly between two
+ *    points, without requiring an explicit pipe. Internally an allocated
+ *    pipe is cached in the process, and reused during the life time of
+ *    that process.
+ *
  */
 ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 			       splice_direct_actor *actor)
@@ -1070,6 +1120,21 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
 }
 
+/**
+ * do_splice_direct - splices data directly between two files
+ * @in:		file to splice from
+ * @ppos:	input file offset
+ * @out:	file to splice to
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags
+ *
+ * Description:
+ *    For use by do_sendfile(). splice can easily emulate sendfile, but
+ *    doing it in the application would incur an extra system call
+ *    (splice in + splice out, as compared to just sendfile()). So this helper
+ *    can splice directly through a process-private pipe.
+ *
+ */
 long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		      size_t len, unsigned int flags)
 {
-- 
1.5.2.1.174.gcd03

