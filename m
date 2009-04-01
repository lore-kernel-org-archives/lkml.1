Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbZDALs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbZDALs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZDALsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:48:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:59675 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZDALst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:48:49 -0400
Date: Wed, 1 Apr 2009 20:47:31 +0900
To: tj@kernel.org
Cc: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] block: fix SG_IO vector request data length
 handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1238583884-13517-3-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
	<1238583884-13517-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401204716N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 20:47:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Apr 2009 20:04:38 +0900
Tejun Heo <tj@kernel.org> wrote:

> Impact: fix SG_IO behavior such that it matches the documentation
> 
> SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
> shorter one wins.  However, the current implementation returns -EINVAL
> for such cases.  Trim iovc if it's longer than ->dxfer_len.

Is that description about sg's SG_IO?


> This patch uses iov_*() helpers which take struct iovec * by casting
> struct sg_iovec * to it.  sg_iovec is always identical to iovec and
> this will be further cleaned up with later patches.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/scsi_ioctl.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 626ee27..c8e8868 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -288,6 +288,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  
>  	if (hdr->iovec_count) {
>  		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
> +		size_t iov_data_len;
>  		struct sg_iovec *iov;
>  
>  		iov = kmalloc(size, GFP_KERNEL);
> @@ -302,8 +303,18 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  			goto out;
>  		}
>  
> +		/* SG_IO howto says that the shorter of the two wins */
> +		iov_data_len = iov_length((struct iovec *)iov,
> +					  hdr->iovec_count);
> +		if (hdr->dxfer_len < iov_data_len) {
> +			hdr->iovec_count = iov_shorten((struct iovec *)iov,
> +						       hdr->iovec_count,
> +						       hdr->dxfer_len);
> +			iov_data_len = hdr->dxfer_len;
> +		}
> +
>  		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
> -					  hdr->dxfer_len, GFP_KERNEL);
> +					  iov_data_len, GFP_KERNEL);
>  		kfree(iov);
>  	} else if (hdr->dxfer_len)
>  		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
