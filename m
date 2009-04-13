Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZDMK00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZDMK00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 06:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbZDMK0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 06:26:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:59286 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbZDMK0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 06:26:16 -0400
Date: Mon, 13 Apr 2009 19:26:09 +0900
To: Jens.Axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] block: fix SG_IO to return a proper error value
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090403204911X.fujita.tomonori@lab.ntt.co.jp>
References: <20090403204911X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090413192604N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Apr 2009 19:26:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

This patch is necessary to return a proper error for applications
issuing READ requests with a bogus buffer.

On Fri, 3 Apr 2009 20:49:03 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> blk_rq_unmap_user() returns -EFAULT if a program passes an invalid
> address to kernel. SG_IO path needs to pass the returned value to user
> space instead of ignoring it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/scsi_ioctl.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 626ee27..84b7f87 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -217,7 +217,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
>  static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  				 struct bio *bio)
>  {
> -	int ret = 0;
> +	int r, ret = 0;
>  
>  	/*
>  	 * fill in all the output members
> @@ -242,7 +242,9 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  			ret = -EFAULT;
>  	}
>  
> -	blk_rq_unmap_user(bio);
> +	r = blk_rq_unmap_user(bio);
> +	if (!ret)
> +		ret = r;
>  	blk_put_request(rq);
>  
>  	return ret;
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
