Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYLDQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYLDQzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLDQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:55:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35485 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYLDQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:55:40 -0500
Date: Thu, 4 Dec 2008 08:55:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
Message-ID: <20081204165536.GA6753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com> <20081203181202.GA10031@linux.vnet.ibm.com> <1228392866.19553.36.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228392866.19553.36.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 12:14:26PM +0000, Catalin Marinas wrote:
> Hi Paul,
> 
> On Wed, 2008-12-03 at 10:12 -0800, Paul E. McKenney wrote:
> > On Thu, Nov 20, 2008 at 11:30:34AM +0000, Catalin Marinas wrote:
> > > This patch adds the base support for the kernel memory leak
> > > detector. It traces the memory allocation/freeing in a way similar to
> > > the Boehm's conservative garbage collector, the difference being that
> > > the unreferenced objects are not freed but only shown in
> > > /sys/kernel/debug/memleak. Enabling this feature introduces an
> > > overhead to memory allocations.
> > 
> > I have some concerns about your locking/RCU design, please see
> > interspersed questions and comments.
> 
> Thanks for reviewing the locking. This was probably the hardest part of
> kmemleak. It had several incarnations and slowly got towards a finer
> grained locking.

And I should have also pointed out that a memory-leak detector is an
extremely useful thing!!!  I look forward to its acceptance.

> I'll comment below as well but I'll first show my logic which I added as
> comment at the top of the memleak.c file:

This is very helpful, thank you!  (And please accept my apologies if I
missed seeing it in my earlier review.)

>  * The following locks are used by kmemleak:
>  * 
>  * - object_list_lock (spinlock): protects the object_list. This is the main
>  *   list holding the metadata (struct memleak_object) for the allocated
>  *   objects. The memleak_object structures are added to the list in the
>  *   create_object() function called from the memleak_alloc() callback. They
>  *   are removed from the list in put_object() if the object->use_count is 0

This part sounds good.  I would also add that once object->use_count is
zero, no one is allowed to increment it.  Also, attempts to increment
object->use_count must be under the protection of rcu_read_lock(),
correct?

>  * - object_tree_lock (rwlock): protects the object_tree_root. When the
>  *   metadata is created in create_object(), it is added to the object prio
>  *   search tree and removed in delete_object() with this lock held
>  *   (write_lock). This lock is also acquired (read_lock) in
>  *   find_and_get_object() when an object needs to be looked up by a pointer
>  *   value (either during scanning or when changing its properties like
>  *   marking as false positive)

Looks OK.  I must confess that I am a bit fuzzy on the purpose of
object_tree_root vs. object_list.

>  * - memleak_object.lock (spinlock): protects a memleak_object. Modifications
>  *   of the metadata (e.g. count) are protected by this lock. Note that some
>  *   members of this structure may be protected by other means (atomic or
>  *   object_list lock). This lock is also held when scanning the corresponding
>  *   object to avoid the kernel freeing it via the memleak_free() callback.
>  *   This is less heavyweight than holding a global lock like object_list_lock
>  *   during scanning

OK, holding an object's lock can protect that object from deletion,
but only after you actually acquire the lock.  There must be some other
mechanism preventing the object from being freed during the actual
acquisition of the lock.

Now this might be the object_list_lock, object_tree_lock, RCU, or some
combination of the three, for example it might depend on how that object
is looked up.

>  * The only mutex used is scan_mutex. This ensures that only one thread may
>  * scan the memory for unreferenced objects at a time. The gray_list contains
>  * the objects which are already referenced or marked as false positives and
>  * need to be scanned. This list is only modified during a scanning episode
>  * when the scan_mutex is held. At the end of a scan, the gray_list is always
>  * empty. Note that the memleak_object.use_count is incremented when an object
>  * is added to the gray_list and therefore cannot be freed.

This is quite helpful -- I totally missed this mutex.

>  * Freeing a memleak_object is done via an RCU callback invoked from
>  * put_object() when its use_count is 0 and after removing it from the
>  * object_list. One of the reasons for the RCU is to delay the freeing and
>  * avoid a recursive call into the allocator via kmem_cache_free(). Another
>  * reason is to allow lock-less object_list traversal during memleak_scan().

