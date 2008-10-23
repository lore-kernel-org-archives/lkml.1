Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYJWA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYJWA7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYJWA5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:57:55 -0400
Received: from ozlabs.org ([203.10.76.45]:40316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYJWA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:57:51 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 23 11:55:16 EST 2008
CC: travis@sgi.com
Subject: [PATCH 6/7] work_on_cpu: use on x86/kernel/cpu/intel_cacheinfo.c
Cc: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081023005750.D0A11DDEF9@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple transition to work_on_cpu(), rather than cpumask games.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   38 ++++++++++++++++------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -r 6f4737048b99 arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c	Thu Oct 23 00:06:30 2008 +1100
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c	Thu Oct 23 00:20:57 2008 +1100
@@ -534,28 +534,13 @@ static void __cpuinit free_cache_attribu
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
+static long get_cpu_leaves(void *unused)
 {
-	struct _cpuid4_info	*this_leaf;
-	unsigned long		j;
-	int			retval;
-	cpumask_t		oldmask;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	per_cpu(cpuid4_info, cpu) = kzalloc(
-	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(cpuid4_info, cpu) == NULL)
-		return -ENOMEM;
-
-	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (retval)
-		goto out;
+	int j, retval = 0, cpu = smp_processor_id();
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
+		struct _cpuid4_info *this_leaf;
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
 		retval = cpuid4_cache_lookup(j, this_leaf);
 		if (unlikely(retval < 0)) {
@@ -567,9 +552,22 @@ static int __cpuinit detect_cache_attrib
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed_ptr(current, &oldmask);
+	return retval;
+}
 
-out:
+static int __cpuinit detect_cache_attributes(unsigned int cpu)
+{
+	int			retval;
+
+	if (num_cache_leaves == 0)
+		return -ENOENT;
+
+	per_cpu(cpuid4_info, cpu) = kzalloc(
+	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
+	if (per_cpu(cpuid4_info, cpu) == NULL)
+		return -ENOMEM;
+
+	retval = work_on_cpu(cpu, get_cpu_leaves, NULL);
 	if (retval) {
 		kfree(per_cpu(cpuid4_info, cpu));
 		per_cpu(cpuid4_info, cpu) = NULL;

