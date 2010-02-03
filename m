Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0BCQP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:15:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64971 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757358Ab0BCQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:15:57 -0500
Subject: [RFC PATCH] ARM: Change the mandatory barriers implementation
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tony Lindgren <tony@atomide.com>, Larry Bassel <lbassel@quicinc.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>
Date: Wed, 03 Feb 2010 16:15:34 +0000
Message-ID: <20100203161434.15912.42697.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-36-g53e3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2010 16:15:34.0742 (UTC) FILETIME=[1D7C8F60:01CAA4EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  (I cc'ed LKML as well just in case I got the wrong semantics of the
  mandatory barriers)

The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
systems for things like ordering Normal Non-cacheable memory accesses
with DMA transfer (via Device memory writes). The current implementation
uses dmb() for mb() and friends but this is not sufficient. The DMB only
ensures the ordering of accesses with regards to a single observer
accessing the same memory. If a DMA transfer is started by a write to
Device memory, the data to be transfered may not reach the main memory
(even if mapped as Normal Non-cacheable) before the device receives the
notification to begin the transfer. The only barrier that would help in
this situation is DSB which would completely drain the write buffers.

The patch also adds support for platform-defined barriers that can be
defined in mach/barriers.h. This is required by at least two platforms -
MSM and RealView (possible OMAP as well). On RealView with an outer
cache (PL310 for example) stores to Normal Non-cacheable memory are
buffered by the outer cache but the DSB doesn't go as far as this. A
separate L2x0 sync command is required (a store to Strongly Ordered
memory would do as well, similar to the MSM requirements and maybe
faster).

Note that the SMP barriers are not affected as they only deal with
ordering in Normal memory. There is however a situation with the use of
IPIs. A DMB is not enough to ensure that a write to Normal memory is
strictly ordered with respect to the IPI generation (and interrupt
handling). A solution is for the users of smp_call_function() to use a
mandatory barrier.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@codeaurora.org>
Cc: Larry Bassel <lbassel@quicinc.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/include/asm/system.h |   18 ++++++++----------
 arch/arm/mm/Kconfig           |    6 ++++++
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 058e7e9..477861d 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -138,14 +138,12 @@ extern unsigned int user_debug;
 #define dmb() __asm__ __volatile__ ("" : : : "memory")
 #endif
 
-#if __LINUX_ARM_ARCH__ >= 7 || defined(CONFIG_SMP)
-#define mb()		dmb()
-#define rmb()		dmb()
-#define wmb()		dmb()
+#ifdef CONFIG_ARCH_HAS_BARRIERS
+#include <mach/barriers.h>
 #else
-#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#define mb()		dsb()
+#define rmb()		dmb()
+#define wmb()		dsb()
 #endif
 
 #ifndef CONFIG_SMP
@@ -153,9 +151,9 @@ extern unsigned int user_debug;
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #else
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
+#define smp_mb()	dmb()
+#define smp_rmb()	dmb()
+#define smp_wmb()	dmb()
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index f62beb7..f67f2c4 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -802,3 +802,9 @@ config ARM_L1_CACHE_SHIFT
 	int
 	default 6 if ARCH_OMAP3 || ARCH_S5PC1XX
 	default 5
+
+config ARCH_HAS_BARRIERS
+	bool
+	help
+	  This option allows the use of custom mandatory barriers
+	  included via the mach/barriers.h file.

