Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZABAMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZABAMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 19:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZABAMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 19:12:25 -0500
Received: from mx03.mailboxcop.com ([206.125.223.73]:38614 "EHLO
	mx03.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZABAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 19:12:25 -0500
Message-ID: <495D5C70.4090804@jaysonking.com>
Date: Thu, 01 Jan 2009 18:14:40 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [patch] Re: problem with "sched: revert back to per-rq vruntime"?
References: <495948E0.8040502@jaysonking.com>	 <495A788B.3010001@jaysonking.com>	 <1230740773.6412.21.camel@marge.simson.net>	 <495BD346.9040408@jaysonking.com> <1230795963.5892.14.camel@marge.simson.net>
In-Reply-To: <1230795963.5892.14.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.20
X-Bayes-Prob: 0.0003 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333765457 - 1950a5253276
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333765457&m=1950a5253276&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333765457&m=1950a5253276&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333765457&m=1950a5253276&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Would perhaps be prettier to have the load already in place at call
> time, but methinks the enqueue/dequeue accounting logic is nice as is,
> so complete the unlikely case handling in an unlikely block.
>  
> Impact: bug fixlet.
>
> Account for tasks which have not yet been enqueued in calc_delta_weight().
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5ad4440..4685f28 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -392,8 +392,16 @@ static inline unsigned long
>  calc_delta_weight(unsigned long delta, struct sched_entity *se)
>  {
>  	for_each_sched_entity(se) {
> -		delta = calc_delta_mine(delta,
> -				se->load.weight, &cfs_rq_of(se)->load);
> +		struct load_weight *load = &cfs_rq_of(se)->load;
> +
> +		if (unlikely(!se->on_rq)) {
> +			struct load_weight tmp;
> +
> +			tmp.weight = load->weight + se->load.weight;
> +			tmp.inv_weight = 0;
> +			load = &tmp;
> +		}
> +		delta = calc_delta_mine(delta, se->load.weight, load);
>  	}
>  
>  	return delta;
>
>   

Still works OK for me. You may add, if you like:

Tested-By: Jayson King <dev@jaysonking.com>


Jayson

