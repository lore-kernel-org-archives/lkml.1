Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZFCVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZFCVnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZFCVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:43:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:50145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZFCVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:43:33 -0400
Date: Wed, 3 Jun 2009 21:42:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix throttling lock-up
Message-ID: <tip-128f048f0f0d2a477ad2555e7acd2ad15a1b6061@git.kernel.org>
Git-Commit-ID: 128f048f0f0d2a477ad2555e7acd2ad15a1b6061
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 21:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  128f048f0f0d2a477ad2555e7acd2ad15a1b6061
Gitweb:     http://git.kernel.org/tip/128f048f0f0d2a477ad2555e7acd2ad15a1b6061
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 22:19:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 23:39:51 +0200

perf_counter: Fix throttling lock-up

Throttling logic is broken and we can lock up with too small
hw sampling intervals.

Make the throttling code more robust: disable counters even
if we already disabled them.

( Also clean up whitespace damage i noticed while reading
  various pieces of code related to throttling. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 kernel/perf_counter.c              |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 12cc05e..8f53f3a 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -91,7 +91,7 @@ static u64 intel_pmu_raw_event(u64 event)
 #define CORE_EVNTSEL_INV_MASK		0x00800000ULL
 #define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
 
-#define CORE_EVNTSEL_MASK 		\
+#define CORE_EVNTSEL_MASK		\
 	(CORE_EVNTSEL_EVENT_MASK |	\
 	 CORE_EVNTSEL_UNIT_MASK  |	\
 	 CORE_EVNTSEL_EDGE_MASK  |	\
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ab44554..0bb03f1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2822,11 +2822,20 @@ int perf_counter_overflow(struct perf_counter *counter,
 
 	if (!throttle) {
 		counter->hw.interrupts++;
-	} else if (counter->hw.interrupts != MAX_INTERRUPTS) {
-		counter->hw.interrupts++;
-		if (HZ*counter->hw.interrupts > (u64)sysctl_perf_counter_limit) {
-			counter->hw.interrupts = MAX_INTERRUPTS;
-			perf_log_throttle(counter, 0);
+	} else {
+		if (counter->hw.interrupts != MAX_INTERRUPTS) {
+			counter->hw.interrupts++;
+			if (HZ*counter->hw.interrupts > (u64)sysctl_perf_counter_limit) {
+				counter->hw.interrupts = MAX_INTERRUPTS;
+				perf_log_throttle(counter, 0);
+				ret = 1;
+			}
+		} else {
+			/*
+			 * Keep re-disabling counters even though on the previous
+			 * pass we disabled it - just in case we raced with a
+			 * sched-in and the counter got enabled again:
+			 */
 			ret = 1;
 		}
 	}
