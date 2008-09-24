Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYIXQuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYIXQuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYIXQtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:49:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbYIXQti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:49:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, a.p.zijlstra@chello.nl, nico@cam.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2008 17:48:26 +0100
Message-ID: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make use of it
too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/mach-pxa/time.c       |    2 +
 arch/arm/mach-sa1100/generic.c |    2 +
 arch/arm/mach-versatile/core.c |    2 +
 include/linux/cnt32_to_63.h    |   80 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/cnt32_to_63.h


diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 67e1850..b0d6b32 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -17,9 +17,9 @@
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/sched.h>
+#include <linux/cnt32_to_63.h>
 
 #include <asm/div64.h>
-#include <asm/cnt32_to_63.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
 #include <mach/pxa-regs.h>
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 1362994..b422526 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -18,9 +18,9 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>	/* just for sched_clock() - funny that */
 #include <linux/platform_device.h>
+#include <linux/cnt32_to_63.h>
 
 #include <asm/div64.h>
-#include <asm/cnt32_to_63.h>
 #include <mach/hardware.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index d75e795..b638f10 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -28,8 +28,8 @@
 #include <linux/amba/clcd.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/cnt32_to_63.h>
 
-#include <asm/cnt32_to_63.h>
 #include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/io.h>
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
new file mode 100644
index 0000000..8c0f950
--- /dev/null
+++ b/include/linux/cnt32_to_63.h
@@ -0,0 +1,80 @@
+/*
+ *  Extend a 32-bit counter to 63 bits
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	December 3, 2006
+ *  Copyright:	MontaVista Software, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_CNT32_TO_63_H__
+#define __LINUX_CNT32_TO_63_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+/* this is used only to give gcc a clue about good code generation */
+union cnt32_to_63 {
+	struct {
+#if defined(__LITTLE_ENDIAN)
+		u32 lo, hi;
+#elif defined(__BIG_ENDIAN)
+		u32 hi, lo;
+#endif
+	};
+	u64 val;
+};
+
+
+/**
+ * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
+ * @cnt_lo: The low part of the counter
+ *
+ * Many hardware clock counters are only 32 bits wide and therefore have
+ * a relatively short period making wrap-arounds rather frequent.  This
+ * is a problem when implementing sched_clock() for example, where a 64-bit
+ * non-wrapping monotonic value is expected to be returned.
+ *
+ * To overcome that limitation, let's extend a 32-bit counter to 63 bits
+ * in a completely lock free fashion. Bits 0 to 31 of the clock are provided
+ * by the hardware while bits 32 to 62 are stored in memory.  The top bit in
+ * memory is used to synchronize with the hardware clock half-period.  When
+ * the top bit of both counters (hardware and in memory) differ then the
+ * memory is updated with a new value, incrementing it when the hardware
+ * counter wraps around.
+ *
+ * Because a word store in memory is atomic then the incremented value will
+ * always be in synch with the top bit indicating to any potential concurrent
+ * reader if the value in memory is up to date or not with regards to the
+ * needed increment.  And any race in updating the value in memory is harmless
+ * as the same value would simply be stored more than once.
+ *
+ * The only restriction for the algorithm to work properly is that this
+ * code must be executed at least once per each half period of the 32-bit
+ * counter to properly update the state bit in memory. This is usually not a
+ * problem in practice, but if it is then a kernel timer could be scheduled
+ * to manage for this code to be executed often enough.
+ *
+ * Note that the top bit (bit 63) in the returned value should be considered
+ * as garbage.  It is not cleared here because callers are likely to use a
+ * multiplier on the returned value which can get rid of the top bit
+ * implicitly by making the multiplier even, therefore saving on a runtime
+ * clear-bit instruction. Otherwise caller must remember to clear the top
+ * bit explicitly.
+ */
+#define cnt32_to_63(cnt_lo) \
+({ \
+	static volatile u32 __m_cnt_hi; \
+	union cnt32_to_63 __x; \
+	__x.hi = __m_cnt_hi; \
+	__x.lo = (cnt_lo); \
+	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
+		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
+	__x.val; \
+})
+
+#endif

