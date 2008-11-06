Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKFNcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKFNcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYKFNcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:32:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58800 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753612AbYKFNcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:32:13 -0500
Date: Thu, 6 Nov 2008 07:32:09 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081106133209.GA15469@sgi.com>
References: <29495f1d0811060113g331f08aereef4fd771cf43b0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0811060113g331f08aereef4fd771cf43b0e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 01:13:48AM -0800, Nish Aravamudan wrote:
> On Tue, Nov 4, 2008 at 6:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2008-11-04 at 09:34 -0500, Gregory Haskins wrote:
> >> Gregory Haskins wrote:
> >> > Peter Zijlstra wrote:
> >> >
> >> >> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
> >> >>
> >> >>
> >> >>> When load balancing gets switched off for a set of cpus via the
> >> >>> sched_load_balance flag in cpusets, those cpus wind up with the
> >> >>> globally defined def_root_domain attached.  The def_root_domain is
> >> >>> attached when partition_sched_domains calls detach_destroy_domains().
> >> >>> A new root_domain is never allocated or attached as a sched domain
> >> >>> will never be attached by __build_sched_domains() for the non-load
> >> >>> balanced processors.
> >> >>>
> >> >>> The problem with this scenario is that on systems with a large number
> >> >>> of processors with load balancing switched off, we start to see the
> >> >>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
> >> >>> This starts to become much more apparent above 8 waking RT threads
> >> >>> (with each RT thread running on it's own cpu, blocking and waking up
> >> >>> continuously).
> >> >>>
> >> >>> I'm wondering if this is, in fact, the way things were meant to work,
> >> >>> or should we have a root domain allocated for each cpu that is not to
> >> >>> be part of a sched domain?  Note the the def_root_domain spans all of
> >> >>> the non-load-balanced cpus in this case.  Having it attached to cpus
> >> >>> that should not be load balancing doesn't quite make sense to me.
> >> >>>
> >> >>>
> >> >> It shouldn't be like that, each load-balance domain (in your case a
> >> >> single cpu) should get its own root domain. Gregory?
> >> >>
> >> >>
> >> >
> >> > Yeah, this sounds broken.  I know that the root-domain code was being
> >> > developed coincident to some upheaval with the cpuset code, so I suspect
> >> > something may have been broken from the original intent.  I will take a
> >> > look.
> >> >
> >> > -Greg
> >> >
> >> >
> >>
> >> After thinking about it some more, I am not quite sure what to do here.
> >> The root-domain code was really designed to be 1:1 with a disjoint
> >> cpuset.  In this case, it sounds like all the non-balanced cpus are
> >> still in one default cpuset.  In that case, the code is correct to place
> >> all those cores in the singleton def_root_domain.  The question really
> >> is: How do we support the sched_load_balance flag better?
> >>
> >> I suppose we could go through the scheduler code and have it check that
> >> flag before consulting the root-domain.  Another alternative is to have
> >> the sched_load_balance=false flag create a disjoint cpuset.  Any thoughts?
> >
> > Hmm, but you cannot disable load-balance on a cpu without placing it in
> > an cpuset first, right?
> >
> > Or are folks disabling load-balance bottom-up, instead of top-down?
> >
> > In that case, I think we should dis-allow that.
> 
> I don't have a lot of insight into the technical discussion, but will
> say that (if I understand you right), the "bottom-up" approach was
> recommended on LKML by Max K. in the (long) thread from earlier this
> year with Subject "Inquiry: Should we remove "isolcpus= kernel boot
> option? (may have realtime uses)":
> 
> "Just to complete the example above. Lets say you want to isolate cpu2
> (assuming that cpusets are already mounted).
> 
>        # Bring cpu2 offline
>        echo 0 > /sys/devices/system/cpu/cpu2/online
> 
>        # Disable system wide load balancing
>        echo 0 > /dev/cpuset/cpuset.sched_load_banace
> 
>        # Bring cpu2 online
>        echo 1 > /sys/devices/system/cpu/cpu2/online
> 
> Now if you want to un-isolate cpu2 you do
> 
>        # Disable system wide load balancing
>        echo 1 > /dev/cpuset/cpuset.sched_load_banace
> 
> Of course this is not a complete isolation. There are also irqs (see my
> "default irq affinity" patch), workqueues and the stop machine. I'm working on
> those too and will release .25 base cpuisol tree when I'm done."
> 
> Would you recommend instead, then, that a new cpuset be created with
> only cpu 2 in it (should one set cpuset.cpu_exclusive then?) and then
> disabling load balancing in that cpuset?
> 

This is exactly the primary scenario that I've been trying (as well as having multiple cpus in that cpuset).  Regardless of the setup, the same problem occurs - the default root domain is what gets attached, and that spans all other cpus with load balancing switched off.  The lock in the def_root_domain's cpupri_vec therefore becomes contended, and that slows down thread wakeup.
