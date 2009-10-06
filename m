Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbZJFOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbZJFOmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbZJFOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:42:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59261 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbZJFOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tv70+shDx743IGbke1qhzfBaM6lKFbHpiYK0gW9ge4EE9NAcdwV0dNye0F9jT52LlF
         /Zlg8J9ter0K6TVkKVXRrckBm1VLoiIPeqiwkQ6cAG2n/m00gB5TPOsstDMvMgB138t6
         OFmwIDqJgfo7x5fe15os4cT0K+j/Dj5QYzI/Y=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH 1/2] perf_events: check for filters on fixed counter events
Date: Tue,  6 Oct 2009 16:42:08 +0200
Message-Id: <1254840129-6198-2-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1254840129-6198-1-git-send-email-eranian@gmail.com>
References: <>
 <1254840129-6198-1-git-send-email-eranian@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Intel fixed counters do not support all the filters
	possible with a generic counter. Thus, if a  fixed counter
	event is passed but with certain filters set, then the
	fixed_mode_idx() function must fail and the event must be
	measured in a generic counter instead.

	Reject filters are: inv, edge, cnt-mask

	Signed-off-by: Stephane Eranian <eranian@gmail.com>
---
 arch/x86/include/asm/perf_event.h |   11 +++++++++++
 arch/x86/kernel/cpu/perf_event.c  |    6 ++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ad7ce3f..719273b 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -28,6 +28,17 @@
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
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
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
-- 
1.5.4.3

