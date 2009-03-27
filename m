Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZC0OHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZC0OHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZC0OHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:07:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZC0OHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:07:36 -0400
Date: Fri, 27 Mar 2009 10:05:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: Re: [PATCH] IO Controller: No need to stop idling in as
Message-ID: <20090327140530.GE30476@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-11-git-send-email-vgoyal@redhat.com> <49CC791A.10008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC791A.10008@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 02:58:34PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> 
> >  		.elevator_alloc_sched_queue_fn = as_alloc_as_queue,
> >  		.elevator_free_sched_queue_fn = as_free_as_queue,
> > +#ifdef CONFIG_IOSCHED_AS_HIER
> > +		.elevator_expire_ioq_fn =       as_expire_ioq,
> > +		.elevator_active_ioq_set_fn =   as_active_ioq_set,
> >  	},
> > -
> > +	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,
> 
>   Hi Vivek,
> 
>   I found the IO Controller doesn't work in as.
>   I dig into this issue, and notice that you stop idling in as. IMHO, this will cause
>   active ioq is always expired when tring to choose a new ioq to serve(elv_fq_select_ioq). 
>   Because idling is disabled, active ioq can't be kept anymore.
>   So i just get rid of ELV_IOSCHED_DONT_IDLE, and it works fine this time.
> 

Hi Gui,

Thanks for the testing. I have not enabled idling for AS in common layer
becuase AS has its own idling/anticipation logic. I think we should not have
anticipation going on at two places, common layer as well as individual
io scheduler. That's the reason I have implemented a function
elv_iosched_expire_ioq(), which calls io scheduler to find out if an ioq
can be expired now. 

So in elv_fq_select_ioq(), we call elv_iosched_expire_ioq() and if
ioschduler denies expiration, then we don't expire the queue. In this case
AS can deny the expiration if it is anticipating for next request.

Actually AS is very different and its little tricky to make it work with
common layer, especially in terms of anticipation. This is on my TODO list
but before I fix AS, I wanted to get other things right with common layer,
cfq, noop and deadline.

Thanks
Vivek


> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/as-iosched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/as-iosched.c b/block/as-iosched.c
> index 27c14a7..499c521 100644
> --- a/block/as-iosched.c
> +++ b/block/as-iosched.c
> @@ -1689,7 +1689,7 @@ static struct elevator_type iosched_as = {
>  		.elevator_expire_ioq_fn =       as_expire_ioq,
>  		.elevator_active_ioq_set_fn =   as_active_ioq_set,
>  	},
> -	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,
> +	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
>  #else
>  	},
>  #endif
> -- 
> 1.5.4.rc3
> 
