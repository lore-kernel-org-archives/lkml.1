Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbYCGDxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbYCGDxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYCGDxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:53:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYCGDxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:53:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
In-Reply-To: Oleg Nesterov's message of  Wednesday, 5 March 2008 20:11:09 +0300 <20080305171109.GB6723@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru>
	<20080304122654.7313227010A@magilla.localdomain>
	<20080305171109.GB6723@tv-sign.ru>
X-Zippy-Says: Hello, GORRY-O!!  I'm a GENIUS from HARVARD!!
Message-Id: <20080307035308.2D8CD2700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 19:53:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's excluded from counting as in your session if you consider to to be init.
> 
> Yes. Not that I really understand ;) But Eric also suggested to use
> is_container_init().

That uses a slightly different test, which I specifically did not chose.
is_container_init says "your parent thinks its PID is 1".  The test I
posted says "you think your parent's PID is 1".  (I'm being anal again.)
It's an arcane distinction.  But it seems like the correct mapping of the
original pre-pid_ns logic.

I agree with Eric that the init special case ought to just go away.
I'd suggest we do this alone first by removing the existing 
is_global_init(p) check in a tiny commit before we get into the rest
of the cleanup.  If someone's init ever has a problem, they can bisect
it back to that and we can discuss what they think it should be doing.

> So perhaps it's:
> > 
> > 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
> > 		if (task_session(p->real_parent) == task_session(p) &&
> > 		    task_pgrp(p->real_parent) != pgrp &&
> >  		    atomic_read(&p->signal->live) > 0 &&
> > 		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
> > 			return 0;
> > 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
> 
> I am hopeless, I can't understand orphaned pgrps.

Eric explained it pretty well.  The idea is a pgrp is an orphan if it has
no "controller".  That term is used only a couple of times in POSIX.  In
real examples, the "controller" is always your shell.  If the shell is
gone, stopped jobs could linger around forever.  Consider:

	$ foo
	^Z
	[1]+  Stopped                 foo
	$ kill -9 $$

So foo gets the SIGHUP+SIGCONT to make it likely to die when it should.
In practice, you use "logout" not "kill -9 $$", and I suspect nowadays
the shell kills the jobs for you whenever it exits gracefully.  But this
is how the behavior arose.

Even more likely, consider:

	$ stty tostop
	...
	$ trap '' SIGHUP	# signal(SIGHUP, SIG_IGN)
	$ foo &
	$ logout

You wanted foo to keep running when you were gone, and forgot about doing
stty tostop.  Now it does some output, but the tty is someone else's, so
it gets SIGTTOU.  If this made it stop, it would be stopped until morning.
That's why it ignores such stops.  (This is why the nohup command
redirects stdout if it's a tty.)  

Nowadays there are all manner of things that make these scenarios far less
likely.  e.g. revocation of ttys, the fancy nohup command, etc.  But POSIX
specifies only a slight refinement (with the "session" idea) from what was
the original status quo of job control in 4.2/4.3 BSD.

> But still. Let's suppose that pgrp should be considered as orphaned when
> 2 tasks A and B exit. They both exit at the same time and decrement ->live
> down to zero. Now, they both can send SIGHUP to the stopped tasks.
> 
> No?

Yes, I think.  What we want is that the act of orphaning a given pgrp
happens only once.  It's that act, the transition from "controlled"
pgrp to "orphaned pgrp" that should generate the signals.  Currently
what we really check is whether it is an orphaned pgrp right now, just
after removing the currently-exiting task from the pgrp.  That is not
a transition that happens once, it's a state that prevails once the
transition has occurred.

We need to think about this more.  I just spent a while hurting my brain.
I didn't come up with anything clever.

> Stupid question, just to be sure. Suppose that SIGTSTP was sent by a
> "regular" kill_pid_info() (not by tty or kill_pgrp_info). In that case
> get_signal_to_deliver() still must check is_current_pgrp_orphaned(),
> yes?

Yes.  It is specifically said that SIGTSTP, SIGTTIN, SIGTTOU may not
cause a stop in a member of an orphaned pgrp.  It doesn't matter how
it came to be that the signal got delivered.


Thanks,
Roland
