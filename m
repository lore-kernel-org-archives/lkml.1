Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZBIEzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZBIEzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 23:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZBIEze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 23:55:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52113 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZBIEzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 23:55:33 -0500
Date: Mon, 9 Feb 2009 05:52:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090209045234.GA3213@redhat.com>
References: <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <20090205030553.49650FC381@magilla.sf.frob.com> <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com> <20090205161544.GA24799@redhat.com> <20090205212234.934D1FC381@magilla.sf.frob.com> <20090205232223.GB10345@redhat.com> <20090209033335.5DE77FC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209033335.5DE77FC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am already sleep, will return tomorrow. Just a souple of quick notes...

On 02/08, Roland McGrath wrote:
>
> I think the first problem is we'll never even get into wait_task_stopped().
> We'll be in wait_consider_task() on the group leader, which is EXIT_ZOMBIE.

Yes sure. I meant, instead of just checking task_is_stopped_or_traced() in
wait_consider_task(), we should do somthing like

	int wait_is_stopped(p, ptrace)
	{
		if (ptrace)
			// wait_task_stopped() will also check p->exit_code != 0
			return task_is_stopped_or_traced(p);
		else
			// wait_task_stopped() will also check ->group_exit_code != 0
			return !!(signal->flags & SIGNAL_STOP_STOPPED);
	}

> In wait_task_zombie_leader(), it will have to take the siglock and try to
> figure out if there is a completed group stop to report.
>
> > 	if we tracer:
> >
> > 		check ->state, eat ->exit_code
>
> Being the ptracer does not affect the delay_group_leader logic.
> It just affects individual vs group stop reports.  So the existing
> code path is right for ptrace.
>
> > 	else:
> > 		check SIGNAL_STOP_STOPPED, use ->group_exit_code
>
> We don't want wait to change group_exit_code.  But we need the "reported as
> stopped" tracking that wait_task_stopped() gets by clearing exit_code.

I never understood this.

Why do we mix the normal group stop with the ptrace "per-thread" stops?

Look. We have the main thread M and the sub-thread T. We stop this process,
its parent does do_wait() and clears M->exit_code.

Now, ptracer can attach to T (it still has ->exit_code != 0), but not to M.
This always looked very strange to me.

Or. ptracer attaches to the main thread and (say) does nothing. We send
SIGSTOP to another thread. The whole group stops, but its parent can't
see this. Why? Then ptracer does PTRACE_DETACH, and the parent still can't
(and will never can) see the stop unless the ptracer puts something reasonable
into ->exit_code. But even in this case we lost the notofication.

> So
> I think what we need is to get the zombie group_leader->exit_code to be set
> to ->group_exit_code as it would have been if the leader were alive and had
> participated in the group stop.

Please see below.

> > 	$ sleep 100
> > 	^Z
> > 	[1]+  Stopped                 sleep 100
> > 	$ strace -p `pidof sleep`
> > 	Process 11442 attached - interrupt to quit
> >
> > strace hangs in do_wait(). But after the fix strace will happily
> > proceed. I can't know whether this behaviour change is bad or not.
>
> I think this would only happen if the "reported as stopped" bookkeeping I
> mentioned above were broken.  The "Stopped" line means that the shell just
> did do_wait(WUNTRACED), so wait_task_stopped() cleared ->exit_code when
> reporting it as stopped.  Now strace does PTRACE_ATTACH and then a wait;
> it can't see a fresh wait result here because ->exit_code is still zero.

Yes. And why ptracer should wait?

> 100% untested concept patch follows.

it adds more special cases for the delay_group_leader() zombies :(

> +static inline void complete_group_stop(struct task_struct *tsk,
> +				       struct signal_struct *sig,
> +				       int stop_count)
> +{
> +	if (stop_count)
> +		return;
> +
> +	sig->flags = SIGNAL_STOP_STOPPED;
> +
> +	if (tsk->group_leader->exit_state)
> +		tsk->group_leader->exit_code = sig->group_exit_code;
> +}

This doesn't look exactly right. Unless another thread does sys_exit_group()
later (they all can exit via sys_exit), wait_task_zombie() may report this
->exit_code == SIGSTOP.

Oleg.

