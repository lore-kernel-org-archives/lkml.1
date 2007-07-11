Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXGKFHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXGKFHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXGKFHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:07:44 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63561 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbXGKFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:07:44 -0400
Date: Wed, 11 Jul 2007 01:02:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] *Tests* Scheduler profiling - Use immediate values
Message-ID: <20070711050238.GC4025@Krystal>
References: <20070707015009.GA10775@Krystal> <5FD5754DDBA0B1499B5A0B4BB5419485015CCB91@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485015CCB91@fmsmsx411.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:58:23 up 3 days, 19:03,  3 users,  load average: 0.47, 0.24, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Li, Tong N (tong.n.li@intel.com) wrote:
> Mathieu,
> 
> > 	cycles_per_iter = 0.0;
> > 	for (i=0; i<NR_TESTS; i++) {
> > 		time1 = get_cycles();
> > 		for (j = 0; j < NR_ITER; j++) {
> > 			testval = &array[random() % ARRAY_SIZE];
> > 		}
> > 		time2 = get_cycles();
> > 		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
> > 	}
> > 	cycles_per_iter /= (double)NR_TESTS;
> > 	printf("Just getting the pointer, doing noting with it, cycles
> per
> > iteration (mean) : %g\n", cycles_per_iter);
> > 
> 
> Some comments on the code:
> 
> 1. random() is counted in cycle_per_iter, which can skew the results.
> You could pre-compute the random addresses and store them in an array.
> Then, during the actual timing, walk the array:
> 
> index = 0;
> for (i = 0; i < ARRAY_SIZE; i++)
>       index = *(int *)(array + index * CACHE_LINE_SIZE);
> 
> 2. You may want to flush the cache before the timing starts.
> 
> 3. You want to access memory at the cache-line granularity to avoid
> addresses falling into the same line (and thus unwanted hits).
> 

This is true, my test code was not perfect. Thanks for the hints.
The improvements you propose will clearly accelerate my test program
quite a bit, but I doubt that it will cause even higher memory
latencies. Although using a random() at each memory access is slow, it
should give a good enough dispersion. And since do 3 cache trashing
passes in my code, I make sure that each and every cache lines are
trashed. In fact, since I do multiple accesses to each cache line (as
you noted in point 3), it takes more time, but makes it more certain
that I hit all of them at least once.

> If you do these, I expect you'll get a higher memory latency.
> 

I will use these comments in my next tests, thanks. :) However, I still
feel confident that the numbers I got from my run still hold.

Mathieu

>   tong
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
