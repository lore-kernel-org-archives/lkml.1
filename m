Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0BOEak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:30:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:33969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754512Ab0BOEai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:30:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19l9vN+BlNlxocasju2JNdw7/URiA2BUcKoOHQyA+
	qFgHWA2zEGdYko
Subject: Re: [Bug #15044] Much higher wakeups for "<kernel IPI> :
 Rescheduling interrupts" since 2.6.32.2
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Roman Mamedov <roman@rm.pp.ru>
In-Reply-To: <4un6Gst5rKB.A.zP.CkIeLB@chimera>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
	 <4un6Gst5rKB.A.zP.CkIeLB@chimera>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 05:30:33 +0100
Message-Id: <1266208233.6418.85.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 00:38 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15044
> Subject		: Much higher wakeups for "<kernel IPI> : Rescheduling interrupts" since 2.6.32.2
> Submitter	: Roman Mamedov <roman@rm.pp.ru>
> Date		: 2010-01-11 02:58 (35 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/a1f84a3ab8e002159498814eaa7e48c33752b04b

I don't know that this should be carried as a regression.

Yes, the code in question increases cross cpu wakeups, but that's the
entire point.  If there is any overlap in execution larger than the cost
of running a scheduler on another core, that time can be converted to
throughput.

Tip AF_UNIX lmbench numbers show that throughput gain being realized,
TCP numbers below that (x) show what can be had for apps which do a lot
of what that microbenchmark does, given a tiny enabler patchlet.

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge      2.6.31.9-smp 2853 2923 1132 2829.3 4761.9 1235.0 1234.4 4472 1683.
marge      2.6.31.9-smp 2839 2921 1141 2846.5 4779.8 1242.5 1235.9 4455 1684.
marge      2.6.31.9-smp 2838 2935 751. 2838.5 4820.0 1243.6 1235.0 4472 1684.
marge    2.6.33-tip-smp 3057 5166 859. 2760.2 4827.8 1481.1 1466.1 4499 1811.
marge    2.6.33-tip-smp 1796 5165 1257 2748.6 4817.4 1481.1 1464.8 4487 1806.
marge    2.6.33-tip-smp 3055 5175 1262 2763.4 4812.4 1483.9 1462.7 4477 1810.
marge   2.6.33-tip-smpx 3063 5140 2940 2811.1 4740.0 1235.8 1237.0 4433 1673.
marge   2.6.33-tip-smpx 3065 5205 2945 2836.3 4794.4 1243.6 1233.7 4293 1686.
marge   2.6.33-tip-smpx 3058 5181 2940 2785.4 4700.2 1243.9 1234.5 4415 1682.

(1. tip memory numbers are phase-of-moon anomaly.. irrelevant here)
(2. pipe numbers are only possible with pipe buffer increase patch in
tip.  Often, pipes are truly synchronous, so waking cross CPU is small
loss.  In tip, it's a win because of optimistic mutex spin.. context
switch cost is converted to throughput.  That throughput gain also
cannot be had if you don't do the cross cpu wakeup to get the ball
rolling.  The code in question is acting as enabler for spintex.)

So yeah, the code in question _will_ cause more cross CPU wakeups, and
it _may_ cost power.  It may _save_ power by getting the job done more
efficiently.  Dunno.

Regression?  Depends on what you're measuring.

	-Mike

