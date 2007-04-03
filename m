Return-Path: <linux-kernel-owner+w=401wt.eu-S2992463AbXDCWsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992463AbXDCWsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXDCWsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:48:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992463AbXDCWsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:48:50 -0400
Date: Tue, 3 Apr 2007 15:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: getting processor numbers
Message-Id: <20070403154831.37bde672.akpm@linux-foundation.org>
In-Reply-To: <4612D175.30604@redhat.com>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 15:13:09 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> Andrew Morton wrote:
> > Did we mean to go off-list?
> 
> Oops, no, pressed the wrong button.
> 
> >> Andrew Morton wrote:
> >>> So I'd have thought that in general an application should be querying its
> >>> present affinity mask - something like sched_getaffinity()?  That fixes the
> >>> CPU hotplug issues too, of course.
> >> Does it really?
> >>
> >> My recollection is that the affinity masks of running processes is not
> >> updated on hotplugging.  Is this addressed?
> > 
> > ah, yes, you're correct.
> > 
> > Inside a cpuset:
> > 
> >   sched_setaffinity() is constrained to those CPUs which are in the
> >   cpuset.
> > 
> >   If a cpu if on/offlined we update each cpuset's cpu mask appropriately
> >   but we do not update all the tasks presently running in the cpuset.
> > 
> > Outside a cpuset:
> > 
> >   sched_setaffinity() is constrained to all possible cpus
> > 
> >   We don't update each task's cpus_allowed when a CPU is removed.
> > 
> > 
> > I think we trivially _could_ update each tasks's cpus_allowed mask when a
> > CPU is removed, actually.
> 
> I think it has to be done.  But that's not so trivial.  What happens if
> all the CPUs a process was supposed to be runnable on vanish.
> Shouldn't, if no affinity mask is defined, new processors be added?  I
> agree that if the process has a defined affinity mask no new processors
> should be added _automatically_.
> 

Yes, some policy decision needs to be made there.

But whatever we decide to do, the implementation will be relatively
straightforward, because hot-unplug uses stop_machine_run() and later, we
hope, will use the process freezer.  This setting of the whole machine into
a known state means (I think) that we can avoid a whole lot of fuss which
happens when affinity is altered.

Anyway.  It's not really clear who maintains CPU hotplug nowadays.  <adds a
few cc's>.  But yes, I do thing we should do <something sane> with process
affinity when CPU hot[un]plug happens.

Now it could be argued that the current behaviour is that sane thing: we
allow the process to "pin" itself to not-present CPUs and just handle it in
the CPU scheduler.

Paul, could you please describe what cpusets' policy is in the presence of
CPU additional and removal?

> 
> >> If yes, sched_getaffinity is a solution until the NUMA topology
> >> framework can provide something better.  Even without a popcnt
> >> instruction in the CPU (64-bit albeit) it's twice as fast as the the
> >> stat() method proposed.
> > 
> > I'm surprised - I'd have expected sched_getaffinity() to be vastly quicker
> > that doing fileystem operations.
> 
> You mean because it's only a factor of two?  Well, it's not once you
> count the whole overhead.

Is it kernel overhead, or userspace?  The overhead of counting the bits?

Because sched_getaffinity() could be easily sped up in the case where
it is operating on the current process.


Anyway, where do we stand?  Assuming we can address the CPU hotplug issues,
does sched_getaffinity() look like it will be suitable?
