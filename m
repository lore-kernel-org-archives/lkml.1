Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbYBWR4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbYBWR4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760062AbYBWRzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:55:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758531AbYBWRzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:55:50 -0500
Date: Sat, 23 Feb 2008 09:54:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
 added to -mm tree
In-Reply-To: <20080223162705.GA7686@tv-sign.ru>
Message-ID: <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org> <20080223162705.GA7686@tv-sign.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Oleg Nesterov wrote:
> 
> In short: wake_up_process() doesn't imply mb(), this means that _in theory_
> the commonly used code like
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (CONDITION)
> 		return;
> 	schedule();
> 
> is racy wrt
> 
> 	CONDITION = 1;
> 	wake_up_process(p);
> 
> I'll be happy to be wrong though, please correct me.

Well, you should be wrong on x86, because the spinlock at the head of 
wake_up_process() (well, "try_to_wake_up()" to be exact) will be a full 
memory barrier.

But yeah, in general spinlocks can have weaker semantics, and let 
preceding writes percolate into the critical section and thus past the 
point that actually sets task->state.

And I do agree that we should *not* add a memory barrier in the caller 
(that's just going to be really confusing for everybody, and make these 
things much harder than they should be), and we should make sure that the 
above sequence is always race-free.

I also think that a full memory barrier is overkill. We should be ok with 
just adding a write barrier to the top of wake_up_process(), no? That way, 
we know that the CONDITION will be seen on the other CPU before it sees 
task->state change to TASK_RUNNING, so with the memory barrier int he 
"set_current_state()", we know that the other side will see the new 
condition _or_ it will see TASK_RUNNING when it hits schedule.

No?

(smp_wmb() also has the advantage of being a no-op on x86, where it's not 
needed).

But memory ordering is hard. Maybe I'm not thinking right about this.

			Linus
