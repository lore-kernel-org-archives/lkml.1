Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZDBOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZDBOrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZDBOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:47:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbZDBOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:47:25 -0400
Date: Thu, 2 Apr 2009 16:43:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: what is_single_threaded() does?
Message-ID: <20090402144313.GA2010@redhat.com>
References: <20090331205703.GA21030@redhat.com> <2360.1238670426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2360.1238670426@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But this is not what the code does? The "t->mm == mm" check below means
> > it also returns false if ->mm is shared with another CLONE_VM process ?
>
> It's a matter of defining what is meant by single-threaded, I suppose.  For
> the purposes of security checks, that means not being part of the same group
> of threads and not sharing VM space.

Then I think it is better to change the comment,

> Linux has a very fuzzy view of threads, whereby different tasks can share
> different sets of things.

The comment says:

	Determine if a thread group is single-threaded

"thread group" is what we have in ->thread_group.

> probably mostly unused.
>
> > 		if (atomic_read(&p->signal->count) != 1)
> > 			goto no;
> >
> > Is this correct? Let's suppose the main thread dies, and the thread group
> > has only one live thread. In that case signal->count == 2.
>
> Doesn't exit() kill the subsidiary threads in such a case?  I don't recall.

No. Well, sys_exit() (and thus pthread_exit()) doesn't.

> It appears that the zombie would retain a pointer to p->signal so that
> wait_task_zombie() can get stuff out of it -

Yes,

> but can wait_task_zombie()
> actually access a thread group that still has active threads?

Not sure I understand... But, if a thread group that still has active threads,
wait_task_zombie() will not be called.

> I don't think this is a real problem, at least for the two security users of
> it.

I do not claim this is security problem. But still it doesn't look right
to me,

> It is still effectively multithreaded,

Why? The main thread is really dead, it has no ->mm, it can do nothing.
We only have a task_struct which is not released untill all threads exit.

> > Why do_each_thread() ? for_each_process() is enough, all sub-threads use
> > the same ->mm.
>
> Firstly, that's what the original code that I extract out to this function
> did;

OK,

> secondly, it doesn't make much difference: do_each_thread() does the
> filtering for us that we'd have to do ourselves if we used for_each_process();
> and thirdly,

What do you mean? do_each_thread() iterates over all threads in system,
the number of processes can be much lower. And we hold tasklist, not
good.

> it is neither required nor enforced that all sub-threads use the
> same ->mm.

It is required and enforced. CLONE_THREAD without CLONE_VM results in -EINVAL.

> Actually, a better way of doing things may be to use a list of threads rooted
> on signal_struct.

Can't understand. We already have this list of threads: ->thread_group.

And confused. You said "and not sharing VM space" above, how this list
can help?

> > What about use_mm() ? Looks like this needs PF_KTHREAD check.
>
> I'm not sure what you mean.  Are you suggesting this should use use_mm()?  Or
> are you suggesting that use_mm() is wrong?

The aio kernel thread can borrow ->mm from user-space process. In that
case is_single_threaded() will wrongly retun false. is_single_threaded()
should not check ->mm if PF_KTHREAD.

> > Perhaps it should be current_is_single_thread(void) ...
>
> Perhaps.

Yes, because it doesn't makes to much sense to call this helper
unless p == current.

Oleg.

