Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZFAWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZFAWiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZFAWiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:38:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZFAWiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:38:15 -0400
Date: Tue, 2 Jun 2009 00:32:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601223241.GA26788@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk> <20090601171119.GA13970@redhat.com> <20090601184608.6379440c@lxorguk.ukuu.org.uk> <20090601182305.GA16372@redhat.com> <20090601203845.B010DFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601203845.B010DFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Roland McGrath wrote:
>
> IMHO it would certainly be wrong to have behavior differ based on what
> particular method from userland was used to generate a signal.

Agreed.

> Aside from that, I see the following categories for newly-arriving signals.
>
> 1. More core-dump signals.  e.g., it was already crashing and you hit ^\
>    or maybe just hit ^\ twice with a finger delay.
> 2. Non-fatal signals (i.e. ones with handlers, stop signals).
> 3. Plain sig_fatal() non-core signals (e.g. SIGINT when not handled)
> 4. SIGKILL (an actual one from userland or oomkill, not group-exit)
>
> #1 IMHO should not do anything at all.
> You are asking for a core dump, it's already doing it.
>
> #2 should not do anything at all.
> It's not really possible to suspend during the core dump, so unhandled,
> unblocked stop signals can't do anything either.
>
> #4 IMHO should always stop everything immediately.
> That's what SIGKILL is for.  When userland generates a SIGKILL
> explicitly, that says the top priority is to be gone and cease
> consuming any resources ASAP.

Agreed.

> #3 is the open question.  I don't feel strongly either way.
>
> Whatever the decision on #3, we have a problem to fix for #1 and #2 at
> least anyway.  These unblocked signals will cause TIF_SIGPENDING to be
> set when dumping, either via recalc_sigpending() from dequeue_signal()
> after the core signal is taken (more signals already pending), or via
> signal_wake_up() from complete_signal() for newly-generated signals.
> (PF_EXITING is not yet set to prevent it.)  This spuriously prevents
> interruptible waits in the fs code or the pipe code or whatnot.
>
> That looks simple to avoid just by clobbering ->real_blocked when we
> start the core dump.

I don't think ->real_blocked is a good choice, we have to add more checks
to the signal sending path. Note that currenly it is only checked under
sig_fatal() && !SIGNAL_GROUP_EXIT.

Perhaps it is easier to change dump_write() to clear TIF_SIGPENDING
unless fatal_signal_pending(),

	int coredump_file_write(struct file *file, const void *addr, int nr)
	{
		while (nr > 0) {
			int res = file->f_op->write(file, addr, nr, &file->f_pos);

			if (res > 0) {
				nr -= res;
				continue;
			}

			if (!signal_pending(current))
				break;
			if (__fatal_signal_pending(current))
				break;
			clear_thread_flag(TIF_SIGPENDING);
		}

		return !nr;
	}

> The less magical way that is obvious
> would be to add a SIGNAL_GROUP_DUMPING flag that we set at the beginning
> of the dumping, and make recalc_sigpending_tsk/complete_signal obey that.

We do not need to change recalc_sigpending_tsk. For example, if we decide
that only SIGKILL interrupts the coredumping, than I think something like
the patch below should work. But I think we should change dump_write() to
handle the short write anyway?

Of course, this all assumes f_op->write() does not do recalc_sigpending().

Oleg.

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -644,6 +644,8 @@ static int prepare_signal(int sig, struc
 		/*
 		 * The process is in the middle of dying, nothing to do.
 		 */
+		if ((signal->flags & SIGNAL_GROUP_DUMPING) && sig != SIGKILL)
+			return 0;
 	} else if (sig_kernel_stop(sig)) {
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1537,6 +1537,8 @@ static inline int zap_threads(struct tas
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		tsk->signal->group_exit_code = exit_code;
+		tsk->signal->flags |= SIGNAL_GROUP_DUMPING;
+		clear_thread_flag(TIF_SIGPENDING);
 		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -1760,12 +1762,6 @@ void do_coredump(long signr, int exit_co
 	old_cred = override_creds(cred);
 
 	/*
-	 * Clear any false indication of pending signals that might
-	 * be seen by the filesystem code called to write the core file.
-	 */
-	clear_thread_flag(TIF_SIGPENDING);
-
-	/*
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
 	 */

