Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYIXPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYIXPUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYIXPUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:20:34 -0400
Received: from flusers.ccur.com ([12.192.68.2]:50612 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751954AbYIXPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:20:33 -0400
Date: Wed, 24 Sep 2008 11:19:33 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080924151933.GA17531@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080923155331.GA20380@tsunami.ccur.com> <20080923163530.GA656@tv-sign.ru> <20080924150541.GA119@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924150541.GA119@tv-sign.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:05:41AM -0400, Oleg Nesterov wrote:
> Joe says:
>> So it looks like the test is in error, not the kernel.
> 
> and I am happy to agree.
> I think sigaction/10-1.c should be fixed, please see the patch below.

A year or two ago I sent to Intel some OpenPosixTestSuite fixes, and they
were accepted.  Send it in (to the people listed in the comments at the
front of the .c file), hopefully they are still at Intel.


> Now, since SIGCHLD is a non-rt signal, the second SIGCHLD is lost,
> and wait_until_we_receive_CLD_STOPPED() hangs.
> 
> I did the test patch to be sure:
> 
>         --- 26-rc2/kernel/signal.c~     2008-09-20 20:37:52.000000000 +0400
>         +++ 26-rc2/kernel/signal.c      2008-09-24 18:43:34.000000000 +0400
>         @@ -808,7 +808,7 @@ static int send_signal(int sig, struct s
>                  * exactly one non-rt signal, so that we can get more
>                  * detailed information about the cause of the signal.
>                  */
>         -       if (legacy_queue(pending, sig))
>         +       if (sig != SIGCHLD && legacy_queue(pending, sig))
>                         return 0;
>                 /*
>                  * fast-pathed signals for kernel-internal things like SIGSTOP
> 
> and now your test-case doesn't hang.

Very interesting!  I am not sure this is Posix conformant, as Posix
seems to say that posting a SIGSTOP or SIGCHLD clears out all pending
SIGSTOPs or SIGCHLDs, so queueing the SIGCHLD might violate the standard.
Still it might be workable as it would be hard to see, from userspace, any
behavioral difference between queueing (possibly illegal) and synchronous
operation (which seems legal), both of which service all SIGCONTs and
SIGSTOPs without loss.

Joe
