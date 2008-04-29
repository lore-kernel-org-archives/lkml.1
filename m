Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYD2MuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYD2MuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYD2Mt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:49:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYD2Mt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:49:58 -0400
Subject: Re: futex code and barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804291442050.22014@twin.jikos.cz>
References: <1209470236.13978.55.camel@twins>
	 <Pine.LNX.4.64.0804291442050.22014@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 14:49:36 +0200
Message-Id: <1209473376.13978.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 14:43 +0200, Jiri Kosina wrote:
> On Tue, 29 Apr 2008, Peter Zijlstra wrote:
> 
> > While looking through the futex code I stumbled upon the following bit:
> > kernel/futex.c:
> > 	/* add_wait_queue is the barrier after __set_current_state. */
> > 	__set_current_state(TASK_INTERRUPTIBLE);
> > 	add_wait_queue(&q.waiters, &wait);
> > However,
> > void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
> > {
> > 	unsigned long flags;
> > 
> > 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
> > 	spin_lock_irqsave(&q->lock, flags);
> > 	__add_wait_queue(q, wait);
> > 	spin_unlock_irqrestore(&q->lock, flags);
> > }
> [ ... ]
> > Non of which implies a full barrier.
> 
> Well I am probably missing the point, but what about the lock and unlock 
> of the spinlock?

See Documentation/memory-barriers.txt

quoted:

---

 (1) LOCK operation implication:

     Memory operations issued after the LOCK will be completed after the LOCK
     operation has completed.

     Memory operations issued before the LOCK may be completed after the LOCK
     operation has completed.

 (2) UNLOCK operation implication:

     Memory operations issued before the UNLOCK will be completed before the
     UNLOCK operation has completed.

     Memory operations issued after the UNLOCK may be completed before the
     UNLOCK operation has completed.

 (3) LOCK vs LOCK implication:

     All LOCK operations issued before another LOCK operation will be completed
     before that LOCK operation.

 (4) LOCK vs UNLOCK implication:

     All LOCK operations issued before an UNLOCK operation will be completed
     before the UNLOCK operation.

     All UNLOCK operations issued before a LOCK operation will be completed
     before the LOCK operation.

 (5) Failed conditional LOCK implication:

     Certain variants of the LOCK operation may fail, either due to being
     unable to get the lock immediately, or due to receiving an unblocked
     signal whilst asleep waiting for the lock to become available.  Failed
     locks do not imply any sort of barrier.

Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.

[!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
    barriers is that the effects of instructions outside of a critical section
    may seep into the inside of the critical section.

A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
because it is possible for an access preceding the LOCK to happen after the
LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
two accesses can themselves then cross:

        *A = a;
        LOCK
        UNLOCK
        *B = b;

may occur as:

        LOCK, STORE *B, STORE *A, UNLOCK

Locks and semaphores may not provide any guarantee of ordering on UP compiled
systems, and so cannot be counted on in such a situation to actually achieve
anything at all - especially with respect to I/O accesses - unless combined
with interrupt disabling operations.

See also the section on "Inter-CPU locking barrier effects".


As an example, consider the following:

        *A = a;
        *B = b;
        LOCK
        *C = c;
        *D = d;
        UNLOCK
        *E = e;
        *F = f;

The following sequence of events is acceptable:

        LOCK, {*F,*A}, *E, {*C,*D}, *B, UNLOCK

        [+] Note that {*F,*A} indicates a combined access.

But none of the following are:

        {*F,*A}, *B,    LOCK, *C, *D,   UNLOCK, *E
        *A, *B, *C,     LOCK, *D,       UNLOCK, *E, *F
        *A, *B,         LOCK, *C,       UNLOCK, *D, *E, *F
        *B,             LOCK, *C, *D,   UNLOCK, {*F,*A}, *E



