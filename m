Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYIHRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYIHRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIHRKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:10:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYIHRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:10:35 -0400
Date: Mon, 8 Sep 2008 13:10:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Message-ID: <20080908171020.GA22521@infradead.org>
References: <20080908205245t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908205245t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 08:52:45PM +0900, Takashi Sato wrote:
> diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/fs/block_dev.c linux-2.6.27-rc5-freeze/fs
> /block_dev.c
> --- linux-2.6.27-rc5.org/fs/block_dev.c	2008-08-29 07:52:02.000000000 +0900
> +++ linux-2.6.27-rc5-freeze/fs/block_dev.c	2008-09-05 20:00:29.000000000 +0900
> @@ -285,6 +285,8 @@ static void init_once(void *foo)
>  	INIT_LIST_HEAD(&bdev->bd_holder_list);
>  #endif
>  	inode_init_once(&ei->vfs_inode);
> +	/* Initialize mutex for freeze. */
> +	mutex_init(&bdev->bd_fsfreeze_mutex);

Why not just freeze_mutex?


>  struct super_block *freeze_bdev(struct block_device *bdev)
>  {
>  	struct super_block *sb;
>  
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (bdev->bd_fsfreeze_count > 0) {
> +		bdev->bd_fsfreeze_count++;
> +		sb = get_super(bdev);
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return sb;
> +	}
> +	bdev->bd_fsfreeze_count++;
> +
>  	down(&bdev->bd_mount_sem);

Note that we still have duplication with the bd_mount_sem.  I think
you should look into getting rid of it and instead do a check of
the freeze_count under proper freeze_mutex protection.

> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (!bdev->bd_fsfreeze_count) {
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return 0;
> +	}
> +
> +	bdev->bd_fsfreeze_count--;
> +	if (bdev->bd_fsfreeze_count > 0) {
> +		if (sb)
> +			drop_super(sb);
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return 0;
> +	}
> +
>  	if (sb) {
>  		BUG_ON(sb->s_bdev != bdev);
>  
> @@ -244,6 +274,8 @@ void thaw_bdev(struct block_device *bdev
>  	}
>  
>  	up(&bdev->bd_mount_sem);
> +	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +	return 0;

Why do you add a return value here if we always return 0 anyway?

