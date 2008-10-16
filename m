Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYJPX42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYJPX42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYJPXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48768 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYJPXz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:27 -0400
Message-Id: <20081016234657.052698980@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC patch 10/15] LTTng timestamp mips
Content-Disposition: inline; filename=lttng-timestamp-mips.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS get_cycles only returns a 32 bits TSC (see timex.h). The assumption there
is that the reschedule is done every 8 seconds or so. Given that tracing needs
to detect delays longer than 8 seconds, we need a full 64-bits TSC, whic is
provided by LTTng syntheric TSC.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/Kconfig      |    2 ++
 include/asm-mips/ltt.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

Index: linux-2.6-lttng/include/asm-mips/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-mips/ltt.h	2008-10-16 19:18:48.000000000 -0400
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2005, Mathieu Desnoyers
+ *
+ * MIPS definitions for tracing system
+ */
+
+#ifndef _ASM_MIPS_LTT_H
+#define _ASM_MIPS_LTT_H
+
+#include <linux/timex.h>
+#include <asm/processor.h>
+
+extern u64 ltt_read_synthetic_tsc(void);
+
+/*
+ * MIPS get_cycles only returns a 32 bits TSC (see timex.h). The assumption
+ * there is that the reschedule is done every 8 seconds or so. Given that
+ * tracing needs to detect delays longer than 8 seconds, we need a full 64-bits
+ * TSC, whic is provided by LTTng syntheric TSC.
+*/
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
+	return mips_hpt_frequency;
+}
+
+static inline u32 ltt_freq_scale(void)
+{
+	return 1;
+}
+
+#endif /* _ASM_MIPS_LTT_H */
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2008-10-16 19:14:08.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2008-10-16 19:16:49.000000000 -0400
@@ -1584,6 +1584,8 @@ config CPU_R4400_WORKAROUNDS
 config HAVE_GET_CYCLES_32
 	def_bool y
 	depends on !CPU_R4400_WORKAROUNDS
+	select HAVE_LTT_CLOCK
+	select HAVE_LTT_SYNTHETIC_TSC
 
 #
 # Use the generic interrupt handling code in kernel/irq/:

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
