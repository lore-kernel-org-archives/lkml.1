Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbXDNTFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbXDNTFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXDNTFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:05:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbXDNTFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:05:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
	<20070414183538.GB504@tv-sign.ru>
Date: Sat, 14 Apr 2007 13:04:26 -0600
In-Reply-To: <20070414183538.GB504@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 14 Apr 2007 22:35:38 +0400")
Message-ID: <m1slb2lqv9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/13, Eric W. Biederman wrote:
>>
>> +static inline int __kthread_should_stop(struct task_struct *tsk)
>> +{
>> +	return test_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
>> +}
>
> Am I blind? Where does copy_process/dup_task_struct clears unwanted
> flags in thread_info->flags ?

Good question.  It is only a real problem if someone forks a kernel
thread after we ask it to die but, it does appear to be an issue.
With this usage and the same usage by the process freezer.

We do have these lines in copy_process...

	clear_tsk_thread_flag(p, TIF_SIGPENDING);
	init_sigpending(&p->pending);

I don't know what we want to do about TIF_KTHREAD_STOP and TIF_FREEZE.

Right now we will go allow our merry way until we hit:

	recalc_sigpending();
	if (signal_pending(current)) {
		spin_unlock(&current->sighand->siglock);
		write_unlock_irq(&tasklist_lock);
		retval = -ERESTARTNOINTR;
		goto bad_fork_cleanup_namespaces;
	}

And copy_process will fail.  Since that is an expected failure point
that actually seems like reasonable behavior in this case if you
are being frozen or are being told to die you can't fork.

It does ensure that these additional kernel flags won't make it
onto new instances of struct task_struct.  Which is the important
thing from a correctness standpoint.


>> +int kthread_stop(struct task_struct *tsk)
>>  {
>>  	int ret;
>>  
>> -	mutex_lock(&kthread_stop_lock);
>> -
>> -	/* It could exit after stop_info.k set, but before wake_up_process. */
>> -	get_task_struct(k);
>> +	/* Ensure the task struct persists until I read the exit code. */
>> +	get_task_struct(tsk);
>>  
>> -	/* Must init completion *before* thread sees kthread_stop_info.k */
>> -	init_completion(&kthread_stop_info.done);
>> -	smp_wmb();
>> +	set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
>> +	spin_lock_irq(&tsk->sighand->siglock);
>> +	signal_wake_up(tsk, 1);
>> +	spin_unlock_irq(&tsk->sighand->siglock);
>
> Off-topic again, the comment above signal_wake_up() is very confusing...
> I think the only reason for ->siglock is to prevent the case when
> TIF_SIGPENDING may be cleared by recalc_sigpending(). Or something else?

I'm really not certain.  I just looked and saw that every user of
signal_pending had the siglock, so I didn't delve any deeper.

> This changes the current API, kthread_stop() doesn't wake up UNINTERRUPTIBLE
> tasks any longer. I'd say this is good, but may break things ... For example,
> kthred_stop(kthread_create(...)) can't work now.

Ugh. Good point.  I haven't picked up the UNINTERRUPTIBLE change yet.
I hadn't realized this exceeded the wait for the completion.  Which
it obviously does, ugh.  

I don't know what to do about the theoretical freezer race, for now I
am inclined to ignore it.  At least until someone audits all of the kernel
threads to be certain an API change is ok.

There is also Andrews general objection that we should use UNINTERRUPTIBLE
sleeps very sparingly because it contributes to load average and such.

>> -	/* Now set kthread_should_stop() to true, and wake it up. */
>> -	kthread_stop_info.k = k;
>> -	wake_up_process(k);
>> -	put_task_struct(k);
>> +	wait_for_completion(tsk->vfork_done);
>> +	ret = tsk->exit_code;
>
> This is really good. Now the kernel thread can exit() at any point without
> fear to break kthread_stop().

Yes.

>> @@ -218,7 +219,7 @@ static inline int has_pending_signals(sigset_t *signal,
> sigset_t *blocked)
>>  fastcall void recalc_sigpending_tsk(struct task_struct *t)
>>  {
>>  	if (t->signal->group_stop_count > 0 ||
>> -	    (freezing(t)) ||
>> +	    (freezing(t)) || __kthread_should_stop(t) ||
>>  	    PENDING(&t->pending, &t->blocked) ||
>>  	    PENDING(&t->signal->shared_pending, &t->blocked))
>>  		set_tsk_thread_flag(t, TIF_SIGPENDING);
>
> Aha, now I understand your point about interruptible sleeps (the previous
> message). What is the reason for this change?

This bit is so that TIF_SIGPENDING does not get cleared on us.

Eric

