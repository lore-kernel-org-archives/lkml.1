Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXBYGV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXBYGV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 01:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932782AbXBYGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 01:21:28 -0500
Received: from pool-71-111-73-6.ptldor.dsl-w.verizon.net ([71.111.73.6]:21656
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932773AbXBYGV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 01:21:26 -0500
Date: Sat, 24 Feb 2007 22:21:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070225062128.GA17339@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070223153743.GA26141@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 04:37:43PM +0100, Nick Piggin wrote:
> 
> The dentry hash uses up 8MB for 1 million entries on my 4GB system is one
> of the biggest wasters of memory for me. Because I rarely have more than one or
> two hundred thousand dentries. And that's with several kernel trees worth of
> entries. Most desktop and probably even many types of servers will only use a
> fraction of that.
> 
> So I introduce a new method for resizing hash tables with RCU, and apply
> that to the dentry hash.
> 
> The primitive heuristic is that the hash size is doubled when the number of
> entries reaches 150% the hash size, and halved when the number is 50%.
> It should also be able to shrink under memory pressure, and scale up as
> large as we go.
> 
> A pity it uses vmalloc memory for the moment.
> 
> The implementation is not highly stress tested, but it is running now. It
> could do a bit more RCU stuff asynchronously rather than with synchronize_rcu,
> but who cares, for now.
> 
> The hash is costing me about 256K now, which is a 32x reduction in memory.
> 
> I don't know if it's worthwhile to do this, rather than move things to other
> data structures, but something just tempted me to have a go!  I'd be interested
> to hear comments, and how many holes people can spot in my design ;)

The pseudocode looks sound to me.  The discussion on netdev has a few
alternatives that are interesting as well -- one of them gets rid of
the need for the sequence lock using a trick similar to one that Josh
Triplett came up with for atomically moving an element from one list
to another in face of RCU readers.  Another is Robert Ohlsson's "trash"
trie-hash implementation.

Some rather impressive algorithms all around!

							Thanx, Paul

