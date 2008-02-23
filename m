Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbYBWThI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbYBWThI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761367AbYBWTgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:36:50 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40483 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760745AbYBWTgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:36:46 -0500
Date: Sat, 23 Feb 2008 22:36:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org,
       Ingo Molnar <mingo@elte.hu>, nickpiggin@yahoo.com.au,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Message-ID: <20080223193620.GA89@tv-sign.ru>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org> <20080223162705.GA7686@tv-sign.ru> <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org> <20080223182258.GA19946@tv-sign.ru> <alpine.LFD.1.00.0802231044240.21332@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802231044240.21332@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Linus Torvalds wrote:
>
> On Sat, 23 Feb 2008, Oleg Nesterov wrote:
> > 
> > Yes, but still I suspect wmb() is not enough. Note that try_to_wake_up()
> > first checks (reads) the task->state,
> > 
> > 	if (!(old_state & state))
> > 		goto out;
> > 
> > without the full mb() it is (in theory) possible that try_to_wake_up()
> > first reads TASK_RUNNING and only then sets CONDITION. IOW, STORE and
> > LOAD could be re-ordered.
> 
> No. The spinlock can have preceding stores (and loads, for that matter) 
> percolate *into* the locked region, but a spinlock can *not* have loads 
> (and stores) escape *out* of the region withou being totally broken. 
> 
> So the spinlock that predeces that load of "old_state" absolutely *must* 
> be a memory barrier as far as that load is concerned.
> 
> Spinlocks are just "one-way" permeable. They stop both reads and writes, 
> but they stop them from escaping up to earlier code (and the spin-unlock 
> in turn stops reads and writes within the critical section from escaping 
> down past the unlock).
> 
> But they definitely must stop that direction, and no loads or stores that 
> are inside the critical section can possibly be allowed to be done outside 
> of it, or the spinlock would be pointless.

Yes sure. But I meant that the STORE (set CONDITION) can leak into the critical
section, and it could be re-ordered with the LOAD (check ->state) _inside_
the critical section.

However,

> So I think a simple smp_wmb() should be ok.

now I think you are probably right. Because (please ack/nack my understanding)
this smp_wmb() ensures that the preceding STORE can't actually go into
the locked region.

> That said, I do not *mind* the notion of "smp_mb_before/after_spinlock()", 
> and just have architectures do whatever they want (with x86 just being a 
> no-op). I don't think it's wrong in any way, and may be the really 
> generic solution for some theoretical case where locking is done not by 
> using the normal cache coherency, but over a separate lock network. But I 
> would suggest against adding new abstractions unless there are real cases 
> of it mattering.
> 
> (The biggest reason to do it in practice is probably architectures that 
> have a really slow smp_wmb() and that also have a spinlock that is already 
> serializing enough, but if this is only for one single use - in 
> try_to_wake_up() - even that doesn't really seem to be a very strong 
> argument).

Great.

> > A bit offtopic, but let's take another example, __queue_work()->insert_work().
> > With some trivial modification we can move set_wq_data() outside of cwq->lock.
> > But according to linux's memory model we still need wmb(), which is a bit
> > annoying. Perhaps we can also add smp_wmb_before_spinlock(). Not sure this
> > is not too ugly though.
> 
> Is that really so performance-critical? We still need the spinlock for the 
> actual list manipulation, so why would we care?
> 
> And the smp_wmb() really should be free. It's literally free on x86, but 
> doing a write barrier is generally a cheap operation on any sane 
> architecture (ie generally cheaper than a read barrier or a full barrier: 
> it should mostly be a matter of inserting a magic entry in the write 
> buffers).

Yes, yes, this was just a "on a related note", thanks!

Oleg.

