Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYLAIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYLAIrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAIr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:47:29 -0500
Received: from ozlabs.org ([203.10.76.45]:34432 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYLAIr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:47:28 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 19:17:22 +1030
Subject: [PATCH 1/1] work_on_cpu: use on PowerPC
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011917.23507.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use work_on_cpu() instead of cpumask games.  (At least they had the
decency to have a FIXME!)

Compile-tested on powerpc (defconfig).

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
 


