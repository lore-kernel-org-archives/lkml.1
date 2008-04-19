Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbYDSXZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbYDSXZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYDSXZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:25:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43535 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYDSXZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:25:44 -0400
Date: Sat, 19 Apr 2008 16:25:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, peterz@infradead.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
Message-ID: <20080419232539.GE20138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080411161702.460410000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411161702.460410000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 06:17:02PM +0200, Nadia.Derbey@bull.net wrote:
> 
> 
> Here is finally the ipc ridr-based implementation I was talking about last
> week (see http://lkml.org/lkml/2008/4/4/208).
> I couldn't avoid much of the code duplication, but at least made things
> incremental.
> 
> Does somebody now a test suite that exists for the idr API, that I could
> run on this new api?
> 
> Mike, can you try to run it on your victim: I had such a hard time building
> this patch, that I couldn't re-run the test on my 8-core with this new
> version. So the last results I have are for 2.6.25-rc3-mm1.
> 
> Also, I think a careful review should be done to avoid introducing yet other
> problems :-(
> 
> *WARNING*: this patch contains a fix for idr.c
>            I know, I'm doing things bad, but I only saw the problem this
>            afternoon.
> 
> It should be applied on linux-2.6.25-rc8-mm1, in the following order:
> 
> [ PATCH 01/13 ] : copy_idr_code.patch
> [ PATCH 02/13 ] : change_ridr_struct.patch
> [ PATCH 03/13 ] : ridr_pre_get.patch
> [ PATCH 04/13 ] : ridr_alloc_layer.patch
> [ PATCH 05/13 ] : ridr_free_layer.patch
> [ PATCH 06/13 ] : ridr_sub_alloc.patch
> [ PATCH 07/13 ] : ridr_get_empty_slot.patch
> [ PATCH 08/13 ] : ridr_get_new.patch
> [ PATCH 09/13 ] : ridr_remove.patch
> [ PATCH 10/13 ] : ridr_find.patch
> [ PATCH 11/13 ] : ridr_integrate.patch
> [ PATCH 12/13 ] : ipc_use_ridr.patch
> [ PATCH 13/13 ] : remove_ipc_lock_down.patch

And some more comments on the resulting ridr.c.  Note that we might in
fact want to keep the rcu_assign_pointer() calls that I complain about --
see Johannes Berg's posting about making sparse smarter about RCU.

But I include them for completeness.

							Thanx, Paul

> /*
>  * RCU-based idr API
>  */
> 
> #ifndef TEST                        /* to test in user space... */
> #include <linux/slab.h>
> #include <linux/init.h>
> #include <linux/module.h>
> #endif
> #include <linux/err.h>
> #include <linux/string.h>
> #include <linux/ridr.h>
> 
> static struct kmem_cache *ridr_layer_cache;
> 
> /*
>  * Per-cpu pool of preloaded layers
>  */
> struct ridr_preget {
> 	int nr;
> 	struct ridr_layer *layers[MAX_LEVEL];
> };
> DEFINE_PER_CPU(struct ridr_preget, ridr_pregets) = { 0, };
> 
> static inline gfp_t ridr_gfp_mask(struct ridr *idp)
> {
> 	return idp->gfp_mask & __GFP_BITS_MASK;
> }
> 
> static struct ridr_layer *alloc_layer(struct ridr *idp)
> {
> 	struct ridr_layer *ret = NULL;
> 	gfp_t gfp_mask = ridr_gfp_mask(idp);
> 
> 	if (!(gfp_mask & __GFP_WAIT)) {
> 		struct ridr_preget *ridp;
> 
> 		/*
> 		 * Provided the caller has preloaded here, we will always
> 		 * succeed in getting a node here (and never reach
> 		 * kmem_cache_alloc)
> 		 */
> 		ridp = &__get_cpu_var(ridr_pregets);
> 		if (ridp->nr) {
> 			ret = ridp->layers[ridp->nr - 1];
> 			ridp->layers[ridp->nr - 1] = NULL;
> 			ridp->nr--;
> 		}

Might be good to have a BUG_ON(!ret) or some such here?

> 	}
> 	if (ret == NULL)
> 		ret = kmem_cache_alloc(ridr_layer_cache, gfp_mask);

Either that or get kmem_cache_alloc() upset about being called with
preemption disabled.  But only sometimes, IIRC.

> 	return ret;
> }
> 
> static void ridr_layer_rcu_free(struct rcu_head *head)
> {
> 	struct ridr_layer *layer;
> 
> 	layer = container_of(head, struct ridr_layer, rcu_head);
> 	kmem_cache_free(ridr_layer_cache, layer);
> }
> 
> static inline void free_layer(struct ridr_layer *p)
> {
> 	call_rcu(&p->rcu_head, ridr_layer_rcu_free);
> }
> 
> static void ridr_mark_full(struct ridr_layer **pa, int id)
> {
> 	struct ridr_layer *p = pa[0];
> 	int l = 0;
> 
> 	__set_bit(id & IDR_MASK, &p->bitmap);
> 	/*
> 	 * If this layer is full mark the bit in the layer above to
> 	 * show that this part of the radix tree is full.  This may
> 	 * complete the layer above and require walking up the radix
> 	 * tree.
> 	 */
> 	while (p->bitmap == IDR_FULL) {
> 		p = pa[++l];
> 		if (!p)
> 			break;
> 		id = id >> IDR_BITS;
> 		__set_bit((id & IDR_MASK), &p->bitmap);
> 	}
> }
> 
> /**
>  * ridr_pre_get - reserver resources for ridr allocation
>  * @idp:	ridr handle
>  * @gfp_mask:	memory allocation flags
>  *
>  * Load up this CPU's ridr_layer buffer with sufficient objects to
>  * ensure that the addition of a single element in the tree cannot fail.
>  *
>  * If the system is REALLY out of memory this function returns 0, with
>  * preemption enabled.
>  * Otherwise 1, with preemption disabled.
>  */
> int ridr_pre_get(gfp_t gfp_mask)
> {
> 	struct ridr_preget *idp;
> 	struct ridr_layer *layer;
> 	int ret = 0;
> 
> 	preempt_disable();
> 	idp = &__get_cpu_var(ridr_pregets);
> 	while (idp->nr < ARRAY_SIZE(idp->layers)) {
> 		preempt_enable();
> 		layer = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
> 		if (layer == NULL)
> 			goto out;

Here we potentially spatter free elements across the CPUs, which seems
a bit strange -- unless I am missing something, there has to be a single
lock guarding all updates of a given ridr structure, right?

> 		preempt_disable();
> 		idp = &__get_cpu_var(ridr_pregets);
> 		if (idp->nr < ARRAY_SIZE(idp->layers))
> 			idp->layers[idp->nr++] = layer;
> 		else
> 			kmem_cache_free(ridr_layer_cache, layer);
> 	}
> 	ret = 1;
> out:
> 	return ret;
> }
> EXPORT_SYMBOL(ridr_pre_get);
> 
> static int sub_alloc(struct ridr *idp, int *starting_id,
> 			struct ridr_layer **pa)
> {
> 	int n, m, sh;
> 	struct ridr_layer *p, *new;
> 	int l, id, oid;
> 	unsigned long bm;
> 
> 	id = *starting_id;
>  restart:
> 	rcu_assign_pointer(p, idp->top);

We don't need the above rcu_assign_pointer(), because "p" is a local
variable.  (And we don't publish p's address somewhere that other CPUs
can find it, correct?)

> 	l = idp->layers;
> 	rcu_assign_pointer(pa[l--], NULL);

This is a static function, and its caller is also static.  So the pa[]
array is always a local variable a ways up the stack, and this need not
be rcu_assign_pointer().

> 	while (1) {
> 		/*
> 		 * We run around this while until we reach the leaf node...
> 		 */
> 		n = (id >> (IDR_BITS*l)) & IDR_MASK;
> 		bm = ~p->bitmap;
> 		m = find_next_bit(&bm, IDR_SIZE, n);
> 		if (m == IDR_SIZE) {
> 			/* no space available go back to previous layer. */
> 			l++;
> 			oid = id;
> 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
> 
> 			/* if already at the top layer, we need to grow */
> 			rcu_assign_pointer(p, pa[l]);

Another unneeded rcu_assign_pointer(), "p" is local.

> 			if (!p) {
> 				*starting_id = id;
> 				return -2;
> 			}
> 
> 			/* If we need to go up one layer, continue the
> 			 * loop; otherwise, restart from the top.
> 			 */
> 			sh = IDR_BITS * (l + 1);
> 			if (oid >> sh == id >> sh)
> 				continue;
> 			else
> 				goto restart;
> 		}
> 		if (m != n) {
> 			sh = IDR_BITS*l;
> 			id = ((id >> sh) ^ n ^ m) << sh;
> 		}
> 		if ((id >= MAX_ID_BIT) || (id < 0))
> 			return -3;
> 		if (l == 0)
> 			break;
> 		/*
> 		 * Create the layer below if it is missing.
> 		 */
> 		if (!p->ary[m]) {
> 			new = alloc_layer(idp);
> 			if (!new)
> 				return -1;
> 			rcu_assign_pointer(p->ary[m], new);

Not yet published, so rcu_assign_pointer() not needed.

> 			p->count++;
> 		}
> 		rcu_assign_pointer(pa[l--], p);

Assignment to local variable (up the stack), so no need for
rcu_assign_pointer().

> 		p = p->ary[m];
> 	}
> 
> 	rcu_assign_pointer(pa[l], p);
> 	return id;

Assignment to local variable (up the stack), so no need for
rcu_assign_pointer().

> }
> 
> static int ridr_get_empty_slot(struct ridr *idp, int starting_id,
> 			      struct ridr_layer **pa)
> {
> 	struct ridr_layer *p, *new;
> 	int layers, v, id;
> 
> 	id = starting_id;
> build_up:
> 	p = idp->top;
> 	layers = idp->layers;
> 	if (unlikely(!p)) {
> 		p = alloc_layer(idp);
> 		if (!p)
> 			return -1;
> 		layers = 1;
> 	}
> 	/*
> 	 * Add a new layer to the top of the tree if the requested
> 	 * id is larger than the currently allocated space.
> 	 */
> 	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
> 		layers++;
> 		if (!p->count)
> 			continue;
> 		new = alloc_layer(idp);
> 		if (!new) {
> 			/*
> 			 * The allocation failed.  If we built part of
> 			 * the structure tear it down.
> 			 */
> 			for (new = p; p && p != idp->top; new = p) {
> 				p = p->ary[0];
> 				new->ary[0] = NULL;
> 				new->bitmap = new->count = 0;
> 				free_layer(new);
> 			}
> 			return -1;
> 		}
> 		rcu_assign_pointer(new->ary[0], p);

The above rcu_assign_pointer() is not needed because we haven't yet
make "new" accessible to other CPUs.

> 		new->count = 1;
> 		if (p->bitmap == IDR_FULL)
> 			__set_bit(0, &new->bitmap);
> 		rcu_assign_pointer(p, new);

The above need not be rcu_assign_pointer() because "p" is a local variable
that is (I hope!) not being accessed by other CPUs.

> 	}
> 	rcu_assign_pointer(idp->top, p);

Interesting...  We assign to idp->top whether it changed or not.
Not a problem -- the alternative would make backing out on OOM
quite painful.

> 	idp->layers = layers;
> 	v = sub_alloc(idp, &id, pa);
> 	if (v == -2)
> 		goto build_up;
> 	return(v);
> }
> 
> static int ridr_get_new_above_int(struct ridr *idp, void *ptr, int starting_id)
> {
> 	struct ridr_layer *pa[MAX_LEVEL];
> 	int id;
> 
> 	id = ridr_get_empty_slot(idp, starting_id, pa);
> 	if (id >= 0) {
> 		/*
> 		 * Successfully found an empty slot.  Install the user
> 		 * pointer and mark the slot full.
> 		 */
> 		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
> 						(struct ridr_layer *)ptr);

Here we are assigning to the live tree, so we -do- need rcu_assign_pointer().

> 		pa[0]->count++;
> 		ridr_mark_full(pa, id);

Is ridr_mark_full() really safe in face of concurrent readers?  Seems like
it should be, since it is doing a bunch of __set_bit() calls.

> 	}
> 
> 	return id;
> }
> 
> /**
>  * ridr_get_new - allocate new ridr entry
>  * @idp: ridr handle
>  * @ptr: pointer you want associated with the ide
>  * @id: pointer to the allocated handle
>  *
>  * This is the allocate id function.  It should be called with any
>  * required locks.
>  *
>  * If memory is required, it will return -EAGAIN, you should unlock, enable
>  * preemption and go back to the ridr_pre_get() call.
>  * If the ridr is full, it will return -ENOSPC.
>  *
>  * @id returns a value in the range 0 ... 0x7fffffff
>  */
> int ridr_get_new(struct ridr *idp, void *ptr, int *id)
> {
> 	int rv;
> 
> 	rv = ridr_get_new_above_int(idp, ptr, 0);
> 	/*
> 	 * This is a cheap hack until the IDR code can be fixed to
> 	 * return proper error values.
> 	 */
> 	if (rv < 0) {
> 		if (rv == -1)
> 			return -EAGAIN;
> 		else /* Will be -3 */
> 			return -ENOSPC;
> 	}
> 	*id = rv;
> 	return 0;
> }
> EXPORT_SYMBOL(ridr_get_new);
> 
> static void sub_remove(struct ridr *idp, int shift, int id)
> {
> 	struct ridr_layer *p = idp->top;
> 	struct ridr_layer **pa[MAX_LEVEL];
> 	struct ridr_layer ***paa = &pa[0];
> 	struct ridr_layer *to_free;
> 	int n;
> 
> 	*paa = NULL;
> 	*++paa = &idp->top;
> 
> 	while ((shift > 0) && p) {
> 		n = (id >> shift) & IDR_MASK;
> 		__clear_bit(n, &p->bitmap);
> 		*++paa = &p->ary[n];
> 		p = p->ary[n];
> 		shift -= IDR_BITS;
> 	}
> 	n = id & IDR_MASK;
> 	if (likely(p != NULL && test_bit(n, &p->bitmap))) {
> 		__clear_bit(n, &p->bitmap);
> 		p->ary[n] = NULL;
> 		to_free = NULL;
> 		while (*paa && !--((**paa)->count)) {
> 			if (to_free)
> 				free_layer(to_free);
> 			to_free = **paa;
> 			**paa-- = NULL;
> 		}
> 		if (!*paa)
> 			idp->layers = 0;
> 		if (to_free)
> 			free_layer(to_free);
> 	} else
> 		idr_remove_warning("ridr_remove", id);
> }
> 
> /**
>  * ridr_remove - remove the given id and free it's slot
>  * @idp: ridr handle
>  * @id: unique key
>  */
> void ridr_remove(struct ridr *idp, int id)
> {
> 	struct ridr_layer *p, *to_free;
> 
> 	/* Mask off upper bits we don't use for the search. */
> 	id &= MAX_ID_MASK;
> 
> 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
> 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
> 	    idp->top->ary[0]) {  /* We can drop a layer */

Why do we drop layers both in sub_remove() and here?

Hmmm...  For the same reason we do in idr_remove(), I guess.  Whatever
reason that might be.  ;-)

