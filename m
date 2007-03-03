Return-Path: <linux-kernel-owner+w=401wt.eu-S2992966AbXCCE75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992966AbXCCE75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 23:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992967AbXCCE75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 23:59:57 -0500
Received: from mga06.intel.com ([134.134.136.21]:38355 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992966AbXCCE75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 23:59:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,244,1170662400"; 
   d="scan'208"; a="203527275:sNHT18883326"
Date: Fri, 2 Mar 2007 20:23:32 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: [patch] sched: optimize siblings status check logic in wake_idle()
Message-ID: <20070302202331.B27368@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a logical cpu 'x' already has more than one process running, then most likely
the siblings of that cpu 'x' must be busy. Otherwise the idle siblings
would have likely(in most of the scenarios) picked up the extra load making
the load on 'x' atmost one.

Use this logic to eliminate the siblings status check and minimize the cache
misses encountered on a heavily loaded system.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 0dc7572..d1ecc56 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1368,7 +1368,16 @@ static int wake_idle(int cpu, struct task_struct *p)
 	struct sched_domain *sd;
 	int i;
 
-	if (idle_cpu(cpu))
+	/*
+	 * If it is idle, then it is the best cpu to run this task.
+	 *
+	 * This cpu is also the best, if it has more than one task already.
+	 * Siblings must be also busy(in most cases) as they didn't already
+	 * pickup the extra load from this cpu and hence we need not check
+	 * sibling runqueue info. This will avoid the checks and cache miss
+	 * penalities associated with that.
+	 */
+	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
 		return cpu;
 
 	for_each_domain(cpu, sd) {
