Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYFZONk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYFZONk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYFZONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:13:32 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:38060 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYFZONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:13:30 -0400
Date: Thu, 26 Jun 2008 07:13:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH]rcu classic: update qlen when cpu offline
Message-ID: <20080626141324.GA10859@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4862F9B3.5030300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4862F9B3.5030300@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:06:43AM +0800, Lai Jiangshan wrote:
> 
> When callbacks are moved from offline cpu to this cpu,
> the qlen field of this rdp should be updated.

Good catch!!!

The effect of this bug would be for force_quiescent_state() to be invoked
when it should not and vice versa -- wasting cycles in the first case
and letting RCU callbacks remain piled up in the second case.  The bug
is thus "benign" in that it does not result in premature grace-period
termination, but should of course be fixed nonetheless.

Preemption is disabled by the caller's get_cpu_var(), so we are guaranteed
to remain on the same CPU, as required.  The local_irq_disable() is indeed
needed, otherwise, an interrupt might invoke call_rcu() or call_rcu_bh(),
which could cause that interrupt's increment of ->qlen to be lost.

So this patch looks correct to me.  Good job, Jiangshan!!!

Ingo, would you be willing to add this patch to tip/core/rcu?

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index f4ffbd0..42aead6 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -373,6 +373,10 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
>  	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
>  	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
>  	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
> +
> +	local_irq_disable();
> +	this_rdp->qlen += rdp->qlen;
> +	local_irq_enable();
>  }
> 
>  static void rcu_offline_cpu(int cpu)
> 
> 
