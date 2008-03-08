Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYCHSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYCHSBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYCHSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:01:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59055 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYCHSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:01:09 -0500
Date: Sat, 8 Mar 2008 21:05:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: mt-exec && signals
Message-ID: <20080308180539.GA28398@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru> <20080307193159.1AFF127010F@magilla.localdomain> <20080307201346.GA107@tv-sign.ru> <20080307211955.A876226F990@magilla.localdomain> <20080307213217.GA2584@tv-sign.ru> <20080307215134.6E6BC26F990@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307215134.6E6BC26F990@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trim CC list, change the subject)

On 03/07, Roland McGrath wrote:
>
> > Btw, a question: we are buggy or just "not perfect" ? After all, the
> > main thread actually exits although this is just linux's implementation
> > detail.
>
> I think it's buggy.  The SIGKILL should kill the whole process.

OK, thanks... but the question above was only about the exiting leader in
the middle of exec...

Do we behave correctly when we send the specific "special" KILL/STOP/CONT
signal to the zombie leader when the thread group is alive?

For example, SIGKILL is silently (has subtle side effect) ignored, SIGSTOP
doesn't stop but has side effects, SIGCONT works.

Hmm? If this is not correct we can fix it.

> > > This is the big problem with exec that I've cited before.  It can even
> > > happen with group-wide signals that should be fatal, but avoided the
> > > __group_complete_signal special fatal case.  (e.g. the thread racing with
> > > the exec thread just now unblocked the signal and dequeued it.)  IIRC it
> > > was the biggest reason we wanted to revisit the whole MT exec plan.
> > 
> > Oh. Could you clarify? Afaics, currently exec() can't miss the fatal group
> > signal?
> 
> Threads A and B both block SIGTERM.  An outside process sends SIGTERM,
> so it is queued in shared_pending but noone wakes.
> 
> A starts an exec.		
> 
> B unblocks SIGTERM.  
> B enters get_signal_to_deliver, locks, dequeues SIGTERM, unlocks.
> Now B is e.g. just before "current->flags |= PF_SIGNALED;".
> 
> A locks.  No group-exit is in yet progress.  
> A does zap_other_threads, and unlocks.
> 
> B enters do_group_exit.  A group-exit is in progress, so it just exits.
> SIGTERM is lost.

Ah, this. Yes I know, we can lost the non-fatal group-wide signal
on mt-exec. Note that we don't need to block the signal, it could
be stealed by sub-thread anyway.

> But for me it is just an
> example of why we still need to step back and think over the whole
> exec picture.

Yes sure.

But I already thought about this, and actually I was almost going
to send something like the (incomplete) patch below.

What do you think? Do you agree it should fix all problems with
the group signals vs exec?

Oleg.

--- kernel/signal.c	2008-03-08 19:15:00.000000000 +0300
+++ kernel/signal.c	2008-03-08 21:00:44.883423954 +0300
@@ -379,6 +379,9 @@ int dequeue_signal(struct task_struct *t
 {
 	int signr;
 
+	if (signal_group_exit(tsk->signal))
+		return SIGKILL;
+
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
@@ -428,8 +431,7 @@ int dequeue_signal(struct task_struct *t
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*

