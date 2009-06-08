Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZFHVdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZFHVdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFHVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:33:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbZFHVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:33:41 -0400
Date: Mon, 8 Jun 2009 21:33:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: Implement generalized cache event types, add AMD support
Message-ID: <tip-f86748e91a14bd6cc49477560f33ed5d59896e89@git.kernel.org>
Git-Commit-ID: f86748e91a14bd6cc49477560f33ed5d59896e89
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 21:33:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f86748e91a14bd6cc49477560f33ed5d59896e89
Gitweb:     http://git.kernel.org/tip/f86748e91a14bd6cc49477560f33ed5d59896e89
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 8 Jun 2009 22:33:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 23:10:37 +0200

perf_counter, x86: Implement generalized cache event types, add AMD support

Fill in amd_hw_cache_event_id[] with the AMD CPU specific events,
for family 0x0f, 0x10 and 0x11.

There's apparently no distinction between load and store events, so
we only fill in the load events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |  102 ++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 0339d19..93af821 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -389,6 +389,97 @@ static u64 intel_pmu_raw_event(u64 event)
 	return event & CORE_EVNTSEL_MASK;
 }
 
+static const u64 amd_0f_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction cache fetches  */
+		[ C(RESULT_MISS)   ] = 0x0081, /* Instruction cache misses   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(L2  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
+		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c2, /* Retired Branch Instr.      */
+		[ C(RESULT_MISS)   ] = 0x00c3, /* Retired Mispredicted BI    */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
 /*
  * AMD Performance Monitor K7 and later.
  */
@@ -1345,6 +1436,17 @@ static int intel_pmu_init(void)
 static int amd_pmu_init(void)
 {
 	x86_pmu = amd_pmu;
+
+	switch (boot_cpu_data.x86) {
+	case 0x0f:
+	case 0x10:
+	case 0x11:
+		memcpy(hw_cache_event_ids, amd_0f_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		pr_cont("AMD Family 0f/10/11 events, ");
+		break;
+	}
 	return 0;
 }
 
