Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYGAHdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYGAHdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYGAHd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:33:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYGAHd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:33:28 -0400
Date: Tue, 1 Jul 2008 00:32:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Message-Id: <20080701003255.493f54e0.akpm@linux-foundation.org>
In-Reply-To: <200807011103.02974.vda.linux@googlemail.com>
References: <200807011103.02974.vda.linux@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 11:03:02 +0200 Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi Andrew, Al,
> 
> I posted this patch a few months ago, but it apparently
> fell thru cracks. Here we go again.
> 
> I noticed that read/write/rdwr_pipe_fops are (1) const and
> (2) exactly identical to xxx_fifo_fops, which are also const.
> 
> Attached patch #defines xxx_pipe_fops as aliases to xxx_fifo_fops.
> Size difference:
> 
> # size linux-2.6.25-rc6*/*/pipe.o
>    text    data     bss     dec     hex filename
>    6534     144       0    6678    1a16 linux-2.6.25-rc6/fs/pipe.o
>    5862     144       0    6006    1776 linux-2.6.25-rc6-pt/fs/pipe.o
> 
> Run-tested on 2.6.26-rc8. Please apply.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

<argh, an attachment.  save-as, read, edit..>

--- linux-2.6.25-rc6.src/fs/pipe.c	Sat Mar 22 23:00:34 2008
> +++ linux-2.6.25-rc6.pipe/fs/pipe.c	Fri Mar 28 15:52:00 2008
> @@ -814,42 +814,9 @@
>  	.fasync		= pipe_rdwr_fasync,
>  };
>  
> -static const struct file_operations read_pipe_fops = {
> -	.llseek		= no_llseek,
> -	.read		= do_sync_read,
> -	.aio_read	= pipe_read,
> -	.write		= bad_pipe_w,
> -	.poll		= pipe_poll,
> -	.unlocked_ioctl	= pipe_ioctl,
> -	.open		= pipe_read_open,
> -	.release	= pipe_read_release,
> -	.fasync		= pipe_read_fasync,
> -};
> -
> -static const struct file_operations write_pipe_fops = {
> -	.llseek		= no_llseek,
> -	.read		= bad_pipe_r,
> -	.write		= do_sync_write,
> -	.aio_write	= pipe_write,
> -	.poll		= pipe_poll,
> -	.unlocked_ioctl	= pipe_ioctl,
> -	.open		= pipe_write_open,
> -	.release	= pipe_write_release,
> -	.fasync		= pipe_write_fasync,
> -};
> -
> -static const struct file_operations rdwr_pipe_fops = {
> -	.llseek		= no_llseek,
> -	.read		= do_sync_read,
> -	.aio_read	= pipe_read,
> -	.write		= do_sync_write,
> -	.aio_write	= pipe_write,
> -	.poll		= pipe_poll,
> -	.unlocked_ioctl	= pipe_ioctl,
> -	.open		= pipe_rdwr_open,
> -	.release	= pipe_rdwr_release,
> -	.fasync		= pipe_rdwr_fasync,
> -};
> +#define read_pipe_fops  read_fifo_fops
> +#define write_pipe_fops write_fifo_fops
> +#define rdwr_pipe_fops  rdwr_fifo_fops
>  
>  struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
>  {

Well OK.  But there's a risk that someone will go and modify
read_fifo_fops without realising that they're also modifying
read_pipe_fops.

So it'd be better to rename read_fifo_fops to (say) shared_read_fops
then do

#define read_pipe_fops shared_read_fops
#define read_fifo_fops shared_read_fops

no?
