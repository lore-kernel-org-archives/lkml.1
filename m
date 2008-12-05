Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYLEAeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYLEAeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYLEAdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:33:49 -0500
Received: from ozlabs.org ([203.10.76.45]:51435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYLEAdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:33:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18744.30427.440468.829807@cargo.ozlabs.ibm.com>
Date: Fri, 5 Dec 2008 11:33:31 +1100
From: Paul Mackerras <paulus@samba.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] performance counters: documentation
In-Reply-To: <20081204230228.557959174@linutronix.de>
References: <20081204225345.654705757@linutronix.de>
	<20081204230228.557959174@linutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:

> + enum hw_event_types {
> +	PERF_COUNT_CYCLES,
> +	PERF_COUNT_INSTRUCTIONS,
> +	PERF_COUNT_CACHE_REFERENCES,
> +	PERF_COUNT_CACHE_MISSES,
> +	PERF_COUNT_BRANCH_INSTRUCTIONS,
> +	PERF_COUNT_BRANCH_MISSES,
> + };
> +
> +These are standardized types of events that work uniformly on all CPUs
> +that implements Performance Counters support under Linux. If a CPU is
> +not able to count branch-misses, then the system call will return
> +-EINVAL.
> +
> +[ Note: more hw_event_types are supported as well, but they are CPU
> +  specific and are enumerated via /sys on a per CPU basis. Raw hw event
> +  types can be passed in as negative numbers. For example, to count
> +  "External bus cycles while bus lock signal asserted" events on Intel
> +  Core CPUs, pass in a -0x4064 event type value. ]

This is going to be a huge problem, at least on powerpc, because it
means that the kernel will have to know which events can be counted on
which counters and what values need to be put in the control registers
to select them.

The thing is that not all the counters count the same set of events,
or use the same select values when they can count the same events.
For example, on a MPC7450 cpu, you can count L2 cache misses in PMC5
or PMC6.  If you're counting them on PMC5 you need to put 19 into the
PCM5 event selector field in the MMCR1 register.  But if you're
counting them on PMC6 then you need to put 29 in the PMC6 event
selector field in MMCR1.

Since we don't get to say which counter to use in perf_counter_open,
we would have to pass an abstracted "L2 cache miss" event code and
have that map to 19 or 29 depending on which PMC register we get to
use.  But that means that the kernel then has to have the entire table
of countable events for every supported CPU model - something that
perfmon3 manages to keep out of the kernel.

The situation will be even worse with POWER5 and POWER6, where the
event selection logic is very complex, with multiple layers of
multiplexers.  I really really don't want the kernel to have to know
about all that.

Basically, what it boils down to is that treating performance monitor
counters as independent units is just not feasible, at least on
powerpc.  We really need to be able to deal with the full set of
counters as one thing.

Paul.
