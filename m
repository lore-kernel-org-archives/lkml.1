Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbZJ1TAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbZJ1TAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZJ1TAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:00:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZJ1TAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:00:20 -0400
Date: Wed, 28 Oct 2009 12:00:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 2.6.32-rc
In-Reply-To: <20091028185101.GS10727@kernel.dk>
Message-ID: <alpine.LFD.2.01.0910281157160.31845@localhost.localdomain>
References: <20091028185101.GS10727@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Oct 2009, Jens Axboe wrote:
> 
> Neil Brown (1):
>       block: use after free bug in __blkdev_get
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 9cf4b92..8bed055 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1248,8 +1248,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
>  		}
>  	} else {
> -		put_disk(disk);
>  		module_put(disk->fops->owner);
> +		put_disk(disk);
>  		disk = NULL;
>  		if (bdev->bd_contains == bdev) {
>  			if (bdev->bd_disk->fops->open) {

Is this really right? You do the module-put while the disk is still 
available..

I get the feeling that it might have been better to do

	struct module *mod = disk->fops->owner;
	put_disk(disk);
	module_put(mod);

instead, which tries to make sure that the module is put only after we've 
gotten rid of the disk entirely.

But I dunno. Maybe there is some reason why it's safe either way. You're 
sure the kobject_put() in put_disk will never call to the module?

		Linus
