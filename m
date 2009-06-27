Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZF0GoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZF0GoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 02:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZF0GoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 02:44:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZF0GoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 02:44:12 -0400
Date: Sat, 27 Jun 2009 08:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090627064404.GA19368@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090627060432.GB16200@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Besides, you compare perfcounters to perfmon (which you seem to be 
> a contributor of), while in reality perfmon has much, much worse 
> (and unfixable, because designed-in) measurement overhead.
> 
> So why are you criticising perfcounters for a 5000 cycles 
> measurement overhead while perfmon has huge, _hundreds of 
> millions_ of cycles measurement overhead (per second) for various 
> realistic workloads? [ In fact in one of the scheduler-tests 
> perfmon has a whopping measurement overhead of _nine billion_ 
> cycles, it increased total runtime of the workload from 3.3 
> seconds to 6.6 seconds. (!) ]

Here are the more detailed perfmon/pfmon measurement overhead 
numbers.

Test system is a "Intel Core2 E6800 @ 2.93GHz", 1 GB of RAM, default 
Fedora install.

I've measured two workloads:

    hackbench.c         # messaging server benchmark
    test-1m-pipes.c     # does 1 million pipe ops, similar to lat_pipe

v2.6.28+perfmon patches (v3, full):

    ./hackbench 10
    0.496400985  seconds time elapsed   ( +-   1.699% )

    pfmon --follow-fork--aggregate-results ./hackbench 10
    0.580812999  seconds time elapsed   ( +-   2.233% )

I.e. this workload runs 17% slower under pfmon, the measurement 
overhead is about 1.45 billion cycles.
 
Furthermore, when running a 'pipe latency benchmark', an app that 
does one million pipe reads and writes between two tasks (source 
code attached below), i measured the following perfmon/pfmon 
overhead:

    ./pipe-test-1m
    3.344280347  seconds time elapsed   ( +-   0.361% )

    pfmon --follow-fork --aggregate-results ./pipe-test-1m
    6.508737983  seconds time elapsed   ( +-   0.243% )

That's an about 94% measurement overhead, or about 9.2 _billion_ 
cycles overhead on this test-system.

These perfmon/pfmon overhead figures are consistently reproducible, 
and they happen on other test-systems as well, and with other 
workloads as well. Basically for any app that involves task creation 
or context-switching, perfmon adds considerable runtime overhead - 
well beyond the overhead of perfcounters.

	Ingo

-----------------{ pipe-test-1m.c }-------------------->

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <linux/unistd.h>

#define LOOPS 1000000

int main (void)
{
	unsigned long long t0, t1;
	int pipe_1[2], pipe_2[2];
	int m = 0, i;

	pipe(pipe_1);
	pipe(pipe_2);

	if (!fork()) {
		for (i = 0; i < LOOPS; i++) {
			read(pipe_1[0], &m, sizeof(int));
			write(pipe_2[1], &m, sizeof(int));
		}
	} else {
		for (i = 0; i < LOOPS; i++) {
			write(pipe_1[1], &m, sizeof(int));
			read(pipe_2[0], &m, sizeof(int));
		}
	}

	return 0;
}
