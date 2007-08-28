Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXH1Efl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXH1Efl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 00:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXH1Efd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 00:35:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbXH1Efc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 00:35:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: SIGNAL_STOP_DEQUEUED
In-Reply-To: Oleg Nesterov's message of  Monday, 13 August 2007 12:26:15 +0400 <20070813082615.GA90@tv-sign.ru>
X-Zippy-Says: Life is selling REVOLUTIONARY HAIR PRODUCTS!
Message-Id: <20070828043528.A86814D04CC@magilla.localdomain>
Date: Mon, 27 Aug 2007 21:35:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But SIGNAL_STOP_DEQUEUED code should be OK, afaics. We only need it to
> make sure do_signal_stop() can't miss SIGNAL_STOP_CONTINUED/GROUP_EXIT.
> 
> Can't we remove SIGNAL_STOP_DEQUEUED, btw?

No, we can't.

> 	dequeue_signal:
> 
> 		if (sig_kernel_stop(sig))
> 			->flags &= ~SIGNAL_STOP_CONTINUED;
> 
> 	do_signal_stop:
> 
> 		if (flags & (SIGNAL_STOP_CONTINUED | SIGNAL_GROUP_EXIT))
> 			return 0;
> 
> Possible?

SIGNAL_STOP_CONTINUED exists to keep track of whether CLD_CONTINUED has
been reported to the parent's wait* call using the WCONTINUED flag.
wait_task_continued (kernel/exit.c) clears it.  It should only be cleared
by the signals code when a job control stop actually happens before a wait*
call clears it.  In dequeue_signal, you do not yet know whether it will
actually lead to a stop.

SIGNAL_STOP_DEQUEUED exists to fix a particular race, when we dequeue a
signal and then unlock the siglock before acting on it.  This happens when
we call is_current_pgrp_orphaned(), and there might be other cases that
arise.  In the window while we do not hold the lock, a kill or suchlike can
take the long to post a SIGCONT.  The generation of a SIGCONT must clear
all pending stop signals from all the queues.  But, the thread that
dequeued the signal and then released the lock effectively has that signal
still "pending" in its stack state, where it cannot be cleared.  So, when
clearing stop signals from queues, we also clear the SIGNAL_STOP_DEQUEUED
flag.  After retaking the siglock and considering the previously dequeued
stop signal, we check that SIGNAL_STOP_DEQUEUED is still set.  This way, if
the stop signal had a handler, it runs, the stop signal having been
considered logically delivered before the SIGCONT was generated.  The
SIGKILL/group-exit case has the same need, where rather than needing to
have stop signals cleared from queus, we need to make sure SIGKILL
overrides any stop in progress just as it would wake up the stopped thread
if it came after the race.


Thanks,
Roland
