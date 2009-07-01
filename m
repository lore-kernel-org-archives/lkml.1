Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbZGABgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbZGABgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZGABgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:36:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36139 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZGABgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:36:21 -0400
Date: Tue, 30 Jun 2009 21:32:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH] io-controller: Don't expire an idle ioq if it's the
	only ioq in hierarchy
Message-ID: <20090701013239.GB13958@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-9-git-send-email-vgoyal@redhat.com> <4A49C381.3040302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A49C381.3040302@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 03:49:21PM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> We don't expect expiring an idle ioq if it's the only ioq 
> in the hierarchy.
> 

Hi Gui,

This patch will avoid idle queue expiry for single ioq schedulers. But
that's not an issue anyway as single ioq schedulers don't have the notion
of idle queue. It is only CFQ which allows creation of idle ioq.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 4270cfd..0b65e16 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -4058,12 +4058,6 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  			elv_clear_ioq_slice_new(ioq);
>  		}
>  
> -		if (elv_ioq_class_idle(ioq)) {
> -			if (elv_iosched_expire_ioq(q, 1, 0))
> -				elv_ioq_slice_expired(q);
> -			goto done;
> -		}
> -
>  		/*
>  		 * If there is only root group present, don't expire the queue
>  		 * for single queue ioschedulers (noop, deadline, AS). It is
> @@ -4077,6 +4071,12 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  			goto done;
>  		}
>  
> +		if (elv_ioq_class_idle(ioq)) {
> +			if (elv_iosched_expire_ioq(q, 1, 0))
> +				elv_ioq_slice_expired(q);
> +			goto done;
> +		}
> +
>  		/* For async queue try to do wait busy */
>  		if (efqd->fairness && !elv_ioq_sync(ioq) && !ioq->nr_queued
>  		    && (elv_iog_nr_active(iog) <= 1)) {
> -- 
> 1.5.4.rc3
> 
