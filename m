Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZD2NF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZD2NF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZD2NEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:44512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbZD2NEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:04:43 -0400
Date: Wed, 29 Apr 2009 13:04:05 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-5-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-5-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: rework pmc_amd_save_disable_all() and pmc_amd_restore_all()
Message-ID: <tip-4295ee62660b13ddb87d41539f49b239e6e7d56f@git.kernel.org>
Git-Commit-ID: 4295ee62660b13ddb87d41539f49b239e6e7d56f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:04:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4295ee62660b13ddb87d41539f49b239e6e7d56f
Gitweb:     http://git.kernel.org/tip/4295ee62660b13ddb87d41539f49b239e6e7d56f
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:02 +0200

perf_counter, x86: rework pmc_amd_save_disable_all() and pmc_amd_restore_all()

MSR reads and writes are expensive. This patch adds checks to avoid
its usage where possible.

[ Impact: micro-optimization on AMD CPUs ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-5-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d6d6529..75a0903 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -334,11 +334,13 @@ static u64 pmc_amd_save_disable_all(void)
 	for (idx = 0; idx < nr_counters_generic; idx++) {
 		u64 val;
 
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
-			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		}
+		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
+			continue;
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 
 	return enabled;
@@ -372,13 +374,15 @@ static void pmc_amd_restore_all(u64 ctrl)
 		return;
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		if (test_bit(idx, cpuc->active_mask)) {
-			u64 val;
+		u64 val;
 
-			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		}
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			continue;
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 }
 
