Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXCCDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXCCDKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992957AbXCCDKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:10:32 -0500
Received: from mail.queued.net ([207.210.101.209]:1756 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992956AbXCCDKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:10:32 -0500
Message-ID: <45E8E729.2040906@debian.org>
Date: Fri, 02 Mar 2007 22:10:33 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH]: i386: make x86_64 tsc header require i386 rather than vice-versa
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------080604070806090707090809"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080604070806090707090809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Prior to commit 95492e4646e5de8b43d9a7908d6177fb737b61f0  ([PATCH] x86:
rewrite SMP TSC sync code), the headers in asm-i386 did not really
require anything in include/asm-x86_64.  This means that distributions
such as fedora did not include asm-x86_64 in kernel-devel headers for
i386.  Ingo's commit changed that, and broke things.  This is easy
enough to hack around in package builds by just including asm-x86_64 on
i386, but that's kind of annoying.  If anything, x86_64 should depend
upon i386, not the other way around.

This patch changes it so that asm-x86_64/tsc.h includes asm-i386/tsc.h,
rather than vice-versa.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------080604070806090707090809
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index e997891..6207fc0 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -1 +1,66 @@
-#include <asm-x86_64/tsc.h>
+/*
+ * linux/include/asm-i386/tsc.h
+ *
+ * x86 TSC related functions
+ */
+#ifndef _ASM_i386_TSC_H
+#define _ASM_i386_TSC_H
+
+#include <asm/processor.h>
+
+/*
+ * Standard way to access the cycle counter.
+ */
+typedef unsigned long long cycles_t;
+
+extern unsigned int cpu_khz;
+extern unsigned int tsc_khz;
+
+static inline cycles_t get_cycles(void)
+{
+	unsigned long long ret = 0;
+
+#ifndef CONFIG_X86_TSC
+	if (!cpu_has_tsc)
+		return 0;
+#endif
+
+#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
+	rdtscll(ret);
+#endif
+	return ret;
+}
+
+/* Like get_cycles, but make sure the CPU is synchronized. */
+static __always_inline cycles_t get_cycles_sync(void)
+{
+	unsigned long long ret;
+#ifdef X86_FEATURE_SYNC_RDTSC
+	unsigned eax;
+
+	/*
+	 * Don't do an additional sync on CPUs where we know
+	 * RDTSC is already synchronous:
+	 */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+#else
+	sync_core();
+#endif
+	rdtscll(ret);
+
+	return ret;
+}
+
+extern void tsc_init(void);
+extern void mark_tsc_unstable(void);
+extern int unsynchronized_tsc(void);
+
+/*
+ * Boot-time check whether the TSCs are synchronized across
+ * all CPUs/cores:
+ */
+extern void check_tsc_sync_source(int cpu);
+extern void check_tsc_sync_target(void);
+
+#endif
diff --git a/include/asm-x86_64/tsc.h b/include/asm-x86_64/tsc.h
index 9a0a368..d66ba6e 100644
--- a/include/asm-x86_64/tsc.h
+++ b/include/asm-x86_64/tsc.h
@@ -1,66 +1 @@
-/*
- * linux/include/asm-x86_64/tsc.h
- *
- * x86_64 TSC related functions
- */
-#ifndef _ASM_x86_64_TSC_H
-#define _ASM_x86_64_TSC_H
-
-#include <asm/processor.h>
-
-/*
- * Standard way to access the cycle counter.
- */
-typedef unsigned long long cycles_t;
-
-extern unsigned int cpu_khz;
-extern unsigned int tsc_khz;
-
-static inline cycles_t get_cycles(void)
-{
-	unsigned long long ret = 0;
-
-#ifndef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		return 0;
-#endif
-
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
-	rdtscll(ret);
-#endif
-	return ret;
-}
-
-/* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t get_cycles_sync(void)
-{
-	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
-	unsigned eax;
-
-	/*
-	 * Don't do an additional sync on CPUs where we know
-	 * RDTSC is already synchronous:
-	 */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-#else
-	sync_core();
-#endif
-	rdtscll(ret);
-
-	return ret;
-}
-
-extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
-extern int unsynchronized_tsc(void);
-
-/*
- * Boot-time check whether the TSCs are synchronized across
- * all CPUs/cores:
- */
-extern void check_tsc_sync_source(int cpu);
-extern void check_tsc_sync_target(void);
-
-#endif
+#include <asm-i386/tsc.h>

--------------080604070806090707090809--
