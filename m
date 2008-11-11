Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYKKJni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYKKJni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYKKJna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:43:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbYKKJn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:43:29 -0500
Date: Tue, 11 Nov 2008 10:43:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Message-ID: <20081111094312.GA16496@elte.hu>
References: <49191C31.1050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49191C31.1050402@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This patchset adds the ability for ftrace to trace the function even 
> on call time and on return time. So we can now measure the time of 
> execution of the most part of the functions inside the kernel with 
> ftrace.
> 
> The first patch bring the low level tools to add the support of 
> return tracing on X86-32. It is totally separated from the 
> traditional implementation of ftrace and doesn't support dynamic 
> ftrace at this time.
> 
> The second patch adds a tracer based on the ring-buffer which 
> measure the time of execution of the functions inside the kernel.

okay, i've created tip/tracing/function-return-tracer topic so that we 
can start testing this for real and do can start iterating it via 
smaller changes. I've also integrated it into tip/master, it's looking 
good so far.

i did a couple of cleanups straight away:

 1) i did a FTRACE_RETURN => FUNCTION_RET_TRACER rename, to move it in
    line with the function tracer

 2) i cleaned up the arch/x86/Kconfig impact:

      f1c4be5: tracing, x86: clean up FUNCTION_RET_TRACER Kconfig

the return-tracer builds and boots, and works fabulously:

 # cd /sys/debug/tracing/

 # cat available_tracers 
 return function sched_switch nop

 # echo return > current_tracer
 
 clocksource_read+0xd/0xf -> acpi_pm_read (1547 ns)
 getnstimeofday+0x3e/0xc8 -> clocksource_read (1951 ns)
 ktime_get_ts+0x25/0x49 -> getnstimeofday (2354 ns)
 ktime_get_ts+0x45/0x49 -> set_normalized_timespec (120 ns)

Small quirk, it does not seem possible to switch from ftrace to 
ftrace-ret:

 # echo ftrace > current_tracer 
 # echo return > current_tracer
 bash: echo: write error: Invalid argument

i have to go via the "nop" tracer for this to work. Steve: switching 
between tracer plugins should be seemless.

Question: have you thought about extending the return-tracer to 
dyn-function-tracer?

That's where it will really shine: the dftrace workflow is to 
typically enable a low number of functions - and there the 
return-tracing overhead does not show up nearly as much as in the 
static-function-tracing workflow.

Another suggestion: i think the "return" plugin name is confusing to 
users (it confused me when i first saw it listed in 
available_tracers).

So lets use "function_full" and "function" tracing perhaps? The "full" 
tracer is what traces both entry and exit points, and establishes full 
function-call timings/costs. The "function" tracer is more lightweight 
and traces function entry events.

	Ingo
