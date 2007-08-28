Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXH1W13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXH1W13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 18:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXH1W1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 18:27:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:59859 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXH1W1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 18:27:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,318,1183359600"; 
   d="scan'208";a="284996613"
Date: Tue, 28 Aug 2007 15:27:19 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: Ingo Molnar <mingo@elte.hu>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070828222718.GI1894@linux-os.sc.intel.com>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com> <20070827192324.GA29441@elte.hu> <20070827193103.GF1894@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827193103.GF1894@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 12:31:03PM -0700, Siddha, Suresh B wrote:
> Essentially I observed that nice 0 tasks still endup on two cores of same
> package, with out getting spread out to two different packages. This behavior
> is same with out this fix and this fix doesn't help in any way.

Ingo, Appended patch seems to fix the issue and as far as I can test, seems ok
to me.

This is a quick fix for .23. Peter Williams and myself plan to look at
code cleanups in this area (HT/MC optimizations) post .23

BTW, with this fix, do you want to retain the current FUZZ value?

thanks,
suresh
--

Try to fix MC/HT scheduler optimization breakage again, with out breaking
the FUZZ logic.

First fix the check
	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task)
with this
	if (*imbalance < busiest_load_per_task)

As the current check is always false for nice 0 tasks (as SCHED_LOAD_SCALE_FUZZ
is same as busiest_load_per_task for nice 0 tasks).

With the above change, imbalance was getting reset to 0 in the corner case
condition, making the FUZZ logic fail. Fix it by not corrupting the
imbalance and change the imbalance, only when it finds that the
HT/MC optimization is needed.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 9fe473a..03e5e8d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2511,7 +2511,7 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {
+	if (*imbalance < busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
@@ -2563,10 +2563,8 @@ small_imbalance:
 		pwr_move /= SCHED_LOAD_SCALE;
 
 		/* Move if we gain throughput */
-		if (pwr_move <= pwr_now)
-			goto out_balanced;
-
-		*imbalance = busiest_load_per_task;
+		if (pwr_move > pwr_now)
+			*imbalance = busiest_load_per_task;
 	}
 
 	return busiest;
