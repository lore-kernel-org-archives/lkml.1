Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYBRIhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYBRIhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYBRIhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:37:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:35652 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755138AbYBRIhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:37:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zhLw/EdezdIRdISWi9QcZVAjEO+A/3WwQ4jNZmH
	CRTsX6kJM3f/Ik
Subject: Re: 2.6.24-git4+ regression
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, aneesh.kumar@in.ibm.com
In-Reply-To: <20080218082021.GD14419@linux.vnet.ibm.com>
References: <20080130135609.GA5100@ics.muni.cz>
	 <20080214165551.GA21963@linux.vnet.ibm.com>
	 <20080217202642.GA4327@ics.muni.cz> <20080218042831.GJ30201@elte.hu>
	 <1203320304.26269.3.camel@homer.simson.net>
	 <20080218082021.GD14419@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 09:36:55 +0100
Message-Id: <1203323815.5443.4.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 13:50 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Feb 18, 2008 at 08:38:24AM +0100, Mike Galbraith wrote:
> > Here, it does not.  It seems fine without CONFIG_FAIR_GROUP_SCHED.
> 
> My hunch is its because of the vruntime driven preemption which shoots
> up latencies (and the fact perhaps that Peter hasnt't focused more on SMP case
> yet!).
> 
> Curiously, do you observe the same results when in UP mode (maxcpus=1)?

No, I only see bad latency with SMP.

> FWIW, my test patch I had sent earlier didnt address the needs of UP, as Peter 
> pointed me out. In that direction, I had done more experimentation with the 
> patch below, which seemed to improve UP latencies also. Note that I
> don't particularly like the first hunk below, perhaps it needs to be
> surrounded by an if(something) ..

I'll try this patch later (errands).

	Thanks,

	-Mike

> 
> ---
>  kernel/sched_fair.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: current/kernel/sched_fair.c
> ===================================================================
> --- current.orig/kernel/sched_fair.c
> +++ current/kernel/sched_fair.c
> @@ -523,8 +523,6 @@ place_entity(struct cfs_rq *cfs_rq, stru
>  		if (sched_feat(NEW_FAIR_SLEEPERS))
>  			vruntime -= sysctl_sched_latency;
>  
> -		/* ensure we never gain time by being placed backwards. */
> -		vruntime = max_vruntime(se->vruntime, vruntime);
>  	}
>  
>  	se->vruntime = vruntime;
> @@ -816,6 +814,13 @@ hrtick_start_fair(struct rq *rq, struct 
>  }
>  #endif
>  
> +static inline void dequeue_stack(struct sched_entity *se)
> +{
> +	for_each_sched_entity(se)
> +		if (se->on_rq)
> +			dequeue_entity(cfs_rq_of(se), se, 0);
> +}
> +
>  /*
>   * The enqueue_task method is called before nr_running is
>   * increased. Here we update the fair scheduling stats and
> @@ -828,6 +833,9 @@ static void enqueue_task_fair(struct rq 
>  			    *topse = NULL;	/* Highest schedulable entity */
>  	int incload = 1;
>  
> +	if (wakeup)
> +		dequeue_stack(se);
> +
>  	for_each_sched_entity(se) {
>  		topse = se;
>  		if (se->on_rq) {
> 
> 
> 
> P.S : Sorry about slow responses, since I am now in a different project :(
> 

