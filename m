Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbZIDH6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbZIDH6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbZIDH6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:58:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:33469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbZIDH6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:58:49 -0400
Date: Fri, 4 Sep 2009 07:58:18 GMT
From: "tip-bot for markus.t.metzger@intel.com" <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090902140612.943801000@intel.com>
References: <20090902140612.943801000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] x86, perf_counter, bts: Fail if BTS is not available
Message-ID: <tip-747b50aaf728987732e6ff3ba10aba4acc4e0277@git.kernel.org>
Git-Commit-ID: 747b50aaf728987732e6ff3ba10aba4acc4e0277
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 07:58:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  747b50aaf728987732e6ff3ba10aba4acc4e0277
Gitweb:     http://git.kernel.org/tip/747b50aaf728987732e6ff3ba10aba4acc4e0277
Author:     markus.t.metzger@intel.com <markus.t.metzger@intel.com>
AuthorDate: Wed, 2 Sep 2009 16:04:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 09:26:39 +0200

x86, perf_counter, bts: Fail if BTS is not available

Reserve PERF_COUNT_HW_BRANCH_INSTRUCTIONS with sample_period ==
1 for BTS tracing and fail, if BTS is not available.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090902140612.943801000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 396e35d..2f41874 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -769,7 +769,7 @@ static int reserve_bts_hardware(void)
 	int cpu, err = 0;
 
 	if (!bts_available())
-		return -EOPNOTSUPP;
+		return 0;
 
 	get_online_cpus();
 
@@ -914,7 +914,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
 			else
-				reserve_bts_hardware();
+				err = reserve_bts_hardware();
 		}
 		if (!err)
 			atomic_inc(&active_counters);
@@ -979,6 +979,13 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (config == -1LL)
 		return -EINVAL;
 
+	/*
+	 * Branch tracing:
+	 */
+	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (hwc->sample_period == 1) && !bts_available())
+		return -EOPNOTSUPP;
+
 	hwc->config |= config;
 
 	return 0;
@@ -1355,19 +1362,9 @@ static int x86_pmu_enable(struct perf_counter *counter)
 
 	idx = fixed_mode_idx(counter, hwc);
 	if (idx == X86_PMC_IDX_FIXED_BTS) {
-		/*
-		 * Try to use BTS for branch tracing. If that is not
-		 * available, try to get a generic counter.
-		 */
-		if (unlikely(!cpuc->ds))
-			goto try_generic;
-
-		/*
-		 * Try to get the fixed counter, if that is already taken
-		 * then try to get a generic counter:
-		 */
+		/* BTS is already occupied. */
 		if (test_and_set_bit(idx, cpuc->used_mask))
-			goto try_generic;
+			return -EAGAIN;
 
 		hwc->config_base	= 0;
 		hwc->counter_base	= 0;
