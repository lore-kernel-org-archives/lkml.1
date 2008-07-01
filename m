Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYGAIJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYGAIJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYGAIIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:08:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYGAIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:08:49 -0400
Date: Tue, 1 Jul 2008 04:08:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Message-ID: <20080701080844.GA16691@infradead.org>
References: <20080630212323t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212323t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  {
>  	struct super_block *sb;
>  
> +	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
> +		return ERR_PTR(-EBUSY);
> +
> +	sb = get_super(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		drop_super(sb);
> +		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +		return sb;
> +	}
> +
> +	if (sb)
> +		drop_super(sb);
> +
>  	down(&bdev->bd_mount_sem);
>  	sb = get_super(bdev);
>  	if (sb && !(sb->s_flags & MS_RDONLY)) {
> @@ -219,6 +234,8 @@ struct super_block *freeze_bdev(struct b
>  	}
>  
>  	sync_blockdev(bdev);
> +	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +

Please only clear BD_FREEZE_OP in thaw_bdev, that way you can also get
rid of the frozen check above, and the double-get_super.  Also
bd_mount_sem could be removed that way by checking for BD_FREEZE_OP
in the unmount path.

>  /*
> + * ioctl_freeze - Freeze the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call freeze_bdev() to freeze the filesystem.
> + */

This is not a kerneldoc comment.  But I think it can be simply removed
anyway, as it's a quite trivial function with static scope.

> +/*
> + * ioctl_thaw - Thaw the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call thaw_bdev() to thaw the filesystem.
> + */

Same here.

