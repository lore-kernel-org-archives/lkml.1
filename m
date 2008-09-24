Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbYIXPuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbYIXPuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYIXPuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:50:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42229 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbYIXPuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:50:21 -0400
Date: Wed, 24 Sep 2008 19:56:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Joe Korty <joe.korty@ccur.com>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080924155611.GA5334@tv-sign.ru>
References: <20080923155331.GA20380@tsunami.ccur.com> <20080923163530.GA656@tv-sign.ru> <20080924150541.GA119@tv-sign.ru> <20080924151933.GA17531@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924151933.GA17531@tsunami.ccur.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Joe Korty wrote:
>
> On Wed, Sep 24, 2008 at 11:05:41AM -0400, Oleg Nesterov wrote:
> > Joe says:
> >> So it looks like the test is in error, not the kernel.
> >
> > and I am happy to agree.
> > I think sigaction/10-1.c should be fixed, please see the patch below.
>
> A year or two ago I sent to Intel some OpenPosixTestSuite fixes, and they
> were accepted.  Send it in (to the people listed in the comments at the
> front of the .c file), hopefully they are still at Intel.

OK, thanks, will do.

> > I did the test patch to be sure:
> >
> >         --- 26-rc2/kernel/signal.c~     2008-09-20 20:37:52.000000000 +0400
> >         +++ 26-rc2/kernel/signal.c      2008-09-24 18:43:34.000000000 +0400
> >         @@ -808,7 +808,7 @@ static int send_signal(int sig, struct s
> >                  * exactly one non-rt signal, so that we can get more
> >                  * detailed information about the cause of the signal.
> >                  */
> >         -       if (legacy_queue(pending, sig))
> >         +       if (sig != SIGCHLD && legacy_queue(pending, sig))
> >                         return 0;
> >                 /*
> >                  * fast-pathed signals for kernel-internal things like SIGSTOP
> >
> > and now your test-case doesn't hang.
>
> Very interesting!  I am not sure this is Posix conformant,

No, no, the patch is of course wrong, I did it only to check my
understanding.

> as Posix
> seems to say that posting a SIGSTOP or SIGCHLD clears out all pending
> SIGSTOPs or SIGCHLDs,

Hmm. Are you sure?

Anyway, this is not what Linux does. If a non-rt signal is pending, the
next signal with the same number is silently ignored. SIGCHLD too.

> Still it might be workable

Confused. Do you agree the kernel is not buggy?

To clarify, none of SIGCONTs/SIGSTOPs is lost. But the test-case assumes
that it must always receive SIGCHLD + CLD_STOPPED. This is not true because
SIGCHLD is not queueable, and we have another "stream" of SIGCHLDs which
carry CLD_CONTINUED.

For example, the "opposite" code

	kill(SIGSTOP);
	kill(SIGCONT);
	wait_for_CLD_CONTINUED();

was always wrong, but

	kill(SIGCONT);
	kill(SIGSTOP);
	wait_for_CLD_STOPPED();

happened to work before that commit. But please note that it is wrong
anyway. For example, if we have another sub-thread, we can miss
CLD_STOPPED even without the commit which changed the timing.

Oleg.

