Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXGWJyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXGWJyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXGWJyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:54:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbXGWJyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:54:08 -0400
Date: Mon, 23 Jul 2007 11:53:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
Message-ID: <20070723095357.GA886@elte.hu>
References: <469600F7.3060603@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469600F7.3060603@free.fr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John Sigler <linux.kernel@free.fr> wrote:

> Here's a /proc/latency_trace dump. What is there to understand?
> 
> # cat /proc/latency_trace
> preemption latency trace v1.1.5 on 2.6.20.7-rt8
> --------------------------------------------------------------------
>  latency: 26 us, #2/2, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1)
>     -----------------
>     | task: softirq-timer/0-4 (uid:0 nice:0 policy:1 rt_prio:50)
>     -----------------
> 
>                  _------=> CPU#
>                 / _-----=> irqs-off
>                | / _----=> need-resched
>                || / _---=> hardirq/softirq
>                ||| / _--=> preempt-depth
>                |||| /
>                |||||     delay
>    cmd     pid ||||| time  |   caller
>       \   /    |||||   \   |   /
>    <...>-4     0D..1   26us : trace_stop_sched_switched 
> (__sched_text_start)

could you try:

 http://redhat.com/~mingo/latency-tracing-patches/trace-it.c

and run it like this:

 ./trace-it 1 > trace.txt

does it produce lots of trace entries? If not then 
CONFIG_FUNCTION_TRACING is not enabled. Once you see lots of output in 
the file, the tracer is up and running and you can start tracing the 
latency in your app.

your above wakeup-tracing output suggests that your app is probably not 
delayed by scheduling latencies, but by some other, higher-level 
latencies.

To track it down, use the method that trace-it.c uses to start/stop 
tracing, i.e. put the prctl(0,1); / prctl(0,0); calls into your app to 
start/stop tracing and the kernel will do the rest once you've set 
/proc/sys/kernel/preempt_max_latency back to 0: /proc/latency_trace will 
always contain the longest latency that your app triggered, of the 
critical path you programmed into it.

also check the cyclictest source of how to do app-driven latency 
tracing. (And please post any latency traces to this list, we might be 
able to pinpoint the source of the latencies.)

	Ingo
