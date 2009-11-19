Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZKSJBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZKSJBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZKSJBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:01:12 -0500
Received: from ozlabs.org ([203.10.76.45]:46598 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZKSJBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:01:11 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191931.15379.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:31:15 +1030
Subject: [PATCH 4/6] cpumask: select disabling obsolete cpumask functions on x86
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It currently depends on CONFIG_BROKEN; change to be set by
CONFIG_CPUMASK_OFFSTACK now it all compiles.

We also complete it: the header shouldn't refer to the deprected
CPU_MASK_LAST_WORD, and the deprecated implementations are removed.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |    4 ++--
 include/linux/sched.h   |    2 +-
 lib/Kconfig             |    5 ++++-
 lib/cpumask.c           |    2 ++
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -700,7 +700,7 @@ static inline const struct cpumask *get_
 #if NR_CPUS <= BITS_PER_LONG
 #define CPU_BITS_ALL						\
 {								\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+	[BITS_TO_LONGS(NR_CPUS)-1] = BITMAP_LAST_WORD_MASK(NR_CPUS)	\
 }
 
 #else /* NR_CPUS > BITS_PER_LONG */
@@ -708,7 +708,7 @@ static inline const struct cpumask *get_
 #define CPU_BITS_ALL						\
 {								\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
+	[BITS_TO_LONGS(NR_CPUS)-1] = BITMAP_LAST_WORD_MASK(NR_CPUS)	\
 }
 #endif /* NR_CPUS > BITS_PER_LONG */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,7 +1826,7 @@ static inline int set_cpus_allowed_ptr(s
 }
 #endif
 
-#ifndef CONFIG_CPUMASK_OFFSTACK
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
 	return set_cpus_allowed_ptr(p, &new_mask);
diff --git a/lib/Kconfig b/lib/Kconfig
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -179,6 +179,7 @@ config HAVE_LMB
 
 config CPUMASK_OFFSTACK
 	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	select DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
@@ -186,7 +187,9 @@ config CPUMASK_OFFSTACK
 
 config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
        bool "Disable obsolete cpumask functions" if DEBUG_PER_CPU_MAPS
-       depends on EXPERIMENTAL && BROKEN
+       help
+	 Remove all the definitions of things which are dangerous with
+	 offstack (ie. dynamically allocated) cpumasks.
 
 #
 # Netlink attribute parsing support is select'ed if needed
diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/bootmem.h>
 
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 int __first_cpu(const cpumask_t *srcp)
 {
 	return min_t(int, NR_CPUS, find_first_bit(srcp->bits, NR_CPUS));
@@ -36,6 +37,7 @@ int __any_online_cpu(const cpumask_t *ma
 	return cpu;
 }
 EXPORT_SYMBOL(__any_online_cpu);
+#endif /* CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 
 /**
  * cpumask_next_and - get the next cpu in *src1p & *src2p

