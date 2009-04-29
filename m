Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbZD2NKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbZD2NKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbZD2NHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:07:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbZD2NH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:07:29 -0400
Date: Wed, 29 Apr 2009 13:06:43 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: rename cpuc->active_mask
Message-ID: <tip-93904966934193204ad08e951f806d5631c29eb3@git.kernel.org>
Git-Commit-ID: 93904966934193204ad08e951f806d5631c29eb3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:06:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93904966934193204ad08e951f806d5631c29eb3
Gitweb:     http://git.kernel.org/tip/93904966934193204ad08e951f806d5631c29eb3
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:09 +0200

perf_counter, x86: rename cpuc->active_mask

This is to have a consistent naming scheme with cpuc->used.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3f3ae47..9ec51a6 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -29,9 +29,9 @@ static u64 perf_counter_mask __read_mostly;
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		active[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	u64			throttle_ctrl;
-	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 };
 
@@ -334,7 +334,7 @@ static u64 amd_pmu_save_disable_all(void)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
@@ -376,7 +376,7 @@ static void amd_pmu_restore_all(u64 ctrl)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
@@ -424,7 +424,7 @@ static void amd_pmu_enable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	set_bit(idx, cpuc->active_mask);
+	set_bit(idx, cpuc->active);
 	if (cpuc->enabled)
 		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
@@ -448,7 +448,7 @@ static void amd_pmu_disable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	clear_bit(idx, cpuc->active_mask);
+	clear_bit(idx, cpuc->active);
 	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
 
 }
