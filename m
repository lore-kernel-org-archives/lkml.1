Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbXH2EUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbXH2EUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXH2EU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:20:27 -0400
Received: from [212.12.190.144] ([212.12.190.144]:32927 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbXH2EU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:20:26 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CFS review
Date: Wed, 29 Aug 2007 07:19:24 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org> <20070828164507.GA2969@elte.hu>
In-Reply-To: <20070828164507.GA2969@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708290719.24422.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, 28 Aug 2007, Al Boldi wrote:
> > > I like your analysis, but how do you explain that these stalls
> > > vanish when __update_curr is disabled?
> >
> > It's entirely possible that what happens is that the X scheduling is
> > just a slightly unstable system - which effectively would turn a small
> > scheduling difference into a *huge* visible difference.
>
> i think it's because disabling __update_curr() in essence removes the
> ability of scheduler to preempt tasks - that hack in essence results in
> a non-scheduler. Hence the gears + X pair of tasks becomes a synchronous
> pair of tasks in essence - and thus gears cannot "overload" X.

I have narrowed it down a bit to add_wait_runtime.

Patch 2.6.22.5-v20.4 like this:

346-     * the two values are equal)
347-     * [Note: delta_mine - delta_exec is negative]:
348-     */
349://  add_wait_runtime(cfs_rq, curr, delta_mine - delta_exec);
350-}
351-
352-static void update_curr(struct cfs_rq *cfs_rq)

When disabling add_wait_runtime the stalls are gone.  With this change the 
scheduler is still usable, but it does not constitute a fix.

Now, even with this hack, uneven nice-levels between X and gears causes a 
return of the stalls, so make sure both X and gears run on the same 
nice-level when testing.

Again, the whole point of this workload is to expose scheduler glitches 
regardless of whether X is broken or not, and my hunch is that this problem 
looks suspiciously like an ia-boosting bug.  What's important to note is 
that by adjusting the scheduler we can effect a correction in behaviour, and 
as such should yield this problem as fixable.

It's probably a good idea to look further into add_wait_runtime.


Thanks!

--
Al

