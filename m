Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZCIBji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZCIBji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 21:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZCIBja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 21:39:30 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7960 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754146AbZCIBj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 21:39:29 -0400
X-BigFish: VPS-19(zz62a3L98dR936eQ3b5bkzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG7TWT-04-RYA-01
Date: Mon, 9 Mar 2009 02:39:03 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090309013902.GK10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090121185021.GA8852@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Mar 2009 01:39:03.0189 (UTC) FILETIME=[D3BF2C50:01C9A057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some points to mention here. This patch set actually introduces two
interfaces, a new user/kernel interface and an in-kernel api to access
performance counters. These are separate things and sometimes mixed
too much. There is a strong need for an in-kernel api. This is the
third implementation I am involved (oprofile, perfmon are the others)
and the things are always the same way. All these subsystems should be
merged to one in-kernel implemenation and share the same code. The
different user/kernel i/fs could then coexist and meet the users
different needs.

The implementation of the hardware counters is written from scratch
again. It is sometimes useful to drop old code, but there is the
danger of making errors twice. Implementing performance counters is
not trivial, especially buffer handling, SMP and cpu hotplug. For
oprofile and perfmon it took years to get stable code. We should
benefit from this. (The current x86 code in this patch series seems
not to work proper with SMP.) So we should look for a way to better
reuse and share code.

See also my comments below.

On 21.01.09 19:50:21, Ingo Molnar wrote:

[...]

> +static bool perf_counters_initialized __read_mostly;
> +
> +/*
> + * Number of (generic) HW counters:
> + */
> +static int nr_counters_generic __read_mostly;
> +static u64 perf_counter_mask __read_mostly;
> +static u64 counter_value_mask __read_mostly;
> +
> +static int nr_counters_fixed __read_mostly;
> +
> +struct cpu_hw_counters {
> +	struct perf_counter	*counters[X86_PMC_IDX_MAX];
> +	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +};
> +
> +/*
> + * Intel PerfMon v3. Used on Core2 and later.
> + */
> +static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
> +
> +static const int intel_perfmon_event_map[] =
> +{
> +  [PERF_COUNT_CPU_CYCLES]		= 0x003c,
> +  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
> +  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
> +  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
> +  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
> +  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
> +  [PERF_COUNT_BUS_CYCLES]		= 0x013c,
> +};

I would like to define _all_ the behaviour of the architecture and the
models in functions instead of parameters and lists. It is hard to
explain why, because it is more esthetics, but I believe, only nice
things work best. Let me try.

1) The list above seems to be random, there are lots of events and it
is hard to define, which event is really important. Surely these
events are important, but it is hard to draw a line here.

2) The list assumes/implies the events are available on all
architectures and cpus. This is probably not the case, and also, the
existence of an event must not be _important_ for a certain
architecture. But it has to be there even if it is of no interest.

3) Hard to extend. If an event is added here this could have impact to
all other architectures. Data structures are changing.

4) In the kernel the behaviour of a subsystem is offen implemented by
functions (e.g. struct device_driver). There are lots of ops structs
in the kernel and there are reasons for it.

5) ops structs are more dynamic. The data could be generated
dynamically and does not have to be static in some tables and
variables.

So, instead of making the list a public data structure, better pass
the type to an arch specific function, e.g.:

int arch_xxx_setup_event(int event_type);

If the type is not supported, an error could be returned. There is no
more impact. Even the binaries of the builds would be identically if
hw_event_types would be extended for a single different architecture.

The same applies also for counters and so on, better implement
functions.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

