Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbXJVAnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbXJVAnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXJVAnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:43:17 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:33407 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXJVAnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:43:16 -0400
Date: Sun, 21 Oct 2007 19:43:12 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071022004312.GH6773@localdomain>
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain> <20071018075702.GB15281@in.ibm.com> <20071018082221.GE6773@localdomain> <20071018085959.GC15281@in.ibm.com> <20071018173054.GF6773@localdomain> <20071019050456.GB26625@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019050456.GB26625@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> > Gautham R Shenoy wrote:
> > > On Thu, Oct 18, 2007 at 03:22:21AM -0500, Nathan Lynch wrote:
> > > > Gautham R Shenoy wrote:
> > > > > > Gautham R Shenoy wrote:
> > > > > > > Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> > > > > > > get_online_cpus and put_online_cpus instead as it highlights
> > > > > > > the refcount semantics in these operations.
> > > > > > 
> > > > > > Something other than "get_online_cpus", please?  lock_cpu_hotplug()
> > > > > > protects cpu_present_map as well as cpu_online_map.  For example, some
> > > > > > of the powerpc code modified in this patch is made a bit less clear
> > > > > > because it is manipulating cpu_present_map, not cpu_online_map.
> > > > > 
> > > > > A quick look at the code, and I am wondering why is lock_cpu_hotplug()
> > > > > used there in the first place. It doesn't look like we require any 
> > > > > protection against cpus coming up/ going down in the code below, 
> > > > > since the cpu-hotplug operation doesn't affect the cpu_present_map. 
> > > > 
> > > > The locking is necessary.  Changes to cpu_online_map and
> > > > cpu_present_map must be serialized; otherwise you could end up trying
> > > > to online a cpu as it is being removed (i.e. cleared from
> > > > cpu_present_map).  Online operations must check that a cpu is present
> > > > before bringing it up (kernel/cpu.c):
> > > 
> > > Fair enough! 
> > > 
> > > But we are not protecting the cpu_present_map here using
> > > lock_cpu_hotplug(), now are we?
> > 
> > Yes, we are.  In addition to the above, updates to cpu_present_map
> > have to be serialized.  pseries_add_processor can be summed up as
> > "find the first N unset bits in cpu_present_map and set them".  That's
> > not an atomic operation, so some kind of mutual exclusion is needed.
> > 
> 
> Okay. But other than pseries_add_processor and pseries_remove_processor,
> are there any other places where we _change_ the cpu_present_map ?

Other arch code e.g. ia64 changes it for add/remove also.  But I fail
to see how it matters.


> I agree that we need some kind of synchronization for threads which
> read the cpu_present_map. But probably we can use a seperate mutex
> for that.

That would be needless complexity.


> > The naming is a problem IMO for two reasons:
> > 
> > - lock_cpu_hotplug() protects cpu_present_map as well as
> >   cpu_online_map (sigh, I see that Documentation/cpu-hotplug.txt
> >   disagrees with me, but my statement holds for powerpc, at least).
> > 
> > - get_online_cpus() implies reference count semantics (as stated in
> >   the changelog) but AFAICT it really has a reference count
> >   implementation with read-write locking semantics.
> > 
> > Hmm, I think there's another problem here.  With your changes, code
> > which relies on the mutual exclusion behavior of lock_cpu_hotplug()
> > (such as pseries_add/remove_processor) will now be able to run
> > concurrently.  Probably those functions should use
> > cpu_hotplug_begin/end instead.
> 
> One of the primary reasons to move away from the mutex semantics for
> cpu-hotplug protection, was that there were a lot of places where
> lock_cpu_hotplug() was used for protecting local data structures too,
> when they had nothing to do with cpu-hotplug as such, and it resulted 
> in a whole mess. It took people quite sometime to sort things out 
> with the cpufreq subsystem.

cpu_present_map isn't a "local data structure" any more than
cpu_online_map, and it is quite relevant to cpu hotplug.  We have to
maintain the invariant that the set of cpus online is a subset of cpus
present.

> Probably it would be a lot cleaner if we use get_online_cpus() for
> protection against cpu-hotplug and use specific mutexes for serializing
> accesses to local data structures. Thoughts?

I don't feel like I'm getting through here.  Let me restate.

If I'm reading them correctly, these patches are changing the behavior
of lock_cpu_hotplug() from mutex-style locking to a kind of read-write
locking.  I think that's fine, but the naming of the new API poorly
reflects its real behavior.  Conversion of lock_cpu_hotplug() users
should be done with care.  Most of them - those that need one of the
cpu maps to remain unchanged during a critical section - can be
considered readers.  But a few (such as pseries_add_processor() and
pseries_remove_processor()) are writers, because they modify one of
the maps.

So, why not:

get_cpus_online   -> cpumaps_read_lock
put_cpus_online   -> cpumaps_read_unlock
cpu_hotplug_begin -> cpumaps_write_lock
cpu_hotplug_end   -> cpumaps_write_unlock

Or something similar?
