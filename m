Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbXBFEZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbXBFEZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXBFEZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:25:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXBFEZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:25:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Wednesday, 17 January 2007 11:17:37 -0500 <Pine.LNX.4.44L0.0701171114040.2381-100000@iolanthe.rowland.org>
X-Fcc: ~/Mail/utrace
X-Shopping-List: (1) Expectant honey tables
   (2) Mysterious strenuous chain intrusions
   (3) Compliant incompetent pajamas
Message-Id: <20070206042520.1F6E418005D@magilla.sf.frob.com>
Date: Mon,  5 Feb 2007 20:25:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I've been slow in giving you feedback on kwatch.

> I'll be happy to move this over to the utrace setting, once it is merged.  
> Do you think it would be better to include the current version of kwatch 
> now or to wait for utrace?
> 
> Roland, is there a schedule for when you plan to get utrace into -mm?

Since you've asked, I'll mention that I've been discussing this with Andrew
lately and we plan to work on merging it into -mm as soon as we can manage.

The kwatch implementation is pretty much orthogonal to the utrace patch as
it is so far.  As you've noted, it doesn't change the nature of the setting
of the debug registers; it only moves around the existing code for setting
them in raw form.  Hence it doesn't much matter which order the work is
merged at this stage.  There's no reason to withhold kwatch waiting for utrace.

I do have a problem with kwatch, however.  The existing user ABI includes
setting all of the debug registers, and this interface has never before
expressed a situation where you can set some but not all of them.  Having
ptrace suddenly fail with EBUSY when it never did before is not OK.  No
well-behaved kernel-mode tracing/debugging facility should perturb the user
experience in this way.  It is certainly understandable that one will
sometimes want to do invasive kernel-mode debugging and on special
occasions choose to be ill-behaved in this way (you might know your
userland work load doesn't include running gdb with watchpoints).  
But kwatch as it stands does not even make it possible to write a
well-behaved facility.

I am all in favor of a facility to manage shared use of the debug
registers, such as your debugreg.h additions.  I just think it needs to be
a little more flexible.  An unobtrusive kernel facility has to get out of
the way when user-mode decides to use all its debug registers.  It's not
immediately important what it's going to about it when contention arises,
but there has to be a way for the user-mode facilities to say they need to
allocate debugregs with priority and evict other squatters.  So, something
like code allocating a debugreg can supply a callback that's made when its
allocation has to taken by something with higher priority.  

Even after utrace, there will always be the possibility of a traditional
uncoordinated user of the raw debug registers, if nothing else ptrace
compatibility will always be there for old users.  So anything new and
fancy needs to be prepared to back out of the way gracefully.  In the case
of kwatch, it can just have a handler function given by the caller to start
with.  It's OK if individual callers can specially declare "I am not
well-behaved" and eat debugregs so that well-behaved high-priority users
like ptrace just have to lose (breaking compatibility).  But no
well-behaved caller of kwatch will do that.  

As a later improvement, kwatch could try a thing or two to stave off giving
up and telling its caller the watchpoint couldn't stay for the current
task.  For example, if a watchpoint is in kernel memory, you could switch
in your debugreg settings on entering the kernel and restore the user
watchpoints before returning to user mode.  Then you'd need to make
get_user et al somehow observe the user-mode watchpoints.  But it could be
investigated if the need arises.  Note that you can already silently do
something simple like juggling your kwatch debugreg assignments around if
the higher-priority consumer evicting you has left some other debugregs unused.

I certainly intend for later features based on utrace to include
higher-level treatment of watchpoints so that user debugging facilities can
also become responsive to debugreg allocation pressure.  (Eventually, the
user facilities might have easier ways of falling back to other methods and
getting out of the way of kernel debugreg consumers, than can be done for
the kernel-mode-tracing facilities.)  To that end, I'd like to see a clear
and robust interface for debugreg sharing, below the level of kwatch.  I'd
also like to see a thin layer on that giving a machine-independent kernel
source API for talking about watchpoints, which you pretty much have rolled
into the kwatch interface now.  But these are further refinements, not
barriers to including kwatch.

Also, an unrelated minor point.  I think it's error-prone to have an
integer argument to unregister_kwatch.  I think it makes most sense to have
the caller provide the space and call register/unregister with a pointer,
in the style of kprobes.


Thanks,
Roland
