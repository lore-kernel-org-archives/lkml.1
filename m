Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZCWV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZCWV7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZCWV7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:59:11 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:53185 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbZCWV7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:59:09 -0400
Message-ID: <49C805E3.4060808@cosmosbay.com>
Date: Mon, 23 Mar 2009 22:57:55 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private	futexes
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain> <49C5F3FD.9010606@cosmosbay.com> <20090323202837.GE7278@localdomain>
In-Reply-To: <20090323202837.GE7278@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 23 Mar 2009 22:57:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai a écrit :
> On Sun, Mar 22, 2009 at 09:17:01AM +0100, Eric Dumazet wrote:
>> Ravikiran G Thirumalai a écrit :
>>>> Did you tried to change FUTEX_HASHBITS instead, since current value is really really
>>>> ridiculous ?
>>> We tried it in the past and I remember on a 16 core machine, we had to
>>> use 32k hash slots to avoid false sharing.
>>>
>>>
>>> Yes, dynamically changing the hash table is better (looking at the patch you
>>> have posted), but still there are no locality guarantees here.  A process
>>> pinned to node X may still end up accessing remote memory locations while
>>> accessing the hash table.  A process private table on the other hand should
>>> not have this problem. I think using a global hash for entirely process local
>>> objects is bad design wise here.
>>>
>>>
>>
>> Bad design, or bad luck... considering all kernel already use such global tables
>> (dentries, inodes, tcp, ip route cache, ...).
> 
> Not necessarily.  The dentry/inode/route caches need to be shared by
> processes so a global cache makes sense there -- the private futexes need to
> be only shared between threads of the process rather than the entire world.
> 
>> Problem is to size this hash table, being private or not. You said hou had
>> to have a 32768 slots to avoid false sharing on a 16 core machine. This seems
>> strange to me, given we use jhash. What is the size of the cache line on your
>> platforms ???
> 
> It is large and true these bad effects get magnified with larger cache lines.
> However, this does forewarn other architectures of problems such as these.
> Access to the below virtual addresses were seen to cause cache trashing
> between nodes on a vSMP system.  The eip corresponds to the  spin_lock
> on a 2.6.27 kernel at 'futex_wake' (see end of email).
> Obviously these addresses correspond to the spinlock on the hash buckets,
> and this was a threaded FEA solver workload on a 32 core machine.
> As can be seen, this is a problem even on a machine with 64b cacheline.
> 
> 
>> Say we have 32768 slots for the global hash table, and 256 slots for a private one,
>> you probably can have a program running slowly with this private 256 slots table,
>> if this program uses all available cores.
> 
> True, as I replied to akpm in this thread, if a workload happens to be one
> multi-threaded process with a zillion threads, the workload will have bigger
> overheads due to the sharing of process address space and mmap_sem.  Atleast
> that has been our experience so far.  Private futex hashes solve the
> problem on hand.
> 
>> If we use large private hash table, the setup cost is higher (need to initialize
>> all spinlocks and plist heads at each program startup), unless we use a dedicate
>> kmem_cache to keep a pool of preinitialized priv hash tables...
>>
> 
> 
> Hmm!  How about
> a) Reduce hash table size for private futex hash and increase hash table
>    size for the global hash?
> 
> OR, better,
> 
> b) Since it is multiple spinlocks on the same cacheline which is a PITA
>    here, how about keeping the global table, but just add a dereference
>    to each hash slot, and interleave the adjacent hash buckets between
>    nodes/cpus? So even without needing to  lose out memory from padding,
>    we avoid false sharing on cachelines due to unrelated futexes hashing
>    onto adjacent hash buckets?
> 

Because of jhash(), futex slots are almost random. No need to try to interleave
them. Since you have a "cache line" of 4096 bytes, you need almost 4 pages
per cpu to avoid in a statistical way false sharing.

Unfortunatly a small private futex hash will have the same scalability problem,
so its not a general solution.

Could you try this patch please ?

[PATCH] futex: Dynamically size futexes hash table

As noticed by Ravikiran Thirumalai and Shai Fultheim, global futexes hash table
is too small with current hardware.
With 256 slots, probability of false sharing is too high.

This patch makes its size not known at compile time, but boot time computed,
depending on various factors, like number of possible cpus, and VSMP settings.

Using alloc_large_system_hash() also has better NUMA properties, since at boot time
hash table will be spreaded on many nodes, instead of only one.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---


diff --git a/kernel/futex.c b/kernel/futex.c
index 438701a..bd9a052 100644
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
@@ -2016,7 +2021,25 @@ static int __init futex_init(void)
 {
 	u32 curval;
 	int i;
+#if !defined(CONFIG_BASE_SMALL)
+#if defined(CONFIG_PROVE_LOCKING)
+	unsigned int nr_slots = 256;
+#else
+	/* 4 nodes per cpu on VSMP, or 256 slots per cpu */
+	unsigned int nr_slots = max(256, (4 << INTERNODE_CACHE_SHIFT) /
+					  sizeof(struct futex_hash_bucket));
+	nr_slots = roundup_pow_of_two(num_possible_cpus() * nr_slots);
+#endif
 
+	futex_queues = alloc_large_system_hash("futexes",
+			sizeof(struct futex_hash_bucket),
+			nr_slots,
+			0, /* scale : unused */
+			0, /* flags */
+			NULL, /* shift */
+			&futex_hash_mask,
+			nr_slots);
+#endif
 	/*
 	 * This will fail and we want it. Some arch implementations do
 	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
@@ -2031,7 +2054,7 @@ static int __init futex_init(void)
 	if (curval == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+	for (i = 0; i <= futex_hash_mask; i++) {
 		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
 		spin_lock_init(&futex_queues[i].lock);
 	}

