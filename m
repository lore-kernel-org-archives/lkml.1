Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab0BERtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:49:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47355 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab0BERtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:49:31 -0500
Date: Fri, 5 Feb 2010 17:49:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100205174917.GB11512@csn.ul.ie>
References: <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B6C3E6E.6050303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:51:10PM +0100, Christian Ehrhardt wrote:
> I'll keep the old thread below as reference.
>
> After taking a round of ensuring reproducibility and a pile of new  
> measurements I now can come back with several new insights.
>
> FYI - I'm now running iozone triplets (4, then 8, then 16 parallel  
> threads) with sequential read load and all that 4 times to find  
> potential noise. But since I changed to that load instead of random read  
> wit hone thread and ensuring the most memory is cleared (sync + echo 3 >  
> /proc/sys/vm/drop_caches + a few sleeps) . The noise is now down <2%.  
> For detailed questions about the setup feel free to ask me directly as I  
> won't flood this thread too much with such details.
> 

Is there any chance you have a driver script for the test that you could send
me? I'll then try reproducing based on that script and see what happens. I'm
not optimistic I'll be able to reproduce the problem because I think
it's specific to your setup but you never know.

> So in the past I identified git id e084b for bringing a huge  
> degradation, that is still true, but I need to revert my old statement  
> that unapplying e084b on v2.6.32 helps - it simply doesn't.
>

Hmm, ok. Odd that it used to work but now doesn't.

How reproducible are these results with patch e084b reverted? i.e. I know
it does not work now, but did reverting on the old kernel always fix it
or were there occasions where the figures would be still bad?

> Another bisect (keepign e084b reverted) brought up git id 5f8dcc21 which  
> came in later. Both patches unapplied individually don't improve  
> anything. But both patches reverted at the same time on git v2.6.32  
> bring us back to our old values (remember that is more than 2Gb/s  
> improvement in throughput)!
>
> Unfortunately 5f8dcc21 is as unobvious as e84b in explaining how this  
> can cause so much trouble.
>

There is a bug in commit 5f8dcc21. One consequence of it is that swap-based
workloads can suffer. A second is that users of high-order allocations can
enter direct reclaim a lot more than previously. This was fixed in commit
a7016235a61d520e6806f38129001d935c4b6661 but you say that's not the fix in
your case. 

The only other interesting thing in commit 5f8dcc21 is that it increases
the memory overhead of a per-cpu structure. If your memory usage is really
borderline, it might have been just enough to push it over the edge.

> In the past I identified congestion_wait as the point where the "time is  
> lost" when comparing good and bad case. Fortunately at least this is  
> still true when comparing 2.6.32 vs 2.6.32 with both patches reverted.
> So I upgraded my old counter patches a bit and can now report the following:
>
> BAD CASE
>                                                                4 THREAD  READ               8 THREAD READ               16 THREAD READ         16THR % portions
> perf_count_congestion_wait                                        305                        1970                        8980
> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                           0                           0
> perf_count_call_congestion_wait_from_alloc_pages_slowpath         305                        1970                        8979                   100.00%
> perf_count_pages_direct_reclaim                                  1153                        6818                        3221
> perf_count_failed_pages_direct_reclaim                            305                        1556                        8979

Something is wrong with the counters there. For 16 threads, it says direct
reclaim was entered 3221 but it failed 8979 times. How does that work? The
patch you supplied below looks like a patch on top of another debugging patch.
Can you send the full debugging patch please?

> perf_count_failed_pages_direct_reclaim_but_progress               305                        1478                        8979                   27.87%
>
> GOOD CASE WITH REVERTS                                          4 THREAD  READ               8 THREAD READ               16 THREAD READ        16THR % portions
> perf_count_congestion_wait                                         25                          76                         1114
> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0                           0                            0
> perf_count_call_congestion_wait_from_alloc_pages_slowpath          25                          76                         1114               99.98%
> perf_count_pages_direct_reclaim                                  1054                        9150                        62297
> perf_count_failed_pages_direct_reclaim                             25                          64                         1114
> perf_count_failed_pages_direct_reclaim_but_progress                25                          57                         1114                1.79%
>
>
> I hope the format is kept, it should be good with every monospace viewer.

It got manged but I think I've it fixed above. The biggest thing I can see
is that direct reclaim is a lot more successful with the patches reverted but
that in itself doesn't make sense. Neither patch affects how many pages should
be free or reclaimable - just what order they are allocated and freed in.

With botgh patches reverted, is the performance 100% reliable or does it
sometimes vary?

If reverting 5f8dcc21 is required, I'm leaning towards believing that the
additional memory overhead with that patch is enough to push this workload
over the edge where entering direct reclaim is necessary a lot more to keep
the zones over the min watermark. You mentioned early on that adding 64MB
to the machine makes the problem go away. Do you know what the cut-off point
is? For example, is adding 4MB enough?

If a small amount of memory does help, I'd also test with min_free_kbytes
at a lower value? If reducing it restores the performance, it again implies
that memory usage is the real problem.

Thing is, even if adding small amounts of memory or reducing
min_free_kbytes helps, it does not explain why e084b ever made a
difference because all that patch does is alter the ordering of pages on
the free list. That might have some cache consequences but it would not
impact direct reclaim like this.

> You can all clearly see that the patches somehow affect the ratio at  
> which __alloc_pages_direct_reclaim runs into a race between try_to_free  
> pages that could actually free something, but a few lines below can't  
> get a page from the free list.

There actually is potentially a significant delay from when direct
reclaim returns and a new allocation attempt happens. However, it's been
like this for a long time so I don't think it's the issue.

I have a prototype patch that removes usage of congestion_wait() altogether
and puts processes to sleep on a waitqueue waiting for watermarks to restore
or a timeout. However, I think it would be just treating the symptoms here
rather than the real issue.

> Outside in the function alloc_pages_slowpath this leads to a call to  
> congestion_wait which is absolutely futile as there are absolutely no  
> writes in flight to wait for.
>
> Now this kills effectively up to 80% of our throughput - Any idea of  
> better understanding the link between the patches and the effect is  
> welcome and might lead to a solution.
>
> FYI - I tried all patches you suggested - none of them affects this.
>

I'm still at a total loss to explain this. Memory overhead of the second
patch is a vague possibility and worth checking out by slightly increasing
available memory on the partition or reducing min_free_kbytes. It does not
explain why the first patch makes a difference.

> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
