Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbXLaKVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbXLaKVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 05:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXLaKVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 05:21:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXLaKVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 05:21:30 -0500
Date: Mon, 31 Dec 2007 11:20:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20071231102045.GB30380@elte.hu>
References: <20071231060911.GB6461@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231060911.GB6461@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* K. Prasad <prasad@linux.vnet.ibm.com> wrote:

> @@ -486,12 +309,12 @@ void rcu_unboost_readers(void)
>  
>  	spin_lock_irqsave(&rcu_boost_wake_lock, flags);
>  
> -	rcu_trace_boost_try_unboost_readers(RCU_BOOST_ME);
> +	trace_mark(try_unboost_readers, "%u", smp_processor_id());

this isnt directed at you or your patch, it's more directed at Mathieu, 
but looking at this actual markers patch submitted to me, i'm still 
fundamentally worried about the whole marker approach.

Firstly, why on earth does a full format string have to be passed in for 
something as simple as a CPU id? This way we basically codify it forever 
that tracing _has_ to be expensive when enabled. The latency-tracer 
(which i'd love to convert to markers, if only markers were capable 
enough) has shown it that tracing _can_ be used to capture performance 
data without disturbing the measured system, even at hundreds of 
thousands context switches a second per CPU.

Secondly, the inlined overhead of trace_mark() is still WAY too large:

                if (unlikely(__mark_##name.state)) {                    \
                        preempt_disable();                              \
                        (*__mark_##name.call)                           \
                                (&__mark_##name, call_data,             \
                                format, ## args);                       \
                        preempt_enable();                               \
                }                                                       \

Whatever became of the obvious suggestion that i outlined years ago, to 
have a _single_ trace call instruction and to _patch out_ the damn 
marker calls by default? No .state flag checking inlined. No 
preempt_disable()/enable() pair. Patching static tracepoints OUT of the 
kernel, only leaving a ~5-byte NOP sequence behind them (and some 
minimal disturbance to the variables the tracepoint accesses). We've got 
all the alternatives.h code patching infrastructure available for such 
purposes. Why are we 2 years down the line and _STILL_ arguing about 
this?

Thirdly, the patch selects CONFIG_MARKERS:

>  config RCU_TRACE
> -       bool "Enable tracing for RCU - currently stats in debugfs"
> +       tristate "Enable tracing for RCU - currently stats in debugfs"
>         select DEBUG_FS
> -       default y
> +       select MARKERS

Which adds overhead (inlined checks for markers) all around the kernel, 
even if all markers are deactivated! Imagine a thousand of them and the 
kernel blows up measurably.

Sadly, this whole trace_mark() API seems to have gotten much worse since 
i last saw it. It's sub-par when it's turned on and it's sub-par when 
it's turned off. It gets us the worst of both worlds.

If it continues like this then i'd much rather see people add printks as 
tracing, because there you _know_ that it's high-overhead and people 
wont start arguing about trace compatibility either, etc.

	Ingo
