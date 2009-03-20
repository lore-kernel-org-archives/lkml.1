Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZCTUtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZCTUtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZCTUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:48:54 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:33433 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZCTUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RXHwIQJmzL0Lkos2M5b6pvYcQY0Qfwi5QMMY8Koh2KtHNp1JDVSI1/HcabB7cCP+dZ
         30x9xtN7g3CFXOxzYSzdwZoNdrvBlo+sXzAh09fSXmPlhVH3Ob1UWR+d469W1LQSMbFp
         OKPzShbRh18JKDAEPW5EVUbts7x+ModlCDdHw=
Date: Fri, 20 Mar 2009 21:48:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320204848.GA6044@nowhere>
References: <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320195414.GA24129@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 08:54:14PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Mar 20, 2009 at 08:27:21PM +0100, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Fri, Mar 20, 2009 at 07:38:49PM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > > 
> > > > > > > > This looks like it is RCU/stop_machine related. The CPU is 
> > > > > > > > stuck in in stop_machine? I see that rcu_torture is running. 
> > > > > > > > Does this go away if you turn off rcu_torture?
> > > > > > > 
> > > > > > > Grasping at straws...  Does Lai's rcu_barrier() fix help?
> > > > > > 
> > > > > > which one is that?
> > > > > 
> > > > > ok, found it. Will know in about ~24 hours whether it helps.
> > > > 
> > > > http://lkml.org/lkml/2009/3/20/71 was the one I was thinking of, 
> > > > just to double-check.
> > > 
> > > Yeah - i just picked it up into tip:core/rcu.
> > > 
> > > I didnt immediately connect the two things, as 'tracer self-test' 
> > > does not lend itself to 'CPU hotplug and RCU race fix' - but indeed 
> > > in the case of the function tracer there's a dependency due to 
> > > stop_machine_run(). Thanks for point it out!
> > > 
> > > 	Ingo
> > 
> > 
> > I've successfully triggered a crash, the problem is that I can't be sure this is
> > the same because I don't have a serial line on my x86-64, and the trace goes too far.
> > Moreover boot_delay=N make it disappear.
> > 
> > I can trigger it each time I boot with ftrace=function_graph and
> > the following patch applied:
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 7c4142a..e9914a8 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -616,7 +616,7 @@ rcu_torture_writer(void *arg)
> >  	static DEFINE_RCU_RANDOM(rand);
> >  
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, -1);
> >  
> >  	do {
> >  		schedule_timeout_uninterruptible(1);
> > @@ -736,7 +736,7 @@ rcu_torture_reader(void *arg)
> >  	struct timer_list t;
> >  
> >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, -1);
> >  	if (irqreader && cur_ops->irqcapable)
> >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> 
> i dont have a reproducer right now. Can you trigger it with latest 
> -tip, which has this commit included:
> 
> 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> 
> ?
> 
> 	Ingo


I tested three times the same things but with 04cb9ac and... it didn't triggered
anymore :-)

