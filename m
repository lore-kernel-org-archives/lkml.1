Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYJ0QbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYJ0QbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYJ0Qax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:30:53 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:56616 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYJ0Qav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:30:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAGyFBUlMQWro/2dsb2JhbACBdrtAhXSDTw
Date: Mon, 27 Oct 2008 12:30:46 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] new probes manager
Message-ID: <20081027163046.GA20692@Krystal>
References: <48FFE5CB.2050608@cn.fujitsu.com> <20081027155832.GB17250@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081027155832.GB17250@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:11 up 144 days, 21:10, 11 users,  load average: 0.44, 0.39,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > this patch use a new probes manager for marker.
> > 
> > the most important benefit of this patch is:
> > 	1) smp_rmb() is removed from the critical path. as we know rmb()
> > 	   is very expensive.
> > 
> 
> Do you have performance measurements for this ? On x86 it's a nop,
> AFAIK.

My statement above is inexact : x86_64 uses lfence for rmb(). But
numbers would still be welcome.

MAthieu

> 
> > the other benefits:
> > 	2) Now, unused memory is handled by struct marker_probes.
> > 
> > 	   old code use these three field to handle unused memory.
> > 	   struct marker_entry {
> > 		...
> > 		struct rcu_head rcu;
> > 		void *oldptr;
> > 		int rcu_pending;
> > 		...
> > 	   };
> > 	   in this way, unused memory is handled by struct marker_entry.
> > 	   it bring reenter bug(it was fixed) and marker.c is filled
> >            full of ".*rcu.*" code statements. this patch remove all these.
> > 
> 
> Hrm, I think this will utterly slow down the batch
> registration/unregistration. Can you try to register 100 markers in
> batch on a loaded machine (e.g. running tbench on all cores) and see
> how long it takes ? Comparing before/after your patch would be welcome.
> 
> I have merged the modules_mutex, tracepoint_mutex and marker_mutex in
> the -lttng tree. It makes locking much much simpler and actually fixes
> an issue we currently have with interrupt unregister marker by private
> data (the entry is not there anymore when we do the second get within
> the unregister).
> 
> Can you have a look at these changes ?
> 
> > 	3) use new probes manager, and remove the "single optimization",
> > 	   and remove hundreds of codes. "single optimization" indeed
> > 	   speedup register/unregister side, but it brings smp_rmb()
> > 	   in the critical path, and brings a lots of code.
> > 
> 
> Nope. Single probe optimization makes sure we don't dynamically allocate
> memory for a single probe, it's not there for register/unregister speed
> at all. It also makes sure we don't reference another cache-line
> uselessly when we have a single probe.
> 
> Performance impact of this change should be better tested/caracterized.
> 
> > 	   and the size of struct marker is reduced. struct marker's
> > 	   memory is pre-allocated by compiler. this fix will save
> > 	   this memory.
> 
> This is mostly cache-cold stuff. And the thing we really care about is
> the amount of cache-lines used when the marker is active with a single
> probe. Your change seems to degrade this.
> 
> > 
> > about struct marker.state and immediate value:
> > 	4) struct marker.state is removed, for it equals to
> > 		struct marker.multi != NULL
> > 	   and struct marker.multi can use immediate value also in future.
> > 
> 
> Given the single vs multi probes are better vs cache-line usage, I still
> see the need for marker.state, which is a single char which fits in the
> same cache-line as marker.ptype.
> 
> Mathieu
> 
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  include/linux/marker.h |   12 -
> >  kernel/marker.c        |  552 +++++++++++++------------------------------------
> >  2 files changed, 150 insertions(+), 414 deletions(-)
> > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > index 4aca94a..179c59a 100644
> > --- a/include/linux/marker.h
> > +++ b/include/linux/marker.h
> > @@ -43,11 +43,8 @@ struct marker {
> >  	const char *format;	/* Marker format string, describing the
> >  				 * variable argument list.
> >  				 */
> > -	char state;		/* Marker state. */
> > -	char ptype;		/* probe type : 0 : single, 1 : multi */
> > -				/* Probe wrapper */
> > +
> >  	void (*call)(const struct marker *mdata, void *call_private, ...);
> > -	struct marker_probe_closure single;
> >  	struct marker_probe_closure *multi;
> >  } __attribute__((aligned(8)));
> >  
> > @@ -72,10 +69,9 @@ struct marker {
> >  		static struct marker __mark_##name			\
> >  		__attribute__((section("__markers"), aligned(8))) =	\
> >  		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
> > -		0, 0, marker_probe_cb,					\
> > -		{ __mark_empty_function, NULL}, NULL };			\
> > +		marker_probe_cb, NULL };				\
> >  		__mark_check_format(format, ## args);			\
> > -		if (unlikely(__mark_##name.state)) {			\
> > +		if (unlikely(__mark_##name.multi)) {			\
> >  			(*__mark_##name.call)				\
> >  				(&__mark_##name, call_private, ## args);\
> >  		}							\
> > @@ -133,8 +129,6 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
> >  			___mark_check_format(format, ## args);		\
> >  	} while (0)
> >  
> > -extern marker_probe_func __mark_empty_function;
> > -
> >  extern void marker_probe_cb(const struct marker *mdata,
> >  	void *call_private, ...);
> >  
> > diff --git a/kernel/marker.c b/kernel/marker.c
> > index 2898b64..dee5bd3 100644
> > --- a/kernel/marker.c
> > +++ b/kernel/marker.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * Copyright (C) 2007 Mathieu Desnoyers
> > + * Copyright (C) 2008 Lai Jiangshan
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License as published by
> > @@ -55,89 +56,32 @@ static struct hlist_head marker_table[MARKER_TABLE_SIZE];
> >   */
> >  struct marker_entry {
> >  	struct hlist_node hlist;
> > -	char *format;
> > +	const char *format;
> >  			/* Probe wrapper */
> >  	void (*call)(const struct marker *mdata, void *call_private, ...);
> > -	struct marker_probe_closure single;
> >  	struct marker_probe_closure *multi;
> > -	int refcount;	/* Number of times armed. 0 if disarmed. */
> > -	struct rcu_head rcu;
> > -	void *oldptr;
> > -	int rcu_pending;
> > -	unsigned char ptype:1;
> > +	int refcount;	/* Number of probes */
> >  	unsigned char format_allocated:1;
> > -	char name[0];	/* Contains name'\0'format'\0' */
> > +	const char name[0];	/* Contains name'\0'format'\0' */
> >  };
> >  
> >  /**
> > - * __mark_empty_function - Empty probe callback
> > - * @probe_private: probe private data
> > - * @call_private: call site private data
> > - * @fmt: format string
> > - * @...: variable argument list
> > - *
> > - * Empty callback provided as a probe to the markers. By providing this to a
> > - * disabled marker, we make sure the  execution flow is always valid even
> > - * though the function pointer change and the marker enabling are two distinct
> > - * operations that modifies the execution flow of preemptible code.
> > - */
> > -void __mark_empty_function(void *probe_private, void *call_private,
> > -	const char *fmt, va_list *args)
> > -{
> > -}
> > -EXPORT_SYMBOL_GPL(__mark_empty_function);
> > -
> > -/*
> > - * marker_probe_cb Callback that prepares the variable argument list for probes.
> > + * marker_probe_cb - Call probes with the variable argument list
> >   * @mdata: pointer of type struct marker
> >   * @call_private: caller site private data
> >   * @...:  Variable argument list.
> > - *
> > - * Since we do not use "typical" pointer based RCU in the 1 argument case, we
> > - * need to put a full smp_rmb() in this branch. This is why we do not use
> > - * rcu_dereference() for the pointer read.
> >   */
> >  void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
> >  {
> >  	va_list args;
> > -	char ptype;
> > +	struct marker_probe_closure *multi;
> >  
> > -	/*
> > -	 * rcu_read_lock_sched does two things : disabling preemption to make
> > -	 * sure the teardown of the callbacks can be done correctly when they
> > -	 * are in modules and they insure RCU read coherency.
> > -	 */
> >  	rcu_read_lock_sched();
> > -	ptype = mdata->ptype;
> > -	if (likely(!ptype)) {
> > -		marker_probe_func *func;
> > -		/* Must read the ptype before ptr. They are not data dependant,
> > -		 * so we put an explicit smp_rmb() here. */
> > -		smp_rmb();
> > -		func = mdata->single.func;
> > -		/* Must read the ptr before private data. They are not data
> > -		 * dependant, so we put an explicit smp_rmb() here. */
> > -		smp_rmb();
> > -		va_start(args, call_private);
> > -		func(mdata->single.probe_private, call_private, mdata->format,
> > -			&args);
> > -		va_end(args);
> > -	} else {
> > -		struct marker_probe_closure *multi;
> > +	/* reload mdata->multi again with rcu_read_lock_sched() held. */
> > +	multi = rcu_dereference(mdata->multi);
> > +	/* recheck multi after reload */
> > +	if (multi) {
> >  		int i;
> > -		/*
> > -		 * Read mdata->ptype before mdata->multi.
> > -		 */
> > -		smp_rmb();
> > -		multi = mdata->multi;
> > -		/*
> > -		 * multi points to an array, therefore accessing the array
> > -		 * depends on reading multi. However, even in this case,
> > -		 * we must insure that the pointer is read _before_ the array
> > -		 * data. Same as rcu_dereference, but we need a full smp_rmb()
> > -		 * in the fast path, so put the explicit barrier here.
> > -		 */
> > -		smp_read_barrier_depends();
> >  		for (i = 0; multi[i].func; i++) {
> >  			va_start(args, call_private);
> >  			multi[i].func(multi[i].probe_private, call_private,
> > @@ -149,48 +93,26 @@ void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
> >  }
> >  EXPORT_SYMBOL_GPL(marker_probe_cb);
> >  
> > -/*
> > - * marker_probe_cb Callback that does not prepare the variable argument list.
> > +/**
> > + * marker_probe_cb_noarg - Call probes without variable argument list
> >   * @mdata: pointer of type struct marker
> >   * @call_private: caller site private data
> >   * @...:  Variable argument list.
> >   *
> >   * Should be connected to markers "MARK_NOARGS".
> >   */
> > -static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> > +static void marker_probe_cb_noarg(const struct marker *mdata,
> > +		void *call_private, ...)
> >  {
> > -	va_list args;	/* not initialized */
> > -	char ptype;
> > +	va_list args;
> > +	struct marker_probe_closure *multi;
> >  
> >  	rcu_read_lock_sched();
> > -	ptype = mdata->ptype;
> > -	if (likely(!ptype)) {
> > -		marker_probe_func *func;
> > -		/* Must read the ptype before ptr. They are not data dependant,
> > -		 * so we put an explicit smp_rmb() here. */
> > -		smp_rmb();
> > -		func = mdata->single.func;
> > -		/* Must read the ptr before private data. They are not data
> > -		 * dependant, so we put an explicit smp_rmb() here. */
> > -		smp_rmb();
> > -		func(mdata->single.probe_private, call_private, mdata->format,
> > -			&args);
> > -	} else {
> > -		struct marker_probe_closure *multi;
> > +	/* reload mdata->multi again with rcu_read_lock_sched() held. */
> > +	multi = rcu_dereference(mdata->multi);
> > +	/* recheck multi after reload */
> > +	if (multi) {
> >  		int i;
> > -		/*
> > -		 * Read mdata->ptype before mdata->multi.
> > -		 */
> > -		smp_rmb();
> > -		multi = mdata->multi;
> > -		/*
> > -		 * multi points to an array, therefore accessing the array
> > -		 * depends on reading multi. However, even in this case,
> > -		 * we must insure that the pointer is read _before_ the array
> > -		 * data. Same as rcu_dereference, but we need a full smp_rmb()
> > -		 * in the fast path, so put the explicit barrier here.
> > -		 */
> > -		smp_read_barrier_depends();
> >  		for (i = 0; multi[i].func; i++)
> >  			multi[i].func(multi[i].probe_private, call_private,
> >  				mdata->format, &args);
> > @@ -198,14 +120,35 @@ static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private
> >  	rcu_read_unlock_sched();
> >  }
> >  
> > -static void free_old_closure(struct rcu_head *head)
> > +struct marker_probes {
> > +	struct rcu_head rcu;
> > +	struct marker_probe_closure multi[0];
> > +};
> > +
> > +static inline struct marker_probe_closure *allocate_probe_closure(int count)
> > +{
> > +	struct marker_probes *p;
> > +	p = kmalloc(count * sizeof(struct marker_probe_closure)
> > +			+ sizeof(struct marker_probes), GFP_KERNEL);
> > +	if (!p)
> > +		return NULL;
> > +	return p->multi;
> > +}
> > +
> > +static void rcu_free_old_closure(struct rcu_head *head)
> >  {
> > -	struct marker_entry *entry = container_of(head,
> > -		struct marker_entry, rcu);
> > -	kfree(entry->oldptr);
> > -	/* Make sure we free the data before setting the pending flag to 0 */
> > -	smp_wmb();
> > -	entry->rcu_pending = 0;
> > +	struct marker_probes *probes = container_of(head,
> > +		struct marker_probes, rcu);
> > +	kfree(probes);
> > +}
> > +
> > +static inline void release_probe_closure(struct marker_probe_closure *old)
> > +{
> > +	if (old) {
> > +		struct marker_probes *probes = container_of(old,
> > +			struct marker_probes, multi[0]);
> > +		call_rcu(&probes->rcu, rcu_free_old_closure);
> > +	}
> >  }
> >  
> >  static void debug_print_probes(struct marker_entry *entry)
> > @@ -215,69 +158,40 @@ static void debug_print_probes(struct marker_entry *entry)
> >  	if (!marker_debug)
> >  		return;
> >  
> > -	if (!entry->ptype) {
> > -		printk(KERN_DEBUG "Single probe : %p %p\n",
> > -			entry->single.func,
> > -			entry->single.probe_private);
> > -	} else {
> > -		for (i = 0; entry->multi[i].func; i++)
> > -			printk(KERN_DEBUG "Multi probe %d : %p %p\n", i,
> > -				entry->multi[i].func,
> > -				entry->multi[i].probe_private);
> > -	}
> > +	for (i = 0; i < entry->refcount; i++)
> > +		printk(KERN_DEBUG "Multi probe %d : %p %p\n", i,
> > +			entry->multi[i].func,
> > +			entry->multi[i].probe_private);
> >  }
> >  
> >  static struct marker_probe_closure *
> >  marker_entry_add_probe(struct marker_entry *entry,
> >  		marker_probe_func *probe, void *probe_private)
> >  {
> > -	int nr_probes = 0;
> > +	int nr_probes = entry->refcount, i;
> >  	struct marker_probe_closure *old, *new;
> >  
> > -	WARN_ON(!probe);
> > +	if (!probe)
> > +		return ERR_PTR(-EINVAL);
> >  
> >  	debug_print_probes(entry);
> >  	old = entry->multi;
> > -	if (!entry->ptype) {
> > -		if (entry->single.func == probe &&
> > -				entry->single.probe_private == probe_private)
> > +	for (i = 0; i < nr_probes; i++)
> > +		if (old[i].func == probe
> > +				&& old[i].probe_private == probe_private)
> >  			return ERR_PTR(-EBUSY);
> > -		if (entry->single.func == __mark_empty_function) {
> > -			/* 0 -> 1 probes */
> > -			entry->single.func = probe;
> > -			entry->single.probe_private = probe_private;
> > -			entry->refcount = 1;
> > -			entry->ptype = 0;
> > -			debug_print_probes(entry);
> > -			return NULL;
> > -		} else {
> > -			/* 1 -> 2 probes */
> > -			nr_probes = 1;
> > -			old = NULL;
> > -		}
> > -	} else {
> > -		/* (N -> N+1), (N != 0, 1) probes */
> > -		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
> > -			if (old[nr_probes].func == probe
> > -					&& old[nr_probes].probe_private
> > -						== probe_private)
> > -				return ERR_PTR(-EBUSY);
> > -	}
> > +
> >  	/* + 2 : one for new probe, one for NULL func */
> > -	new = kzalloc((nr_probes + 2) * sizeof(struct marker_probe_closure),
> > -			GFP_KERNEL);
> > -	if (new == NULL)
> > +	new = allocate_probe_closure(nr_probes + 2);
> > +	if (!new)
> >  		return ERR_PTR(-ENOMEM);
> > -	if (!old)
> > -		new[0] = entry->single;
> > -	else
> > -		memcpy(new, old,
> > -			nr_probes * sizeof(struct marker_probe_closure));
> > +	memcpy(new, old, nr_probes * sizeof(struct marker_probe_closure));
> >  	new[nr_probes].func = probe;
> >  	new[nr_probes].probe_private = probe_private;
> > +	new[nr_probes + 1].func = NULL;
> > +	new[nr_probes + 1].probe_private = NULL;
> >  	entry->refcount = nr_probes + 1;
> >  	entry->multi = new;
> > -	entry->ptype = 1;
> >  	debug_print_probes(entry);
> >  	return old;
> >  }
> > @@ -286,60 +200,33 @@ static struct marker_probe_closure *
> >  marker_entry_remove_probe(struct marker_entry *entry,
> >  		marker_probe_func *probe, void *probe_private)
> >  {
> > -	int nr_probes = 0, nr_del = 0, i;
> > +	int nr_probes = entry->refcount, nr_del = 0, i;
> >  	struct marker_probe_closure *old, *new;
> >  
> > -	old = entry->multi;
> > -
> >  	debug_print_probes(entry);
> > -	if (!entry->ptype) {
> > -		/* 0 -> N is an error */
> > -		WARN_ON(entry->single.func == __mark_empty_function);
> > -		/* 1 -> 0 probes */
> > -		WARN_ON(probe && entry->single.func != probe);
> > -		WARN_ON(entry->single.probe_private != probe_private);
> > -		entry->single.func = __mark_empty_function;
> > -		entry->refcount = 0;
> > -		entry->ptype = 0;
> > -		debug_print_probes(entry);
> > -		return NULL;
> > -	} else {
> > -		/* (N -> M), (N > 1, M >= 0) probes */
> > -		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > -			if ((!probe || old[nr_probes].func == probe)
> > -					&& old[nr_probes].probe_private
> > -						== probe_private)
> > -				nr_del++;
> > -		}
> > +	old = entry->multi;
> > +	for (i = 0; i < nr_probes; i++) {
> > +		if ((!probe || old[i].func == probe)
> > +				&& old[i].probe_private == probe_private)
> > +			nr_del++;
> >  	}
> >  
> >  	if (nr_probes - nr_del == 0) {
> > -		/* N -> 0, (N > 1) */
> > -		entry->single.func = __mark_empty_function;
> >  		entry->refcount = 0;
> > -		entry->ptype = 0;
> > -	} else if (nr_probes - nr_del == 1) {
> > -		/* N -> 1, (N > 1) */
> > -		for (i = 0; old[i].func; i++)
> > -			if ((probe && old[i].func != probe) ||
> > -					old[i].probe_private != probe_private)
> > -				entry->single = old[i];
> > -		entry->refcount = 1;
> > -		entry->ptype = 0;
> > +		entry->multi = NULL;
> >  	} else {
> >  		int j = 0;
> > -		/* N -> M, (N > 1, M > 1) */
> >  		/* + 1 for NULL */
> > -		new = kzalloc((nr_probes - nr_del + 1)
> > -			* sizeof(struct marker_probe_closure), GFP_KERNEL);
> > -		if (new == NULL)
> > +		new = allocate_probe_closure(nr_probes - nr_del + 1);
> > +		if (!new)
> >  			return ERR_PTR(-ENOMEM);
> > -		for (i = 0; old[i].func; i++)
> > +		for (i = 0; i < nr_probes; i++)
> >  			if ((probe && old[i].func != probe) ||
> >  					old[i].probe_private != probe_private)
> >  				new[j++] = old[i];
> > +		new[nr_probes - nr_del].func = NULL;
> > +		new[nr_probes - nr_del].probe_private = NULL;
> >  		entry->refcount = nr_probes - nr_del;
> > -		entry->ptype = 1;
> >  		entry->multi = new;
> >  	}
> >  	debug_print_probes(entry);
> > @@ -358,7 +245,7 @@ static struct marker_entry *get_marker(const char *name)
> >  	struct marker_entry *e;
> >  	u32 hash = jhash(name, strlen(name), 0);
> >  
> > -	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > +	head = &marker_table[hash & (MARKER_TABLE_SIZE - 1)];
> >  	hlist_for_each_entry(e, node, head, hlist) {
> >  		if (!strcmp(name, e->name))
> >  			return e;
> > @@ -373,22 +260,14 @@ static struct marker_entry *get_marker(const char *name)
> >  static struct marker_entry *add_marker(const char *name, const char *format)
> >  {
> >  	struct hlist_head *head;
> > -	struct hlist_node *node;
> >  	struct marker_entry *e;
> >  	size_t name_len = strlen(name) + 1;
> >  	size_t format_len = 0;
> > -	u32 hash = jhash(name, name_len-1, 0);
> > +	u32 hash = jhash(name, name_len - 1, 0);
> >  
> > +	head = &marker_table[hash & (MARKER_TABLE_SIZE - 1)];
> >  	if (format)
> >  		format_len = strlen(format) + 1;
> > -	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > -	hlist_for_each_entry(e, node, head, hlist) {
> > -		if (!strcmp(name, e->name)) {
> > -			printk(KERN_NOTICE
> > -				"Marker %s busy\n", name);
> > -			return ERR_PTR(-EBUSY);	/* Already there */
> > -		}
> > -	}
> >  	/*
> >  	 * Using kmalloc here to allocate a variable length element. Could
> >  	 * cause some memory fragmentation if overused.
> > @@ -397,10 +276,10 @@ static struct marker_entry *add_marker(const char *name, const char *format)
> >  			GFP_KERNEL);
> >  	if (!e)
> >  		return ERR_PTR(-ENOMEM);
> > -	memcpy(&e->name[0], name, name_len);
> > +	memcpy((void *)&e->name[0], name, name_len);
> >  	if (format) {
> >  		e->format = &e->name[name_len];
> > -		memcpy(e->format, format, format_len);
> > +		memcpy((void *)e->format, format, format_len);
> >  		if (strcmp(e->format, MARK_NOARGS) == 0)
> >  			e->call = marker_probe_cb_noarg;
> >  		else
> > @@ -411,13 +290,9 @@ static struct marker_entry *add_marker(const char *name, const char *format)
> >  		e->format = NULL;
> >  		e->call = marker_probe_cb;
> >  	}
> > -	e->single.func = __mark_empty_function;
> > -	e->single.probe_private = NULL;
> >  	e->multi = NULL;
> > -	e->ptype = 0;
> >  	e->format_allocated = 0;
> >  	e->refcount = 0;
> > -	e->rcu_pending = 0;
> >  	hlist_add_head(&e->hlist, head);
> >  	return e;
> >  }
> > @@ -426,38 +301,16 @@ static struct marker_entry *add_marker(const char *name, const char *format)
> >   * Remove the marker from the marker hash table. Must be called with mutex_lock
> >   * held.
> >   */
> > -static int remove_marker(const char *name)
> > +static inline void remove_marker(struct marker_entry *entry)
> >  {
> > -	struct hlist_head *head;
> > -	struct hlist_node *node;
> > -	struct marker_entry *e;
> > -	int found = 0;
> > -	size_t len = strlen(name) + 1;
> > -	u32 hash = jhash(name, len-1, 0);
> > -
> > -	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > -	hlist_for_each_entry(e, node, head, hlist) {
> > -		if (!strcmp(name, e->name)) {
> > -			found = 1;
> > -			break;
> > -		}
> > -	}
> > -	if (!found)
> > -		return -ENOENT;
> > -	if (e->single.func != __mark_empty_function)
> > -		return -EBUSY;
> > -	hlist_del(&e->hlist);
> > -	if (e->format_allocated)
> > -		kfree(e->format);
> > -	/* Make sure the call_rcu has been executed */
> > -	if (e->rcu_pending)
> > -		rcu_barrier_sched();
> > -	kfree(e);
> > -	return 0;
> > +	hlist_del(&entry->hlist);
> > +	if (entry->format_allocated)
> > +		kfree(entry->format);
> > +	kfree(entry);
> >  }
> >  
> >  /*
> > - * Set the mark_entry format to the format found in the element.
> > + * Set the mark_entry format to the format.
> >   */
> >  static int marker_set_format(struct marker_entry *entry, const char *format)
> >  {
> > @@ -466,6 +319,11 @@ static int marker_set_format(struct marker_entry *entry, const char *format)
> >  		return -ENOMEM;
> >  	entry->format_allocated = 1;
> >  
> > +	if (strcmp(entry->format, MARK_NOARGS) == 0)
> > +		entry->call = marker_probe_cb_noarg;
> > +	else
> > +		entry->call = marker_probe_cb;
> > +
> >  	trace_mark(core_marker_format, "name %s format %s",
> >  			entry->name, entry->format);
> >  	return 0;
> > @@ -474,8 +332,7 @@ static int marker_set_format(struct marker_entry *entry, const char *format)
> >  /*
> >   * Sets the probe callback corresponding to one marker.
> >   */
> > -static int set_marker(struct marker_entry *entry, struct marker *elem,
> > -		int active)
> > +static int set_marker(struct marker_entry *entry, struct marker *elem)
> >  {
> >  	int ret;
> >  	WARN_ON(strcmp(entry->name, elem->name) != 0);
> > @@ -503,56 +360,18 @@ static int set_marker(struct marker_entry *entry, struct marker *elem,
> >  	 * callback (does not set arguments).
> >  	 */
> >  	elem->call = entry->call;
> > -	/*
> > -	 * Sanity check :
> > -	 * We only update the single probe private data when the ptr is
> > -	 * set to a _non_ single probe! (0 -> 1 and N -> 1, N != 1)
> > -	 */
> > -	WARN_ON(elem->single.func != __mark_empty_function
> > -		&& elem->single.probe_private != entry->single.probe_private
> > -		&& !elem->ptype);
> > -	elem->single.probe_private = entry->single.probe_private;
> > -	/*
> > -	 * Make sure the private data is valid when we update the
> > -	 * single probe ptr.
> > -	 */
> > -	smp_wmb();
> > -	elem->single.func = entry->single.func;
> > -	/*
> > -	 * We also make sure that the new probe callbacks array is consistent
> > -	 * before setting a pointer to it.
> > -	 */
> > +
> >  	rcu_assign_pointer(elem->multi, entry->multi);
> > -	/*
> > -	 * Update the function or multi probe array pointer before setting the
> > -	 * ptype.
> > -	 */
> > -	smp_wmb();
> > -	elem->ptype = entry->ptype;
> > -	elem->state = active;
> >  
> >  	return 0;
> >  }
> >  
> >  /*
> >   * Disable a marker and its probe callback.
> > - * Note: only waiting an RCU period after setting elem->call to the empty
> > - * function insures that the original callback is not used anymore. This insured
> > - * by rcu_read_lock_sched around the call site.
> >   */
> > -static void disable_marker(struct marker *elem)
> > +static inline void disable_marker(struct marker *elem)
> >  {
> > -	/* leave "call" as is. It is known statically. */
> > -	elem->state = 0;
> > -	elem->single.func = __mark_empty_function;
> > -	/* Update the function before setting the ptype */
> > -	smp_wmb();
> > -	elem->ptype = 0;	/* single probe */
> > -	/*
> > -	 * Leave the private data and id there, because removal is racy and
> > -	 * should be done only after an RCU period. These are never used until
> > -	 * the next initialization anyway.
> > -	 */
> > +	rcu_assign_pointer(elem->multi, NULL);
> >  }
> >  
> >  /**
> > @@ -562,8 +381,7 @@ static void disable_marker(struct marker *elem)
> >   *
> >   * Updates the probe callback corresponding to a range of markers.
> >   */
> > -void marker_update_probe_range(struct marker *begin,
> > -	struct marker *end)
> > +void marker_update_probe_range(struct marker *begin, struct marker *end)
> >  {
> >  	struct marker *iter;
> >  	struct marker_entry *mark_entry;
> > @@ -572,7 +390,7 @@ void marker_update_probe_range(struct marker *begin,
> >  	for (iter = begin; iter < end; iter++) {
> >  		mark_entry = get_marker(iter->name);
> >  		if (mark_entry) {
> > -			set_marker(mark_entry, iter, !!mark_entry->refcount);
> > +			set_marker(mark_entry, iter);
> >  			/*
> >  			 * ignore error, continue
> >  			 */
> > @@ -585,20 +403,6 @@ void marker_update_probe_range(struct marker *begin,
> >  
> >  /*
> >   * Update probes, removing the faulty probes.
> > - *
> > - * Internal callback only changed before the first probe is connected to it.
> > - * Single probe private data can only be changed on 0 -> 1 and 2 -> 1
> > - * transitions.  All other transitions will leave the old private data valid.
> > - * This makes the non-atomicity of the callback/private data updates valid.
> > - *
> > - * "special case" updates :
> > - * 0 -> 1 callback
> > - * 1 -> 0 callback
> > - * 1 -> 2 callbacks
> > - * 2 -> 1 callbacks
> > - * Other updates all behave the same, just like the 2 -> 3 or 3 -> 2 updates.
> > - * Site effect : marker_set_format may delete the marker entry (creating a
> > - * replacement).
> >   */
> >  static void marker_update_probes(void)
> >  {
> > @@ -638,35 +442,19 @@ int marker_probe_register(const char *name, const char *format,
> >  		else if (strcmp(entry->format, format))
> >  			ret = -EPERM;
> >  	}
> > -	if (ret)
> > -		goto end;
> > +	if (ret) {
> > +		mutex_unlock(&markers_mutex);
> > +		return ret;
> > +	}
> >  
> > -	/*
> > -	 * If we detect that a call_rcu is pending for this marker,
> > -	 * make sure it's executed now.
> > -	 */
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> >  	old = marker_entry_add_probe(entry, probe, probe_private);
> > -	if (IS_ERR(old)) {
> > -		ret = PTR_ERR(old);
> > -		goto end;
> > -	}
> >  	mutex_unlock(&markers_mutex);
> > +	if (old && IS_ERR(old))
> > +		return PTR_ERR(old);
> > +
> >  	marker_update_probes();		/* may update entry */
> > -	mutex_lock(&markers_mutex);
> > -	entry = get_marker(name);
> > -	WARN_ON(!entry);
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > -end:
> > -	mutex_unlock(&markers_mutex);
> > -	return ret;
> > +	release_probe_closure(old);
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(marker_probe_register);
> >  
> > @@ -677,43 +465,32 @@ EXPORT_SYMBOL_GPL(marker_probe_register);
> >   * @probe_private: probe private data
> >   *
> >   * Returns the private data given to marker_probe_register, or an ERR_PTR().
> > - * We do not need to call a synchronize_sched to make sure the probes have
> > - * finished running before doing a module unload, because the module unload
> > - * itself uses stop_machine(), which insures that every preempt disabled section
> > - * have finished.
> >   */
> >  int marker_probe_unregister(const char *name,
> >  	marker_probe_func *probe, void *probe_private)
> >  {
> >  	struct marker_entry *entry;
> >  	struct marker_probe_closure *old;
> > -	int ret = -ENOENT;
> >  
> >  	mutex_lock(&markers_mutex);
> >  	entry = get_marker(name);
> > -	if (!entry)
> > -		goto end;
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> > +	if (!entry) {
> > +		mutex_unlock(&markers_mutex);
> > +		return -ENOENT;
> > +	}
> > +
> >  	old = marker_entry_remove_probe(entry, probe, probe_private);
> > +	if (!entry->refcount)
> > +		remove_marker(entry);
> > +
> >  	mutex_unlock(&markers_mutex);
> > +	if (old && IS_ERR(old))
> > +		return PTR_ERR(old);
> > +
> >  	marker_update_probes();		/* may update entry */
> > -	mutex_lock(&markers_mutex);
> > -	entry = get_marker(name);
> > -	if (!entry)
> > -		goto end;
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > -	remove_marker(name);	/* Ignore busy error message */
> > -	ret = 0;
> > -end:
> > -	mutex_unlock(&markers_mutex);
> > -	return ret;
> > +	release_probe_closure(old);
> > +
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(marker_probe_unregister);
> >  
> > @@ -728,20 +505,13 @@ get_marker_from_private_data(marker_probe_func *probe, void *probe_private)
> >  	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
> >  		head = &marker_table[i];
> >  		hlist_for_each_entry(entry, node, head, hlist) {
> > -			if (!entry->ptype) {
> > -				if (entry->single.func == probe
> > -						&& entry->single.probe_private
> > +			struct marker_probe_closure *closure;
> > +			closure = entry->multi;
> > +			for (i = 0; i < entry->refcount; i++) {
> > +				if (closure[i].func == probe &&
> > +						closure[i].probe_private
> >  						== probe_private)
> >  					return entry;
> > -			} else {
> > -				struct marker_probe_closure *closure;
> > -				closure = entry->multi;
> > -				for (i = 0; closure[i].func; i++) {
> > -					if (closure[i].func == probe &&
> > -							closure[i].probe_private
> > -							== probe_private)
> > -						return entry;
> > -				}
> >  			}
> >  		}
> >  	}
> > @@ -756,43 +526,32 @@ get_marker_from_private_data(marker_probe_func *probe, void *probe_private)
> >   * Unregister a probe by providing the registered private data.
> >   * Only removes the first marker found in hash table.
> >   * Return 0 on success or error value.
> > - * We do not need to call a synchronize_sched to make sure the probes have
> > - * finished running before doing a module unload, because the module unload
> > - * itself uses stop_machine(), which insures that every preempt disabled section
> > - * have finished.
> >   */
> >  int marker_probe_unregister_private_data(marker_probe_func *probe,
> >  		void *probe_private)
> >  {
> >  	struct marker_entry *entry;
> > -	int ret = 0;
> >  	struct marker_probe_closure *old;
> >  
> >  	mutex_lock(&markers_mutex);
> >  	entry = get_marker_from_private_data(probe, probe_private);
> >  	if (!entry) {
> > -		ret = -ENOENT;
> > -		goto end;
> > +		mutex_unlock(&markers_mutex);
> > +		return -ENOENT;
> >  	}
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> > +
> >  	old = marker_entry_remove_probe(entry, NULL, probe_private);
> > +	if (!entry->refcount)
> > +		remove_marker(entry);
> > +
> >  	mutex_unlock(&markers_mutex);
> > +	if (old && IS_ERR(old))
> > +		return PTR_ERR(old);
> > +
> >  	marker_update_probes();		/* may update entry */
> > -	mutex_lock(&markers_mutex);
> > -	entry = get_marker_from_private_data(probe, probe_private);
> > -	WARN_ON(!entry);
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > -	remove_marker(entry->name);	/* Ignore busy error message */
> > -end:
> > -	mutex_unlock(&markers_mutex);
> > -	return ret;
> > +	release_probe_closure(old);
> > +
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
> >  
> > @@ -804,7 +563,6 @@ EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
> >   *
> >   * Returns the nth private data pointer (starting from 0) matching, or an
> >   * ERR_PTR.
> > - * Returns the private data pointer, or an ERR_PTR.
> >   * The private data pointer should _only_ be dereferenced if the caller is the
> >   * owner of the data, or its content could vanish. This is mostly used to
> >   * confirm that a caller is the owner of a registered probe.
> > @@ -812,31 +570,15 @@ EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
> >  void *marker_get_private_data(const char *name, marker_probe_func *probe,
> >  		int num)
> >  {
> > -	struct hlist_head *head;
> > -	struct hlist_node *node;
> > -	struct marker_entry *e;
> > -	size_t name_len = strlen(name) + 1;
> > -	u32 hash = jhash(name, name_len-1, 0);
> > -	int i;
> > -
> > -	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > -	hlist_for_each_entry(e, node, head, hlist) {
> > -		if (!strcmp(name, e->name)) {
> > -			if (!e->ptype) {
> > -				if (num == 0 && e->single.func == probe)
> > -					return e->single.probe_private;
> > -			} else {
> > -				struct marker_probe_closure *closure;
> > -				int match = 0;
> > -				closure = e->multi;
> > -				for (i = 0; closure[i].func; i++) {
> > -					if (closure[i].func != probe)
> > -						continue;
> > -					if (match++ == num)
> > -						return closure[i].probe_private;
> > -				}
> > -			}
> > -			break;
> > +	struct marker_entry *e = get_marker(name);
> > +	if (e) {
> > +		struct marker_probe_closure *closure = e->multi;
> > +		int match = 0, i;
> > +		for (i = 0; i < e->refcount; i++) {
> > +			if (closure[i].func != probe)
> > +				continue;
> > +			if (match++ == num)
> > +				return closure[i].probe_private;
> >  		}
> >  	}
> >  	return ERR_PTR(-ENOENT);
> > 
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
