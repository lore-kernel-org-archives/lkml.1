Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0BHOBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:01:31 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:47780 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0BHOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:01:29 -0500
Message-ID: <4B70192C.3070601@linux.vnet.ibm.com>
Date: Mon, 08 Feb 2010 15:01:16 +0100
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
References: <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie>
In-Reply-To: <20100205174917.GB11512@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Fri, Feb 05, 2010 at 04:51:10PM +0100, Christian Ehrhardt wrote:
>   
>> I'll keep the old thread below as reference.
>>
>> After taking a round of ensuring reproducibility and a pile of new  
>> measurements I now can come back with several new insights.
>>
>> FYI - I'm now running iozone triplets (4, then 8, then 16 parallel  
>> threads) with sequential read load and all that 4 times to find  
>> potential noise. But since I changed to that load instead of random read  
>> wit hone thread and ensuring the most memory is cleared (sync + echo 3 >  
>> /proc/sys/vm/drop_caches + a few sleeps) . The noise is now down <2%.  
>> For detailed questions about the setup feel free to ask me directly as I  
>> won't flood this thread too much with such details.
>>
>>     
>
> Is there any chance you have a driver script for the test that you could send
> me? I'll then try reproducing based on that script and see what happens. I'm
> not optimistic I'll be able to reproduce the problem because I think
> it's specific to your setup but you never know.
>   
I don't have one as it runs in a bigger automated test environment, but 
it is easy enough to write down something comparable.
>> So in the past I identified git id e084b for bringing a huge  
>> degradation, that is still true, but I need to revert my old statement  
>> that unapplying e084b on v2.6.32 helps - it simply doesn't.
>>
>>     
>
> Hmm, ok. Odd that it used to work but now doesn't.
>
> How reproducible are these results with patch e084b reverted? i.e. I know
> it does not work now, but did reverting on the old kernel always fix it
> or were there occasions where the figures would be still bad?
>   
Reverting e084b in the past showed something like +40%, so I thought it 
helps.
Afterwards I found out it wasn't a good testcase for reproducibility and 
when looking at a series it had +5%,-7%,+20%,...
So by far too noisy to be useful for bisect, discussion or fix testing.
Thats why I made my big round reinventing the testcases in a more 
reproducible way like described above.
In those the original issue is still very visible - which means 4 runs 
comparing 2.6.32 vs 2.6.32-Reve084b being each max +/-1%.
While gitid-e084b vs. the one just before (51fbb) gives ~-60% all the time.
>   
>> Another bisect (keepign e084b reverted) brought up git id 5f8dcc21 which  
>> came in later. Both patches unapplied individually don't improve  
>> anything. But both patches reverted at the same time on git v2.6.32  
>> bring us back to our old values (remember that is more than 2Gb/s  
>> improvement in throughput)!
>>
>> Unfortunately 5f8dcc21 is as unobvious as e84b in explaining how this  
>> can cause so much trouble.
>>     
>
> There is a bug in commit 5f8dcc21. One consequence of it is that swap-based
> workloads can suffer. A second is that users of high-order allocations can
> enter direct reclaim a lot more than previously. This was fixed in commit
> a7016235a61d520e6806f38129001d935c4b6661 but you say that's not the fix in
> your case. 
>
> The only other interesting thing in commit 5f8dcc21 is that it increases
> the memory overhead of a per-cpu structure. If your memory usage is really
> borderline, it might have been just enough to push it over the edge.
>   
I had this thoughts too, but as it only shows an effect with 5f8dcc21 
and e084b reverted at the same time I'm wondering if it can be that.
But I agree that this should be considered too until a verification can 
be done.
>   
>> In the past I identified congestion_wait as the point where the "time is  
>> lost" when comparing good and bad case. Fortunately at least this is  
>> still true when comparing 2.6.32 vs 2.6.32 with both patches reverted.
>> So I upgraded my old counter patches a bit and can now report the following:
>>
>> BAD CASE
>>                                                                4 THREAD  READ               8 THREAD READ               16 THREAD READ         16THR % portions
>> perf_count_congestion_wait                                        305                        1970                        8980
>> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                           0                           0
>> perf_count_call_congestion_wait_from_alloc_pages_slowpath         305                        1970                        8979                   100.00%
>> perf_count_pages_direct_reclaim                                  1153                        6818                        3221
>> perf_count_failed_pages_direct_reclaim                            305                        1556                        8979
>>     
>
> Something is wrong with the counters there. For 16 threads, it says direct
> reclaim was entered 3221 but it failed 8979 times. How does that work? The
> patch you supplied below looks like a patch on top of another debugging patch.
> Can you send the full debugging patch please?
>   
This is just a single 7 deleted accidentally when bringing it to a plain 
text format for this mail. The percentage is fine and properly it would 
look like:

                                                               4 THREAD  READ               8 THREAD READ               16 THREAD READ         16THR % portions

