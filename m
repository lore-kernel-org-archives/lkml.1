Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZCVEP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZCVEP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 00:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZCVEPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 00:15:11 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:50850 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZCVEPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 00:15:10 -0400
Date: Sat, 21 Mar 2009 21:15:02 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private
	futexes
Message-ID: <20090322041502.GC7278@localdomain>
References: <20090321044637.GA7278@localdomain> <20090321043514.69f8243d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321043514.69f8243d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 04:35:14AM -0700, Andrew Morton wrote:
>On Fri, 20 Mar 2009 21:46:37 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> 
>> Index: linux-2.6.28.6/include/linux/mm_types.h
>> ===================================================================
>> --- linux-2.6.28.6.orig/include/linux/mm_types.h	2009-03-11 16:52:06.000000000 -0800
>> +++ linux-2.6.28.6/include/linux/mm_types.h	2009-03-11 16:52:23.000000000 -0800
>> @@ -256,6 +256,10 @@ struct mm_struct {
>>  #ifdef CONFIG_MMU_NOTIFIER
>>  	struct mmu_notifier_mm *mmu_notifier_mm;
>>  #endif
>> +#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
>> +	/* Process private futex hash table */
>> +	struct futex_hash_bucket *htb;
>> +#endif
>
>So we're effectively improving the hashing operation by splitting the
>single hash table into multiple ones.
>
>But was that the best way of speeding up the hashing operation?  I'd have
>thought that for some workloads, there will still be tremendous amounts of
>contention for the per-mm hashtable?  In which case it is but a partial fix
>for certain workloads.

If there is tremendous contention on the per-mm hashtable, then
workload suffers from userspace lock contention to begin with, and the right
approach would be to fix the lock contention in userspace/workload, no?
True, if a workload happens to be one process on a large core count machine
with a zillion threads, using a zillion futexes, hashing might still be bad,
but  such a workload has bigger hurdles like the mmap_sem which is still
a bigger lock than the per-bucket locks of the private hash table.  (Even
with use of the FUTEX_PRIVATE_FLAG, mmap_sem gets contended for page faults
and the like).

The fundamental problem we are facing right now is the private futexes
hashing onto a global hash table and then the futex subsystem
wading through the table that contains private futexes from other
*unrelated* processes.  Even with better hashing/larger hash table, we do not
eliminate the possibility of private futexes from two unrelated processes
hashing on to hash buckets close enough to be on the same cache line -- if
we use one global hash table for private futexes.
(I remember doing some tests and instrumentation in the past with a
different hash function as well as more hash slots)
Hence, it seems like a private hash table for private futexes are the right
solution.  Perhaps we can reduce the hash slots for private hash table and
increase the hash slots on the global hash (to help non-private futex
hashing)?

Thanks,
Kiran
