Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0BEPvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:51:23 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37664 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0BEPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:51:17 -0500
Message-ID: <4B6C3E6E.6050303@linux.vnet.ibm.com>
Date: Fri, 05 Feb 2010 16:51:10 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie>
In-Reply-To: <20100119113306.GA23881@csn.ul.ie>
Content-Type: multipart/mixed;
 boundary="------------000800050901060404040205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000800050901060404040205
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

I'll keep the old thread below as reference.

After taking a round of ensuring reproducibility and a pile of new 
measurements I now can come back with several new insights.

FYI - I'm now running iozone triplets (4, then 8, then 16 parallel 
threads) with sequential read load and all that 4 times to find 
potential noise. But since I changed to that load instead of random read 
wit hone thread and ensuring the most memory is cleared (sync + echo 3 > 
/proc/sys/vm/drop_caches + a few sleeps) . The noise is now down <2%. 
For detailed questions about the setup feel free to ask me directly as I 
won't flood this thread too much with such details.

So in the past I identified git id e084b for bringing a huge 
degradation, that is still true, but I need to revert my old statement 
that unapplying e084b on v2.6.32 helps - it simply doesn't.

Another bisect (keepign e084b reverted) brought up git id 5f8dcc21 which 
came in later. Both patches unapplied individually don't improve 
anything. But both patches reverted at the same time on git v2.6.32 
bring us back to our old values (remember that is more than 2Gb/s 
improvement in throughput)!

Unfortunately 5f8dcc21 is as unobvious as e84b in explaining how this 
can cause so much trouble.

In the past I identified congestion_wait as the point where the "time is 
lost" when comparing good and bad case. Fortunately at least this is 
still true when comparing 2.6.32 vs 2.6.32 with both patches reverted.
So I upgraded my old counter patches a bit and can now report the following:

BAD CASE
                                                                4 THREAD 
READ               8 THREAD READ               16 THREAD READ       
16THR % portions
perf_count_congestion_wait                                        
305                        1970                        8980
perf_count_call_congestion_wait_from_alloc_pages_high_priority      
0                           0                           0
perf_count_call_congestion_wait_from_alloc_pages_slowpath         
305                        1970                        
8979                100.00%
perf_count_pages_direct_reclaim                                  
1153                        6818                        3221
perf_count_failed_pages_direct_reclaim                            
305                        1556                        8979
perf_count_failed_pages_direct_reclaim_but_progress               
305                        1478                        
8979                27.87%

GOOD CASE WITH REVERTS                                          4 THREAD 
READ               8 THREAD READ               16 THREAD READ       
16THR % portions
perf_count_congestion_wait                                         
25                          76                         1114
perf_count_call_congestion_wait_from_alloc_pages_high_priority      
0                           0                            0
perf_count_call_congestion_wait_from_alloc_pages_slowpath          
25                          76                         
1114               99.98%
perf_count_pages_direct_reclaim                                  
1054                        9150                        62297
perf_count_failed_pages_direct_reclaim                             
25                          64                         1114
perf_count_failed_pages_direct_reclaim_but_progress                
25                          57                         
1114                1.79%


I hope the format is kept, it should be good with every monospace viewer.
You can all clearly see that the patches somehow affect the ratio at 
which __alloc_pages_direct_reclaim runs into a race between try_to_free 
pages that could actually free something, but a few lines below can't 
get a page from the free list.
Outside in the function alloc_pages_slowpath this leads to a call to 
congestion_wait which is absolutely futile as there are absolutely no 
writes in flight to wait for.

Now this kills effectively up to 80% of our throughput - Any idea of 
better understanding the link between the patches and the effect is 
welcome and might lead to a solution.

FYI - I tried all patches you suggested - none of them affects this.

Updated perf counter patches are attached.
As for some questions in the old thread:

>> Back to business :-)
>> First - yes it is reproducible in 2.6.32 final and fixable by unapplying  
>> e084b.
>> But I don't think un-applying it is really a fix as no one really  
>> understands how e084b cause this regression (it might just work around  
>> whatever goes on in the background and someone still hits the hidden 
>> issue).
>>
>>     
>
> Agreed on reverting is not an option. While it is not understood why it
> causes your regression, it's known to fix a regression for hardware that
> does do merging.
>   

