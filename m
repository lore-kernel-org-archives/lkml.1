Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYA3SbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYA3SbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYA3SbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:31:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41736 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYA3SbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:31:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
References: <20080129164019.GA2060@tv-sign.ru>
	<m1ir1cgfmm.fsf@ebiederm.dsl.xmission.com>
	<20080130093018.GA88@tv-sign.ru>
Date: Wed, 30 Jan 2008 11:28:12 -0700
In-Reply-To: <20080130093018.GA88@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 30 Jan 2008 12:30:18 +0300")
Message-ID: <m11w7zgocj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 01/29, Eric W. Biederman wrote:
>>
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
>
> Not only.
>
> Any find_pid() is unsafe under tasklist, even the find_pid(1).
> Because free_pid() mangles the pid_hash[hash] while find_pid()
> scans the same list.

But we do it the rcu way.

So it isn't the mangling that is a problem.  Just walking off into
freed memory.  That is fundamentally the principle that the rcu
accessors work on.

Any find_pid is in trouble because any intermediate pid in the hash
chain may be freed as we walk the list, and if we don't wait the rcu
interval the pointers we need may go bad.

>> This patch in the simplest form is wrong because it is confusing.
>>
>> We currently appear to have two options.
>> 1) Force all pid hash table access and pid accesses that
>>    do not get a count to be covered under rcu_read_lock.
>
> I agree, we can (and should) convert most of these read_lock(tasklist)'s
> to rcu_read_lock(). But we have a lot of them.

We have to touch and recheck all of that code anyway to ensure
the pid namespace stuff is correct and working well.

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
>
> And this means that attach_pid() and detach_pid() need write_lock(tasklist)
> anyway.
>
> So copy_process()->free_pid() is the only case when we modify the pid_hash[]
> list without tasklist.

Nope.  alloc_pid does also.  The pid_hash table is fundamentally not
protected by task_lock, but by pidmap_lock.

task_list only protects detach (by fluke) and going from struct pid 
to a task.  It doesn't prevent additions to the hash chains at all.

>> So let's just remove the guarantee of find_pid being usable with
>> just the tasklist_lock held.
>>
>> Eric
>>
>> diff --git a/include/linux/pid.h b/include/linux/pid.h
>> index e29a900..0ffb8cc 100644
>> --- a/include/linux/pid.h
>> +++ b/include/linux/pid.h
>> @@ -100,8 +100,7 @@ struct pid_namespace;
>>  extern struct pid_namespace init_pid_ns;
>>
>>  /*
>> - * look up a PID in the hash table. Must be called with the tasklist_lock
>> - * or rcu_read_lock() held.
>> + * look up a PID in the hash table. Must be called with the rcu_read_lock()
> held.
>
> Imho, we should first fix all users of read_lock(tasklist)+find_..._pid().
>
> So I still think this patch makes sense as a trivial fix for now, until
> we add the necessary rcu_read_lock()s. However this race is very unlikely,
> perhaps we can live with it.

The patch is horrible because it works for all of the wrong reasons,
and obscures what is really going on.  That can't be good.

Eric

