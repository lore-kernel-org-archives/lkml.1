Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZEDSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZEDSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZEDSZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:25:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:60304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZEDSZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:25:18 -0400
Date: Mon, 4 May 2009 18:24:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, robert.richter@amd.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter: fix fixed-purpose counter support on v2 Intel-PERFMON
Message-ID: <tip-066d7dea32c9bffe6decc0abe465627656cdd84e@git.kernel.org>
Git-Commit-ID: 066d7dea32c9bffe6decc0abe465627656cdd84e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 18:24:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  066d7dea32c9bffe6decc0abe465627656cdd84e
Gitweb:     http://git.kernel.org/tip/066d7dea32c9bffe6decc0abe465627656cdd84e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 4 May 2009 19:04:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 20:17:31 +0200

perf_counter: fix fixed-purpose counter support on v2 Intel-PERFMON

Fixed-purpose counters stopped working in a simple 'perf stat ls' run:

   <not counted>  cache references
   <not counted>  cache misses

Due to:

  ef7b3e0: perf_counter, x86: remove vendor check in fixed_mode_idx()

Which made x86_pmu.num_counters_fixed matter: if it's nonzero, the
fixed-purpose counters are utilized.

But on v2 perfmon this field is not set (despite there being
fixed-purpose PMCs). So add a quirk to set the number of fixed-purpose
counters to at least three.

[ Impact: add quirk for three fixed-purpose counters on certain Intel CPUs ]

Cc: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 196b58f..a6878b0 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -962,7 +962,13 @@ static int intel_pmu_init(void)
 	x86_pmu = intel_pmu;
 	x86_pmu.version = version;
 	x86_pmu.num_counters = eax.split.num_counters;
-	x86_pmu.num_counters_fixed = edx.split.num_counters_fixed;
+
+	/*
+	 * Quirk: v2 perfmon does not report fixed-purpose counters, so
+	 * assume at least 3 counters:
+	 */
+	x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
+
 	x86_pmu.counter_bits = eax.split.bit_width;
 	x86_pmu.counter_mask = (1ULL << eax.split.bit_width) - 1;
 