I'm not taking this point but fairly compared it is +15% vs -80% - so it 
is not "only" good :-)

>> Lets better look what we know summarized:
>> - the patch e084a causes this regression
>> - it causes it only in very rare if not theoretically high memory  
>> constraints
>> - time is lost between read system call and the block device layer enter
>> - via debugging and discussion we found that time lost is spent in  
>> congestion_wait
>>
>>     
>
> Thanks for the summary.
>
> There is an outside chance it's due to a difference in free page availablity
> and the associated counters. Particularly if some subsystem is optimistally
> trying high-order allocations depending on availability. If there are many
> allocation failures, the counters gets skewed due to a bug, watermarks are
> not met and direct reclaim is used more. A patch is on its way upstream to
> fix this is http://www.spinics.net/lists/mm-commits/msg75671.html . Can you
> try it please?
>
> There is a report on swap-based workloads being impacted on 2.6.32 and a fix
> exists but it wouldn't have affected 2.6.31. If you are testing on 2.6.32
> though, this patch should be applied http://lkml.org/lkml/2009/12/21/245
>   
both are not affecting my scenario at all
>   
>> I did not yet check if it is possible, but we might have a spot tho  
>> might fix the issue.
>> Congestion_wait states it would "Waits for up to @timeout jiffies for a  
>> backing_dev (any backing_dev) to exit write congestion.  If no  
>> backing_devs are congested then just wait for the next write to be  
>> completed.".
>> Now in some case (and also my test) there is absolutely no write to do  
>> or in flight. So maybe it would be possible to either detect this before  
>> calling congestion_wait from page_alloc.c or let congestion_wait return  
>> an error code or something similar.
>>
>>     
>
> While I think that idea has merit, it's fixing the symptons and not the
> underlying problem. There is a growing opinion that congestion_wait() being
> used in the VM at all is a mistake. If the VM really needs to wait on pages
> being written out, it should have been on a waitqueue for a number of pages
> rather than a time-based method.
>
> In other words, I'm more interesting in figuring out *why* we enter
> congestion_wait() at all with the patch and it's avoided without rather than
> what congestion_wait() does when it gets called.
>
> Also, are you sure about thw "waiting for the next write to complete"? In
> 2.6.31 at least, it's waiting on the async write queue. If it's a case that
> it waits the full timeout if there is no async traffic then that's obviously
> bad as well but still doesn't explain why the problem patch makes a difference.
>   
I agree that this part of the discussion is about symptoms and for now 
we should try to focus on the cause that avtually brings up the race in 
__alloc_pages_direct_reclaim.
>> I mean as far as I can see the kernel currently does a loop like that  
>> (pseudo code and simplified):
>> 1. get a page <- fail
>> 2. try_to_free page <- returns >=1 pages freed
>> 3. get_page_from_freelist <- fails
>> 4. should_alloc_retry <- true
>> 5. congestion_wait <- FUTILE - just loosing time, nothing will be freed  
>> by writes
>> 6. goto 1
>> -> So maybe we should detect the futility of that congestion_wait call  
>> and not do it at all repeating instantly, go to oom, .., whatever (thats  
>> out for discussion).
>>
>> If we can't fix it that way I would propose we keep the code as is,  
>>     
>
> It's not my preferred way to fix this although I'm willing to explore it.
> I'd much prefer an explanation as to why your testcase is sensitive to the
> PFN ordering of the pages it gets back.
>
> One possibility is that your testcase requires a number of
> high-order allocations and the patch is preventing them being
> merged. If that was the case, the following patch would also help
> http://www.spinics.net/lists/mm-commits/msg75672.html but it's less than ideal.
>
>   
again not affecting my workload at all

