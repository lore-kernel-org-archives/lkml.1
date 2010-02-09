Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0BIPw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:52:29 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:34722 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0BIPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:52:27 -0500
Message-ID: <4B7184B5.6040400@linux.vnet.ibm.com>
Date: Tue, 09 Feb 2010 16:52:21 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, npiggin@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie>
In-Reply-To: <20100208152131.GC23680@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Mon, Feb 08, 2010 at 03:01:16PM +0100, Christian Ehrhardt wrote:
>>
>> Mel Gorman wrote:
>>> On Fri, Feb 05, 2010 at 04:51:10PM +0100, Christian Ehrhardt wrote:
>>>   

[...]

>>> How reproducible are these results with patch e084b reverted? i.e. I know
>>> it does not work now, but did reverting on the old kernel always fix it
>>> or were there occasions where the figures would be still bad?
>>>   
>> Reverting e084b in the past showed something like +40%, so I thought it  
>> helps.
>> Afterwards I found out it wasn't a good testcase for reproducibility and  
>> when looking at a series it had +5%,-7%,+20%,...
>> So by far too noisy to be useful for bisect, discussion or fix testing.
>> Thats why I made my big round reinventing the testcases in a more  
>> reproducible way like described above.
>> In those the original issue is still very visible - which means 4 runs  
>> comparing 2.6.32 vs 2.6.32-Reve084b being each max +/-1%.
>> While gitid-e084b vs. the one just before (51fbb) gives ~-60% all the time.
> 
> About all e084b can be affecting is cache hotness when fallback is occuring
> but 60% regression still seems way too high for just that.

Yes, most the ideas you, I an a few others so far had went for cache hotness - but always the summary was "couldn't be that much".

On the other hand we have to consider that it could be a small timing due to cache or whatever else which leads into congestion_wait and then it waits HZ/50. That way a 1µs cause can lead to 20001µs lost which then cause 60%.
Another important thing is that "cold page" afaik means the page content, and not the management struct etc. As the time lost is in management only (=> before accessing the actual 4k page content) it should not be important if a page is cold/hot for the mm code itself.
That much for direct_reclaim that either runs into progress, but !page (BAD case) or not (GOOD case) - there only cache effects of struct page, pcp lists etc should have an effect.

>>>> Another bisect (keepign e084b reverted) brought up git id 5f8dcc21 
>>>> which  came in later. Both patches unapplied individually don't 
>>>> improve  anything. But both patches reverted at the same time on git 
>>>> v2.6.32  bring us back to our old values (remember that is more than 
>>>> 2Gb/s  improvement in throughput)!
>>>>
>>>> Unfortunately 5f8dcc21 is as unobvious as e84b in explaining how this 
>>>>  can cause so much trouble.
>>>>     
>>> There is a bug in commit 5f8dcc21. One consequence of it is that swap-based
>>> workloads can suffer. A second is that users of high-order allocations can
>>> enter direct reclaim a lot more than previously. This was fixed in commit
>>> a7016235a61d520e6806f38129001d935c4b6661 but you say that's not the fix in
>>> your case. 
>>>
>>> The only other interesting thing in commit 5f8dcc21 is that it increases
>>> the memory overhead of a per-cpu structure. If your memory usage is really
>>> borderline, it might have been just enough to push it over the edge.
>>>   
>> I had this thoughts too, but as it only shows an effect with 5f8dcc21  
>> and e084b reverted at the same time I'm wondering if it can be that.
>> But I agree that this should be considered too until a verification can  
>> be done.
>>>   
> 
> Another consequence of 5f8dcc is that pages are on the per-cpu lists that
> it is possible for pages to be on the per-cpu lists when the page allocator
> is called. There is potential that page reclaim is being entered as a
> result even though pages were free on the per-cpu lists.
> 
> It would not explain why reverting e084b makes such a difference but I
> can prototype a patch that falls back to other per-cpu lists before
> calling the page allocator as it used to do but without linear searching
> the per-cpu lists.

I tested these patch you submitted in another reply.
Short - it only gives it ~+4% by probably speeding up things a bit but not touching the issue in any way.
Some more detail below at the other test result.

[...]

