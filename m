Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZIDItQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZIDItQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZIDItP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:49:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbZIDItO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:49:14 -0400
Date: Fri, 4 Sep 2009 10:49:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090904084904.GA29283@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

Would be nice if you could pull this into .31-final, due to the 
security and the stability fix.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      perf_counters: Increase paranoia level

Paul Mackerras (1):
      perf_counter/powerpc: Fix cache event codes for POWER7

Peter Zijlstra (1):
      perf_counter: Fix /0 bug in swcounters


 arch/powerpc/kernel/power7-pmu.c |    6 +++---
 kernel/perf_counter.c            |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 388cf57..018d094 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -317,7 +317,7 @@ static int power7_generic_events[] = {
  */
 static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-		[C(OP_READ)] = {	0x400f0,	0xc880	},
+		[C(OP_READ)] = {	0xc880,		0x400f0	},
 		[C(OP_WRITE)] = {	0,		0x300f0	},
 		[C(OP_PREFETCH)] = {	0xd8b8,		0	},
 	},
@@ -327,8 +327,8 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_PREFETCH)] = {	0x408a,		0	},
 	},
 	[C(LL)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-		[C(OP_READ)] = {	0x6080,		0x6084	},
-		[C(OP_WRITE)] = {	0x6082,		0x6086	},
+		[C(OP_READ)] = {	0x16080,	0x26080	},
+		[C(OP_WRITE)] = {	0x16082,	0x26082	},
 		[C(OP_PREFETCH)] = {	0,		0	},
 	},
 	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f274e19..d7cbc57 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -50,7 +50,7 @@ static atomic_t nr_task_counters __read_mostly;
  *  1 - disallow cpu counters to unpriv
  *  2 - disallow kernel profiling to unpriv
  */
-int sysctl_perf_counter_paranoid __read_mostly;
+int sysctl_perf_counter_paranoid __read_mostly = 1;
 
 static inline bool perf_paranoid_cpu(void)
 {
@@ -4066,6 +4066,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	hwc->sample_period = attr->sample_period;
 	if (attr->freq && attr->sample_freq)
 		hwc->sample_period = 1;
+	hwc->last_period = hwc->sample_period;
 
 	atomic64_set(&hwc->period_left, hwc->sample_period);
 
