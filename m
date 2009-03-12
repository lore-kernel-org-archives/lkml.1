Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZCLO1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZCLO1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZCLO0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:26:53 -0400
Received: from www.tglx.de ([62.245.132.106]:33671 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZCLO0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:26:52 -0400
Date: Thu, 12 Mar 2009 15:25:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com, hpa@zytor.com,
       dvhltc@us.ibm.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt
 tasks too
In-Reply-To: <1236866529.22914.3694.camel@twins>
Message-ID: <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain>
References: <20090312075559.9856.28822.stgit@Aeon>  <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>  <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Peter Zijlstra wrote:

> On Thu, 2009-03-12 at 06:53 -0700, Arjan van de Ven wrote:
> > Darren Hart wrote:
> > > Commit-ID:  16f4993f4e9860715918efd4eeac928f8de1218b
> > > Gitweb:     http://git.kernel.org/tip/16f4993f4e9860715918efd4eeac928f8de1218b
> > > Author:     "Darren Hart" <dvhltc@us.ibm.com>
> > > AuthorDate: Thu, 12 Mar 2009 00:55:59 -0700
> > > Commit:     Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Thu, 12 Mar 2009 11:20:57 +0100
> > > 
> > > futex: use current->time_slack_ns for rt tasks too
> > > 
> > > RT tasks should set their timer slack to 0 on their own.  This
> > > patch removes the 'if (rt_task()) slack = 0;' block in
> > > futex_wait.
> > 
> > Hi,
> > 
> > can you explain the rationale for this reasoning?
> 
> Yeah, I found it iffy as well, I think we want something like the below
> instead though..

Yup, that's what I meant when I hollered about the timer_slack_ns
hackery in futex.c

Thanks,

	tglx

> ---
> 
> Subject: sched: adjust timer_slack_ns on scheduler policy change
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Mar 12 15:01:02 CET 2009
> 
> Ensure RT tasks have 0 timer slack.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -5511,10 +5511,12 @@ __setscheduler(struct rq *rq, struct tas
>  	case SCHED_NORMAL:
>  	case SCHED_BATCH:
>  	case SCHED_IDLE:
> +		p->timer_slack_ns = p->default_timer_slack_ns;
>  		p->sched_class = &fair_sched_class;
>  		break;
>  	case SCHED_FIFO:
>  	case SCHED_RR:
> +		p->timer_slack_ns = 0;
>  		p->sched_class = &rt_sched_class;
>  		break;
>  	}
> 
