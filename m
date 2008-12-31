Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYLaUPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYLaUPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYLaUPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:15:07 -0500
Received: from mx02.mailboxcop.com ([206.125.223.72]:48113 "EHLO
	mx02.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbYLaUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:15:05 -0500
Message-ID: <495BD346.9040408@jaysonking.com>
Date: Wed, 31 Dec 2008 14:17:10 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: problem with "sched: revert back to per-rq vruntime"?
References: <495948E0.8040502@jaysonking.com>	 <495A788B.3010001@jaysonking.com> <1230740773.6412.21.camel@marge.simson.net>
In-Reply-To: <1230740773.6412.21.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.44
X-Bayes-Prob: 0.0008 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333484876 - 38824edb3a29
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333484876&m=38824edb3a29&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333484876&m=38824edb3a29&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333484876&m=38824edb3a29&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Tue, 2008-12-30 at 13:37 -0600, Jayson King wrote:
>   
>> Here's some times using bash, for example. Let me know if there are some 
>> other tests I can do.
>>
>>     
>> [jayson@atlas tmp]$ time bash -i -c 'exit'
>> exit
>>
>> real    0m0.753s
>> user    0m0.011s
>> sys     0m0.011s
>>     
>
> Yeah, it's b0rked.  The problem is that we call sched_slice() before the
> new task's load weight has been added to the runqueue.  
>
> Normally this doesn't cause horrible problems, but when there is a +nice
> hog on the runqueue, the lighter the hog, and/or heavier the victim...
>
> [  160.489402] bash:5858 vslice: 3840000000 weight: 1024 rq_weight: 15 inv_weight: 268435456
>
> ...the closer the victim's vruntime gets to the middle of next week.
>
> Not-signed-off diag hack.
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5ad4440..3254213 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -449,13 +449,34 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  }
>  
>  /*
> + * A freshly forked task's load weight has not yet been added to the runqueue,
> + * so we can't call calc_delta_weight() and get sane results.  Therefore, we roll
> + * our own so place_entity() can place this task in the right spot.  The runqueue
> + * weight and nr_running will be updated when the task is enqueued.
> + */
> +static u64 sched_initial_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +{
> +	u64 slice = __sched_period(cfs_rq->nr_running + 1);
> +
> +	for_each_sched_entity(se) {
> +		struct load_weight lw = cfs_rq->load;
> +
> +		lw.weight += se->load.weight;
> +		lw.inv_weight = 0;
> +		slice = calc_delta_mine(slice, se->load.weight, &lw);
> +	}
> +
> +	return slice;
> +}
> +
> +/*
>   * We calculate the vruntime slice of a to be inserted task
>   *
>   * vs = s/w
>   */
>  static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -	return calc_delta_fair(sched_slice(cfs_rq, se), se);
> +	return calc_delta_fair(sched_initial_slice(cfs_rq, se), se);
>  }
>  
>  /*
>   

I tested it. Now the times are back to normal.

# 2.6.28 under 100% nice CPU and Mike Galbraith patch
[jayson@atlas tmp]$ time bash -i -c 'exit'
exit

real    0m0.042s
user    0m0.006s
sys     0m0.003s



Jayson

