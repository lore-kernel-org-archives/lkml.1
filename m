Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYHVSPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYHVSPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYHVSPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:15:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYHVSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:15:03 -0400
Date: Fri, 22 Aug 2008 14:14:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20080822181458.GA15469@infradead.org>
References: <20080818212819t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818212819t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 09:28:19PM +0900, Takashi Sato wrote:
> +	down(&bdev->bd_freeze_sem);
> +	bdev->bd_freeze_count++;
> +	if (bdev->bd_freeze_count > 1) {
> +		sb = get_super(bdev);
> +		drop_super(sb);
> +		up(&bdev->bd_freeze_sem);
> +		return sb;
> +	}
> +
>  	down(&bdev->bd_mount_sem);

Now you have a reference counter of freezes which actually is pretty
sensible, but also needs some documentation.  What I don't understand
here at all is why you do the get_super/drop_super in the already frozen
case.

Now that the freeze_count has replaced one of the uses of bd_mount_sem
you should also replace the other use in the unmount path by simply
checking for the freez_count and abort if it's set.  To do so you'll
need to hold the bd_mount_sem over the whole unmount operation to
prevent new frezes from coming in.

As others noted it should be a mutex and not a semaphore.

>  /*
> + * ioctl_freeze - Freeze the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call freeze_bdev() to freeze the filesystem.
> + */
> +static int ioctl_freeze(struct file *filp)

This is not quite kerneldcoc format, which would ne a /** as commnt
start.  But I don't think the comment is actually needed, it's a pretty
obvious file scope function. (Same commnt also applies to ioctl_thaw)

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

I don't understand this commnt.  What you are checking is that the
filesystem has a non-NULL s_bdev, which implies a not blockdevice-backed
filesystem.

