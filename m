Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZCFGsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZCFGsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZCFGrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:56769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbZCFGrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:01 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] percpu: clean up percpu constants
Date: Fri,  6 Mar 2009 15:46:21 +0900
Message-Id: <1236321988-19457-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleaup

Make the following cleanups.

* There isn't much arch-specific about PERCPU_MODULE_RESERVE.  Always
  define it whether arch overrides PERCPU_ENOUGH_ROOM or not.

* blackfin overrides PERCPU_ENOUGH_ROOM to align static area size.  Do
  it by default.

* percpu allocation sizes doesn't have much to do with the page size.
  Don't use PAGE_SHIFT in their definition.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/percpu.h |   10 ----------
 include/linux/percpu.h             |   24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/include/asm/percpu.h b/arch/blackfin/include/asm/percpu.h
index 797c0c1..c94c7bc 100644
--- a/arch/blackfin/include/asm/percpu.h
+++ b/arch/blackfin/include/asm/percpu.h
@@ -3,14 +3,4 @@
 
 #include <asm-generic/percpu.h>
 
-#ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE 8192
-#else
-#define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
-
 #endif	/* __ARCH_BLACKFIN_PERCPU__ */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 545b068..2d34b03 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -5,6 +5,7 @@
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/cpumask.h>
+#include <linux/pfn.h>
 
 #include <asm/percpu.h>
 
@@ -52,17 +53,18 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
-/* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
-#ifndef PERCPU_ENOUGH_ROOM
+/* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE	8192
+#define PERCPU_MODULE_RESERVE		(8 << 10)
 #else
-#define PERCPU_MODULE_RESERVE	0
+#define PERCPU_MODULE_RESERVE		0
 #endif
 
+#ifndef PERCPU_ENOUGH_ROOM
 #define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
-#endif	/* PERCPU_ENOUGH_ROOM */
+	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) +	\
+	 PERCPU_MODULE_RESERVE)
+#endif
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
@@ -79,7 +81,7 @@
 #ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
 
 /* minimum unit size, also is the maximum supported allocation size */
-#define PCPU_MIN_UNIT_SIZE		(16UL << PAGE_SHIFT)
+#define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(64 << 10)
 
 /*
  * PERCPU_DYNAMIC_RESERVE indicates the amount of free area to piggy
@@ -96,15 +98,15 @@
 #ifndef PERCPU_DYNAMIC_RESERVE
 #  if BITS_PER_LONG > 32
 #    ifdef CONFIG_MODULES
-#      define PERCPU_DYNAMIC_RESERVE	(6 << PAGE_SHIFT)
+#      define PERCPU_DYNAMIC_RESERVE	(24 << 10)
 #    else
-#      define PERCPU_DYNAMIC_RESERVE	(4 << PAGE_SHIFT)
+#      define PERCPU_DYNAMIC_RESERVE	(16 << 10)
 #    endif
 #  else
 #    ifdef CONFIG_MODULES
-#      define PERCPU_DYNAMIC_RESERVE	(4 << PAGE_SHIFT)
+#      define PERCPU_DYNAMIC_RESERVE	(16 << 10)
 #    else
-#      define PERCPU_DYNAMIC_RESERVE	(2 << PAGE_SHIFT)
+#      define PERCPU_DYNAMIC_RESERVE	(8 << 10)
 #    endif
 #  endif
 #endif	/* PERCPU_DYNAMIC_RESERVE */
-- 
1.6.0.2

