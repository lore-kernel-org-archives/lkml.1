Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYLaNLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYLaNLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYLaNKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:10:53 -0500
Received: from ozlabs.org ([203.10.76.45]:42052 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYLaNKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:10:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] work_on_cpu: use on PowerPC
Date: Wed, 31 Dec 2008 23:40:43 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812011917.23507.rusty@rustcorp.com.au>
In-Reply-To: <200812011917.23507.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812312340.44056.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008 19:17:22 Rusty Russell wrote:
> Use work_on_cpu() instead of cpumask games.  (At least they had the
> decency to have a FIXME!)
> 
> Compile-tested on powerpc (defconfig).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Hmm, I didn't see this in Linus' tree.  No urgency, but just a reminder.

Subject: work_on_cpu: use on PowerPC

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
 
