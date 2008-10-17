Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYJQAK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYJQAK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYJQAKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:10:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYJQAKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:10:14 -0400
Date: Thu, 16 Oct 2008 17:08:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <20081016234657.837704867@polymtl.ca>
Message-ID: <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Mathieu Desnoyers wrote:
>
> +static inline cycles_t ltt_async_tsc_read(void)

(a) this shouldn't be inline

> +	rdtsc_barrier();
> +	new_tsc = get_cycles();
> +	rdtsc_barrier();
> +	do {
> +		last_tsc = ltt_last_tsc;
> +		if (new_tsc < last_tsc)
> +			new_tsc = last_tsc + LTT_MIN_PROBE_DURATION;
> +		/*
> +		 * If cmpxchg fails with a value higher than the new_tsc, don't
> +		 * retry : the value has been incremented and the events
> +		 * happened almost at the same time.
> +		 * We must retry if cmpxchg fails with a lower value :
> +		 * it means that we are the CPU with highest frequency and
> +		 * therefore MUST update the value.
> +		 */
> +	} while (cmpxchg64(&ltt_last_tsc, last_tsc, new_tsc) < new_tsc);

(b) This is really quite expensive.

Why do things like this? Make the timestamps be per-cpu. If you do things 
like the above, then just getting the timestamp means that every single 
trace event will cause a cacheline bounce, and if you do that, you might 
as well just not have per-cpu tracing at all.

It really boils down to two cases:

 - you do per-CPU traces

   If so, you need to ONLY EVER touch per-cpu data when tracing, and the 
   above is a fundamental BUG. Dirtying shared cachelines makes the whole 
   per-cpu thing pointless.

 - you do global traces

   Sure, then the above works, but why bother? You'll get the ordering 
   from the global trace, you might as well do time stamps with local 
   counts.

So in neither case does it make any sense to try to do that global 
ltt_last_tsc.

Perhaps more importantly - if the TSC really are out of whack, that just 
means that now all your timestamps are worthless, because the value you 
calculate ends up having NOTHING to do with the timestamp. So you cannot 
even use it to see how long something took, because it may be that you're 
running on the CPU that runs behind, and all you ever see is the value of 
LTT_MIN_PROBE_DURATION.

			Linus
