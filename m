Return-Path: <linux-kernel-owner+w=401wt.eu-S933729AbXJRJAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbXJRJAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXJRJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:00:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35077 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578AbXJRJAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:00:03 -0400
Date: Thu, 18 Oct 2007 14:29:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071018085959.GC15281@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain> <20071018075702.GB15281@in.ibm.com> <20071018082221.GE6773@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018082221.GE6773@localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 03:22:21AM -0500, Nathan Lynch wrote:
> Gautham R Shenoy wrote:
> > Hi Nathan, 
> > > Hi Gautham-
> > > 
> > > Gautham R Shenoy wrote:
> > > > Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> > > > get_online_cpus and put_online_cpus instead as it highlights
> > > > the refcount semantics in these operations.
> > > 
> > > Something other than "get_online_cpus", please?  lock_cpu_hotplug()
> > > protects cpu_present_map as well as cpu_online_map.  For example, some
> > > of the powerpc code modified in this patch is made a bit less clear
> > > because it is manipulating cpu_present_map, not cpu_online_map.
> > 
> > A quick look at the code, and I am wondering why is lock_cpu_hotplug()
> > used there in the first place. It doesn't look like we require any 
> > protection against cpus coming up/ going down in the code below, 
> > since the cpu-hotplug operation doesn't affect the cpu_present_map. 
> 
> The locking is necessary.  Changes to cpu_online_map and
> cpu_present_map must be serialized; otherwise you could end up trying
> to online a cpu as it is being removed (i.e. cleared from
> cpu_present_map).  Online operations must check that a cpu is present
> before bringing it up (kernel/cpu.c):

Fair enough! 

But we are not protecting the cpu_present_map here using
lock_cpu_hotplug(), now are we?

The lock_cpu_hotplug() here, ensures that no cpu-hotplug operations
occur in parallel with a processor add or a processor remove. 
IOW, we're still ensuring that the cpu_online_map doesn't change 
while we're changing the cpu_present_map. So I don't see why the name
get_online_cpus() should be a problem here. May be we could add a
comment as to why we don't want a cpu-hotplug operation to happen while
we're adding/removing a processor.

Unless of course, lock_cpu_hotplug() is also used to serialize 
the add_processor and remove_processor operations. Is that the case
here ?

Thanks and Regards
gautham.
> 
> /* Requires cpu_add_remove_lock to be held */
> static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
> {
> 	int ret, nr_calls = 0;
> 	void *hcpu = (void *)(long)cpu;
> 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
> 
> 	if (cpu_online(cpu) || !cpu_present(cpu))
> 		return -EINVAL;
> 	....
> 
> > Can't we use another mutex here instead of the cpu_hotplug mutex here ?
> 
> I guess so, but I don't really see the need...
> 

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
