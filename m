Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZGPJMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZGPJMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZGPJMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:12:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:37426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZGPJMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:12:05 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <1247734722.15471.83.camel@twins>
References: <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
	 <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
	 <20090715231646.GI14993@cs.fsu.edu>  <1247734722.15471.83.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 11:11:01 +0200
Message-Id: <1247735461.15471.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 10:58 +0200, Peter Zijlstra wrote:
> On Wed, 2009-07-15 at 19:16 -0400, Ted Baker wrote:
> > > > 1) The priority of a group seemed to be defined by the priority of
> > > > the highest-priority thread in the group's run-queue, which means
> > > > it varies dynamically according to which threads in the group are
> > > > contending.
> > > >
> > > 
> > > This is true, but it also ensures that the time allocated to the group
> > > is also consumed by group if it wants to.
> > 
> > I don't see how schedulability analysis can be done with this model,
> > since a single budget is being expended at varying priorities/deadlines.
> > 
> > > > 4) On an SMP, more than one thread could be running against
> > > > the same budget at the same time, resulting in budget over-charges.
> > > >
> > > 
> > > The rt group scheduler does split the budget per cpu. On expiring the
> > > budget, it tries to borrow from other CPUs if possible.
> > 
> > First, how is the splitting of the budget between CPU's controlled
> > by the application?
> > 
> > Second, I don't see how schedulabiliyt analysis could be done if
> > CPU's can "borrow" budget from other CPUs, unless there is some
> > mechanism in place to "pay it back".  How do you do the analysis?
> 
> Right so control-groups (cgroups for short) are a form of
> virtualization. Each controller is specific to a resource. We have
> memory controllers, namespace controllers and also a scheduler
> controller.
> 
> If you would apply all controllers to the same task groups you get a
> result like chroot on steroids, or jails etc. But you can also use them
> individually to control resources in creative ways.

To add to this, it is by no means a way of introducing deadline
scheduling to tasks, for that you're quite right in that we should
extend sched_setscheduler() and struct sched_param.

Somewhere before RTLWS we'll add:
 
 struct sched_param2;

 sys_sched_setscheduler2(pid_t pid, int policy, struct sched_param2 *param);
 sys_sched_setparam2(pid_t pid, struct sched_param2 *param);
 sys_sched_getparam2(pid_t pid, struct sched_param2 *param);

 SCHED_SOFT_DEADLINE (bounded tardiness)
 SCHED_DEADLINE      (no tardiness)

and hopefully enough hooks to make people happy :-)

The intention is to add these to -rt only for now, so that we can still
poke at the interfaces and only move then to mainline once the dust
settles down.
