Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYKYVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYKYVr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYKYVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:45:05 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43582 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbYKYVpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:45:03 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/6] Migrate x86 to nanosecond cputime64_t
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:44:58 -0800
Message-ID: <20081125214457.22900.94980.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates cputime64_t to have nanosecond resolution instead
of jiffies resolution.  This is necessary so that we can report scaled
utime and stime for chargeback accounting, since the taskstat data are
only updated once per jiffy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 arch/x86/include/asm/cputime.h |  109 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cputime.h b/arch/x86/include/asm/cputime.h
index 6d68ad7..dcce01a 100644
--- a/arch/x86/include/asm/cputime.h
+++ b/arch/x86/include/asm/cputime.h
@@ -1 +1,110 @@
+/*
+ * Definitions for measuring cputime on x86 machines.
+ *
+ * Based on <asm-ia64/cputime.h>.
+ *
+ * From the original file:
+ * Copyright (C) 2007 FUJITSU LIMITED
+ * Copyright (C) 2007 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * If we have CONFIG_VIRT_CPU_ACCOUNTING, we measure cpu time in nsec.
+ * Otherwise we measure cpu time in jiffies using the generic definitions.
+ */
+
+#ifndef __X86_CPUTIME_H
+#define __X86_CPUTIME_H
+
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 #include <asm-generic/cputime.h>
+#else
+
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <asm/processor.h>
+
+typedef u64 cputime_t;
+typedef u64 cputime64_t;
+
+#define cputime_zero			((cputime_t)0)
+#define cputime_max			((~((cputime_t)0) >> 1) - 1)
+#define cputime_add(__a, __b)		((__a) +  (__b))
+#define cputime_sub(__a, __b)		((__a) -  (__b))
+#define cputime_div(__a, __n)		((__a) /  (__n))
+#define cputime_halve(__a)		((__a) >> 1)
+#define cputime_eq(__a, __b)		((__a) == (__b))
+#define cputime_gt(__a, __b)		((__a) >  (__b))
+#define cputime_ge(__a, __b)		((__a) >= (__b))
+#define cputime_lt(__a, __b)		((__a) <  (__b))
+#define cputime_le(__a, __b)		((__a) <= (__b))
+
+#define cputime64_zero			((cputime64_t)0)
+#define cputime64_add(__a, __b)		((__a) + (__b))
+#define cputime64_sub(__a, __b)		((__a) - (__b))
+#define cputime_to_cputime64(__ct)	(__ct)
+
+/*
+ * Convert cputime <-> jiffies (HZ)
+ */
+#define cputime_to_jiffies(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies_to_cputime(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
+
+/*
+ * Convert cputime <-> milliseconds
+ */
+#define cputime_to_msecs(__ct)		((__ct) / NSEC_PER_MSEC)
+#define msecs_to_cputime(__msecs)	((__msecs) * NSEC_PER_MSEC)
+
+/*
+ * Convert cputime <-> seconds
+ */
+#define cputime_to_secs(__ct)		((__ct) / NSEC_PER_SEC)
+#define secs_to_cputime(__secs)		((__secs) * NSEC_PER_SEC)
+
+/*
+ * Convert cputime <-> timespec (nsec)
+ */
+static inline cputime_t timespec_to_cputime(const struct timespec *val)
+{
+	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
+	return ret + val->tv_nsec;
+}
+static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
+{
+	val->tv_sec  = ct / NSEC_PER_SEC;
+	val->tv_nsec = ct % NSEC_PER_SEC;
+}
+
+/*
+ * Convert cputime <-> timeval (msec)
+ */
+static inline cputime_t timeval_to_cputime(struct timeval *val)
+{
+	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
+	return ret + val->tv_usec * NSEC_PER_USEC;
+}
+static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
+{
+	val->tv_sec = ct / NSEC_PER_SEC;
+	val->tv_usec = (ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+}
+
+/*
+ * Convert cputime <-> clock (USER_HZ)
+ */
+#define cputime_to_clock_t(__ct)	((__ct) / (NSEC_PER_SEC / USER_HZ))
+#define clock_t_to_cputime(__x)		((__x) * (NSEC_PER_SEC / USER_HZ))
+
+/*
+ * Convert cputime64 to clock.
+ */
+#define cputime64_to_clock_t(__ct)      cputime_to_clock_t((cputime_t)__ct)
+
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* __X86_CPUTIME_H */

