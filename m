Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYLPC3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYLPC3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYLPCY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:28 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40567 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbYLPCYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:15 -0500
Message-Id: <20081216022411.603858000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:22 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 13/16] x86: Remove cpumask games in x86/kernel/cpu/intel_cacheinfo.c
Content-Disposition: inline; filename=0017-x86-Remove-cpumask-games-in-x86-kernel-cpu-intel_ca.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove cpumask_t from stack.

We should not try to save and restore cpus_allowed on current.

We can't use work_on_cpu() here, since it's in the hotplug cpu path
(if anyone else tries to get the hotplug lock from a workqueue we
could deadlock against them).

Fortunately, we can just use smp_call_function_single() since the
function can run from an interrupt.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   41 +++++++++++++++-----------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 43ea612..fb7f946 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -534,31 +534,16 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
+static void get_cpu_leaves(void *_retval)
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
+	int j, *retval = _retval, cpu = smp_processor_id();
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
+		struct _cpuid4_info *this_leaf;
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
-		retval = cpuid4_cache_lookup(j, this_leaf);
-		if (unlikely(retval < 0)) {
+		*retval = cpuid4_cache_lookup(j, this_leaf);
+		if (unlikely(*retval < 0)) {
 			int i;
 
 			for (i = 0; i < j; i++)
@@ -567,9 +552,21 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed_ptr(current, &oldmask);
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
 
-out:
+	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
 	if (retval) {
 		kfree(per_cpu(cpuid4_info, cpu));
 		per_cpu(cpuid4_info, cpu) = NULL;
-- 
1.6.0

-- 
