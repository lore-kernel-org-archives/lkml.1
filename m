Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXJ3IK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXJ3IK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXJ3IKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:10:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4761 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXJ3IKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:10:12 -0400
Date: Tue, 30 Oct 2007 09:07:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071030080742.GE4993@kernel.dk>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029154849.GA24187@bigserver.hohndel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Dirk Hohndel wrote:
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 52d6385..bb3933e 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -61,7 +61,10 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
>  				}
>  			}
>  			/* all seems OK */
> -			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
> +			if (add_partition(disk, part, start, length, ADDPART_FLAG_NONE)) {
> +				mutex_unlock(&bdev->bd_mutex);
> +				return -EBUSY;
> +			}
>  			mutex_unlock(&bdev->bd_mutex);
>  			return 0;
>  		case BLKPG_DEL_PARTITION:
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 722e12e..cd92471 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -368,13 +368,13 @@ void delete_partition(struct gendisk *disk, int part)
>  	kobject_put(&p->kobj);
>  }
>  
> -void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
> +int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
>  {
>  	struct hd_struct *p;
>  
>  	p = kzalloc(sizeof(*p), GFP_KERNEL);
>  	if (!p)
> -		return;
> +		return -1;

Why not return the 'correct' error codes, instead of always -1 and
making that -EBUSY at the caller? This one should be -ENOMEM.

IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
the correct return values, the patch then looks fine to me.

-- 
Jens Axboe

