Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbYEVWTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbYEVWTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYEVWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:19:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52409 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbYEVWS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:18:59 -0400
Date: Fri, 23 May 2008 01:18:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080522211809.GA451@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru> <20080521022046.1501F26FA1C@magilla.localdomain> <20080521115414.GA147@tv-sign.ru> <20080521184245.5BABF26FA24@magilla.localdomain> <alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org> <20080521193348.64E8C26FA24@magilla.localdomain> <alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org> <20080521230135.BF65A26FA24@magilla.localdomain> <20080522111211.GA117@tv-sign.ru> <20080522215057.DCDF326FA24@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522215057.DCDF326FA24@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22, Roland McGrath wrote:
>
> > This is not enough. Again, we remove and free sigqueue but don't discard
> > the pending signal. (and we must take into account other rt signals with
> > the same si_signo if we want to discard the signal).
> 
> Right, of course.  The sigset_t collecting while checking the queue is the
> only way to do it.  Note that you need to make it:
> 
> 	if (q->info.si_code == SI_TIMER && sig >= SIGRTMIN)
> 
> because a SI_TIMER could be using a legacy_queue signal number.

Argh ;)

I hoped you will not notice this. Because this is a separate problem
which needs a separate discussion.

Please note that send_sigqueue() does not check if legacy_queue signal
is already pending. The recent changes in signal.c carefully preserve
this peculiarity. This is the question I was going to ask 1000 times
but forgot all the time.

So. Let's suppose that (say) SIGHUP is pending, and the posix timer
sends SIGHUP too. In that case the new SIGHUP is added, and if the
previous one was infoless the new one "hides" it: collect_signal()
won't see 2 distinct signals, it will find only 1 signal and clear
the bit in sigpending->signal.

So I think we shouldn't check "sig >= SIGRTMIN", but perhaps send_signal()
should be fixed? Anyway, I believe this is a separate problem.

Oleg.

