Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYA3JZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYA3JZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYA3JZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:25:29 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54401 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYA3JZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:25:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
References: <20080129164019.GA2060@tv-sign.ru>
	<m1ir1cgfmm.fsf@ebiederm.dsl.xmission.com>
	<20080130050048.GH12073@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2008 02:20:02 -0700
In-Reply-To: <20080130050048.GH12073@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Tue, 29 Jan 2008 21:00:48 -0800")
Message-ID: <m163xbhdq5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Tue, Jan 29, 2008 at 08:24:17PM -0700, Eric W. Biederman wrote:
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply
> rcu_read_lock(),
>> > but find_pid_ns()->hlist_for_each_entry_rcu() should be safe under tasklist.
>> >
>> > Usually it is, detach_pid() is always called under
> write_lock(tasklist_lock),
>> > but copy_process() calls free_pid() lockless.
>> >
>> > "#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
>> > too ugly and should be removed.
>> >
>> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>> >
>> > --- MM/kernel/fork.c~PR_RCU	2008-01-27 17:09:47.000000000 +0300
>> > +++ MM/kernel/fork.c	2008-01-29 19:23:44.000000000 +0300
>> > @@ -1335,8 +1335,19 @@ static struct task_struct *copy_process(
>> >  	return p;
>> >  
>> >  bad_fork_free_pid:
>> > -	if (pid != &init_struct_pid)
>> > +	if (pid != &init_struct_pid) {
>> > +#ifdef CONFIG_PREEMPT_RCU
>> > +		/*
>> > +		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
>> > +		 * make sure find_pid() is safe under read_lock(tasklist).
>> > +		 */
>> > +		write_lock_irq(&tasklist_lock);
>> > +#endif
>> >  		free_pid(pid);
>> > +#ifdef CONFIG_PREEMPT_RCU
>> > +		write_unlock_irq(&tasklist_lock);
>> > +#endif
>> > +	}
>> >  bad_fork_cleanup_namespaces:
>> >  	exit_task_namespaces(p);
>> >  bad_fork_cleanup_keys:
>> 
>> Ok. I believe I see what problem you are trying to fix.  That
>> a pid returned from find_pid might disappear if we are not rcu
>> protected.
>> 
>> This patch in the simplest form is wrong because it is confusing.
>> 
>> We currently appear to have two options.
>> 1) Force all pid hash table access and pid accesses that
>>    do not get a count to be covered under rcu_read_lock.
>> 2) To modify the locking requirements for free_pid to require
>>    the tasklist_lock.
>> 
>>    However this second approach is horribly brittle, as it
>>    will break if we ever have intermediate entries in the
>>    hash table protected by pidmap_lock.
>> 
>> Using the tasklist_lock to still guarantee we see the list, the entire
>> list, and exactly the list for proper implementation of kill to
>> process groups and sessions still seems sane.
>> 
>> So let's just remove the guarantee of find_pid being usable with
>> just the tasklist_lock held.
>
> Makes sense to me -- it is totally permissible to hold rcu_read_lock()
> across update code.  ;-)

Let me rephrase so it is clear.

When dealing with pids there is exactly one case where we need
to take read_lock(&tasklist_lock);

Posix (and sanely handling corner cases) requires that when we send a
signal to a process group or a session we have a snapshot in time view
of the entire group.  In particular this allows us to send SIGKILL to
every member of the group and to have the entire group die.

For all other cases (like /proc) we can safely and simply use the
rcu_read_lock and it improves scalability.

So for those cases where we are sending a signal to multiple processes
it looks like we need to go in and change the code to say:

read_lock(&tasklist_lock);
rcu_read_lock();
...
rcu_read_unlock();
read_unlock(&tasklist_lock);

Which is all sane, and should be correct and maintainable in the
future and is relatively easy to understand.

Of course if we start with find_get_pid and then later do put_pid we
are also fine.  The current code is a little extra confused right now
because we have not completed the pid namespace conversion.  Although
we are getting quite close.

Eric


