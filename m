Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXFAQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXFAQTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbXFAQTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:19:19 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757058AbXFAQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:19:18 -0400
Date: Fri, 1 Jun 2007 09:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-Id: <20070601091909.97570a16.akpm@linux-foundation.org>
In-Reply-To: <20070601155413.GA1216@Krystal>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140229.811672406@polymtl.ca>
	<20070530133407.4f5789a0.akpm@linux-foundation.org>
	<20070601155413.GA1216@Krystal>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 11:54:13 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Wed, 30 May 2007 10:00:34 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > @@ -2990,7 +2991,8 @@
> > >  			print_irqtrace_events(prev);
> > >  		dump_stack();
> > >  	}
> > > -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> > > +	cond_call(profile_on,
> > > +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
> > >  
> > 
> > That's looking pretty neat.  Do you have any before-and-after performance
> > figures for i386 and for a non-optimised architecture?
> 
> Sure, here is the result of a small test comparing:
> 1 - Branch depending on a cache miss (has to fetch in memory, caused by a 128
>     bytes stride)). This is the test that is likely to look like what
>     side-effect the original profile_hit code was causing, under the
>     assumption that the kernel is already using L1 and L2 caches at
>     their full capacity and that a supplementary data load would cause
>     cache trashing.
> 2 - Branch depending on L1 cache hit. Just for comparison.
> 3 - Branch depending on a load immediate in the instruction stream.
> 
> It has been compiled with gcc -O2. Tests done on a 3GHz P4.
> 
> In the first test series, the branch is not taken:
> 
> number of tests : 1000
> number of branches per test : 81920
> memory hit cycles per iteration (mean) : 48.252
> L1 cache hit cycles per iteration (mean) : 16.1693
> instruction stream based test, cycles per iteration (mean) : 16.0432
> 
> 
> In the second test series, the branch is taken and an integer is
> incremented within the block:
> 
> number of tests : 1000
> number of branches per test : 81920
> memory hit cycles per iteration (mean) : 48.2691
> L1 cache hit cycles per iteration (mean) : 16.396
> instruction stream based test, cycles per iteration (mean) : 16.0441
> 
> Therefore, the memory fetch based test seems to be 200% slower than the
> load immediate based test.

Confused.  From what did you calculate that 200%?

> (I am adding these results to the documentation)

Good, thanks.
