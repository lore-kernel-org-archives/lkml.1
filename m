Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZBNGmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZBNGmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 01:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZBNGmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 01:42:43 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:39768 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZBNGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 01:42:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEACPylUlMQWt2/2dsb2JhbACBbcF+CI5UgmAIgTQG
Date: Sat, 14 Feb 2009 01:42:37 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090214064237.GA30505@Krystal>
References: <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal> <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain> <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain> <20090213185411.GB7124@Krystal> <20090213193619.GH6854@linux.vnet.ibm.com> <8bd0f97a0902132107r3651ce4rc5bc4e027268e2aa@mail.gmail.com> <20090214052030.GB7194@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090214052030.GB7194@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:28:17 up 44 days,  6:26,  4 users,  load average: 0.84, 1.16,
	1.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Feb 14, 2009 at 12:07:46AM -0500, Mike Frysinger wrote:
> > On Fri, Feb 13, 2009 at 14:36, Paul E. McKenney wrote:
> > > On Fri, Feb 13, 2009 at 01:54:11PM -0500, Mathieu Desnoyers wrote:
> > >> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > >> > Btw, for user space, if you want to do this all right for something like
> > >> > BF. I think the only _correct_ thing to do (in the sense that the end
> > >> > result will actually be debuggable) is to essentially give full SMP
> > >> > coherency in user space.
> > >> >
> > >> > It's doable, but rather complicated, and I'm not 100% sure it really ends
> > >> > up making sense. The way to do it is to just simply say:
> > >> >
> > >> >  - never map the same page writably on two different cores, and always
> > >> >    flush the cache (on the receiving side) when you switch a page from one
> > >> >    core to another.
> > >> >
> > >> > Now, the kernel can't really do that reasonably, but user space possibly could.
> > >> >
> > >> > Now, I realize that blackfin doesn't actually even have a MMU or a TLB, so
> > >> > by "mapping the same page" in that case we end up really meaning "having a
> > >> > shared mapping or thread". I think that _should_ be doable. The most
> > >> > trivial approach might be to simply limit all processes with shared
> > >> > mappings or CLONE_VM to core 0, and letting core 1 run everything else
> > >> > (but you could do it differently: mapping something with MAP_SHARED would
> > >> > force you to core 0, but threads would just force the thread group to
> > >> > stay on _one_ core, rather than necessarily a fixed one).
> > >> >
> > >> > Yeah, because of the lack of real memory protection, the kernel can't
> > >> > _know_ that processes don't behave badly and access things that they
> > >> > didn't explicitly map, but I'm hoping that that is rare.
> > >> >
> > >> > And yes, if you really want to use threads as a way to do something
> > >> > across cores, you'd be screwed - the kenrel would only schedule the
> > >> > threads on one CPU. But considering the undefined nature of threading on
> > >> > such a cpu, wouldn't that still be preferable? Wouldn't it be nice to have
> > >> > the knowledge that user space _looks_ cache-coherent by virtue of the
> > >> > kernel just limiting cores appropriately?
> > >> >
> > >> > And then user space would simply not need to worry as much. Code written
> > >> > for another architecture will "just work" on BF SMP too. With the normal
> > >> > uclinux limitations, of course.
> > >>
> > >> I don't know enough about BF to tell for sure, but the other way around
> > >> I see that would still permit running threads with shared memory space
> > >> on different CPUs is to call a cache flush each time a userspace lock is
> > >> taken/released (at the synchronization points where the "magic
> > >> test-and-set instruction" is used) _from_ userspace.
> > >>
> > >> If some more elaborate userspace MT code uses something else than those
> > >> basic locks provided by core libraries to synchronize data exchange,
> > >> then it would be on its own and have to ensure cache flushing itself.
> > >
> > > How about just doing a sched_setaffinity() in the BF case?  Sounds
> > > like an easy way to implement Linus's suggestion of restricting the
> > > multithreaded processes to a single core.  I have a hard time losing
> > > sleep over the lack of parallelism in the case where the SMP support is
> > > at best rudimentary...
> > 
> > the quick way is to tell people to run their program through `taskset`
> > (which is what we're doing now).
> 
> Not sure what environment Mathieu is looking to run his program from,
> but he would need to run it on multiple architectures.
> 

Given I plan to use this userspace rcu mechanism to ensure coherency of
the LTTng userspace tracing control data structures, and given I plan to
deploy it on a large set of architectures (ideally all architectures
supported by Linux), I need to understand the limitations linked to the
design choice we make. If we make the assumption that the caches are
coherent, that's fine, but we have to document it, because otherwise
people might think we would have taken that into account when it is not
the case. Knowing the limitation of the cache coherency model and memory
ordering will help us designing what I hope to be a rock-solid userspace
RCU library.

And if we document clearly the points of data exchange within our
implementation, it could possibly become an efficient way of supporting
SMP on such architectures given RCU need very few synchronization or to
better identify, for instances, remote vs local NUMA accesses. It leaves
room for exploration.

Mathieu


> > the next step up (or down depending on how you look at it) would be to
> > hook the clone function to do this automatically.  i havent gotten
> > around to testing this yet which is why there isnt anything in there
> > yet though.
> > 
> > asmlinkage int bfin_clone(struct pt_regs....
> >        unsigned long clone_flags;
> >        unsigned long newsp;
> > 
> > +#ifdef CONFIG_SMP
> > +       if (current->rt.nr_cpus_allowed == NR_CPUS) {
> > +               current->cpus_allowed = cpumask_of_cpu(smp_processor_id());
> > +               current->rt.nr_cpus_allowed = 1;
> > +       }
> > +#endif
> > +
> >        /* syscall2 puts clone_flags in r0 and usp in r1 */
> >        clone_flags = regs->r0;
> >        newsp = regs->r1;
> 
> Wouldn't you also have to make sched_setaffinity() cut back to only one
> CPU if more are specified?  If Blackfin handles hotplug CPU, that may
> need attention as well, since tasks affinitied to the CPU being removed
> can end up with their affinity set to all CPUs.  And there are probably
> other issues.
> 
> 							Thanx, Paul
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
