Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZLIPnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZLIPnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZLIPna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:43:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZLIPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:43:30 -0500
Date: Wed, 9 Dec 2009 16:37:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091209153709.GA13192@redhat.com>
References: <20091130174638.GA9782@elte.hu> <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com> <m1aaxu305x.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aaxu305x.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 12/05, Eric W. Biederman wrote:
> >>
> >> Atomically sending signal to every member of a process group, is the
> >> big fly in the ointment I am aware of.  Last time I looked I could
> >> not see how to convert it rcu.
> >
> > I am not sure, but iirc we can do this lockless (under rcu_lock).
> > We need to modify pid_link to use list_entry and attach_pid() should
> > add the new task to the end. Of course we need more changes, but
> > (again iirc) this is not too hard.
>
> The problem is that even adding to the end of the list, we could run
> into a deleted entry and not see the new end of the list.
>
> Suppose when we start iterating the list we have:
>
>   A -> B -> C -> D
>
> Then someone deletes some of the entries while we are iterating the list.
>
> A ->
>  B' -> C' -> D'
>
> We will continue on traversing through the deleted entries.
>
> Then someone adds a new entry to the end of the list.
>
> A-> N
>
> Since we are at B', C' or D' we will never see the new entry on the
> end of the list.

Yes, but who can add the new entry?

Let's forget about setpgrp/etc for the moment, I think we have "races"
with or without tasklist. Say, setpgrp() can add the new process to the
already "killed" pgrp.

Then, I think the only important case is SIGKILL/SIGSTOP (or other
signals which can't be blockes/ignored). We must kill/stop the entire
pgrp, we must not race with fork() and miss a child.

In this case I _think_ rcu_read_lock() is enough,

	rcu_read_lock()

	list_for_each_entry_rcu(task, pid->tasks[PIDTYPE_PGID)
		group_send_sig_info(sig, task);

	rcu_read_unlock();

except group_send_sig_info() can race with mt-exec, but this is simple
to fix.

If we send a signal (not necessary SIGKILL) to a process P, we must see
all childs which were forked by P, both send_signal() and copy_process()
take the same ->siglock, we must see the result of list_add_tail_rcu().
And, after we sent SIGKILL/SIGSTOP, it can't fork the new child.

If list_for_each_entry() does not see the exited process P, this means
we see the result of list_del_rcu(). But this also means we must the
the result of the previous list_add_rcu().

IOW, fork+exit means list_add_rcu() + wmb() + list_del_rcu(), if we
don't see the new entry on list, we must see the new one, right?

(I am ignoring the case when list_for_each_entry_rcu() sees a process
 P but lock_task_sighand(P) fails, I think this is the same as if we
 we missed P)

Now suppose a signal is blocked/ignored or has a handler. In this case
we can miss a child, but I think this is OK, we can pretend the new
child was forked after kill_pgrp() completes. Say, this child C was
forked by some process P. We can miss C only if it was forked after
we already sent the signal to P.

However. I do not pretend the reasoning above is "complete", and
perhaps I missed something else.

> Additionally we have the other possibility that if a child is forking
> we send the signal to the parent after the child forks away but before
> the child joins whichever list we are walking, and we complete our
> traversal without seeing the child.

Not sure I understand... But afaics this case is covered above.
->siglock should serialize this, copy_process() does attach_pid()
under this lock.

Oleg.

