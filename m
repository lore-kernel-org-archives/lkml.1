Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYB2Fnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYB2Fnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYB2Fno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:43:44 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46141 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYB2Fnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:43:43 -0500
Date: Thu, 28 Feb 2008 22:43:22 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080229054322.GC19198@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx> <1204180441-8540-4-git-send-email-matthew@wil.cx> <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <20080228175729.e7bebc44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228175729.e7bebc44.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:57:29PM -0800, Andrew Morton wrote:
> This make all architectures use the lib/semaphore-sleepers.c
> implementation.

It's slightly different -- I didn't use any existing semaphore
implementation for inspiration (though I did write the parisc one,
so I couldn't help but be influenced).  I was much more influenced
by mutex.c.  After I'd posted it the first time, dhowells pointed out
it was essentially the same as FRV's implementation.

> The major difference is that down() and up() will now
> unconditionally do a spin_lock_irq[save]() on the not-contended fastpath,
> whereas the hand-optimised arch-specific implementations would avoid that.
> 
> Yes, hopefully not many sempahores are used on fastpaths any more, and a
> suitable fix for any which _are_ so used is usually convert-to-mutex.
> 
> And spin_lock_irqsave() probably isn't hugely slower than an atomic-dec
> anyway.

As always, the major cost is getting the cacheline exclusive on this
CPU.  I'd be surprised if you can measure the difference.

> A few nits, most or all of which pertain to the old code:

Thanks for the review.

> > +static void noinline __down(struct semaphore *sem);
> > +static int noinline __down_interruptible(struct semaphore *sem);
> > +static int noinline __down_killable(struct semaphore *sem);
> > +static void noinline __up(struct semaphore *sem);
> 
> We conventionally do `static inline void' rather than `static void inline',
> so I guess we should do `static noinline void' too.

I can change that.  I'll modify the git tree, unless anyone has any
complaints.  We should fix mutex.c at the same time:

static void noinline __sched
__mutex_lock_slowpath(atomic_t *lock_count);

> > +int down_interruptible(struct semaphore *sem)
> > +{
> > +	int result = 0;
> > +	might_sleep();
> > +	spin_lock_irq(&sem->lock);
> > +	if (unlikely(sem->count-- <= 0))
> > +		result = __down_interruptible(sem);
> > +	spin_unlock_irq(&sem->lock);
> > +	return result;
> > +}
> > +EXPORT_SYMBOL(down_interruptible);
> 
> Some functions leave no blank line between end-of-locals and start-of-code...

It's not something I feel strongly about ;-)

> whereas some others do leave a blank line.
> 
> I think the 51% consensus is that the latter form is preferred.

Fine.

> > +static void noinline __sched __up_down_common(struct semaphore *sem)
> > +{
> > +	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
> > +						struct semaphore_waiter, list);
> > +	list_del(&waiter->list);
> > +	waiter->up = 1;
> 
> hm.  Do we need a barrier here?

__up_down_common is always called while holding the spinlock.  The
spinlock is acquired by the waiter before it checks the flag.  If
there's a race here, I question the value of spinlocks at all.

> > +	wake_up_process(waiter->task);


> > + * Because this function is inlined, the 'state' parameter will be constant,
> > + * and thus optimised away by the compiler.
> > + */

> That is one huuuuuuuge inline.  Are we sure it's justified?

It's a mirror of __mutex_lock_common ... I don't believe it's justified
in one case and not the other.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
