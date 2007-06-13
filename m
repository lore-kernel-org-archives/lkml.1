Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbXFMXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbXFMXCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbXFMXCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:02:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbXFMXCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:02:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
In-Reply-To: Benjamin Herrenschmidt's message of  Thursday, 14 June 2007 08:36:00 +1000 <1181774160.14818.333.camel@localhost.localdomain>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070613230153.7B3034D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 16:01:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The freezer is crap... news at 11. Maybe a quick hack would be to let it
> clear sigpending if tsk->mm == NULL but that's ugly. Note that there's
> anything pretty about the freezer anyway...

I think it might be made not too unreasonable by adding a TASK_FROZEN state.
But I am still persuaded by my "hide in the corner" plan.

> Well.. why was it _and_wake() in the first place anyway ? Or do I miss
> something ? Why would we need to wake a thread for which we are removing
> signals ?

The bug was about a case where recalc_sigpending_tsk would set
TIF_SIGPENDING when it hadn't been set before (wants_signal).  It has
nothing to do with the rm_from_queue_full being done there.  It's just a
violation of the necessary rule that when you set TIF_SIGPENDING on another
thread you better call signal_wake_up on it.

> What about something like:
> 
> 			do {
> 				rm_from_queue_full(&mask, &t->pending);
> -				recalc_sigpending_and_wake(t);
> 				t = next_thread(t);
> 			} while (t != current);
> +			recalc_sigpending();

There is no need for the +, just the -.  The calling thread is the one
where know there is certainly no perturbation of behavior due to leaving
TIF_SIGPENDING set rather than clearing it.  It's just going to exit the
syscall and deal with signal state properly on the way out either way.
Doing recalc_sigpending is an unnecessary optimization of the corner case.

> So at the end of the day, easier to test it inside dequeue_signal().

Before completely revamping the whole set of entrypoints to be saner all
around, yes.


Thanks,
Roland
