Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXFDRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXFDRqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXFDRqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:46:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51700 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXFDRp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:45:59 -0400
Date: Mon, 4 Jun 2007 10:45:42 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Syslets, signals, and security
Message-ID: <20070604174542.GD29201@mami.zabbo.net>
References: <20070604163145.GA7144@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604163145.GA7144@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:31:45PM -0400, Jeff Dike wrote:
> Syslets seem like a fundamentally good idea to me, but the current
> implementation, using CLONE_THREAD threads, seems like a basic
> problem.

It has remaining problems that need to be addressed, yes.

> First, there are signals.  If the app has an interval timer enabled,
> every thread will inherit it and you will have 32 threads getting
> alarms, which seems surprising and wasteful.  I can imagine other
> signals (like SIGWINCH and  SIGHUP) which might be surprising to
> receive multiple times in an obstensibly single-threaded process.

Yeah.  I'm hoping someone who knows more about signals than I do would
be excited about looking into the best way to fix this.  I'm sure I
could plod through it in time, but, bleh.  SIGXFSZ is the one in the
back of my mind.

> Second, security.  What happens if a well-written server starts life
> as root, does some (async) I/O, and setuids to a non-root uid?  There
> will be a bunch of async threads still running as root, with the
> result that async operations (and the main thread) will more than
> occassionally regain root privs.

Yeah.  I wanted to experiment with this in the fs/aio.c syslet
management code.  The most obvious fix is to just tear down all the
waiting threads before each operation.  We have to have a worst case to
measure :).  More incentive to get thread creation and destruction even
cheaper might not be such a bad thing, too.

One can imagine all sorts of crazy schemes which let us only shoot down
waiting async threads which were cloned before state in the submitting
task_struct was changed.  Maybe we could swallow increasing a counter in
task_struct each time we change one of these sensitive fields (fsuid,
etc), but I bet the maintenance burden of anything more fine grained
than that would get pretty excessive.

> You can fix this by going around to all the threads in the thread
> group and changing their ->uid, but that seems somewhat kludgy.

No doubt racey and unsafe, too.

> There's also ptrace, which (as I think Zach already mentioned) gets
> along badly with syslets.

Yeah, and I'm blissfully ignorant of ptrace.  Imagine me skipping
through a field of daisies with some ptrace wolves hiding in the bushes
at the edge of the meadow.  La la la.

> Offhand, it seems to me that the underlying problem is that the
> threads all have their own task_structs and userspaces.

Well, don't conflate the two issues.

Each execution context having its own task struct is intentional, very
much so.  Remember, this started with the fibrils patch series which
indeed shared a single task struct amongst a set of running stacks and
thread infos, etc.  This approach is invasive because it changes the
sleeping entity in the scheduler from a task struct to some new
construct which has a many to one mapping to the task struct.  It
touches vast amounts of code.  This approach is also risky because it
introduces concurrent access to the task struct.  That's a pretty big
auditing burden.  So the syslet approach is a more conservative
alternative.  I think we'll need a pretty strong demonstration of why we
*can't* fix the problems you're seeing with the syslets approach before
taking on the amount of effort needed to divorce the notion of tasks and
scheduling entities.

Each thread being able to return to userspace is an interface design
decision that I'm not prepared to defend.  My current preference for a
user-facing API would be a lot stupider than what Ingo has built around
the atoms, and such, but I haven't taken up that battle as I'm focusing
on the fs/aio.c use of syslets.

My intention with the fs/aio.c syslet use is to only ever have one of
the worker threads returning to userspace.  That's not quite implemented
now.  I think cachemiss threads servicing fs/aio.c could get quite
confused if they exit their scheduling loop if a signal is raised, but
that's a bug -- not a feature :).

> Since the basic schedulable unit is currently a task_struct, and
> syslets would prefer to have multiple schedulable units per
> task_struct, this would imply some surgery on the task_struct and the
> scheduler.  What I think we'd want is for the basic schedulable unit
> to be not much more than a kernel stack and a register set.  A
> (non-kernel-thread) task_struct would still be associated 1-1 with a
> userspace, but could have multiple schedulable units, one of which is
> allowed to exit to userspace.

Have you looked at how the fibrils stuff did it?  It's a lot more work
than it seems like it should be, on first glance.  You start to modify
things and every few days you trip across another fundamental kernel
construct which needs to be modified :/.

  http://lwn.net/Articles/219954/

So can we dig a little deeper into what it will take to fix these
problems with the syslet approach?

- z