I did figure out the lock-less object_list traversal, but totally missed
the fact that you were using RCU to prevent infinite recursion.  Cute!

Also, the memleak_object must have been removed from object_tree before
its use_count can possibly go to 0, correct?

> > > +static void free_object_rcu(struct rcu_head *rcu)
> > > +{
> > > +	struct hlist_node *elem, *tmp;
> > > +	struct memleak_scan_area *area;
> > > +	struct memleak_object *object =
> > > +		container_of(rcu, struct memleak_object, rcu);
> > > +
> > > +	/* once use_count is 0, there is no code accessing the object */
> > 
> > OK, so we won't pass free_object_rcu() to call_rcu() until use_count
> > is equal to zero.  And once use_count is zero, it is never incremented.
> > So the point of the RCU grace period is to ensure that all tasks
> > who didn't quite call get_object() soon enough get done failing
> > before we free up the object, correct?
> > 
> > Which means that get_object() needs to be under rcu_read_lock()...
> 
> My view here is that if use_count is 0, no other thread would be able to
> use this object. It will also be removed from the object_list and hence
> no other way to get this this object.

What if some other CPU picked up a pointer to the object just before it
was removed from the list?  If that CPU was not under the protection of
rcu_read_lock(), and if that CPU was delayed, then the object could be
freed (and possibly re-allocated as something else) before the CPU got
around to doing the atomic_inc_not_zero().

Keep in mind that spinlocks can be preempted in -rt kernels, so it
is possible for the CPU to be delayed a -long- time.

So I believe you really do need all get_object() calls to either be under
the protection of rcu_read_lock() or under the protection of some lock
that excludes both deletion -and- lookup-for-deletion of that object.

It looks to me that the code currently does the right thing here, just
want to make sure I understand the locking and that we don't end up
tempting someone later to break it.  ;-)

>                                       I think it would have worked
> pretty much OK without the RCU *but* the main reason for the grace
> period is to avoid a recursive call into kmem_cache_free() since
> put_object() is quite likely called via kmem_cache_free() ->
> memleak_free() -> delete_object(). The alternative is to use a work
> queue or something else but the RCU already had the infrastructure and I
> also gained a lock-less object_list traversal in memleak_scan().

Yep, as noted earlier, I missed this prevent-infinite-recursion aspect,
and it is pretty cute.

> > > +static void put_object(struct memleak_object *object)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	if (!atomic_dec_and_test(&object->use_count))
> > > +		return;
> > > +
> > > +	/* should only get here after delete_object was called */
> > > +	BUG_ON(object->flags & OBJECT_ALLOCATED);
> > > +
> > > +	spin_lock_irqsave(&object_list_lock, flags);
> > 
> > We also need to write-hold the object_tree_lock, not?
> 
> Not here, the memleak_object is removed from the object_tree in the
> delete_object() function (via from the memleak_free callback). If it is
> in the object_tree, it should have a use_count >= 1.

So the code never calls the last put_object() without first having
called delete_object() to remove it from the object_tree?  The "last"
put_object() being the one that decrements object->use_count to zero.