perf_count_congestion_wait                                        
305                        1970                         8980
perf_count_call_congestion_wait_from_alloc_pages_high_priority      
0                           0                            0
perf_count_call_congestion_wait_from_alloc_pages_slowpath         
305                        1970                         
8979               100.00%
perf_count_pages_direct_reclaim                                  
1153                        6818                        32217
perf_count_failed_pages_direct_reclaim                            
305                        1556                         8979
perf_count_failed_pages_direct_reclaim_but_progress               
305                        1478                         
8979               27.87%


There were three patches attached in the last mail which should work in 
this order:

~/kernels/linux-2.6$ git checkout -f v2.6.32
~/kernels/linux-2.6$ patch -p1 < 
~/Desktop/patches-git/perf-count-congestion-wait.diff
patching file include/linux/sysctl.h
patching file kernel/sysctl.c
patching file mm/backing-dev.c
~/kernels/linux-2.6$ patch -p1 < 
~/Desktop/patches-git/perf-count-failed-direct-recalims.diff
patching file kernel/sysctl.c
patching file mm/page_alloc.c
Hunk #1 succeeded at 1670 (offset 9 lines).
Hunk #2 succeeded at 1709 (offset 9 lines).
~/kernels/linux-2.6$ patch -p1 < 
~/Desktop/patches-git/perf-count-congestion-wait-calls.diff
patching file kernel/sysctl.c
patching file mm/page_alloc.c
Hunk #1 succeeded at 1672 (offset 9 lines).
Hunk #2 succeeded at 1714 (offset 9 lines).
Hunk #3 succeeded at 1738 (offset 9 lines).
Hunk #4 succeeded at 1796 (offset 9 lines).
Hunk #5 succeeded at 1913 (offset 9 lines).

Offsets are due to e084b/5f8dcc21 being reverted or not, it works in 
both cases.
Let me know if they work out for you that way.
>   
>> perf_count_failed_pages_direct_reclaim_but_progress               305                        1478                        8979                   27.87%
>>
>> GOOD CASE WITH REVERTS                                          4 THREAD  READ               8 THREAD READ               16 THREAD READ        16THR % portions
>> perf_count_congestion_wait                                         25                          76                         1114
>> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                           0                            0
>> perf_count_call_congestion_wait_from_alloc_pages_slowpath          25                          76                         1114               99.98%
>> perf_count_pages_direct_reclaim                                  1054                        9150                        62297
>> perf_count_failed_pages_direct_reclaim                             25                          64                         1114
>> perf_count_failed_pages_direct_reclaim_but_progress                25                          57                         1114                1.79%
>>
>>
>> I hope the format is kept, it should be good with every monospace viewer.
>>     
>
> It got manged but I think I've it fixed above. The biggest thing I can see
> is that direct reclaim is a lot more successful with the patches reverted but
> that in itself doesn't make sense. Neither patch affects how many pages should
> be free or reclaimable - just what order they are allocated and freed in.
>
> With botgh patches reverted, is the performance 100% reliable or does it
> sometimes vary?
>   
It is 100% percent reliable now - reliably bad with plain 2.6.32 as well 
as reliably much better (e.g. +40% @ 16threads) with both reverted.

> If reverting 5f8dcc21 is required, I'm leaning towards believing that the
> additional memory overhead with that patch is enough to push this workload
> over the edge where entering direct reclaim is necessary a lot more to keep
> the zones over the min watermark. You mentioned early on that adding 64MB
> to the machine makes the problem go away. Do you know what the cut-off point
> is? For example, is adding 4MB enough?
>   
That was another one probably only seen due to the lack of good 
reproducibility in my old setup.
I made bigger memory scaling tests with the new setup. Therefore I ran 
the workload with 160 to 356 megabytes in 32mb steps (256 is the default 
in all other runs).
The result is that more than 256m memory only brings a slight benefit 
(which is ok as the load doesn't reread the data read into page cache 
and it just doesn't need much more).

Here some data about scaling memory normalized to the 256m memory values:
- deviation to 256m case -                  160m    192m    224m    
256m    288m    320m    356m
plain 2.6.32                              +9.12% -55.11% -17.15%   
=100%  +1.46%  +1.46%  +1.46%
2.6.32 - 5f8dcc21 and e084b reverted      +6.95%  -6.95%  -0.80%   
=100%  +2.14%  +2.67%  +2.67%
------------------------------------------------------------------------------------------------
deviation between each other (all +)      60.64% 182.93%  63.44%  
36.50%  37.41%  38.13%  38.13%
What can be seen:
a) more memory brings up to +2.67%/+1.46%, but not more when further 
increasing memory (reasonable as we don't reread cached files)
b) decreasing memory drops performance by up to -6.95% @ -64mb with both 
reverted, but down to -55% @ -64mb (compared to the already much lower 
256m throughput)
   -> plain 2.6.32 is much more sensible to lower available memory AND 
