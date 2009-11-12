Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbZKLBNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbZKLBNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbZKLBNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:13:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54430 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556AbZKLBNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:13:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 12 Nov 2009 10:12:35 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] cpu controller can't provide fair CPU time for each group
Cc: Miao Xie <miaox@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1257934048.23203.76.camel@twins>
References: <20091111134910.5F42.E1E9C6FF@jp.fujitsu.com> <1257934048.23203.76.camel@twins>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20091112095947.7229.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-11-11 at 15:21 +0900, Yasunori Goto wrote:
> > > Someone needs to fix that if they really care.
> > 
> > To be honest, I don't have any good idea because I'm not familiar with
> > schduler's code. 
> 
> You could possible try something like the below, its rather gross but
> might maybe work,.. has other issues though.

Thank you very much for your patch. I'm very glad.

Unfortunately, my test staff and I don't have test box today,
I'll report the result later.

Thanks again for your time.

> 
> 
> ---
>  kernel/sched.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 91642c1..65629a3 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1614,7 +1614,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
>   */
>  static int tg_shares_up(struct task_group *tg, void *data)
>  {
> -	unsigned long weight, rq_weight = 0, shares = 0;
> +	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
>  	unsigned long *usd_rq_weight;
>  	struct sched_domain *sd = data;
>  	unsigned long flags;
> @@ -1630,6 +1630,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
>  		weight = tg->cfs_rq[i]->load.weight;
>  		usd_rq_weight[i] = weight;
>  
> +		rq_weight += weight;
>  		/*
>  		 * If there are currently no tasks on the cpu pretend there
>  		 * is one of average load so that when a new task gets to
> @@ -1638,10 +1639,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
>  		if (!weight)
>  			weight = NICE_0_LOAD;
>  
> -		rq_weight += weight;
> +		sum_weight += weight;
> +
>  		shares += tg->cfs_rq[i]->shares;
>  	}
>  
> +	if (!rq_weight)
> +		rq_weight = sum_weight;
> +
>  	if ((!shares && rq_weight) || shares > tg->shares)
>  		shares = tg->shares;
>  
> 

-- 
Yasunori Goto 