> > > +	/* the last reference to this object */
> > > +	list_del_rcu(&object->object_list);
> > > +	call_rcu(&object->rcu, free_object_rcu);
> > > +	spin_unlock_irqrestore(&object_list_lock, flags);
> > > +}
> > > +
> > > +static struct memleak_object *find_and_get_object(unsigned long ptr, int alias)
> > > +{
> > > +	unsigned long flags;
> > > +	struct memleak_object *object;
> > > +
> > > +	read_lock_irqsave(&object_tree_lock, flags);
> > 
> > Use of read_lock_irqsave() will work, but only if -all- deletions are
> > protected by write-acquiring object_tree_lock.
> 
> Yes, deletions (in delete_object) are protected by
> write_lock(object_tree_lock).
> 
> > Or unless there is an enclosing rcu_read_lock() around all calls to
> > find_and_get_object().
> 
> Not needed in my opinion since if it is in the object_tree, it has
> use_count >= 1 anyway and the RCU callback for freeing won't be invoked.

Yep, if all deletions are protected by write_lock(object_tree_lock),
then you -don't- need rcu_read_lock() around all find_and_get_object().

> > > +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> [...]
> > > +	write_lock_irqsave(&object_tree_lock, flags);
> > > +	node = prio_tree_insert(&object_tree_root, &object->tree_node);
> > > +	if (node != &object->tree_node) {
> > > +		unsigned long flags;
> > > +
> > > +		pr_warning("kmemleak: existing pointer\n");
> > > +		dump_stack();
> > > +
> > > +		object = lookup_object(ptr, 1);
> > > +		spin_lock_irqsave(&object->lock, flags);
> > > +		dump_object_info(object);
> > > +		spin_unlock_irqrestore(&object->lock, flags);
> > > +
> > > +		panic("kmemleak: cannot insert 0x%lx into the object search tree\n",
> > > +		      ptr);
> > > +	}
> > > +	write_unlock_irqrestore(&object_tree_lock, flags);
> > 
> > In theory, you are OK here, but only because the below is adding
> > an element (not removing it).  But this code is looking pretty dodgy.
> > 
> > What exactly does object_tree_lock protect?  What exactly does
> > object_list protect?
> 
> See my explanation at the beginning. I separated the locking for the
> object_list and the object_tree_root (prio search tree). I think I could
> have held the object_tree_lock only for the prio_tree_insert() call.

I can't say I understand the code well enough to say for sure, but
if that is true, it would make the locking easier for me to understand.

> > > +static void memleak_scan(void)
> [...]
> > > +		/* reset the reference count (whiten the object) */
> > > +		object->count = 0;
> > > +		if (color_gray(object) && get_object(object))
> > > +			list_add_tail(&object->gray_list, &gray_list);
> > 
> > What prevents other tasks from concurrently adding other objects to
> > gray_list?  Preventing such concurrent adds is absolutely required,
> > otherwise gray_list will be corrupted.
> 
> There is scan_mutex for this.

Good point -- I totally missed the fact that scan_mutex even existed.

> > > +static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > > +{
> > > +	struct list_head *n;
> > > +	struct memleak_object *next = NULL;
> > > +	unsigned long flags;
> > > +
> > > +	++(*pos);
> > > +	if (reported_leaks >= REPORTS_NR)
> > > +		goto out;
> > > +
> > > +	spin_lock_irqsave(&object_list_lock, flags);
> > 
> > Using a spinlock instead of rcu_read_lock() is OK, but only if all
> > updates are also protected by this same spinlock.  Which means that,
> > given that find_and_get_object read-acquires object_tree_lock, deletions
> > must be projected both by object_list_lock and by write-acquiring
> > object_tree_lock.  Or all calls to memleak_seq_next need to be covered
> > by rcu_read_lock().
> 
> The spin_lock here is only to retrieve the next object in the list but I
> agree that even if the object_list modifications are protected by
> object_list_lock, put_object could actually set the use_count to 0 and
> get_object return in this function isn't checked. If get_object returns
> successfully, I don't think an rcu_read_lock() is needed since
> put_object() can no longer invoke free_object_rcu().

OK, so let me see if I understand:

	The memleak_object passed in via the "v" argument to
	memleak_seq_next() was get_object()-ed by some prior
	call, either an earlier memleak_seq_next() or presumably
	by memleak_seq_start().

	memleak_seq_start() -does- do its scan under RCU protection,
	so looks OK.

	I believe you also need RCU protection in memleak_seq_next()
	to prevent the next memleak_object from disappearing
	during the traversal.  Yes, you do greatly decrease the
	odds of this happening by having irqs disabled, but the
	fact is that RCU is within its rights to end a grace
	period during this time.

Assuming that I do understand, as you say, if the get_object() in
memleak_seq_next() fails, we could end up accessing freed-up memory on
the next call to memleak_seq_next(), or even during the current one,
assuming an aggressive RCU or an extended NMI, SMI, burst of ECC errors
or some other delay.  So I agree that it is necessary to check the return
value of get_object().

Also, I do see the put_object() call in memleak_seq_stop(), but it looks
to me that this only does a put_object() on the last memleak_object.
What does the put_object() on the earlier memleak_object structures that
were scanned by memleak_seq_next?  Or is there never more than one
such object in a given list?

							Thanx, Paul
