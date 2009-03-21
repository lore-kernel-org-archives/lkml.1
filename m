Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZCUUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZCUUrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZCUUrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:47:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:60337 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZCUUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HquMkMlsjufVaeSIrtcPquMOMn28rHkob6EsHFnyl1yK4z3S5oZU5PBXK6rrAC+qeJ
         9SAkaubnMynsG9tk9QiD/UjLfWX9PKhzSUwCd48HAm9K785iBAVe+1GJhfeP3F7px9Nk
         N2UPLpmmOUzM37qDBf97cl/Su0kTHKNwAKwXM=
Date: Sat, 21 Mar 2009 21:46:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321204657.GF5956@nowhere>
References: <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <20090321173206.GB5956@nowhere> <20090321181858.GA21155@elte.hu> <20090321200955.GE5956@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321200955.GE5956@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 09:09:56PM +0100, Frederic Weisbecker wrote:
> On Sat, Mar 21, 2009 at 07:18:58PM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > >  [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
> > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > >  [<ffffffff8026abef>] update_process_times+0x3c/0x77
> > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > >  [<ffffffff802875dd>] tick_periodic+0x6e/0x70
> > > 
> > > 
> > > Still hanging in the timer interrupt.
> > > I guess it makes the timer interrupt servicing too slow and then
> > > once it is serviced, another one is raised.
> > > 
> > > But the cause is perhaps more complex
> > > 
> > > I think you have had too much hanging of this type. I'm preparing 
> > > a fix that checks periodically if the function graph tracer is 
> > > spending too much time in an interrupt.
> > > 
> > > I guess I could count the number of function executed between the 
> > > irq entry and its exit.
> > > 
> > > That's the best: if we are hanging in an interrupt, it could be 
> > > whatever interrupt and the jiffies could not be progressing so I 
> > > can't rely on time but only on number of functions executed.
> > > 
> > > May be 10000 calls is a good threshold before killing the function 
> > > graph inside an interrupt?
> > 
> > i think the problem isnt even the IRQ handler - but the fact that 
> > the (timer) irq handler gets re-triggered - so all we do is 
> > processing timer IRQs.
> > 
> > Your patch would detect a timer IRQ hanging - but it would not 
> > detect the 'system makes no progress because there's always anoter 
> > pending timer IRQ to execute' situation.
> 
> 
> Ah, you're right.
> 
>  
> > So i think we need a "function trace watchdog" - which kills the 
> > tracer if we do more than 100,000,000 entries since we started the 
> > self-test, or so.
> > 
> > 	Ingo
> 
> 
> The problem is that it can happen also on other contexts than selftests.
> For example with ftrace=function_graph or by simply enabling the tracer
> later.
> 
> Sometimes it can happen during the selftests, sometimes it's only
> revealed by manually enabling it. I just remind another hang that
> you reported earlier and which I half-solved by fixing a pointless
> softirq call...
> 

Well, ok let's do that, it will be a first and good stage on debugging
the graph hangs.
I will write this selftest watchdog and ftrace_dump() once we reach
100,000,000 entries.
It will be very helpful to know what really happens and what can be
optimized in this area.

Concerning this ftrace_dump(), I will tune it to let us decide if we want
to kill all tracing or not. For example, in case of a graph hang, we don't have
to bother about other tracers.

Thanks.

