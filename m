Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYBSVvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYBSVvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbYBSVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:51:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43986 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbYBSVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:51:41 -0500
Date: Tue, 19 Feb 2008 13:51:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: linux-kernel@vger.kernel.org, walpole@cs.pdx.edu
Subject: Re: [ANNOUNCE,RFC] rcuhashbash synchronization benchmark module
Message-ID: <20080219215129.GG10774@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <47BAE404.8070104@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BAE404.8070104@freedesktop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 06:13:24AM -0800, Josh Triplett wrote:

Good stuff!!!  Some questions and comments below.

> Some time ago, I developed a new algorithm for moving a hash table
> element to a new key and new bucket in an atomic fashion, without
> locking.  This algorithm works with synchronization techniques like
> RCU, which allow writers to proceed without waiting for readers, and
> delay the visibility of some writer updates until later readers.
> Details of the algorithm appear later in this mail.
> 
> Recently, I developed a benchmark module to determine the performance
> of my algorithm.  In the process, I discovered that my benchmark
> seemed to work quite well as a benchmark of synchronization techniques
> in general.  Thus, I'd like to present it to the Linux community, both
> to allow others to make use of it and to get feedback.  I have
> included the code for rcuhashbash inline in this mail for ease of
> commenting.
> 
> The rcuhashbash benchmark module works by constructing a hash table
> with integer keys, and then starting reader and writer threads.  The
> reader threads randomly choose a key from the range of possible items
> and look it up.  The writer threads randomly choose two keys and move
> the item with the first key to the item with the second key.  The
> reader and writer threads track the number of operations they
> complete, and the benchmark module prints these when unloaded.  Thus,
> a benchmark run involves inserting the module with the desired
> parameters, sleeping, removing the module, and obtaining the benchmark
> results from dmesg.
> 
> A move algorithm used in the benchmark must satisfy some atomicity
> requirements:
> 
> 1) If a reader finds the item under the new name, it must not
>    subsequently find it under the old name.
> 2) If a reader does not find the item under the old name, it must not
>    then subsequently fail to find the item under the new name.
> 3) Unrelated items in the hash table must always appear when looked up,
>    regardless of operations occurring in parallel.
> 
> These provide useful properties for implementing higher-level
> atomicity requirements, such as those of the rename system call.
> 
> These requirements rule out the most obvious RCU move algorithms.
> Inserting the item into the new bucket before removing it from the old
> would allow it to appear in both places, violating requirement 1.
> Removing the item from one bucket before inserting it into the other
> would allow the item to temporarily appear in neither place, violating
> requirement 2.  Furthermore, moving an item in either fashion could
> potentially drag readers from one bucket to another following the
> item, violating requirement 3.
> 
> My RCU move algorithm moves items from one bucket to another
> atomically by:
> 
> * Moving the item to the end of its current hash chain, so no items
>   appear after it.
> * Cross-linking that item into both hash buckets by pointing the last
>   item of the new bucket to it.
> * Changing the key, which atomically makes the item appear in the new
>   bucket and disappear from the old.
> * Un-cross-linking the chains.
> 
> See the source code for more details on the algorithm.
> 
> The main complexity comes in due to moving the item to the end of its
> chain, and in resolving the cross-linking safely.
> 
> Full disclosure: like RCU itself, this algorithm has IBM patents
> pending on it.  Also like RCU, GPLed code can use these patents.
> 
> In addition to my algorithm, I also included many several forms of
> locking synchronization, several variations on how to lock hash
> buckets, and another RCU algorithm using a sequence counter lock
> (inspired by dcache's rename handling, which originally motivated the
> invention of this new move algorithm).  The structure of rcuhashbash
> makes it easy to add additional synchronization variants.
> 
> The results from rcuhashbash seem to agree with reasonable
> expectations.  RCU runs circles around locking in terms of reader
> performance, at the expense of writer performance.  My new algorithm
> beats the sequence-counter-based algorithm in read performance.  For
> the locking approaches to synchronization, fine-grained locking works
> better than coarse-grained, and heavyweight locks like reader-writer
> locks lose to simpler locks like spinlocks.
> 
> I look forward to any comments people may have on the rcuhashbash
> synchronization benchmark.
> 
> - Josh Triplett
> 
> Source code for rcuhashbash.c:
> 
> /* rcuhashbash: test module for RCU hash-table alorithms.
>  * Written by Josh Triplett
>  * Mostly lockless random number generator rcu_random from rcutorture, by Paul
>  * McKenney and Josh Triplett.
>  */
> #include <linux/byteorder/swabb.h>
> #include <linux/dcache.h>
> #include <linux/init.h>
> #include <linux/kthread.h>
> #include <linux/list.h>
> #include <linux/module.h>
> #include <linux/mutex.h>
> #include <linux/random.h>
> #include <linux/rcupdate.h>
> #include <linux/seqlock.h>
> #include <linux/slab.h>
> #include <linux/spinlock.h>
> #include <linux/string.h>
> 
> MODULE_AUTHOR("Josh Triplett <josh@kernel.org>");
> MODULE_DESCRIPTION("RCU hash algorithm test module.");
> MODULE_LICENSE("GPL");
> 
> static char *reader_type = "rcu"; /* Reader implementation to benchmark */
> static char *writer_type = "spinlock"; /* Writer implementation to benchmark */
> static int readers = -1; /* Number of reader tasks; defaults to online CPUs */
> static int writers = -1; /* Number of writer tasks; defaults to online CPUs */
> static unsigned long buckets = 1024; /* Number of hash table buckets */
> static unsigned long entries = 4096; /* Number of entries initially added */
> static unsigned long reader_range = 0; /* Upper bound of reader range */
> static unsigned long writer_range = 0; /* Upper bound of writer range */
> 
> module_param(reader_type, charp, 0444);
> MODULE_PARM_DESC(reader_type, "Hash table reader implementation");
> module_param(writer_type, charp, 0444);
> MODULE_PARM_DESC(writer_type, "Hash table writer implementation");
> module_param(readers, int, 0444);
> MODULE_PARM_DESC(readers, "Number of reader threads");
> module_param(writers, int, 0444);
> MODULE_PARM_DESC(writers, "Number of writer threads");
> module_param(buckets, ulong, 0444);
> MODULE_PARM_DESC(buckets, "Number of hash buckets");
> module_param(entries, ulong, 0444);
> MODULE_PARM_DESC(entries, "Number of hash table entries");
> module_param(reader_range, ulong, 0444);
> MODULE_PARM_DESC(reader_range, "Upper bound of reader operating range (default 2*entries)");
> module_param(writer_range, ulong, 0444);
> MODULE_PARM_DESC(writer_range, "Upper bound of writer operating range (default 2*entries)");
> 
> struct rcuhashbash_bucket {
> 	struct hlist_head head;
> 	union {
> 		spinlock_t spinlock;
> 		rwlock_t rwlock;
> 		struct mutex mutex;
> 	};
> };
> 
> struct rcuhashbash_ops {
> 	void (*init_bucket)(struct rcuhashbash_bucket *);
> 	int (*reader_thread)(void *);
> 	void (*read_lock_bucket)(struct rcuhashbash_bucket *);
> 	void (*read_unlock_bucket)(struct rcuhashbash_bucket *);
> 	int (*writer_thread)(void *);
> 	void (*write_lock_buckets)(struct rcuhashbash_bucket *, struct rcuhashbash_bucket *);
> 	void (*write_unlock_buckets)(struct rcuhashbash_bucket *, struct rcuhashbash_bucket *);
> 	bool limit_writers;
> 	int max_writers;
> 	const char *reader_type;
> 	const char *writer_type;
> };
> 
> static struct rcuhashbash_ops *ops;
> 
> static DEFINE_SPINLOCK(table_spinlock);
> static DEFINE_RWLOCK(table_rwlock);
> static DEFINE_MUTEX(table_mutex);
> static seqcount_t table_seqcount = SEQCNT_ZERO;
> 
> static struct rcuhashbash_bucket *hash_table;
> 
> struct rcuhashbash_entry {
> 	struct hlist_node node;
> 	struct rcu_head rcu_head;
> 	u32 value;
> };
> 
> static struct kmem_cache *entry_cache;
> 
> static struct task_struct **reader_tasks;
> static struct task_struct **writer_tasks;
> 
> struct reader_stats {
> 	u64 hits;
> 	u64 misses;
> };
> 
> struct writer_stats {
> 	u64 moves;
> 	u64 dests_in_use;
> 	u64 misses;
> };
> 
> struct reader_stats *reader_stats;
> struct writer_stats *writer_stats;
> 
> struct rcu_random_state {
> 	unsigned long rrs_state;
> 	long rrs_count;
> };
> 
> #define RCU_RANDOM_MULT 39916801  /* prime */
> #define RCU_RANDOM_ADD  479001701 /* prime */
> #define RCU_RANDOM_REFRESH 10000
> 
> #define DEFINE_RCU_RANDOM(name) struct rcu_random_state name = { 0, 0 }
> 
> /*
>  * Crude but fast random-number generator.  Uses a linear congruential
>  * generator, with occasional help from cpu_clock().
>  */
> static unsigned long
> rcu_random(struct rcu_random_state *rrsp)
> {
> 	if (--rrsp->rrs_count < 0) {
> 		rrsp->rrs_state +=
> 			(unsigned long)cpu_clock(raw_smp_processor_id());
> 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
> 	}
> 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
> 	return swahw32(rrsp->rrs_state);
> }
> 
> static int rcuhashbash_reader_nosync(void *arg)
> {
> 	struct reader_stats *stats_ret = arg;
> 	struct reader_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		struct rcuhashbash_entry *entry;
> 		struct hlist_node *node;
> 		u32 value;
> 
> 		cond_resched();
> 
> 		value = rcu_random(&rand) % reader_range;
> 
> 		hlist_for_each_entry(entry, node, &hash_table[value % buckets].head, node)
> 			if (entry->value == value)
> 				break;
> 		if (node)
> 			stats.hits++;
> 		else
> 			stats.misses++;
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static int rcuhashbash_reader_nosync_rcu_dereference(void *arg)
> {
> 	struct reader_stats *stats_ret = arg;
> 	struct reader_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		struct rcuhashbash_entry *entry;
> 		struct hlist_node *node;
> 		u32 value;
> 
> 		cond_resched();
> 
> 		value = rcu_random(&rand) % reader_range;
> 
> 		hlist_for_each_entry_rcu(entry, node, &hash_table[value % buckets].head, node)
> 			if (entry->value == value)
> 				break;
> 		if (node)
> 			stats.hits++;
> 		else
> 			stats.misses++;
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static int rcuhashbash_reader_rcu(void *arg)
> {
> 	struct reader_stats *stats_ret = arg;
> 	struct reader_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		struct rcuhashbash_entry *entry;
> 		struct hlist_node *node;
> 		u32 value;
> 
> 		cond_resched();
> 
> 		value = rcu_random(&rand) % reader_range;
> 
> 		rcu_read_lock();
> 		hlist_for_each_entry_rcu(entry, node, &hash_table[value % buckets].head, node)
> 			if (entry->value == value)
> 				break;
> 		if (node)
> 			stats.hits++;
> 		else
> 			stats.misses++;
> 		rcu_read_unlock();
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static int rcuhashbash_reader_lock(void *arg)
> {
> 	struct reader_stats *stats_ret = arg;
> 	struct reader_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		struct rcuhashbash_entry *entry;
> 		struct hlist_node *node;
> 		u32 value, bucket;
> 
> 		cond_resched();
> 
> 		value = rcu_random(&rand) % reader_range;
> 		bucket = value % buckets;
> 
> 		if (ops->read_lock_bucket)
> 			ops->read_lock_bucket(&hash_table[bucket]);
> 		hlist_for_each_entry(entry, node, &hash_table[value % buckets].head, node)
> 			if (entry->value == value)
> 				break;
> 		if (node)
> 			stats.hits++;
> 		else
> 			stats.misses++;
> 		if (ops->read_unlock_bucket)
> 			ops->read_unlock_bucket(&hash_table[bucket]);
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static int rcuhashbash_reader_rcu_seq(void *arg)
> {
> 	struct reader_stats *stats_ret = arg;
> 	struct reader_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		struct rcuhashbash_entry *entry;
> 		struct hlist_node *node;
> 		u32 value;
> 		unsigned long seq;
> 		bool found;
> 
> 		cond_resched();
> 
> 		value = rcu_random(&rand) % reader_range;
> 
> 		do {
> 			seq = read_seqcount_begin(&table_seqcount);
> 			rcu_read_lock();
> 			hlist_for_each_entry_rcu(entry, node, &hash_table[value % buckets].head, node)
> 				if (entry->value == value)
> 					break;
> 			found = node;
> 			rcu_read_unlock();
> 		} while (read_seqcount_retry(&table_seqcount, seq));
> 
> 		if (found)
> 			stats.hits++;
> 		else
> 			stats.misses++;
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static void rcuhashbash_entry_cb(struct rcu_head *rcu_head)
> {
> 	struct rcuhashbash_entry *entry;
> 	entry = container_of(rcu_head, struct rcuhashbash_entry, rcu_head);
> 	kmem_cache_free(entry_cache, entry);
> }
> 
> static int rcuhashbash_writer_rcu(void *arg)
> {
> 	int err = 0;
> 	struct writer_stats *stats_ret = arg;
> 	struct writer_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		u32 src_value, src_bucket;
> 		u32 dst_value, dst_bucket;
> 		struct rcuhashbash_entry *entry = NULL;
> 		struct hlist_node *node;
> 		struct rcuhashbash_entry *src_entry = NULL;
> 		bool same_bucket;
> 		bool dest_in_use = false;
> 		struct rcuhashbash_entry *old_entry = NULL;
> 		struct hlist_node **src_tail = NULL;
> 		struct hlist_node **dst_tail = NULL;
> 
> 		cond_resched();
> 
> 		src_value = rcu_random(&rand) % writer_range;
> 		src_bucket = src_value % buckets;
> 		dst_value = rcu_random(&rand) % writer_range;
> 		dst_bucket = dst_value % buckets;
> 		same_bucket = src_bucket == dst_bucket;

If applying this sort of algorithm to dynamically resizing RCU-protected
hash tables, same_bucket would always be false, allowing some simplification
below.

> 		if (ops->write_lock_buckets)
> 			ops->write_lock_buckets(&hash_table[src_bucket],
> 			                        &hash_table[dst_bucket]);
> 
> 		/* Find src_tail and src_entry. */
> 		src_tail = &(hash_table[src_bucket].head.first);
> 		hlist_for_each_entry(entry, node, &hash_table[src_bucket].head, node) {
> 			if (entry->value == src_value)
> 				src_entry = entry;
> 			if (same_bucket && entry->value == dst_value)
> 				dest_in_use = true;
> 			if (!entry->node.next)
> 				src_tail = &(entry->node.next);
> 		}
> 		if (!src_entry) {
> 			stats.misses++;
> 			goto unlock_and_loop;
> 		}
> 		if (dest_in_use) {
> 			stats.dests_in_use++;
> 			goto unlock_and_loop;

Why not hoist the above two lines up into the body of the "if" above
that sets "dest_in_use"?  I don't understand what is gained by continuing
the hash-chain scan once you see that the destination name is already
present, given that you are simply going to fail the operation in
any case.

Of course, if this was the file-rename situation, you would need to
atomically replace the old element with the new one...

> 		}
> 
> 		if (same_bucket) {
> 			src_entry->value = dst_value;
> 			stats.moves++;
> 			goto unlock_and_loop;
> 		}
> 
> 		/* Find dst_tail and check for existing destination. */
> 		dst_tail = &(hash_table[dst_bucket].head.first);
> 		hlist_for_each_entry(entry, node, &hash_table[dst_bucket].head, node) {
> 			if (entry->value == dst_value) {
> 				dest_in_use = true;
> 				break;
> 			}
> 			if (!entry->node.next)
> 				dst_tail = &(entry->node.next);
> 		}
> 		if (dest_in_use) {
> 			stats.dests_in_use++;
> 			goto unlock_and_loop;

As above, why not hoist the above two lines into the body of the "if" above
that sets "dest_in_use"?

> 		}
> 
> 		/* Move the entry to the end of its bucket. */
> 		if (src_entry->node.next) {
> 			old_entry = src_entry;
> 			src_entry = kmem_cache_zalloc(entry_cache, GFP_KERNEL);
> 			if (!src_entry) {
> 				err = -ENOMEM;
> 				goto unlock_and_loop;
> 			}
> 			src_entry->value = old_entry->value;

In the dcache case, wouldn't we need to have this newly created entry
reference the one that appears earlier in the list?  That would allow
the original (that appeared in the middle of the list) to be moved
to the new list, which is necessary in the dcache case given the large
number of external references that can be held to dentries.

This would of course require an additional test in the read-side
search loop, but no atomics or additional memory barriers.

Also, after removing the original source element, it would be necessary
to add it back in at the tail of the list and then remove the fake
element.

> 			src_entry->node.pprev = src_tail;
> 			smp_wmb(); /* Initialization must appear before insertion */
> 			*src_tail = &src_entry->node;

Replacing the above with rcu_assign_pointer() would eliminate the bare
memory barrier.  OTOH, the following memory barrier cannot be trivially
pulled into an rcu_assign_pointer, from what I can see, anyway.

> 			smp_wmb(); /* New entry must appear before old disappears. */
> 			hlist_del_rcu(&old_entry->node);
> 			call_rcu(&old_entry->rcu_head, rcuhashbash_entry_cb);
> 		}
> 
> 		/* Cross-link and change key to move. */
> 		*dst_tail = &src_entry->node;

OK, now on both lists...  But why doesn't the above need to be
rcu_assign_pointer()?  Ah, I see -- you are relying on the searches
of the new bucket to fail due to key mismatch, and the fact that the
source bucket will find either the old entry or the new faked-up one.

> 		smp_wmb(); /* Must appear in new bucket before changing key */

The above barrier could be subsumed into the following assignment via
rcu_assign_pointer().

> 		src_entry->value = dst_value;
> 		smp_wmb(); /* Need new value before removing from old bucket */

The above memory barrier cannot be subsumed into rcu_assign_pointer(),
as the new version of this primitive omits the memory barrier when
assigning a NULL pointer.

> 		*src_entry->node.pprev = NULL;
> 		src_entry->node.pprev = dst_tail;
> 
> 		stats.moves++;

[I have not fully convinced myself that we don't need a synchronize_rcu()
or two in this code path, but will stare at it some more...]

							Thanx, Paul

> unlock_and_loop:
> 		if (ops->write_unlock_buckets)
> 			ops->write_unlock_buckets(&hash_table[src_bucket],
> 			                          &hash_table[dst_bucket]);
> 	} while (!kthread_should_stop() && !err);
> 
> 	*stats_ret = stats;
> 
> 	while (!kthread_should_stop())
> 		schedule_timeout_interruptible(1);
> 	return err;
> }
> 
> static int rcuhashbash_writer_lock(void *arg)
> {
> 	struct writer_stats *stats_ret = arg;
> 	struct writer_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		u32 src_value, src_bucket;
> 		u32 dst_value, dst_bucket;
> 		struct rcuhashbash_entry *entry = NULL;
> 		struct hlist_node *node;
> 		struct rcuhashbash_entry *src_entry = NULL;
> 		bool same_bucket;
> 		bool dest_in_use = false;
> 
> 		cond_resched();
> 
> 		src_value = rcu_random(&rand) % writer_range;
> 		src_bucket = src_value % buckets;
> 		dst_value = rcu_random(&rand) % writer_range;
> 		dst_bucket = dst_value % buckets;
> 		same_bucket = src_bucket == dst_bucket;
> 
> 		if (ops->write_lock_buckets)
> 			ops->write_lock_buckets(&hash_table[src_bucket],
> 			                        &hash_table[dst_bucket]);
> 
> 		/* Find src_entry. */
> 		hlist_for_each_entry(entry, node, &hash_table[src_bucket].head, node) {
> 			if (entry->value == src_value)
> 				src_entry = entry;
> 			if (same_bucket && entry->value == dst_value)
> 				dest_in_use = true;
> 		}
> 		if (!src_entry) {
> 			stats.misses++;
> 			goto unlock_and_loop;
> 		}
> 		if (dest_in_use) {
> 			stats.dests_in_use++;
> 			goto unlock_and_loop;
> 		}
> 
> 		if (same_bucket) {
> 			src_entry->value = dst_value;
> 			stats.moves++;
> 			goto unlock_and_loop;
> 		}
> 
> 		/* Check for existing destination. */
> 		hlist_for_each_entry(entry, node, &hash_table[dst_bucket].head, node)
> 			if (entry->value == dst_value) {
> 				dest_in_use = true;
> 				break;
> 			}
> 		if (dest_in_use) {
> 			stats.dests_in_use++;
> 			goto unlock_and_loop;
> 		}
> 
> 		hlist_del(&src_entry->node);
> 		src_entry->value = dst_value;
> 		hlist_add_head(&src_entry->node, &hash_table[dst_bucket].head);
> 
> 		stats.moves++;
> 
> unlock_and_loop:
> 		if (ops->write_unlock_buckets)
> 			ops->write_unlock_buckets(&hash_table[src_bucket],
> 			                          &hash_table[dst_bucket]);
> 	} while (!kthread_should_stop());
> 
> 	*stats_ret = stats;
> 
> 	return 0;
> }
> 
> static int rcuhashbash_writer_rcu_seq(void *arg)
> {
> 	int err = 0;
> 	struct writer_stats *stats_ret = arg;
> 	struct writer_stats stats = { 0 };
> 	DEFINE_RCU_RANDOM(rand);
> 
> 	set_user_nice(current, 19);
> 
> 	do {
> 		u32 src_value, src_bucket;
> 		u32 dst_value, dst_bucket;
> 		struct rcuhashbash_entry *entry = NULL;
> 		struct hlist_node *node;
> 		struct rcuhashbash_entry *src_entry = NULL;
> 		bool same_bucket;
> 		bool dest_in_use = false;
> 
> 		cond_resched();
> 
> 		src_value = rcu_random(&rand) % writer_range;
> 		src_bucket = src_value % buckets;
> 		dst_value = rcu_random(&rand) % writer_range;
> 		dst_bucket = dst_value % buckets;
> 		same_bucket = src_bucket == dst_bucket;
> 
> 		if (ops->write_lock_buckets)
> 			ops->write_lock_buckets(&hash_table[src_bucket],
> 			                        &hash_table[dst_bucket]);
> 
> 		/* Find src_entry. */
> 		hlist_for_each_entry(entry, node, &hash_table[src_bucket].head, node) {
> 			if (entry->value == src_value) {
> 				src_entry = entry;
> 				break;
> 			}
> 		}
> 		if (!src_entry) {
> 			stats.misses++;
> 			goto unlock_and_loop;
> 		}
> 
> 		/* Check for existing destination. */
> 		hlist_for_each_entry(entry, node, &hash_table[dst_bucket].head, node) {
> 			if (entry->value == dst_value) {
> 				dest_in_use = true;
> 				break;
> 			}
> 		}
> 		if (dest_in_use) {
> 			stats.dests_in_use++;
> 			goto unlock_and_loop;
> 		}
> 
> 		if (same_bucket) {
> 			src_entry->value = dst_value;
> 			stats.moves++;
> 			goto unlock_and_loop;
> 		}
> 
> 		write_seqcount_begin(&table_seqcount);
> 		hlist_del_rcu(&src_entry->node);
> 		hlist_add_head_rcu(&src_entry->node, &hash_table[dst_bucket].head);
> 		src_entry->value = dst_value;
> 		write_seqcount_end(&table_seqcount);
> 
> 		stats.moves++;
> 
> unlock_and_loop:
> 		if (ops->write_unlock_buckets)
> 			ops->write_unlock_buckets(&hash_table[src_bucket],
> 			                          &hash_table[dst_bucket]);
> 	} while (!kthread_should_stop() && !err);
> 
> 	*stats_ret = stats;
> 
> 	while (!kthread_should_stop())
> 		schedule_timeout_interruptible(1);
> 	return err;
> }
> 
> static void spinlock_init_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	spin_lock_init(&bucket->spinlock);
> }
> 
> static void rwlock_init_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	rwlock_init(&bucket->rwlock);
> }
> 
> static void mutex_init_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	mutex_init(&bucket->mutex);
> }
> 
> static void spinlock_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	spin_lock(&bucket->spinlock);
> }
> 
> static void rwlock_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	read_lock(&bucket->rwlock);
> }
> 
> static void mutex_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	mutex_lock(&bucket->mutex);
> }
> 
> static void table_spinlock_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	spin_lock(&table_spinlock);
> }
> 
> static void table_rwlock_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	read_lock(&table_rwlock);
> }
> 
> static void table_mutex_read_lock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	mutex_lock(&table_mutex);
> }
> 
> static void spinlock_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	spin_unlock(&bucket->spinlock);
> }
> 
> static void rwlock_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	read_unlock(&bucket->rwlock);
> }
> 
> static void mutex_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	mutex_unlock(&bucket->mutex);
> }
> 
> static void table_spinlock_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	spin_unlock(&table_spinlock);
> }
> 
> static void table_rwlock_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	read_unlock(&table_rwlock);
> }
> 
> static void table_mutex_read_unlock_bucket(struct rcuhashbash_bucket *bucket)
> {
> 	mutex_unlock(&table_mutex);
> }
> 
> static void spinlock_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                         struct rcuhashbash_bucket *b2)
> {
> 	if (b1 == b2)
> 		spin_lock(&b1->spinlock);
> 	else if (b1 < b2) {
> 		spin_lock(&b1->spinlock);
> 		spin_lock_nested(&b2->spinlock, SINGLE_DEPTH_NESTING);
> 	} else {
> 		spin_lock(&b2->spinlock);
> 		spin_lock_nested(&b1->spinlock, SINGLE_DEPTH_NESTING);
> 	}
> }
> 
> static void rwlock_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                       struct rcuhashbash_bucket *b2)
> {
> 	if (b1 == b2)
> 		write_lock(&b1->rwlock);
> 	else if (b1 < b2) {
> 		write_lock(&b1->rwlock);
> 		write_lock(&b2->rwlock);
> 	} else {
> 		write_lock(&b2->rwlock);
> 		write_lock(&b1->rwlock);
> 	}
> }
> 
> static void mutex_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                      struct rcuhashbash_bucket *b2)
> {
> 	if (b1 == b2)
> 		mutex_lock(&b1->mutex);
> 	else if (b1 < b2) {
> 		mutex_lock(&b1->mutex);
> 		mutex_lock_nested(&b2->mutex, SINGLE_DEPTH_NESTING);
> 	} else {
> 		mutex_lock(&b2->mutex);
> 		mutex_lock_nested(&b1->mutex, SINGLE_DEPTH_NESTING);
> 	}
> }
> 
> static void table_spinlock_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                               struct rcuhashbash_bucket *b2)
> {
> 	spin_lock(&table_spinlock);
> }
> 
> static void table_rwlock_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                             struct rcuhashbash_bucket *b2)
> {
> 	write_lock(&table_rwlock);
> }
> 
> static void table_mutex_write_lock_buckets(struct rcuhashbash_bucket *b1,
>                                            struct rcuhashbash_bucket *b2)
> {
> 	mutex_lock(&table_mutex);
> }
> 
> static void spinlock_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                           struct rcuhashbash_bucket *b2)
> {
> 	spin_unlock(&b1->spinlock);
> 	if (b1 != b2)
> 		spin_unlock(&b2->spinlock);
> }
> 
> static void rwlock_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                         struct rcuhashbash_bucket *b2)
> {
> 	write_unlock(&b1->rwlock);
> 	if (b1 != b2)
> 		write_unlock(&b2->rwlock);
> }
> 
> static void mutex_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                        struct rcuhashbash_bucket *b2)
> {
> 	mutex_unlock(&b1->mutex);
> 	if (b1 != b2)
> 		mutex_unlock(&b2->mutex);
> }
> 
> static void table_spinlock_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                                 struct rcuhashbash_bucket *b2)
> {
> 	spin_unlock(&table_spinlock);
> }
> 
> static void table_rwlock_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                               struct rcuhashbash_bucket *b2)
> {
> 	write_unlock(&table_rwlock);
> }
> 
> static void table_mutex_write_unlock_buckets(struct rcuhashbash_bucket *b1,
>                                              struct rcuhashbash_bucket *b2)
> {
> 	mutex_unlock(&table_mutex);
> }
> 
> static struct rcuhashbash_ops all_ops[] = {
> 	{
> 		.reader_type = "nosync",
> 		.writer_type = "none",
> 		.reader_thread = rcuhashbash_reader_nosync,
> 		.writer_thread = NULL,
> 		.limit_writers = true,
> 		.max_writers = 0,
> 	},
> 	{
> 		.reader_type = "nosync_rcu_dereference",
> 		.writer_type = "none",
> 		.reader_thread = rcuhashbash_reader_nosync_rcu_dereference,
> 		.writer_thread = NULL,
> 		.limit_writers = true,
> 		.max_writers = 0,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "single",
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.limit_writers = true,
> 		.max_writers = 1,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "spinlock",
> 		.init_bucket = spinlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = spinlock_write_lock_buckets,
> 		.write_unlock_buckets = spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "rwlock",
> 		.init_bucket = rwlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = rwlock_write_lock_buckets,
> 		.write_unlock_buckets = rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "mutex",
> 		.init_bucket = mutex_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = mutex_write_lock_buckets,
> 		.write_unlock_buckets = mutex_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "table_spinlock",
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = table_spinlock_write_lock_buckets,
> 		.write_unlock_buckets = table_spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "table_rwlock",
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = table_rwlock_write_lock_buckets,
> 		.write_unlock_buckets = table_rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu",
> 		.writer_type = "table_mutex",
> 		.reader_thread = rcuhashbash_reader_rcu,
> 		.writer_thread = rcuhashbash_writer_rcu,
> 		.write_lock_buckets = table_mutex_write_lock_buckets,
> 		.write_unlock_buckets = table_mutex_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "single",
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.limit_writers = true,
> 		.max_writers = 1,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "spinlock",
> 		.init_bucket = spinlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = spinlock_write_lock_buckets,
> 		.write_unlock_buckets = spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "rwlock",
> 		.init_bucket = rwlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = rwlock_write_lock_buckets,
> 		.write_unlock_buckets = rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "mutex",
> 		.init_bucket = mutex_init_bucket,
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = mutex_write_lock_buckets,
> 		.write_unlock_buckets = mutex_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "table_spinlock",
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = table_spinlock_write_lock_buckets,
> 		.write_unlock_buckets = table_spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "table_rwlock",
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = table_rwlock_write_lock_buckets,
> 		.write_unlock_buckets = table_rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rcu_seq",
> 		.writer_type = "table_mutex",
> 		.reader_thread = rcuhashbash_reader_rcu_seq,
> 		.writer_thread = rcuhashbash_writer_rcu_seq,
> 		.write_lock_buckets = table_mutex_write_lock_buckets,
> 		.write_unlock_buckets = table_mutex_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "spinlock",
> 		.writer_type = "spinlock",
> 		.init_bucket = spinlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = spinlock_read_lock_bucket,
> 		.read_unlock_bucket = spinlock_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = spinlock_write_lock_buckets,
> 		.write_unlock_buckets = spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "rwlock",
> 		.writer_type = "rwlock",
> 		.init_bucket = rwlock_init_bucket,
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = rwlock_read_lock_bucket,
> 		.read_unlock_bucket = rwlock_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = rwlock_write_lock_buckets,
> 		.write_unlock_buckets = rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "mutex",
> 		.writer_type = "mutex",
> 		.init_bucket = mutex_init_bucket,
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = mutex_read_lock_bucket,
> 		.read_unlock_bucket = mutex_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = mutex_write_lock_buckets,
> 		.write_unlock_buckets = mutex_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "table_spinlock",
> 		.writer_type = "table_spinlock",
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = table_spinlock_read_lock_bucket,
> 		.read_unlock_bucket = table_spinlock_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = table_spinlock_write_lock_buckets,
> 		.write_unlock_buckets = table_spinlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "table_rwlock",
> 		.writer_type = "table_rwlock",
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = table_rwlock_read_lock_bucket,
> 		.read_unlock_bucket = table_rwlock_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = table_rwlock_write_lock_buckets,
> 		.write_unlock_buckets = table_rwlock_write_unlock_buckets,
> 	},
> 	{
> 		.reader_type = "table_mutex",
> 		.writer_type = "table_mutex",
> 		.reader_thread = rcuhashbash_reader_lock,
> 		.read_lock_bucket = table_mutex_read_lock_bucket,
> 		.read_unlock_bucket = table_mutex_read_unlock_bucket,
> 		.writer_thread = rcuhashbash_writer_lock,
> 		.write_lock_buckets = table_mutex_write_lock_buckets,
> 		.write_unlock_buckets = table_mutex_write_unlock_buckets,
> 	},
> };
> 
> static struct rcuhashbash_ops *ops;
> 
> static void rcuhashbash_print_stats(void)
> {
> 	int i;
> 	struct reader_stats rs = { 0 };
> 	struct writer_stats ws = { 0 };
> 
> 	if (!reader_stats) {
> 		printk(KERN_ALERT "rcuhashbash stats unavailable\n");
> 		return;
> 	}
> 
> 	for (i = 0; i < readers; i++) {
> 		rs.hits += reader_stats[i].hits;
> 		rs.misses += reader_stats[i].misses;
> 	}
> 
> 	for (i = 0; i < writers; i++) {
> 		ws.moves += writer_stats[i].moves;
> 		ws.dests_in_use += writer_stats[i].dests_in_use;
> 		ws.misses += writer_stats[i].misses;
> 	}
> 
> 	printk(KERN_ALERT "rcuhashbash summary: readers=%d reader_type=%s writers=%d writer_type=%s\n"
> 	       KERN_ALERT "rcuhashbash summary: buckets=%lu entries=%lu reader_range=%lu writer_range=%lu\n"
> 	       KERN_ALERT "rcuhashbash summary: writers: %llu moves, %llu dests in use, %llu misses\n"
> 	       KERN_ALERT "rcuhashbash summary: readers: %llu hits, %llu misses\n",
> 	       readers, reader_type, writers, writer_type,
> 	       buckets, entries, reader_range, writer_range,
> 	       ws.moves, ws.dests_in_use, ws.misses,
> 	       rs.hits, rs.misses);
> }
> 
> static void rcuhashbash_exit(void)
> {
> 	unsigned long i;
> 	int ret;
> 
> 	if (writer_tasks) {
> 		for (i = 0; i < writers; i++)
> 			if (writer_tasks[i]) {
> 				ret = kthread_stop(writer_tasks[i]);
> 				if(ret)
> 					printk(KERN_ALERT "rcuhashbash writer returned error %d\n", ret);
> 			}
> 		kfree(writer_tasks);
> 	}
> 
> 	if (reader_tasks) {
> 		for (i = 0; i < readers; i++)
> 			if (reader_tasks[i]) {
> 				ret = kthread_stop(reader_tasks[i]);
> 				if(ret)
> 					printk(KERN_ALERT "rcuhashbash reader returned error %d\n", ret);
> 			}
> 		kfree(reader_tasks);
> 	}
> 
> 	/* Wait for all RCU callbacks to complete. */
> 	rcu_barrier();
> 
> 	if (hash_table) {
> 		for (i = 0; i < buckets; i++) {
> 			struct hlist_head *head = &hash_table[i].head;
> 			while (!hlist_empty(head)) {
> 				struct rcuhashbash_entry *entry;
> 				entry = hlist_entry(head->first, struct rcuhashbash_entry, node);
> 				hlist_del(head->first);
> 				kmem_cache_free(entry_cache, entry);
> 			}
> 		}
> 		kfree(hash_table);
> 	}
> 
> 	if (entry_cache)
> 		kmem_cache_destroy(entry_cache);
> 
> 	rcuhashbash_print_stats();
> 
> 	kfree(writer_stats);
> 	kfree(reader_stats);
> 
> 	printk(KERN_ALERT "rcuhashbash done\n");
> }
> 
> static __init int rcuhashbash_init(void)
> {
> 	int ret;
> 	u32 i;
> 
> 	for (i = 0; i < ARRAY_SIZE(all_ops); i++)
> 		if (strcmp(reader_type, all_ops[i].reader_type) == 0
> 		    && strcmp(writer_type, all_ops[i].writer_type) == 0) {
> 			ops = &all_ops[i];
> 		}
> 	if (!ops) {
> 		printk(KERN_ALERT "rcuhashbash: No implementation with %s reader and %s writer\n",
> 		       reader_type, writer_type);
> 		return -EINVAL;
> 	}
> 
> 	if (readers < 0)
> 		readers = num_online_cpus();
> 	if (writers < 0)
> 		writers = num_online_cpus();
> 	if (ops->limit_writers && writers > ops->max_writers) {
> 		printk(KERN_ALERT "rcuhashbash: %s writer implementation supports at most %d writers\n",
> 		       writer_type, ops->max_writers);
> 		return -EINVAL;
> 	}
> 
> 	if (readers > 0 && !ops->reader_thread) {
> 		printk(KERN_ALERT "rcuhashbash: Internal error: readers > 0 but reader thread NULL\n");
> 		return -EINVAL;
> 	}
> 	if (writers > 0 && !ops->writer_thread) {
> 		printk(KERN_ALERT "rcuhashbash: Internal error: writers > 0 but writer thread NULL\n");
> 		return -EINVAL;
> 	}
> 
> 	if (reader_range == 0)
> 		reader_range = 2*entries;
> 	if (writer_range == 0)
> 		writer_range = 2*entries;
> 
> 	entry_cache = KMEM_CACHE(rcuhashbash_entry, 0);
> 	if (!entry_cache)
> 		goto enomem;
> 
> 	hash_table = kcalloc(buckets, sizeof(hash_table[0]), GFP_KERNEL);
> 	if (!hash_table)
> 		goto enomem;
> 
> 	if (ops->init_bucket)
> 		for (i = 0; i < buckets; i++)
> 			ops->init_bucket(&hash_table[i]);
> 
> 	for (i = 0; i < entries; i++) {
> 		struct rcuhashbash_entry *entry;
> 		entry = kmem_cache_zalloc(entry_cache, GFP_KERNEL);
> 		if(!entry)
> 			goto enomem;
> 		entry->value = i;
> 		hlist_add_head(&entry->node, &hash_table[entry->value % buckets].head);
> 	}
> 
> 	reader_stats = kcalloc(readers, sizeof(reader_stats[0]), GFP_KERNEL);
> 	if (!reader_stats)
> 		goto enomem;
> 
> 	reader_tasks = kcalloc(readers, sizeof(reader_tasks[0]), GFP_KERNEL);
> 	if (!reader_tasks)
> 		goto enomem;
> 
> 	writer_stats = kcalloc(writers, sizeof(writer_stats[0]), GFP_KERNEL);
> 	if (!writer_stats)
> 		goto enomem;
> 
> 	writer_tasks = kcalloc(writers, sizeof(writer_tasks[0]), GFP_KERNEL);
> 	if (!writer_tasks)
> 		goto enomem;
> 
> 	printk(KERN_ALERT "rcuhashbash starting threads\n");
> 
> 	for (i = 0; i < readers; i++) {
> 		struct task_struct *task;
> 		task = kthread_run(ops->reader_thread, &reader_stats[i],
> 		                   "rcuhashbash_reader");
> 		if (IS_ERR(task)) {
> 			ret = PTR_ERR(task);
> 			goto error;
> 		}
> 		reader_tasks[i] = task;
> 	}
> 
> 	for (i = 0; i < writers; i++) {
> 		struct task_struct *task;
> 		task = kthread_run(ops->writer_thread, &writer_stats[i],
> 		                   "rcuhashbash_writer");
> 		if (IS_ERR(task)) {
> 			ret = PTR_ERR(task);
> 			goto error;
> 		}
> 		writer_tasks[i] = task;
> 	}
> 
> 	return 0;
> 
> enomem:
> 	ret = -ENOMEM;
> error:
> 	rcuhashbash_exit();
> 	return ret;
> }
> 
> module_init(rcuhashbash_init);
> module_exit(rcuhashbash_exit);
> /************************** End of rcuhashbash.c **************************/
> 
> Simple Makefile for building rcuhashbash:
> 
> ifneq ($(KERNELRELEASE),)
> obj-m := rcuhashbash.o
> else
> # Build against the current kernel, or use the environment variable KERNELDIR.
> KERNELDIR ?= /lib/modules/$(shell uname -r)/build
> %:
> 	$(MAKE) -C $(KERNELDIR) M=$(CURDIR) $@
> endif
> ############################## End of Makefile #############################
