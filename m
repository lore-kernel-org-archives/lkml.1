Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZBWJMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZBWJMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZBWJMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:12:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZBWJMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:12:32 -0500
Date: Mon, 23 Feb 2009 10:11:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090223091158.GJ9582@elte.hu>
References: <20090220125516.GB10232@linux.vnet.ibm.com> <20090220132145.GF26418@elte.hu> <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223075521.GA3725@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2009-02-20 22:53:18]:
> 
> > 
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > On Fri, 20 Feb 2009 17:07:37 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > I'd also suggest to not do that rather ugly 
> > > > > > enable_timer_migration per-cpu variable, but simply reuse 
> > > > > > the existing nohz.load_balancer as a target CPU.
> > > > > 
> > > > > This is a good idea to automatically bias the timers.  But 
> > > > > this nohz.load_balancer is a very fast moving target and we 
> > > > > will need some heuristics to estimate overall system idleness 
> > > > > before moving the timers.
> > > > > 
> > > > > I would agree that the power saving load balancer has a good 
> > > > > view of the system and can potentially guide the timer biasing 
> > > > > framework.
> > > > 
> > > > Yeah, it's a fast moving target, but it already concentrates 
> > > > the load somewhat.
> > > > 
> > > 
> > > I wonder if the real answer for this isn't to have timers be 
> > > considered schedulable-entities and have the regular scheduler 
> > > decide where they actually run.
> > 
> > hm, not sure - it's a bit heavy for that.
> >
> 
> I think the basic timer migration policy should exist in user 
> space.

I disagree.

> One of the ways of looking at it is, as we begin to 
> consolidate, using range timers and migrating all timers to 
> lesser number of CPUs would make a whole lot of sense.
> 
> As far as the scheduler making those decisions is concerned, 
> my concern is that the load balancing is a continuous process 
> and timers don't necessarily work that way. I'd put my neck 
> out and say that irqbalance, range timers and timer migration 
> should all belong to user space. irqbalance and range timers 
> do, so should timer migration.

As i said it my first reply, IRQ migration is special because 
they are not kernel-internal objects, they come externally so 
there's a lot of user-space enumeration, policy and other steps 
involved. Furthermore, IRQs are migrated in a 'slow' fashion.

Timers on the other hand are fast entities tied to _tasks_ 
primarily, not external entities. Hence they should migrate 
according to the CPU where the activities of the system 
concentrates - i.e. where tasks are running.

Another thing: do you argue for the existing timer-migration 
code we have in mod_timer() to move to user-space too? It isnt a 
consistent argument to push 'some' of it to user-space, and some 
of it in kernel-space.

	Ingo
