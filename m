Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZK3AKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZK3AKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 19:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZK3AKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 19:10:07 -0500
Received: from ozlabs.org ([203.10.76.45]:48915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZK3AKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 19:10:06 -0500
Date: Mon, 30 Nov 2009 11:05:32 +1100
From: Anton Blanchard <anton@samba.org>
To: rusty@rustcorp.com.au, mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Fix isolcpus boot option
Message-ID: <20091130000532.GW32182@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We allocate and zero cpu_isolated_map after the isolcpus __setup option
has run. This means cpu_isolated_map always ends up empty and if
CPUMASK_OFFSTACK is enabled we write to a cpumask that hasn't been
allocated.

To keep the fix to a minimum this patch stores a pointer to the cmdline
option and parses it after we allocate and zero the cpumask.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Might be worth moving cpu_isolated_map into kernel/cpu.c and treat it
like the other cpu masks but I figured that change would have trouble
making 2.6.32. Thoughts?

Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c	2009-11-28 09:35:29.000000000 +1100
+++ linux.trees.git/kernel/sched.c	2009-11-28 21:50:44.000000000 +1100
@@ -8098,10 +8098,14 @@ cpu_attach_domain(struct sched_domain *s
 /* cpus with isolated domains */
 static cpumask_var_t cpu_isolated_map;
 
-/* Setup the mask of cpus configured for isolated domains */
+/*
+ * Since it's too early to allocate cpu_isolated_map we just store
+ * a pointer to the parameter and allocate and initialize it in sched_init
+ */
+static __initdata char *isolated_cpu_str;
 static int __init isolated_cpu_setup(char *str)
 {
-	cpulist_parse(str, cpu_isolated_map);
+	isolated_cpu_str = str;
 	return 1;
 }
 
@@ -9650,6 +9654,7 @@ void __init sched_init(void)
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
 	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	cpulist_parse(isolated_cpu_str, cpu_isolated_map);
 #endif /* SMP */
 
 	perf_event_init();
