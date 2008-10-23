Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJWCMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJWCMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYJWCIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46610 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754033AbYJWCI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:29 -0400
Message-Id: <20081023020828.875558000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:39 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/35] cpumask: make nr_cpu_ids valid in all configurations. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:always-have-nr_cpu_ids.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_cpu_ids is the (badly named) runtime limit on possible CPU numbers;
ie. the variable version of NR_CPUS.

This makes is valid in all configs, including UP.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    9 +++++++--
 init/main.c             |    7 +++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -190,6 +190,13 @@ extern cpumask_t _unused_cpumask_arg_;
 #define cpus_addr(src) ((src).bits)
 /* End deprecated region. */
 
+#if NR_CPUS > 1
+/* Starts at NR_CPUS until we know better. */
+extern int nr_cpu_ids;
+#else
+#define nr_cpu_ids	NR_CPUS
+#endif
+
 static inline void cpumask_set_cpu(int cpu, volatile struct cpumask *dstp)
 {
 	set_bit(cpu, dstp->bits);
@@ -429,7 +436,6 @@ extern cpumask_t cpu_mask_all;
 
 #if NR_CPUS == 1
 
-#define nr_cpu_ids			1
 #define first_cpu(src)			({ (void)(src); 0; })
 #define next_cpu(n, src)		({ (void)(src); 1; })
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
@@ -442,7 +448,6 @@ extern cpumask_t cpu_mask_all;
 
 #else /* NR_CPUS > 1 */
 
-extern int nr_cpu_ids;
 int __first_cpu(const cpumask_t *srcp);
 int __next_cpu(int n, const cpumask_t *srcp);
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
--- linux-2.6.28.orig/init/main.c
+++ linux-2.6.28/init/main.c
@@ -374,6 +374,8 @@ EXPORT_SYMBOL(cpu_mask_all);
 #endif
 
 /* Setup number of possible processor ids */
+/* nr_cpu_ids is a real variable for SMP. */
+#ifndef nr_cpu_ids
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
@@ -387,6 +389,11 @@ static void __init setup_nr_cpu_ids(void
 
 	nr_cpu_ids = highest_cpu + 1;
 }
+#else
+void __init setup_nr_cpu_ids(void)
+{
+}
+#endif /* ... nr_cpu_ids is a constant. */
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;

-- 
