Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbXEXMz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbXEXMz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbXEXMzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:55:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbXEXMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:55:16 -0400
Date: Thu, 24 May 2007 14:54:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524125453.GA7554@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> On some strange workload involving strace and fuse I get ocasional 
> long periods (10-100s) of total unresponsiveness, not even SysRq-* 
> working.  Then the machine continues as normal.  Nothing in dmesg, 
> absolutely no indication about what is happening.

> Any ideas?  Possibly something ACPI related?

how reproducable are these lockups - could you possibly trace it? If yes 
then please apply:

  http://www.tglx.de/private/tglx/ht-debug/tracer.diff

and run the attached trace-it-1sec.c thing in a loop:

  echo 1 > /proc/sys/kernel/mcount_enabled

  while true; do
     ./trace-it-1sec > trace-`date`.txt
  done

and wait for the lockup. Once it happens, please upload the trace*.txt 
file that contains the lockup, i guess we'll be able to tell you more 
about the nature of the lockup. (Perhaps increase the sleep(1) to 
sleep(5) to capture longer periods and to increase the odds that you 
catch the lockup while the utility is tracing.)

	Ingo

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace-it-1sec.c"


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
	system("echo 1 > /proc/sys/kernel/trace_enabled");
//	system("echo 0 > /proc/sys/kernel/trace_freerunning");
	system("echo 0 > /proc/sys/kernel/trace_print_at_crash");
	system("echo 1 > /proc/sys/kernel/trace_user_triggered");
	system("echo 0 > /proc/sys/kernel/trace_verbose");
	system("echo 0 > /proc/sys/kernel/preempt_max_latency");
	system("echo 0 > /proc/sys/kernel/preempt_thresh");
	system("[ -e /proc/sys/kernel/wakeup_timing ] && echo 1 > /proc/sys/kernel/wakeup_timing");
//	system("echo 1 > /proc/sys/kernel/mcount_enabled");

	prctl(0, 1); // start tracing
	sleep(1);
	prctl(0, 0); // stop tracing

	system("cat /proc/latency_trace");

	return 0;
}



--HlL+5n6rz5pIUxbD--
