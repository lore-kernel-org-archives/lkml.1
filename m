Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYGAMQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYGAMQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYGAMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:16:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59683 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727AbYGAMQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:16:35 -0400
Message-Id: <20080701121635.056353000@polaris-admin.engr.sgi.com>
References: <20080701121634.865966000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Jul 2008 05:16:35 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC 1/5] x86_64: Fix early references to cpumask_of_cpu
Content-Disposition: inline; filename=cleanup_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Initialize the cpumask_of_cpu_map to contain a cpumask for cpu 0
    in the initdata section.  This allows references before the real
    cpumask_of_cpu_map is setup avoiding possible null pointer deref
    panics.

Based on linux-2.6.tip/master

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -51,7 +51,7 @@ static void __init setup_node_to_cpumask
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -81,16 +81,25 @@ static void __init setup_per_cpu_maps(vo
 }
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
+
+/* Configure an initial cpumask_of_cpu(0) for early users */
+static cpumask_t initial_cpumask_of_cpu_map __initdata = (cpumask_t) { {
+	[BITS_TO_LONGS(NR_CPUS)-1] = 1
+} };
+cpumask_t *cpumask_of_cpu_map __read_mostly =
+	(cpumask_t *)&initial_cpumask_of_cpu_map;
 EXPORT_SYMBOL(cpumask_of_cpu_map);
 
-/* requires nr_cpu_ids to be initialized */
+/* Requires nr_cpu_ids to be initialized */
 static void __init setup_cpumask_of_cpu(void)
 {
 	int i;
 
 	/* alloc_bootmem zeroes memory */
 	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	printk(KERN_DEBUG "cpumask_of_cpu_map %p\n", cpumask_of_cpu_map);
+#endif
 	for (i = 0; i < nr_cpu_ids; i++)
 		cpu_set(i, cpumask_of_cpu_map[i]);
 }

-- 
