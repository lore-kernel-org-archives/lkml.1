Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYKDVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYKDVJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYKDVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:09:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110AbYKDVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:09:32 -0500
Date: Tue, 4 Nov 2008 13:09:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: cl@linux-foundation.org, npiggin@suse.de, peterz@infradead.org,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
Message-Id: <20081104130918.bee16cff.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0810300310180.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0810300310180.18283@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 12:23:11 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> From: Christoph Lameter <cl@linux-foundation.org>
> 
> In a NUMA system it is helpful to know where the dirty pages of a mapping
> are located.  That way we will be able to implement writeout for
> applications that are constrained to a portion of the memory of the
> system as required by cpusets.
> 
> This patch implements the management of dirty node maps for an address
> space through the following functions:
> 
> cpuset_clear_dirty_nodes(mapping)	Clear the map of dirty nodes
> 
> cpuset_update_nodes(mapping, page)	Record a node in the dirty nodes
> 					map
> 
> cpuset_init_dirty_nodes(mapping)	Initialization of the map
> 
> 
> The dirty map may be stored either directly in the mapping (for NUMA
> systems with less then BITS_PER_LONG nodes) or separately allocated for
> systems with a large number of nodes (f.e. ia64 with 1024 nodes).
> 
> Updating the dirty map may involve allocating it first for large
> configurations.  Therefore, we protect the allocation and setting of a
> node in the map through the tree_lock.  The tree_lock is already taken
> when a page is dirtied so there is no additional locking overhead if we
> insert the updating of the nodemask there.
> 
> The dirty map is only cleared (or freed) when the inode is cleared.  At
> that point no pages are attached to the inode anymore and therefore it
> can be done without any locking. The dirty map therefore records all nodes
> that have been used for dirty pages by that inode until the inode is no
> longer used.
> 
> If the mapping for an inode's set of dirty nodes does not intersect the
> set under writeback, the inode is requeued for later.  This is the
> mechanism for enforcing the writeback control's set of nodes policy.
> 
> ...
> 
> +/*
> + * We need macros since struct address_space is not defined yet

sigh.  Thanks for adding the comment.

> + */
> +#if MAX_NUMNODES <= BITS_PER_LONG
> +#define cpuset_init_dirty_nodes(__mapping)				\
> +	(__mapping)->dirty_nodes = NODE_MASK_NONE
> +
> +#define cpuset_update_dirty_nodes(__mapping, __page)			\
> +	node_set(page_to_nid(__page), (__mapping)->dirty_nodes);
> +
> +#define cpuset_clear_dirty_nodes(__mapping)				\
> +	(__mapping)->dirty_nodes = NODE_MASK_NONE
> +
> +#define cpuset_intersects_dirty_nodes(__mapping, __nodemask_ptr)	\
> +	(!(__nodemask_ptr) ||						\
> +	 nodes_intersects((__mapping)->dirty_nodes, *(__nodemask_ptr)))

This macro can evaluate __nodemask_ptr one or two times, possibly
causing code bloat, performance loss or bugs.  Copying it into a local
would fix that.

> +#else
> +struct address_space;

When forward-declaring structures like this I'd suggest that the
declaration be put right at the top of the header file, outside ifdefs.

Because putting it inside an ifdef is just inviting compilation errors
later on when someone assumes that address_space was declared and
didn't test all config options.

And put it at the top of the file because some unobservant person might
later add more code to the header ahead of the address_space
declaration which needs address_space.  So they go and add a second
forward declaration of the same thing.  We've had that happen before.

> +#define cpuset_init_dirty_nodes(__mapping)				\
> +	(__mapping)->dirty_nodes = NULL

