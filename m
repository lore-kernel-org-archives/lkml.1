Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0BRQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:09:58 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:44490 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0BRQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:09:56 -0500
Message-ID: <4B7D664C.20507@linux.vnet.ibm.com>
Date: Thu, 18 Feb 2010 17:09:48 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com> <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie>
In-Reply-To: <20100218114310.GC32626@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Wed, Feb 17, 2010 at 10:55:08AM +0100, Christian Ehrhardt wrote:
>> Christian Ehrhardt wrote:
>>> Mel Gorman wrote:
>>>> On Mon, Feb 15, 2010 at 04:46:53PM +0100, Christian Ehrhardt wrote:
>>> [...]
>>>>> The differences in asm are pretty much the same, as before rmqueue_bulk was already inlined the actually intended change to its parameters was negligible.
>>>>> I wondered if it would be important if that is a constant value (-1) or if the reason was caused by that shift. So I tried:
>>>>>
>>>>>  23 @@ -965,7 +965,7 @@
>>>>>  24                 set_page_private(page, migratetype);
>>>>>  25                 list = &page->lru;
>>>>>  26         }
>>>>>  27 -       __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
>>>>>  28 +       __mod_zone_page_state(zone, NR_FREE_PAGES, -i);
>>>>>  29         spin_unlock(&zone->lock);
>>>>>  30         return i;
>>>>>  31  }
>>>>>
>>> [...]
>>>> It "fixes" it only by not calling direct reclaim when it should :(
>>> yeah as we both realized -1 was not right so it was more a crazy workaround :-)
>>>
>>> Anyway after that being a dead end again I dug even deeper into the details of direct_reclaim - I think we can agree that out of the counters we already know the race between try_to_free making progress and get_page not getting a page causing the congestion_wait is source of the issue.
>>>
>>> So what I tried to bring some more light into all that was extending my perf counters to track a few more details in direct_reclaim.
>>> Two patches are attached and apply after the other three already available in that thread.
>>> The intention is
>>> a) to track the time
>>>  a1) spent in try_to_free_pages
>>>  a2) consumed after try_to_free_pages until get_page_from_freelist
>>>  a3) spent in get_pages_from_freelist
>>> b1) after seeing that order!=0 -> drain_all_pages I wondered if that might differ even all calls look like they have zero
>>> b2) tracking the average amount of pages freed by try_to_free_pages for fast path and slow path (progres&!page)
>>>
>>> Naming convention (otherwise it might get confusing here)
>>> Good case - the scenario e.g. with e084b and 5f8dcc21 reverted resulting in high throughput and a low ratio of direct_reclaim running into progress&!page
>>> Bad case - the scenario e.g. on a clean 2.6.32
>>> Fast path - direct reclaim calls that did not run into progress&!page
>>> Slow path - direct reclaim calls that ran into progress&!page ending up in a long congestion_wait and therefore called "slow" path
>>>
>>> Mini summary of what we had before in huge tables:
>>>             fast path   slow path
>>> GOOD CASE      ~98%       ~1-3%
>>> BAD CASE       ~70%        ~30%
>>> -> leading to throughput impact of e.g. 600 mb/s with 16 iozone threads (worse with even more threads)
>>>
>>> Out of the numbers I got the following things might help us to create a new approach to a solution.
>>> The timings showed that that the so called slow case is actually much faster passing though direct_reclaim in bad case.
>>>
>>> GOOD CASE                                        duration
>>> a1 Fast-avg-duration_pre_ttf_2_post_ttf            164099
>>> a2 Fast-avg-duration_post_ttf_2_pre_get_page          459
>>> a3 Fast-avg-duration_pre_get_page_2_post_get_page     346
>>> a1 Slow-avg-duration_pre_ttf_2_post_ttf            127621
>>> a2 Slow-avg-duration_post_ttf_2_pre_get_page         1957
>>> a3 Slow-avg-duration_pre_get_page_2_post_get_page     256
>>> BAD CASE                                         duration   deviation to good case in %
>>> a1 Fast-avg-duration_pre_ttf_2_post_ttf            122921   -25.09%
>>> a2 Fast-avg-duration_post_ttf_2_pre_get_page          521   13.53%
>>> a3 Fast-avg-duration_pre_get_page_2_post_get_page     244   -29.55%
>>> a1 Slow-avg-duration_pre_ttf_2_post_ttf            109740   -14.01%
>>> a2 Slow-avg-duration_post_ttf_2_pre_get_page          250   -87.18%
>>> a3 Slow-avg-duration_pre_get_page_2_post_get_page     117   -54.16%
>>>
>>> That means that in the bad case the execution is much faster. Especially in the case that eventually runs into the slow path try_to_free is 14% faster, more important the time between try_to_free and get_pages is 87%! faster => less than a fifth and finally get_page is 54% faster, but that is probably just failing in an almost empty list which is fast^^.
>>>
>>> As I checked order which always was zero the time is not spent in drain_all_pages and the only other thing left might be cond_resched ?!
>>> Everything else are a few assignments so it can't be much else.
>>> But why would e.g. not running into schedule in cond_resched cause get_pages to not find anything - I don't know and I would expect it should be the other way around - the faster you get from free to get the more pages should be left.
>> THe reason here is probably the the fact that in the bad case a lot of  
>> processes are waiting on congestion_wait and are therefore not runnnable  
>> and that way not scheduled via cond_resched.
>>
>> I'll test this theory today or tomorrow with cond_resched in  
>> direct_reclaim commented out and expect almost no difference.
>>
>>> I thought the progress try_to_free_pages is doing might be important as well so I took numbers for that too.
>>> From those I see that the good case as well as the bad case has an average of 62 pages freed in fast path.
>>> But in slow path they start to differ - while the good case that is running only seldom in that path anyway frees an average of 1.46 pages (that might be the thing causing it not getting a page eventually) in the bad case it makes a progress of avg 37 pages even in slow path.
>>>
>>> PAGES-FREED  fast path   slow path
>>> GOOD CASE      ~62       ~1.46
>>> BAD CASE       ~62       ~37
>> 5f8dcc21 introduced per migrate type pcp lists, is it possible that we  
>> run in a scenario where try_to_free frees a lot of pages via, but of the  
>> wrong migrate type?
> 
> It's possible but the window is small. When a threshold is reached on the
> PCP lists, they get drained to the buddy lists and later picked up again
> by __rmqueue_fallback(). I had considered the possibility of pages of the
> wrong type being on the PCP lists which led to the patch "page-allocator:
> Fallback to other per-cpu lists when the target list is empty and memory is
> low" but you reported it made no difference even when fallback was allowed
> with high watermarks.
> [...]

