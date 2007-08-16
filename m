Return-Path: <linux-kernel-owner+w=401wt.eu-S937214AbXHPBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937214AbXHPBIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXHPBId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:08:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:36342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbXHPBIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,268,1183359600"; 
   d="scan'208";a="279502774"
Date: Wed, 15 Aug 2007 18:01:50 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070816010150.GG10033@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, let me know if there any side effects of this change. Thanks.
---

On a four package system with HT - HT load balancing optimizations
were broken. For example, if two tasks end up running on two logical
threads of one of the packages, scheduler is not able to pull one of
the tasks to a completely idle package.

In this scenario, for nice-0 tasks, imbalance calculated by scheduler
will be 512 and find_busiest_queue() will return 0 (as each cpu's load
is 1024 > imbalance and has only one task running).

Similarly MC scheduler optimizations also get fixed with this patch.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 45e17b8..c5ac710 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2494,7 +2494,7 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
+	if (*imbalance < busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
