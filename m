Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0BDJ5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:60169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139Ab0BDJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:48 -0500
Date: Thu, 4 Feb 2010 09:57:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] bitops: Ensure the compile time HWEIGHT is only used for such
Message-ID: <tip-fce877e3a429940a986e085a41e8b57f2d922e36@git.kernel.org>
Git-Commit-ID: fce877e3a429940a986e085a41e8b57f2d922e36
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:57:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fce877e3a429940a986e085a41e8b57f2d922e36
Gitweb:     http://git.kernel.org/tip/fce877e3a429940a986e085a41e8b57f2d922e36
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 29 Jan 2010 13:25:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:59:50 +0100

bitops: Ensure the compile time HWEIGHT is only used for such

Avoid accidental misuse by failing to compile things

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   10 +++++++---
 include/linux/bitops.h           |   33 ++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5b91992..96cfc1a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -93,13 +93,16 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
-#define EVENT_CONSTRAINT(c, n, m) {	\
+#define __EVENT_CONSTRAINT(c, n, m, w) {\
 	{ .idxmsk64[0] = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
-	.weight = HWEIGHT64((u64)(n)),	\
+	.weight = (w),			\
 }
 
+#define EVENT_CONSTRAINT(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
 
@@ -2622,7 +2625,8 @@ void __init init_hw_perf_events(void)
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	unconstrained = (struct event_constraint)
-		EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1, 0);
+		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1,
+				   0, x86_pmu.num_events);
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index ba0fd1e..25b8b2f 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -45,19 +45,30 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-#define HWEIGHT8(w)			\
-      (	(!!((w) & (1ULL << 0))) +	\
-	(!!((w) & (1ULL << 1))) +	\
-	(!!((w) & (1ULL << 2))) +	\
-	(!!((w) & (1ULL << 3))) +	\
-	(!!((w) & (1ULL << 4))) +	\
-	(!!((w) & (1ULL << 5))) +	\
-	(!!((w) & (1ULL << 6))) +	\
+/*
+ * Clearly slow versions of the hweightN() functions, their benefit is
+ * of course compile time evaluation of constant arguments.
+ */
+#define HWEIGHT8(w)					\
+      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
+	(!!((w) & (1ULL << 0))) +			\
+	(!!((w) & (1ULL << 1))) +			\
+	(!!((w) & (1ULL << 2))) +			\
+	(!!((w) & (1ULL << 3))) +			\
+	(!!((w) & (1ULL << 4))) +			\
+	(!!((w) & (1ULL << 5))) +			\
+	(!!((w) & (1ULL << 6))) +			\
 	(!!((w) & (1ULL << 7)))	)
 
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
+#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
+#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
+#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
+
+/*
+ * Type invariant version that simply casts things to the
+ * largest type.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)(w))
 
 /**
  * rol32 - rotate a 32-bit value left
