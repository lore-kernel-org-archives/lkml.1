Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbZLJGWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbZLJGWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbZLJGWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:22:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38109 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110AbZLJGWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:22:15 -0500
Date: Wed, 9 Dec 2009 22:22:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091210062220.GC6720@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com> <m1aaxu305x.fsf@fess.ebiederm.org> <20091209153709.GA13192@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209153709.GA13192@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 04:37:09PM +0100, Oleg Nesterov wrote:
> On 12/07, Eric W. Biederman wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> > > On 12/05, Eric W. Biederman wrote:
> > >>
> > >> Atomically sending signal to every member of a process group, is the
> > >> big fly in the ointment I am aware of.  Last time I looked I could
> > >> not see how to convert it rcu.
> > >
> > > I am not sure, but iirc we can do this lockless (under rcu_lock).
> > > We need to modify pid_link to use list_entry and attach_pid() should
> > > add the new task to the end. Of course we need more changes, but
> > > (again iirc) this is not too hard.
> >
> > The problem is that even adding to the end of the list, we could run
> > into a deleted entry and not see the new end of the list.
> >
> > Suppose when we start iterating the list we have:
> >
> >   A -> B -> C -> D
> >
> > Then someone deletes some of the entries while we are iterating the list.
> >
> > A ->
> >  B' -> C' -> D'
> >
> > We will continue on traversing through the deleted entries.
> >
> > Then someone adds a new entry to the end of the list.
> >
> > A-> N
> >
> > Since we are at B', C' or D' we will never see the new entry on the
> > end of the list.
> 
> Yes, but who can add the new entry?
> 
> Let's forget about setpgrp/etc for the moment, I think we have "races"
> with or without tasklist. Say, setpgrp() can add the new process to the
> already "killed" pgrp.
> 
> Then, I think the only important case is SIGKILL/SIGSTOP (or other
> signals which can't be blockes/ignored). We must kill/stop the entire
> pgrp, we must not race with fork() and miss a child.
> 
> In this case I _think_ rcu_read_lock() is enough,
> 
> 	rcu_read_lock()
> 
> 	list_for_each_entry_rcu(task, pid->tasks[PIDTYPE_PGID)
> 		group_send_sig_info(sig, task);
> 
> 	rcu_read_unlock();
> 
> except group_send_sig_info() can race with mt-exec, but this is simple
> to fix.
> 
> If we send a signal (not necessary SIGKILL) to a process P, we must see
> all childs which were forked by P, both send_signal() and copy_process()
> take the same ->siglock, we must see the result of list_add_tail_rcu().
> And, after we sent SIGKILL/SIGSTOP, it can't fork the new child.
> 
> If list_for_each_entry() does not see the exited process P, this means
> we see the result of list_del_rcu(). But this also means we must the
> the result of the previous list_add_rcu().
> 
> IOW, fork+exit means list_add_rcu() + wmb() + list_del_rcu(), if we
> don't see the new entry on list, we must see the new one, right?
> 
> (I am ignoring the case when list_for_each_entry_rcu() sees a process
>  P but lock_task_sighand(P) fails, I think this is the same as if we
>  we missed P)
> 
> Now suppose a signal is blocked/ignored or has a handler. In this case
> we can miss a child, but I think this is OK, we can pretend the new
> child was forked after kill_pgrp() completes. Say, this child C was
> forked by some process P. We can miss C only if it was forked after
> we already sent the signal to P.
> 
> However. I do not pretend the reasoning above is "complete", and
> perhaps I missed something else.

My main concern would be "fork storms", where each CPU in a large
system is spawning children in a pgrp that some other CPU is attempting
to kill.  The CPUs spawning children might be able to keep ahead of
the single CPU, so that the pgrp never is completely killed.

Enlisting the aid of the CPUs doing the spawning (e.g., by having them
consult a list of signals being sent) prevents this fork-storm scenario.

							Thanx, Paul

> > Additionally we have the other possibility that if a child is forking
> > we send the signal to the parent after the child forks away but before
> > the child joins whichever list we are walking, and we complete our
> > traversal without seeing the child.
> 
> Not sure I understand... But afaics this case is covered above.
> ->siglock should serialize this, copy_process() does attach_pid()
> under this lock.
> 
> Oleg.
> 