Today I created rather huge debug logs - I'll spare everyone with too 
much detail.
Eventually it comes down to some kind of cat /proc/zoneinfo like output 
extended to list all things per migrate type too.

 From that I still think there should be plenty of pages to get the 
allocation through, as it was suggested by the high amount of pages 
freed by try_to_free.

Due to that I tried calling a second get_page_from_freelist after the 
first failing one and after the statistic output which showed me there 
wer enough pages available.
Even that second one failed - but this is good, that allows me to run 
that second call with a kind of "debugthis" parameter which I'll run 
tomorrow.

If anyone wants the full 6.2M of that data let me know, but I think the 
step by step debug of the second try will give us much smaller and 
better insights to discuss about.

More about that tomorrow,
Christian

P.S. Just one output of it here from a 16 thread read case:
### extended zoneinfo after failed direct reclaim ###
Progress just made in try_to_free         32
Current allocation order   0
Current allocation gfp_flags      201da GFP_COLD '1'
Current allocation migrate type '2'
Current cpu id          0
zone      DMA
zni:   pages_free                      503
         min                       508
         low                       635
         high                      762
         scanned                    96
         spanned                 65536
         present                 64640
     nr_free_pages                 503
     nr_inactive_anon             1536
     nr_active_anon               1480
     nr_inactive_file            33197
     nr_active_file               9492
     nr_unevictable               3016
     nr_mlock                     3016
     nr_anon_pages                5188
     nr_mapped                    2295
     nr_file_pages               43714
     nr_dirty                      206
     nr_writeback                    0
     nr_slab_reclaimable          2762
     nr_slab_unreclaimable        5368
     nr_page_table_pages           151
     nr_kernel_stack               215
     nr_unstable                     0
     nr_bounce                       0
     nr_vmscan_write               476
     nr_writeback_temp               0
     nr_isolated_anon                0
     nr_isolated_file               32
     nr_shmem                       62
         protection: (0,0,0)
Free areas:
Order  0 - nr_free        198 (matching        198 order 0 pages)
    MIGRATE_UNMOVABLE          198
    MIGRATE_RECLAIMABLE          0
d get_page_from_freelist fail
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  1 - nr_free          2 (matching          4 order 0 pages)
    MIGRATE_UNMOVABLE            1
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              1*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  2 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  3 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  4 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  5 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  6 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  7 - nr_free          0 (matching          0 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
    MIGRATE_RESERVE              0
    MIGRATE_ISOLATE              0
Order  8 - nr_free          1 (matching        256 order 0 pages)
    MIGRATE_UNMOVABLE            0
    MIGRATE_RECLAIMABLE          0
    MIGRATE_MOVABLE              0*
d get_page_from_freelist fail
    MIGRATE_RESERVE              1
    MIGRATE_ISOLATE              0
pagesets
     cpu:  0 (current cpu)
           count:         46
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             46*
           vm_stats_threshold:         16
     cpu:  1
           count:         77
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             77*
           vm_stats_threshold:         16
     cpu:  2
           count:         10
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             10*
           vm_stats_threshold:         16
     cpu:  3
           count:          8
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE              8*
           vm_stats_threshold:         16
     cpu:  4
           count:         11
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             11*
           vm_stats_threshold:         16
     cpu:  5
           count:         74
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             74*
           vm_stats_threshold:         16
     cpu:  6
           count:         65
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE             65*
           vm_stats_threshold:         16
     cpu:  7
           count:          0
           high:          90
           batch:         15
           MIGRATE_UNMOVABLE            0
           MIGRATE_RECLAIMABLE          0
           MIGRATE_MOVABLE              0*
           vm_stats_threshold:         16
   all_unreclaimable:          0
   prev_priority:             10
   start_pfn:                  0
   inactive_ratio:             1


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization
