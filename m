Return-Path: <linux-kernel-owner+w=401wt.eu-S1031181AbXDZMHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031181AbXDZMHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031185AbXDZMHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:07:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031181AbXDZMHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:07:52 -0400
Date: Thu, 26 Apr 2007 14:07:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Message-ID: <20070426120723.GA4092@elte.hu>
References: <200704261312.25571.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704261312.25571.mgd@technosis.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Gerdau <mgd@technosis.de> wrote:

> Hi list,
> 
> find below a test comparing
>     2.6.21-rc7 (mainline)
>     2.6.21-rc7-sd046
>     2.6.21-rc7-cfs-v6-rc2(*) (X @ nice 0)
>     2.6.21-rc7-cfs-v6-rc2(*) (X @ nice -10)
> running on a dualcore x86_64.

thanks for the testing!

as a summary: i think your numbers demonstrate it nicely that the 
shorter 'timeslice length' that both CFS and SD utilizes does not have a 
measurable negative impact on your workload. To measure the total impact 
of 'timeslicing' you might want to try the exact same workload with a 
much higher 'timeslice length' of say 400 msecs, via:

    echo 400000000 > /proc/sys/kernel/sched_granularity_ns  # on CFS
    echo 400 > /proc/sys/kernel/rr_interval                 # on SD

your existing numbers are a bit hard to analyze because the 3 workloads 
were started at the same time and they overlapped differently and 
utilized the system differently.

i think the primary number that makes sense to look at (which is perhaps 
the least sensitive to the 'overlap effect') is the 'combined user times 
of all 3 workloads' (in order of performance):

> 2.6.21-rc7:                              20589.423    100.00%
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    20613.845     99.88%
> 2.6.21-rc7-sd046:                        20617.945     99.86%
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      20743.564     99.25%

to me this gives the impression that it's all "within noise". In 
particular the two CFS results suggest that there's at least a ~100 
seconds noise in these results, because the renicing of X should have no 
impact on the result (the workloads are pure number-crunchers, and all 
use up the CPUs 100%, correct?), and even if it has an impact, renicing 
X to nice 0 should _speed up_ the result - not slow it down a bit like 
the numbers suggest.

another (perhaps less reliable) number is the total wall-clock runtime 
of all 3 jobs. Provided i did not make any mistakes in my calculations, 
here are the results:

> 2.6.21-rc7-sd046:                        10512.611 seconds
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    10605.946 seconds
> 2.6.21-rc7:                              10650.535 seconds
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      10788.125 seconds

(the numbers are lower than the first numbers because this is a 2 CPU 
system)

both SD and CFS-nice-10 was faster than mainline, but i'd say this too 
is noise - especially because this result highly depends on the way the 
workloads overlap in general, which seems to be different for SD.

system time is interesting too:

> 2.6.21-rc7:                              35.379
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    40.399
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      44.239
> 2.6.21-rc7-sd046:                        45.515

here too the two CFS results seem to suggest that there's at least 
around 5 seconds of noise. So i'd not necessarily call it systematic 
that vanilla had the lowest system time and SD had the highest.

combined system+user time:

> 2.6.21-rc7:                              20624.802
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      20658.084
> 2.6.21-rc7-sd046:                        20663.460
> 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    20783.963

perhaps it might make more sense to run the workloads serialized, to 
have better comparabality of the individual workloads. (on a real system 
you'd naturally want to overlap these workloads to utilize the CPUs, so 
the numbers you did are very relevant too.)
 
The vmstat suggested there is occasional idle time in the system - is 
the workload IO-bound (or memory bound) in those cases?

	Ingo
