Return-Path: <linux-kernel-owner+w=401wt.eu-S934023AbXFFESo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbXFFESo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXFFESf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:18:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:46817 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXFFESe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:18:34 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1181102921.2788.57.camel@entropy>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
	 <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
	 <1181088936.2788.10.camel@entropy>
	 <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
	 <1181091523.2788.28.camel@entropy>
	 <1181098204.31677.158.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com>
	 <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
	 <1181102921.2788.57.camel@entropy>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 14:18:25 +1000
Message-Id: <1181103505.31677.176.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> a) Process-global signals can be read by any thread (inside or outside
> of the process receiving the signal).
> 
> Rationale:
> 	This should always work, so there's no reason to limit it.

I agree, with an appropriate fix to recalc_sigpending_tsk() to only
clear TIF_SIGPENDING if tsk == current (the patch Linus posted
basically) _along_ with a fix to avoid the notifier thingy if stealing
from another task, that would work.

> b) Thread-specific signals can only be read by their target thread.
> 
> Rationale:
> 	This behavior is required by POSIX, and if an application is using
> pthread_kill()/tkill()/tgkill()/etc. to specifically direct a signal, it
> damn well better get to where the app wants it to go.

I agree there too. I don't see the point of the 'feature' of allowing
those to be stolen and can only lead into all sort of new headaches
nobody needs.

> c) Synchronous signals ("Naturally" generated SIGILL, SIGFPE, SIGSEGV,
> SIGBUS, and SIGTRAP. Did I miss any?) are not delivered via signalfd()
> at all. (And by "naturally" generated, I mean signals that would have
> the SI_KERNEL flag set.)

Heh, well, as you say later, it can't be delivered anyway... I don't
think we need to do anything explicit to prevent them from being read()
in signalfd, it will just not happen.

> Rationale: 
> 	These are a subset of thread-specific signals, so they can only be read
> from a signalfd by their target thread.
> 
> However, there's no way for the target thread to get the signal because
> it is either:
> 
> a) not blocked in a syscall waiting for signal delivery and thus further
> execution beyond the instruction causing the signal is impossible
>  OR
> b) it is blocked in a syscall waiting for signal delivery and the error
> is caused by the signal delivery mechanism itself (i.e. a bad pointer
> passed to read/select/poll/epoll_wait/etc.) and thus the signal can't be
> delivered

Ben.


