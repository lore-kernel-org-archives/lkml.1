Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbZJIOXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbZJIOXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZJIOXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:23:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbZJIOXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:23:14 -0400
Date: Fri, 9 Oct 2009 14:22:07 GMT
From: tip-bot for Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       eranian@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       eranian@gmail.com, mingo@elte.hu
In-Reply-To: <1254840129-6198-2-git-send-email-eranian@gmail.com>
References: <1254840129-6198-2-git-send-email-eranian@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Check for filters on fixed counter events
Message-ID: <tip-04a705df47d1ea27ca2b066f24b1951c51792d0d@git.kernel.org>
Git-Commit-ID: 04a705df47d1ea27ca2b066f24b1951c51792d0d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:22:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04a705df47d1ea27ca2b066f24b1951c51792d0d
Gitweb:     http://git.kernel.org/tip/04a705df47d1ea27ca2b066f24b1951c51792d0d
Author:     Stephane Eranian <eranian@googlemail.com>
AuthorDate: Tue, 6 Oct 2009 16:42:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:56:10 +0200

perf_events: Check for filters on fixed counter events

Intel fixed counters do not support all the filters possible with a
generic counter. Thus, if a fixed counter event is passed but with
certain filters set, then the fixed_mode_idx() function must fail
and the event must be measured in a generic counter instead.

Reject filters are: inv, edge, cnt-mask.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1254840129-6198-2-git-send-email-eranian@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |   13 ++++++++++++-
 arch/x86/kernel/cpu/perf_event.c  |    6 ++++++
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ad7ce3f..8d9f854 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -28,9 +28,20 @@
  */
 #define ARCH_PERFMON_EVENT_MASK				    0xffff
 
+/*
+ * filter mask to validate fixed counter events.
+ * the following filters disqualify for fixed counters:
+ *  - inv
+ *  - edge
+ *  - cnt-mask
+ *  The other filters are supported by fixed counters.
+ *  The any-thread option is supported starting with v3.
+ */
+#define ARCH_PERFMON_EVENT_FILTER_MASK			0xff840000
+
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX			 0
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
 		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b5801c3..1d16bd6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1349,6 +1349,12 @@ fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
 	if (!x86_pmu.num_events_fixed)
 		return -1;
 
+	/*
+	 * fixed counters do not take all possible filters
+	 */
+	if (hwc->config & ARCH_PERFMON_EVENT_FILTER_MASK)
+		return -1;
+
 	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
 	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
