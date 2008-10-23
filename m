Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYJWA64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYJWA64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYJWA5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:57:54 -0400
Received: from ozlabs.org ([203.10.76.45]:40314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYJWA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:57:51 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 23 11:55:16 EST 2008
CC: travis@sgi.com
Subject: [PATCH 5/7] work_on_cpu: use on PowerPC
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <20081023005750.A1F5DDDEF8@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At least they had the decency to have a FIXME.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/sysfs.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff -r 6f4737048b99 arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c	Thu Oct 23 00:06:30 2008 +1100
+++ b/arch/powerpc/kernel/sysfs.c	Thu Oct 23 00:20:57 2008 +1100
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
 