>> hoping that it is a theoretical case that never hits a customer system.  
>> But in that case we should definitely add a userspace readable counter  
>> to congestion_wait similar to my debug patches. This would allow  
>> everyone that ever assumes an issue might be related to this to verify  
>> it by checking the congestion_wait counter.
>>     
>
> Would the accounting features available with
> CONFIG_TASK_DELAY_ACCT be sufficient?  There is a description in
> Documentation/accounting/delay-accounting.txt on how to use it. An abnormal
> amount of time spent on IO might explain the problem.
>
>   
Eventually it will appear as a huge increase in I/O-wait for no obvious 
reason - DELAY_ACCT is fine, actually even plain iostat is be enough.
The congestion_wait counter would just help to differ this issue, from 
others also increasing I/O-wait - but that is not too important.
I think we can all live without a counter and better fix the cause :-)
>> This should not be too hard in a technical way, but also not performance  
>> critical as congestion_wait is going to wait anyway. On the other hand  
>> everyone hates introducing new kernel interfaces that need to be kept  
>> compatible until nirvana - especially for bug tracking its not the best  
>> idea :-) So it should be our very last resort.
>>
>>     
>
> Agreed.
>
>   


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 


--------------000800050901060404040205
Content-Type: text/x-patch;
 name="perf-count-congestion-wait.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-congestion-wait.diff"

Index: linux-2.6-git/include/linux/sysctl.h
===================================================================
--- linux-2.6-git.orig/include/linux/sysctl.h	2010-02-05 16:48:08.000000000 +0100
+++ linux-2.6-git/include/linux/sysctl.h	2010-02-05 16:48:50.000000000 +0100
@@ -68,6 +68,7 @@
 	CTL_BUS=8,		/* Busses */
 	CTL_ABI=9,		/* Binary emulation */
 	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
+  	CTL_PERF=11,		/* Performance counters and timer sums for debugging */
 	CTL_ARLAN=254,		/* arlan wireless driver */
 	CTL_S390DBF=5677,	/* s390 debug */
 	CTL_SUNRPC=7249,	/* sunrpc debug */
Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c	2010-02-05 16:48:08.000000000 +0100
+++ linux-2.6-git/kernel/sysctl.c	2010-02-05 16:48:27.000000000 +0100
@@ -183,6 +183,7 @@
 	.default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
 };
 
+static struct ctl_table perf_table[];
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
@@ -236,6 +237,13 @@
 		.mode		= 0555,
 		.child		= dev_table,
 	},
+	{
+		.ctl_name	= CTL_PERF,
+		.procname	= "perf",
+		.mode		= 0555,
+		.child		= perf_table,
+	},
+
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
@@ -250,6 +258,19 @@
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
+extern unsigned long perf_count_congestion_wait;
+static struct ctl_table perf_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_congestion_wait",
+		.data           = &perf_count_congestion_wait,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{ .ctl_name = 0 }
+};
+
 static struct ctl_table kern_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6-git/mm/backing-dev.c
===================================================================
--- linux-2.6-git.orig/mm/backing-dev.c	2010-02-05 16:48:08.000000000 +0100
+++ linux-2.6-git/mm/backing-dev.c	2010-02-05 16:48:27.000000000 +0100
@@ -739,6 +739,7 @@
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
+unsigned long perf_count_congestion_wait = 0;
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
  * @sync: SYNC or ASYNC IO
@@ -754,6 +755,7 @@
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
+	perf_count_congestion_wait++;
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);

--------------000800050901060404040205
Content-Type: text/x-patch;
 name="perf-count-congestion-wait-calls.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-congestion-wait-calls.diff"

Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c	2010-02-05 16:48:58.000000000 +0100
+++ linux-2.6-git/kernel/sysctl.c	2010-02-05 16:49:03.000000000 +0100
@@ -262,6 +262,8 @@
 extern unsigned long perf_count_pages_direct_reclaim;
 extern unsigned long perf_count_failed_pages_direct_reclaim;
 extern unsigned long perf_count_failed_pages_direct_reclaim_but_progress;
