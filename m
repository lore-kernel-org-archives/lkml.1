Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172Ab0BQKDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:03:55 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41073 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab0BQKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:03:53 -0500
Message-ID: <4B7BBF03.1030102@linux.vnet.ibm.com>
Date: Wed, 17 Feb 2010 11:03:47 +0100
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
References: <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com> <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com>
In-Reply-To: <4B7BBCFC.4090101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christian Ehrhardt wrote:
> Christian Ehrhardt wrote:
>> Mel Gorman wrote:
>>> On Mon, Feb 15, 2010 at 04:46:53PM +0100, Christian Ehrhardt wrote:
>> [...]
>>>> The differences in asm are pretty much the same, as before 
>>>> rmqueue_bulk was already inlined the actually intended change to its 
>>>> parameters was negligible.
>>>> I wondered if it would be important if that is a constant value (-1) 
>>>> or if the reason was caused by that shift. So I tried:
>>>>
>>>>  23 @@ -965,7 +965,7 @@
>>>>  24                 set_page_private(page, migratetype);
>>>>  25                 list = &page->lru;
>>>>  26         }
>>>>  27 -       __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
>>>>  28 +       __mod_zone_page_state(zone, NR_FREE_PAGES, -i);
>>>>  29         spin_unlock(&zone->lock);
>>>>  30         return i;
>>>>  31  }
>>>>
>> [...]
>>> It "fixes" it only by not calling direct reclaim when it should :(
>>
>> yeah as we both realized -1 was not right so it was more a crazy 
>> workaround :-)
>>
>> Anyway after that being a dead end again I dug even deeper into the 
>> details of direct_reclaim - I think we can agree that out of the 
>> counters we already know the race between try_to_free making progress 
>> and get_page not getting a page causing the congestion_wait is source 
>> of the issue.
>>
>> So what I tried to bring some more light into all that was extending 
>> my perf counters to track a few more details in direct_reclaim.
>> Two patches are attached and apply after the other three already 
>> available in that thread.
>> The intention is
>> a) to track the time
>>  a1) spent in try_to_free_pages
>>  a2) consumed after try_to_free_pages until get_page_from_freelist
>>  a3) spent in get_pages_from_freelist
>> b1) after seeing that order!=0 -> drain_all_pages I wondered if that 
>> might differ even all calls look like they have zero
>> b2) tracking the average amount of pages freed by try_to_free_pages 
>> for fast path and slow path (progres&!page)
>>
>> Naming convention (otherwise it might get confusing here)
>> Good case - the scenario e.g. with e084b and 5f8dcc21 reverted 
>> resulting in high throughput and a low ratio of direct_reclaim running 
>> into progress&!page
>> Bad case - the scenario e.g. on a clean 2.6.32
>> Fast path - direct reclaim calls that did not run into progress&!page
>> Slow path - direct reclaim calls that ran into progress&!page ending 
>> up in a long congestion_wait and therefore called "slow" path
>>
>> Mini summary of what we had before in huge tables:
>>             fast path   slow path
>> GOOD CASE      ~98%       ~1-3%
>> BAD CASE       ~70%        ~30%
>> -> leading to throughput impact of e.g. 600 mb/s with 16 iozone 
>> threads (worse with even more threads)
>>
>> Out of the numbers I got the following things might help us to create 
>> a new approach to a solution.
>> The timings showed that that the so called slow case is actually much 
>> faster passing though direct_reclaim in bad case.
>>
>> GOOD CASE                                        duration
>> a1 Fast-avg-duration_pre_ttf_2_post_ttf            164099
>> a2 Fast-avg-duration_post_ttf_2_pre_get_page          459
>> a3 Fast-avg-duration_pre_get_page_2_post_get_page     346
>> a1 Slow-avg-duration_pre_ttf_2_post_ttf            127621
>> a2 Slow-avg-duration_post_ttf_2_pre_get_page         1957
>> a3 Slow-avg-duration_pre_get_page_2_post_get_page     256
>> BAD CASE                                         duration   deviation 
>> to good case in %
>> a1 Fast-avg-duration_pre_ttf_2_post_ttf            122921   -25.09%
>> a2 Fast-avg-duration_post_ttf_2_pre_get_page          521   13.53%
>> a3 Fast-avg-duration_pre_get_page_2_post_get_page     244   -29.55%
>> a1 Slow-avg-duration_pre_ttf_2_post_ttf            109740   -14.01%
>> a2 Slow-avg-duration_post_ttf_2_pre_get_page          250   -87.18%
>> a3 Slow-avg-duration_pre_get_page_2_post_get_page     117   -54.16%
>>
>> That means that in the bad case the execution is much faster. 
>> Especially in the case that eventually runs into the slow path 
>> try_to_free is 14% faster, more important the time between try_to_free 
>> and get_pages is 87%! faster => less than a fifth and finally get_page 
>> is 54% faster, but that is probably just failing in an almost empty 
>> list which is fast^^.
>>
>> As I checked order which always was zero the time is not spent in 
>> drain_all_pages and the only other thing left might be cond_resched ?!
>> Everything else are a few assignments so it can't be much else.
>> But why would e.g. not running into schedule in cond_resched cause 
>> get_pages to not find anything - I don't know and I would expect it 
>> should be the other way around - the faster you get from free to get 
>> the more pages should be left.
> 
> THe reason here is probably the the fact that in the bad case a lot of 
> processes are waiting on congestion_wait and are therefore not runnnable 
> and that way not scheduled via cond_resched.
> 
> I'll test this theory today or tomorrow with cond_resched in 
> direct_reclaim commented out and expect almost no difference.
> 
>> I thought the progress try_to_free_pages is doing might be important 
>> as well so I took numbers for that too.
>> From those I see that the good case as well as the bad case has an 
>> average of 62 pages freed in fast path.
>> But in slow path they start to differ - while the good case that is 
>> running only seldom in that path anyway frees an average of 1.46 pages 
>> (that might be the thing causing it not getting a page eventually) in 
>> the bad case it makes a progress of avg 37 pages even in slow path.
>>
>> PAGES-FREED  fast path   slow path
>> GOOD CASE      ~62       ~1.46
>> BAD CASE       ~62       ~37
> 
> 5f8dcc21 introduced per migrate type pcp lists, is it possible that we 
> run in a scenario where try_to_free frees a lot of pages via, but of the 
> wrong migrate type?
> And afterwards get_page
> At least try_to_free_page and it's called shrink_ functions is not 
> migrate type aware while get_page and its subsequent buffered_rmqueue 
> and rmqueue_bulk are - btw here comes patch e084b.
> 
> I only see buffered_rmqueue chose a specific pcp list based on migrate 
> type, and a fallback to migrate_reserve - is that enough fallback, what 
> if the reserve is empty too but a few other types would not and those 
> other types are the ones filled by try_to_free?

I just saw the full type iteration in __rmqueue_fallback, but still 
somewhere the average of 37 freed pages need to go so that get_page 
doesn't get one.

> I'll try to get a per migrate type #pages statistic after direct_reclaim 
> reaches !page - maybe that can confirm some parts of my theory.

This might be still worth a try.

>> Thinking of it as asking "how few pages do I have to free until I fall 
>> from fast to slow path" the kernels behave different it looks wrong 
>> but interesting.
>> The good case only drops to slow path (!page) in case of ~1.46 pages 
>> freed while the bad case seems to enter that much earlier with even 37 
>> pages freed.
>>
>> As order is always 0 and get_page afaik about getting just "one" page 
>> I wonder where these 37 pages disappeared especially as in bad case it 
>> is much faster getting to get_pages after freeing those ~37 pages.
>>
>> Comments and ideas welcome!
>>
>>
> 

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization
