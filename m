Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbZD2NN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbZD2NN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbZD2NIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:08:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:44719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322AbZD2NIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:08:43 -0400
Date: Wed, 29 Apr 2009 13:08:02 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-26-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-26-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: return raw count with x86_perf_counter_update()
Message-ID: <tip-4b7bfd0d276da3a006d37e85d3cf900d7a14ae2a@git.kernel.org>
Git-Commit-ID: 4b7bfd0d276da3a006d37e85d3cf900d7a14ae2a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:08:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b7bfd0d276da3a006d37e85d3cf900d7a14ae2a
Gitweb:     http://git.kernel.org/tip/4b7bfd0d276da3a006d37e85d3cf900d7a14ae2a
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:13 +0200

perf_counter, x86: return raw count with x86_perf_counter_update()

To check on AMD cpus if a counter overflows, the upper bit of the raw
counter value must be checked. This value is already internally
available in x86_perf_counter_update(). Now, the value is returned so
that it can be used directly to check for overflows.

[ Impact: micro-optimization ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-26-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f4d59d4..a8a53ab 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -132,7 +132,7 @@ static u64 amd_pmu_raw_event(u64 event)
  * Can only be executed on the CPU where the counter is active.
  * Returns the delta events processed.
  */
-static void
+static u64
 x86_perf_counter_update(struct perf_counter *counter,
 			struct hw_perf_counter *hwc, int idx)
 {
@@ -165,6 +165,8 @@ again:
 
 	atomic64_add(delta, &counter->count);
 	atomic64_sub(delta, &hwc->period_left);
+
+	return new_raw_count;
 }
 
 static atomic_t num_counters;
@@ -785,8 +787,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 			continue;
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
-		x86_perf_counter_update(counter, hwc, idx);
-		val = atomic64_read(&hwc->prev_count);
+		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
 			continue;
 		/* counter overflow */
