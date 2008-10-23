Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYJWOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYJWOqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYJWOp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:45:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45532 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752252AbYJWOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:45:56 -0400
Date: Thu, 23 Oct 2008 10:45:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manish Lachwani <mlachwani@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: oops in file_storage.c
In-Reply-To: <431757fd0810221821o4aa1a63ck425e0988fb761a63@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0810231032550.2453-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Manish Lachwani wrote:

> Hi Alan,
> 
> I am using the 2.6.27 kernel on a ARM platform. In a test that
> transfers big files over the gadget interface, i occasionally run into
> an oops:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000003c
> Internal error: Oops: 17 [#1] PREEMPT
> Modules linked in: ppp_deflate ppp_async crc_ccitt ppp_generic slhc
> mxc_alsa_pmic snd_pcm snd_page_a
> lloc snd_timer snd fiveway mxc_keyb ip_queue iptable_filter ip_tables
> x_tables uinput fuse g_file_st
> orage mwan arcotg_udc charger eink_fb_pnlcd eink_fb_shim
> eink_fb_hal_broads eink_fb_hal
> CPU: 0 Not tainted (2.6.22.19-lab126 #4)
> PC is at fsync_sub+0x70/0xb4 [g_file_storage]
...

> So far, I am running into this issue only when I am trying to copy a
> large file when the device disk is almost full.

Odd.  Maybe this has to do with whether or not fsync_sub() gets called.

> The crash looks to occur at:
> 
>  e0c:       e593f03c        ldr     pc, [r3, #60]
> 
> this seems to be loading the filp->f_op->fsync into PC.
> 
> "Unable to handle kernel NULL pointer dereference at virtual address
> 0000003c" points to offset 60 as well.
> 
> However, there is a check for filp->f_op->fsync at the begining of the fn:
> 
>         if (!filp->f_op->fsync)
>                 return -EINVAL;
> 
> I noticed in fs/sync.c, similar check as part of sys_fdatasync:
> 
> if (!file->f_op || !file->f_op->fsync) {
> 
> I modified the code in fsync_sub() to do this and so far, no crash. Do
> you think this makes sense?
> 
> diff --git a/drivers/usb/gadget/file_storage.c
> b/drivers/usb/gadget/file_storage.c
> index c4e62a6..46db662 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -1859,7 +1859,7 @@ static int do_write(struct fsg_dev *fsg)
>  /*-------------------------------------------------------------------------*/
> 
>  /* Sync the file data, don't bother with the metadata.
> - * This code was copied from fs/buffer.c:sys_fdatasync(). */
> + * This code was copied from fs/sync.c:sys_fdatasync(). */
>  static int fsync_sub(struct lun *curlun)
>  {
>         struct file     *filp = curlun->filp;
> @@ -1868,7 +1868,7 @@ static int fsync_sub(struct lun *curlun)
> 
>         if (curlun->ro || !filp)
>                 return 0;
> -       if (!filp->f_op->fsync)
> +       if (!filp->f_op || !filp->f_op->fsync)
>                 return -EINVAL;
> 
>         inode = filp->f_path.dentry->d_inode;

Hmm.  On my system (2.6.27) the code has moved to fs/sync.c/do_fsync(),
and it has changed a fair amount.  Maybe file_storage.c should be 
changed to match.

In fact, the easiest approach would be to EXPORT do_fsync() and then 
call it directly.  I don't know whether people would like this, though.

Alan Stern

