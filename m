Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXIAHMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXIAHMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 03:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXIAHMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 03:12:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXIAHMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 03:12:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: SIGNAL_STOP_DEQUEUED
In-Reply-To: Oleg Nesterov's message of  Tuesday, 28 August 2007 13:13:18 +0400 <20070828091318.GA307@tv-sign.ru>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20070901071226.6C42E4D04CC@magilla.localdomain>
Date: Sat,  1 Sep 2007 00:12:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. do_wait(WCONTINUED) can miss SIGNAL_STOP_CONTINUED task if the task
> dequeues another sig_kernel_stop() signal. I thought this is harmless, but
> it turns out I misunderstood the needed semantics.
> 
> Thanks for your explanation.
> 
> This is easy to fix, but we have to split SIGNAL_STOP_CONTINUED into 2 flags,
> one for do_wait(), another to indicate that do_signal_stop() should abort.

SIGNAL_STOP_DEQUEUED is that second flag (its lack says to abort the stop).

> However, is it all correct currently ? Consider 2 threads, T1 and T2,
> SIGTTIN is SIG_DFL, SIGTTOU has a handler.
> 
> 	T1 does get_signal_to_deliver(), dequeus SIGTTIN, unlocks ->siglock.
> 
> 	SIGCONT comes in, nothing to do yet, just clear SIGNAL_STOP_DEQUEUED.
> 
> 	SIGTTOU is sent, T2 dequeues it and sets SIGNAL_STOP_DEQUEUED again.
> 	It has a handler, we shouldn't stop, but
> 
> 	T1 continues, takes ->siglock, and calls do_signal_stop().

Yes, I think you are right that this could happen.  It is indeed wrong that
it's possible to stop with SIGTTIN when the SIGCONT was posted second.

> What do you think about something like the patch below? It moves the setting of
> SIGNAL_STOP_DEQUEUED from dequeue_signal() to get_signal_to_deliver(), and the
> flag is set only if the sig_kernel_stop() signal doesn't have a handler.

I don't recall why this went into dequeue_signal in the first place.  It's
possible there was a specific reason at the time, but I can't find one now.
Probably it just seemed natural at the time to set the flag very close the
actual dequeuing just so it's simple to be sure what the invariant is.


Thanks,
Roland
