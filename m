Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZKTHx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZKTHx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZKTHx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:53:56 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:42789 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZKTHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:53:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RteChFPsxHwzFqtzN2tNeO1lL8T86zBt1g3TTuC1qSgopwXyb2Lcb4Qn9XtwypNFym
         mBunbWQTmbfmiCTiZIwIMI34uwkZXCXbz3ysxh8liwsKES9mlaC4SWzs4+95IyL/Wyh0
         5gII2Z+Xy4H/G6ENxzdA7rM0iQS6PKMBQzWrQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] MIPS: Add a high precision sched_clock() via cnt32_to_63().
Date: Fri, 20 Nov 2009 15:53:22 +0800
Message-Id: <1258703602-29065-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

MIPS uses the jiffies based sched_clock(), the precision is very
low(about 10ms with 1000 HZ), which is not enough for some places. a
very obvious example is Ftracer.

Ftracer is originally designed for real time tracing, but without a high
precision sched_clock(), the timestamp information will be totally
garbage. So, we need to find a high precision sched_clock().

In the past series of patchset of "ftrace for MIPS", I have implemented
such a sched_clock(), which is based on the 32-bit long MIPS c0 count
and the timecounter/cyclecounter stuff in include/linux/clocksource.h.

That sched_clock() did work well for Ftracer, but touched several places
of the core of Ftracer. and also, that one is only enabled for Ftracer.

In the v8 revision of "ftrace for MIPS", Thomas Gleixner recommended to
enable sched_clock() for the whole system and re-implement it via the
cnt32_to_63() stuff in include/linux/cnt32_to_63.h.

Just had a look at the cnt32_to_64() and some implementations in
arch/arm/, and then cloned one for MIPS from arch/arm/plat-orion/time.c.

Of course, this is a "rude" version, perhaps we need to consider more
for different MIPSs(something like what have been done in
arch/arm/plat-orion/time.c). and also, the overhead is needed to
be measured. Herein just list the difference between the old
jiffes based one and this new one:

1. jiffies-based:

unsigned long long __attribute__((weak)) sched_clock(void)
{
	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
					* (NSEC_PER_SEC / HZ);
}

2. cnt32_to_63() and read_c0_count() based one:

unsigned long long notrace sched_clock(void)
{
	unsigned long long v = cnt32_to_63(read_c0_count());
	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
}

 #define cnt32_to_63(cnt_lo) \
({ \
	static u32 __m_cnt_hi; \
	union cnt32_to_63 __x; \
	__x.hi = __m_cnt_hi; \
 	smp_rmb(); \
	__x.lo = (cnt_lo); \
	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
	__x.val; \
})

 #define read_c0_count()		__read_32bit_c0_register($9, 0)
 #define __read_32bit_c0_register(source, sel)				\
({ int __res;								\
	if (sel == 0)							\
		__asm__ __volatile__(					\
			"mfc0\t%0, " #source "\n\t"			\
			: "=r" (__res));				\
	else								\
		__asm__ __volatile__(					\
			".set\tmips32\n\t"				\
			"mfc0\t%0, " #source ", " #sel "\n\t"		\
			".set\tmips0\n\t"				\
			: "=r" (__res));				\
	__res;								\
})

NOTE: An exisiting problem is with this new sched_clock(), we can not
always get tracing result(no result of "cat /debug/tracing/trace") of
function graph tracer. Not sure whether it is relative to this
sched_clock()!

(I will split this patch out of the patchset "ftrace for MIPS" and
 resend the patchset as v9 later for this one is really different from
 the other patches)

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/kernel/csrc-r4k.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index e95a3cd..865035d 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -6,10 +6,45 @@
  * Copyright (C) 2007 by Ralf Baechle
  */
 #include <linux/clocksource.h>
+#include <linux/cnt32_to_63.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 
 #include <asm/time.h>
 
+/*
+ * MIPS' sched_clock implementation.
+ *
+ * NOTE: because cnt32_to_63() needs to be called at least once per half period
+ * to work properly, and some of the MIPS' frequency is very low, perhaps a
+ * kernel timer is needed to be set up to ensure this requirement is always
+ * met. please refer to  arch/arm/plat-orion/time.c and
+ * include/linux/cnt32_to_63.h
+ */
+static unsigned long tclk2ns_scale, tclk2ns_scale_factor;
+
+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long v = cnt32_to_63(read_c0_count());
+	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
+}
+
+static void __init setup_sched_clock(struct clocksource *cs, unsigned long tclk)
+{
+	unsigned long long v;
+
+	v = cs->mult;
+	/*
+	 * We want an even value to automatically clear the top bit
+	 * returned by cnt32_to_63() without an additional run time
+	 * instruction. So if the LSB is 1 then round it up.
+	 */
+	if (v & 1)
+		v++;
+	tclk2ns_scale = v;
+	tclk2ns_scale_factor = cs->shift;
+}
+
 static cycle_t c0_hpt_read(struct clocksource *cs)
 {
 	return read_c0_count();
@@ -32,6 +67,8 @@ int __init init_r4k_clocksource(void)
 
 	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
 
+	setup_sched_clock(&clocksource_mips, mips_hpt_frequency);
+
 	clocksource_register(&clocksource_mips);
 
 	return 0;
-- 
1.6.2.1

