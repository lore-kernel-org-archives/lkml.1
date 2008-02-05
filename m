Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYBERDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYBERDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBERDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:03:07 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44428 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYBERDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:03:05 -0500
Date: Tue, 5 Feb 2008 08:59:36 -0800
From: Daniel Walker <dwalker@dwalker1.mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, Max Krasnyanskiy <maxk@qualcomm.com>
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
Message-ID: <20080205165936.GA18613@dwalker1.mvista.com>
References: <47A7A131.8040800@qualcomm.com> <20080205025144.GA31774@dwalker1.mvista.com> <47A7A784.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7A784.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:02:12PM -0700, Gregory Haskins wrote:
> >>> On Mon, Feb 4, 2008 at  9:51 PM, in message
> <20080205025144.GA31774@dwalker1.mvista.com>, Daniel Walker
> <dwalker@dwalker1.mvista.com> wrote: 
> > I get the following when I tried it,
> > 
> > BUG: sleeping function called from invalid context bash(5126) at
> > kernel/rtmutex.c:638
> > in_atomic():1 [00000001], irqs_disabled():1
> 
> Hi Daniel,
>   Can you try this patch and let me know if it fixes your problem?
> 
> -----------------------
> 
> use rcu for root-domain kfree
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e6ad493..77e86c1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -339,6 +339,7 @@ struct root_domain {
>         atomic_t refcount;
>         cpumask_t span;
>         cpumask_t online;
> +       struct rcu_head rcu;
> 
>         /*
>          * The "RT overload" flag: it gets set if a CPU has more than
> @@ -6222,6 +6223,12 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
>         return 1;
>  }
> 
> +/* rcu callback to free a root-domain */
> +static void rq_free_root(struct rcu_head *rcu)
> +{
> +       kfree(container_of(rcu, struct root_domain, rcu));
> +}
> +

I looked at the code a bit, and I'm not sure you need this complexity..
Once you have replace the old_rq, there is no reason it needs to
protection of the run queue spinlock .. So you could just move the kfree
down below the spin_unlock_irqrestore() ..

Daniel
