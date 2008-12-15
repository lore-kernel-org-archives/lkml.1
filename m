Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYLOKtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYLOKtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYLOKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:48:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYLOKsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:48:55 -0500
Date: Mon, 15 Dec 2008 11:47:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: broken do_each_pid_{thread,task}
Message-ID: <20081215104716.GB11106@redhat.com>
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wse29roy.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Eric W. Biederman wrote:
>
> Jiri Slaby <jirislaby@gmail.com> writes:
> >
> > I'm getting
> > `if (type == PIDTYPE_PID)' is unreachable
> > warning from kernel/exit.c. The preprocessed code looks like:
> > do {
> >          struct hlist_node *pos___;
> >          if (pgrp != ((void *)0))
> >                  for (LIST ITERATION) {
> >                          {
> >                           if (!((p->state & 4) != 0))
> >                            continue;
> >                           retval = 1;
> >                           break;
> >                          }
> >                          if (PIDTYPE_PGID == PIDTYPE_PID)
> >                                  break;
> >                  }
> > } while (0);
> > and it's obviously wrong.
>
> Actually the test:
> >                          if (PIDTYPE_PGID == PIDTYPE_PID)
> >                                  break;
> Is technically ok.  The compiler should optimize it out instead of warning.
> Although seeing the unexpected corner case it gets us into I think it would
> be good to reconsider this test.

Agreed. This check uglifies the code to fix the theoretical problem.

But, actually do_each_pid_task() is a bit ugly even without this check.
Lets forget about this check for a moment.

Firstly, all hlist_for_each_entry() helpers should be "fixed", we don't
need the second argument. For example, hlist_for_each_entry_rcu() could
be

	#define hlist_for_each_entry_rcu(pos, head, member)			\
		for (pos = (void*)(head)->first; rcu_dereference(pos) && ({	\
			prefetch(((struct hlist_node*)pos)->next);		\
			pos = hlist_entry((void*)pos, typeof(*pos), member); 1;	\
		     }); pos = (void*)(pos)->member.next)

So we can define

	#define for_each_pid_task(pid, type, task)
		for (task = pid ? (void*)((pid)->tasks + type)->first : NULL;			\
			rcu_dereference(task) && ({						\
			prefetch(((struct hlist_node*)task)->next);				\
			task = hlist_entry((void*)task, typeof(*task), pids[type].node); 1;	\
		     }); task = (void*)(task)->pids[type].node.next)

Which can be used just

	for_each_pid_task(pid, type, task)
		do_something(task);

Not that I think it is worth to do, though ;)

We can even restore the ugly special case for PIDTYPE_PID:

	#define for_each_pid_task(pid, type, task)
		for (task = pid ? (void*)((pid)->tasks + type)->first : NULL;			\
			rcu_dereference(task) && ({						\
			prefetch(((struct hlist_node*)task)->next);				\
			task = hlist_entry((void*)task, typeof(*task), pids[type].node); 1; })	\
		     task = (type != PIDTYPE_PID) ? (void*)(task)->pids[type].node.next : NULL)


> > For do_each_pid_thread(), even this code snippet from fs/ioprio.c is broken
> > due to double do {} while expansion:
> > do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> >   ret = set_task_ioprio(p, ioprio);
> >   if (ret)
> >     break;
> > } while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> >
> > Any idea how to get rid of this issue?
>
> The double loop there is certainly an issue.  I'm not quite convinced that
> the error handling is correct even with the break statement.  But the
> break statement was written when the code was just a single loop, so the
> behavior is definitely not what we intended.

Yes,

> With respect to error handling and IO priorities can we fix the error handling
> by doing what we do when we send a signal to a process group?  That is note
> that there was an error, finish processing all of the other processes and then
> return the error?

Personally, I think you are right. But then we should change IOPRIO_WHO_USER
accordingly, imho.

Oleg.

