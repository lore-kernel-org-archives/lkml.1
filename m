Return-Path: <linux-kernel-owner+w=401wt.eu-S1031228AbXECM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031228AbXECM3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031222AbXECM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:29:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031228AbXECM3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:29:30 -0400
Date: Thu, 3 May 2007 14:28:51 +0200
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
Subject: Re: [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Message-ID: <20070503122851.GA32222@elte.hu>
References: <200704301005.33884.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704301005.33884.mgd@technosis.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Gerdau <mgd@technosis.de> wrote:

> There are 3 scenarios:
>     j1 - all 3 tasks run sequentially
> 	 /proc/sys/kernel/sched_granularity_ns=4000000
> 	 /proc/sys/kernel/rr_interval=16
>     j3 - all 3 tasks run in parallel
> 	 /proc/sys/kernel/sched_granularity_ns=4000000
> 	 /proc/sys/kernel/rr_interval=16
>     j3big - all 3 tasks run in parallel with timeslice extended
>             by 2 magnitudes (not run for mainline)
>             /proc/sys/kernel/sched_granularity_ns=400000000
>             /proc/sys/kernel/rr_interval=400
> 
> All 3 tasks are run while the system does nothing else except for
> the "normal" (KDE) daemons. The system had not been used for
> interactive work during the tests.
> 
> I'm giving user time as provided by the "time" cmd followed by wallclock time
> (all values in seconds).
> 
>                 LTMM
>                 j1              j3              j3big
> 2.6.21-cfs-v6    5655.07/ 5682   5437.84/ 5531   5434.04/ 8072
>                 LTMB
> 2.6.21-cfs-v6    7729.81/ 7755   7470.10/10244   7449.16/10186
>                 LTBM
> 2.6.21-cfs-v6    7720.70/ 7746   7567.09/10362   7464.17/10335
>                 LTMM+LTMB+LTBM
> 2.6.21-cfs-v6	21105.58/21183  20475.03/26137  20347.37/28593

> User time apparently is subject to some variance. I'm particularly 
> surprised by the wallclock time of scenario j1 and j3 for case LTMM 
> with 2.6.21-cfs-v6. I'm not sure what to make of this, i.e. whether I 
> had happening something else on my machine during j1 of LTMM -- that's 
> always been the first test I ran and it might be that there were still 
> some other jobs running after the initial boot.

thanks for the testing!

regarding the fairness of the different schedulers, please note the 
different runtimes for each component of the workload:

     LTMM:   5655.07/ 5682
     LTMB:   7729.81/ 7755
     LTBM:   7720.70/ 7746

this means that a fair scheduler would _not_ be the one that finishes 
them first on wall-clock time (!). A fair scheduler would run each of 
them at 33% capacity until the fastest one (LTMM) reaches ~5650 seconds 
runtime and finishes, and _then_ the remaining ~2050 seconds of runtime 
would be done at 50%/50% capacity between the remaining two jobs. I.e. 
the fair wall-clock results should be around:

    LTMM:  ~8500 seconds
    LTMB: ~10600 seconds 
    LTBM: ~10600 seconds

(but the IO portion of the workloads and other scheduling effects could 
easily shift these numbers by a few minutes.)

regarding the results: it seems the wallclock portion of LTMM/j3 is too 
small - even though the 3 tasks ran in parallel, in the CFS test LTMM 
finished just as fast as if it were running alone, right? That does not 
seem to be logical and indeed suggests some sort of testing artifact.

That makes it hard to judge which scheduler achieved the above 'ideal 
fair distribution' of the workloads better - for some of the results it 
was SD, for some it was CFS - but the missing LTMM/j3 number makes it 
hard to decide it conclusively. They are certainly both close enough and 
the noise of the results seems quite high.

	Ingo
