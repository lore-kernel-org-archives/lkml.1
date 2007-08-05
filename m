Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbXHEPFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbXHEPFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXHEPEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:04:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38428 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXHEPEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:04:53 -0400
Date: Sun, 5 Aug 2007 08:04:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG  RT] - rcupreempt.c:133 on 2.6.23-rc1-rt7
Message-ID: <20070805150449.GA19418@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1186289484.636.5.camel@localhost.localdomain> <1186290332.636.8.camel@localhost.localdomain> <20070805065948.GB515@elte.hu> <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 10:24:15AM -0400, Steven Rostedt wrote:
> 
> --
> 
> On Sun, 5 Aug 2007, Ingo Molnar wrote:
> 
> >
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > > I don't have time to look further now, and it's something that isn't
> > > > easily reproducible (Well, it happened once out of two boots). If
> > > > you need me to look further, or need a config or dmesg (I have
> > > > both), then just give me a holler.
> > >
> > > Silly me. FYI, I was running with !PREEMPT_RT, but with Hard and
> > > Softirqs as threads.  Must have copied the wrong config over :-/
> >
> > it's still not supposed to happen ... rcu read lock nesting that deep?
> >
> 
> The code on line 133 is:
> 
> 	WARN_ON_ONCE(current->rcu_read_lock_nesting > NR_CPUS);
> 
> I have NR_CPUS set to 2 since the box I'm running this on only has
> 2 cpus and I see no reason to waste more data structures.
> 
> Is rcu read lock nesting deeper than 2?

In networking, I would not be at all surprised, given things like fib_trie
and netfilter usage.  In addition, if rcu_read_lock() is called from
hardirq or NMI/SMI, it is necessary to add the nesting levels in these
environments as well.  In any case, rcu_read_lock() is freely nestable,
so there is no penalty for nesting pretty deeply.  I must have missed this
WARN_ON_ONCE() being added to rcu_read_lock() -- I did ack Daniel Walker's
check for negative values of rcu_read_lock_nesting in rcu_read_unlock(),
but saw no upper-limit checks.

So, are you running into a situation where rcu_read_lock_nesting is
growing unboundedly?

I would not expect the per-task nesting level to normally be a function
of the number of CPUs -- unless one was doing some sort of nested scan
of RCU-protected per-CPU data structures or some such.  So if you are
adding this to your local build as a debug check, I would suggest a fixed
limit -- but would -not- suggest putting such a check into a production
build, at least not for a small limit.

							Thanx, Paul