> 		to_free = idp->top;
> 		p = idp->top->ary[0];
> 		idp->top = p;
> 		--idp->layers;
> 		to_free->bitmap = to_free->count = 0;
> 		free_layer(to_free);
> 	}
> 	return;
> }
> EXPORT_SYMBOL(ridr_remove);
> 
> /**
>  * ridr_find - return pointer for given id
>  * @idp: ridr handle
>  * @id: lookup key
>  *
>  * Return the pointer given the id it has been registered with.  A %NULL
>  * return indicates that @id is not valid or you passed %NULL in
>  * ridr_get_new().
>  *
>  * The caller must serialize ridr_find() vs ridr_get_new() and ridr_remove().
>  */
> void *ridr_find(struct ridr *idp, int id)
> {
> 	int n;
> 	struct ridr_layer *p;
> 
> 	n = idp->layers * IDR_BITS;
> 	p = rcu_dereference(idp->top);
> 
> 	/* Mask off upper bits we don't use for the search. */
> 	id &= MAX_ID_MASK;
> 
> 	if (id >= (1 << n))
> 		return NULL;
> 
> 	while (n > 0 && p) {
> 		n -= IDR_BITS;
> 		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
> 	}
> 	return((void *)p);
> }
> EXPORT_SYMBOL(ridr_find);
> 
> static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
> 				void *ridr_layer)
> {
> 	memset(ridr_layer, 0, sizeof(struct ridr_layer));
> }
> 
> void __init ridr_init_cache(void)
> {
> 	ridr_layer_cache = kmem_cache_create("ridr_layer_cache",
> 				sizeof(struct ridr_layer), 0, SLAB_PANIC,
> 				ridr_cache_ctor);
> }
