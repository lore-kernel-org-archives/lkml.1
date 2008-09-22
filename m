Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYIVJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYIVJoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYIVJoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:44:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYIVJoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:44:11 -0400
Date: Mon, 22 Sep 2008 11:43:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Patch 3/3] Tracing/ftrace: Replace none tracer by nop tracer
Message-ID: <20080922094358.GB17258@elte.hu>
References: <48D68F7E.5020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48D68F7E.5020609@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Replace "none" tracer by the recently created "nop" tracer. Both are 
> pretty similar except that nop accepts TRACE_PRINT or TRACE_SPECIAL 
> entries. And as a consequence, changing the size of the ring buffer 
> now requires that tracing has already been disabled.

btw., if people are interested in new tracers, it would be useful to 
have an initcall tracer which can capture boot delays and schedule 
events from bootup. -tip has the 'fastboot' feature topic which could 
make use of such a tracer.

Right now fastboot profiling works like this: it (abu-)uses the 
initcall_debug boot parameter to get such special printouts in 
init/main.c:

                printk("initcall %pF returned %d after %Ld msecs\n", fn,
                        result, (unsigned long long) delta.tv64 >> 20);

and relies on CONFIG_PRINTK_TIME to get event timestamps. Then, after 
bootup, scripts/bootgraph.pl can be used to draw a graph of bootup 
dependencies and timings.

the efficiency of this mechanism could be extended significantly via an 
ftrace/fastboot plugin: it would allow non-initcall delays to be traced, 
plus the _reason_ for the delays as well. Stackframe tracing could be 
enabled by default (see 'stacktrace' / TRACE_ITER_STACKTRACE / 
__trace_stack() in kernel/tracing/trace.c - not to be confused with the 
stack-footprint tracer ftrace/stacktrace), and context-switch events 
could be / should be traced as well.

the ideal workflow would be like this: developers optimizing fastboot 
details would enable a single kernel option: CONFIG_TRACE_BOOT, and that 
would be an 'all in one' switch. Tracing would occur by default (no 
extra boot parameters), and /debug/tracing/trace would have output 
suitable for scripts/bootgraph.pl parsing.

(at least) one architectural detail that needs to be solved here is the 
fact that ftrace is initialized via an initcall right now. It should 
probably be initialized via an early-initcall instead.

Hm?

	Ingo
