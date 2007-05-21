Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbXEUI5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbXEUI5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbXEUI5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:57:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbXEUI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:57:23 -0400
Date: Mon, 21 May 2007 10:57:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070521085703.GA18755@elte.hu>
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com> <20070521082926.GH19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521082926.GH19966@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> cfs should probably consider aggregate lag as opposed to aggregate 
> weighted load. Mainline's convergence to proper CPU bandwidth 
> distributions on SMP (e.g. N+1 tasks of equal nice on N cpus) is 
> incredibly slow and probably also fragile in the presence of arrivals 
> and departures partly because of this. [...]

hm, have you actually tested CFS before coming to this conclusion?

CFS is fair even on SMP. Consider for example the worst-case 
3-tasks-on-2-CPUs workload on a 2-CPU box:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2658 mingo     20   0  1580  248  200 R   67  0.0   0:56.30 loop
 2656 mingo     20   0  1580  252  200 R   66  0.0   0:55.55 loop
 2657 mingo     20   0  1576  248  200 R   66  0.0   0:55.24 loop

66% of CPU time for each task. The 'TIME+' column shows a 2% spread 
between the slowest and the fastest loop after just 1 minute of runtime 
(and the spread gets narrower with time). Mainline does a 50% / 50% / 
100% split:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3121 mingo     25   0  1584  252  204 R  100  0.0   0:13.11 loop
 3120 mingo     25   0  1584  256  204 R   50  0.0   0:06.68 loop
 3119 mingo     25   0  1584  252  204 R   50  0.0   0:06.64 loop

and i fixed that in CFS.

or consider a sleepy workload like massive_intr, 3-tasks-on-2-CPUs:

  europe:~> head -1 /proc/interrupts
             CPU0       CPU1

  europe:~> ./massive_intr 3 10
  002623  00000722
  002621  00000720
  002622  00000721

Or a 5-tasks-on-2-CPS workload:

  europe:~> ./massive_intr 5 50
  002649  00002519
  002653  00002492
  002651  00002478
  002652  00002510
  002650  00002478

that's around 1% of spread.

load-balancing is a performance vs. fairness tradeoff so we wont be able 
to make it precisely fair because that's hideously expensive on SMP 
(barring someone showing a working patch of course) - but in CFS i got 
quite close to having it very fair in practice.

> [...] Tong Li's DWRR repairs the deficit in mainline by synchronizing 
> epochs or otherwise bounding epoch dispersion. This doesn't directly 
> translate to cfs. In cfs cpu should probably try to figure out if its 
> aggregate lag (e.g. via minimax) is above or below average, and push 
> to or pull from the other half accordingly.

i'd first like to see a demonstration of a problem to solve, before 
thinking about more complex solutions ;-)

	Ingo
