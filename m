Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0CBKxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:53:30 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8588 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0CBKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:53:29 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYNI8R-01-5SM-02
X-M-MSG: 
Date: Tue, 2 Mar 2010 11:53:14 +0100
From: Robert Richter <robert.richter@amd.com>
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
Subject: Re: [PATCH] perf_events: add sampling period randomization support
Message-ID: <20100302105314.GF13205@erda.amd.com>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1267510029-19750-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Mar 2010 10:53:14.0762 (UTC) FILETIME=[8F1D0EA0:01CAB9F6]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.03.10 22:07:09, eranian@google.com wrote:
> This patch adds support for randomizing the sampling period.
> Randomization is very useful to mitigate the bias that exists
> with sampling. The random number generator does not need to
> be sophisticated. This patch uses the builtin random32()
> generator.
> 
> The user activates randomization by setting the perf_event_attr.random
> field to 1 and by passing a bitmask to control the range of variation
> above the base period. Period will vary from period to period & mask.
> Note that randomization is not available when a target interrupt rate
> (freq) is enabled.

Instead of providing a mask I would prefer to either use a bit width
parameter there the mask can be calculated from or to specify a range
the period may vary.

> 
> The last used period can be collected using the PERF_SAMPLE_PERIOD flag
> in sample_type.
> 
> The patch has been tested on X86. There is also code for PowerPC but
> I could not test it.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> --
>  arch/powerpc/kernel/perf_event.c       |    3 +++
>  arch/x86/kernel/cpu/perf_event.c       |    2 ++
>  arch/x86/kernel/cpu/perf_event_intel.c |    4 ++++

I agree with Peter, I also don't see the need to touch arch specific
code.

>  include/linux/perf_event.h             |    7 +++++--
>  kernel/perf_event.c                    |   24 ++++++++++++++++++++++++
>  5 files changed, 38 insertions(+), 2 deletions(-)
> 

[...]

> +void perf_randomize_event_period(struct perf_event *event)
> +{
> +	u64 new_seed;
> +	u64 mask = event->attr.random_mask;
> +
> +	event->hw.last_period = event->hw.sample_period;
> +
> +	new_seed = random32();
> +
> +	if (unlikely(mask >> 32))
> +		new_seed |= (u64)random32() << 32;
> +
> +	event->hw.sample_period = event->attr.sample_period + (new_seed & mask);

Only adding the random value will lead to longer sample periods on
average. To compensate this you could calculate something like:

	 event->hw.sample_period = event->attr.sample_period + (new_seed & mask) - (mask >> 1);

Or, the offset is already in sample_period.

Also a range check for sample_period is necessary to avoid over- or
underflows.

-Robert

> +}

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

