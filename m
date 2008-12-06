Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYLFXHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYLFXHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLFXHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:07:37 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42634 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbYLFXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:07:36 -0500
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081204165536.GA6753@linux.vnet.ibm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
	 <20081203181202.GA10031@linux.vnet.ibm.com>
	 <1228392866.19553.36.camel@pc1117.cambridge.arm.com>
	 <20081204165536.GA6753@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 06 Dec 2008 23:07:30 +0000
Message-Id: <1228604850.8621.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2008 23:07:31.0273 (UTC) FILETIME=[6A89E390:01C957F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 08:55 -0800, Paul E. McKenney wrote:
> On Thu, Dec 04, 2008 at 12:14:26PM +0000, Catalin Marinas wrote:
> > On Wed, 2008-12-03 at 10:12 -0800, Paul E. McKenney wrote:
> > > On Thu, Nov 20, 2008 at 11:30:34AM +0000, Catalin Marinas wrote:
> > > > This patch adds the base support for the kernel memory leak
> > > > detector. It traces the memory allocation/freeing in a way similar to
> > > > the Boehm's conservative garbage collector, the difference being that
> > > > the unreferenced objects are not freed but only shown in
> > > > /sys/kernel/debug/memleak. Enabling this feature introduces an
> > > > overhead to memory allocations.
> > > 
> > > I have some concerns about your locking/RCU design, please see
> > > interspersed questions and comments.
[...]
> > I'll comment below as well but I'll first show my logic which I added as
> > comment at the top of the memleak.c file:
> 
> This is very helpful, thank you!  (And please accept my apologies if I
> missed seeing it in my earlier review.)

You haven't missed it, that's the first time I posted this text.

> >  * The following locks are used by kmemleak:
> >  * 
> >  * - object_list_lock (spinlock): protects the object_list. This is the main
> >  *   list holding the metadata (struct memleak_object) for the allocated
> >  *   objects. The memleak_object structures are added to the list in the
> >  *   create_object() function called from the memleak_alloc() callback. They
> >  *   are removed from the list in put_object() if the object->use_count is 0
> 
> This part sounds good.  I would also add that once object->use_count is
> zero, no one is allowed to increment it.  Also, attempts to increment
> object->use_count must be under the protection of rcu_read_lock(),
> correct?

So, to make sure I understand it correctly, the rcu_read_lock() is
needed to protect between the point where the object pointer was
obtained to the get_object() point. Would it also work if
spin_lock_irqsave(object_list_lock) is used instead of rcu_read_lock()?
The call_rcu() in put_object is bracketed with object_list_lock.

BTW, I'll have a look if I could remove an object from the object_list
in delete_object() rather than waiting until put_object().

> >  * - object_tree_lock (rwlock): protects the object_tree_root. When the
> >  *   metadata is created in create_object(), it is added to the object prio
> >  *   search tree and removed in delete_object() with this lock held
> >  *   (write_lock). This lock is also acquired (read_lock) in
> >  *   find_and_get_object() when an object needs to be looked up by a pointer
> >  *   value (either during scanning or when changing its properties like
> >  *   marking as false positive)
> 
> Looks OK.  I must confess that I am a bit fuzzy on the purpose of
> object_tree_root vs. object_list.

object_list holds all the memleak_objects in the system and it is
traversed when preparing the scanning and also when reporting the leaks.

object_tree_root is used to look-up memleak_objects by the allocated
memory block. In the past, this used to be a radix tree (with some
lockdep problems) and later a hash. I now use a prio tree because it
allows pointer ranges.

Kmemleak could probably iterate over the object_tree_root when reporting
but it is more convenient to report the leaks in the order they were
allocated (preserved by object_list) since one leak may trigger many
subsequent reports but they disappear once the first one is solved.

> >  * - memleak_object.lock (spinlock): protects a memleak_object. Modifications
> >  *   of the metadata (e.g. count) are protected by this lock. Note that some
> >  *   members of this structure may be protected by other means (atomic or
> >  *   object_list lock). This lock is also held when scanning the corresponding
> >  *   object to avoid the kernel freeing it via the memleak_free() callback.
> >  *   This is less heavyweight than holding a global lock like object_list_lock
> >  *   during scanning
> 
> OK, holding an object's lock can protect that object from deletion,
> but only after you actually acquire the lock.  There must be some other
> mechanism preventing the object from being freed during the actual
> acquisition of the lock.
> 
> Now this might be the object_list_lock, object_tree_lock, RCU, or some
> combination of the three, for example it might depend on how that object
> is looked up.

Correct. I'll have to review this again.

> >  * Freeing a memleak_object is done via an RCU callback invoked from
> >  * put_object() when its use_count is 0 and after removing it from the
> >  * object_list. One of the reasons for the RCU is to delay the freeing and
> >  * avoid a recursive call into the allocator via kmem_cache_free(). Another
> >  * reason is to allow lock-less object_list traversal during memleak_scan().
> 
> I did figure out the lock-less object_list traversal, but totally missed
> the fact that you were using RCU to prevent infinite recursion.  Cute!

It wasn't documented, so pretty hard to guess.

> Also, the memleak_object must have been removed from object_tree before
> its use_count can possibly go to 0, correct?

Yes.

> > > > +static void free_object_rcu(struct rcu_head *rcu)
> > > > +{
> > > > +	struct hlist_node *elem, *tmp;
> > > > +	struct memleak_scan_area *area;
> > > > +	struct memleak_object *object =
> > > > +		container_of(rcu, struct memleak_object, rcu);
> > > > +
> > > > +	/* once use_count is 0, there is no code accessing the object */
> > > 
> > > OK, so we won't pass free_object_rcu() to call_rcu() until use_count
> > > is equal to zero.  And once use_count is zero, it is never incremented.
> > > So the point of the RCU grace period is to ensure that all tasks
> > > who didn't quite call get_object() soon enough get done failing
> > > before we free up the object, correct?
> > > 
> > > Which means that get_object() needs to be under rcu_read_lock()...
> > 
> > My view here is that if use_count is 0, no other thread would be able to
> > use this object. It will also be removed from the object_list and hence
> > no other way to get this this object.
> 
> What if some other CPU picked up a pointer to the object just before it
> was removed from the list?  If that CPU was not under the protection of
> rcu_read_lock(), and if that CPU was delayed, then the object could be
> freed (and possibly re-allocated as something else) before the CPU got
> around to doing the atomic_inc_not_zero().

OK, I got it now.

> It looks to me that the code currently does the right thing here, just
> want to make sure I understand the locking and that we don't end up
> tempting someone later to break it.  ;-)

I'll document it better and make sure it's clear for me as well.

> > > > +static void put_object(struct memleak_object *object)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	if (!atomic_dec_and_test(&object->use_count))
> > > > +		return;
> > > > +
> > > > +	/* should only get here after delete_object was called */
> > > > +	BUG_ON(object->flags & OBJECT_ALLOCATED);
> > > > +
> > > > +	spin_lock_irqsave(&object_list_lock, flags);
> > > 
> > > We also need to write-hold the object_tree_lock, not?
> > 
> > Not here, the memleak_object is removed from the object_tree in the
> > delete_object() function (via from the memleak_free callback). If it is
> > in the object_tree, it should have a use_count >= 1.
> 
> So the code never calls the last put_object() without first having
> called delete_object() to remove it from the object_tree?  The "last"
> put_object() being the one that decrements object->use_count to zero.

Yes.

> > > > +static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > > > +{
> > > > +	struct list_head *n;
> > > > +	struct memleak_object *next = NULL;
> > > > +	unsigned long flags;
> > > > +
> > > > +	++(*pos);
> > > > +	if (reported_leaks >= REPORTS_NR)
> > > > +		goto out;
> > > > +
> > > > +	spin_lock_irqsave(&object_list_lock, flags);
> > > 
> > > Using a spinlock instead of rcu_read_lock() is OK, but only if all
> > > updates are also protected by this same spinlock.  Which means that,
> > > given that find_and_get_object read-acquires object_tree_lock, deletions
> > > must be projected both by object_list_lock and by write-acquiring
> > > object_tree_lock.  Or all calls to memleak_seq_next need to be covered
> > > by rcu_read_lock().
> > 
> > The spin_lock here is only to retrieve the next object in the list but I
> > agree that even if the object_list modifications are protected by
> > object_list_lock, put_object could actually set the use_count to 0 and
> > get_object return in this function isn't checked. If get_object returns
> > successfully, I don't think an rcu_read_lock() is needed since
> > put_object() can no longer invoke free_object_rcu().
> 
> OK, so let me see if I understand:
> 
> 	The memleak_object passed in via the "v" argument to
> 	memleak_seq_next() was get_object()-ed by some prior
> 	call, either an earlier memleak_seq_next() or presumably
> 	by memleak_seq_start().

Yes.

> 	memleak_seq_start() -does- do its scan under RCU protection,
> 	so looks OK.
> 
> 	I believe you also need RCU protection in memleak_seq_next()
> 	to prevent the next memleak_object from disappearing
> 	during the traversal.  Yes, you do greatly decrease the
> 	odds of this happening by having irqs disabled, but the
> 	fact is that RCU is within its rights to end a grace
> 	period during this time.

I'll try to make the memleak_seq_next() function use rcu_dereference()
and rcu_read_lock(). ATM, the "v" object has use_count >= 1 (from a
previous get_object) and the next pointer is accessed under
object_list_lock, so no modifications to the list (even put_object
acquires this lock when invoking call_rcu). There is still the bug with
not checking the get_object() return.

> Assuming that I do understand, as you say, if the get_object() in
> memleak_seq_next() fails, we could end up accessing freed-up memory on
> the next call to memleak_seq_next(), or even during the current one,
> assuming an aggressive RCU or an extended NMI, SMI, burst of ECC errors
> or some other delay.  So I agree that it is necessary to check the return
> value of get_object().

Yes

> Also, I do see the put_object() call in memleak_seq_stop(), but it looks
> to me that this only does a put_object() on the last memleak_object.
> What does the put_object() on the earlier memleak_object structures that
> were scanned by memleak_seq_next?  Or is there never more than one
> such object in a given list?

The previous objects' use_count are decremented in memleak_seq_next()
just before returning "next", so between seq_start-seq_next and
seq_next-seq_stop, there is only one object with an incremented
use_count. The memleak_seq_next() function may have two such objects for
a small period of time.

I actually added a test for this in memleak_scan() (if DEBUG is defined)
and I've never got any reports. There may be some situations when for
very short periods of time the use_count is > 1 at the beginning of a
scan, usually when one of the memleak_scan_area or memleak_ignore
callbacks are invoked.

I'll revise the locking a bit and re-post the patches this week.

Thanks.

-- 
Catalin

