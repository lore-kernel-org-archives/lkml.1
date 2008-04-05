Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYDEPBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYDEPBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 11:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYDEPBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 11:01:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42482 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYDEPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:01:31 -0400
Date: Sat, 5 Apr 2008 18:06:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
Message-ID: <20080405140656.GA109@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <20080329033542.BFF4526FA1D@magilla.localdomain> <20080329103929.GB359@tv-sign.ru> <20080329131019.GA472@tv-sign.ru> <20080404210033.F26CC26F8DC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404210033.F26CC26F8DC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Roland McGrath wrote:
>
> > Unless I missed something again, this is not 100% right.
> > 
> > Suppose that we are ->real_parent, the child was traced by us, we ignore
> > SIGCHLD, and we are doing the threaded reparenting. In that case we should
> > release the child if it is dead, like the current code does.
> 
> I tried to construct a test case to demonstrate this behavior on the
> existing kernel.  I couldn't manage to get it to do this.  Are you this
> is "like the current code does"?  I'll send you my test case attempts
> off-list and we can try together to get the right test to show this.  If
> it turns out that it does not really behave this way now and so my code
> is not introducing any regression, then (as usual) I'd rather fix this
> separately after the cleanup.

Heh. You are right, the current kernel has the same (minor) bug.
I beleive it was introduced by b2b2cbc4b2a2f389442549399a993a8306420baf.
Before this patch we notified the new parent even if it is from the same
thread group. If SIGCHLD is ignored, do_notify_parent() sets ->exit_signal = -1,
and then forget_original_parent() notices this and adds the child to ptrace_dead.
Now we don't notify the parent, and so the child "hangs".


However, now I think your patch adds a more serious problem, we can really
leak a zombie. Suppose that that we are ->real_parent, the child was traced
by us, it is zombie now, and the child is not a group leader. No matter who
is the new parent, no matter what is the state of SIGCHLD, we must not reparent
the child: nobody can release it except us. It is not traced any longer,
its ->exit_signal == -1, eligible_child() doesn't like this.

No?

> > Even if we don't ignore SIGCHLD, we should notify our thread-group, but
> > reparent_thread() skips do_notify_parent() when the new parent is from
> > is from the same thread-group.
> 
> Why do you think this is wrong?  The notification is always group-wide
> (a SIGCHLD to the group, and wakeup of the group-shared wait_chldexit).

Well, I was thinking about another thread (the new parent) sleeping in
do_wait(__WNOTHREAD)... not sure this really matters, though.

But,

> So there already was a notification, and a second one seems wrong to me.

Yes, I missed this. The second signal doesn't look right.

> > Note also that reparent_thread() has a very old bug. When it sees the
> > EXIT_ZOMBIE task, it notifies the new parent, but doesn't check if the task
> > becomes detached because the new parent ignores SIGCHLD. Currently this means
> > that init must have a handler for SIGCHLD or we leak zombies.
> 
> I had noticed that.  After the cleanup, we can look into fixing that.
> As usual, I am first going for a set of cleanup patches that changes
> exactly nothing semantically.

Yes, yes, I agree. I just wanted to be sure you didn't miss this bug.

Oleg.

