Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYGYWcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYGYWcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYGYWc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:32:28 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59972 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYGYWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:32:27 -0400
Date: Fri, 25 Jul 2008 18:31:59 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, rfc: 1/2] sched, hotplug: safe use of
	rq->migration_thread and find_busiest_queue()
Message-ID: <20080725223159.GA16433@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1216937517.5368.11.camel@earth> <1216985986.7257.375.camel@twins> <b647ffbd0807250452k5b07b7eai40b5ca9d1bec930@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807250452k5b07b7eai40b5ca9d1bec930@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 01:52:17PM +0200, Dmitry Adamushko wrote:
> 2008/7/25 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Fri, 2008-07-25 at 00:11 +0200, Dmitry Adamushko wrote:
> >> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> >> Subject: sched, hotplug: safe use of rq->migration_thread
> >> and find_busiest_queue()
> >>
> >> ---
> >>
> >>     sched, hotplug: safe use of rq->migration_thread and find_busiest_queue()
> >>
> >>     (1) make usre rq->migration_thread is valid when we access it in set_cpus_allowed_ptr()
> >>     after releasing the rq-lock;
> >>
> >>     (2) in load_balance() and load_balance_idle()
> >>
> >>     ensure that we don't get 'busiest' which can disappear as a result of cpu_down()
> >>     while we are manipulating it. For this goal, we choose 'busiest' only amongst
> >>     'cpu_active_map' cpus.
> >>
> >>     load_balance() and load_balance_idle() get called with preemption being disabled
> >>     so synchronize_sched() in cpu_down() should get us synced.
> >>
> >>     IOW, as soon as synchronize_sched() has been done in cpu_down(cpu), the run-queue for
> >>     can't be manipulated/accessed by the load-balancer.
> >>
> >>     Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> >
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks.
> 
> >
> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> index 6acf749..b4ccc8b 100644
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -3409,7 +3409,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
> >>       struct rq *busiest;
> >>       unsigned long flags;
> >>
> >> -     cpus_setall(*cpus);
> >> +     /*
> >> +      * Ensure that we don't get 'busiest' which can disappear
> >> +      * as a result of cpu_down() while we are manipulating it.
> >> +      *
> >> +      * load_balance() gets called with preemption being disabled
> >> +      * so synchronize_sched() in cpu_down() should get us synced.
> >> +      */
> >> +     *cpus = cpu_active_map;
> >
> > This is going to be painful on -rt... there it can be preempted. I guess
> > we can put get_online_cpus() around it or something..
> 
> I've considered using get_online_cpus() for a moment but dropped this
> idea exactly because I thought it would harm us latency-wise.

get_online_cpus() can be made to be extremely lightweight (as simple as
updating a per_cpu variable). But yes, if a cpu-hotplug operation is in
progress one might block there.. So probably we need the try_ variant
here..


> cpu_down() and cpu_up() may take quite a long time to complete and
> load_balance() && load_balance_idle() would need to wait all this
> time. And they both are kind of generic (primary) scheduler
> operations.



> 
> but yea, my scheme relies on the fact that load_balance() &&
> load_balance_idle() are atomic one way or another wrt. cpu_clear() +
> synchronize_sched() in cpu_down().
> 
> [ speculating here ] I'd rather add an additional mechanism which
> would be light-weight for load_balance() and add
> synch_this_mechanism() (alike to synchonise_sched()) in cpu_down() as
> perhaps we don't care that much on how fast the later one is.
> 
> 
> -- 
> Best regards,
> Dmitry Adamushko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