always a level below
c) there is a weird but very reproducible improvement with even lower 
memory - very probably another issue or better another solution and not 
related here - but who knows :-)
   -> still both reverted is always much better than plain 2.6.32

> If a small amount of memory does help, I'd also test with min_free_kbytes
> at a lower value? If reducing it restores the performance, it again implies
> that memory usage is the real problem.
>   

I'll run a few tests with bigger/smaller numbers of min_free_kbytes just 
to be sure.
> Thing is, even if adding small amounts of memory or reducing
> min_free_kbytes helps, it does not explain why e084b ever made a
> difference because all that patch does is alter the ordering of pages on
> the free list. That might have some cache consequences but it would not
> impact direct reclaim like this.
>
>   
>> You can all clearly see that the patches somehow affect the ratio at  
>> which __alloc_pages_direct_reclaim runs into a race between try_to_free  
>> pages that could actually free something, but a few lines below can't  
>> get a page from the free list.
>>     
>
> There actually is potentially a significant delay from when direct
> reclaim returns and a new allocation attempt happens. However, it's been
> like this for a long time so I don't think it's the issue.
>   
Due to the increased percentage of progress, but !page in direct_reclaim 
I still think it is related.
I agree that "having" that potential race between try_to_free and 
get_page is not the issue, but I assume it is very likely that the 
patches change the timing there so that it happens much more often.
> I have a prototype patch that removes usage of congestion_wait() altogether
> and puts processes to sleep on a waitqueue waiting for watermarks to restore
> or a timeout. However, I think it would be just treating the symptoms here
> rather than the real issue.
>   
Anyway I'd be happy to test this patch if you could sent it to me, 
because as long as we don't have a "real" solution I like such 
symptom-fixes as a start :-)
At least it would fix going into congestion_wait even without dirty 
pages or I/O's in flight - waiting for watermarks sounds much better to 
me independent to the current issue.
>> Outside in the function alloc_pages_slowpath this leads to a call to  
>> congestion_wait which is absolutely futile as there are absolutely no  
>> writes in flight to wait for.
>>
>> Now this kills effectively up to 80% of our throughput - Any idea of  
>> better understanding the link between the patches and the effect is  
>> welcome and might lead to a solution.
>>
>> FYI - I tried all patches you suggested - none of them affects this.
>>
>>     
>
> I'm still at a total loss to explain this. Memory overhead of the second
> patch is a vague possibility and worth checking out by slightly increasing
> available memory on the partition or reducing min_free_kbytes. It does not
> explain why the first patch makes a difference.
>   
In a discussion with Hannes Reinecke (hare@suse.de) he brought up that 
in a low memory scenario the ordering of the pages might twist.
Today we have the single linst of pages - add hot ones to the head and 
cold to the tail. Both patches affect that list management - e084b 
changes the order of some, and 5f8dcc is splitting it per migrate type.
What now could happen is that you free pages and get a list like:
H1 - H2 - H3 - C3 - C2 - C1 (H is hot and C is cold)
In low mem scenarios it could now happen that a allocation for hot pages 
falls back to cold pages (as usual fallback), but couldnt it be that it 
then also gets the cold pages in reverse order again ?
Without e084b it would be like:
H1 - H2 - H3 - C1 - C2 - C3 and therefore all at least in order (with 
the issue that cold allocations from the right are reverse -> e084b)
5f8dcc is now lowering the size of those lists by splitting it into 
different migration types, so maybe both together are increasing the 
chance to get such an issue.

I hope I explained that idea right, Hannes please feel free to correct 
and extend if needed.
I also added Nick on his request.
>> <SNIP>
>>     
>
>   

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

