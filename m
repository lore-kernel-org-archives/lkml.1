Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXIAI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXIAI1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXIAI1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 04:27:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXIAI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 04:27:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? fix SIGNAL_STOP_DEQUEUED vs SIGCONT race
In-Reply-To: Oleg Nesterov's message of  Tuesday, 28 August 2007 19:54:33 +0400 <20070828155433.GA1081@tv-sign.ru>
Emacs: because one operating system isn't enough.
Message-Id: <20070901082638.3C1124D04CC@magilla.localdomain>
Date: Sat,  1 Sep 2007 01:26:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Move the setting of SIGNAL_STOP_DEQUEUED from dequeue_signal() to
> get_signal_to_deliver(), and set this flag only if we are really going to stop.
> This also simplifies the code and makes the SIGNAL_STOP_DEQUEUED usage more
> understandable.

It looks like a nice cleanup to me.

> However, this changes the behaviour when the task is ptraced. If the debugger
> doesn't clear ->exit_code, SIGSTOP always succeeds after ptrace_stop(), even
> if SIGCONT was sent in between. I can't decide whether this change is good
> or bad, hopefully Roland can clarify.

Hmm.  I think this is bad.  

First, considering only the single-threaded case, there are debugger vs
SIGCONT races.  Someone does kill(pid,SIGSTOP);kill(pid,SIGCONT); while pid
is debugged.  The mandate for end user behavior here is that pid cannot
wind up sitting in job control stop in the end.  Say the debugger is
e.g. strace, simply printing every signal and passing it through.
So say it goes:
	T			K			D
	merrily running ...				blocked in wait4
				kill(K, SIGSTOP)
	dequeue SIGSTOP
	 -> ptrace_stop
 							wait4 -> K,{SIGSTOP}
				kill(K, SIGCONT)
							PTRACE_CONT,K,SIGSTOP
	do_signal_stop(SIGSTOP)
 							wait4 -> K,{SIGSTOP}

The debugger did the obvious thing: just pass through what it got.
The killer did something POSIX guarantees leaves T running.
T is in job control stop, with a pending SIGCONT (normally impossible).
It's not the end of the world, since the next SIGKILL or SIGCONT will
always wake it up.  But it's not right.

There are related issues with multi-threaded job control stop and with
suddenly killing the debugger.  I could get into those in detail.  But I
think the case above illustrates why we need a stop signal pending
consideration by the debugger to be like a stop signal pending locking for
the is_current_pgrp_orphaned() check when a SIGCONT/SIGKILL comes in between.

It's still probably a worthwhile cleanup to have the logic only in
get_signal_to_deliver, and to fix the problem you cited.  It will take only
a little extra code to handle the ptrace case too, i.e.
	if (sig_kernel_stop(signr) &&
 	    current->sighand->action[signr-1] == SIG_DFL &&
 	    !(current->signal->flags & SIGNAL_GROUP_EXIT))
		current->signal->flags |= SIGNAL_STOP_DEQUEUED;
	ptrace_stop(signr, signr, info);
	if (sig_kernel_stop(signr) && current->exit_code == signr &&
	    !(current->signal->flags & SIGNAL_STOP_DEQUEUED) &&
 	    current->sighand->action[signr-1] == SIG_DFL)
		current->exit_code = 0;
maybe.


Thanks,
Roland
