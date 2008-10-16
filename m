Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYJPX52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYJPX52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYJPXzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48792 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbYJPXzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:32 -0400
Message-Id: <20081016234657.521254081@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Giuseppe Cavallaro <peppe.cavallaro@st.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [RFC patch 13/15] LTTng timestamp sh
Content-Disposition: inline; filename=lttng-timestamp-sh.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the timestamping mechanism in the ltt.h arch header file.
The new timestamp functions use the TMU channel 1.

This code only works if the TMU channel 1 is initialized during the kernel boot

Note from Mathieu :
This patch seems to assume TMU channel 1 is setup at boot. Is it always true on
all SuperH boards ? Is there some Kconfig selection that should be done here ?
We could probably extract part of this patch into get_cycles() and remove
CONFIG_LTT dependency.

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org
---
 arch/sh/Kconfig             |    2 +
 arch/sh/include/asm/ltt.h   |   45 ++++++++++++++++++++++++++++++++++++++++++++
 arch/sh/include/asm/timex.h |    8 ++++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/sh/include/asm/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/sh/include/asm/ltt.h	2008-10-16 18:54:57.000000000 -0400
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2007, Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *                     Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * SuperH definitions for tracing system
+ */
+
+#ifndef _ASM_SH_LTT_H
+#define _ASM_SH_LTT_H
+
+#include <linux/timer.h>
+#include <asm/clock.h>
+
+extern u64 ltt_read_synthetic_tsc(void);
+
+static inline u32 ltt_get_timestamp32(void)
+{
+	return get_cycles();
+}
+
+static inline u64 ltt_get_timestamp64(void)
+{
+	return ltt_read_synthetic_tsc();
+}
+
+static inline void ltt_add_timestamp(unsigned long ticks)
+{ }
+
+static inline unsigned int ltt_frequency(void)
+{
+	unsigned long rate;
+	struct clk *tmu1_clk;
+
+	tmu1_clk = clk_get(NULL, "tmu1_clk");
+	rate = (clk_get_rate(tmu1_clk));
+
+	return (unsigned int)(rate);
+}
+
+static inline u32 ltt_freq_scale(void)
+{
+	return 1;
+}
+
+#endif /* _ASM_SH_LTT_H */
Index: linux-2.6-lttng/arch/sh/include/asm/timex.h
===================================================================
--- linux-2.6-lttng.orig/arch/sh/include/asm/timex.h	2008-10-16 18:53:59.000000000 -0400
+++ linux-2.6-lttng/arch/sh/include/asm/timex.h	2008-10-16 18:54:51.000000000 -0400
@@ -6,12 +6,18 @@
 #ifndef __ASM_SH_TIMEX_H
 #define __ASM_SH_TIMEX_H
 
-#define CLOCK_TICK_RATE		(CONFIG_SH_PCLK_FREQ / 4) /* Underlying HZ */
+#include <linux/io.h>
+#include <asm/cpu/timer.h>
+
+#define CLOCK_TICK_RATE		(HZ * 100000UL)
 
 typedef unsigned long long cycles_t;
 
 static __inline__ cycles_t get_cycles (void)
 {
+#ifdef CONFIG_LTT
+	return 0xffffffff - ctrl_inl(TMU1_TCNT);
+#endif
 	return 0;
 }
 
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2008-10-16 18:53:59.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2008-10-16 18:54:51.000000000 -0400
@@ -11,6 +11,8 @@ config SUPERH
 	select HAVE_CLK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_LTT_CLOCK
+	select HAVE_LTT_SYNTHETIC_TSC
 	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
