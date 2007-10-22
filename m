Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXJVEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXJVEwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXJVEwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:52:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34889 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXJVEwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:52:03 -0400
Date: Mon, 22 Oct 2007 10:21:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071022045159.GA7146@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain> <20071018075702.GB15281@in.ibm.com> <20071018082221.GE6773@localdomain> <20071018085959.GC15281@in.ibm.com> <20071018173054.GF6773@localdomain> <20071019050456.GB26625@in.ibm.com> <20071022004312.GH6773@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022004312.GH6773@localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Okay. But other than pseries_add_processor and pseries_remove_processor,
> > are there any other places where we _change_ the cpu_present_map ?
> 
> Other arch code e.g. ia64 changes it for add/remove also.  But I fail
> to see how it matters.
> 
> 
> > I agree that we need some kind of synchronization for threads which
> > read the cpu_present_map. But probably we can use a seperate mutex
> > for that.
> 
> That would be needless complexity.
> 
> 
> > > The naming is a problem IMO for two reasons:
> > > 
> > > - lock_cpu_hotplug() protects cpu_present_map as well as
> > >   cpu_online_map (sigh, I see that Documentation/cpu-hotplug.txt
> > >   disagrees with me, but my statement holds for powerpc, at least).
> > > 
> > > - get_online_cpus() implies reference count semantics (as stated in
> > >   the changelog) but AFAICT it really has a reference count
> > >   implementation with read-write locking semantics.
> > > 
> > > Hmm, I think there's another problem here.  With your changes, code
> > > which relies on the mutual exclusion behavior of lock_cpu_hotplug()
> > > (such as pseries_add/remove_processor) will now be able to run
> > > concurrently.  Probably those functions should use
> > > cpu_hotplug_begin/end instead.
> > 
> > One of the primary reasons to move away from the mutex semantics for
> > cpu-hotplug protection, was that there were a lot of places where
> > lock_cpu_hotplug() was used for protecting local data structures too,
> > when they had nothing to do with cpu-hotplug as such, and it resulted 
> > in a whole mess. It took people quite sometime to sort things out 
> > with the cpufreq subsystem.
> 
> cpu_present_map isn't a "local data structure" any more than
> cpu_online_map, and it is quite relevant to cpu hotplug.  We have to
> maintain the invariant that the set of cpus online is a subset of cpus
> present.
> 
> > Probably it would be a lot cleaner if we use get_online_cpus() for
> > protection against cpu-hotplug and use specific mutexes for serializing
> > accesses to local data structures. Thoughts?
> 
> I don't feel like I'm getting through here.  Let me restate.
> 
> If I'm reading them correctly, these patches are changing the behavior
> of lock_cpu_hotplug() from mutex-style locking to a kind of read-write
> locking.  I think that's fine, but the naming of the new API poorly
> reflects its real behavior.  Conversion of lock_cpu_hotplug() users
> should be done with care.  Most of them - those that need one of the
> cpu maps to remain unchanged during a critical section - can be
> considered readers.  But a few (such as pseries_add_processor() and
> pseries_remove_processor()) are writers, because they modify one of
> the maps.
> 
> So, why not:
> 
> get_cpus_online   -> cpumaps_read_lock
> put_cpus_online   -> cpumaps_read_unlock
> cpu_hotplug_begin -> cpumaps_write_lock
> cpu_hotplug_end   -> cpumaps_write_unlock
> 
> Or something similar?

Hi Nathan, 
I totally see your point and agree with it. 

However, though the new implementation appears to have
a read-write-semaphore behaviour it differs in 
following aspects:

a) This implementation allows natural recursion of reads, just
as in the case of preempt_count. 
This is not possible in case of a normal read-write
lock because if you have something like the following in
a timeline, 
R1 -- > R2--> W3 --> R1, where 
Ri is a read by a thread i and
Wi is a write by a thread i, 
then thread1 will deadlock as it will be blocked behind W3, 
holding the semaphore.

b) Regular Reader Writer semaphores are fair. As in if a new reader
arrives when a writer is already present, the new reader waits until
the writer in front of it finishes. But, in the new implementation, 
the new reader will proceed as long as the refcount is non-zero, and the
writer will get to run only when the number of readers = 0. However, the
readers which arrive when the writer is executing, will block until the
writer is done.

Because of these properties, the implementation is more similar to the
refcounting, except that it allows the new bunch of readers to
sleep during an ongoing write.

Like you pointed out, since the code of pseries_add_processor and 
other places where the cpu_present_map is being changed during the
runtime requires write protection, how if the 
cpu_hotplug_begin/cpu_hotplug_end support is made
available outside cpu.c and appropriately named ?

Personally I would propose the following names to reflect the behaviour, 
but if the community is okay with the word "lock" in the API's I don't
have any problems renaming them to what you've suggested.

/* 
 * Api's which ensure that the cpu_present_map and the cpu_online_map
 * do not change while operating in a critical section.
 */
 
 get_cpu_maps();
 put_cpu_maps();

/* 
 * Api's to serialize the updates to the cpu_present_map/cpu_online_map.
 */

 cpu_map_update_begin();
 cpu_map_update_done();

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
