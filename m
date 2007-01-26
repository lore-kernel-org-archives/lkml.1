Return-Path: <linux-kernel-owner+w=401wt.eu-S1161247AbXAZTvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161247AbXAZTvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161244AbXAZTvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:51:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161246AbXAZTvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:51:06 -0500
Date: Fri, 26 Jan 2007 11:28:37 -0800
From: Andrew Morton <akpm@osdl.org>
To: dipankar@in.ibm.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-Id: <20070126112837.059502fc.akpm@osdl.org>
In-Reply-To: <20070126191113.GA14770@in.ibm.com>
References: <20070124011519.GG1613@linux.vnet.ibm.com>
	<20070124090111.GC27221@in.ibm.com>
	<20070124161559.GA1762@linux.vnet.ibm.com>
	<20070124210645.GA19650@in.ibm.com>
	<20070126191113.GA14770@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 00:41:13 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> On Thu, Jan 25, 2007 at 02:36:45AM +0530, Dipankar Sarma wrote:
> > On Wed, Jan 24, 2007 at 08:15:59AM -0800, Paul E. McKenney wrote:
> > 
> > It should be relatively easy. Setting the offlined cpu's flags
> > to neutral state should do the trick in most cases.
> > I will send out the patches tomorrow after reviewing the code
> > some more.
> 
> Famous last words. 
> 
> It turns out that I have been bitten by the ugly cpu hotplug
> locking mess while trying to get preemptible RCU code working
> with CPU hotplug. The per-subsystem locking thing isn't really
> user-friendly. Here is the dependency -
> 
> In cpu hotplug path (after CPU_LOCK_ACQUIRE) -
> 
> CPU_DOWN_PREPARE:sched domains -> detach_destroy_domains() ->
> 			synchronize_sched() -> sched_setaffinity()
> 
> sched_setaffinity() tries to acquire the scheduler cpu hotplug
> mutex and deadlocks.
> 
> I see no easy way of getting around this - doing "cpu hotplug locked"
> version of all those APIs would add lots of code which is bad.
> We could try Gautham's idea of letting  each subsystem maintain
> its own online cpu mask, but I bet implementing sched_setaffinity()
> would not be very easy despite this.

Suggest you just ignore cpu hotplug locking, if that helps.

> What is the status on this now ?

Stalled, apparently.

> Is this a good example to
> show why per-subsystem locks might be unmaintainable ?

Maybe.  It might also be a good example of confused design.

> Can we go back

"back" assumes it was once present.  It wasn't.

> to a simple

"simple" hasn't been demonstrated.  New lock types and their use are never
simple, especially magic ones.

> scalable refcount model
> for CPU hotplug now ?

The plan is, I hope, to rip it all out and do freeze_processes() on the
hotplug side, so nobody else needs to worry about cpu hotplug any more. 
But at present everyone seems to be in hiding.
