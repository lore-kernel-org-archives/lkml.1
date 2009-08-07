Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZHGL3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZHGL3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbZHGL3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:29:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbZHGL3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:29:39 -0400
Date: Fri, 7 Aug 2009 13:29:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090807112931.GA31401@elte.hu>
References: <20090804111412.GA20942@elte.hu> <20090804113555.GA28198@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com> <1249633282.32113.613.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com> <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com> <20090807112634.GC30014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807112634.GC30014@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> btw., the number of samples seems to be varying too widely:
> 
> titan:~> for ((i=0;i<10;i++)); do perf record -f -e branches:u -c 1 true 2>/dev/null; perf report | head -1; done
> # Samples: 28784
> # Samples: 24063
> # Samples: 22788
> # Samples: 30449
> # Samples: 15335
> # Samples: 30557
> # Samples: 24010
> # Samples: 23866
> # Samples: 24877
> # Samples: 24330
> 
> compared to the branch-stat itself:
> 
> titan:~> perf stat -v --repeat 10 -e branches:u true
> [ perf stat: executing run #1 ... ]
> [ perf stat: executing run #2 ... ]
> [ perf stat: executing run #3 ... ]
> [ perf stat: executing run #4 ... ]
> [ perf stat: executing run #5 ... ]
> [ perf stat: executing run #6 ... ]
> [ perf stat: executing run #7 ... ]
> [ perf stat: executing run #8 ... ]
> [ perf stat: executing run #9 ... ]
> [ perf stat: executing run #10 ... ]
> 
>  Performance counter stats for 'true' (10 runs):
> 
>           23851  branches                   ( +-   0.000% )
> 
>     0.000639653  seconds time elapsed   ( +-   2.474% )
> 
> do we lose records in the recording?

i doubt it's lost records. Even with SCHED_FIFO sampling and with a 
huge, 512 MB mmap ring-buffer we get a BTS sample count variation in 
the +- 10% range:

titan:/home/mingo> for ((i=0;i<10;i++)); do perf record -r 1 -m 
131072 -f -e branches:u -c 1 true 2>/dev/null; perf report | head 
-1; done
# Samples: 24860
# Samples: 24177
# Samples: 26165
# Samples: 25682
# Samples: 29175
# Samples: 23136
# Samples: 27102
# Samples: 29888
# Samples: 25524
# Samples: 24266

(and these are all just user-mode executions)

	Ingo
