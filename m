Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYIDRAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYIDRAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYIDQ7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:59:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34141 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYIDQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:59:51 -0400
Message-ID: <48C012F3.3000408@redhat.com>
Date: Thu, 04 Sep 2008 11:55:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Sato <t-sato@yk.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
References: <20080818212819t-sato@mail.jp.nec.com>
In-Reply-To: <20080818212819t-sato@mail.jp.nec.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Sato wrote:

> @@ -141,6 +142,57 @@ static int ioctl_fioasync(unsigned int f
>  }
>  
>  /*
> + * ioctl_freeze - Freeze the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call freeze_bdev() to freeze the filesystem.
> + */
> +static int ioctl_freeze(struct file *filp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If filesystem doesn't support freeze feature, return. */
> +	if (sb->s_op->write_super_lockfs == NULL)
> +		return -EOPNOTSUPP;
> +
> +	/* If a regular file or a directory isn't specified, return. */
> +	if (sb->s_bdev == NULL)
> +		return -EINVAL;
> +
> +	/* Freeze */
> +	sb = freeze_bdev(sb->s_bdev);
> +	if (IS_ERR(sb))
> +		return PTR_ERR(sb);
> +	return 0;
> +}

Not a problem with your patch exactly, but I was just wondering; you
check here whether the sb returned from freeze_bdev is an ERR_PTR (as
does lock_fs()) - but, freeze_bdev never returns an error, does it?
->write_super_lockfs is a void...

It really seems that at least we should be able to handle IO errors on
the freeze request, and tell the user "No, your filesystem was not
frozen..."?

Maybe I'll whip up a patch to see about propagating freeze errors up
from the filesystems that implement it, unless I'm missing some reason
not to do so...?

Also, should this be checking for a NULL returned from freeze_bdev as
well?  I guess this should never happen if we have a file open on which
we are calling the ioctl ...

-Eric
