Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZGCHFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZGCHFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZGCHFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:05:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZGCHFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:05:23 -0400
Date: Fri, 3 Jul 2009 09:04:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix
	scheduling-while-atomic bug)
Message-ID: <20090703070456.GD32687@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org> <20090701075332.GA17252@elte.hu> <1246439937.8492.18.camel@pc1117.cambridge.arm.com> <20090701093015.GA6862@elte.hu> <1246441592.8492.38.camel@pc1117.cambridge.arm.com> <20090701110438.GA15958@elte.hu> <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
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

> Hi Ingo,
> 
> On Wed, 2009-07-01 at 13:04 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > Since we are at locking, I just noticed this on my x86 laptop when
> > > running cat /sys/kernel/debug/kmemleak (I haven't got it on an ARM
> > > board):
> > > 
> > > ================================================
> > > [ BUG: lock held when returning to user space! ]
> > > ------------------------------------------------
> > > cat/3687 is leaving the kernel with locks still held!
> > > 1 lock held by cat/3687:
> > > #0:  (scan_mutex){+.+.+.}, at: [<c01e0c5c>] kmemleak_open+0x3c/0x70
> > > 
> > > kmemleak_open() acquires scan_mutex and unconditionally releases 
> > > it in kmemleak_release(). The mutex seems to be released as a 
> > > subsequent acquiring works fine.
> > > 
> > > Is this caused just because cat may have exited without closing 
> > > the file descriptor (which should be done automatically anyway)?
> > 
> > This lockdep warning has a 0% false positives track record so 
> > far: all previous cases it triggered showed some real (and 
> > fatal) bug in the underlying code.
> 
> In this particular case, there is no fatal problem as the mutex is 
> released shortly after this message.

Maybe - but holding locks in user-space is almost always bad.

What happens if user-space opens a second file descriptor before 
closing the first one? We either lock up (which is bad and fatal) or 
you already have some _other_ exclusion mechanism that prevents this 
case, which calls into question the need to hold this particular 
mutex in user-space to begin with.

I've yet to see a valid 'need to hold this kernel lock in 
user-space' case, and this does not seem to be such a case either.

	Ingo
