Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYJWCU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYJWCU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYJWCJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:09:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43382 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754547AbYJWCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020830.685972000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:48 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 22/35] cpumask: deprecate any_online_cpu() in favour of cpumask_any/cpumask_any_and From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:deprecate-any_online_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any_online_cpu() is a good name, but it takes a cpumask_t, not a
pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   11 ++++++-----
 lib/cpumask.c           |   12 ------------
 2 files changed, 6 insertions(+), 17 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -108,7 +108,8 @@
  * int cpu_possible(cpu)		Is some cpu possible?
  * int cpu_present(cpu)			Is some cpu present (can schedule)?
  *
- * int any_online_cpu(mask)		First online cpu in mask
+ * int cpumask_any(mask)		Any cpu in mask
+ * int cpumask_any_and(mask1,mask2)	Any cpu in both masks
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
  * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_map
@@ -180,6 +181,7 @@ extern cpumask_t _unused_cpumask_arg_;
 		for_each_cpu_and(cpu, &(mask), &(and))
 #define first_cpu(src)		cpumask_first(&(src))
 #define next_cpu(n, src)	cpumask_next((n), &(src))
+#define any_online_cpu(mask)	cpumask_any_and(&(mask), &cpu_online_map)
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -380,6 +382,9 @@ static inline void cpumask_copy(struct c
 	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), nr_cpumask_bits);
 }
 
+#define cpumask_any(srcp) cpumask_first(srcp)
+#define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
+
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
  *
@@ -446,7 +451,6 @@ extern cpumask_t cpu_mask_all;
 #define cpumask_first(src)		({ (void)(src); 0; })
 #define cpumask_next(n, src)		({ (void)(src); 1; })
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
-#define any_online_cpu(mask)		0
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
@@ -458,9 +462,6 @@ extern cpumask_t cpu_mask_all;
 int cpumask_first(const cpumask_t *srcp);
 int cpumask_next(int n, const cpumask_t *srcp);
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
-int __any_online_cpu(const cpumask_t *mask);
-
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
 
 #define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -24,18 +24,6 @@ int cpumask_next_and(int n, const cpumas
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
-int __any_online_cpu(const cpumask_t *mask)
-{
-	int cpu;
-
-	for_each_cpu(cpu, mask) {
-		if (cpu_online(cpu))
-			break;
-	}
-	return cpu;
-}
-EXPORT_SYMBOL(__any_online_cpu);
-
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)

-- 
