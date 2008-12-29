Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYL2MoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYL2MoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYL2Mn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:43:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbYL2Mn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:43:58 -0500
Date: Mon, 29 Dec 2008 13:41:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081229124151.GA29634@redhat.com>
References: <20081229041352.6bbdf57c@tpl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229041352.6bbdf57c@tpl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Jonathan Corbet wrote:
>
> After pondering for a while, I couldn't come up with anything better than a
> global file->f_flags mutex.  There's no point in bloating struct file with
> a mutex just for this purpose; it's hard to imagine that there will be any
> real contention for this lock.

Yes, this patch is simple and straightforward, but now we can't change
->f_flags in non-preempible context. And the global lock is not very
nice anyway.

Once again, can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
and I won't insist if you don't like is.

	static inline int try_lock_f_flags(struct file *file)
	{
		return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
	}

	static inline set_f_flags(struct file *file, unsigned int flags)
	{
		file->f_flags = flags & ~O_LOCK_FLAGS;
	}

Now, nobody should change ->f_flags directly (except create/open
pathes. For example, ioctl_fionbio() should be changed:

		if (try_lock_f_flags(filp)) {
			if (on)
				set_f_flags(filp, filp->f_flags | flag);
			else
				set_f_flags(filp, filp->f_flags & ~flag);
		}

If try_lock_f_flags() fails we do nothing, as if the current owner of
O_LOCK_FLAGS changes ->f_flags after us.

What do you think?


> @@ -1116,6 +1116,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
>  	 * binary needs it. We might want to drop this workaround
>  	 * during an unstable branch.
>  	 */
> +	lock_file_flags();
>  	filp->f_flags |= O_LARGEFILE;
>
>  	if (filp->f_flags & O_NDELAY)
> @@ -1124,6 +1125,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
>  		filp->f_mode |= FMODE_EXCL;
>  	if ((filp->f_flags & O_ACCMODE) == 3)
>  		filp->f_mode |= FMODE_WRITE_IOCTL;
> +	unlock_file_flags();

do we really need lock_file_flags() here?

> diff --git a/fs/pipe.c b/fs/pipe.c
> index 7aea8b8..23ae227 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -945,7 +945,9 @@ struct file *create_write_pipe(int flags)
>  		goto err_dentry;
>  	f->f_mapping = inode->i_mapping;
>
> +	lock_file_flags();
>  	f->f_flags = O_WRONLY | (flags & O_NONBLOCK);
> +	unlock_file_flags();
>  	f->f_version = 0;
>
>  	return f;
> @@ -981,7 +983,9 @@ struct file *create_read_pipe(struct file *wrf, int flags)
>  	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
>
>  	f->f_pos = 0;
> +	lock_file_flags();
>  	f->f_flags = O_RDONLY | (flags & O_NONBLOCK);
> +	unlock_file_flags();

Ditto. Nobody can see this file yet, we can change ->f_flags lockless.

But please correct me if I am wrong, I know nothing about fs/.

Oleg.

