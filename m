Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZCUOPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZCUOPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCUOPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:15:34 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:54403 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZCUOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:15:33 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/1] Restrict definitions of a couple of static functions
Date: Sat, 21 Mar 2009 16:15:22 +0200
Message-Id: <1237644922-7877-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call sites of the static functions free_cache_attributes() and
detect_cache_attributes() in arch/x86/kernel/cpu/intel_cacheinfo.c
are placed under #ifdef CONFIG_SYSFS/#endif, but their definitions
are not. This may produce the following warning:

arch/x86/kernel/cpu/intel_cacheinfo.c:542: warning:
'free_cache_attributes' defined but not used
arch/x86/kernel/cpu/intel_cacheinfo.c:573: warning:
'detect_cache_attributes' defined but not used

This patch fixes the warning by restricting the definitions of the
two functions to the case when CONFIG_SYSFS is enabled.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   64 ++++++++++++++++----------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index da299eb..f04d351 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -538,17 +538,6 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
-static void __cpuinit free_cache_attributes(unsigned int cpu)
-{
-	int i;
-
-	for (i = 0; i < num_cache_leaves; i++)
-		cache_remove_shared_cpu_map(cpu, i);
-
-	kfree(per_cpu(cpuid4_info, cpu));
-	per_cpu(cpuid4_info, cpu) = NULL;
-}
-
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
@@ -569,27 +558,6 @@ static void __cpuinit get_cpu_leaves(void *_retval)
 	}
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
-{
-	int			retval;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	per_cpu(cpuid4_info, cpu) = kzalloc(
-	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(cpuid4_info, cpu) == NULL)
-		return -ENOMEM;
-
-	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
-	if (retval) {
-		kfree(per_cpu(cpuid4_info, cpu));
-		per_cpu(cpuid4_info, cpu) = NULL;
-	}
-
-	return retval;
-}
-
 #ifdef CONFIG_SYSFS
 
 #include <linux/kobject.h>
@@ -840,6 +808,38 @@ static struct kobj_type ktype_percpu_entry = {
 	.sysfs_ops	= &sysfs_ops,
 };
 
+static void __cpuinit free_cache_attributes(unsigned int cpu)
+{
+	int i;
+
+	for (i = 0; i < num_cache_leaves; i++)
+		cache_remove_shared_cpu_map(cpu, i);
+
+	kfree(per_cpu(cpuid4_info, cpu));
+	per_cpu(cpuid4_info, cpu) = NULL;
+}
+
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
+	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
+	if (retval) {
+		kfree(per_cpu(cpuid4_info, cpu));
+		per_cpu(cpuid4_info, cpu) = NULL;
+	}
+
+	return retval;
+}
+
 static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(per_cpu(cache_kobject, cpu));
-- 
1.5.6.3

