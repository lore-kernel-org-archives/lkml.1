Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbXDNSDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbXDNSDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXDNSDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:03:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:42002 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbXDNSDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:03:44 -0400
Date: Sat, 14 Apr 2007 22:02:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] make kthread_stop() scalable
Message-ID: <20070414180247.GA504@tv-sign.ru>
References: <20070413130236.GA173@tv-sign.ru> <m14pnjon4m.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14pnjon4m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > It's a shame kthread_stop() (may take a while!) runs with a global semaphore
> > held. With this patch kthread() allocates all neccesary data (struct kthread)
> > on its own stack, globals kthread_stop_xxx are deleted.
> 
> Oleg so fare you patches  have been inspiring.  However..
> 
> > HACKS:
> >
> > 	- re-use task_struct->set_child_tid to point to "struct kthread"
> 
> 	 task_struct->vfork_done is a better cannidate.
> 
> > 	- use do_exit() directly to preserve "struct kthread" on stack
> 
> Calling do_exit directly like that is not a hack, as it appears the preferred
> way to exit is to call do_exit, or complete_and_exit.
> 
> While this does improve the scalability and remove a global variable.  It
> also introduces a complex special case in the form of struct kthread.

I can't say I agree. I thought it is good to have a struct which represents
a kernel thread. Actually, I thought we can have __kthread_create() which
returns "struct kthread". May be I am wrong, because yes, ->set_child_tid can
point right to completion, and we can use some TIF flag instead of ->should_stop.
This needs to update a lot of include/asm/ files.

> It also doesn't solve the biggest problem with the current kthread interface
> in that calling kthread_stop does not cause the code to break out of
> interruptible sleeps.

Hm? kthread_stop() does wake_up_process(), it wakes up TASK_INTERRUPTIBLE tasks.

> > @@ -91,7 +105,7 @@ static void create_kthread(struct kthrea
> >
> >  	/* We want our own signal handler (we take no signals by default). */
> >  	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
> > -	create->result = pid;
> > +	create->result = ERR_PTR(pid);
> 
> Ouch.    You have a nasty race here.
> 
> If kthread runs before kernel_thread returns then setting
> "create->result = ERR_PTR(pid);" could easily stomp 
> "create->result = &self".

Yes, thanks... Can't understand how I was soooo stupid!!! thanks...

Damn. We don't need 2 completions! just one.

	create_kthread:

		pid = kernel_thread(...);
		if (pid < 0) {
			create->result = ERR_PTR(pid);
			complete(create->started);
		}
		// else: kthread() will do complete()

		return;

Oleg.

