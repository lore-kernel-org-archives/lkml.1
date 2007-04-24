Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXDXVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXDXVVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXDXVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:21:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58120 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbXDXVVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:21:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
	<20070424030924.be44ebfa.akpm@linux-foundation.org>
	<m1r6qat681.fsf@ebiederm.dsl.xmission.com>
	<20070424150558.GA233@tv-sign.ru> <20070424155332.GA321@tv-sign.ru>
	<m1irblu1wc.fsf@ebiederm.dsl.xmission.com>
	<20070424202727.GB5042@tv-sign.ru>
Date: Tue, 24 Apr 2007 15:19:50 -0600
In-Reply-To: <20070424202727.GB5042@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 25 Apr 2007 00:27:27 +0400")
Message-ID: <m1ejm9tqq1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/24, Eric W. Biederman wrote:
>> 
>> I don't know if this is the problem but it certainly needs to be fixed.
>
> I guess you will re-submit these patches soon. May I suggest you to put
> this
>
>> +	spin_lock_irq(&tsk->sighand->siglock);
>> +	signal_wake_up(tsk, 1);
>> +	spin_unlock_irq(&tsk->sighand->siglock);
>
> and this
>
>>  fastcall void recalc_sigpending_tsk(struct task_struct *t)
>>  {
>>  	if (t->signal->group_stop_count > 0 ||
>> -	    (freezing(t)) ||
>> +	    (freezing(t)) || __kthread_should_stop(t) ||
>
> into the separate patch?
>
> Perhaps I am too paranoid, and most probably this change is good, but
> still I'm afraid this very subtle change may break things. In that case
> it would be easy to revert that only part (for example for the testing
> purposes).

It makes sense.  I doubt we are going to run into issues when
we are killing a thread but we certainly could.

Making it easy to test for that scenario would certainly be
a good idea.

> Consider,
>
> 	current->flags |= PF_NOFREEZE;
>
> 	while (!kthread_should_stop()) {
>
> 		begin_something();
>
> 		// I am a kernel thread, all signals are ignored.
> 		// I don't want to contribute to loadavg, so I am
> 		// waiting for the absoulutely critical event in
> 		// TASK__INTERRUPTIBLE state.
>
> 		if (wait_event_interruptible(condition))
> 			panic("Impossible!");
>
> 		commit_something();
> 	}

Of course if it's impossible it is most likely there won't be a check
there so something more subtle will happen.

Eric
