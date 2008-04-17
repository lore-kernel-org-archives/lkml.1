Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbYDQMal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbYDQMal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYDQMab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:30:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44138 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYDQMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:30:31 -0400
Date: Thu, 17 Apr 2008 15:30:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-ID: <20080417113000.GB103@tv-sign.ru>
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru> <4806C633.3000302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4806C633.3000302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Balbir Singh wrote:
>
> Oleg Nesterov wrote:
> > 
> > I'd suggest to use ->real_parent though. And the third loop could be
> 
> real_parent is for ptraced processes right?

No, please look at __ptrace_link(). ->real_parent is parent, ->parent
is ptracer or it is equal to ->real_parent.

> > 	for_each_process(g) {
> > 		c = g;
> > 		do {
> > 			if (!c->mm)
> > 				continue;
> > 			if (c->mm != mm)
> > 				break;
> > 			goto assign_new_owner;
> > 		} while_each_thread(g, c);
> > 	}
> > 
> 
> I had this loop earlier (inspired from zap_threads()), is this loop more
> efficient than what we have?

All sub-threads have the same ->mm. Once we see that c->mm != mm, we don't
need to waste CPU iterating over the all other threads in the thread group.

> > Still. can't we make mm->mm_users_list ?
> 
> I suspect that will be expensive to maintain. Specially with large number of
> threads. I see a large space overhead and time overhead and additional
> synchronization overhead.

Not sure... but I didn't really think about the implementation.

> Apart from finding the next owner is there any other
> advantage?

it could be used by coredump.

OK, please forget. Even _if_ I am right, we can do this later.


Sadly, I don't have any time to read cgroup.c currently. Balbir, any
chance you have the "for dummies" explanation what mm->owner is?
I mean, I can't understand how it is possible that 2 CLONE_VM tasks
are not equal wrt "ownering". When the old owner dies, we choose a
random thread with the same mm. But we do nothing when the last user
of ->mm dies. What is the point? (please feel free to ignore my q
if it is not easy to explain).


Also, please let me remind,

 > > +     get_task_struct(c);
 > > +     /*
 > > +      * The task_lock protects c->mm from changing.
 > > +      * We always want mm->owner->mm == mm
 > > +      */
 > > +     task_lock(c);
 > > +     /*
 > > +      * Delay read_unlock() till we have the task_lock()
 > > +      * to ensure that c does not slip away underneath us
 > > +      */
 > > +     read_unlock(&tasklist_lock);

The commemt is misleading, tasklist_lock buys nothing and could
be dropped right after get_task_struct(). tasklist can't prevent
the task from exiting, but get_task_struct() pins task_struct,
so it is safe to do task_lock() and re-check ->mm.

And we seem to have problems with use_mm(), no? Btw, what do you
think about killing PF_BORROWED_MM ?

	http://marc.info/?l=linux-kernel&m=120825843403378

Oleg.

