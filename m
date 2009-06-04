Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZFDCcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZFDCcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 22:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZFDCcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 22:32:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbZFDCcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 22:32:10 -0400
Date: Thu, 4 Jun 2009 04:27:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
Message-ID: <20090604022749.GA19054@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com> <20090525172033.GA12586@redhat.com> <4A1AE02D.5080701@gmail.com> <20090525225150.GA12362@redhat.com> <4A25211C.8050504@gmail.com> <20090602144951.GA12123@redhat.com> <20090603015215.85A78FC333@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603015215.85A78FC333@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Roland McGrath wrote:
>
> > > > Heh. In this case you have another (long-standing) issue, please note
> > > > the "if (p->flags & PF_EXITING)" check in wants_signal().
>
> Hmm.  wants_signal():
>
> 	if (p->flags & PF_EXITING)
> 		return 0;
> 	if (sig == SIGKILL)
> 		return 1;
>
> Perhaps we should reverse the order of those two?

Yes perhaps. But afaics this is not enough.

First of all, we should decide what we really want wrt exiting process/thread
&& signals. (see also the end of message).

Let's suppose the killed/exiting process hangs somewhere in close_files(),
and the user wants to SIGKILL via kill(1).

If this process is multithreaded, how can we find the right thread to
wake up? Or we should assume the user should find the offending thread
and use tkill() ? In that case, what if this thread still has the pending
private SIGKILL ?

Of course, the same problem with the shared SIGKILL pending, it is never
dequeued so the next group-wide SIGKILL has no effect.

> But also I'm now reminded that complete_signal() short-circuits for the
> single-threaded case and never does the sig_fatal() case.
>
> This means a single-threaded process will have SIGKILL in shared_pending
> but not in its own pending so __fatal_signal_pending() will be false, no?

Hmm, afaics no. Or I misunderstood. Or I missed something.

Yes, it is possible that we add SIGKILL in shared_pending and do not add
it in ->pending, but this can only happen if all threads have PF_EXITING.
(so "single-threaded" above doesn't matter).

> I'm also now wondering if in some of our recent signals discussions we have
> been assuming that SIGNAL_GROUP_EXIT is set when a fatal signal is pending.

Yes. SIGNAL_GROUP_EXIT == all threads have the pending private SIGKILL.
Except, in do_exit() path, it can be already dequeued.

> > We can clear TIF_SIGPENDING, and we can change recalc_sigpending_xxx()
> > to take PF_EXITING into account (or change their callers), but this
> > needs changes. And I am not sure this will right.
>
> I think we want recalc_sigpending_tsk to be consistent with wants_signal
> and the other conditions controlling signal_wake_up calls.

Well, perhaps. But let's look from the different angle. IF the task was
already SIGKILL'ed, it looks a bit insane we need another SIGKILL to
really kill it if it hangs in do_exit().

Perhaps we need another flag, SIGNAL_GROUP_KILLED or whatever which is
set along with SIGNAL_GROUP_EXIT by complete_signal() when the task is
killed. It is not set by zap_other_threads/etc.

Now, exit_signals() should do something like

	if (SIGNAL_GROUP_KILLED) {
		// make sure interruptible/killable sleep is not
		// possible, we are already killed
		set_thread_flag(TIF_SIGPENDING);
	} else {
		// OK, we still respect SIGKILL
		clear_thread_flag(TIF_SIGPENDING);
	}
		
Of course we need other changes. complete_signal() should check
SIGNAL_GROUP_KILLED, not SIGNAL_GROUP_EXIT, and wake up all threads.
recalc_sigpending_tsk() needs changes, __fatal_signal_pending()
should be consistent with SIGNAL_GROUP_KILLED on exiting, etc.

Note also complete_signal() does signal_wake_up(t, sig == SIGKILL)
even if SIGNAL_GROUP_EXIT, we should be carefull.

> But indeed we
> need to think through any ramifications carefully.

Agreed. And yes, this is connected to the coredump discussion.

Oleg.

