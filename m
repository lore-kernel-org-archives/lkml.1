Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZBWKgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZBWKgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZBWKg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:36:26 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42359 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZBWKg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:36:26 -0500
Date: Mon, 23 Feb 2009 16:08:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090223103814.GB8817@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090220125516.GB10232@linux.vnet.ibm.com> <20090220132145.GF26418@elte.hu> <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com> <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090223094850.GA10226@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2009-02-23 15:18:50]:

> * Ingo Molnar <mingo@elte.hu> [2009-02-23 10:11:58]:
> 
> > 
> > * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * Ingo Molnar <mingo@elte.hu> [2009-02-20 22:53:18]:
> > > 
> > > > 
> > > > * Arjan van de Ven <arjan@infradead.org> wrote:
> > > > 
> > > > > On Fri, 20 Feb 2009 17:07:37 +0100
> > > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > > > 
> > > > > > 
> > > > > > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > > > > > 
> > > > > > > > I'd also suggest to not do that rather ugly 
> > > > > > > > enable_timer_migration per-cpu variable, but simply reuse 
> > > > > > > > the existing nohz.load_balancer as a target CPU.
> > > > > > > 
> > > > > > > This is a good idea to automatically bias the timers.  But 
> > > > > > > this nohz.load_balancer is a very fast moving target and we 
> > > > > > > will need some heuristics to estimate overall system idleness 
> > > > > > > before moving the timers.
> > > > > > > 
> > > > > > > I would agree that the power saving load balancer has a good 
> > > > > > > view of the system and can potentially guide the timer biasing 
> > > > > > > framework.
> > > > > > 
> > > > > > Yeah, it's a fast moving target, but it already concentrates 
> > > > > > the load somewhat.
> > > > > > 
> > > > > 
> > > > > I wonder if the real answer for this isn't to have timers be 
> > > > > considered schedulable-entities and have the regular scheduler 
> > > > > decide where they actually run.
> > > > 
> > > > hm, not sure - it's a bit heavy for that.
> > > >
> > > 
> > > I think the basic timer migration policy should exist in user 
> > > space.
> > 
> > I disagree.
> >
> 
> See below
> 
> > > One of the ways of looking at it is, as we begin to 
> > > consolidate, using range timers and migrating all timers to 
> > > lesser number of CPUs would make a whole lot of sense.
> > > 
> > > As far as the scheduler making those decisions is concerned, 
> > > my concern is that the load balancing is a continuous process 
> > > and timers don't necessarily work that way. I'd put my neck 
> > > out and say that irqbalance, range timers and timer migration 
> > > should all belong to user space. irqbalance and range timers 
> > > do, so should timer migration.
> > 
> > As i said it my first reply, IRQ migration is special because 
> > they are not kernel-internal objects, they come externally so 
> > there's a lot of user-space enumeration, policy and other steps 
> > involved. Furthermore, IRQs are migrated in a 'slow' fashion.
> > 
> > Timers on the other hand are fast entities tied to _tasks_ 
> > primarily, not external entities. 
> 
> Timers are also queued due to external events like interrupts (device
> drivers tend to set of timers all the time). I am not fully against
> what you've said, at some semantic level what you are suggesting is
> that at a higher level of power saving, when the scheduler balances
> timers it is doing a form of soft CPU hotplug on the system by
> migrating timers and tasks away from idle CPUs when the load can be
> handled by other CPUs. See below as well.
> 
> > Hence they should migrate 
> > according to the CPU where the activities of the system 
> > concentrates - i.e. where tasks are running.
> > 
> > Another thing: do you argue for the existing timer-migration 
> > code we have in mod_timer() to move to user-space too? It isnt a 
> > consistent argument to push 'some' of it to user-space, and some 
> > of it in kernel-space.
> > 
> 
> No.. mod_timer() is correct where it belongs.
> 
> Consider the powertop usage scenario today
> 
> 1. Powertop displays a list of timers and common causes of wakeup
> 2. It recommends policies in user space that can affect power savings
>    a. usb autosuspend
>    b. wireless link management
>    c. disable HAL polling
> 
> My argument is, why can't we add
> 
>    d. Use range timers
>    e. Consolidate timers
> 
> In the future.
> 
> Even sched_mc=n is set by user space, so really the
> policy is in user space.

Hi Balbir, 

I would agree that the policy would exist in user space.  But what
Ingo is suggesting is that the decision of actually choosing the
destination cpu to consolidate should come from existing scheduler's
power save balancer code.

My understanding is that we will certainly have a sysfs tunable to
'enable' timer migration or consolidation, similar to the sched_mc=2
policy, but the actual set of CPUs to evacuate and the correct set of
target CPUs to consolidate should come from the scheduler and not
necessarily from the user space.

The scheduler should be able to figure out the following parameters:

* Identify set of idle CPUs (CPU package) from which timers can be
  removed
* Identify a semi-idle or idle CPU package to which the timers can be
  moved
* Decide when to start moving timers as the system has large number of
  idle CPUs
* Decide when to stop migrating as system becomes less idle and
  utilisation increases

Guiding all of the above decisions from user space may not be fast
enough.

--Vaidy
