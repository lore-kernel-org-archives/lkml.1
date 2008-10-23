Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYJWQqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYJWQqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYJWQqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:46:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40167 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751601AbYJWQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:46:01 -0400
Date: Thu, 23 Oct 2008 12:46:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manish Lachwani <mlachwani@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: oops in file_storage.c
In-Reply-To: <431757fd0810230835m454a18bav24347e4851b7cb85@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0810231238550.2453-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Manish Lachwani wrote:

> Hi Alan,
> 
> >
> > Hmm.  On my system (2.6.27) the code has moved to fs/sync.c/do_fsync(),
> > and it has changed a fair amount.  Maybe file_storage.c should be
> > changed to match.
> 
> I have the latest git checkout of
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> and it seems that do_fsync() is still quite similar to fsync_sub().
> Also, I checked older trees like 2.6.22 and do_fsync() is still in
> fs/sync.c

That just goes to show how old file_storage.c is.

> > In fact, the easiest approach would be to EXPORT do_fsync() and then
> > call it directly.  I don't know whether people would like this, though.
> >
> 
> I could try this. But I don't see much difference b/w do_fsync() and
> fsync_sub(). However in do_fsync(), filemap_fdatawrite() is called
> before the mutex_lock() and filemap_fdatawait() is called after the
> mutex_unlock().
> 
> Here is do_fsync() -
> 
> long do_fsync(struct file *file, int datasync)
> {
>         int ret;
>         int err;
>         struct address_space *mapping = file->f_mapping;

file_storage does

		inode = filp->f_path.dentry->d_inode;

instead, and uses inode in place of mapping->host and inode->i_mapping 
in place of mapping.  Should this be changed?  I have no idea, beyond 
feeling that the core kernel code has got to be more up-to-date.  Same 
goes for the ordering of the locks and the filemap_* calls.

>         if (!file->f_op || !file->f_op->fsync) {
>                 /* Why?  We can still call filemap_fdatawrite */
>                 ret = -EINVAL;
>                 goto out;
>         }
> 
>         ret = filemap_fdatawrite(mapping);
> 
>         /*
>          * We need to protect against concurrent writers, which could cause
>          * livelocks in fsync_buffers_list().
>          */
>         mutex_lock(&mapping->host->i_mutex);
>         err = file->f_op->fsync(file, file->f_path.dentry, datasync);
>         if (!ret)
>                 ret = err;
>         mutex_unlock(&mapping->host->i_mutex);
>         err = filemap_fdatawait(mapping);
>         if (!ret)
>                 ret = err;
> out:
>         return ret;
> }

If the EXPORT route is acceptable, I'd prefer to use it.

Alan Stern

