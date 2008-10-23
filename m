Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYJWCM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYJWCM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYJWCIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46588 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752585AbYJWCI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:29 -0400
Message-Id: <20081023020829.077394000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:40 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/35] cpumask: add nr_cpumask_bits
Content-Disposition: inline; filename=cpumask:add-nr_cpumask_bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nr_cpu_ids is set to CONFIG_NR_CPUS then references to nr_cpu_ids
will return the maximum index of the configured NR_CPUS (+1) instead
of the maximum index of the possible number of cpus (+1).  This results
in extra unused memory being allocated by functions that are setting up
arrays of structs to keep track of per cpu items.

Since we do want to keep the ability to use constants for the cpu bit
operators on smaller systems (which are generally much faster assembler
ops), we introduce a separate "nr_cpumask_bits" to replace "nr_cpu_ids"
only for the inline assembly ops.  This will be a constant when
CONFIG_CPUMASK_OFFSTACK is undefined and a variable when it is defined.

Thus "nr_cpu_ids" reverts back to being a variable representing the
maximum possible cpu (+1), except in the non-SMP case where it is a
constant value of 1.  The relationship between the related variables
and constants is: (1 <= nr_cpu_ids <= nr_cpumask_bits <= NR_CPUS).

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |    7 ++++---
 include/linux/cpumask.h        |    8 ++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- linux-2.6.28.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.28/arch/x86/kernel/setup_percpu.c
@@ -155,6 +155,10 @@ void __init setup_per_cpu_areas(void)
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
+	printk(KERN_DEBUG
+		"NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
+
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 		ptr = __alloc_bootmem(size, align,
@@ -183,9 +187,6 @@ void __init setup_per_cpu_areas(void)
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
-
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -197,6 +197,14 @@ extern int nr_cpu_ids;
 #define nr_cpu_ids	NR_CPUS
 #endif
 
+/* The number of bits to hand to the bitmask ops. */
+#if NR_CPUS <= BITS_PER_LONG
+/* This produces more efficient code. */
+#define nr_cpumask_bits	NR_CPUS
+#else
+#define nr_cpumask_bits nr_cpu_ids
+#endif
+
 static inline void cpumask_set_cpu(int cpu, volatile struct cpumask *dstp)
 {
 	set_bit(cpu, dstp->bits);

-- 
