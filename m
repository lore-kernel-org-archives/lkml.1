Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYGAKL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYGAKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYGAKLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:11:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:8959 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbYGAKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=T2s/NlRf/UvbLxobyyRFfU63vs9d1MI1+c8XTbRwgC+D5l0gH8+qwcFyVTNuBnvNP4
         vw+oDP2kLcSR1FeGMzemvGnUcaVKpDxHuplQWbvUZpieq84cyPljlVWhVnFVz+Y2OC9w
         BoKUspG2mlAgwidy3CSZyVMiZhAJpu03TaAmE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Date: Tue, 1 Jul 2008 14:11:25 +0200
User-Agent: KMail/1.8.2
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200807011103.02974.vda.linux@googlemail.com> <200807011203.50632.vda.linux@googlemail.com> <20080701011045.f4490332.akpm@linux-foundation.org>
In-Reply-To: <20080701011045.f4490332.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011411.25411.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008 10:10, Andrew Morton wrote:
> On Tue, 1 Jul 2008 12:03:50 +0200 Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > I think since XXX_pipe_fops are only used in this file,
> > just explaining this in the comment would be enough.
> 
> no, a comment is only needed when the code is unobvious.  Make
> the code obvious and we don't need a comment.
> 
> As Christoph pointed out, open-coding shared_read_fops everywhere
> might make sense too.  It'd make it harder to unshare them later
> on, but that's pretty improbable.

Ok.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--- linux-2.6.26-rc8/fs.org/fifo.c	Thu Apr 17 04:49:44 2008
+++ linux-2.6.26-rc8/fs/fifo.c	Tue Jul  1 14:09:13 2008
@@ -57,7 +57,7 @@
 	 *  POSIX.1 says that O_NONBLOCK means return with the FIFO
 	 *  opened, even when there is no process writing the FIFO.
 	 */
-		filp->f_op = &read_fifo_fops;
+		filp->f_op = &read_pipefifo_fops;
 		pipe->r_counter++;
 		if (pipe->readers++ == 0)
 			wake_up_partner(inode);
@@ -86,7 +86,7 @@
 		if ((filp->f_flags & O_NONBLOCK) && !pipe->readers)
 			goto err;
 
-		filp->f_op = &write_fifo_fops;
+		filp->f_op = &write_pipefifo_fops;
 		pipe->w_counter++;
 		if (!pipe->writers++)
 			wake_up_partner(inode);
@@ -105,7 +105,7 @@
 	 *  This implementation will NEVER block on a O_RDWR open, since
 	 *  the process can at least talk to itself.
 	 */
-		filp->f_op = &rdwr_fifo_fops;
+		filp->f_op = &rdwr_pipefifo_fops;
 
 		pipe->readers++;
 		pipe->writers++;
@@ -151,5 +151,5 @@
  * depending on the access mode of the file...
  */
 const struct file_operations def_fifo_fops = {
-	.open		= fifo_open,	/* will set read or write pipe_fops */
+	.open		= fifo_open,	/* will set read_ or write_pipefifo_fops */
 };
--- linux-2.6.26-rc8/fs.org/pipe.c	Tue Jul  1 11:52:28 2008
+++ linux-2.6.26-rc8/fs/pipe.c	Tue Jul  1 14:08:16 2008
@@ -777,8 +777,10 @@
 /*
  * The file_operations structs are not static because they
  * are also used in linux/fs/fifo.c to do operations on FIFOs.
+ *
+ * Pipes reuse fifos' file_operations structs.
  */
-const struct file_operations read_fifo_fops = {
+const struct file_operations read_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
@@ -790,7 +792,7 @@
 	.fasync		= pipe_read_fasync,
 };
 
-const struct file_operations write_fifo_fops = {
+const struct file_operations write_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= bad_pipe_r,
 	.write		= do_sync_write,
@@ -802,7 +804,7 @@
 	.fasync		= pipe_write_fasync,
 };
 
-const struct file_operations rdwr_fifo_fops = {
+const struct file_operations rdwr_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
@@ -815,43 +817,6 @@
 	.fasync		= pipe_rdwr_fasync,
 };
 
-static const struct file_operations read_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= bad_pipe_w,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_read_open,
-	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
-};
-
-static const struct file_operations write_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= bad_pipe_r,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_write_open,
-	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
-};
-
-static const struct file_operations rdwr_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_rdwr_open,
-	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
-};
-
 struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
 {
 	struct pipe_inode_info *pipe;
@@ -927,7 +892,7 @@
 	inode->i_pipe = pipe;
 
 	pipe->readers = pipe->writers = 1;
-	inode->i_fop = &rdwr_pipe_fops;
+	inode->i_fop = &rdwr_pipefifo_fops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -978,7 +943,7 @@
 	d_instantiate(dentry, inode);
 
 	err = -ENFILE;
-	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipefifo_fops);
 	if (!f)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
@@ -1021,7 +986,7 @@
 
 	f->f_pos = 0;
 	f->f_flags = O_RDONLY;
-	f->f_op = &read_pipe_fops;
+	f->f_op = &read_pipefifo_fops;
 	f->f_mode = FMODE_READ;
 	f->f_version = 0;
 
