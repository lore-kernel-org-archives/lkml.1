Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbYEVVwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbYEVVwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYEVVwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:52:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbYEVVwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:52:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
In-Reply-To: Oleg Nesterov's message of  Thursday, 22 May 2008 15:12:11 +0400 <20080522111211.GA117@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru>
	<20080521022046.1501F26FA1C@magilla.localdomain>
	<20080521115414.GA147@tv-sign.ru>
	<20080521184245.5BABF26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
	<20080521193348.64E8C26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org>
	<20080521230135.BF65A26FA24@magilla.localdomain>
	<20080522111211.GA117@tv-sign.ru>
Emacs: because you deserve a brk today.
Message-Id: <20080522215057.DCDF326FA24@magilla.localdomain>
Date: Thu, 22 May 2008 14:50:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is not enough. Again, we remove and free sigqueue but don't discard
> the pending signal. (and we must take into account other rt signals with
> the same si_signo if we want to discard the signal).

Right, of course.  The sigset_t collecting while checking the queue is the
only way to do it.  Note that you need to make it:

	if (q->info.si_code == SI_TIMER && sig >= SIGRTMIN)

because a SI_TIMER could be using a legacy_queue signal number.  In that
case there might have been a second non-timer signal pending with that
number too, which must not get cleared.  Since the only siginfo_t still
recorded is the SI_TIMER one, better to leave it queued than turn it into
an infoless signal, seems to me.


Thanks,
Roland
