Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYGAIDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYGAIDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYGAIDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:03:40 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:33560 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYGAIDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=mYPyw77xHGwOXg6TkrH/irCKUcT0Fe2r7IIlNGfZlktJfFERDcfleKKJDpDhtRLvml
         aEGBsDG4Q/X/4kH4xmQ0BxjfmoCGlTvpRcRQ4wSgf0veJ622udKkhel3/V7613MoAHNs
         sGS14dDOWYjVubsYc3Z3OuQAlPeT9eZADZMYI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Date: Tue, 1 Jul 2008 12:03:50 +0200
User-Agent: KMail/1.8.2
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200807011103.02974.vda.linux@googlemail.com> <20080701003255.493f54e0.akpm@linux-foundation.org>
In-Reply-To: <20080701003255.493f54e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011203.50632.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008 09:32, Andrew Morton wrote:
> > I noticed that read/write/rdwr_pipe_fops are (1) const and
> > (2) exactly identical to xxx_fifo_fops, which are also const.
> > 
> > Attached patch #defines xxx_pipe_fops as aliases to xxx_fifo_fops.
> > Size difference:
> > 
> > # size linux-2.6.25-rc6*/*/pipe.o
> >    text    data     bss     dec     hex filename
> >    6534     144       0    6678    1a16 linux-2.6.25-rc6/fs/pipe.o
> >    5862     144       0    6006    1776 linux-2.6.25-rc6-pt/fs/pipe.o
> > 
> > Run-tested on 2.6.26-rc8. Please apply.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> <argh, an attachment.  save-as, read, edit..>

Let's see how KMail will cope with inline cut-n-paste...

> > -static const struct file_operations rdwr_pipe_fops = {
> > -	.llseek		= no_llseek,
> > -	.read		= do_sync_read,
> > -	.aio_read	= pipe_read,
> > -	.write		= do_sync_write,
> > -	.aio_write	= pipe_write,
> > -	.poll		= pipe_poll,
> > -	.unlocked_ioctl	= pipe_ioctl,
> > -	.open		= pipe_rdwr_open,
> > -	.release	= pipe_rdwr_release,
> > -	.fasync		= pipe_rdwr_fasync,
> > -};
> > +#define read_pipe_fops  read_fifo_fops
> > +#define write_pipe_fops write_fifo_fops
> > +#define rdwr_pipe_fops  rdwr_fifo_fops
> 
> Well OK.  But there's a risk that someone will go and modify
> read_fifo_fops without realising that they're also modifying
> read_pipe_fops.

Yes, it is possible.

> So it'd be better to rename read_fifo_fops to (say) shared_read_fops
> then do
> 
> #define read_pipe_fops shared_read_fops
> #define read_fifo_fops shared_read_fops

I think since XXX_pipe_fops are only used in this file,
just explaining this in the comment would be enough.

Please take a look at the version below.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- linux-2.6.26-rc8/fs/pipe.c.org	Tue Jul  1 11:52:28 2008
+++ linux-2.6.26-rc8/fs/pipe.c	Tue Jul  1 11:58:23 2008
@@ -777,6 +777,8 @@
 /*
  * The file_operations structs are not static because they
  * are also used in linux/fs/fifo.c to do operations on FIFOs.
+ *
+ * Pipes reuse fifos' file_operations structs.
  */
 const struct file_operations read_fifo_fops = {
 	.llseek		= no_llseek,
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
+	inode->i_fop = &rdwr_fifo_fops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -978,7 +943,7 @@
 	d_instantiate(dentry, inode);
 
 	err = -ENFILE;
-	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_fifo_fops);
 	if (!f)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
@@ -1021,7 +986,7 @@
 
 	f->f_pos = 0;
 	f->f_flags = O_RDONLY;
-	f->f_op = &read_pipe_fops;
+	f->f_op = &read_fifo_fops;
 	f->f_mode = FMODE_READ;
 	f->f_version = 0;
 
