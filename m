Return-Path: <linux-kernel-owner+w=401wt.eu-S2993163AbXDSIBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993163AbXDSIBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993162AbXDSIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:01:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993163AbXDSIBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:01:43 -0400
Date: Thu, 19 Apr 2007 10:00:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419080053.GA4106@elte.hu>
References: <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu> <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org> <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com> <20070418214816.GA10902@elte.hu> <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > That's one reason why i dont think it's necessarily a good idea to 
> > group-schedule threads, we dont really want to do a per thread group 
> > percpu_alloc().
> 
> I still do not have clear how much overhead this will bring into the 
> table, but I think (like Linus was pointing out) the hierarchy should 
> look like:
> 
> Top (VCPU maybe?)
>     User
>         Process
>             Thread
> 
> The "run_queue" concept (and data) that now is bound to a CPU, need to be 
> replicated in:
> 
> ROOT <- VCPUs add themselves here
>     VCPU <- USERs add themselves here
>         USER <- PROCs add themselves here
>             PROC <- THREADs add themselves here
>                 THREAD (ultimate fine grained scheduling unit)
> 
> So ROOT, VCPU, USER and PROC will have their own "run_queue". Picking 
> up a new task would mean:
> 
> VCPU = ROOT->lookup();
> USER = VCPU->lookup();
> PROC = USER->lookup();
> THREAD = PROC->lookup();
> 
> Run-time statistics should propagate back the other way around.

yeah, but this looks quite bad from an overhead POV ... i think we can 
do alot simpler to solve X and kernel threads prioritization.

> > In fact for threads the _reverse_ problem exists, threaded apps tend 
> > to _strive_ for more performance - hence their desperation of using 
> > the threaded programming model to begin with ;) (just think of media 
> > playback apps which are typically multithreaded)
> 
> The same user nicing two different multi-threaded processes would 
> expect a predictable CPU distribution too. [...]

i disagree that the user 'would expect' this. Some users might. Others 
would say: 'my 10-thread rendering engine is more important than a 
1-thread job because it's using 10 threads for a reason'. And the CFS 
feedback so far strengthens this point: the default behavior of treating 
the thread as a single scheduling (and CPU time accounting) unit works 
pretty well on the desktop.

think about it in another, 'kernel policy' way as well: we'd like to 
_encourage_ more parallel user applications. Hurting them by accounting 
all threads together sends the exact opposite message.

> [...] Doing that efficently (the old per-cpu run-queue is pretty nice 
> from many POVs) is the real challenge.

yeah.

	Ingo
