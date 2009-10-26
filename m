Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZJZH0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZJZH0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZJZH0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:26:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZJZH0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:26:03 -0400
Date: Mon, 26 Oct 2009 08:26:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use after free bug in __blkdev_get
Message-ID: <20091026072607.GZ10727@kernel.dk>
References: <19173.11702.129258.49993@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19173.11702.129258.49993@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Neil Brown wrote:
> 
> 
> commit 0762b8bde9729f10f8e6249809660ff2ec3ad735
> (from 14 months ago) introduced a use-after-free bug which has just
> recently started manifesting in my md testing.
> I tried git bisect to find out what caused the bug to start
> manifesting, and it could have been the recent change to
> blk_unregister_queue (48c0d4d4c04) but the results were inconclusive.
> 
> This patch certainly fixes my symptoms and looks correct as the two
> calls are now in the same order as elsewhere in that function.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
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

Thanks Neil, good catch! Applied.

-- 
Jens Axboe

