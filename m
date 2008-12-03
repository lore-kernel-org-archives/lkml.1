Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYLDAxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYLDAxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYLDAxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:53:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYLDAxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:53:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <onestero@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SIGTRAP vs. sys_exit_group race
In-Reply-To: Oleg Nesterov's message of  Thursday, 16 October 2008 18:57:27 +0200 <20081016165727.GA6442@redhat.com>
References: <48EA1BE9.1030707@siemens.com>
	<20081016165727.GA6442@redhat.com>
X-Shopping-List: (1) Would-be complicators
   (2) Skeptical demolition
   (3) Symphonic exotic nutrition
   (4) Electric compressors
   (5) Vainglorious prosecutors
Message-Id: <20081204005203.7AE1CFC053@magilla.sf.frob.com>
Date: Tue,  2 Dec 2008 20:47:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, what do you think?
> 
> On 10/06, Jan Kiszka wrote:
> >
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1528,10 +1528,11 @@ static void ptrace_stop(int exit_code, i
> >  		spin_unlock_irq(&current->sighand->siglock);
> >  		arch_ptrace_stop(exit_code, info);
> >  		spin_lock_irq(&current->sighand->siglock);
> > -		if (sigkill_pending(current))
> > -			return;
> >  	}
> >
> > +	if (sigkill_pending(current))
> > +		return;
> > +
> 
> Personally, I think this change is good anyway. The tracee shouldn't
> sleep in TASK_TRACED with the pending SIGKILL.

I think this is actually superfluous since TASK_WAKEKILL (2.6.24?).
It won't sleep in TASK_TRACED at all, because of signal_pending_state().

> I think we need further changes. If the thread group group was killed
> by some fatal signal (but not SIGKILL) the tracee will sleep with
> SIGNAL_GROUP_EXIT, this is not nice too. But imho the patch makes
> sense anyway.

When there is no (user-level) SIGKILL and no core dump synchronization, I
think it's desireable for each thread to stop in exit tracing so it can be
fully examined.

I believe the behavior Jan saw is not new, but was always possible in races
depending on when signals got sent.  The SIGTRAP (or PTRACE_EVENT_*)
exit_code might be seen by gdb's wait4 call, but the task can be woken
again by SIGKILL in the next instant and have the death exit_code seen by
the next wait4 call (or not, depending on the race).  Since the The size of
the window where an asynchronous SIGKILL could leave the previous SIGTRAP
(et al) exit_code to be seen by wait4 before seeing the death code might
have changed with the introduction of TASK_WAKEWILL, but it was always
there.


Thanks,
Roland
