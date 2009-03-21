Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZCUL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZCUL4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZCUL4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:56:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33925 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZCUL4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:56:05 -0400
Message-ID: <49C4D5A0.5020106@cosmosbay.com>
Date: Sat, 21 Mar 2009 12:55:12 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] futex: Dynamically size futexes hash table
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com>
In-Reply-To: <49C4AE64.4060400@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 21 Mar 2009 12:55:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Ravikiran G Thirumalai a écrit :
>> Patch to have a process private hash table for 'PRIVATE' futexes.
>>
>> On large core count systems running multiple threaded processes causes
>> false sharing on the global futex hash table.  The global futex hash
>> table is an array of struct futex_hash_bucket which is defined as:
>>
>> struct futex_hash_bucket {
>>         spinlock_t lock;
>>         struct plist_head chain;
>> };
>>
>> static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
>>
>> Needless to say this will cause multiple spinlocks to reside on the
>> same cacheline which is very bad when multiple un-related process
>> hash onto adjacent hash buckets.  The probability of unrelated futexes
>> ending on adjacent hash buckets increase with the number of cores in the
>> system (more cores available translates to more processes/more threads
>> being run on a system).  The effects of false sharing are tangible on
>> machines with more than 32 cores.  We have noticed this with  workload
>> of a certain multiple threaded FEA (Finite Element Analysis) solvers.
>> We reported this problem couple of years ago which eventually resulted in
>> a new api for private futexes to avoid mmap_sem.  The false sharing on
>> the global futex hash was put off pending glibc changes to accomodate
>> the futex private apis.  Now that the glibc changes are in, and
>> multicore is more prevalent, maybe it is time to fix this problem.
>>
>> The root cause of the problem is a global futex hash table even for process
>> private futexes.  Process private futexes can be hashed on process private
>> hash tables, avoiding the global hash and a longer hash table walk when
>> there are a lot more futexes in the workload.  However, this results in an
>> addition of one extra pointer to the mm_struct.  Hence, this implementation
>> of a process private hash table is based off a config option, which can be
>> turned off for smaller core count systems.  Furthermore, a subsequent patch
>> will introduce a sysctl to dynamically turn on private futex hash tables.
>>
>> We found this patch to improve the runtime of a certain FEA solver by about
>> 15% on a 32 core vSMP system.
>>
>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>> Signed-off-by: Shai Fultheim <shai@scalex86.org>
>>
> 
> First incantation of PRIVATE_FUTEXES had process private hash table
> 
> http://lkml.org/lkml/2007/3/15/230
> 
> I dont remember objections at that time, maybe it was going to slow down small
> users of these PRIVATE_FUTEXES, ie processes that will maybe use one futex_wait()
>  in their existence, because they'll have to allocate their private hash table
> and populate it.
> 
> So I dropped parts about NUMA and private hash tables to get PRIVATE_FUTEXES into mainline.
> 
> http://lwn.net/Articles/229668/
> 
> Did you tried to change FUTEX_HASHBITS instead, since current value is really really
> ridiculous ?
> 
> You could also try to adapt this patch to current kernels :
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-03/msg06504.html
> 
> [PATCH 3/3] FUTEX : NUMA friendly global hashtable
> 
> On NUMA machines, we should get better performance using a big futex
> hashtable, allocated with vmalloc() so that it is spreaded on several nodes.
> 
> I chose a static size of four pages. (Very big NUMA machines have 64k page
> size)
> 

Here is my suggested patch.

It should help both private and shared futexes usage on large machines.

[PATCH] futex: Dynamically size futexes hash table

As noticed by Ravikiran Thirumalai and Shai Fultheim, global futexes hash table
is too small with current hardware.
With 256 slots, probability of false sharing is too high.

This patch makes its size not known at compile time, but boot time computed,
depending on various factors, like number of possible cpus.

Using vmalloc() also has better NUMA properties, since at boot time
this hash table will be spreaded on many nodes, instead of only one.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 kernel/futex.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index 438701a..f636e5c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -62,7 +62,6 @@
 
 int __read_mostly futex_cmpxchg_enabled;
 
-#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
  * Priority Inheritance state:
@@ -121,7 +120,13 @@ struct futex_hash_bucket {
 	struct plist_head chain;
 };
 
-static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
+#if defined(CONFIG_BASE_SMALL)
+const unsigned int futex_hash_mask = 15;
+static struct futex_hash_bucket futex_queues[16];
+#else
+unsigned int futex_hash_mask __read_mostly;
+static struct futex_hash_bucket *futex_queues __read_mostly;
+#endif
 
 /*
  * We hash on the keys returned from get_futex_key (see below).
@@ -131,7 +136,7 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
 	u32 hash = jhash2((u32*)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+	return &futex_queues[hash & futex_hash_mask];
 }
 
 /*
@@ -2016,7 +2021,28 @@ static int __init futex_init(void)
 {
 	u32 curval;
 	int i;
+#if !defined(CONFIG_BASE_SMALL)
+#if defined(CONFIG_PROVE_LOCKING)
+	unsigned int nb_slots = 256;
+#else
+	unsigned int nb_slots = roundup_pow_of_two(num_possible_cpus()) * 256;
+#endif
+	size_t sz;
 
+retry:
+	sz = nb_slots * sizeof(struct futex_hash_bucket);
+	if (sz > PAGE_SIZE)
+		futex_queues = vmalloc(sz);
+	else
+		futex_queues = kmalloc(sz, GFP_KERNEL);
+	if (!futex_queues) {
+		nb_slots >>= 1;
+		if (!nb_slots)
+			panic("Could not allocate futex hash table");
+		goto retry;
+	}
+	futex_hash_mask = nb_slots - 1;
+#endif
 	/*
 	 * This will fail and we want it. Some arch implementations do
 	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
@@ -2031,7 +2057,7 @@ static int __init futex_init(void)
 	if (curval == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+	for (i = 0; i <= futex_hash_mask; i++) {
 		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
 		spin_lock_init(&futex_queues[i].lock);
 	}

