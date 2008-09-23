Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYIWQ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYIWQ36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYIWQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:29:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46912 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYIWQ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:29:49 -0400
Date: Tue, 23 Sep 2008 20:35:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Joe Korty <joe.korty@ccur.com>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080923163530.GA656@tv-sign.ru>
References: <20080923155331.GA20380@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923155331.GA20380@tsunami.ccur.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry! I have to run avay right now, and I will be completely offline
tomorrow. I'll return on Thursday.

On 09/23, Joe Korty wrote:
>
> Since 2.6.25-git16, the Open POSIX Test Suite test sigaction/10-1 on
> occasion stalls out.  A ^C breaks the test out of the stall.
>
> To see the problem, one must run the test in a loop.  The stallout happens
> anywhere from 3 to approximately 60 iterations.  To make the test runtime
> more bearable, I've been using a custom version that is 8x faster than
> the original, s/sleep/usleep/g + new sleep constants.
>
> The test in essence does 10 SIGSTOPs and SIGCONTs, interleaved, with a
> short delay between each SIGSTOP and SIGCONT, but none (other than the
> small delay of a printf) between each SIGCONT and SIGSTOP:
>
>     for(i=0; i<10; i++) {
> 	printf("--> Sending SIGSTOP #%d\n", i);
> 	kill (pid, SIGSTOP);
> 	usleep(125000);
> 	printf("--> Sending SIGCONT #%d\n", i);
> 	kill (pid, SIGCONT);
> 	// usleep(125000); /* this is missing from the real 10-1 */
>     }
>
> When the above commented-out usleep is enabled, the stallout disappears.
> If instead of adding a usleep, the printf's are removed, the test stalls
> out immediately.

Could you clarify? Do you mean that the task hangs in sys_kill() ?

Better yet, to avoid a possible confusion, could you please send me
the (modified) source code to re-produce the stall ?

> Therefore the problem has something to do with a SIGSTOP
> being issued 'too soon' after the issuance of a SIGCONT.
>
> Bisection shows that the problem was introduced by
>
>     commit e442055193e4584218006e616c9bdce0c5e9ae5c
>     Author: Oleg Nesterov <oleg@tv-sign.ru>
>     Date:   Wed Apr 30 00:52:44 2008 -0700
>
> This commit adds code that solves serious race problems by deferring the
> actual processing of SIGSTOP and SIGCONT to a later time.  I suspect it
> is this deferring that is making SIGCONT sensitive to a SIGSTOP coming
> in too close on its heels.
>
> The following patch, not to be considered seriously,

Yes, the patch is not for production, but thanks a lot! I am sure it will
help to diagnose the problem.

Thanks Joe!

Oleg.

