Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbXFMWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbXFMWH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXFMWHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:07:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbXFMWHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:07:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
 internal errnos
In-Reply-To: Linus Torvalds's message of  Wednesday, 6 June 2007 08:35:27 -0700 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070613220654.7F1C84D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 15:06:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> HOWEVER: I'm still a bit worried about the fact that we have about ~180 
> calls to "recalc_sigpending()" around the kernel, and I'm not AT ALL sure 
> that they are all supposed to possibly clear the TIF_SIGPENDING flag. 

Most of those calls are in arch or compat code's sigreturn, sigsuspend, et
al functions, which are reasonably considered within the "private" realm of
the core signals code.  Those aside, I count fewer than 40 other uses.
So maybe there is some hope of figuring this out and cleaning it up without
enormous amounts of effort.  But those uses are not necessarily all trivial
to understand, which is why I was conservative.

allow_signal and disallow_signal do not touch anything that affects
recalc_sigpending, and by rights should not call it.  But they used to
diddle the blocked set, and when we changed them we were afraid that some
of their callers might have subtle dependencies on recalc_sigpending having
been called.  Off hand that seems unduly paranoid, but you never know.

The call in copy_process might be superfluous, but perhaps it can be
necessary if the thread was in syscall entry stop (TASK_TRACED) and so got
skipped for setting TIF_SIGPENDING (wants_signal) for a process-shared
signal, then entered fork.  

The freezer stuff just makes me want to go hide in the corner.  (It's
enough work already repressing the knowledge of what's happening when I
resume the laptop from suspend and my shells all report "Stopped" again
for the jobs already in job control stop.)

I can't tell off hand what's going on in sunrpc.  I think it's only
dealing with its own kernel threads.  Same goes for fs/lockd/clntproc.c.

nbd looks like some honest-to-goodness questionable diddling with user threads.
dlm too.  autofs4 too, but wronger.  9p, ncpfs, saa5249 all seem
dubious to me, but it's pretty clear they do expect recalc_sigpending to
clear TIF_SIGPENDING and that's a primary thing they need done.

handle_vm86_trap must be something ancient that should have just been
using send_sigtrap.

arch/ia64/kernel/fsys.S seems to have recalc_sigpending open coded in
assembly, so heaven help them.

So from that quick survey, it does seem that recalc_sigpending itself
called directly is not often used for the kernel-thread situations.  As
to current correctness, I'd say most of these calls do indeed depend on
it to clear TIF_SIGPENDING.  Nearly all of its uses are at least somewhat
questionable and to me indicate that there should be some cleaner entry
points into the signals code that all these places can use to accomplish
what they need without having their fingers in the subtle internals of
signals data structures.


signalfd is a whole other can of worms, and I have not really looked into
it but would approach the whole area with caution.


Thanks,
Roland
