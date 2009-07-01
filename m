Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZGALjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZGALjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZGALjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:39:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZGALje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:39:34 -0400
Date: Wed, 1 Jul 2009 13:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6 -tip] perf stat: treat same behaviour for all
	CYCLES and CLOCKS
Message-ID: <20090701113915.GG15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246440977.3403.7.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> For normalization also added SW_CPU_CLOCK and HW_BUS_CYCLES
> 
> For nsec_printout also added SW_CPU_CLOCK
> 
> Added helper functions to check counter unit as cycles and instructions
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/builtin-stat.c |   49 +++++++++++++++++++++++++++++++-------------
>  1 files changed, 34 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 6bf2b80..af61c29 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -144,6 +144,29 @@ static inline int nsec_counter(int counter)
>  }
>  
>  /*
> + * Does the counter have cycles as a unit?
> + */
> +static inline int cycle_counter(int counter)
> +{
> +	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter) ||
> +	    MATCH_EVENT(HARDWARE, HW_BUS_CYCLES, counter))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * Does the counter have instructions as a unit?
> + */
> +static inline int instruction_counter(int counter)
> +{
> +	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter))
> +		return 1;
> +
> +	return 0;
> +}

This should be done a bit differently. Each event should have a 
'unit type' index in its descriptor table, which links back to 
_another_ event, specifying its unit.

For example:

   (PERF_COUNT_HW_INSTRUCTIONS,     -1                        , "instructions")
   (PERF_COUNT_HW_CACHE_REFERENCES, PERF_COUNT_HW_INSTRUCTIONS)
   (PERF_COUNT_HW_CACHE_MISSES,     PERF_COUNT_HW_INSTRUCTIONS)

'-1' signals an event that has itself as a unit, and a string field 
gives us the pretty-print form of the unit.

The same could be done for other types of events as well, such as 
software events:

   (PERF_COUNT_SW_CPU_CLOCK,        -1                        , "nsecs")
   (PERF_COUNT_SW_TASK_CLOCK,       PERF_COUNT_SW_CPU_CLOCK   )

This way normalization can be fully automated: say if we print out 
PERF_COUNT_HW_CACHE_MISSES, we see that it is in units of 
PERF_COUNT_HW_INSTRUCTIONS so we can print out that unit and can 
normalize it to that metric.

the 'IPC' (Instructions Per Cycle) field is special, and if you are 
interested in this then i think it should be implemented as a 
special 'compound' event: it is represented by the division of two 
events.

( If it's implemented like that then IPC will be printed in a
  separate line, not as part of the instructions line - but that's 
  OK. )

Other 'compound' events might be possible too: for example a new 
cache-hits field could be is cache-refs minus cache-misses.

I.e. the simplest model for 'compound' events would be:

  X = A / B
  X = A - B
  X = A + B

We could list them in the event table, with a flag that specifies 
which arithmetic operation connects two 'atomic' counters.

Then the adding of a new compound event would only be the matter of 
adding one more line to the event table.

Can you see any problems with this approach?

	Ingo
