Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbZJWAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbZJWAkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 20:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJWAkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 20:40:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56353 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZJWAkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:40:31 -0400
Date: Thu, 22 Oct 2009 17:40:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel RCU: shrink the size of the struct rcu_head
Message-ID: <20091023004034.GF6277@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091018232918.GA7385@Krystal> <20091020220728.GA6174@linux.vnet.ibm.com> <20091021145315.GA25791@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021145315.GA25791@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 10:53:15AM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sun, Oct 18, 2009 at 07:29:18PM -0400, Mathieu Desnoyers wrote:
> > > Hi Paul,
> > > 
> > > I noticed that you already discussed the possibility of shrinking the
> > > struct rcu_head by removing the function pointer.
> > > (http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html)
> > > 
> > > The ideas brought in so far require having per-callback lists, which
> > > involves a bit of management overhead and don't permit keeping the
> > > call_rcu() in cpu order.
> > 
> > But please note that this is on the "Possibly Dubious Changes" list.  ;-)
> > 
> > > You might want to look into the Userspace RCU urcu-defer.c
> > > implementation, where I perform pointer encoding to compact the usual
> > > case, expected to be the same callback passed as parameter multiple
> > > times in a row to call_rcu(). This is very typical with multiple free()
> > > calls for different data structures next to each other.
> > > 
> > > This typically keeps the size of the information to encode per callback
> > > down to a minimum: the size of a single pointer. It would be good to
> > > trace the kernel usage of call_rcu() to see if my assumption holds.
> > > 
> > > I just thought I should tell you before you start looking at this
> > > issue further.
> > 
> > So the idea is to maintain a per-CPU queue of function pointers, but
> > with the pointers on this queue encoded to save space, correct?
> 
> Yes, exactly.

OK, I will add something to this effect on my rcutodo page.

> >  If I
> > understand correctly, the user-level rcu-defer implementation relies on
> > the following:
> > 
> > 1.	It is illegal to call _rcu_defer_queue() within an RCU read-side
> > 	critical section (due to the call to rcu_defer_barrier_thread()
> > 	which in turn calls synchronize_rcu().  This is necessary to
> > 	handle queue overflow.  (Which appears to be why you introduce
> > 	a new API, as it is legal to invoke call_rcu() from within an
> > 	RCU read-side critical section.)
> 
> When dealing with queue overflow, I figured we have 4 alternatives.
> Either:
> 
> 1, 2, 3) We proceed to execution of {the single, all, thread local}
>          callback(s) on the spot after a synchronize_rcu().
> 
> 4) We expand the queue by allocating more memory.
> 
> The idea of pointer encoding to save space could be used with any of 1,
> 2, 3, or 4. As you say, call_rcu() requires (4), because it tolerates
> being called from an rcu read-side C.S.. 1, 2, 3 are incompatible with
> read-side C.S. context because they require to use synchronize_rcu()
> within the C.S., which would deadlock on its calling context.
> 
> Now, there is a rationale for the choice of (3) in my urcu-defer
> implementation:
> 
> * It's how I can deal with memory full (-ENOMEM) without letting the
>   system die with exit(). How does the kernel call_rcu() deal with this
>   currently ? BUG_ON, WARN_ON ?

It doesn't have to do anything -- the caller of call_rcu() is responsible
for allocating any required memory.  So call_rcu() never allocates memory
and thus never needs to worry about a memory-allocation failure.

> * It acts as a rate limiter for urcu_defer_queue(). Basically, if a
>   thread starts enqueuing callbacks too fast, it will eventually fill its
>   queue and have to empty it itself. AFAIK, It's not possible to do that
>   if you allow call_rcu() to be called from read-side C.S..

Yep!  ;-)

> I could even extend rcu_defer_queue() to take a second rate-limiter
> callback, which would check if the thread went over some threshold and
> give a more precise limit (e.g. amount of memory to be freed) on the
> rate than the "4096 callbacks in flight max", which have been chosen by
> benchmarks, but is a bit arbitrary in terms of overall callback effect.
> 
> How important is it to permit enqueuing callbacks from within rcu
> read-side C.S. in terms of real-life usage ? If it is really that
> important to fill this use-case, then I could have a mode for call_rcu()
> that expands the RCU callback queue upon overflow. But as I argue above,
> I really prefer the control we have with a fixed-sized queue.

There are occurrences of this in the Linux kernel.  In theory, you could
always hang onto the object until leaving the outermost RCU read-side
critical section, but in practice this is not always consistent with
good software-engineering practice.

One use case is when you have an RCU-protected list, each element of
which has an RCU-protected list hanging off it.  In this case, you might
scan the upper-level list under RCU protection, but during the scan you
might need to remove elements from the lower-level list and pass them
to call_rcu().

So it really needs to be legal for call_rcu() to be invoked from within
an RCU read-side critical section.

> > 2.	It is OK to wait for a grace period when a thread calls
> > 	rcu_defer_unregister_thread() while exiting.  In the kernel,
> > 	this is roughly equivalent to the CPU_DYING notifier, which
> > 	cannot block, thus cannot wait for a grace period.
> > 
> > 	I could imagine copying the per-CPU buffer somewhere, though
> > 	my experience with the RCU/CPU-hotplug interface does not
> > 	encourage me in this direction.  ;-)
> 
> As you say, we don't _have_ to empty the queue before putting a
> thread/cpu offline. We could simply copy the unplugged cpu queue to an
> orphan queue, as you currently do in your implementation. I agree that
> it would be more suitable to the cpu hotplug CPU_DYING execution
> context, due to its inherent trickiness.

Especially if you want something like rcu_barrier() to continue working.

Hmmm...  Can user applications unload dynamically linked libraries?  ;-)

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > 							Thanx, Paul
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
