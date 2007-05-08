Return-Path: <linux-kernel-owner+w=401wt.eu-S934556AbXEHHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbXEHHvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbXEHHvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:51:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:60157 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934484AbXEHHvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:51:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+PPvMxLw+P9l60wpXykLyP8P7FJqQ020rf2QkTIq
	DaqX66Btm8mSoR
Subject: Re: [patch] CFS scheduler, -v10
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
In-Reply-To: <20070507163342.GA3502@elte.hu>
References: <20070507163342.GA3502@elte.hu>
Content-Type: text/plain
Date: Tue, 08 May 2007 09:51:38 +0200
Message-Id: <1178610698.7558.48.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 18:33 +0200, Ingo Molnar wrote:
>  - complete and finetune the 'smooth load calculation' mechanism
>    (Mike Galbraith) 

Houston, we have alien artifacts.

Artifact 1:

root@Homer: taskset -c 1 ./thud 5
starting 5 children
running...

root@Homer: taskset -c 1 ./chew
pid 7551, prio   0, interval of 99984800 nsec
pid 7551, prio   0, out for    7 ms, ran for 1690 ms, load  99%
pid 7551, prio   0, out for    2 ms, ran for 1794 ms, load  99%
pid 7551, prio   0, out for    4 ms, ran for 9665 ms, load  99%
pid 7551, prio   0, out for  775 ms, ran for  379 ms, load  32% <== hurt pain ouch!
pid 7551, prio   0, out for   32 ms, ran for    6 ms, load  17%
pid 7551, prio   0, out for   32 ms, ran for    4 ms, load  13%
pid 7551, prio   0, out for   32 ms, ran for    4 ms, load  13%
pid 7551, prio   0, out for   32 ms, ran for    4 ms, load  13%

When thud starts, chew takes a size 14EEE latency hit if bits 1, 2 and 3
are set in sysctl_sched_load_smoothing.  Good for burst load, rotten for
interactivity if that burst load ain't X.  Start a thud 5 without the
taskset, and you'll feel the lurch.

Artifact 2:

If both bits 1 and 2 are set, and bit 3 is _not_ set, chew's out drops
to ~6ms and run drops to < 1ms.  Excessive context switching.

Computing delta_fair with smoothed load in update_curr() fixes some
things, but still breaks others.  The cost/benefit ratio isn't adding up
very favorably.  Tinkering.

Values 0x7 and 0xf should be avoided the like plague if your test load
includes bursty multiple hogs-from-hell.  Values 0x3 and 0xb are merely
context switch happy.

	-Mike

