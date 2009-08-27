Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZH0M0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZH0M0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZH0M0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:26:45 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52583 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZH0M0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:26:44 -0400
Message-ID: <4A9679EC.1030108@gmail.com>
Date: Thu, 27 Aug 2009 14:19:56 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jes@sgi.com, jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] sched: Avoid division by zero - really
References: <1250855934.7538.30.camel@twins>	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>	 <1251227486.7538.1174.camel@twins>  <4A94FD58.8060207@kernel.org> <1251371336.18584.77.camel@twins>
In-Reply-To: <1251371336.18584.77.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 27 Aug 2009 14:19:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> When re-computing the shares for each task group's cpu representation we
> need the ratio of weight on each cpu vs the total weight of the sched
> domain.
> 
> Since load-balancing is loosely (read not) synchronized, the weight of
> individual cpus can change between doing the sum and calculating the
> ratio.
> 
> The previous patch dealt with only one of the race scenarios, this patch
> side steps them all by saving a snapshot of all the individual cpu
> weights, thereby always working on a consistent set.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   50 +++++++++++++++++++++++++++++---------------------
>  1 files changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0e76b17..4591054 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1515,30 +1515,29 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  
> +struct update_shares_data {
> +	unsigned long rq_weight[NR_CPUS];
> +};
> +
> +static DEFINE_PER_CPU(struct update_shares_data, update_shares_data);

ouch... thats quite large IMHO, up to 4096*8 = 32768 bytes per cpu...

Now we have nice dynamic per cpu allocations, we could use it here,
and use nr_cpus instead of NR_CPUS as the array size ?

