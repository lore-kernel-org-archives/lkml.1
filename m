Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYA3CXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYA3CXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYA3CXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:23:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51211 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYA3CXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:23:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
References: <20080129164019.GA2060@tv-sign.ru>
	<20080129150836.7fd994a2.akpm@linux-foundation.org>
Date: Tue, 29 Jan 2008 19:16:50 -0700
In-Reply-To: <20080129150836.7fd994a2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 29 Jan 2008 15:08:36 -0800")
Message-ID: <m1r6g0gir1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 29 Jan 2008 19:40:19 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
>
>> With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply
> rcu_read_lock(),
>> but find_pid_ns()->hlist_for_each_entry_rcu() should be safe under tasklist.
>> 
>> Usually it is, detach_pid() is always called under write_lock(tasklist_lock),
>> but copy_process() calls free_pid() lockless.
>> 
>> "#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
>> too ugly and should be removed.
>> 
>> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>> 
>> --- MM/kernel/fork.c~PR_RCU	2008-01-27 17:09:47.000000000 +0300
>> +++ MM/kernel/fork.c	2008-01-29 19:23:44.000000000 +0300
>> @@ -1335,8 +1335,19 @@ static struct task_struct *copy_process(
>>  	return p;
>>  
>>  bad_fork_free_pid:
>> -	if (pid != &init_struct_pid)
>> +	if (pid != &init_struct_pid) {
>> +#ifdef CONFIG_PREEMPT_RCU
>> +		/*
>> +		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
>> +		 * make sure find_pid() is safe under read_lock(tasklist).
>> +		 */
>> +		write_lock_irq(&tasklist_lock);
>> +#endif
>>  		free_pid(pid);
>> +#ifdef CONFIG_PREEMPT_RCU
>> +		write_unlock_irq(&tasklist_lock);
>> +#endif
>> +	}
>>  bad_fork_cleanup_namespaces:
>>  	exit_task_namespaces(p);
>>  bad_fork_cleanup_keys:
>
> My attempt to understand this change timed out.
>
> kernel/pid.c is full of global but undocumented functions.  What are the
> locking requirements for free_pid()?  free_pid_ns()?  If it's just
> caller-must-hold-rcu_read_lock() then why not use rcu_read_lock() here?
>
> If the locking is "caller must hold write_lock_irq(tasklist_lock) then the
> sole relevant comment in there (in free_pid()) is wrong.
>
> Guys, more maintainable code please?

Well I took a quick look.

Yeah this looks complex.
Mutation of the hash table is protected by pidmap_lock.
But attachments of tasks to hash entries is protected task_lock.

And it looks like it has been that way since commit 92476d7fc0326a409ab1d3864a04093a6be9aca7

I thought free_pid did not have any requirements that a lock be held when
it was called, taking all of the needed locks.

Now how read_lock doesn't imply rcu_read_lock is another question.

Anyway I have to run.  I will see about looking at this in a bit.

Eric
