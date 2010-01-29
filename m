Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782Ab0A2J3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0A2J3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460Ab0A2J3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:29:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:57449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061Ab0A2J3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:29:09 -0500
Date: Fri, 29 Jan 2010 09:28:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.963944926@chello.nl>
References: <20100122155535.963944926@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Optimize constraint weight computation
Message-ID: <tip-272d30be622c9c6cbd514b1211ff359292001baa@git.kernel.org>
Git-Commit-ID: 272d30be622c9c6cbd514b1211ff359292001baa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:28:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  272d30be622c9c6cbd514b1211ff359292001baa
Gitweb:     http://git.kernel.org/tip/272d30be622c9c6cbd514b1211ff359292001baa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 16:32:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:41 +0100

perf_event: x86: Optimize constraint weight computation

Add a weight member to the constraint structure and avoid recomputing the
weight at runtime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.963944926@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 092ad56..2c22ce4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 #include <linux/cpu.h>
+#include <linux/bitops.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -76,6 +77,7 @@ struct event_constraint {
 	};
 	int	code;
 	int	cmask;
+	int	weight;
 };
 
 struct cpu_hw_events {
@@ -95,6 +97,7 @@ struct cpu_hw_events {
 	{ .idxmsk64[0] = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
+	.weight = HWEIGHT64((u64)(n)),	\
 }
 
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
@@ -1242,8 +1245,7 @@ static inline int is_x86_event(struct perf_event *event)
 
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	int i, j , w, num;
-	int weight, wmax;
+	int i, j, w, num, wmax;
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct hw_perf_event *hwc;
@@ -1320,8 +1322,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
-			weight = bitmap_weight(c->idxmsk, X86_PMC_IDX_MAX);
-			if (weight != w)
+			if (c->weight != w)
 				continue;
 
 			for_each_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
