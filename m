Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbXHWLyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbXHWLyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbXHWLyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:54:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbXHWLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:54:30 -0400
Date: Thu, 23 Aug 2007 13:54:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070823115416.GA31027@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816010150.GG10033@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

>  	 * a think about bumping its value to force at least one task to be
>  	 * moved
>  	 */
> -	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
> +	if (*imbalance < busiest_load_per_task) {
>  		unsigned long tmp, pwr_now, pwr_move;

hm, found a problem: this removes the 'fuzz' from balancing, which is a 
slight over-balancing to perturb CPU-bound tasks to be distributed in a 
fairer manner between CPUs. So how about the patch below instead?

a good testcase for this is to start 3 CPU-bound tasks on a 2-core box:

  for ((i=0; i<3; i++)); do while :; do :; done & done

with your patch applied two of the loops stick to one core, getting 50% 
each - the third loop sticks to the other core, getting 100% CPU time:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3093 root      20   0  2736  528  252 R  100  0.0   0:23.81 bash
 3094 root      20   0  2736  532  256 R   50  0.0   0:11.95 bash
 3095 root      20   0  2736  532  256 R   50  0.0   0:11.95 bash

with no patch, or with my patch below each gets ~66% of CPU time, 
long-term:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2290 mingo     20   0  2736  528  252 R   67  0.0   3:22.95 bash
 2291 mingo     20   0  2736  532  256 R   67  0.0   3:18.94 bash
 2292 mingo     20   0  2736  532  256 R   66  0.0   3:19.83 bash

the breakage wasnt caused by the fuzz, it was caused by the /2 - the 
patch below should fix this for real.

	Ingo

------------------------------>
Subject: sched: fix broken SMT/MC optimizations
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

On a four package system with HT - HT load balancing optimizations were 
broken.  For example, if two tasks end up running on two logical threads 
of one of the packages, scheduler is not able to pull one of the tasks 
to a completely idle package.

In this scenario, for nice-0 tasks, imbalance calculated by scheduler 
will be 512 and find_busiest_queue() will return 0 (as each cpu's load 
is 1024 > imbalance and has only one task running).

Similarly MC scheduler optimizations also get fixed with this patch.

[ mingo@elte.hu: restored fair balancing by increasing the fuzz and
                 adding it back to the power decision, without the /2
                 factor. ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 include/linux/sched.h |    2 +-
 kernel/sched.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -681,7 +681,7 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SHIFT	10
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
-#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 1)
+#define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
 
 #ifdef CONFIG_SMP
 #define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -2517,7 +2517,7 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
+	if (*imbalance < busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