I think there are ways in which this sort of macro can cause
compilation errors or even bugs.  I forget all the scenarios, but we do
know that whapping a `do { ...  } while (0)' around it fixes them.

> +extern void cpuset_update_dirty_nodes(struct address_space *mapping,
> +				      struct page *page);
> +extern void cpuset_clear_dirty_nodes(struct address_space *mapping);
> +extern int cpuset_intersects_dirty_nodes(struct address_space *mapping,
> +					 nodemask_t *mask);
> +#endif
> +
>  #else /* !CONFIG_CPUSETS */
>  
>  static inline int cpuset_init_early(void) { return 0; }
> @@ -163,6 +193,27 @@ static inline void rebuild_sched_domains(void)
>  	partition_sched_domains(1, NULL, NULL);
>  }
>  
> +struct address_space;
> +
> +static inline void cpuset_init_dirty_nodes(struct address_space *mapping)
> +{
> +}
> +
> +static inline void cpuset_update_dirty_nodes(struct address_space *mapping,
> +					     struct page *page)
> +{
> +}

OK, what's ging on here?  I count _three_ definitions of
cpuset_update_dirty_nodes().  One is a macro, one is a static inline
stub, one is an out-of-line C function.

What's up with that?  Maybe `#if MAX_NUMNODES > BITS_PER_LONG' added
the third leg?

> +static inline void cpuset_clear_dirty_nodes(struct address_space *mapping)
> +{
> +}
> +
> +static inline int cpuset_intersects_dirty_nodes(struct address_space *mapping,
> +						nodemask_t *mask)
> +{
> +	return 1;
> +}
> +
>  #endif /* !CONFIG_CPUSETS */
>  
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -544,6 +544,13 @@ struct address_space {
>  	spinlock_t		private_lock;	/* for use by the address_space */
>  	struct list_head	private_list;	/* ditto */
>  	struct address_space	*assoc_mapping;	/* ditto */
> +#ifdef CONFIG_CPUSETS
> +#if MAX_NUMNODES <= BITS_PER_LONG
> +	nodemask_t		dirty_nodes;	/* nodes with dirty pages */
> +#else
> +	nodemask_t		*dirty_nodes;	/* pointer to mask, if dirty */
> +#endif
> +#endif
>  } __attribute__((aligned(sizeof(long))));

eek.  Increasing the size of the address_space (and hence of the inode)
is a moderately big deal - there can be millions of these in memory.

Which gets me thinking...

Many inodes don't have any pagecache.  ext3 directories, anything which
was read via stat(), for a start.  Would it be worthwhile optimising
for this?

Options would include

- remove inode.i_data and dynamically allocate it.

- move your dirty_nodes thing into radix_tree_node, dynamically
  allocate address_space.page_tree (and tree_lock).

- etc.

There's a little project for someone to be going on with.


>  	/*
>  	 * On most architectures that alignment is already the case; but
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -72,6 +72,8 @@ struct writeback_control {
>  	 * so we use a single control to update them
>  	 */
>  	unsigned no_nrwrite_index_update:1;
> +
> +	nodemask_t *nodes;		/* Nodemask to writeback */

This one doesn't get ifdefs?

>  };
>  
>  /*
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -16,6 +16,7 @@
>   *  2006 Rework by Paul Menage to use generic cgroups
>   *  2008 Rework of the scheduler domains and CPU hotplug handling
>   *       by Max Krasnyansky
> + *  2008 Cpuset writeback by Christoph Lameter
>   *
>   *  This file is subject to the terms and conditions of the GNU General Public
>   *  License.  See the file COPYING in the main directory of the Linux
> @@ -2323,6 +2324,58 @@ int cpuset_mem_spread_node(void)
>  }
>  EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
>  
> +#if MAX_NUMNODES > BITS_PER_LONG
> +/*
> + * Special functions for NUMA systems with a large number of nodes.  The
> + * nodemask is pointed to from the address_space structure.  The attachment of
> + * the dirty_nodes nodemask is protected by the tree_lock.  The nodemask is
> + * freed only when the inode is cleared (and therefore unused, thus no locking
> + * is necessary).
> + */
> +void cpuset_update_dirty_nodes(struct address_space *mapping,
> +			       struct page *page)
> +{
> +	nodemask_t *nodes = mapping->dirty_nodes;
> +	int node = page_to_nid(page);
> +
> +	if (!nodes) {
> +		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);

erk, OK, called from __set_page_dirty, needs to be atomic.

What are the consequences when this allocation fails?

I prefer `foo = kmalloc(sizeof(*foo), ...)', personally.  It avoids
duplicating information and means that PoorOldReviewer doesn't have to
crawl back through the code checking that NastyYoungCoder got the type
right.


