Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZIWIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZIWIXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZIWIXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:23:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:32974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZIWIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:23:21 -0400
From: Neil Brown <neilb@suse.de>
To: Dmitry Monakhov <rjevskiy@gmail.com>
Date: Wed, 23 Sep 2009 18:24:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19129.56117.549751.226346@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid-1/10: fix RW bits manipulation
In-Reply-To: message from Dmitry Monakhov on Sunday September 20
References: <c18d6aa20909192252j4b895ed5t278070ab47b0114@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday September 20, rjevskiy@gmail.com wrote:
> Recently Jens has changed bio_rw_flagged() logic by following
> commit 1f98a13f623e0ef666690a18c1250335fc6d7ef1. Now it returns
> bool instead of int. This broke raid1/raid10 RW bits manipulation logic.
> One of visible result is BUG_ON triggering due to empty barrier
> here scsi_lib.c:1108 scsi_setup_fs_cmnd()

Thanks for this.  It looks good.  I will forward it to Linus shortly.

NeilBrown


> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  drivers/md/raid1.c  |   10 ++++++----
>  drivers/md/raid10.c |    6 +++---
>  2 files changed, 9 insertions(+), 7 deletions(-)
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ff7ed33..5de48e5 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -851,7 +851,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
>  		read_bio->bi_bdev = mirror->rdev->bdev;
>  		read_bio->bi_end_io = raid1_end_read_request;
> -		read_bio->bi_rw = READ | do_sync;
> +		read_bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
>  		read_bio->bi_private = r1_bio;
>  
>  		generic_make_request(read_bio);
> @@ -943,7 +943,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
>  		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
>  		mbio->bi_end_io	= raid1_end_write_request;
> -		mbio->bi_rw = WRITE | do_barriers | do_sync;
> +		mbio->bi_rw = WRITE | (do_barriers << BIO_RW_BARRIER) |
> +			(do_sync << BIO_RW_SYNCIO);
>  		mbio->bi_private = r1_bio;
>  
>  		if (behind_pages) {
> @@ -1623,7 +1624,8 @@ static void raid1d(mddev_t *mddev)
>  						conf->mirrors[i].rdev->data_offset;
>  					bio->bi_bdev = conf->mirrors[i].rdev->bdev;
>  					bio->bi_end_io = raid1_end_write_request;
> -					bio->bi_rw = WRITE | do_sync;
> +					bio->bi_rw = WRITE |
> +						(do_sync << BIO_RW_SYNCIO);
>  					bio->bi_private = r1_bio;
>  					r1_bio->bios[i] = bio;
>  					generic_make_request(bio);
> @@ -1672,7 +1674,7 @@ static void raid1d(mddev_t *mddev)
>  				bio->bi_sector = r1_bio->sector + rdev->data_offset;
>  				bio->bi_bdev = rdev->bdev;
>  				bio->bi_end_io = raid1_end_read_request;
> -				bio->bi_rw = READ | do_sync;
> +				bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
>  				bio->bi_private = r1_bio;
>  				unplug = 1;
>  				generic_make_request(bio);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d0a2152..f2c891f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -882,7 +882,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  			mirror->rdev->data_offset;
>  		read_bio->bi_bdev = mirror->rdev->bdev;
>  		read_bio->bi_end_io = raid10_end_read_request;
> -		read_bio->bi_rw = READ | do_sync;
> +		read_bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
>  		read_bio->bi_private = r10_bio;
>  
>  		generic_make_request(read_bio);
> @@ -950,7 +950,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  			conf->mirrors[d].rdev->data_offset;
>  		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
>  		mbio->bi_end_io	= raid10_end_write_request;
> -		mbio->bi_rw = WRITE | do_sync;
> +		mbio->bi_rw = WRITE | (do_sync << BIO_RW_SYNCIO);
>  		mbio->bi_private = r10_bio;
>  
>  		atomic_inc(&r10_bio->remaining);
> @@ -1623,7 +1623,7 @@ static void raid10d(mddev_t *mddev)
>  				bio->bi_sector = r10_bio->devs[r10_bio->read_slot].addr
>  					+ rdev->data_offset;
>  				bio->bi_bdev = rdev->bdev;
> -				bio->bi_rw = READ | do_sync;
> +				bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
>  				bio->bi_private = r10_bio;
>  				bio->bi_end_io = raid10_end_read_request;
>  				unplug = 1;
> -- 
> 1.6.2.2.446.gfbdc0
> 
