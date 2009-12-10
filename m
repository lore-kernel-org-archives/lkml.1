Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZLJDgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZLJDgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZLJDgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:36:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34722 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452AbZLJDgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:36:32 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20091130174638.GA9782@elte.hu>
	<alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	<m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com>
	<m1aaxu305x.fsf@fess.ebiederm.org> <20091209153709.GA13192@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 09 Dec 2009 19:36:26 -0800
In-Reply-To: <20091209153709.GA13192@redhat.com> (Oleg Nesterov's message of "Wed\, 9 Dec 2009 16\:37\:09 +0100")
Message-ID: <m1pr6npkjp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [rfc] "fair" rw spinlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 12/07, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 12/05, Eric W. Biederman wrote:
>> >>
>> >> Atomically sending signal to every member of a process group, is the
>> >> big fly in the ointment I am aware of.  Last time I looked I could
>> >> not see how to convert it rcu.
>> >
>> > I am not sure, but iirc we can do this lockless (under rcu_lock).
>> > We need to modify pid_link to use list_entry and attach_pid() should
>> > add the new task to the end. Of course we need more changes, but
>> > (again iirc) this is not too hard.
>>
>> The problem is that even adding to the end of the list, we could run
>> into a deleted entry and not see the new end of the list.
>>
>> Suppose when we start iterating the list we have:
>>
>>   A -> B -> C -> D
>>
>> Then someone deletes some of the entries while we are iterating the list.
>>
>> A ->
>>  B' -> C' -> D'
>>
>> We will continue on traversing through the deleted entries.
>>
>> Then someone adds a new entry to the end of the list.
>>
>> A-> N
>>
>> Since we are at B', C' or D' we will never see the new entry on the
>> end of the list.
>
> Yes, but who can add the new entry?
>
> Let's forget about setpgrp/etc for the moment, I think we have "races"
> with or without tasklist. Say, setpgrp() can add the new process to the
> already "killed" pgrp.

Agreed. A setpgrp call that we miss can be considered to have happened
after the signal was sent to the process group.

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

After we change the code to always add new entries to the end of
the rcu list you are correct.

The danger I saw is having a new process ( that we must handle ) show
up while we have gotten into a rcu cul-de-sac of the process list,
where we do not see new processes added to the end.

Once a process has gotten a signal we don't care, any children it spawns
happen after the signal was sent.

So we only care about children for processes that we have not delivered
the signal to.  If we add children to the end of the list they will be
visible if you traverse through the parent.  Since we have not traversed
through the parent and delivered the signal (by definition) then we don't
care.

This works for all signals, and especially for SIGKILL and SIGSTOP.

I am tempted to apply the test that if user space can prove the ordering
is not what is expected than there is a problem.  However signals have
not always arrived strongly orders with other user space events, and
the tasklist lock today does not appear to preclude a task that has
received a signal from talking to a task that has not yet received a
signal via pipes, etc.  

So as long as we can guarantee that if you traverse a parent you will
also traverse all of the children forked before you traversed the
parent, then we should be fine.


> If we send a signal (not necessary SIGKILL) to a process P, we must see
> all childs which were forked by P, both send_signal() and copy_process()
> take the same ->siglock, we must see the result of list_add_tail_rcu().
> And, after we sent SIGKILL/SIGSTOP, it can't fork the new child.

Sounds right.

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

I don't see how we can miss a child that matters.

> However. I do not pretend the reasoning above is "complete", and
> perhaps I missed something else.

I can not find fault with your idea.

Eric
