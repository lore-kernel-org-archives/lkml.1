Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZAaRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZAaRYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZAaRYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:24:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:51758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZAaRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:23:59 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>
In-Reply-To: <1233421901.4787.27.camel@laptop>
References: <20090130230936.GA7549@elte.hu>
	 <1233421901.4787.27.camel@laptop>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 18:23:52 +0100
Message-Id: <1233422632.4787.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 18:11 +0100, Peter Zijlstra wrote:
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 52bbf1c..5686bb5 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
> >       /*
> >        * Underflow?
> >        */
> > -     if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
> > +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
> >               return;
> >       /*
> >        * Is the spinlock portion underflowing?

Since the commit msg of 01e3eb8 says:

    kernel_locked() is not a valid test in IRQ context (we update the
    BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
    so we cannot put it into the generic preempt debugging checks which
    can run in IRQ contexts too.

Another possibility would be writing it like:

  if (DEBUG_LOCKS_WARN_ON(val > preempt_count() -
			  (in_interrupt() ? 0 : !!kernel_locked())))

Which might just work because we're in sub_preempt_count, before we
actually do the subtraction, so in_interrupt() will still be true.



