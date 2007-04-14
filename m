Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXDNSua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXDNSua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965536AbXDNSua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:50:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:50174 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965528AbXDNSu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:50:29 -0400
Date: Sat, 14 Apr 2007 22:50:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] make kthread_stop() scalable
Message-ID: <20070414184956.GA615@tv-sign.ru>
References: <20070413130236.GA173@tv-sign.ru> <m14pnjon4m.fsf@ebiederm.dsl.xmission.com> <20070414180247.GA504@tv-sign.ru> <m11wimn6tx.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wimn6tx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Eric W. Biederman wrote:
>
> This is where I was going beyond what you were doing.  I needed a flag to say
> that this a kthread that is stopping to test in recalc_sigpending.  To be certain
> of terminating interruptible sleeps.  I could not get at your struct kthread
> in that case.
> 
> If it wasn't for the wait_event_interruptible thing I likely would
> have just thrown a union in struct task_struct.
> 
> I also got lucky in that vfork_done is designed to point a completion
> just where I need it (when a task exits).  The name is now a little
> abused but otherwise it does just what I want it to.
> 
> >> It also doesn't solve the biggest problem with the current kthread interface
> >> in that calling kthread_stop does not cause the code to break out of
> >> interruptible sleeps.
> >
> > Hm? kthread_stop() does wake_up_process(), it wakes up TASK_INTERRUPTIBLE tasks.
> 
> Yes. But if they are looping, unless signal_pending is set it is quite possible
> they will go back to sleep.
> 
> Take for example:
> 
> > #define __wait_event_interruptible(wq, condition, ret)		\
> > do {									\
> > 	DEFINE_WAIT(__wait);						\
> > 									\
> > 	for (;;) {							\
> > 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> > 		if (condition)						\
> > 			break;						\
> > 		if (!signal_pending(current)) {				\
> > 			schedule();					\
> > 			continue;					\
> > 		}							\
> > 		ret = -ERESTARTSYS;					\
> > 		break;							\
> > 	}								\
> > 	finish_wait(&wq, &__wait);					\
> > } while (0)
> 
> We don't break out until either condition is true or signal_pending(current)
> is true.
> 
> Loops that do that are very common in the kernel.  I counted about 500
> calls of signal pending in places that otherwise care nothing about signals.
> Several kernel threads call into functions that use loops like
> wait_event_interruptible.  So I need a more forceful kthread_stop.  If
> I don't want to continue to use signals.

Yes, I got it reading your next patches. Ok, probably this change is good.
My question was: do we really want to force a kernel thread to exit if it
waits for event in TASK_INTERRUPTIBLE state? probably yes.

> > Yes, thanks... Can't understand how I was soooo stupid!!! thanks...
> >
> > Damn. We don't need 2 completions! just one.
> 
> Yep.  My second patch in this last round implements that.

Yes, I have read it. It is clearly better then mine, and I think correct.

Oleg.

