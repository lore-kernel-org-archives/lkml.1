Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbXBONfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbXBONfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbXBONfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:35:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742AbXBONfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:35:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Thu, 15 Feb 2007 14:31:08 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
References: <20070214144031.GA15257@in.ibm.com> <200702150909.53145.rjw@sisk.pl> <20070215122055.GA19155@in.ibm.com>
In-Reply-To: <20070215122055.GA19155@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151431.10068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 February 2007 13:20, Gautham R Shenoy wrote:
> On Thu, Feb 15, 2007 at 09:09:51AM +0100, Rafael J. Wysocki wrote:
> > > 
> > > Why should we make sure that PF_NOFREEZE tasks are also frozen for
> > > cpu hotplug? Instead, we can create an infrastructure which allows threads to
> > > specify for the scenarios they would want to be excempted from freeze.
> > > Something like what Paul has suggested in
> > > http://lkml.org/lkml/2007/1/31/323. That way, threads which have nothing
> > > to do with the online_cpu_map or with handling of cpu-hotplug events can
> > > mark themselves to be exempted from being frozen for cpu hotplug.
> > 
> > I think all kernel threads should call try_to_freeze() in suitable places
> > anyway if we are going to use the freezer for anything more than just the
> > suspend.  In other words, they all should be _able_ to freeze if necessary.
> 
> Yeah! I agree. I misunderstood your earlier point. I thought you were 
> hinting at freezing *everyone* while doing a cpu hotplug.

So I think tonight I'll start adding try_to_freeze() to the kernel threads that
set PF_NOFREEZE.

> 
> > 
> > > Once this is achieved, it's all about classifying the threads into
> > > according to their NO_FREEZE needs :)
> > 
> > Yes, but I think it's just a generalization of ingoring PF_NOFREEZE.
> > If all kernel threads are able to freeze, we can mark them as "freeze for CPU
> > hotplug" or "freeze for kprobes", or "freeze for suspend" etc. and call the
> > freezer with the appropriate parameter.
> > 
> > BTW, what happens to a process running on a CPU being removed?
> > 
> 
> We call stop_machine_run in _cpu_down which schedules an idle thread on 
> the cpu to be removed. Once the idle thread runs, we call __cpu_die and
> subsequently the scheduler performs task migration while handling 
> the CPU_DEAD notification (see migration_call in sched.c)

Ah, thanks for the explanation.

> > > > 2) We have to change the PM code to stop using CPU hotplug for disabling
> > > > nonboot CPUs. ;-)
> > > 
> > > Just wondering, how hard is that ?
> > 
> > Hmmm.  In fact the problem is that the suspend code freezes tasks and then
> > calls disable_nonboot_cpus() which uses (_)cpu_down/up().  In principle we
> > could make disable_nonboot_cpus() call some lower-level routines to avoid the
> > freezing of tasks, _but_ the suspend code may freeze too few tasks (ie. we may
> > want to freeze more tasks for the CPU hotplug).  Thus I think we should do
> > something like this:
> > 
> > suspend:				CPU hotplug:
> > freeze_processes(SUSPEND)	...
> > ...					freeze_processes(CPU_HOTPLUG)
> > ...					...
> > ...					thaw_processes(CPU_HOTPLUG)
> > thaw_processes(SUSPEND)	...
> > 
> > so freeze_processes() should be reentrant, at least for different values of
> > the argument.
> > 
> 
> That would still mean going over the task list twice.

Yes, but I think this is inevitable anyway, because we have moved the
disabling of nonboot CPUs after the suspending of devices (for
ACPI-related reasons).

Currently, we have, roughly:

freeze_processes();
shrink_memory(); (swsusp only)
suspend_devices();
disable_nonboot_cpus();
suspend

and the reverse during the resume.

Still, the second pass will be quick, since the majority of tasks are frozen
when disable_nonboot_cpus() is called.

> How if we have 
> 
> freeze_process(SUSPEND|CPU_HOTPLUG);
> perform_pre_hotplug_suspend();
> primitive_cpu_down/_up();
> perform_post_hotplug_suspend();
> 
> Does this look like a good thing to you?
> > All in all, I think we should start from modifying the freezer and the
> > classification of processes with respect to the freezing.
> > 
> 
> Cool! Lets get started then ;-)

No problem with that. ;-)

Speaking of the classification, do you think it would be practical to use
some kind of "freezing levels"?  I mean, for each task we can define the
"freezing level" at which it should be frozen and each user of the freezer
can call it with a specific "freezing level" as a parameter.  Of course for
this purpose the tasks frozen at level 1 have to be a subset of the tasks
frozen at level 2 etc. and I'm not sure if this requirement can be satisfied.

Rafael