>>
>>                                                               4 THREAD  READ               8 THREAD READ               16 THREAD READ         16THR % portions
>>
>> perf_count_congestion_wait                                        305                               1970                         8980
>> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                                  0                            0
>> perf_count_call_congestion_wait_from_alloc_pages_slowpath         305                               1970                         8979               100.00%
>> perf_count_pages_direct_reclaim                                  1153                               6818                        32217
>> perf_count_failed_pages_direct_reclaim                            305                               1556                         8979
>> perf_count_failed_pages_direct_reclaim_but_progress               305                               1478                         8979               27.87%
>>
[...]
>>>   
>>>> perf_count_failed_pages_direct_reclaim_but_progress               305                        1478                        8979                   27.87%
>>>>
>>>> GOOD CASE WITH REVERTS                                          4 THREAD  READ               8 THREAD READ               16 THREAD READ        16THR % portions
>>>> perf_count_congestion_wait                                         25                          76                         1114
>>>> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                           0                            0
>>>> perf_count_call_congestion_wait_from_alloc_pages_slowpath          25                          76                         1114               99.98%
>>>> perf_count_pages_direct_reclaim                                  1054                        9150                        62297
>>>> perf_count_failed_pages_direct_reclaim                             25                          64                         1114
>>>> perf_count_failed_pages_direct_reclaim_but_progress                25                          57                         1114                1.79%
>>>>
>>>>
>>>> I hope the format is kept, it should be good with every monospace viewer.
>>>>     
>>> It got manged but I think I've it fixed above. The biggest thing I can see
>>> is that direct reclaim is a lot more successful with the patches reverted but
>>> that in itself doesn't make sense. Neither patch affects how many pages should
>>> be free or reclaimable - just what order they are allocated and freed in.
>>>
>>> With botgh patches reverted, is the performance 100% reliable or does it
>>> sometimes vary?
>>>   
>> It is 100% percent reliable now - reliably bad with plain 2.6.32 as well  
>> as reliably much better (e.g. +40% @ 16threads) with both reverted.
>>
> 
> Ok.
> 
>>> If reverting 5f8dcc21 is required, I'm leaning towards believing that the
>>> additional memory overhead with that patch is enough to push this workload
>>> over the edge where entering direct reclaim is necessary a lot more to keep
>>> the zones over the min watermark. You mentioned early on that adding 64MB
>>> to the machine makes the problem go away. Do you know what the cut-off point
>>> is? For example, is adding 4MB enough?
>>>   
>> That was another one probably only seen due to the lack of good  
>> reproducibility in my old setup.
> 
> Ok.
> 
>> I made bigger memory scaling tests with the new setup. Therefore I ran  
>> the workload with 160 to 356 megabytes in 32mb steps (256 is the default  
>> in all other runs).
>> The result is that more than 256m memory only brings a slight benefit  
>> (which is ok as the load doesn't reread the data read into page cache  
>> and it just doesn't need much more).
>>
>> Here some data about scaling memory normalized to the 256m memory values:
>> - deviation to 256m case -                  160m    192m    224m    256m     288m    320m    356m
>> plain 2.6.32                              +9.12% -55.11% -17.15%   =100%   +1.46%  +1.46%  +1.46%
>> 2.6.32 - 5f8dcc21 and e084b reverted      +6.95%  -6.95%  -0.80%   =100%   +2.14%  +2.67%  +2.67%
>> ------------------------------------------------------------------------------------------------
>> deviation between each other (all +)      60.64% 182.93%  63.44%  36.50%   37.41%  38.13%  38.13%
>> What can be seen:
>> a) more memory brings up to +2.67%/+1.46%, but not more when further  
>> increasing memory (reasonable as we don't reread cached files)
>> b) decreasing memory drops performance by up to -6.95% @ -64mb with both  
>> reverted, but down to -55% @ -64mb (compared to the already much lower  
>> 256m throughput)
>>   -> plain 2.6.32 is much more sensible to lower available memory AND  
>> always a level below
>> c) there is a weird but very reproducible improvement with even lower  
>> memory - very probably another issue or better another solution and not  
>> related here - but who knows :-)
>>   -> still both reverted is always much better than plain 2.6.32
>>
> 
> Ok. Two avenues of attack then although both are focused on 5f8dcc21.
> The first is the prototype below that should avoid congestion_wait. The
> second is to reintroduce a fallback to other per-cpu lists and see if
> that was a big factor.

I tested both of your patches, btw thanks for the quick work!


[...]

> 
> Hmm, the patch as it currently stands is below. However, I warn you that
> it has only been boot-tested on qemu with no proper testing doing, either
> functional or performance testing. It may just go mad, drink your beer and
> chew on your dog.

