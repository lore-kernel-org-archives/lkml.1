Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326Ab0ASLdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0ASLdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115Ab0ASLdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:33:21 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36080 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0ASLdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:33:19 -0500
Date: Tue, 19 Jan 2010 11:33:07 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100119113306.GA23881@csn.ul.ie>
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B4F0E60.1020601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 01:30:24PM +0100, Christian Ehrhardt wrote:
> Mel Gorman wrote:
>> On Fri, Dec 18, 2009 at 02:38:15PM +0100, Christian Ehrhardt wrote:
>>   
>>> Christian Ehrhardt wrote:
>>>     [...]
>> You mention that the "GOOD" kernel is one commit before e084b but can
>> you test with just that patch reverted please? As the patch is only
>> about list manipulation, I'm failing to see how it can affect
>> congestion_wait().
>>
>>   
>>> Unfortunately I don't understand memory management enough to find the 
>>>  relation between e084b actually changing the order and position of 
>>> freed  pages in the LRU list to __alloc_pages_direct_reclaim not 
>>> getting pages  as effectively as before.
>>>     
>>
>> Off-hand, neither can I. I regret that I'm going off-line for the
>> Christmas very soon and I'll be in the middle of nowhere with no
>> internet connection or test machines in the interim. It's going to be
>> the new year before I get to look at this properly.
>>
>> Even if this patch is not the real problem, your instrumentation patches
>> will help pin down the real problem. Thanks and sorry I'll be delayed in
>> getting back to you properly.
>>   
>
> Back to business :-)
> First - yes it is reproducible in 2.6.32 final and fixable by unapplying  
> e084b.
> But I don't think un-applying it is really a fix as no one really  
> understands how e084b cause this regression (it might just work around  
> whatever goes on in the background and someone still hits the hidden 
> issue).
>

Agreed on reverting is not an option. While it is not understood why it
causes your regression, it's known to fix a regression for hardware that
does do merging.

> Lets better look what we know summarized:
> - the patch e084a causes this regression
> - it causes it only in very rare if not theoretically high memory  
> constraints
> - time is lost between read system call and the block device layer enter
> - via debugging and discussion we found that time lost is spent in  
> congestion_wait
>

Thanks for the summary.

There is an outside chance it's due to a difference in free page availablity
and the associated counters. Particularly if some subsystem is optimistally
trying high-order allocations depending on availability. If there are many
allocation failures, the counters gets skewed due to a bug, watermarks are
not met and direct reclaim is used more. A patch is on its way upstream to
fix this is http://www.spinics.net/lists/mm-commits/msg75671.html . Can you
try it please?

There is a report on swap-based workloads being impacted on 2.6.32 and a fix
exists but it wouldn't have affected 2.6.31. If you are testing on 2.6.32
though, this patch should be applied http://lkml.org/lkml/2009/12/21/245

> I did not yet check if it is possible, but we might have a spot tho  
> might fix the issue.
> Congestion_wait states it would "Waits for up to @timeout jiffies for a  
> backing_dev (any backing_dev) to exit write congestion.  If no  
> backing_devs are congested then just wait for the next write to be  
> completed.".
> Now in some case (and also my test) there is absolutely no write to do  
> or in flight. So maybe it would be possible to either detect this before  
> calling congestion_wait from page_alloc.c or let congestion_wait return  
> an error code or something similar.
>

While I think that idea has merit, it's fixing the symptons and not the
underlying problem. There is a growing opinion that congestion_wait() being
used in the VM at all is a mistake. If the VM really needs to wait on pages
being written out, it should have been on a waitqueue for a number of pages
rather than a time-based method.

In other words, I'm more interesting in figuring out *why* we enter
congestion_wait() at all with the patch and it's avoided without rather than
what congestion_wait() does when it gets called.

Also, are you sure about thw "waiting for the next write to complete"? In
2.6.31 at least, it's waiting on the async write queue. If it's a case that
it waits the full timeout if there is no async traffic then that's obviously
bad as well but still doesn't explain why the problem patch makes a difference.

> I mean as far as I can see the kernel currently does a loop like that  
> (pseudo code and simplified):
> 1. get a page <- fail
> 2. try_to_free page <- returns >=1 pages freed
> 3. get_page_from_freelist <- fails
> 4. should_alloc_retry <- true
> 5. congestion_wait <- FUTILE - just loosing time, nothing will be freed  
> by writes
> 6. goto 1
> -> So maybe we should detect the futility of that congestion_wait call  
> and not do it at all repeating instantly, go to oom, .., whatever (thats  
> out for discussion).
>
> If we can't fix it that way I would propose we keep the code as is,  

It's not my preferred way to fix this although I'm willing to explore it.
I'd much prefer an explanation as to why your testcase is sensitive to the
PFN ordering of the pages it gets back.

One possibility is that your testcase requires a number of
high-order allocations and the patch is preventing them being
merged. If that was the case, the following patch would also help
http://www.spinics.net/lists/mm-commits/msg75672.html but it's less than ideal.

> hoping that it is a theoretical case that never hits a customer system.  
> But in that case we should definitely add a userspace readable counter  
> to congestion_wait similar to my debug patches. This would allow  
> everyone that ever assumes an issue might be related to this to verify  
> it by checking the congestion_wait counter.

Would the accounting features available with
CONFIG_TASK_DELAY_ACCT be sufficient?  There is a description in
Documentation/accounting/delay-accounting.txt on how to use it. An abnormal
amount of time spent on IO might explain the problem.

> This should not be too hard in a technical way, but also not performance  
> critical as congestion_wait is going to wait anyway. On the other hand  
> everyone hates introducing new kernel interfaces that need to be kept  
> compatible until nirvana - especially for bug tracking its not the best  
> idea :-) So it should be our very last resort.
>

Agreed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
