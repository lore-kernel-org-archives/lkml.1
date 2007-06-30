Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbXF3VKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbXF3VKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXF3VKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:10:41 -0400
Received: from 1wt.eu ([62.212.114.60]:3226 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbXF3VKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:10:41 -0400
Date: Sat, 30 Jun 2007 23:06:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070630210649.GA13186@1wt.eu>
References: <20070622220202.GA16872@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622220202.GA16872@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I've accidentally discovered a problem with -v18.

Some time ago, I wrote a small program to prevent my laptop from entering
low-power mode, and noticed that after upgrading my laptop's kernel from
2.4.20.9+cfs-v6 to 2.4.20.14+cfs-v18, it completely freezes if I run this
program.

The program is trivial, it just sets its prio to nice +20 and forks a busy
loop. I've added the ability to stop the loop after a user-definable number
of iterations, and I can confirm that it unfreezes when the loop ends. I'm
not even root when I run it.

Everything freezes, including the frame-buffer. It's not 100% reproducible, I
would say 90% only. Sometimes it requires a few seconds before freezing. It
*seems* to me that running another task in parallel (such as vmstat) increases
its chances to freeze. It seems like nicing to +19 does not cause any trouble.

I've tried it on my dual athlon, and with 1 process I see occasional pauses of
1 or 2 seconds, and with 2 processes, I see fairly larger pauses.

Here's the trivial program. Probably you'll find an obvious bug.

Regards,
Willy

---

/*
 * cfs-freeze.c
 * Fork a busy loop running with idle prio. This often results
 * in complete freezes with CFS-v18.
 *
 * $ gcc -O2 -s -o cfs-freeze cfs-freeze.c
 * $ ./cfs-freeze
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sched.h>
#include <sys/time.h>
#include <sys/resource.h>


int main(int argc, char **argv) {
	struct sched_param sch;
	long long i;

	if (argc > 1)
		i = atoll(argv[1]);

	if (i <= 0)
		i = 4 * 1000 * 1000 * 1000ULL;

	sch.sched_priority = 0;
	sched_setscheduler(0, SCHED_OTHER, &sch);
	setpriority(PRIO_PROCESS, 0, 20);
	if (fork() == 0)
		while (i--);
	return 0;
}

---

