Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZK3ROQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZK3ROQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZK3ROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:14:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbZK3ROO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:14:14 -0500
Date: Mon, 30 Nov 2009 12:13:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: Re: [RFC] Block IO Controller V3
Message-ID: <20091130171347.GH11670@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com> <4B137470.3000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B137470.3000601@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 03:29:52PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi Jens,
> > 
> > This is V3 of the Block IO controller patches on top of "for-2.6.33" branch
> > of block tree.
> > 
> ...
> 
> Hi Vivek,
> 
> If an idle task is running group A and a normal task is running in group B, these
> two group have the same weight, I think IO Controller should isolate group A and
> group B, these two group should get 50% of the IO bw for each, right? But for this case,
> we don't see any isolation, instead, group B monopolizes almost all IO BW. I guess
> the major reason is idle cfqq is only allowed to dispatch one request and get expired.
> I think in order to get better isolation, we shouldn't expire the idle cfqq immediately
> if this idle queue is the only one this its group. The following patch enable idling
> for idle queue and prevent expiring it immediately after dispatch one request if it's 
> the only one in group. This patch is working for V3, hasn't tested on V4 yet.
> 

Hi Gui,

Thanks for the patch. I have intentionally kept idle queue make dispatch
one request at a time system wide irrespective of group.

What's the use case scenario of enforcing idle dispatch more based on
group weight. If somebody has marked a queue idle, he is not expecting
much of that queue anyway.

Now one can argue that for better isolation, don't make idle class system
wide and an idle task should get more disk time if there are no other
queues with-in group.

So for the time being I will leave as it is. We can fix this once somebody
needs stronger isolation even for idle tasks.

Thanks
Vivek
 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6f9d019..3440837 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -900,7 +900,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	struct cfq_rb_root *service_tree = cfqq->service_tree;
>  
>  	/* We never do for idle class queues. */
> -	if (prio == IDLE_WORKLOAD)
> +	if (prio == IDLE_WORKLOAD && cfqq->cfqg->nr_cfqq > 1)
>  		return false;
>  
>  	/* We do for queues that were marked with idle window flag. */
> @@ -2336,7 +2336,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>  	 * expire an async queue immediately if it has used up its slice. idle
>  	 * queue always expire after 1 dispatch round.
>  	 */
> -	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
> +	if (cfqq->cfqg->nr_cfqq  > 1 && ((!cfq_cfqq_sync(cfqq) &&
>  	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
>  	    cfq_class_idle(cfqq))) {
>  		cfqq->slice_end = jiffies + 1;
> -- 
> 1.5.4.rc3
> 
> -- 
> Regards
> Gui Jianfeng
