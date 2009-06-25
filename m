Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZFYJeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZFYJeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZFYJeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:34:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbZFYJeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:34:06 -0400
Date: Thu, 25 Jun 2009 11:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090625093346.GD23547@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245876060.3038.7.camel@localhost.localdomain>
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

> After :
> 
>  Performance counter stats for 'ls -lR /usr/include/':
> 
>       283542921  dL1-loads             (scaled from 23.28%)
>         1848314  dL1-load-misses       (scaled from 22.94%)
>          168963  dL1-stores            (scaled from 22.94%)
>          739249  dL1-prefetches        (scaled from 22.45%)
>          501021  dL1-prefetch-misses   (scaled from 22.25%)
>       275037259  iL1-loads             (scaled from 23.40%)
>         6030825  iL1-load-misses       (scaled from 23.26%)
>          166760  iL1-prefetches        (scaled from 24.31%)
>         7224781  LLC-loads             (scaled from 24.76%)
>          821097  LLC-load-misses       (scaled from 24.07%)
>         7070549  LLC-stores            (scaled from 24.45%)
>       251586242  dTLB-loads            (scaled from 24.65%)
>         5127780  dTLB-load-misses      (scaled from 23.99%)
>       276782014  iTLB-loads            (scaled from 23.77%)
>           16787  iTLB-load-misses      (scaled from 23.72%)
>       123408502  branches              (scaled from 22.88%)
>         5843856  branch-misses         (scaled from 22.87%)
> 
>     1.417039891  seconds time elapsed.

ok, this output looks pretty good and intuitive to me (please 
integrate suggestions from Thomas), but the patch itself needs 
another iteration i think:

>  static char *hw_cache[][MAX_ALIASES] = {
> -	{ "L1-data",		"l1-d",		"l1d"			},
> -	{ "L1-instruction",	"l1-i",		"l1i"			},
> -	{ "L2",			"l2"					},
> -	{ "Data-TLB",		"dtlb",		"d-tlb"			},
> -	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
> -	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
> + { "dL1",	"L1-d",		"l1d",					},
> + { "iL1",	"L1-i",		"l1i",					},
> + { "LLC",	"L2",							},
> + { "dTLB",	"d-tlb",						},
> + { "iTLB",	"i-tlb",						},
> + { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
>  };
>  
>  static char *hw_cache_op[][MAX_ALIASES] = {
> -	{ "Load",		"read"					},
> -	{ "Store",		"write"					},
> -	{ "Prefetch",		"speculative-read", "speculative-load"	},
> + { "load",	"loads",	"read",					},
> + { "store",	"stores",	"write",				},
> + { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
>  };
>  
>  static char *hw_cache_result[][MAX_ALIASES] = {
> -	{ "Reference",		"ops",		"access"		},
> -	{ "Miss"							},
> + { "refs",	"ops",		"access",				},
> + { "misses",	"miss",							},
>  };
>  
>  char *event_name(int counter)
> @@ -123,10 +123,25 @@ char *event_name(int counter)
>  		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
>  			return "unknown-ext-hardware-cache-result";
>  
> -		sprintf(name, "%s-Cache-%s-%ses",
> -			hw_cache[cache_type][0],
> -			hw_cache_op[cache_op][0],
> -			hw_cache_result[cache_result][0]);
> +		/*
> +		 * special handling for branches
> +		 * we are only interested in BPU, READ
> +		 */ 
> +		if (cache_type == PERF_COUNT_HW_CACHE_BPU && cache_op)
> +			return "unknown";
> +		else if (cache_type == PERF_COUNT_HW_CACHE_BPU) {
> +			if (cache_result)
> +				sprintf(name, "%s-%s", hw_cache[cache_type][0],
> +					hw_cache_result[cache_result][0]);
> +			else
> +				sprintf(name, "%s", hw_cache[cache_type][1]);
> +		} else if (cache_result)
> +			sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
> +				hw_cache_op[cache_op][0],
> +				hw_cache_result[cache_result][0]);
> +		else
> +			sprintf(name, "%s-%s", hw_cache[cache_type][0],
> +				hw_cache_op[cache_op][1]);
>  
>  		return name;

Firstly, please run your patches through checkpatch - it will report 
a real problem in your patch.

Secondly, this special-casing of the BPU isnt very clean in this 
form. The BPU isnt 'special' because it deals with instructions - 
it's special because it's for all practical purposes read-only.

So we should extend our table with a read-only flag, and the BPU and 
the iTLB should be listed as read-only. (iTLB-store-miss is another 
thing that makes no sense) For those we should skip the 'store' 
bits.

That way the generic code does not have this special-case wart 
dependent on PERF_COUNT_HW_CACHE_BPU.

	Ingo
