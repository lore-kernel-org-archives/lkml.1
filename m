Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0BCN4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:56:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:46071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab0BCN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:56:23 -0500
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
In-Reply-To: <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 14:56:01 +0100
Message-ID: <1265205361.24455.533.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 14:22 +0100, Stephane Eranian wrote:
> In general, there are some problems with the PEBS buffer when
> used in system-wide mode. If the depth is > 1, then you have a
> problem attributing samples to pid,tid.
> 
> Looks like this patch hardcodes the depth and threshold of the buffer.
> I believe you need to add some flexibility in there.

Sure you can, just drain the buffers on context switch. (You'll see that
placing x86_pmu.drain_pebs() calls is one of the missing pieces).

> You are currently only extracting IP. You need a way to extract the rest
> of the recorded state. There are some useful measurements you can do
> with it. I believe something like PERF_SAMPLE_REGS would work.
> Part of the pt_regs are already exported by signals (sigcontext).

Right, hence my suggestion to add that :-)

> It should be noted that providing PERF_SAMPLE_REGS in non-PEBS
> situations is also a requirement. But it needs to be clear this is the
> interrupted state and not the at-overflow state.

Sure.

> I do not believe substituting PEBS whenever you detect it is available AND
> event supports it is a good idea. PEBS is not more precise than regular
> sampling, in fact, it is statistically of poorer quality. This is due to the way
> it works and it cannot be mitigated by randomization (at least with depth > 1).

Right, which is why I already mentioned intending to use depth == 1 for
things like the auto-freq (and possible future randomization).

> The only improvement that PEBS provides is that you get an IP and the
> machine state at retirement of an instruction that caused the event to
> increment. Thus, the IP points to the next dynamic instruction. The instruction
> is not the one that cause the P-th occurence of the event, if you set the
> period to P. It is at P+N, where N cannot be predicted and varies depending
> on the event and executed code. This introduces some bias in the samples.

I'm not sure I follow, it records the next event after overflow, doesn't
that make it P+1? 

It doesn't matter how many instructions are between the P-th and P+1th
event, you're counting events.

One thing that is not quite clear to me is the influence of PEBS Trap,
IA32_PERF_CAPABILITIES[6], that says to record after (trap like) when
set, and before (fault like) when cleared, but then it goes on saying
the IP is always the instruction after.

If it means the register state before or after the instruction, then I
don't know why they had to mess up the IP like they do :/

> Given the behavior of PEBS, it would not be possible to correlate samples
> obtained from two events with only one of them supporting PEBS. For instance,
> if you sample on INST_RETIRED and UNHALTED_CORE_CYCLES. You
> would get a PEBS profile for INST_RETIRED and a regular profile for CYCLES.
> Given the skid differences, you would not be able to make fair comparisons.

OK, good point.


