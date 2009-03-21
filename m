Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZCULmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZCULmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZCULmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:42:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbZCULmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:42:31 -0400
Date: Sat, 21 Mar 2009 04:35:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private
 futexes
Message-Id: <20090321043514.69f8243d.akpm@linux-foundation.org>
In-Reply-To: <20090321044637.GA7278@localdomain>
References: <20090321044637.GA7278@localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 21:46:37 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

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
> Index: linux-2.6.28.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.28.6.orig/include/linux/mm_types.h	2009-03-11 16:52:06.000000000 -0800
> +++ linux-2.6.28.6/include/linux/mm_types.h	2009-03-11 16:52:23.000000000 -0800
> @@ -256,6 +256,10 @@ struct mm_struct {
>  #ifdef CONFIG_MMU_NOTIFIER
>  	struct mmu_notifier_mm *mmu_notifier_mm;
>  #endif
> +#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
> +	/* Process private futex hash table */
> +	struct futex_hash_bucket *htb;
> +#endif

So we're effectively improving the hashing operation by splitting the
single hash table into multiple ones.

But was that the best way of speeding up the hashing operation?  I'd have
thought that for some workloads, there will still be tremendous amounts of
contention for the per-mm hashtable?  In which case it is but a partial fix
for certain workloads.

Whereas a more general hashing optimisation (if we can come up with it)
would benefit both types of workload?


