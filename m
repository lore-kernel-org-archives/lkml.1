Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYGYBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYGYBVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYGYBVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:21:31 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753554AbYGYBVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:21:30 -0400
Message-Id: <20080725012129.794865000@polaris-admin.engr.sgi.com>
References: <20080725012128.805332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jul 2008 18:21:30 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpumask: Put cpumask_of_cpu_map in the initdata section
Content-Disposition: inline; filename=make-cpumask_map-initdata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Create the cpumask_of_cpu_map statically in the init data section
    using NR_CPUS but replace it during boot up with one sized by
    nr_cpu_ids (num possible cpus).

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |   10 ++++++----
 kernel/cpu.c                   |    8 +++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -81,10 +81,12 @@ static void __init setup_per_cpu_maps(vo
 }
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
-EXPORT_SYMBOL(cpumask_of_cpu_map);
-
-/* requires nr_cpu_ids to be initialized */
+/*
+ * Replace static cpumask_of_cpu_map in the initdata section,
+ * with one that's allocated sized by the possible number of cpus.
+ *
+ * (requires nr_cpu_ids to be initialized)
+ */
 static void __init setup_cpumask_of_cpu(void)
 {
 	int i;
--- linux-2.6.tip.orig/kernel/cpu.c
+++ linux-2.6.tip/kernel/cpu.c
@@ -457,7 +457,6 @@ out:
 
 #endif /* CONFIG_SMP */
 
-#ifndef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
 /* 64 bits of zeros, for initializers. */
 #if BITS_PER_LONG == 32
 #define Z64 0, 0
@@ -507,7 +506,11 @@ out:
 
 /* We want this statically initialized, just to be safe.  We try not
  * to waste too much space, either. */
-static const cpumask_t cpumask_map[] = {
+static const cpumask_t cpumask_map[]
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+__initdata
+#endif
+= {
 	CMI0(0), CMI0(1), CMI0(2), CMI0(3),
 #if NR_CPUS > 4
 	CMI0(4), CMI0(5), CMI0(6), CMI0(7),
@@ -567,4 +570,3 @@ static const cpumask_t cpumask_map[] = {
 };
 
 const cpumask_t *cpumask_of_cpu_map = cpumask_map;
-#endif /* !CONFIG_HAVE_CPUMASK_OF_CPU_MAP */

-- 
