Return-Path: <linux-kernel-owner+w=401wt.eu-S965141AbXBOIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbXBOIOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXBOIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:14:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965141AbXBOIOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:14:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Thu, 15 Feb 2007 09:09:51 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
References: <20070214144031.GA15257@in.ibm.com> <200702142243.37189.rjw@sisk.pl> <20070215063413.GA11950@in.ibm.com>
In-Reply-To: <20070215063413.GA11950@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702150909.53145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 February 2007 07:34, Gautham R Shenoy wrote:
> On Wed, Feb 14, 2007 at 10:43:35PM +0100, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Wednesday, 14 February 2007 15:40, Gautham R Shenoy wrote:
> > > Hello Everybody,
> > > 
> > > This is an experiment towards process_freezer based implementation
> > > of cpu-hotplug. This is mainly based on ideas of Andrew Morton, 
> > > Ingo Molnar and Paul Mckenney featured in the discussion
> > > http://lkml.org/lkml/2007/1/31/323.
> > > 
> > > This is an absolute bare-minimal implementation to check the feasibility
> > > of using process freezer for cpu-hotplug. 
> > > 
> > > The patchset comprises of four patches.
> > > o PATCH 1/4: Core implementation of freezer-based-hotplug.
> > > o PATCH 2/4: Revert changes to workqueue to make it work with the
> > >              freezer-cpu-hotplug.
> > > o PATCH 3/4: Eliminate hotcpu subsystem mutexes from sched and slab.
> > > o PATCH 4/4: Eliminate lock_cpu_hotplug from the kernel.
> > 
> > I think two things are missing:
> > 
> > 1) We should make sure there are not PF_NOFREEZE tasks running when a CPU
> > is removed (when one is added probably too).  For this purpose we can add a
> > parameter to freeze_processes() that will tell it to ignore PF_NOFREEZE, but
> > at the same time we'll have to change all kernel threads that set PF_NOFREEZE
> > to call try_to_freeze() anyway.  I can do that, but it will take me a couple of
> > days.
> 
> Why should we make sure that PF_NOFREEZE tasks are also frozen for
> cpu hotplug? Instead, we can create an infrastructure which allows threads to
> specify for the scenarios they would want to be excempted from freeze.
> Something like what Paul has suggested in
> http://lkml.org/lkml/2007/1/31/323. That way, threads which have nothing
> to do with the online_cpu_map or with handling of cpu-hotplug events can
> mark themselves to be exempted from being frozen for cpu hotplug.

I think all kernel threads should call try_to_freeze() in suitable places
anyway if we are going to use the freezer for anything more than just the
suspend.  In other words, they all should be _able_ to freeze if necessary.

> Once this is achieved, it's all about classifying the threads into
> according to their NO_FREEZE needs :)

Yes, but I think it's just a generalization of ingoring PF_NOFREEZE.
If all kernel threads are able to freeze, we can mark them as "freeze for CPU
hotplug" or "freeze for kprobes", or "freeze for suspend" etc. and call the
freezer with the appropriate parameter.

BTW, what happens to a process running on a CPU being removed?
 
> > 2) We have to change the PM code to stop using CPU hotplug for disabling
> > nonboot CPUs. ;-)
> 
> Just wondering, how hard is that ?

Hmmm.  In fact the problem is that the suspend code freezes tasks and then
calls disable_nonboot_cpus() which uses (_)cpu_down/up().  In principle we
could make disable_nonboot_cpus() call some lower-level routines to avoid the
freezing of tasks, _but_ the suspend code may freeze too few tasks (ie. we may
want to freeze more tasks for the CPU hotplug).  Thus I think we should do
something like this:

suspend:				CPU hotplug:
freeze_processes(SUSPEND)	...
...					freeze_processes(CPU_HOTPLUG)
...					...
...					thaw_processes(CPU_HOTPLUG)
thaw_processes(SUSPEND)	...

so freeze_processes() should be reentrant, at least for different values of
the argument.

All in all, I think we should start from modifying the freezer and the
classification of processes with respect to the freezing.

Greetings,
Rafael
