Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZCUJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZCUJIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCUJIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:08:09 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50624 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZCUJIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:08:07 -0400
Message-ID: <49C4AE64.4060400@cosmosbay.com>
Date: Sat, 21 Mar 2009 10:07:48 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private futexes
References: <20090321044637.GA7278@localdomain>
In-Reply-To: <20090321044637.GA7278@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 21 Mar 2009 10:07:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai a écrit :
> Patch to have a process private hash table for 'PRIVATE' futexes.
> 
> On large core count systems running multiple threaded processes causes
> false sharing on the global futex hash table.  The global futex hash
> table is an array of struct futex_hash_bucket which is defined as:
> 
> struct futex_hash_bucket {
>         spinlock_t lock;
>         struct plist_head chain;
> };
> 
> static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
> 
> Needless to say this will cause multiple spinlocks to reside on the
> same cacheline which is very bad when multiple un-related process
> hash onto adjacent hash buckets.  The probability of unrelated futexes
> ending on adjacent hash buckets increase with the number of cores in the
> system (more cores available translates to more processes/more threads
> being run on a system).  The effects of false sharing are tangible on
> machines with more than 32 cores.  We have noticed this with  workload
> of a certain multiple threaded FEA (Finite Element Analysis) solvers.
> We reported this problem couple of years ago which eventually resulted in
> a new api for private futexes to avoid mmap_sem.  The false sharing on
> the global futex hash was put off pending glibc changes to accomodate
> the futex private apis.  Now that the glibc changes are in, and
> multicore is more prevalent, maybe it is time to fix this problem.
> 
> The root cause of the problem is a global futex hash table even for process
> private futexes.  Process private futexes can be hashed on process private
> hash tables, avoiding the global hash and a longer hash table walk when
> there are a lot more futexes in the workload.  However, this results in an
> addition of one extra pointer to the mm_struct.  Hence, this implementation
> of a process private hash table is based off a config option, which can be
> turned off for smaller core count systems.  Furthermore, a subsequent patch
> will introduce a sysctl to dynamically turn on private futex hash tables.
> 
> We found this patch to improve the runtime of a certain FEA solver by about
> 15% on a 32 core vSMP system.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> Signed-off-by: Shai Fultheim <shai@scalex86.org>
> 

First incantation of PRIVATE_FUTEXES had process private hash table

http://lkml.org/lkml/2007/3/15/230

I dont remember objections at that time, maybe it was going to slow down small
users of these PRIVATE_FUTEXES, ie processes that will maybe use one futex_wait()
 in their existence, because they'll have to allocate their private hash table
and populate it.

So I dropped parts about NUMA and private hash tables to get PRIVATE_FUTEXES into mainline.

http://lwn.net/Articles/229668/

Did you tried to change FUTEX_HASHBITS instead, since current value is really really
ridiculous ?

You could also try to adapt this patch to current kernels :

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-03/msg06504.html

[PATCH 3/3] FUTEX : NUMA friendly global hashtable

On NUMA machines, we should get better performance using a big futex
hashtable, allocated with vmalloc() so that it is spreaded on several nodes.

I chose a static size of four pages. (Very big NUMA machines have 64k page
size)


