Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbYHOUfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbYHOUfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbYHOUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:35:04 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:55436 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461AbYHOUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ricve04SPgslNHMx26bOPqEt/NzxXJCscmJxzglV4eRPSk6TE5W07Ae9+yupcOgGX3
         2P9BGNEhcDFVJQsfID3CJVsBLgPBek1FaCZsloZF6rHggfwF4JgXM2mDbXtahX83E64c
         P3edDRGZFgUtByqGY4m373D/FV20grxgn4wv8=
Message-ID: <48A5E7EB.6020000@gmail.com>
Date: Fri, 15 Aug 2008 16:32:43 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, David.Holmes@sun.com, jkacur@gmail.com
Subject: Re: [PATCH RT RFC v4 1/8] add generalized priority-inheritance interface
References: <20080815202408.668.23736.stgit@dev.haskins.net> <20080815202823.668.26199.stgit@dev.haskins.net>
In-Reply-To: <20080815202823.668.26199.stgit@dev.haskins.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> The kernel currently addresses priority-inversion through priority-
> inheritence.  However, all of the priority-inheritence logic is
> integrated into the Real-Time Mutex infrastructure.  This causes a few
> problems:
>
>  1) This tightly coupled relationship makes it difficult to extend to
>     other areas of the kernel (for instance, pi-aware wait-queues may
>     be desirable).
>  2) Enhancing the rtmutex infrastructure becomes challenging because
>     there is no seperation between the locking code, and the pi-code.
>
> This patch aims to rectify these shortcomings by designing a stand-alone
> pi framework which can then be used to replace the rtmutex-specific
> version.  The goal of this framework is to provide similar functionality
> to the existing subsystem, but with sole focus on PI and the
> relationships between objects that can boost priority, and the objects
> that get boosted.
>
> We introduce the concept of a "pi_source" and a "pi_sink", where, as the
> name suggests provides the basic relationship of a priority source, and
> its boosted target.  A pi_source acts as a reference to some arbitrary
> source of priority, and a pi_sink can be boosted (or deboosted) by
> a pi_source.  For more details, please read the library documentation.
>
> There are currently no users of this inteface.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  Documentation/libpi.txt |   59 ++++++
>  include/linux/pi.h      |  293 ++++++++++++++++++++++++++++
>  lib/Makefile            |    3 
>  lib/pi.c                |  489 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 843 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/libpi.txt
>  create mode 100644 include/linux/pi.h
>  create mode 100644 lib/pi.c
>
> diff --git a/Documentation/libpi.txt b/Documentation/libpi.txt
> new file mode 100644
> index 0000000..197b21a
> --- /dev/null
> +++ b/Documentation/libpi.txt
> @@ -0,0 +1,59 @@
> +﻿lib/pi.c - Priority Inheritance library
> +
> +Sources and sinks:
> +------------
> +
> +This library introduces the basic concept of a "pi_source" and a "pi_sink", where, as the name suggests provides the basic relationship of a priority source, and its boosted target.
> +
> +A pi_source is simply a reference to some arbitrary priority value that may range from 0 (highest prio), to MAX_PRIO (currently 140, lowest prio).  A pi_source calls pi_sink.boost() whenever it wishes to boost the sink to (at least minimally) the priority value that the source represents.  It uses pi_sink.boost() for both the initial boosting, or for any subsequent refreshes to the value (even if the value is decreasing in logical priority).  The policy of the sink will dictate what happens as a result of that boost.  Likewise, a pi_source calls pi_sink.deboost() to stop contributing to the sink's minimum priority.
> +
> +It is important to note that a source is a reference to a priority value, not a value itself.  This is one of the concepts that allows the interface to be idempotent, which is important for properly updating a chain of sources and sinks in the proper order.  If we passed the priority on the stack, the order in which the system executes could allow the actual value that is set to race.
> +
> +Nodes:
> +
> +A pi_node is a convenience object which is simultaneously a source and a sink.  As its name suggests, it would typically be deployed as a node in a pi-chain.  Other pi_sources can boost a node via its pi_sink.boost() interface.  Likewise, a node can boost a fixed number of sinks via the node.add_sink() interface.
> +
> +Generally speaking, a node takes care of many common operations associated with being a “link in the chain”, such as:
> +
> +	1) determining the current priority of the node based on the (logically) highest priority source that is boosting the node.
> +	2) boosting/deboosting upstream sinks whenever the node locally changes priority.
> +	3) taking care to avoid deadlock during a chain update.
> +
> +Design details:
> +
> +Destruction:
> +
> +The pi-library objects are designed to be implicitly-destructable (meaning they do not require an explicit “free()” operation when they are not used anymore).  This is important considering their intended use (spinlock_t's which are also implicitly-destructable).  As such, any allocations needed for operation must come from internal structure storage as there will be no opportunity to free it later.
> +
> +Multiple sinks per Node:
> +
> +We allow multiple sinks to be associated with a node.  This is a slight departure from the previous implementation which had the notion of only a single sink (i.e. “task->pi_blocked_on”).  The reason why we added the ability to add more than one sink was not to change the default chaining model (I.e. multiple boost targets), but rather to add a flexible notification mechanism that is peripheral to the chain, which are informally called “leaf sinks”.
> +
> +Leaf-sinks are boostable objects that do not perpetuate a chain per se.  Rather, they act as endpoints to a priority boosting.  Ultimately, every chain ends with a leaf-sink, which presumably will act on the new priority information.  However, there may be any number of leaf-sinks along a chain as well.  Each one will act on its localized priority in its own implementation specific way.  For instance, a task_struct pi-leaf may change the priority of the task and reschedule it if necessary.  Whereas an rwlock leaf-sink may boost a list of reader-owners.
> +
> +The following diagram depicts an example relationship (warning: cheesy ascii art)
> +
> +                   ---------       ---------
> +                   | leaf  |       | leaf  |
> +                   ---------       ---------
> +                  /	          /	    
> +     ---------   / ----------    / ---------     ---------
> +  ->-| node  |->---| node   |-->---| node  |->---| leaf  |
> +     ---------     ----------      ---------     ---------
> +
> +The reason why this was done was to unify the notion of a “sink” to a single interface, rather than having something like task->pi_blocks_on and a separate callback for the leaf action.  Instead, any downstream object can be represented by a sink, and the implementation details are hidden (e.g. im a task, im a lock, im a node, im a work-item, im a wait-queue, etc).
> +
> +Sinkrefs:
> +
> +Each pi_sink.boost() operation is represented by a unique pi_source to properly facilitate a one node to many source relationship.  Therefore, if a pi_node is to act as aggregator to multiple sinks, it implicitly must have one internal pi_source object for every sink that is added (via node.add_sink().  This pi_source object has to be internally managed for the lifetime of the sink reference.
> +
> +Recall that due to the implicit-destruction requirement above, and the fact that we will typically be executing in a preempt-disabled region, we have to be very careful about how we allocate references to those sinks.  More on that next.  But long story short we limit the number of sinks to MAX_PI_DEPENDENDICES (currently 5).
> +
> +Locking:
> +
> +(work in progress....)
> +
> +
> +
> +
> +
> diff --git a/include/linux/pi.h b/include/linux/pi.h
> new file mode 100644
> index 0000000..5535474
> --- /dev/null
> +++ b/include/linux/pi.h
> @@ -0,0 +1,293 @@
> +/*
> + * see Documentation/libpi.txt for details
> + */
> +
> +#ifndef _LINUX_PI_H
> +#define _LINUX_PI_H
> +
> +#include <linux/list.h>
> +#include <linux/plist.h>
> +#include <asm/atomic.h>
> +
> +#define MAX_PI_DEPENDENCIES 5
> +
> +struct pi_source {
> +	struct plist_node  list;
> +	int               *prio;
> +	int                boosted;
> +};
> +
> +
> +#define PI_FLAG_DEFER_UPDATE     (1 << 0)
> +#define PI_FLAG_ALREADY_BOOSTED  (1 << 1)
> +
> +struct pi_sink;
> +
> +struct pi_sink_ops {
> +	int (*boost)(struct pi_sink *sink, struct pi_source *src,
> +		     unsigned int flags);
> +	int (*deboost)(struct pi_sink *sink, struct pi_source *src,
> +		       unsigned int flags);
> +	int (*update)(struct pi_sink *sink,
> +		      unsigned int flags);
> +	int (*free)(struct pi_sink *sink,
> +		      unsigned int flags);
> +};
> +
> +struct pi_sink {
> +	atomic_t            refs;
> +	struct pi_sink_ops *ops;
> +};
> +
> +enum pi_state {
> +	pi_state_boost,
> +	pi_state_boosted,
> +	pi_state_deboost,
> +	pi_state_free,
> +};
> +
> +/*
> + * NOTE: PI must always use a true (e.g. raw) spinlock, since it is used by
> + * rtmutex infrastructure.
> + */
> +
> +struct pi_sinkref {
> +	raw_spinlock_t         lock;
> +	struct list_head       list;
> +	enum pi_state          state;
> +	struct pi_sink        *sink;
> +	struct pi_source       src;
> +	atomic_t               refs;
> +};
> +
> +struct pi_sinkref_pool {
> +	struct list_head       free;
> +	struct pi_sinkref      data[MAX_PI_DEPENDENCIES];
> +};
> +
> +struct pi_node {
> +	raw_spinlock_t         lock;
> +	int                    prio;
> +	struct pi_sink         sink;
> +	struct pi_sinkref_pool sinkref_pool;
> +	struct list_head       sinks;
> +	struct plist_head      srcs;
> +};
> +
> +/**
> + * pi_node_init - initialize a pi_node before use
> + * @node: a node context
> + */
> +extern void pi_node_init(struct pi_node *node);
> +
> +/**
> + * pi_add_sink - add a sink as an downstream object
> + * @node: the node context
> + * @sink: the sink context to add to the node
> + * @flags: optional flags to modify behavior
> + *   PI_FLAG_DEFER_UPDATE    - Do not perform sync update
> + *   PI_FLAG_ALREADY_BOOSTED - Do not perform initial boosting
> + *
> + * This function registers a sink to get notified whenever the
> + * node changes priority.
> + *
> + * Note: By default, this function will schedule the newly added sink
> + * to get an inital boost notification on the next update (even
> + * without the presence of a priority transition).  However, if the
> + * ALREADY_BOOSTED flag is specified, the sink is initially marked as
> + * BOOSTED and will only get notified if the node changes priority
> + * in the future.
> + *
> + * Note: By default, this function will synchronously update the
> + * chain unless the DEFER_UPDATE flag is specified.
> + *
> + * Returns: (int)
> + *   0 = success
> + *   any other value = failure
> + */
> +extern int pi_add_sink(struct pi_node *node, struct pi_sink *sink,
> +		       unsigned int flags);
> +
> +/**
> + * pi_del_sink - del a sink from the current downstream objects
> + * @node: the node context
> + * @sink: the sink context to delete from the node
> + * @flags: optional flags to modify behavior
> + *   PI_FLAG_DEFER_UPDATE    - Do not perform sync update
> + *
> + * This function unregisters a sink from the node.
> + *
> + * Note: The sink will not actually become fully deboosted until
> + * a call to node.update() successfully returns.
> + *
> + * Note: By default, this function will synchronously update the
> + * chain unless the DEFER_UPDATE flag is specified.
> + *
> + * Returns: (int)
> + *   0 = success
> + *   any other value = failure
> + */
> +extern int pi_del_sink(struct pi_node *node, struct pi_sink *sink,
> +		       unsigned int flags);
> +
> +/**
> + * pi_sink_init - initialize a pi_sink before use
> + * @sink: a sink context
> + * @ops: pointer to an pi_sink_ops structure
> + */
> +static inline void
> +pi_sink_init(struct pi_sink *sink, struct pi_sink_ops *ops)
> +{
> +	atomic_set(&sink->refs, 0);
> +	sink->ops = ops;
> +}
> +
> +/**
> + * pi_source_init - initialize a pi_source before use
> + * @src: a src context
> + * @prio: pointer to a priority value
> + *
> + * A pointer to a priority value is used so that boost and update
> + * are fully idempotent.
> + */
> +static inline void
> +pi_source_init(struct pi_source *src, int *prio)
> +{
> +	plist_node_init(&src->list, *prio);
> +	src->prio = prio;
> +	src->boosted = 0;
> +}
> +
> +/**
> + * pi_boost - boost a node with a pi_source
> + * @node: the node context
> + * @src: the src context to boost the node with
> + * @flags: optional flags to modify behavior
> + *   PI_FLAG_DEFER_UPDATE    - Do not perform sync update
> + *
> + * This function registers a priority source with the node, possibly
> + * boosting its value if the new source is the highest registered source.
> + *
> + * This function is used to both initially register a source, as well as
> + * to notify the node if the value changes in the future (even if the
> + * priority is decreasing).
> + *
> + * Note: By default, this function will synchronously update the
> + * chain unless the DEFER_UPDATE flag is specified.
> + *
> + * Returns: (int)
> + *   0 = success
> + *   any other value = failure
> + */
> +static inline int
> +pi_boost(struct pi_node *node, struct pi_source *src, unsigned int flags)
> +{
> +	struct pi_sink *sink = &node->sink;
> +
> +	if (sink->ops->boost)
> +		return sink->ops->boost(sink, src, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * pi_deboost - deboost a pi_source from a node
> + * @node: the node context
> + * @src: the src context to boost the node with
> + * @flags: optional flags to modify behavior
> + *   PI_FLAG_DEFER_UPDATE    - Do not perform sync update
> + *
> + * This function unregisters a priority source from the node, possibly
> + * deboosting its value if the departing source was the highest
> + * registered source.
> + *
> + * Note: By default, this function will synchronously update the
> + * chain unless the DEFER_UPDATE flag is specified.
> + *
> + * Returns: (int)
> + *   0 = success
> + *   any other value = failure
> + */
> +static inline int
> +pi_deboost(struct pi_node *node, struct pi_source *src, unsigned int flags)
> +{
> +	struct pi_sink *sink = &node->sink;
> +
> +	if (sink->ops->deboost)
> +		return sink->ops->deboost(sink, src, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * pi_update - force a manual chain update
> + * @node: the node context
> + * @flags: optional flags to modify behavior.  Reserved, must be 0.
> + *
> + * This function will push any priority changes (as a result of
> + * boost/deboost or add_sink/del_sink) down through the chain.
> + * If no changes are necessary, this function is a no-op.
> + *
> + * Returns: (int)
> + *   0 = success
> + *   any other value = failure
> + */
> +static inline int
> +pi_update(struct pi_node *node, unsigned int flags)
> +{
> +	struct pi_sink *sink = &node->sink;
> +
> +	if (sink->ops->update)
> +		return sink->ops->update(sink, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * pi_sink_put - down the reference count, freeing the sink if 0
> + * @node: the node context
> + * @flags: optional flags to modify behavior.  Reserved, must be 0.
> + *
> + * Returns: none
> + */
> +static inline void
> +pi_sink_put(struct pi_sink *sink, unsigned int flags)
> +{
> +	if (atomic_dec_and_test(&sink->refs)) {
> +		if (sink->ops->free)
> +			sink->ops->free(sink, flags);
> +	}
> +}
> +
> +
> +/**
> + * pi_get - up the reference count
> + * @node: the node context
> + * @flags: optional flags to modify behavior.  Reserved, must be 0.
> + *
> + * Returns: none
> + */
> +static inline void
> +pi_get(struct pi_node *node, unsigned int flags)
> +{
> +	struct pi_sink *sink = &node->sink;
> +
> +	atomic_inc(&sink->refs);
> +}
> +
> +/**
> + * pi_put - down the reference count, freeing the node if 0
> + * @node: the node context
> + * @flags: optional flags to modify behavior.  Reserved, must be 0.
> + *
> + * Returns: none
> + */
> +static inline void
> +pi_put(struct pi_node *node, unsigned int flags)
> +{
> +	struct pi_sink *sink = &node->sink;
> +
> +	pi_sink_put(sink, flags);
> +}
> +
> +#endif /* _LINUX_PI_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 5187924..df81ad7 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -23,7 +23,8 @@ lib-$(CONFIG_SMP) += cpumask.o
>  lib-y	+= kobject.o kref.o klist.o
>  
>  obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> -	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
> +	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> +	 pi.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
>  CFLAGS_kobject.o += -DDEBUG
> diff --git a/lib/pi.c b/lib/pi.c
> new file mode 100644
> index 0000000..d00042c
> --- /dev/null
> +++ b/lib/pi.c
> @@ -0,0 +1,489 @@
> +/*
> + *  lib/pi.c
> + *
> + *  Priority-Inheritance library
> + *
> + *  Copyright (C) 2008 Novell
> + *
> + *  Author: Gregory Haskins <ghaskins@novell.com>
> + *
> + *  This code provides a generic framework for preventing priority
> + *  inversion by means of priority-inheritance. (see Documentation/libpi.txt
> + *  for details)
> + *
> + *  This library is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  as published by the Free Software Foundation; version 2
> + *  of the License.
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/pi.h>
> +
> +
> +struct updater {
> +    int update;
> +    struct pi_sinkref *sinkref;
> +    struct pi_sink *sink;
> +};
> +
> +/*
> + *-----------------------------------------------------------
> + * pi_sinkref_pool
> + *-----------------------------------------------------------
> + */
> +
> +static void
> +pi_sinkref_pool_init(struct pi_sinkref_pool *pool)
> +{
> +	int i;
> +
> +	INIT_LIST_HEAD(&pool->free);
> +
> +	for (i = 0; i < MAX_PI_DEPENDENCIES; ++i) {
> +		struct pi_sinkref *sinkref = &pool->data[i];
> +
> +		memset(sinkref, 0, sizeof(*sinkref));
> +		INIT_LIST_HEAD(&sinkref->list);
> +		list_add_tail(&sinkref->list, &pool->free);
> +	}
> +}
> +
> +static struct pi_sinkref *
> +pi_sinkref_alloc(struct pi_sinkref_pool *pool)
> +{
> +	struct pi_sinkref *sinkref;
> +
> +	if (list_empty(&pool->free))
> +		return NULL;
> +
> +	sinkref = list_first_entry(&pool->free, struct pi_sinkref, list);
> +	list_del(&sinkref->list);
> +	memset(sinkref, 0, sizeof(*sinkref));
> +
> +	return sinkref;
> +}
> +
> +static void
> +pi_sinkref_free(struct pi_sinkref_pool *pool,
> +		  struct pi_sinkref *sinkref)
> +{
> +	list_add_tail(&sinkref->list, &pool->free);
> +}
> +
> +/*
> + *-----------------------------------------------------------
> + * pi_sinkref
> + *-----------------------------------------------------------
> + */
> +
> +static inline void
> +_pi_sink_get(struct pi_sinkref *sinkref)
> +{
> +	atomic_inc(&sinkref->sink->refs);
> +	atomic_inc(&sinkref->refs);
> +}
> +
> +static inline void
> +_pi_sink_put_local(struct pi_node *node, struct pi_sinkref *sinkref)
> +{
> +	if (atomic_dec_and_lock(&sinkref->refs, &node->lock)) {
> +		list_del(&sinkref->list);
> +		pi_sinkref_free(&node->sinkref_pool, sinkref);
> +		spin_unlock(&node->lock);
> +	}
> +}
> +
> +static inline void
> +_pi_sink_put_all(struct pi_node *node, struct pi_sinkref *sinkref)
> +{
> +	struct pi_sink *sink = sinkref->sink;
> +
> +	_pi_sink_put_local(node, sinkref);
> +	pi_sink_put(sink, 0);
> +}
> +
> +/*
> + *-----------------------------------------------------------
> + * pi_node
> + *-----------------------------------------------------------
> + */
> +
> +static struct pi_node *node_of(struct pi_sink *sink)
> +{
> +	return container_of(sink, struct pi_node, sink);
> +}
> +
> +static inline void
> +__pi_boost(struct pi_node *node, struct pi_source *src)
> +{
> +	BUG_ON(src->boosted);
> +
> +	plist_node_init(&src->list, *src->prio);
> +	plist_add(&src->list, &node->srcs);
> +	src->boosted = 1;
> +}
> +
> +static inline void
> +__pi_deboost(struct pi_node *node, struct pi_source *src)
> +{
> +	BUG_ON(!src->boosted);
> +
> +	plist_del(&src->list, &node->srcs);
> +	src->boosted = 0;
> +}
> +
> +/*
> + * _pi_node_update - update the chain
> + *
> + * We loop through up to MAX_PI_DEPENDENCIES times looking for stale entries
> + * that need to propagate up the chain.  This is a step-wise process where we
> + * have to be careful about locking and preemption.  By trying MAX_PI_DEPs
> + * times, we guarantee that this update routine is an effective barrier...
> + * all modifications made prior to the call to this barrier will have completed.
> + *
> + * Deadlock avoidance: This node may participate in a chain of nodes which
> + * form a graph of arbitrary structure.  While the graph should technically
> + * never close on itself barring any bugs, we still want to protect against
> + * a theoretical ABBA deadlock (if for nothing else, to prevent lockdep
> + * from detecting this potential).  To do this, we employ a dual-locking
> + * scheme where we can carefully control the order.  That is: node->lock
> + * protects most of the node's internal state, but it will never be held
> + * across a chain update.  sinkref->lock, on the other hand, can be held
> + * across a boost/deboost, and also guarantees proper execution order. Also
> + * note that no locks are held across an sink->update.
> + */
> +static int
> +_pi_node_update(struct pi_sink *sink, unsigned int flags)
> +{
> +	struct pi_node    *node = node_of(sink);
> +	struct pi_sinkref *sinkref;
> +	unsigned long      iflags;
> +	int                count = 0;
> +	int                i;
> +	int                pprio;
> +	struct updater     updaters[MAX_PI_DEPENDENCIES];
> +
> +	spin_lock_irqsave(&node->lock, iflags);
> +
> +	pprio = node->prio;
> +
> +	if (!plist_head_empty(&node->srcs))
> +		node->prio = plist_first(&node->srcs)->prio;
> +	else
> +		node->prio = MAX_PRIO;
> +
> +	list_for_each_entry(sinkref, &node->sinks, list) {
> +		/*
> +		 * If the priority is changing, or if this is a
> +		 * BOOST/DEBOOST, we consider this sink "stale"
> +		 */
> +		if (pprio != node->prio
> +		    || sinkref->state != pi_state_boosted) {
> +			struct updater *iter = &updaters[count++];
> +
> +			BUG_ON(!atomic_read(&sinkref->sink->refs));
> +			_pi_sink_get(sinkref);
> +
> +			iter->update  = 1;
> +			iter->sinkref = sinkref;
> +			iter->sink     = sinkref->sink;
> +		}
> +	}
> +
> +	spin_unlock(&node->lock);
> +
> +	for (i = 0; i < count; ++i) {
> +		struct updater    *iter = &updaters[i];
> +		unsigned int       lflags = PI_FLAG_DEFER_UPDATE;
> +		struct pi_sink    *sink;
> +
> +		sinkref = iter->sinkref;
> +		sink = iter->sink;
> +
> +		spin_lock(&sinkref->lock);
> +
> +		switch (sinkref->state) {
> +		case pi_state_boost:
> +			sinkref->state = pi_state_boosted;
> +			/* Fall through */
> +		case pi_state_boosted:
> +			sink->ops->boost(sink, &sinkref->src, lflags);
> +			break;
> +		case pi_state_deboost:
> +			sink->ops->deboost(sink, &sinkref->src, lflags);
> +			sinkref->state = pi_state_free;
> +
> +			/*
> +			 * drop the ref that we took when the sinkref
> +			 * was allocated.  We still hold a ref from
> +			 * above.
> +			 */
> +			_pi_sink_put_all(node, sinkref);
> +			break;
> +		case pi_state_free:
> +			iter->update = 0;
> +			break;
> +		default:
> +			panic("illegal sinkref type: %d", sinkref->state);
> +		}
> +
> +		spin_unlock(&sinkref->lock);
> +
> +		/*
> +		 * We will drop the sinkref reference while still holding the
> +		 * preempt/irqs off so that the memory is returned synchronously
> +		 * to the system.
> +		 */
> +		_pi_sink_put_local(node, sinkref);
> +	}
> +
> +	local_irq_restore(iflags);
> +
> +	/*
> +	 * Note: At this point, sinkref is invalid since we put'd
> +	 * it above, but sink is valid since we still hold the remote
> +	 * reference.  This is key to the design because it allows us
> +	 * to synchronously free the sinkref object, yet maintain a
> +	 * reference to the sink across the update
> +	 */
> +	for (i = 0; i < count; ++i) {
> +		struct updater *iter = &updaters[i];
> +
> +		if (iter->update)
> +			iter->sink->ops->update(iter->sink, 0);
> +	}
> +
> +	/*
> +	 * We perform all the free opertations together at the end, using
> +	 * only automatic/stack variables since any one of these operations
> +	 * could result in our node object being deallocated
> +	 */
> +	for (i = 0; i < count; ++i) {
> +		struct updater *iter = &updaters[i];
> +
> +		pi_sink_put(iter->sink, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +_pi_del_sink(struct pi_node *node, struct pi_sink *sink, unsigned int flags)
> +{
> +	struct pi_sinkref *sinkref;
> +	struct updater     updaters[MAX_PI_DEPENDENCIES];
> +	unsigned long      iflags;
> +	int                count = 0;
> +	int                i;
> +
> +	local_irq_save(iflags);
> +	spin_lock(&node->lock);
> +
> +	list_for_each_entry(sinkref, &node->sinks, list) {
> +		if (!sink || sink == sinkref->sink) {
> +			struct updater *iter = &updaters[count++];
> +
> +			_pi_sink_get(sinkref);
> +			iter->sinkref = sinkref;
> +			iter->sink    = sinkref->sink;
> +		}
> +	}
> +
> +	spin_unlock(&node->lock);
> +
> +	for (i = 0; i < count; ++i) {
> +		struct updater *iter   = &updaters[i];
> +		int             remove = 0;
> +
> +		sinkref = iter->sinkref;
> +
> +		spin_lock(&sinkref->lock);
> +
> +		switch (sinkref->state) {
> +		case pi_state_boost:
> +			/*
> +			 * This state indicates the sink was never formally
> +			 * boosted so we can just delete it immediately
> +			 */
> +			remove = 1;
> +			break;
> +		case pi_state_boosted:
> +			if (sinkref->sink->ops->deboost)
> +				/*
> +				 * If the sink supports deboost notification,
> +				 * schedule it for deboost at the next update
> +				 */
> +				sinkref->state = pi_state_deboost;
> +			else
> +				/*
> +				 * ..otherwise schedule it for immediate
> +				 * removal
> +				 */
> +				remove = 1;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (remove) {
> +			/*
> +			 * drop the ref that we took when the sinkref
> +			 * was allocated.  We still hold a ref from
> +			 * above
> +			 */
> +			_pi_sink_put_all(node, sinkref);
> +			sinkref->state = pi_state_free;
> +		}
> +
> +		spin_unlock(&sinkref->lock);
> +
> +		_pi_sink_put_local(node, sinkref);
> +	}
> +
> +	local_irq_restore(iflags);
> +
> +	for (i = 0; i < count; ++i)
> +		pi_sink_put(updaters[i].sink, 0);
> +
> +	if (!(flags & PI_FLAG_DEFER_UPDATE))
> +		_pi_node_update(&node->sink, 0);
> +
> +	return 0;
> +}
> +
> +static int
> +_pi_node_boost(struct pi_sink *sink, struct pi_source *src,
> +	       unsigned int flags)
> +{
> +	struct pi_node *node = node_of(sink);
> +	unsigned long   iflags;
> +
> +	spin_lock_irqsave(&node->lock, iflags);
> +	if (src->boosted)
> +		__pi_deboost(node, src);
> +	__pi_boost(node, src);
> +	spin_unlock_irqrestore(&node->lock, iflags);
> +
> +	if (!(flags & PI_FLAG_DEFER_UPDATE))
> +		_pi_node_update(sink, 0);
> +
> +	return 0;
> +}
> +
> +static int
> +_pi_node_deboost(struct pi_sink *sink, struct pi_source *src,
> +		 unsigned int flags)
> +{
> +	struct pi_node *node = node_of(sink);
> +	unsigned long   iflags;
> +
> +	spin_lock_irqsave(&node->lock, iflags);
> +	__pi_deboost(node, src);
> +	spin_unlock_irqrestore(&node->lock, iflags);
> +
> +	if (!(flags & PI_FLAG_DEFER_UPDATE))
> +		_pi_node_update(sink, 0);
> +
> +	return 0;
> +}
> +
> +static int
> +_pi_node_free(struct pi_sink *sink, unsigned int flags)
> +{
> +	struct pi_node *node = node_of(sink);
> +
> +	/*
> +	 * When the node is freed, we should perform an implicit
> +	 * del_sink on any remaining sinks we may have.
> +	 */
> +	return _pi_del_sink(node, NULL, flags);
> +}
> +
> +static struct pi_sink_ops pi_node_sink = {
> +    .boost   = _pi_node_boost,
> +    .deboost = _pi_node_deboost,
> +    .update  = _pi_node_update,
> +    .free    = _pi_node_free,
> +};
> +
> +void
> +pi_node_init(struct pi_node *node)
> +{
> +	spin_lock_init(&node->lock);
> +	node->prio = MAX_PRIO;
> +	atomic_set(&node->sink.refs, 1);
> +	node->sink.ops = &pi_node_sink;
>   
                  ^^^^^^

Note to self:  this should use pi_sink_init()


> +	pi_sinkref_pool_init(&node->sinkref_pool);
> +	INIT_LIST_HEAD(&node->sinks);
> +	plist_head_init(&node->srcs, &node->lock);
> +}
> +
> +int
> +pi_add_sink(struct pi_node *node, struct pi_sink *sink, unsigned int flags)
> +{
> +	struct pi_sinkref *sinkref;
> +	int                ret = 0;
> +	unsigned long      iflags;
> +
> +	spin_lock_irqsave(&node->lock, iflags);
> +
> +	if (!atomic_read(&node->sink.refs)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	sinkref = pi_sinkref_alloc(&node->sinkref_pool);
> +	if (!sinkref) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	spin_lock_init(&sinkref->lock);
> +	INIT_LIST_HEAD(&sinkref->list);
> +
> +	if (flags & PI_FLAG_ALREADY_BOOSTED)
> +		sinkref->state = pi_state_boosted;
> +	else
> +		/*
> +		 * Schedule it for addition at the next update
> +		 */
> +		sinkref->state = pi_state_boost;
> +
> +	pi_source_init(&sinkref->src, &node->prio);
> +	sinkref->sink = sink;
> +
> +	/* set one ref from ourselves.  It will be dropped on del_sink */
> +	atomic_inc(&sinkref->sink->refs);
> +	atomic_set(&sinkref->refs, 1);
> +
> +	list_add_tail(&sinkref->list, &node->sinks);
> +
> +	spin_unlock_irqrestore(&node->lock, iflags);
> +
> +	if (!(flags & PI_FLAG_DEFER_UPDATE))
> +		_pi_node_update(&node->sink, 0);
> +
> +	return 0;
> +
> + out:
> +	spin_unlock_irqrestore(&node->lock, iflags);
> +
> +	return ret;
> +}
> +
> +int
> +pi_del_sink(struct pi_node *node, struct pi_sink *sink, unsigned int flags)
> +{
> +	/*
> +	 * There may be multiple matches to sink because sometimes a
> +	 * deboost/free may still be pending an update when the same
> +	 * node has been added.  So we want to process any and all
> +	 * instances that match our target
> +	 */
> +	return _pi_del_sink(node, sink, flags);
> +}
> +
> +
> +
>
>   

