Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYAJAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYAJAGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYAJAGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:06:24 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61046 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYAJAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:06:23 -0500
Date: Wed, 9 Jan 2008 19:05:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, len.brown@intel.com, venkatesh.pallipadi@intel.com,
       abelay@novell.com, a.p.zijlstra@chello.nl, ak@suse.de
Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
In-Reply-To: <20080109154251.c70798d5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0801091900140.5064@gandalf.stny.rr.com>
References: <1199759244.26343.35.camel@localhost.localdomain>
 <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain>
 <20080109154251.c70798d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Jan 2008, Andrew Morton wrote:

>
> > Subject: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
>
> s/cpus_/cpu_/

I've been up to 4am writing patches. I must be seeing double :-/

> >  {
> >  	unsigned int cpu, this_cpu = get_cpu();
> > @@ -228,6 +232,13 @@ void cpu_idle_wait(void)
> >  				cpu_clear(cpu, map);
> >  		}
> >  		cpus_and(map, map, cpu_online_map);
> > +		/*
> > +		 * We waited 1 sec, if a CPU still did not call idle
> > +		 * it may be because it is in idle and not waking up
> > +		 * because it has nothing to do.
> > +		 * Give all the remaining CPUS a kick.
> > +		 */
> > +		smp_call_function_mask(map, do_nothing, 0, 0);
> >  	} while (!cpus_empty(map));
> >
> >  	set_cpus_allowed(current, tmp);
>
> This seems rather hacky.  Although it may turn out to be the most efficient
> fix, dunno.

s/seems/is/

>
> I'd have thought that the right fix would be to plug the race which you
> described at the top-of-thread.  That might require some redesign, but it
> sounds like the design is wrong anyway.
>
> Maybe your proposed fix is suitable for a 2.6.24 bandaid..

I was thinking the same thing.

>
> <looks at cpu_idle_wait()>
>
> <pokes his tongue out at the person who put in a global,
> exported-to-modules interface and didn't bother documenting it>
>
> OK, it's called infrequently, so a few extra IPIs there won't hurt.
>
>
> btw, it's pretty damn sad that cpu_idle_wait() will always stall for at
> least one second.  That's a huge amount of time and I bet it's thousands of
> times longer than is actually needed..
>

I didn't like that either. But I was focusing on something else, and I was
getting sick and tired of my box hanging on bootup every once in a while
(usually when I reboot and walk away, just to come back to find the box
hung).

So this was my band-aid, and since it was only happening on the box
running with my patches, I thought it may have been something I did. But
then it finally hung on a reboot to a vanilla kernel, so I decided to at
least send my band-aid out.

If anything, this should get some notice and we can have a proper fix for
.25.

-- Steve

