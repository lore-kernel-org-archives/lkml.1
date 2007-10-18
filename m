Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXJRIXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXJRIXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbXJRIWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:22:32 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:46343 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbXJRIW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:22:29 -0400
Date: Thu, 18 Oct 2007 03:22:21 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071018082221.GE6773@localdomain>
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain> <20071018075702.GB15281@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018075702.GB15281@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> Hi Nathan, 
> > Hi Gautham-
> > 
> > Gautham R Shenoy wrote:
> > > Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> > > get_online_cpus and put_online_cpus instead as it highlights
> > > the refcount semantics in these operations.
> > 
> > Something other than "get_online_cpus", please?  lock_cpu_hotplug()
> > protects cpu_present_map as well as cpu_online_map.  For example, some
> > of the powerpc code modified in this patch is made a bit less clear
> > because it is manipulating cpu_present_map, not cpu_online_map.
> 
> A quick look at the code, and I am wondering why is lock_cpu_hotplug()
> used there in the first place. It doesn't look like we require any 
> protection against cpus coming up/ going down in the code below, 
> since the cpu-hotplug operation doesn't affect the cpu_present_map. 

The locking is necessary.  Changes to cpu_online_map and
cpu_present_map must be serialized; otherwise you could end up trying
to online a cpu as it is being removed (i.e. cleared from
cpu_present_map).  Online operations must check that a cpu is present
before bringing it up (kernel/cpu.c):

/* Requires cpu_add_remove_lock to be held */
static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
{
	int ret, nr_calls = 0;
	void *hcpu = (void *)(long)cpu;
	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;

	if (cpu_online(cpu) || !cpu_present(cpu))
		return -EINVAL;
	....

> Can't we use another mutex here instead of the cpu_hotplug mutex here ?

I guess so, but I don't really see the need...

