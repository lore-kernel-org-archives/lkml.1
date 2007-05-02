Return-Path: <linux-kernel-owner+w=401wt.eu-S2993061AbXEBMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993061AbXEBMNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993076AbXEBMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:13:31 -0400
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:58722 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993061AbXEBMNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:13:30 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Date: Wed, 2 May 2007 22:11:20 +1000
User-Agent: KMail/1.9.5
Cc: Michael Gerdau <mgd@technosis.de>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704301005.33884.mgd@technosis.de>
In-Reply-To: <200704301005.33884.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022211.20769.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 18:05, Michael Gerdau wrote:
> i list,
>
> meanwhile I've redone my numbercrunching tests with the following kernels:
>     2.6.21.1 (mainline)
>     2.6.21-sd046
>     2.6.21-cfs-v6
> running on a dualcore x86_64.
> [I will run the same test with 2.6.21.1-cfs-v7 over the next days,
> likely tonight]

Thanks for testing.

> The tests consist of 3 tasks (named LTMM, LTMB and LTBM). The only
> I/O they do is during init and for logging the results, the rest
> is just floating point math.
>
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
> I'm giving user time as provided by the "time" cmd followed by wallclock
> time (all values in seconds).
>
>                 LTMM
>                 j1              j3              j3big
> 2.6.21-cfs-v6    5655.07/ 5682   5437.84/ 5531   5434.04/ 8072
> 2.6.21-sd-046    5556.44/ 5583   5446.86/ 8037   5407.50/ 8274
> 2.6.21.1         5417.62/ 5439   5422.37/ 7132   na     /na
>
>                 LTMB
>                 j1              j3              j3big
> 2.6.21-cfs-v6    7729.81/ 7755   7470.10/10244   7449.16/10186
> 2.6.21-sd-046    7611.00/ 7626   7573.16/10109   7458.10/10316
> 2.6.21.1         7438.31/ 7461   7620.72/11087   na     /na
>
>                 LTBM
>                 j1              j3              j3big
> 2.6.21-cfs-v6    7720.70/ 7746   7567.09/10362   7464.17/10335
> 2.6.21-sd-046    7431.06/ 7452   7539.83/10600   7474.20/10222
> 2.6.21.1         7452.80/ 7481   7484.19/ 9570   na     /na
>
>                 LTMM+LTMB+LTBM
>                 j1              j3              j3big
> 2.6.21-cfs-v6	21105.58/21183  20475.03/26137  20347.37/28593
> 2.6.21-sd-046	20598.50/20661  20559.85/28746  20339.80/28812
> 2.6.21.1	20308.73/20381  20527.28/27789  na      /na
>
>
> User time apparently is subject to some variance. I'm particularly
> surprised by the wallclock time of scenario j1 and j3 for case LTMM with
> 2.6.21-cfs-v6. I'm not sure what to make of this, i.e. whether I had
> happening something else on my machine during j1 of LTMM -- that's always
> been the first test I ran and it might be that there were still some other
> jobs running after the initial boot.
>
> Assuming scenario j1 does constitute the "true" time each task requires and
> also assuming each scheduler makes maximum use of the available CPUs (the
> tests involve very little I/O) one could compute the expected wallclock
> time. However since I suspect the j1 figures of LTMM to be somewhat "dirty"
> I'll refrain from it.
>
> However from these figures it seems as if sd does provide for the fairest
> (as in equal share for all) scheduling among the 3 schedulers tested.

Looks good, thanks. Ingo's been hard at work since then and has v8 out by now. 
SD has not changed so you wouldn't need to do the whole lot of tests on SD 
again unless you don't trust some of the results.

> Best,
> Michael

-- 
-ck
