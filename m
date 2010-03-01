Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab0CAO0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:26:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0CAO0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:26:05 -0500
Date: Mon, 1 Mar 2010 09:25:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
Message-ID: <20100301142553.GB8878@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <1267296340-3820-2-git-send-email-czoccolo@gmail.com> <1267296340-3820-3-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267296340-3820-3-git-send-email-czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 07:45:40PM +0100, Corrado Zoccolo wrote:
> CFQ currently applies the same logic of detecting seeky queues and
> grouping them together for rotational disks as well as SSDs.
> For SSDs, the time to complete a request doesn't depend on the
> request location, but only on the size.
> This patch therefore changes the criterion to group queues by
> request size in case of SSDs, in order to achieve better fairness.

Hi Corrado,

Can you give some numbers regarding how are you measuring fairness and
how did you decide that we achieve better fairness?

In case of SSDs with NCQ, we will not idle on any of the queues (either
sync or sync-noidle (seeky queues)). So w.r.t code, what behavior changes
if we mark a queue as seeky/non-seeky on SSD?

IOW, looking at this patch, now any queue doing IO in smaller chunks than
32K on SSD will be marked as seeky. How does that change the behavior in 
terms of fairness for the queue?
 
Thanks
Vivek

> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 806d30b..f27e535 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -47,6 +47,7 @@ static const int cfq_hist_divisor = 4;
>  #define CFQ_SERVICE_SHIFT       12
>  
>  #define CFQQ_SEEK_THR		(sector_t)(8 * 100)
> +#define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
>  #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
>  
>  #define RQ_CIC(rq)		\
> @@ -2958,6 +2959,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  		       struct request *rq)
>  {
>  	sector_t sdist = 0;
> +	sector_t n_sec = blk_rq_sectors(rq);
>  	if (cfqq->last_request_pos) {
>  		if (cfqq->last_request_pos < blk_rq_pos(rq))
>  			sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
> @@ -2966,7 +2968,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	}
>  
>  	cfqq->seek_history <<= 1;
> -	cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
> +	if (blk_queue_nonrot(cfqd->queue))
> +		cfqq->seek_history |= (n_sec < CFQQ_SECT_THR_NONROT);
> +	else
> +		cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
>  }
>  
>  /*
> -- 
> 1.6.4.4
