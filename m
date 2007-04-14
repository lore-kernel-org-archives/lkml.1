Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXDNSf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXDNSf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDNSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:35:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34597 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXDNSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:35:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] make kthread_stop() scalable
References: <20070413130236.GA173@tv-sign.ru>
	<m14pnjon4m.fsf@ebiederm.dsl.xmission.com>
	<20070414180247.GA504@tv-sign.ru>
Date: Sat, 14 Apr 2007 12:34:18 -0600
In-Reply-To: <20070414180247.GA504@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 14 Apr 2007 22:02:47 +0400")
Message-ID: <m11wimn6tx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/13, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > It's a shame kthread_stop() (may take a while!) runs with a global semaphore
>> > held. With this patch kthread() allocates all neccesary data (struct
> kthread)
>> > on its own stack, globals kthread_stop_xxx are deleted.
>> 
>> Oleg so fare you patches  have been inspiring.  However..
>> 
>> > HACKS:
>> >
>> > 	- re-use task_struct->set_child_tid to point to "struct kthread"
>> 
>> 	 task_struct->vfork_done is a better cannidate.
>> 
>> > 	- use do_exit() directly to preserve "struct kthread" on stack
>> 
>> Calling do_exit directly like that is not a hack, as it appears the preferred
>> way to exit is to call do_exit, or complete_and_exit.
>> 
>> While this does improve the scalability and remove a global variable.  It
>> also introduces a complex special case in the form of struct kthread.
>
> I can't say I agree. I thought it is good to have a struct which represents
> a kernel thread. Actually, I thought we can have __kthread_create() which
> returns "struct kthread". May be I am wrong, because yes, ->set_child_tid can
> point right to completion, and we can use some TIF flag instead of
> ->should_stop.

> This needs to update a lot of include/asm/ files.

Yes it does.

This is where I was going beyond what you were doing.  I needed a flag to say
that this a kthread that is stopping to test in recalc_sigpending.  To be certain
of terminating interruptible sleeps.  I could not get at your struct kthread
in that case.

If it wasn't for the wait_event_interruptible thing I likely would
have just thrown a union in struct task_struct.

I also got lucky in that vfork_done is designed to point a completion
just where I need it (when a task exits).  The name is now a little
abused but otherwise it does just what I want it to.

>> It also doesn't solve the biggest problem with the current kthread interface
>> in that calling kthread_stop does not cause the code to break out of
>> interruptible sleeps.
>
> Hm? kthread_stop() does wake_up_process(), it wakes up TASK_INTERRUPTIBLE tasks.

Yes. But if they are looping, unless signal_pending is set it is quite possible
they will go back to sleep.

Take for example:

> #define __wait_event_interruptible(wq, condition, ret)		\
> do {									\
> 	DEFINE_WAIT(__wait);						\
> 									\
> 	for (;;) {							\
> 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> 		if (condition)						\
> 			break;						\
> 		if (!signal_pending(current)) {				\
> 			schedule();					\
> 			continue;					\
> 		}							\
> 		ret = -ERESTARTSYS;					\
> 		break;							\
> 	}								\
> 	finish_wait(&wq, &__wait);					\
> } while (0)

We don't break out until either condition is true or signal_pending(current)
is true.

Loops that do that are very common in the kernel.  I counted about 500
calls of signal pending in places that otherwise care nothing about signals.
Several kernel threads call into functions that use loops like
wait_event_interruptible.  So I need a more forceful kthread_stop.  If
I don't want to continue to use signals.

>> > @@ -91,7 +105,7 @@ static void create_kthread(struct kthrea
>> >
>> >  	/* We want our own signal handler (we take no signals by default). */
>> >  	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
>> > -	create->result = pid;
>> > +	create->result = ERR_PTR(pid);
>> 
>> Ouch.    You have a nasty race here.
>> 
>> If kthread runs before kernel_thread returns then setting
>> "create->result = ERR_PTR(pid);" could easily stomp 
>> "create->result = &self".
>
> Yes, thanks... Can't understand how I was soooo stupid!!! thanks...
>
> Damn. We don't need 2 completions! just one.

Yep.  My second patch in this last round implements that.

> 	create_kthread:
>
> 		pid = kernel_thread(...);
> 		if (pid < 0) {
> 			create->result = ERR_PTR(pid);
> 			complete(create->started);
> 		}
> 		// else: kthread() will do complete()
>
> 		return;

Eric

