Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYJTRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYJTRVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYJTRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:05:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753625AbYJTRDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:24 -0400
Message-Id: <20081020170322.785672000@polaris-admin.engr.sgi.com>
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:42 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 23/35] cpumask: deprecate any_online_cpu() in favour of cpumask_any/cpumask_any_and
Content-Disposition: inline; filename=cpumask:deprecate-any_online_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any_online_cpu() is a good name, but it takes a cpumask_t, not a
pointer.

From: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   11 ++++++-----
 lib/cpumask.c           |   12 ------------
 2 files changed, 6 insertions(+), 17 deletions(-)

--- test-compile.orig/include/linux/cpumask.h
+++ test-compile/include/linux/cpumask.h
@@ -109,7 +109,8 @@
  * int cpu_possible(cpu)		Is some cpu possible?
  * int cpu_present(cpu)			Is some cpu present (can schedule)?
  *
- * int any_online_cpu(mask)		First online cpu in mask
+ * int cpumask_any(mask)		Any cpu in mask
+ * int cpumask_any_and(mask1,mask2)	Any cpu in both masks
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
  * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_map
@@ -202,6 +203,7 @@ extern cpumask_t _unused_cpumask_arg_;
 		for_each_cpu_and(cpu, &(mask), &(and))
 #define first_cpu(src)		cpumask_first(&(src))
 #define next_cpu(n, src)	cpumask_next((n), &(src))
+#define any_online_cpu(mask)	cpumask_any_and(&(mask), &cpu_online_map)
 /* End deprecated region. */
 
 static inline void cpumask_set_cpu(int cpu, volatile struct cpumask *dstp)
@@ -387,6 +389,9 @@ static inline void cpumask_copy(struct c
 	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), nr_cpumask_bits);
 }
 
+#define cpumask_any(srcp) cpumask_first(srcp)
+#define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
+
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
  *
@@ -453,7 +458,6 @@ extern cpumask_t cpu_mask_all;
 #define cpumask_first(src)		({ (void)(src); 0; })
 #define cpumask_next(n, src)		({ (void)(src); 1; })
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
-#define any_online_cpu(mask)		0
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
@@ -465,9 +469,6 @@ extern cpumask_t cpu_mask_all;
 int cpumask_first(const cpumask_t *srcp);
 int cpumask_next(int n, const cpumask_t *srcp);
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
-int __any_online_cpu(const cpumask_t *mask);
-
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
 
 #define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
--- test-compile.orig/lib/cpumask.c
+++ test-compile/lib/cpumask.c
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
