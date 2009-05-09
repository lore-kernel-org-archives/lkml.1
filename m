Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZEIStR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZEIStR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 14:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZEIStB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 14:49:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbZEIStA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 14:49:00 -0400
Date: Sat, 9 May 2009 20:43:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090509184303.GA10396@redhat.com>
References: <20090505224722.GA954@redhat.com> <20090506020223.A4F1AFC328@magilla.sf.frob.com> <20090506045241.GA26214@redhat.com> <20090507055159.8AFA1FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507055159.8AFA1FC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Roland McGrath wrote:
>
> > We can preserve the current behaviour, we can do get_task_mm() beforehand,
> > modify __ptrace_may_access() a bit, and call __ptrace_may_access() under
> > tasklist later (in fact, this was the very first version of this patch which
> > I didn't send).
>
> Perhaps there is a way to reorder the patches that makes it simpler?
>
> On second look, what does __ptrace_may_access() need task_lock() for anyway?

Just for get_dumpable(task->mm), I think.

> > But do we really care? If selinux denies to ptrace this task, can't we
> > return -EACESS regardless of ->ptrace?
>
> You're right that the return code is the same either way.  That's not the
> issue.  The issue is whether this case calls security_ptrace_may_access()
> at all, because doing so can have side effects.  Consider an application
> that does:
>
> 	ptrace(PTRACE_ATTACH, pid);
> 	ptrace(PTRACE_ATTACH, pid);
> 	pid = wait(&status);
>
> It works fine, because it doesn't care that the second call fails.
> (A real-world example would be much more complex, with mounds of poorly
> structured code so nobody can even tell what calls have already been made.
> Maybe the first one would really have been the child doing PTRACE_TRACEME,
> or inheriting via CLONE_PTRACE/PTRACE_O_TRACECLONE, etc.)
>
> After your change, the application still works fine by itself.  But now,
> the second call causes a security_ptrace_may_access() call that wasn't
> there before.  This hits some crazy LSM arrangement we haven't even
> thought of, and produces auditing complaints about improper ptrace
> attempts.  Those log messages on a server trigger some fancy monitoring
> thing that identifies them as unexpected and security-related, decides
> that means they're urgent, and so pages the poor sysadmin and his boss
> and his boss's boss with bright red "BREAK-IN ATTEMPTED IN THE
> DATACENTER" pages vibrating their beltlines right when their hot dates
> were about to get interesting.  The poor sysadmin spends the next month
> of his life in rat holes of wild paranoia and reinstalling, and then
> eventually in tedious explanations of how there was never any intrusion
> but he'd just done an innocuous kernel upgrade that he knew was not
> supposed to change any application behavior.

OK, so this change is not purely cosmetic as I thought.

We can fix this in many ways. We can extract the ->cred and ->mm checks
from __ptrace_may_access() into another helper which is called before
write_lock(tasklist), and then call security_ptrace_may_access under tasklist.
Or we can do get_task_mm() in advance and call __ptrace_may_access() without
task_lock().

Or, perhaps, we can just check ->ptrace before __ptrace_may_access()
lockless (just to prevent the scenario above), and then check it again
under tasklist? This looks like a simplest option.

Oleg.

