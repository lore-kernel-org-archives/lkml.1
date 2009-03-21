Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZCUTIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZCUTIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZCUTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:07:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43053 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZCUTHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:07:50 -0400
Date: Sat, 21 Mar 2009 12:07:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321190746.GC7148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 01:25:23PM -0400, Steven Rostedt wrote:
> 
> 
> On Sat, 21 Mar 2009, Ingo Molnar wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > 
> > > > On Fri, 20 Mar 2009, Frederic Weisbecker wrote:
> > > > > > >  
> > > > > > >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > > > > > > -	set_user_nice(current, 19);
> > > > > > > +	set_user_nice(current, -1);
> > > > > > >  	if (irqreader && cur_ops->irqcapable)
> > > > > > >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> > > > > > 
> > > > > > i dont have a reproducer right now. Can you trigger it with latest 
> > > > > > -tip, which has this commit included:
> > > > > > 
> > > > > > 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> > > > > > 
> > > > > > ?
> > > > > > 
> > > > > > 	Ingo
> > > > > 
> > > > > 
> > > > > I tested three times the same things but with 04cb9ac and... it didn't triggered
> > > > > anymore :-)
> > > > 
> > > > So lets hope that was the culprit.
> > > > 
> > > > Great work Frederic!
> > > 
> > > No new lockups of this nature in overnight -tip testing. It's 
> > > still a bit too early to tell for sure but it's promising ;-)
> > 
> > just got a lockup again :-/ It hangs here:
> > 
> > calling  init_mmio_trace+0x0/0x12 @ 1
> > initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
> > calling  init_graph_trace+0x0/0x12 @ 1
> > Testing tracer function_graph: 
> > 
> > and this time i got good stackdumps as well - see below. Config 
> > attached.
> 
> > CONFIG_CLASSIC_RCU=y
> 
> All the crashes you reported only happen with classic RCU.
> 
> Paul,
> 
> Did anything change recently that could cause this lockup?

Arjan van de Ven is seeing a problem where a single synchronize_rcu()
during bootup is taking a full second, which is currently
thought to be due to some drivers spinning in the kernel (Arjan
is working on a bootgraph that will hopefully pinpoint the problem:
http://lkml.org/lkml/2009/3/21/7).  If the drivers were also instrumented
with ftrace, they might (or might not)slow down even further, depending
on exactly why they are spinning.

							Thanx, Paul
