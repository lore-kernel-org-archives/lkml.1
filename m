Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXGYMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXGYMES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbXGYMEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:04:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXGYMEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:04:06 -0400
Date: Wed, 25 Jul 2007 14:03:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tong Li <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070725120358.GA30755@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725110159.GA15076@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patch extends CFS to achieve better fairness for SMPs. For 
> > example, with 10 tasks (same priority) on 8 CPUs, it enables each task 
> > to receive equal CPU time (80%). [...]
> 
> hm, CFS should already offer reasonable long-term SMP fairness. It 
> certainly works on a dual-core box, i just started 3 tasks of the same 
> priority on 2 CPUs, and on vanilla 2.6.23-rc1 the distribution is 
> this:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  7084 mingo     20   0  1576  248  196 R   67  0.0   0:50.13 loop
>  7083 mingo     20   0  1576  244  196 R   66  0.0   0:48.86 loop
>  7085 mingo     20   0  1576  244  196 R   66  0.0   0:49.45 loop
> 
> so each task gets a perfect 66% of CPU time.
> 
> prior CFS, we indeed did a 50%/50%/100% split - so for example on 
> v2.6.22:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2256 mingo     25   0  1580  248  196 R  100  0.0   1:03.19 loop
>  2255 mingo     25   0  1580  248  196 R   50  0.0   0:31.79 loop
>  2257 mingo     25   0  1580  248  196 R   50  0.0   0:31.69 loop
> 
> but CFS has changed that behavior.
> 
> I'll check your 10-tasks-on-8-cpus example on an 8-way box too, maybe 
> we regressed somewhere ...

ok, i just tried it on an 8-cpu box and indeed, unlike the dual-core 
case, the scheduler does not distribute tasks well enough:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2572 mingo     20   0  1576  244  196 R  100  0.0   1:03.61 loop
 2578 mingo     20   0  1576  248  196 R  100  0.0   1:03.59 loop
 2576 mingo     20   0  1576  248  196 R  100  0.0   1:03.52 loop
 2571 mingo     20   0  1576  244  196 R  100  0.0   1:03.46 loop
 2569 mingo     20   0  1576  244  196 R   99  0.0   1:03.36 loop
 2570 mingo     20   0  1576  244  196 R   95  0.0   1:00.55 loop
 2577 mingo     20   0  1576  248  196 R   50  0.0   0:31.88 loop
 2574 mingo     20   0  1576  248  196 R   50  0.0   0:31.87 loop
 2573 mingo     20   0  1576  248  196 R   50  0.0   0:31.86 loop
 2575 mingo     20   0  1576  248  196 R   50  0.0   0:31.86 loop

but this is relatively easy to fix - with the patch below applied, it 
looks a lot better:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2681 mingo     20   0  1576  244  196 R   85  0.0   3:51.68 loop
 2688 mingo     20   0  1576  244  196 R   81  0.0   3:46.35 loop
 2682 mingo     20   0  1576  244  196 R   80  0.0   3:43.68 loop
 2685 mingo     20   0  1576  248  196 R   80  0.0   3:45.97 loop
 2683 mingo     20   0  1576  248  196 R   80  0.0   3:40.25 loop
 2679 mingo     20   0  1576  244  196 R   80  0.0   3:33.53 loop
 2680 mingo     20   0  1576  244  196 R   79  0.0   3:43.53 loop
 2686 mingo     20   0  1576  244  196 R   79  0.0   3:39.31 loop
 2687 mingo     20   0  1576  244  196 R   78  0.0   3:33.31 loop
 2684 mingo     20   0  1576  244  196 R   77  0.0   3:27.52 loop

they now nicely converte to the expected 80% long-term CPU usage.

so, could you please try the patch below, does it work for you too?

	Ingo

--------------------------->
Subject: sched: increase SCHED_LOAD_SCALE_FUZZ
From: Ingo Molnar <mingo@elte.hu>

increase SCHED_LOAD_SCALE_FUZZ that adds a small amount of
over-balancing: to help distribute CPU-bound tasks more fairly on SMP
systems.

the problem of unfair balancing was noticed and reported by Tong N Li.

10 CPU-bound tasks running on 8 CPUs, v2.6.23-rc1:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2572 mingo     20   0  1576  244  196 R  100  0.0   1:03.61 loop
 2578 mingo     20   0  1576  248  196 R  100  0.0   1:03.59 loop
 2576 mingo     20   0  1576  248  196 R  100  0.0   1:03.52 loop
 2571 mingo     20   0  1576  244  196 R  100  0.0   1:03.46 loop
 2569 mingo     20   0  1576  244  196 R   99  0.0   1:03.36 loop
 2570 mingo     20   0  1576  244  196 R   95  0.0   1:00.55 loop
 2577 mingo     20   0  1576  248  196 R   50  0.0   0:31.88 loop
 2574 mingo     20   0  1576  248  196 R   50  0.0   0:31.87 loop
 2573 mingo     20   0  1576  248  196 R   50  0.0   0:31.86 loop
 2575 mingo     20   0  1576  248  196 R   50  0.0   0:31.86 loop

v2.6.23-rc1 + patch:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2681 mingo     20   0  1576  244  196 R   85  0.0   3:51.68 loop
 2688 mingo     20   0  1576  244  196 R   81  0.0   3:46.35 loop
 2682 mingo     20   0  1576  244  196 R   80  0.0   3:43.68 loop
 2685 mingo     20   0  1576  248  196 R   80  0.0   3:45.97 loop
 2683 mingo     20   0  1576  248  196 R   80  0.0   3:40.25 loop
 2679 mingo     20   0  1576  244  196 R   80  0.0   3:33.53 loop
 2680 mingo     20   0  1576  244  196 R   79  0.0   3:43.53 loop
 2686 mingo     20   0  1576  244  196 R   79  0.0   3:39.31 loop
 2687 mingo     20   0  1576  244  196 R   78  0.0   3:33.31 loop
 2684 mingo     20   0  1576  244  196 R   77  0.0   3:27.52 loop

so they now nicely converte to the expected 80% long-term CPU usage.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -681,7 +681,7 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SHIFT	10
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
-#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 5)
+#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 1)
 
 #ifdef CONFIG_SMP
 #define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
