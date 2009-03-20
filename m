Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZCTTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZCTTyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZCTTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:54:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbZCTTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:54:41 -0400
Date: Fri, 20 Mar 2009 20:54:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320195414.GA24129@elte.hu>
References: <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320194617.GA5934@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Mar 20, 2009 at 08:27:21PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Fri, Mar 20, 2009 at 07:38:49PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > > > This looks like it is RCU/stop_machine related. The CPU is 
> > > > > > > stuck in in stop_machine? I see that rcu_torture is running. 
> > > > > > > Does this go away if you turn off rcu_torture?
> > > > > > 
> > > > > > Grasping at straws...  Does Lai's rcu_barrier() fix help?
> > > > > 
> > > > > which one is that?
> > > > 
> > > > ok, found it. Will know in about ~24 hours whether it helps.
> > > 
> > > http://lkml.org/lkml/2009/3/20/71 was the one I was thinking of, 
> > > just to double-check.
> > 
> > Yeah - i just picked it up into tip:core/rcu.
> > 
> > I didnt immediately connect the two things, as 'tracer self-test' 
> > does not lend itself to 'CPU hotplug and RCU race fix' - but indeed 
> > in the case of the function tracer there's a dependency due to 
> > stop_machine_run(). Thanks for point it out!
> > 
> > 	Ingo
> 
> 
> I've successfully triggered a crash, the problem is that I can't be sure this is
> the same because I don't have a serial line on my x86-64, and the trace goes too far.
> Moreover boot_delay=N make it disappear.
> 
> I can trigger it each time I boot with ftrace=function_graph and
> the following patch applied:
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 7c4142a..e9914a8 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -616,7 +616,7 @@ rcu_torture_writer(void *arg)
>  	static DEFINE_RCU_RANDOM(rand);
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, -1);
>  
>  	do {
>  		schedule_timeout_uninterruptible(1);
> @@ -736,7 +736,7 @@ rcu_torture_reader(void *arg)
>  	struct timer_list t;
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, -1);
>  	if (irqreader && cur_ops->irqcapable)
>  		setup_timer_on_stack(&t, rcu_torture_timer, 0);

i dont have a reproducer right now. Can you trigger it with latest 
-tip, which has this commit included:

04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o

?

	Ingo
