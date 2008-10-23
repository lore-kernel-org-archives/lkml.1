Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbYJWCV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbYJWCV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYJWCJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:09:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754431AbYJWCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020830.488699000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:47 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 21/35] cpumask: cpumask_first/cpumask_next From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpumask_first-cpumask_next.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer-taking variants of first_cpu/next_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   18 +++++++++---------
 lib/cpumask.c           |   10 +++++-----
 2 files changed, 14 insertions(+), 14 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -46,8 +46,8 @@
  * void cpumask_shift_right(dst, src, n) Shift right
  * void cpumask_shift_left(dst, src, n)	Shift left
  *
- * int first_cpu(mask)			Number lowest set bit, or >= nr_cpu_ids
- * int next_cpu(cpu, mask)		Next cpu past 'cpu', or >= nr_cpu_ids
+ * int cpumask_first(mask)		Number lowest set bit, or >= nr_cpu_ids
+ * int cpumask_next(cpu, mask)		Next cpu past 'cpu', or >= nr_cpu_ids
  *
  * void cpumask_copy(dmask, smask)	dmask = smask
  *
@@ -178,6 +178,8 @@ extern cpumask_t _unused_cpumask_arg_;
 #define for_each_cpu_mask(cpu, mask)	for_each_cpu(cpu, &(mask))
 #define for_each_cpu_mask_and(cpu, mask, and)	\
 		for_each_cpu_and(cpu, &(mask), &(and))
+#define first_cpu(src)		cpumask_first(&(src))
+#define next_cpu(n, src)	cpumask_next((n), &(src))
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -441,8 +443,8 @@ extern cpumask_t cpu_mask_all;
 
 #if NR_CPUS == 1
 
-#define first_cpu(src)			({ (void)(src); 0; })
-#define next_cpu(n, src)		({ (void)(src); 1; })
+#define cpumask_first(src)		({ (void)(src); 0; })
+#define cpumask_next(n, src)		({ (void)(src); 1; })
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
 #define any_online_cpu(mask)		0
 
@@ -453,18 +455,16 @@ extern cpumask_t cpu_mask_all;
 
 #else /* NR_CPUS > 1 */
 
-int __first_cpu(const cpumask_t *srcp);
-int __next_cpu(int n, const cpumask_t *srcp);
+int cpumask_first(const cpumask_t *srcp);
+int cpumask_next(int n, const cpumask_t *srcp);
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
 int __any_online_cpu(const cpumask_t *mask);
 
-#define first_cpu(src)		__first_cpu(&(src))
-#define next_cpu(n, src)	__next_cpu((n), &(src))
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
 
 #define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
-		(cpu) = __next_cpu((cpu), (mask)),	\
+		(cpu) = cpumask_next((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
 #define for_each_cpu_and(cpu, mask, and)				\
 	for ((cpu) = -1;						\
--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -3,21 +3,21 @@
 #include <linux/cpumask.h>
 #include <linux/module.h>
 
-int __first_cpu(const cpumask_t *srcp)
+int cpumask_first(const cpumask_t *srcp)
 {
 	return find_first_bit(cpumask_bits(srcp), nr_cpumask_bits);
 }
-EXPORT_SYMBOL(__first_cpu);
+EXPORT_SYMBOL(cpumask_first);
 
-int __next_cpu(int n, const cpumask_t *srcp)
+int cpumask_next(int n, const cpumask_t *srcp)
 {
 	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
 }
-EXPORT_SYMBOL(__next_cpu);
+EXPORT_SYMBOL(cpumask_next);
 
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp)
 {
-	while ((n = next_cpu(n, *srcp)) < nr_cpu_ids)
+	while ((n = cpumask_next(n, srcp)) < nr_cpu_ids)
 		if (cpumask_test_cpu(n, andp))
 			break;
 	return n;

-- 