+extern unsigned long perf_count_call_congestion_wait_from_alloc_pages_high_priority;
+extern unsigned long perf_count_call_congestion_wait_from_alloc_pages_slowpath;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -270,6 +272,22 @@
 		.mode           = 0666,
 		.maxlen		= sizeof(unsigned long),
 		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_call_congestion_wait_from_alloc_pages_high_priority",
+		.data           = &perf_count_call_congestion_wait_from_alloc_pages_high_priority,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_call_congestion_wait_from_alloc_pages_slowpath",
+		.data           = &perf_count_call_congestion_wait_from_alloc_pages_slowpath,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long),
+		.proc_handler   = &proc_doulongvec_minmax,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c	2010-02-05 16:48:58.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c	2010-02-05 16:49:03.000000000 +0100
@@ -1663,6 +1663,7 @@
 
 unsigned long perf_count_pages_direct_reclaim = 0;
 unsigned long perf_count_failed_pages_direct_reclaim = 0;
+unsigned long perf_count_failed_pages_direct_reclaim_but_progress = 0;
 
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
@@ -1704,12 +1705,13 @@
 	perf_count_pages_direct_reclaim++;
 	if (!page)
 		perf_count_failed_pages_direct_reclaim++;
-	if (!page && !(*did_some_progress))
-		perf_count_failed_pages_direct_reclaim_but_progress++
+	if (!page && (*did_some_progress))
+		perf_count_failed_pages_direct_reclaim_but_progress++;
 
 	return page;
 }
 
+unsigned long perf_count_call_congestion_wait_from_alloc_pages_high_priority = 0;
 /*
  * This is called in the allocator slow-path if the allocation request is of
  * sufficient urgency to ignore watermarks and take other desperate measures
@@ -1727,8 +1729,10 @@
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
 			preferred_zone, migratetype);
 
-		if (!page && gfp_mask & __GFP_NOFAIL)
+		if (!page && gfp_mask & __GFP_NOFAIL) {
+			perf_count_call_congestion_wait_from_alloc_pages_high_priority++;
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
+		}
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -1783,6 +1787,7 @@
 	return alloc_flags;
 }
 
+unsigned long perf_count_call_congestion_wait_from_alloc_pages_slowpath = 0;
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -1899,6 +1904,7 @@
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
+		perf_count_call_congestion_wait_from_alloc_pages_slowpath++;
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
 	}

--------------000800050901060404040205
Content-Type: text/x-patch;
 name="perf-count-failed-direct-recalims.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-failed-direct-recalims.diff"

Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c	2010-02-05 16:48:27.000000000 +0100
+++ linux-2.6-git/kernel/sysctl.c	2010-02-05 16:48:58.000000000 +0100
@@ -259,6 +259,9 @@
 #endif
 
 extern unsigned long perf_count_congestion_wait;
+extern unsigned long perf_count_pages_direct_reclaim;
+extern unsigned long perf_count_failed_pages_direct_reclaim;
+extern unsigned long perf_count_failed_pages_direct_reclaim_but_progress;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -268,6 +271,30 @@
 		.maxlen		= sizeof(unsigned long),
 		.proc_handler   = &proc_doulongvec_minmax,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_pages_direct_reclaim",
+		.data           = &perf_count_pages_direct_reclaim,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_failed_pages_direct_reclaim",
+		.data           = &perf_count_failed_pages_direct_reclaim,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_failed_pages_direct_reclaim_but_progress",
+		.data           = &perf_count_failed_pages_direct_reclaim_but_progress,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
 	{ .ctl_name = 0 }
 };
 
Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c	2010-02-05 16:48:07.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c	2010-02-05 16:48:58.000000000 +0100
@@ -1661,6 +1661,9 @@
 	return page;
 }
 
+unsigned long perf_count_pages_direct_reclaim = 0;
+unsigned long perf_count_failed_pages_direct_reclaim = 0;
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -1697,6 +1700,13 @@
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+
+	perf_count_pages_direct_reclaim++;
+	if (!page)
+		perf_count_failed_pages_direct_reclaim++;
+	if (!page && !(*did_some_progress))
+		perf_count_failed_pages_direct_reclaim_but_progress++
+
 	return page;
 }
 

--------------000800050901060404040205--
