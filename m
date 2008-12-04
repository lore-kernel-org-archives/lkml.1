Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYLDS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYLDS0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYLDS0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:26:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYLDS0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:26:01 -0500
Date: Thu, 4 Dec 2008 19:24:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SIGTRAP vs. sys_exit_group race
Message-ID: <20081204182431.GB17468@redhat.com>
References: <48EA1BE9.1030707@siemens.com> <20081016165727.GA6442@redhat.com> <20081204005203.7AE1CFC053@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204005203.7AE1CFC053@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Roland McGrath wrote:
>
> > Roland, what do you think?
> >
> > On 10/06, Jan Kiszka wrote:
> > >
> > > --- a/kernel/signal.c
> > > +++ b/kernel/signal.c
> > > @@ -1528,10 +1528,11 @@ static void ptrace_stop(int exit_code, i
> > >  		spin_unlock_irq(&current->sighand->siglock);
> > >  		arch_ptrace_stop(exit_code, info);
> > >  		spin_lock_irq(&current->sighand->siglock);
> > > -		if (sigkill_pending(current))
> > > -			return;
> > >  	}
> > >
> > > +	if (sigkill_pending(current))
> > > +		return;
> > > +
> >
> > Personally, I think this change is good anyway. The tracee shouldn't
> > sleep in TASK_TRACED with the pending SIGKILL.
>
> I think this is actually superfluous since TASK_WAKEKILL (2.6.24?).
> It won't sleep in TASK_TRACED at all, because of signal_pending_state().

Yes. But what if the task was killed by the group-wide SIGKILL, and
already dequeued SIGKILL from ->pending ? (do_exit path).

> > I think we need further changes. If the thread group group was killed
> > by some fatal signal (but not SIGKILL) the tracee will sleep with
> > SIGNAL_GROUP_EXIT, this is not nice too. But imho the patch makes
> > sense anyway.
>
> When there is no (user-level) SIGKILL and no core dump synchronization, I
> think it's desireable for each thread to stop in exit tracing so it can be
> fully examined.

Yes. But my point was, it is not good the tracee sleeps and can't be
killed. Yes, the user can use tkill(9) to wake it up, but still.

Oleg.

