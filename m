Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKZNAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKZNAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYKZM6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:58:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46184 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYKZM6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:58:04 -0500
Message-Id: <20081126124636.075638361@polymtl.ca>
References: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:42:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [patch 11/17] LTTng timestamp sh
Content-Disposition: inline; filename=sh-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the timestamping mechanism in the trace-clock.h arch header
file. The new timestamp functions use the TMU channel 1.

This code only works if the TMU channel 1 is initialized during the kernel boot.

Big fat warning(TM) from Mathieu Desnoyers :

This patch seems to assume TMU channel 1 is setup at boot. Is it always true on
all SuperH boards ? Is there some Kconfig selection that should be done here ?
Make sure this patch does not break get_cycles on SuperH before merging.

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org
---
 arch/sh/Kconfig                   |    2 +
 arch/sh/include/asm/timex.h       |    7 +++-
 arch/sh/include/asm/trace-clock.h |   58 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/sh/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/sh/include/asm/timex.h	2008-11-12 18:15:48.000000000 -0500
+++ linux.trees.git/arch/sh/include/asm/timex.h	2008-11-26 06:52:23.000000000 -0500
@@ -6,13 +6,16 @@
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
-	return 0;
+	return 0xffffffff - ctrl_inl(TMU1_TCNT);
 }
 
 #endif /* __ASM_SH_TIMEX_H */
Index: linux.trees.git/arch/sh/Kconfig
===================================================================
--- linux.trees.git.orig/arch/sh/Kconfig	2008-11-12 18:15:47.000000000 -0500
+++ linux.trees.git/arch/sh/Kconfig	2008-11-26 06:52:23.000000000 -0500
@@ -11,6 +11,8 @@ config SUPERH
 	select HAVE_CLK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_TRACE_CLOCK
+	select HAVE_TRACE_CLOCK_32_TO_64
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IOREMAP_PROT if MMU
 	help
Index: linux.trees.git/arch/sh/include/asm/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/sh/include/asm/trace-clock.h	2008-11-26 06:52:23.000000000 -0500
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2007,2008 Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *                         Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * Trace clock definitions for SuperH.
+ */
+
+#ifndef _ASM_SH_TRACE_CLOCK_H
+#define _ASM_SH_TRACE_CLOCK_H
+
+#include <linux/timer.h>
+#include <asm/clock.h>
+
+extern u64 trace_clock_read_synthetic_tsc(void);
+
+static inline u32 trace_clock_get_timestamp32(void)
+{
+	return get_cycles();
+}
+
+static inline u64 trace_clock_get_timestamp64(void)
+{
+	return trace_clock_read_synthetic_tsc();
+}
+
+static inline u64 trace_clock_frequency(void)
+{
+	u64 rate;
+	struct clk *tmu1_clk;
+
+	tmu1_clk = clk_get(NULL, "tmu1_clk");
+	rate = clk_get_rate(tmu1_clk);
+
+	return rate;
+}
+
+static inline u32 trace_clock_freq_scale(void)
+{
+	return 1;
+}
+
+extern void get_synthetic_tsc(void);
+extern void put_synthetic_tsc(void);
+
+static inline void get_trace_clock(void)
+{
+	get_synthetic_tsc();
+}
+
+static inline void put_trace_clock(void)
+{
+	put_synthetic_tsc();
+}
+
+static inline void set_trace_clock_is_sync(int state)
+{
+}
+#endif /* _ASM_SH_TRACE_CLOCK_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
