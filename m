Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYDDVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYDDVA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYDDVAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:00:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYDDVAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:00:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
In-Reply-To: Oleg Nesterov's message of  Saturday, 29 March 2008 16:10:19 +0300 <20080329131019.GA472@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<20080329033542.BFF4526FA1D@magilla.localdomain>
	<20080329103929.GB359@tv-sign.ru>
	<20080329131019.GA472@tv-sign.ru>
X-Windows: foiled again.
Message-Id: <20080404210033.F26CC26F8DC@magilla.localdomain>
Date: Fri,  4 Apr 2008 14:00:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	/*
> >  	 * pointers to (original) parent process, youngest child, younger sibling,
> >  	 * older sibling, respectively.  (p->father can be replaced with
> > -	 * p->parent->pid)
> > +	 * p->real_parent->pid)
> 
> There is no ->father in task_struct, the comment is obsolete

I took it to be referring to what replaced the field that no longer exists.
Anyway, I just tweaked the bad reference to the ptrace-specific parent field.

> FYI, arch/mips/kernel/irixsig.c uses add_parent/remove_parent. I don't know
> why irixsig.c reimplements do_wait() and friends...

That badly needs to be cleaned up.  As per recent comments from Linus in
another thread, I think we are best off letting this old cruft get broken
and having its arch people fix it to be sane.

> Unless I missed something again, this is not 100% right.
> 
> Suppose that we are ->real_parent, the child was traced by us, we ignore
> SIGCHLD, and we are doing the threaded reparenting. In that case we should
> release the child if it is dead, like the current code does.

I tried to construct a test case to demonstrate this behavior on the
existing kernel.  I couldn't manage to get it to do this.  Are you this
is "like the current code does"?  I'll send you my test case attempts
off-list and we can try together to get the right test to show this.  If
it turns out that it does not really behave this way now and so my code
is not introducing any regression, then (as usual) I'd rather fix this
separately after the cleanup.

> Even if we don't ignore SIGCHLD, we should notify our thread-group, but
> reparent_thread() skips do_notify_parent() when the new parent is from
> is from the same thread-group.

Why do you think this is wrong?  The notification is always group-wide
(a SIGCHLD to the group, and wakeup of the group-shared wait_chldexit).
So there already was a notification, and a second one seems wrong to me.

> Note also that reparent_thread() has a very old bug. When it sees the
> EXIT_ZOMBIE task, it notifies the new parent, but doesn't check if the task
> becomes detached because the new parent ignores SIGCHLD. Currently this means
> that init must have a handler for SIGCHLD or we leak zombies.

I had noticed that.  After the cleanup, we can look into fixing that.
As usual, I am first going for a set of cleanup patches that changes
exactly nothing semantically.

> Also, I think ptrace_exit() is not right,
> 
> 	if (p->exit_signal != -1 && !thread_group_empty(p))
> 		do_notify_parent(p, p->exit_signal);

Yes, that was a typo.  

> Looks wrong... Above this "p->parent != parent" check we have

This was an inadvertent change from some sloppy last-minute rebasing.
Sorry about that.  Both of these two errors were not there in the
version of the code I read over a lot of times, and I flubbed them in
when rejiggering the patches after some of the earlier feedback.  
In the correct code, the ptrace-stolen check is the very first thing
after calling eligible_child and checking its return value.

When we have resolved the issue about the test case above, I will post
a new series that fixes these flubs.


Thanks,
Roland
