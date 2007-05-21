Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbXEUIGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbXEUIGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXEUIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:06:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbXEUIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:06:12 -0400
Date: Mon, 21 May 2007 10:05:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521080529.GA13858@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub> <20070521075824.GA11198@elte.hu> <20070521080351.GA13375@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20070521080351.GA13375@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> ah, you got the latency tracer from Thomas, as part of the -hrt patchset 
> - that makes it quite a bit easier to debug. Could you run the attached 
> trace-it-10sec utility:
> 
> 	trace-it-10sec > trace-to-ingo.txt

attached ...

	Ingo

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace-it-10sec.c"


/*
 * Copyright (C) 2005, Ingo Molnar <mingo@redhat.com>
 *
 * user-triggered tracing.
 *
 * The -rt kernel has a built-in kernel tracer, which will trace
 * all kernel function calls (and a couple of special events as well),
 * by using a build-time gcc feature that instruments all kernel
 * functions.
 * 
 * The tracer is highly automated for a number of latency tracing purposes,
 * but it can also be switched into 'user-triggered' mode, which is a
 * half-automatic tracing mode where userspace apps start and stop the
 * tracer. This file shows a dumb example how to turn user-triggered
 * tracing on, and how to start/stop tracing. Note that if you do
 * multiple start/stop sequences, the kernel will do a maximum search
 * over their latencies, and will keep the trace of the largest latency
 * in /proc/latency_trace. The maximums are also reported to the kernel
 * log. (but can also be read from /proc/sys/kernel/preempt_max_latency)
 *
 * For the tracer to be activated, turn on CONFIG_WAKEUP_TIMING and
 * CONFIG_LATENCY_TRACE in the .config, rebuild the kernel and boot
 * into it. Note that the tracer can have significant runtime overhead,
 * so you dont want to use it for performance testing :)
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <linux/unistd.h>

int main (int argc, char **argv)
{
	int ret;

	if (getuid() != 0) {
		fprintf(stderr, "needs to run as root.\n");
		exit(1);
	}
	ret = system("cat /proc/sys/kernel/mcount_enabled >/dev/null 2>/dev/null");
	if (ret) {
		fprintf(stderr, "CONFIG_LATENCY_TRACING not enabled?\n");
		exit(1);
	}
//	system("echo 0 > /proc/sys/kernel/trace_all_cpus");
	system("echo 1 > /proc/sys/kernel/trace_enabled");
//	system("echo 0 > /proc/sys/kernel/trace_freerunning");
	system("echo 0 > /proc/sys/kernel/trace_print_at_crash");
	system("echo 1 > /proc/sys/kernel/trace_user_triggered");
	system("echo 0 > /proc/sys/kernel/trace_verbose");
	system("echo 0 > /proc/sys/kernel/preempt_max_latency");
	system("echo 0 > /proc/sys/kernel/preempt_thresh");
//	system("[ -e /proc/sys/kernel/wakeup_timing ] && echo 1 > /proc/sys/kernel/wakeup_timing");
//	system("echo 1 > /proc/sys/kernel/mcount_enabled");

	prctl(0, 1); // start tracing
	sleep(10);
	prctl(0, 0); // stop tracing

	system("cat /proc/latency_trace");

	return 0;
}



--y0ulUmNC+osPPQO6--
