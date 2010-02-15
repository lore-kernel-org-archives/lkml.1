Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BOPrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:47:01 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:34167 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab0BOPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:46:59 -0500
Message-ID: <4B796C6D.80800@linux.vnet.ibm.com>
Date: Mon, 15 Feb 2010 16:46:53 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com> <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop>
In-Reply-To: <20100212100519.GA29085@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nick Piggin wrote:
> On Thu, Feb 11, 2010 at 05:11:24PM +0100, Christian Ehrhardt wrote:
>>> 2. Test with the patch below rmqueue_bulk-fewer-parameters to see if the
>>> 	number of parameters being passed is making some unexpected large
>>> 	difference
>> BINGO - this definitely hit something.
>> This experimental patch does two things - on one hand it closes the race we had:
>>
>>                                                                 4 THREAD READ   8 THREAD READ    16 THREAD READ	    %ofcalls
>> perf_count_congestion_wait                                         13              27                52
>> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0               0                 0	
>> perf_count_call_congestion_wait_from_alloc_pages_slowpath          13              27                52              99.52%
>> perf_count_pages_direct_reclaim                                 30867           56811            131552	
>> perf_count_failed_pages_direct_reclaim                             14              24                52	
>> perf_count_failed_pages_direct_reclaim_but_progress                14              21                52              0.04% !!!
>>
>> On the other hand we see that the number of direct_reclaim calls increased by ~x4.
>>
>> I assume (might be totally wrong) that the x4 increase of direct_reclaim calls could be caused by the fact that before we used higher orders which worked on x4 number of pages at once.
> 
> But the order parameter was always passed as constant 0 by the caller?

Uh - I didn't see that in the first look - you're right.
So the x4 in direct_reclaim calls are not caused by e.g. missing order information. Thanks for spotting this.

> 
>> This leaves me with two ideas what the real issue could be:
>> 1. either really the 6th parameter as this is the first one that needs to go on stack and that way might open a race and rob gcc a big pile of optimization chances
> 
> It must be something to do with code generation AFAIKS. I'm surprised
> the function isn't inlined, giving exactly the same result regardless
> of the patch.

after checking asm I can tell that rmqueue_bulk is inlined.
Therefore the test to inline it explicitly as requested in another mail can be considered negligible.
It actually boils down to something different in Mels patch - see below.
 
> Unlikely to be a correctness issue with code generation, but I'm
> really surprised that a small difference in performance could have
> such a big (and apparently repeatable) effect on behaviour like this.
> 
> What's the assembly look like?
> 

Line 214763
This is the preparation of the __mod_zone_page_state call from rmqueue_bulk which  is inlined into
get_page_from_freelist.

!ORDER CHANGED FOR READABILITY!
FAST                               SLOW
lgr  %r2,%r11  #parm 1 from r11    lgr  %r2, %r11  #parm 1 from r11 - same
lghi %r3,0     #parm 2 = 0 const   lghi %r3,0      #parm 2 = 0 - same
lghi %r4,-1    #parm 3 = -1 const  lcr  %r4,%r12   #parm 3 as complement of r12?
                                   lgfr %r4,%r4    #parm 3 - clear upper 32 bit?
brasl          #call               brasl           #call

=> This is most probably this part of Mel's patch:
 23 @@ -965,7 +965,7 @@
 24                 set_page_private(page, migratetype);
 25                 list = &page->lru;
 26         }
 27 -       __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 28 +       __mod_zone_page_state(zone, NR_FREE_PAGES, -1);
 29         spin_unlock(&zone->lock);
 30         return i;
 31  }

-> doesn't look too important, but to be sure we can build an executable with
just this change, but still passing order to rmqueue_bulk - see below.


Line 214800
Differend end of the function. In Slow path there is a check to %r4 and
dependent two different jump targets inside get_page_from_freelist, while in
the fast version there is only an unconditional jump (both after a
_raw_spin_lock_wait).

FAST                                  SLOW
brasl   # call _raw_spin_lock_wait    brasl              # _raw_spin_lock_wait
j       1e6294 get_page_from_freelist lg   %r4,288(%r15) # from stack
                                      ltgr %r4,%r4       # compare
                                      jne  1e62a2 get_page_from_freelist
                                      lhi  %r12,0 # new call gets r12 @ 0 (GOT?)
                                      j    1e6340 get_page_from_freelist
The rest is the same. So what is left is that the slow variant has a new branch
back in to get_page_from_freelist with r12 set to zero. This jump wents directly
after the also new lcr call seen in the first difference and might therfore be
related to that change.

Now I first thought it might not be rmqueue_bulk that misses optimization, but
__mod_zone_page_state - but that one looks the same in both cases.

Therefore I took a shot for 2.6.32 with just that snippet above applied (__mod_zone_page_state call without order which should be fine as we know it is 0 in all cases).
And it is interesting to see that this snippet alone is enough to fix throughput and the direct_reclaim -> progress&!page ratio.

The differences in asm are pretty much the same, as before rmqueue_bulk was already inlined the actually intended change to its parameters was negligible.
I wondered if it would be important if that is a constant value (-1) or if the reason was caused by that shift. So I tried:

 23 @@ -965,7 +965,7 @@
 24                 set_page_private(page, migratetype);
 25                 list = &page->lru;
 26         }
 27 -       __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 28 +       __mod_zone_page_state(zone, NR_FREE_PAGES, -i);
 29         spin_unlock(&zone->lock);
 30         return i;
 31  }

Now that one has still the issue of the very huge throughput loss and the bad ratio of driect_reclaims leading into congestion_wait.
Now as far as I can see that - oh so important - "-i" or "-1" ends up in zone_page_state_add as variable x:
static inline void zone_page_state_add(long x, struct zone *zone,
                                 enum zone_stat_item item)
{
        atomic_long_add(x, &zone->vm_stat[item]);
        atomic_long_add(x, &vm_stat[item]);
}

I guess the intention there is to update the zone with the number of pages freed - and I also guess that -1 as constant might be wrong there.
That would also explain some weird output I saw like this after boot:
h37lp01:~ # cat /proc/meminfo
MemTotal:         251216 kB
MemFree:          483460 kB bigger than total

BUT, and that is now again open for discussion - "__mod_zone_page_state(zone, NR_FREE_PAGES, -1)" even being wrong - fixed the issue in terms of throughput and the congestion_waits as good as reverting e084b+5f8dcc21!


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 
