Return-Path: <linux-kernel-owner+w=401wt.eu-S935694AbZDBLIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935694AbZDBLIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZDBLIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:08:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZDBLIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:08:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090331205703.GA21030@redhat.com>
References: <20090331205703.GA21030@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org
Subject: Re: what is_single_threaded() does?
Date: Thu, 02 Apr 2009 12:07:06 +0100
Message-ID: <2360.1238670426@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg Nesterov <oleg@redhat.com> wrote:

> But this is not what the code does? The "t->mm == mm" check below means
> it also returns false if ->mm is shared with another CLONE_VM process ?

It's a matter of defining what is meant by single-threaded, I suppose.  For
the purposes of security checks, that means not being part of the same group
of threads and not sharing VM space.

Linux has a very fuzzy view of threads, whereby different tasks can share
different sets of things.  In my opinion it's excessive and unnecessary, and
probably mostly unused.

> 		if (atomic_read(&p->signal->count) != 1)
> 			goto no;
>
> Is this correct? Let's suppose the main thread dies, and the thread group
> has only one live thread. In that case signal->count == 2.

Doesn't exit() kill the subsidiary threads in such a case?  I don't recall.

It appears that the zombie would retain a pointer to p->signal so that
wait_task_zombie() can get stuff out of it - but can wait_task_zombie()
actually access a thread group that still has active threads?

I don't think this is a real problem, at least for the two security users of
it.  It is still effectively multithreaded, even though one of the threads is
a zombie, and indeed it would appear the process is busy imploding.

> Why do_each_thread() ? for_each_process() is enough, all sub-threads use
> the same ->mm.

Firstly, that's what the original code that I extract out to this function
did; secondly, it doesn't make much difference: do_each_thread() does the
filtering for us that we'd have to do ourselves if we used for_each_process();
and thirdly, it is neither required nor enforced that all sub-threads use the
same ->mm.

Actually, a better way of doing things may be to use a list of threads rooted
on signal_struct.

> What about use_mm() ? Looks like this needs PF_KTHREAD check.

I'm not sure what you mean.  Are you suggesting this should use use_mm()?  Or
are you suggesting that use_mm() is wrong?

> Perhaps it should be current_is_single_thread(void) ...

Perhaps.
