Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbYLDMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbYLDMOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYLDMOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:14:33 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61171 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYLDMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:14:31 -0500
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081203181202.GA10031@linux.vnet.ibm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
	 <20081203181202.GA10031@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 04 Dec 2008 12:14:26 +0000
Message-Id: <1228392866.19553.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2008 12:14:27.0321 (UTC) FILETIME=[DA41CE90:01C95609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, 2008-12-03 at 10:12 -0800, Paul E. McKenney wrote:
> On Thu, Nov 20, 2008 at 11:30:34AM +0000, Catalin Marinas wrote:
> > This patch adds the base support for the kernel memory leak
> > detector. It traces the memory allocation/freeing in a way similar to
> > the Boehm's conservative garbage collector, the difference being that
> > the unreferenced objects are not freed but only shown in
> > /sys/kernel/debug/memleak. Enabling this feature introduces an
> > overhead to memory allocations.
> 
> I have some concerns about your locking/RCU design, please see
> interspersed questions and comments.

Thanks for reviewing the locking. This was probably the hardest part of
kmemleak. It had several incarnations and slowly got towards a finer
grained locking.

I'll comment below as well but I'll first show my logic which I added as
comment at the top of the memleak.c file:

 * The following locks are used by kmemleak:
 * 
 * - object_list_lock (spinlock): protects the object_list. This is the main
 *   list holding the metadata (struct memleak_object) for the allocated
 *   objects. The memleak_object structures are added to the list in the
 *   create_object() function called from the memleak_alloc() callback. They
 *   are removed from the list in put_object() if the object->use_count is 0
 * - object_tree_lock (rwlock): protects the object_tree_root. When the
 *   metadata is created in create_object(), it is added to the object prio
 *   search tree and removed in delete_object() with this lock held
 *   (write_lock). This lock is also acquired (read_lock) in
 *   find_and_get_object() when an object needs to be looked up by a pointer
 *   value (either during scanning or when changing its properties like
 *   marking as false positive)
 * - memleak_object.lock (spinlock): protects a memleak_object. Modifications
 *   of the metadata (e.g. count) are protected by this lock. Note that some
 *   members of this structure may be protected by other means (atomic or
 *   object_list lock). This lock is also held when scanning the corresponding
 *   object to avoid the kernel freeing it via the memleak_free() callback.
 *   This is less heavyweight than holding a global lock like object_list_lock
 *   during scanning
 *
 * The only mutex used is scan_mutex. This ensures that only one thread may
 * scan the memory for unreferenced objects at a time. The gray_list contains
 * the objects which are already referenced or marked as false positives and
 * need to be scanned. This list is only modified during a scanning episode
 * when the scan_mutex is held. At the end of a scan, the gray_list is always
 * empty. Note that the memleak_object.use_count is incremented when an object
 * is added to the gray_list and therefore cannot be freed.
 *
 * Freeing a memleak_object is done via an RCU callback invoked from
 * put_object() when its use_count is 0 and after removing it from the
 * object_list. One of the reasons for the RCU is to delay the freeing and
 * avoid a recursive call into the allocator via kmem_cache_free(). Another
 * reason is to allow lock-less object_list traversal during memleak_scan().

> > +static void free_object_rcu(struct rcu_head *rcu)
> > +{
> > +	struct hlist_node *elem, *tmp;
> > +	struct memleak_scan_area *area;
> > +	struct memleak_object *object =
> > +		container_of(rcu, struct memleak_object, rcu);
> > +
> > +	/* once use_count is 0, there is no code accessing the object */
> 
> OK, so we won't pass free_object_rcu() to call_rcu() until use_count
> is equal to zero.  And once use_count is zero, it is never incremented.
> So the point of the RCU grace period is to ensure that all tasks
> who didn't quite call get_object() soon enough get done failing
> before we free up the object, correct?
> 
> Which means that get_object() needs to be under rcu_read_lock()...

My view here is that if use_count is 0, no other thread would be able to
use this object. It will also be removed from the object_list and hence
no other way to get this this object. I think it would have worked
pretty much OK without the RCU *but* the main reason for the grace
period is to avoid a recursive call into kmem_cache_free() since
put_object() is quite likely called via kmem_cache_free() ->
memleak_free() -> delete_object(). The alternative is to use a work
queue or something else but the RCU already had the infrastructure and I
also gained a lock-less object_list traversal in memleak_scan().

> > +static void put_object(struct memleak_object *object)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (!atomic_dec_and_test(&object->use_count))
> > +		return;
> > +
> > +	/* should only get here after delete_object was called */
> > +	BUG_ON(object->flags & OBJECT_ALLOCATED);
> > +
> > +	spin_lock_irqsave(&object_list_lock, flags);
> 
> We also need to write-hold the object_tree_lock, not?

Not here, the memleak_object is removed from the object_tree in the
delete_object() function (via from the memleak_free callback). If it is
in the object_tree, it should have a use_count >= 1.

> > +	/* the last reference to this object */
> > +	list_del_rcu(&object->object_list);
> > +	call_rcu(&object->rcu, free_object_rcu);
> > +	spin_unlock_irqrestore(&object_list_lock, flags);
> > +}
> > +
> > +static struct memleak_object *find_and_get_object(unsigned long ptr, int alias)
> > +{
> > +	unsigned long flags;
> > +	struct memleak_object *object;
> > +
> > +	read_lock_irqsave(&object_tree_lock, flags);
> 
> Use of read_lock_irqsave() will work, but only if -all- deletions are
> protected by write-acquiring object_tree_lock.

Yes, deletions (in delete_object) are protected by
write_lock(object_tree_lock).

> Or unless there is an enclosing rcu_read_lock() around all calls to
> find_and_get_object().

Not needed in my opinion since if it is in the object_tree, it has
use_count >= 1 anyway and the RCU callback for freeing won't be invoked.

> > +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
[...]
> > +	write_lock_irqsave(&object_tree_lock, flags);
> > +	node = prio_tree_insert(&object_tree_root, &object->tree_node);
> > +	if (node != &object->tree_node) {
> > +		unsigned long flags;
> > +
> > +		pr_warning("kmemleak: existing pointer\n");
> > +		dump_stack();
> > +
> > +		object = lookup_object(ptr, 1);
> > +		spin_lock_irqsave(&object->lock, flags);
> > +		dump_object_info(object);
> > +		spin_unlock_irqrestore(&object->lock, flags);
> > +
> > +		panic("kmemleak: cannot insert 0x%lx into the object search tree\n",
> > +		      ptr);
> > +	}
> > +	write_unlock_irqrestore(&object_tree_lock, flags);
> 
> In theory, you are OK here, but only because the below is adding
> an element (not removing it).  But this code is looking pretty dodgy.
> 
> What exactly does object_tree_lock protect?  What exactly does
> object_list protect?

See my explanation at the beginning. I separated the locking for the
object_list and the object_tree_root (prio search tree). I think I could
have held the object_tree_lock only for the prio_tree_insert() call.

> > +static void memleak_scan(void)
[...]
> > +		/* reset the reference count (whiten the object) */
> > +		object->count = 0;
> > +		if (color_gray(object) && get_object(object))
> > +			list_add_tail(&object->gray_list, &gray_list);
> 
> What prevents other tasks from concurrently adding other objects to
> gray_list?  Preventing such concurrent adds is absolutely required,
> otherwise gray_list will be corrupted.

There is scan_mutex for this.

> > +static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +	struct list_head *n;
> > +	struct memleak_object *next = NULL;
> > +	unsigned long flags;
> > +
> > +	++(*pos);
> > +	if (reported_leaks >= REPORTS_NR)
> > +		goto out;
> > +
> > +	spin_lock_irqsave(&object_list_lock, flags);
> 
> Using a spinlock instead of rcu_read_lock() is OK, but only if all
> updates are also protected by this same spinlock.  Which means that,
> given that find_and_get_object read-acquires object_tree_lock, deletions
> must be projected both by object_list_lock and by write-acquiring
> object_tree_lock.  Or all calls to memleak_seq_next need to be covered
> by rcu_read_lock().

The spin_lock here is only to retrieve the next object in the list but I
agree that even if the object_list modifications are protected by
object_list_lock, put_object could actually set the use_count to 0 and
get_object return in this function isn't checked. If get_object returns
successfully, I don't think an rcu_read_lock() is needed since
put_object() can no longer invoke free_object_rcu().

Thanks for your time.

-- 
Catalin

