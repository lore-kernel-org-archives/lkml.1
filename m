Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbZIBKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbZIBKjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZIBKjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:39:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIBKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:39:18 -0400
Subject: Re: driver/base/dd.c lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Blunck <jblunck@suse.de>, Kay Sievers <kay.sievers@suse.de>,
       gregkh@suse.de, kasievers@suse.de, USB list <linux-usb@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <Pine.LNX.4.44L0.0909011146030.3190-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0909011146030.3190-100000@iolanthe.rowland.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Sep 2009 12:38:53 +0200
Message-Id: <1251887933.7547.141.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 11:50 -0400, Alan Stern wrote:
> On Tue, 1 Sep 2009, Jan Blunck wrote:
> 
> > On Tue, Sep 01, Alan Stern wrote:
> > 
> > > On Tue, 1 Sep 2009, Jan Blunck wrote:
> > > 
> > > > > This is semaphore->mutex conversion madness from tglx.  What he tried 
> > > > > to do just doesn't work with lockdep.
> > > > > 
> > > > 
> > > > If this is a parent->child relationship and the parent is always locked before
> > > > the child this works perfectly with lockdep. The inode->i_mutex is doing
> > > > it. How is the lock in your code different from that?
> > > 
> > > Maybe you're right and it's not different.  I'm not so sure.  What
> > > about parent-child-grandchild relationships?  What about situations
> > > where multiple siblings are locked concurrently after first acquiring
> > > the parent's lock to make it safe (not that I'm aware of any such
> > > things occurring in the kernel, but they might)?
> > 
> > You have to come up with a locking order on the siblings to make it deadlock
> > free. After that you teach the locking order to lockdep and everything should
> > be fine.
> 
> That's not true at all.  Provided you always lock the parent before 
> locking any of the children, the order in which you lock the children 
> doesn't matter; it cannot deadlock.
> 
> > If nobody is working on this I'll try to come up with a few patches tomorrow.
> 
> Okay.  Peter Zijlstra had some thoughts when this issue came up a week 
> or two ago, CC'ing him.
> 
> Do you have to specify at the time you lock a mutex whether it is a 
> parent or a child?  What happens if it is both?

OK, so the problem is that lockdep groups individual locks into classes
and does lock dependency computations on these classes instead of on
individual locks (this is what keeps the whole exercise feasible, this
also makes it more powerful in that we can detect a lock order inversion
before it actually happens).

When you nest two locks of the same class it can't say whether its the
same lock or two locks, nor can it determine if you do indeed observe a
proper locking order between two instances when it are indeed two
separate locks.

Classes are normally created per lock init site, that is, all locks
initialized from a particular spin_lock_init() site will belong to the
same class by default.

There's a number of lockdep annotations to help out.

 - *_lock_nested(&lock, subclass)

   It says: we know what we're doing, consider this lock in $subclass
   and lockdep will then consider this lock op part of a subclass.

   $subclass is limited to [0-7], and spin_lock(&lock) is equal to
   spin_lock_nested(&lock, 0). Also, any subclass is free to nest in any
   other, as long as its consistent.

   This is useful for limited nesting situations, eg. vfs parent/child
   inode relations.

   It is possible to annotate a real deadlock away using this, consider:

   void double_lock(spinlock_t *a, spinlock_t *b)
   {
	spin_lock(a);
	spin_lock_nested(b, SINGLE_DEPTH_NESTING);
   }

   double_lock(&lock1, &lock2);

   vs.   

   double_lock(&lock2, &lock1);

   This will _NOT_ warn, but will most certainly lead to a deadlock.

 - lockdep_set_class*(&lock, &lock_class_key, ...)

   This will manually assign a different lock class to a lock, and this
   needs to be done _after_ *_lock_init() but _before_ the first actual
   use of this lock.

   The struct lock_class_key _must_ be in static storage.

   An example is in the vfs, which uses this to separate the locks
   on an filesystem type basis, since some filesystems have different
   (and conflicting) locking orders.

 - spin_lock_nest_lock(&lock, &parent) 

   [ currently not available for mutexes for no other reason than
     that there is no user ]

   This will allow nesting of lock's class and validates parent is
   indeed taken.

   It will revert to counting lock instances and allows of up to 2048
   child locks of that particular class to nest. This weakens lockdep
   and lockstat in that the unlock() path doesn't know if it was indeed
   this particular lock, and lockstat in that it will only track the
   first lock instance.

   Again, this will allow annotating away read deadlocks, consider
   multiple child locks being taking without holding parent.

Furthermore, there is a limit of (48) locks that can be tracked at any
one time.

Now the particular issue at hand is that the device tree is a free form
tree with (afaiu) unlimited lock nesting depth -- if you were to plug in
an already daisy chained usb hub with actual devices on the 7th deep hub
device discovery will hold the device locks for the root hub, all 7
intermediate hubs and the child device, leading to a total of 9 locks.

And there is nothing fundamental -- other than the usb chain depth --
that limits this scenario, imagine the device to be an i2c bus with yet
more devices ;-)

[ There used to be the additional complexity that on suspend/resume
  we would hold _ALL_ device locks, which would exceed the max we can
  track for any one task, this however has long been fixed. ]


So the proposal I currently have to solve this is to allocate 48 lock
classes:

struct lock_class_key device_tree_depth[MAX_LOCK_DEPTH];

and when creating a new device node, set the lock class corresponding
the depth in the tree:

  mutex_lock_init(&device->lock);
  BUG_ON(device->depth >= MAX_LOCK_DEPTH); // surely we're not that deep
  lockdep_set_class(&device->lock, device_tree_depth + device->depth);
  ...
  mutex_lock(&device->lock); /* already have parent locked */
  device_attach(device, parent);

and take multiple child locks using:

  mutex_lock_nest_lock(&device->lock, &device->parent->lock);

Which, I think should work for most cases out there.

Alan had some funny corner cases, but I think he wasn't sure whether
those would indeed show up in reality.
