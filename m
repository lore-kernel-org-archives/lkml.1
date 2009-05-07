Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZEGFxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZEGFxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 01:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZEGFxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 01:53:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZEGFxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 01:53:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 06:52:41 +0200 <20090506045241.GA26214@redhat.com>
References: <20090505224722.GA954@redhat.com>
	<20090506020223.A4F1AFC328@magilla.sf.frob.com>
	<20090506045241.GA26214@redhat.com>
X-Zippy-Says: I would like to urinate in an OVULAR, porcelain pool --
Message-Id: <20090507055159.8AFA1FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 22:51:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another subtle change I forgot to comment.

You've got to leave some little things for me to notice and mention so I
can look like I'm paying attention. ;-)

> The last patch in series, "do not use task_lock()", is the reason.
> 
> We need tasklist for writing to check (and set) ->ptrace, but we need
> task_lock() to call __ptrace_may_access().

I see.

> We can preserve the current behaviour, we can do get_task_mm() beforehand,
> modify __ptrace_may_access() a bit, and call __ptrace_may_access() under
> tasklist later (in fact, this was the very first version of this patch which
> I didn't send).

Perhaps there is a way to reorder the patches that makes it simpler?

On second look, what does __ptrace_may_access() need task_lock() for anyway?

> But do we really care? If selinux denies to ptrace this task, can't we
> return -EACESS regardless of ->ptrace?

You're right that the return code is the same either way.  That's not the
issue.  The issue is whether this case calls security_ptrace_may_access()
at all, because doing so can have side effects.  Consider an application
that does:

	ptrace(PTRACE_ATTACH, pid);
	ptrace(PTRACE_ATTACH, pid);
	pid = wait(&status);

It works fine, because it doesn't care that the second call fails.
(A real-world example would be much more complex, with mounds of poorly
structured code so nobody can even tell what calls have already been made.
Maybe the first one would really have been the child doing PTRACE_TRACEME,
or inheriting via CLONE_PTRACE/PTRACE_O_TRACECLONE, etc.)

After your change, the application still works fine by itself.  But now,
the second call causes a security_ptrace_may_access() call that wasn't
there before.  This hits some crazy LSM arrangement we haven't even
thought of, and produces auditing complaints about improper ptrace
attempts.  Those log messages on a server trigger some fancy monitoring
thing that identifies them as unexpected and security-related, decides
that means they're urgent, and so pages the poor sysadmin and his boss
and his boss's boss with bright red "BREAK-IN ATTEMPTED IN THE
DATACENTER" pages vibrating their beltlines right when their hot dates
were about to get interesting.  The poor sysadmin spends the next month
of his life in rat holes of wild paranoia and reinstalling, and then
eventually in tedious explanations of how there was never any intrusion
but he'd just done an innocuous kernel upgrade that he knew was not
supposed to change any application behavior.

That is a ridiculous scenario that presupposes some huge, inscrutable,
and inanely-written applications in fragile arrangements with mindless
nonsense riddled with holes and called business-ready management and
monitoring infrastructure for "mission-critical security" purposes, and
then some admin reactions that range from clueless to irresponsible.
(That never happens in real deployments, right?)  But it illustrates the
pervasive law of unintended consequences.  That's what not perturbing
the deterministic aspects of system behavior without deliberate and
careful intent is all about.


Thanks,
Roland
