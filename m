Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbYBWUDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbYBWUDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYBWUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:03:33 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYBWUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:03:32 -0500
Date: Sat, 23 Feb 2008 12:02:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, apw@shadowen.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
 added to -mm tree
In-Reply-To: <b647ffbd0802231141y4088b8e5g793a1a186a56871d@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802231152260.21332@woody.linux-foundation.org>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>  <20080223162705.GA7686@tv-sign.ru>  <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org> <b647ffbd0802231141y4088b8e5g793a1a186a56871d@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Dmitry Adamushko wrote:
> 
> No, wmb is not enough. I've provided an explanation in the original thread.

Here, let me answer your explanation from this thread (lots snipped to 
keep it concise):

First off:

> Actually, there seems to be _no_ problem at all, provided a task to be
> woken up is _not_ running on another CPU at the exact moment of
> wakeup.

Agreed. The runqueue spinlock will protect the case of the target actually 
sleeping. So that's not the case that anybody has worried about.

So to look at the "concurrently running on another CPU case":

> to sum it up, for the following scheme to work:
> 
> set_current_state(TASK_INTERRUPTIBLE);  <--- here we have a smb_mb()
> if (condition)
>         schedule();
> 
> effectively => (1) MODIFY(current->state) ; (2) LOAD(condition)
> 
> and a wake_up path must ensure access (LOAD or MODIFY) to the same
> data happens in the _reverse_ order:

Yes.

> condition = new;
> smb_mb();
> try_to_wake_up();
> 
> => (1) MODIFY(condition); (2) LOAD(current->state)
> 
> try_to_wake_up() does not need to be a full mb per se, the only
> requirement (and only for situation like above) is that there is a
> full mb between possible write ops. that have taken place before
> try_to_wake_up() _and_ a load of p->state inside try_to_wake_up().
> 
> does it make sense #2 ? :-)

.. and this is why I think a smp_wmb() is sufficient. 

The spinlock already guarantees that the load cannot move up past the 
spinlock (that would make a spinlock pointless), and the smp_wmb() 
guarantees that the store cannot move down past the spinlock.

Now, I realize that a smp_wmb() only protects a write against another 
write, but if it's at the top of try_to_wake_up(), the "other write" in 
question is the spinlock itself. So while the smp_wmb() doesn't enforce 
the order between STORE(condition) and LOAD(curent->state) *directly*, it 
does end up doing so through the interaction with the spinlock.

At least I think so. Odd CPU memory ordering can actually break the notion 
of "causality" (see, for example, the fact that we actually need to have 
"smp_read_barrier_depends()" on some architectures), which is one reason 
why it's hard to really think about them. I think I'm better than most on 
memory ordering, but I won't guarantee that there cannot be some 
architecture that could in theory break that

	store -> wmb -> spinlock -> read 

chain some really odd way.

Note that the position of the wmb does matter: if it is *after* the 
spinlock, then it has zero impact on the read. My argument literally 
depends on the wmb serializing with the write of the spinlock itself.

			Linus
