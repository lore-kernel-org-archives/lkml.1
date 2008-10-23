Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbYJWCQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbYJWCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYJWCIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754567AbYJWCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020830.882924000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:49 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 23/35] cpumask: cpumask_any_but() From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpumask_any_but.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a common case where we want any online cpu except a particular
one.  This creates a helper to do that, otherwise we need a temp var
and cpumask_andnot().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    3 +++
 lib/cpumask.c           |   10 ++++++++++
 2 files changed, 13 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -110,6 +110,7 @@
  *
  * int cpumask_any(mask)		Any cpu in mask
  * int cpumask_any_and(mask1,mask2)	Any cpu in both masks
+ * int cpumask_any_but(mask,cpu)	Any cpu in mask except cpu
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
  * for_each_online_cpu(cpu)		for-loop cpu over cpu_online_map
@@ -451,6 +452,7 @@ extern cpumask_t cpu_mask_all;
 #define cpumask_first(src)		({ (void)(src); 0; })
 #define cpumask_next(n, src)		({ (void)(src); 1; })
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
+#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
@@ -462,6 +464,7 @@ extern cpumask_t cpu_mask_all;
 int cpumask_first(const cpumask_t *srcp);
 int cpumask_next(int n, const cpumask_t *srcp);
 int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
+int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 
 #define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -24,6 +24,16 @@ int cpumask_next_and(int n, const cpumas
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
+int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
+{
+	unsigned int i;
+
+	for_each_cpu(i, mask)
+		if (i != cpu)
+			break;
+	return i;
+}
+
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)

-- 
