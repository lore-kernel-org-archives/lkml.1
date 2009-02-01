Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZBAKYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZBAKYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZBAKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:24:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZBAKYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:24:03 -0500
Date: Sun, 1 Feb 2009 11:21:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090201102117.GA5728@redhat.com>
References: <20090130123358.GA26216@redhat.com> <20090130125058.GA26931@redhat.com> <200901312246.07737.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901312246.07737.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Rusty Russell wrote:
>
> On Friday 30 January 2009 23:20:58 Oleg Nesterov wrote:
> > On 01/30, Oleg Nesterov wrote:
> > >
> > > With this patch kthread() allocates all neccesary data (struct kthread)
> > > on its own stack, globals kthread_stop_xxx are deleted. ->vfork_done
> > > is used as a pointer into "struct kthread", this means kthread_stop()
> > > can easily wait for kthread's exit.
> 
> > struct kthread {
> > 	int should_stop;
> > 	struct completion exited;
> > };
> 
> Mildly prefer bool in new code.

OK, and

> > #define to_kthread(tsk)	\
> > 	container_of((tsk)->vfork_done, struct kthread, exited)
> 
> This needs a comment.  Especially since to_xxx(yyy) is usually simply a
> container_of(yyy, xxx, member).  This one is special.

OK, I'll send the cleanup patch.

> > int kthread_stop(struct task_struct *k)
> > {
> > 	struct kthread *kthread;
> > 	int ret;
> >
> > 	trace_sched_kthread_stop(k);
> > 	get_task_struct(k);
> >
> > 	kthread = to_kthread(k);
> > 	barrier(); /* it might have exited */
> > 	if (k->vfork_done != NULL) {
> > 		kthread->should_stop = 1;
> > 		wake_up_process(k);
> > 		wait_for_completion(&kthread->exited);
> > 	}
> > 	ret = k->exit_code;
>
> I don't think this works.  How does do_exit() preserve a stack var, other
> than for a few cycles longer?  Sure, the vfork_done will be OK, but this code
> here will not be.  I think you'd need a get_task_struct(current) before the
> do_exit(ret)

I think this works ;)

This stack frame can't disappear until __put_task_struct()->...->free_thread_info().
So, if you have a reference to task_struct, then it it is safe to dereference
to_kthread(task).

Before this patch, kthread_stop() can only be used when we know that kthread
must not exit by its own. And with this patch we are safe in this case, note
that kthread_stop() does get_task_struct() before it sets ->should_stop = 1.
And this also pins the memory pointed by to_kthread().

> (the case where the kthread fn calls do_exit() is fine: you're
> not allowed to call kthread stop on such threads).

This was not allowed, but now this is fine. Please look at the 4/4 patch.
But, in that case you must pin the task_struct after kthread_create(),
otherwise (with or without this patch) you just can't use this task_struct
in any way.

> In which case using vfork_done is really just a convenience pointer inside
> struct task_struct to stash the struct kthread.  And that's horribly ugly,
> which is why I stuck with a simple global.  Changing to a linked-list of things
> to stop would avoid the deadlock you mentioned where a kthread stops another
> kthread.

Well, this patch overloads ->vfork_done, and I agree this is a bit ugly.
But what you suggest (if I undestand correctly) is more complex, and doesn't
have any advantages, imho.

What do you think?

Oleg.