> Thanks,
> Nick
> 
> 
> RCU hash resizing algorithm as follows:
> 
> There is a 2 pointer system, the regular hash table, and an "old" hash table
> pointer which is NULL except when resizing the hash.
> 
> When resizing the hash table, the pointer is set to the current table, and the
> regular hash table pointer is switched from the current table to a newly
> initialised hash table (so the current table becomes the old table, and the new
> table becomes the current table). Memory barriers are used so a reader won't
> find a NULL old table AND a new, empty current table.
> 
> Then we wait for a grace period, so that all readers can see this new
> world order. Readers are anybody who wants to get a handle on the hash table,
> including to add entries to it (ie. the data we're protecting is the actual
> table -- hash entry locking is pretty well decoupled from this algorithm).
> So any new insertions should be going into the current table at this point.
> 
> Now we start moving hash entries from the old table into the current table.
> This is done under a seqlock, and we can do it bit by bit, as time and
> latency allow... After all entries are moved, then we set the "old" pointer
> to NULL, wait for a grace period (now no readers will have a handle on it),
> then free it.
> 
> On the read side, we load the current hash pointer and the old hash pointer
> first (remember this has to happen under rcu_read_lock). Then everything
> happens as normal when the old pointer is NULL, which is the common case.
> If the old pointer is not NULL, we have to be prepared to search both hash
> tables to find the entry we want. We also have to do this under the read
> seqlock in case we miss an entry when it is being moved from the old table
> to the current table as part of the resize process.
> 
> NOTE: you can be creative with the seqlock. It could be several seqlocks, if
> performance under resize is important. It doesn't even have to be a seqlock,
> just something to give you synchronisation. Say if you have a spinlock per
> bucket: just hold locks for both buckets while doing the move from one to the
> other, and have the read-side search the old table first.
> 
> struct hash_table *table, *old_table;
> 
> lookup_hash()
> {
> 	struct hash_table *cur, *old;
> 
> 	rcu_read_lock();
> 	cur = table;
> 	smp_rmb();
> 	old = old_table;
> 
> 	if (unlikely(old)) {
> 		do {
> 			read_seqbegin();
> 			entry = search_table(cur);
> 			if (!entry)
> 				entry = search_table(old);
> 		} while (read_seqretry());
> 	} else {
> 		entry = search_table(cur);
> 	}
> 	rcu_read_unlock();
> }
> 
> resize_hash()
> {
> 	init(new_table, new_size);
> 
> 	old_table = table;
> 	smp_wmb();
> 	table = new_table;
> 	synchronize_rcu();
> 
> 	for_each_entry_in(entry, old_table) {
> 		write_seqlock();
> 		rehash(entry, new_table);
> 		write_sequnlock();
> 	}
> 
> 	tmp = old_table;
> 	old_table = NULL;
> 	synchronize_rcu();
> 	free(tmp);
> }
> 
> 
> 
>  fs/dcache.c |  324 +++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 243 insertions(+), 81 deletions(-)
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c
> +++ linux-2.6/fs/dcache.c
> @@ -20,6 +20,7 @@
>  #include <linux/fs.h>
>  #include <linux/fsnotify.h>
>  #include <linux/slab.h>
> +#include <linux/vmalloc.h>
>  #include <linux/init.h>
>  #include <linux/smp_lock.h>
>  #include <linux/hash.h>
> @@ -31,15 +32,18 @@
>  #include <linux/security.h>
>  #include <linux/seqlock.h>
>  #include <linux/swap.h>
> -#include <linux/bootmem.h>
> +#include <linux/mutex.h>
> +#include <linux/kthread.h>
>  #include "internal.h"
> 
> 
>  int sysctl_vfs_cache_pressure __read_mostly = 100;
>  EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
> 
> - __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
> +__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
>  static __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
> +static __cacheline_aligned_in_smp DEFINE_SEQLOCK(resize_transfer_lock);
> +static DEFINE_MUTEX(resize_mutex);
> 
>  EXPORT_SYMBOL(dcache_lock);
> 
> @@ -55,12 +59,22 @@ static struct kmem_cache *dentry_cache _
>   * This hash-function tries to avoid losing too many bits of hash
>   * information, yet avoid using a prime hash-size or similar.
>   */
> -#define D_HASHBITS     d_hash_shift
> -#define D_HASHMASK     d_hash_mask
> +struct dentry_hash {
> +	unsigned int shift;
> +	unsigned long mask;
> +	struct hlist_head *table;
> +};
> +
> +struct dentry_hash *dentry_hash __read_mostly;
> +struct dentry_hash *old_dentry_hash __read_mostly;
> +
> +#define MIN_DHASH_SHIFT 10 /* 4K */
> +#if BITS_PER_LONG == 32
> +#define MAX_DHASH_SHIFT 24 /* 64MB */
> +#else
> +#define MAX_DHASH_SHIFT 30 /* 8GB */
> +#endif
> 
> -static unsigned int d_hash_mask __read_mostly;
> -static unsigned int d_hash_shift __read_mostly;
> -static struct hlist_head *dentry_hashtable __read_mostly;
>  static LIST_HEAD(dentry_unused);
> 
>  /* Statistics gathering. */
> @@ -68,6 +82,20 @@ struct dentry_stat_t dentry_stat = {
>  	.age_limit = 45,
>  };
> 
> +static void dcache_hash_resize(unsigned int new_shift);
> +static void mod_nr_dentry(int mod)
> +{
> +	unsigned long dentry_size;
> +
> +	dentry_stat.nr_dentry += mod;
> +
> +	dentry_size = 1 << dentry_hash->shift;
> +	if (unlikely(dentry_stat.nr_dentry > dentry_size+(dentry_size>>1)))
> +		dcache_hash_resize(dentry_hash->shift+1);
> +	else if (unlikely(dentry_stat.nr_dentry < (dentry_size>>1)))
> +		dcache_hash_resize(dentry_hash->shift-1);
> +}
> +
>  static void __d_free(struct dentry *dentry)
>  {
>  	if (dname_external(dentry))
> @@ -201,7 +229,7 @@ kill_it: {
>    			dentry_stat.nr_unused--;
>    		}
>    		list_del(&dentry->d_u.d_child);
> -		dentry_stat.nr_dentry--;	/* For d_free, below */
> +		mod_nr_dentry(-1);	/* For d_free, below */
>  		/*drops the locks, at that point nobody can reach this dentry */
>  		dentry_iput(dentry);
>  		parent = dentry->d_parent;
> @@ -380,7 +408,7 @@ static void prune_one_dentry(struct dent
> 
>  	__d_drop(dentry);
>  	list_del(&dentry->d_u.d_child);
> -	dentry_stat.nr_dentry--;	/* For d_free, below */
> +	mod_nr_dentry(-1);		/* For d_free, below */
>  	dentry_iput(dentry);
>  	parent = dentry->d_parent;
>  	d_free(dentry);
> @@ -660,7 +688,7 @@ static void shrink_dcache_for_umount_sub
>  out:
>  	/* several dentries were freed, need to correct nr_dentry */
>  	spin_lock(&dcache_lock);
> -	dentry_stat.nr_dentry -= detached;
> +	mod_nr_dentry(-detached);
>  	spin_unlock(&dcache_lock);
>  }
> 
> @@ -916,7 +944,7 @@ struct dentry *d_alloc(struct dentry * p
>  	spin_lock(&dcache_lock);
>  	if (parent)
>  		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
> -	dentry_stat.nr_dentry++;
> +	mod_nr_dentry(1);
>  	spin_unlock(&dcache_lock);
> 
>  	return dentry;
> @@ -1057,12 +1085,12 @@ struct dentry * d_alloc_root(struct inod
>  	return res;
>  }
> 
> -static inline struct hlist_head *d_hash(struct dentry *parent,
> -					unsigned long hash)
> +static inline struct hlist_head *d_hash(struct dentry_hash *hashtable,
> +			struct dentry *parent, unsigned long hash)
>  {
>  	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
> -	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
> -	return dentry_hashtable + (hash & D_HASHMASK);
> +	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> hashtable->shift);
> +	return hashtable->table + (hash & hashtable->mask);
>  }
> 
>  /**
> @@ -1219,18 +1247,18 @@ struct dentry * d_lookup(struct dentry *
>  	return dentry;
>  }
> 
> -struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
> +static struct dentry * __d_lookup_hash(struct dentry_hash * hashtable,
> +				struct dentry * parent, struct qstr * name)
>  {
> -	unsigned int len = name->len;
>  	unsigned int hash = name->hash;
> +	unsigned int len = name->len;
>  	const unsigned char *str = name->name;
> -	struct hlist_head *head = d_hash(parent,hash);
> -	struct dentry *found = NULL;
>  	struct hlist_node *node;
> +	struct hlist_head *head;
>  	struct dentry *dentry;
> +	struct dentry *found = NULL;
> 
> -	rcu_read_lock();
> -	
> +	head = d_hash(hashtable, parent, hash);
>  	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
>  		struct qstr *qstr;
> 
> @@ -1273,9 +1301,39 @@ struct dentry * __d_lookup(struct dentry
>  next:
>  		spin_unlock(&dentry->d_lock);
>   	}
> +
> +	return found;
> +}
> +
> +struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
> +{
> +	struct dentry *ret;
> +	struct dentry_hash *hashtable, *old_hashtable;
> +
> +	rcu_read_lock();
> +	hashtable = dentry_hash;
> +	smp_rmb(); /* see smp_wmb in dcache_hash_resize_work */
> +	old_hashtable = old_dentry_hash;
> +
> +	if (unlikely(old_hashtable)) {
> +		unsigned long seq;
> +		do {
> +			seq = read_seqbegin(&resize_transfer_lock);
> +			ret = __d_lookup_hash(old_hashtable, parent, name);
> +			if (ret)
> +				goto out_rcu;
> +			ret = __d_lookup_hash(hashtable, parent, name);
> +			if (ret)
> +				goto out_rcu;
> +		} while (read_seqretry(&resize_transfer_lock, seq));
> +	} else {
> +		ret = __d_lookup_hash(hashtable, parent, name);
> +	}
> +
> +out_rcu:
>   	rcu_read_unlock();
> 
> - 	return found;
> + 	return ret;
>  }
> 
>  /**
> @@ -1304,6 +1362,28 @@ out:
>  	return dentry;
>  }
> 
> +static int d_validate_hash(struct dentry_hash *hashtable,
> +				struct dentry *dentry, struct dentry *parent)
> +{
> +	struct hlist_head *base;
> +	struct hlist_node *lhp;
> +
> +	base = d_hash(hashtable, parent, dentry->d_name.hash);
> +	spin_lock(&dcache_lock);
> +	hlist_for_each(lhp,base) {
> +		/* hlist_for_each_entry_rcu() not required for d_hash list
> +		 * as it is parsed under dcache_lock
> +		 */
> +		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
> +			__dget_locked(dentry);
> +			spin_unlock(&dcache_lock);
> +			return 1;
> +		}
> +	}
> +	spin_unlock(&dcache_lock);
> +	return 0;
> +}
> +
>  /**
>   * d_validate - verify dentry provided from insecure source
>   * @dentry: The dentry alleged to be valid child of @dparent
> @@ -1316,33 +1396,42 @@ out:
>   * Zero is returned in the dentry is invalid.
>   */
>   
> -int d_validate(struct dentry *dentry, struct dentry *dparent)
> +int d_validate(struct dentry *dentry, struct dentry *parent)
>  {
> -	struct hlist_head *base;
> -	struct hlist_node *lhp;
> +	struct dentry_hash *hashtable, *old_hashtable;
> +	int ret = 0;
> 
>  	/* Check whether the ptr might be valid at all.. */
>  	if (!kmem_ptr_validate(dentry_cache, dentry))
>  		goto out;
> 
> -	if (dentry->d_parent != dparent)
> +	if (dentry->d_parent != parent)
>  		goto out;
> 
> -	spin_lock(&dcache_lock);
> -	base = d_hash(dparent, dentry->d_name.hash);
> -	hlist_for_each(lhp,base) { 
> -		/* hlist_for_each_entry_rcu() not required for d_hash list
> -		 * as it is parsed under dcache_lock
> -		 */
> -		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
> -			__dget_locked(dentry);
> -			spin_unlock(&dcache_lock);
> -			return 1;
> -		}
> +	rcu_read_lock();
> +	hashtable = dentry_hash;
> +	smp_rmb(); /* see smp_wmb in dcache_hash_resize_work */
> +	old_hashtable = old_dentry_hash;
> +
> +	if (unlikely(old_hashtable)) {
> +		unsigned long seq;
> +		do {
> +			seq = read_seqbegin(&resize_transfer_lock);
> +			ret = d_validate_hash(old_hashtable, dentry, parent);
> +			if (ret)
> +				goto out_rcu;
> +			ret = d_validate_hash(hashtable, dentry, parent);
> +			if (ret)
> +				goto out_rcu;
> +		} while (read_seqretry(&resize_transfer_lock, seq));
> +	} else {
> +		ret = d_validate_hash(hashtable, dentry, parent);
>  	}
> -	spin_unlock(&dcache_lock);
> +
> +out_rcu:
> + 	rcu_read_unlock();
>  out:
> -	return 0;
> +	return ret;
>  }
> 
>  /*
> @@ -1402,7 +1491,9 @@ static void __d_rehash(struct dentry * e
> 
>  static void _d_rehash(struct dentry * entry)
>  {
> -	__d_rehash(entry, d_hash(entry->d_parent, entry->d_name.hash));
> +	rcu_read_lock();
> +	__d_rehash(entry, d_hash(dentry_hash, entry->d_parent, entry->d_name.hash));
> +	rcu_read_unlock();
>  }
> 
>  /**
> @@ -1518,8 +1609,10 @@ static void d_move_locked(struct dentry 
>  	hlist_del_rcu(&dentry->d_hash);
> 
>  already_unhashed:
> -	list = d_hash(target->d_parent, target->d_name.hash);
> +	rcu_read_lock();
> +	list = d_hash(dentry_hash, target->d_parent, target->d_name.hash);
>  	__d_rehash(dentry, list);
> +	rcu_read_unlock();
> 
>  	/* Unhash the target: dput() will then get rid of it */
>  	__d_drop(target);
> @@ -2009,42 +2102,114 @@ ino_t find_inode_number(struct dentry *d
>  	return ino;
>  }
> 
> -static __initdata unsigned long dhash_entries;
> -static int __init set_dhash_entries(char *str)
> +static unsigned int resize_new_shift;
> +
> +static void dcache_hash_resize_work(struct work_struct *work)
>  {
> -	if (!str)
> -		return 0;
> -	dhash_entries = simple_strtoul(str, &str, 0);
> -	return 1;
> +	unsigned long new_size, old_size;
> +	int i;
> +	struct dentry_hash *new_hash, *old_hash;
> +	unsigned long transferred;
> +
> +	if (!mutex_trylock(&resize_mutex))
> +		goto out;
> +
> +	new_hash = kmalloc(sizeof(struct dentry_hash), GFP_KERNEL);
> +	if (!new_hash)
> +		goto out_unlock;
> +
> +	new_hash->shift = resize_new_shift;
> +	new_size = 1 << new_hash->shift;
> +	new_hash->mask = new_size - 1;
> +	new_hash->table = vmalloc(new_size*sizeof(struct hlist_head));
> +	if (!new_hash->table)
> +		goto out_kfree;
> +	for (i = 0; i < new_size; i++)
> +		INIT_HLIST_HEAD(&new_hash->table[i]);
> +
> +	old_dentry_hash = dentry_hash;
> +	/*
> +	 * ensure that if the reader sees the new dentry_hash,
> +	 * then they will also see the old_dentry_hash assignment,
> +	 * above.
> +	 */
> +	smp_wmb();
> +	dentry_hash = new_hash;
> +	synchronize_rcu();
> +
> +	old_size = 1 << old_dentry_hash->shift;
> +	transferred = 0;
> +	for (i = 0; i < old_size; i++) {
> +		struct hlist_head *head = &old_dentry_hash->table[i];
> +
> +		if (hlist_empty(head))
> +			continue;
> +
> +		spin_lock(&dcache_lock);
> +		write_seqlock(&resize_transfer_lock);
> +		while (!hlist_empty(head)) {
> +			struct dentry *dentry;
> +			struct hlist_head *new_head;
> +
> +			dentry = hlist_entry(head->first, struct dentry, d_hash);
> +			new_head = d_hash(dentry_hash, dentry->d_parent, dentry->d_name.hash);
> +
> +			spin_lock(&dentry->d_lock);
> +			hlist_del_rcu(head->first);
> + 			hlist_add_head_rcu(&dentry->d_hash, new_head);
> +			spin_unlock(&dentry->d_lock);
> +			transferred++;
> +		}
> +		write_sequnlock(&resize_transfer_lock);
> +		spin_unlock(&dcache_lock);
> +	}
> +
> +	printk("resize dcache hash from %lu to %lu, moved %lu entries\n", old_size, new_size, transferred);
> +
> +	old_hash = old_dentry_hash;
> +	old_dentry_hash = NULL;
> +	mutex_unlock(&resize_mutex);
> +	synchronize_rcu();
> +	vfree(old_hash->table);
> +	kfree(old_hash);
> +
> +	resize_new_shift = 0;
> +	return;
> +
> +out_kfree:
> +	kfree(new_hash);
> +out_unlock:
> +	mutex_unlock(&resize_mutex);
> +out:
> +	resize_new_shift = 0;
> +	return;
>  }
> -__setup("dhash_entries=", set_dhash_entries);
> 
> -static void __init dcache_init_early(void)
> +static DEFINE_SPINLOCK(resize_lock);
> +
> +static void dcache_hash_resize(unsigned int new_shift)
>  {
> -	int loop;
> +	static DECLARE_WORK(resize_work, dcache_hash_resize_work);
> 
> -	/* If hashes are distributed across NUMA nodes, defer
> -	 * hash allocation until vmalloc space is available.
> -	 */
> -	if (hashdist)
> +	if (new_shift < MIN_DHASH_SHIFT || new_shift > MAX_DHASH_SHIFT)
>  		return;
> 
> -	dentry_hashtable =
> -		alloc_large_system_hash("Dentry cache",
> -					sizeof(struct hlist_head),
> -					dhash_entries,
> -					13,
> -					HASH_EARLY,
> -					&d_hash_shift,
> -					&d_hash_mask,
> -					0);
> +	if (resize_new_shift)
> +		return;
> +	spin_lock(&resize_lock);
> +	if (resize_new_shift) {
> +		spin_unlock(&resize_lock);
> +		return;
> +	}
> +	resize_new_shift = new_shift;
> +	spin_unlock(&resize_lock);
> 
> -	for (loop = 0; loop < (1 << d_hash_shift); loop++)
> -		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
> +	schedule_work(&resize_work);
>  }
> 
>  static void __init dcache_init(unsigned long mempages)
>  {
> +	unsigned long hash_size;
>  	int loop;
> 
>  	/* 
> @@ -2061,22 +2226,20 @@ static void __init dcache_init(unsigned 
>  	
>  	set_shrinker(DEFAULT_SEEKS, shrink_dcache_memory);
> 
> -	/* Hash may have been set up in dcache_init_early */
> -	if (!hashdist)
> -		return;
> -
> -	dentry_hashtable =
> -		alloc_large_system_hash("Dentry cache",
> -					sizeof(struct hlist_head),
> -					dhash_entries,
> -					13,
> -					0,
> -					&d_hash_shift,
> -					&d_hash_mask,
> -					0);
> +	old_dentry_hash = NULL;
> 
> -	for (loop = 0; loop < (1 << d_hash_shift); loop++)
> -		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
> +	dentry_hash = kmalloc(sizeof(struct dentry_hash), GFP_ATOMIC);
> +	if (!dentry_hash)
> +		panic("Failed to allocate dentry_hash\n");
> +	dentry_hash->shift = MIN_DHASH_SHIFT;
> +	hash_size = 1 << dentry_hash->shift;
> +	dentry_hash->mask = hash_size - 1;
> +	dentry_hash->table = __vmalloc(hash_size*sizeof(struct hlist_head),
> +					GFP_ATOMIC, PAGE_KERNEL);
> +	if (!dentry_hash->table)
> +		panic("Failed to allocate dentry_hash->table\n");
> +	for (loop = 0; loop < hash_size; loop++)
> +		INIT_HLIST_HEAD(&dentry_hash->table[loop]);
>  }
> 
>  /* SLAB cache for __getname() consumers */
> @@ -2089,7 +2252,6 @@ EXPORT_SYMBOL(d_genocide);
> 
>  void __init vfs_caches_init_early(void)
>  {
> -	dcache_init_early();
>  	inode_init_early();
>  }
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
