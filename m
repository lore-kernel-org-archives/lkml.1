Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZKXTgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZKXTgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbZKXTgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:36:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200AbZKXTgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:36:41 -0500
Date: Tue, 24 Nov 2009 14:36:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: cleanup unreachable code
Message-ID: <20091124193638.GA2803@redhat.com>
References: <200911241701.49677.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911241701.49677.czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 05:01:49PM +0100, Corrado Zoccolo wrote:
> cfq_should_idle returns false for no-idle queues that are not the last,
> so the control flow will never reach the removed code in a state that
> satisfies the if condition.
> The unreachable code was added to emulate previous cfq behaviour for
> non-NCQ rotational devices. My tests show that even without it, the
> performances and fairness are comparable with previous cfq, thanks to
> the fact that all seeky queues are grouped together, and that we idle at
> the end of the tree.
> 

As you said that right now it is dead code, so better remove it.

Theoretically, by retaining this code we could benefit on non NCQ
rotational media if seek cost across the sync-noidle queues is higher
as compared to seek cost with-in queue. Fix it if we run into it.

Till then better to remove dead code.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d44f8a4..7144649 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1274,19 +1274,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  	cfq_mark_cfqq_wait_request(cfqq);
>  
>  	sl = cfqd->cfq_slice_idle;
> -	/* are we servicing noidle tree, and there are more queues?
> -	 * non-rotational or NCQ: no idle
> -	 * non-NCQ rotational : very small idle, to allow
> -	 *     fair distribution of slice time for a process doing back-to-back
> -	 *     seeks.
> -	 */
> -	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
> -	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WORKLOAD, cfqd)
> -		->count > 0) {
> -		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
> -			return;
> -		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
> -	}
>  
>  	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
>  	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
> -- 
> 1.6.2.5
> 
