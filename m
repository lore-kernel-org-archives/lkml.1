Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbXHWMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbXHWMN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXHWMNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:13:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbXHWMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:13:48 -0400
Date: Thu, 23 Aug 2007 14:13:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070823121341.GA5775@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823115416.GA31027@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] So how about the patch below instead?

the right patch attached.

-------------------------------->
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
+	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
