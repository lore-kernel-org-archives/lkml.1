Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZCFFZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZCFFZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZCFFYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:24:01 -0500
Received: from ozlabs.org ([203.10.76.45]:35501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZCFFX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:23:58 -0500
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 05 Mar 2009 17:27:24 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/10] powerpc: avoid cpumask games in arch/powerpc/kernel/sysfs.c
Message-Id: <20090306052355.A9174DDF6B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't play with current's cpumask

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

Use smp_call_function_single(): this is safe since the oprofile code
already calls ppc_enable_pmcs() with interrupts disabled.  And the
current code is questionable anyway, as it could be preempted.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/powerpc/kernel/sysfs.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -134,36 +134,15 @@ void ppc_enable_pmcs(void)
 }
 EXPORT_SYMBOL(ppc_enable_pmcs);
 
-#if defined(CONFIG_6xx) || defined(CONFIG_PPC64)
-/* XXX convert to rusty's on_one_cpu */
-static unsigned long run_on_cpu(unsigned long cpu,
-			        unsigned long (*func)(unsigned long),
-				unsigned long arg)
-{
-	cpumask_t old_affinity = current->cpus_allowed;
-	unsigned long ret;
-
-	/* should return -EINVAL to userspace */
-	if (set_cpus_allowed(current, cpumask_of_cpu(cpu)))
-		return 0;
-
-	ret = func(arg);
-
-	set_cpus_allowed(current, old_affinity);
-
-	return ret;
-}
-#endif
-
 #define SYSFS_PMCSETUP(NAME, ADDRESS) \
-static unsigned long read_##NAME(unsigned long junk) \
+static long read_##NAME(void *junk) \
 { \
 	return mfspr(ADDRESS); \
 } \
-static unsigned long write_##NAME(unsigned long val) \
+static long write_##NAME(void *val) \
 { \
 	ppc_enable_pmcs(); \
-	mtspr(ADDRESS, val); \
+	mtspr(ADDRESS, (unsigned long)val);	\
 	return 0; \
 } \
 static ssize_t show_##NAME(struct sys_device *dev, \
@@ -171,7 +150,7 @@ static ssize_t show_##NAME(struct sys_de
 			char *buf) \
 { \
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev); \
-	unsigned long val = run_on_cpu(cpu->sysdev.id, read_##NAME, 0); \
+	unsigned long val = work_on_cpu(cpu->sysdev.id, read_##NAME, NULL); \
 	return sprintf(buf, "%lx\n", val); \
 } \
 static ssize_t __used \
@@ -183,7 +162,7 @@ static ssize_t __used \
 	int ret = sscanf(buf, "%lx", &val); \
 	if (ret != 1) \
 		return -EINVAL; \
-	run_on_cpu(cpu->sysdev.id, write_##NAME, val); \
+	work_on_cpu(cpu->sysdev.id, write_##NAME, (void *)val);	\
 	return count; \
 }
 