In opposition to all your warnings it worked pretty well.
The patch replacing congestion_wait calls - which we know re futile in my scenario
anyway - by zone_wait calls helps a lot. But so far as you suggested only by alleviating the symptoms.

>From a throughput perspective alone it looks almost fixed:
                                                    4 thread      8 thread    16 thread
plain 2.6.32                                        100%          100%        100%
2.6.32 avoid direct reclaim                         103.85%       103.60%     104.04%
2.6.32 zone wait                                    125.46%       140.87%     131.89%
2.6.32 zone wait + 5f8dcc21 and e084b reverted      124.46%       143.35%     144.21%

Looking at the counters this theory (only fixing symptoms) seems to be confirmed. Before the ratio of perf_count_pages_direct_reclaim calls that ended in perf_count_failed_pages_direct_reclaim_but_progress was ~2% in the good cases and ~30% in bad cases. As congestion_wait in my case almost always waits the full HZ/50 this is a lot.
With the zone wait patch I see a huge throughput win, most probably by all the (still ~30%!) waits that don't have to wait for the full timeout.
But still reverting 5f8dcc21 and e084b fix the issue of so much direct reclaims running in into that condition and that way giving throughput another last push.

                                                      % ran into try_to_free did progress but get_page got !page
plain 2.6.32                                          30.16%
2.6.32 zone wait                                      29.05%
2.6.32 zone wait + 5f8dcc21 and e084b reverted        2.93%

Note - with the zone wait patch there are also almost twice as much direct_reclaim calls. Probably by several waiters coming of the list when the watermark is restored and allocating too much.

Another good side note - 5f8dcc21 and e084b reverted plus your zone wait patch is better than anything I have seen so far :-)
Maybe its worth to measure  both of your patches plus 5f8dcc21 and e084b reverted with 64 threads (the effect grows with # threads) just to rejoice in huge throughput values for a short time.

>>>> Outside in the function alloc_pages_slowpath this leads to a call to  
>>>> congestion_wait which is absolutely futile as there are absolutely no 
>>>>  writes in flight to wait for.
>>>>
>>>> Now this kills effectively up to 80% of our throughput - Any idea of  
>>>> better understanding the link between the patches and the effect is   
>>>> welcome and might lead to a solution.
>>>>
>>>> FYI - I tried all patches you suggested - none of them affects this.
>>>>
>>>>     
>>> I'm still at a total loss to explain this. Memory overhead of the second
>>> patch is a vague possibility and worth checking out by slightly increasing
>>> available memory on the partition or reducing min_free_kbytes. It does not
>>> explain why the first patch makes a difference.
>>>   
>> In a discussion with Hannes Reinecke (hare@suse.de) he brought up that  
>> in a low memory scenario the ordering of the pages might twist.
>> Today we have the single linst of pages - add hot ones to the head and  
>> cold to the tail. Both patches affect that list management - e084b  
>> changes the order of some, and 5f8dcc is splitting it per migrate type.
> 
> Correct on both counts.
> 
>> What now could happen is that you free pages and get a list like:
>> H1 - H2 - H3 - C3 - C2 - C1 (H is hot and C is cold)
>> In low mem scenarios it could now happen that a allocation for hot pages  
>> falls back to cold pages (as usual fallback), but couldnt it be that it  
>> then also gets the cold pages in reverse order again ?
> 
> Yes, this is true but that would only matter from a cache perspective
> as you say your hardware and drivers are doing no automatic merging of
> requests.
> 
>> Without e084b it would be like:
>> H1 - H2 - H3 - C1 - C2 - C3 and therefore all at least in order (with  
>> the issue that cold allocations from the right are reverse -> e084b)
>> 5f8dcc is now lowering the size of those lists by splitting it into  
>> different migration types, so maybe both together are increasing the  
>> chance to get such an issue.
>>
> 
> There is a good chance that 5f8dcc is causing direct reclaim to be entered
> when it could have been avoided as pages were on the per-cpu lists but
> I don't think the difference in cache hotness is enough to explain a 60%
> loss on your machine.
> 

As far as I get it thats what your patch #2 fixed (page allocator: Fallback to other per-cpu lists when the target list is empty and memory is low), but as mentioned below that gave me +4%.
Which is actually a fine win, but not for the issue currently in discussion.
As bonus I can give you now a little tested-by for both patches :-)

[...]


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 
