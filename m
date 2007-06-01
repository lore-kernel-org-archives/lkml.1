Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbXFAQdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbXFAQdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbXFAQdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:33:36 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:33069 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641AbXFAQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:33:36 -0400
Date: Fri, 1 Jun 2007 12:33:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070601163333.GA3242@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <20070530133407.4f5789a0.akpm@linux-foundation.org> <20070601155413.GA1216@Krystal> <20070601091909.97570a16.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070601091909.97570a16.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:28:26 up 4 days,  1:07,  2 users,  load average: 0.29, 0.24, 0.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 1 Jun 2007 11:54:13 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Wed, 30 May 2007 10:00:34 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > @@ -2990,7 +2991,8 @@
> > > >  			print_irqtrace_events(prev);
> > > >  		dump_stack();
> > > >  	}
> > > > -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> > > > +	cond_call(profile_on,
> > > > +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
> > > >  
> > > 
> > > That's looking pretty neat.  Do you have any before-and-after performance
> > > figures for i386 and for a non-optimised architecture?
> > 
> > Sure, here is the result of a small test comparing:
> > 1 - Branch depending on a cache miss (has to fetch in memory, caused by a 128
> >     bytes stride)). This is the test that is likely to look like what
> >     side-effect the original profile_hit code was causing, under the
> >     assumption that the kernel is already using L1 and L2 caches at
> >     their full capacity and that a supplementary data load would cause
> >     cache trashing.
> > 2 - Branch depending on L1 cache hit. Just for comparison.
> > 3 - Branch depending on a load immediate in the instruction stream.
> > 
> > It has been compiled with gcc -O2. Tests done on a 3GHz P4.
> > 
> > In the first test series, the branch is not taken:
> > 
> > number of tests : 1000
> > number of branches per test : 81920
> > memory hit cycles per iteration (mean) : 48.252
> > L1 cache hit cycles per iteration (mean) : 16.1693
> > instruction stream based test, cycles per iteration (mean) : 16.0432
> > 
> > 
> > In the second test series, the branch is taken and an integer is
> > incremented within the block:
> > 
> > number of tests : 1000
> > number of branches per test : 81920
> > memory hit cycles per iteration (mean) : 48.2691
> > L1 cache hit cycles per iteration (mean) : 16.396
> > instruction stream based test, cycles per iteration (mean) : 16.0441
> > 
> > Therefore, the memory fetch based test seems to be 200% slower than the
> > load immediate based test.
> 
> Confused.  From what did you calculate that 200%?
> 
> > (I am adding these results to the documentation)
> 
> Good, thanks.


(48.2691-16.0441)/16.0441 = 2.00

Which means that it is 200% slower to run this test while fetching the
branch condition from main memory rather than using the load immediate.

We could also put it like this : the speedup of the load immediate over
the memory fetch is 3.

48.2691/16.0441 = 3.00

Is there a preferred way to present these results in the documentation ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
