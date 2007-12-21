Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbXLUQSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbXLUQSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXLUQS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:18:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50504 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751579AbXLUQS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:18:26 -0500
Date: Fri, 21 Dec 2007 08:18:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071221120908.GA15926@elte.hu>
Message-ID: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Ingo Molnar wrote:

> what's up with this regression? There's been absolutely no activity 
> about it in the last 8 days: upstream still regresses, -mm still 
> regresses and there are no patches posted for testing.

I added a test that does this 1 alloc N free behavior to the slab 
in kernel benchmark (cpu 0 continually allocs, cpu 1-7 continously free) 
(all order 0). The test makes the regression worse because it run the 
scenario with raw slab allocs/frees in the kernel context without the use 
of the scheduler:

SLAB
1 alloc N free(8): 0=2115 1=549 2=551 3=550 4=550 5=550 6=551 7=549 Average=746
1 alloc N free(16): 0=2159 1=573 2=574 3=573 4=574 5=573 6=574 7=573 Average=772
1 alloc N free(32): 0=2168 1=577 2=576 3=577 4=579 5=578 6=577 7=576 Average=776
1 alloc N free(64): 0=2276 1=555 2=554 3=554 4=555 5=556 6=555 7=554 Average=770
1 alloc N free(128): 0=2635 1=549 2=548 3=548 4=550 5=549 6=548 7=549 Average=809
1 alloc N free(256): 0=3261 1=543 2=542 3=542 4=544 5=542 6=542 7=542 Average=882
1 alloc N free(512): 0=4642 1=571 2=572 3=570 4=573 5=571 6=572 7=572 Average=1080
1 alloc N free(1024): 0=7116 1=582 2=581 3=583 4=581 5=582 6=582 7=583 Average=1399
1 alloc N free(2048): 0=11612 1=667 2=667 3=667 4=668 5=667 6=668 7=667 Average=2035
1 alloc N free(4096): 0=20135 1=673 2=674 3=674 4=675 5=674 6=675 7=674 Average=3107

SLUB
1 alloc N free test
===================
1 alloc N free(8): 0=1223 1=645 2=417 3=643 4=538 5=612 6=557 7=564 Average=650
1 alloc N free(16): 0=3828 1=3140 2=3116 3=3166 4=3122 5=3172 6=3129 7=3172 Average=3231
1 alloc N free(32): 0=4116 1=3207 2=3180 3=3210 4=3183 5=3202 6=3182 7=3214 Average=3312
1 alloc N free(64): 0=4116 1=3017 2=3005 3=3013 4=3006 5=3016 6=3004 7=3020 Average=3149
1 alloc N free(128): 0=5282 1=3013 2=3010 3=3014 4=3009 5=3010 6=3005 7=3013 Average=3295
1 alloc N free(256): 0=5271 1=2750 2=2751 3=2751 4=2751 5=2751 6=2752 7=2751 Average=3066
1 alloc N free(512): 0=5304 1=2293 2=2295 3=2295 4=2295 5=2294 6=2295 7=2294 Average=2671
1 alloc N free(1024): 0=6017 1=2044 2=2043 3=2043 4=2043 5=2045 6=2044 7=2044 Average=2541
1 alloc N free(2048): 0=7162 1=2086 2=2084 3=2086 4=2086 5=2085 6=2086 7=2086 Average=2720
1 alloc N free(4096): 0=7133 1=1795 2=1796 3=1796 4=1797 5=1795 6=1796 7=1795 Average=2463

So we have 3 different regimes here (order 0):

1. SLUB wins in size 8 because the cpu slab is never given up given that 
   we have 512 objects 8 byte objects in a 4K slab (same scenario that we
   can produce with slub_min_order=9).

2. At the high end (>= 2048) the additional overhead of SLAB when 
   allocating objects makes SLUB again performance wise better or similar.

3. There is an intermediate range where the cpu slab has to be changed
   (and thus list_lock has to be used) and where multiple cpus that free
   objects can simultaneouly hit the slab lock of the same slab page. That 
   is the cause of the regression

The regression is contained because:

1. The contention only exist when concurrently freeing and allocation
   from the same slab page. SLUB has provisions for keeping a single 
   allocator and a single freeer in the clear by moving the freelist 
   pointer when a slab page becomes a cpu slab. Concurrent allocs and 
   frees are possible without cacheline contention. The problem only comes
   about when multiple free operations occur simultaneously to the same
   slab page.
 
2. The number of objects in a slab is limited. For the 128 byte size of
   interest here we have 32 objects in a slab. The maximum theoretical 
   contention on the slab lock is through 32 cpus if they are all freeing 
   simultaneously.

3. The tests are an artificial scenario. Typically one would have 
   additional processing in both the alloc and the free paths which would
   reduce the contention. If one would not have complex processing on 
   alloc then we typically allocate the object on the remote processor 
   (warms up the processor cache) instead of allocating objects while 
   freeing  them on remote processors.

4. The contention is reduced the larger the object size becomes since
   this will reduce the number of object per slab page. Thus the number
   of processors taking the lock simultaneously is also reduced.

5. The contention is also reduced through normal operations that will
   lead to the creation of partially populated slabs. If we cannot 
   allocate a large number of objects from the same slab (typical if
   the system has been run for awhile) then the contention is 
   constrained.

We could address this issue by:

1. Detecting the contention while taking the slab lock and then defer the 
   free for these special situations (f.e. by using RCU to free these 
   objects.

2. Not allocate from the same slab if we detect contention.

But given all the boundaries for the contention I would think that it is 
not worth addressing. 

> being able to utilize order-0 pages was supposed to be one of the big 
> plusses of SLUB, so booting with _2MB_ sized slabs cannot be seriously 
> the "fix", right?

Booting with 2MB sized slab is certainly not the mainstream fix although I 
expect that some SGI machines may run with that as the default 
given that they have a couple of terabytes of memory and also the 2Mb 
configurations reduce TLB pressure significantly. The use of 2MB slabs is 
not motivated by the contention that we see here but rather because of the 
improved scaling and nice interaction with the huge page management 
framework provided by the antifrag patches.

Order 0 allocations were never the emphasis of SLUB. The emphasis was on 
being able to use higher order allocs in order to make slab operations 
scale higher.
