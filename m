Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZGALEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZGALEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZGALEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:04:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZGALEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:04:44 -0400
Date: Wed, 1 Jul 2009 13:04:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
Message-ID: <20090701110438.GA15958@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org> <20090701075332.GA17252@elte.hu> <1246439937.8492.18.camel@pc1117.cambridge.arm.com> <20090701093015.GA6862@elte.hu> <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > > The minimal fix below removes scan_yield() and adds a 
> > > > cond_resched() to the outmost (safe) place of the scanning 
> > > > thread. This solves the regression.
> > > 
> > > With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> > > scanning but I don't see this as a real issue (task stacks 
> > > scanning probably takes longer anyway).
> > 
> > Yeah. I suspect one more cond_resched() could be added - i just 
> > didnt see an obvious place for it, given that scan_block() is being 
> > called with asymetric held-locks contexts.
> 
> Yes, scan_block shouldn't call cond_resched(). The code is cleaner if
> functions don't have too many side-effects. I can see about 1 sec of bss
> scanning on an ARM board but with processor at < 500MHz and slow memory
> system. On a standard x86 systems BSS scanning may not be noticeable
> (and I think PREEMPT enabling is quite common these days).
> 
> Since we are at locking, I just noticed this on my x86 laptop when
> running cat /sys/kernel/debug/kmemleak (I haven't got it on an ARM
> board):
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> ------------------------------------------------
> cat/3687 is leaving the kernel with locks still held!
> 1 lock held by cat/3687:
> #0:  (scan_mutex){+.+.+.}, at: [<c01e0c5c>] kmemleak_open+0x3c/0x70
> 
> kmemleak_open() acquires scan_mutex and unconditionally releases 
> it in kmemleak_release(). The mutex seems to be released as a 
> subsequent acquiring works fine.
> 
> Is this caused just because cat may have exited without closing 
> the file descriptor (which should be done automatically anyway)?

This lockdep warning has a 0% false positives track record so far: 
all previous cases it triggered showed some real (and fatal) bug in 
the underlying code.

The above one probably means scan_mutex is leaked out of a /proc 
syscall - that would be a bug in kmemleak.

	Ingo
