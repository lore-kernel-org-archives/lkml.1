Return-Path: <linux-kernel-owner+w=401wt.eu-S965910AbXBOMWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965910AbXBOMWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965919AbXBOMWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:22:11 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33977 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965910AbXBOMWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:22:10 -0500
Date: Thu, 15 Feb 2007 17:50:55 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070215122055.GA19155@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702142243.37189.rjw@sisk.pl> <20070215063413.GA11950@in.ibm.com> <200702150909.53145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702150909.53145.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 09:09:51AM +0100, Rafael J. Wysocki wrote:
> > 
> > Why should we make sure that PF_NOFREEZE tasks are also frozen for
> > cpu hotplug? Instead, we can create an infrastructure which allows threads to
> > specify for the scenarios they would want to be excempted from freeze.
> > Something like what Paul has suggested in
> > http://lkml.org/lkml/2007/1/31/323. That way, threads which have nothing
> > to do with the online_cpu_map or with handling of cpu-hotplug events can
> > mark themselves to be exempted from being frozen for cpu hotplug.
> 
> I think all kernel threads should call try_to_freeze() in suitable places
> anyway if we are going to use the freezer for anything more than just the
> suspend.  In other words, they all should be _able_ to freeze if necessary.

Yeah! I agree. I misunderstood your earlier point. I thought you were 
hinting at freezing *everyone* while doing a cpu hotplug.

> 
> > Once this is achieved, it's all about classifying the threads into
> > according to their NO_FREEZE needs :)
> 
> Yes, but I think it's just a generalization of ingoring PF_NOFREEZE.
> If all kernel threads are able to freeze, we can mark them as "freeze for CPU
> hotplug" or "freeze for kprobes", or "freeze for suspend" etc. and call the
> freezer with the appropriate parameter.
> 
> BTW, what happens to a process running on a CPU being removed?
> 

We call stop_machine_run in _cpu_down which schedules an idle thread on 
the cpu to be removed. Once the idle thread runs, we call __cpu_die and
subsequently the scheduler performs task migration while handling 
the CPU_DEAD notification (see migration_call in sched.c)

> > > 2) We have to change the PM code to stop using CPU hotplug for disabling
> > > nonboot CPUs. ;-)
> > 
> > Just wondering, how hard is that ?
> 
> Hmmm.  In fact the problem is that the suspend code freezes tasks and then
> calls disable_nonboot_cpus() which uses (_)cpu_down/up().  In principle we
> could make disable_nonboot_cpus() call some lower-level routines to avoid the
> freezing of tasks, _but_ the suspend code may freeze too few tasks (ie. we may
> want to freeze more tasks for the CPU hotplug).  Thus I think we should do
> something like this:
> 
> suspend:				CPU hotplug:
> freeze_processes(SUSPEND)	...
> ...					freeze_processes(CPU_HOTPLUG)
> ...					...
> ...					thaw_processes(CPU_HOTPLUG)
> thaw_processes(SUSPEND)	...
> 
> so freeze_processes() should be reentrant, at least for different values of
> the argument.
> 

That would still mean going over the task list twice. How if we have

freeze_process(SUSPEND|CPU_HOTPLUG);
perform_pre_hotplug_suspend();
primitive_cpu_down/_up();
perform_post_hotplug_suspend();

Does this look like a good thing to you?
> All in all, I think we should start from modifying the freezer and the
> classification of processes with respect to the freezing.
> 

Cool! Lets get started then ;-)

> Greetings,
> Rafael

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
