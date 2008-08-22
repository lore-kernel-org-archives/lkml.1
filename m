Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYHVUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYHVUT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYHVUTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:19:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbYHVUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:19:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86 MCE: Fix CPU hotplug problem with multiple multicore AMD CPUs
Date: Fri, 22 Aug 2008 22:23:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808222223.10387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

x86 MCE: Fix CPU hotplug problem with multiple multicore AMD CPUs

During CPU hot-remove the sysfs directory created by
threshold_create_bank(), defined in
arch/x86/kernel/cpu/mcheck/mce_amd_64.c, has to be removed before
its parent directory, created by mce_create_device(), defined in
arch/x86/kernel/cpu/mcheck/mce_64.c .  Moreover, when the CPU in
question is hotplugged again, obviously the latter has to be created
before the former.  At present, the right ordering is not enforced,
because all of these operations are carried out by CPU hotplug
notifiers which are not appropriately ordered with respect to each
other.  This leads to serious problems on systems with two or more
multicore AMD CPUs, among other things during suspend and hibernation.

Fix the problem by placing threshold bank CPU hotplug callbacks in
mce_cpu_callback(), so that they are invoked at the right places,
if defined.  Additionally, use kobject_del() to remove the sysfs
directory associated with the kobject created by
kobject_create_and_add() in threshold_create_bank(), to prevent the
kernel from crashing during CPU hotplug operations on systems with
two or more multicore AMD CPUs.

This patch fixes bug #11337.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Andi Kleen <andi@firstfloor.org>
Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c     |    5 +++++
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   18 +++++-------------
 include/asm-x86/mce.h                   |    1 +
 3 files changed, 11 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -759,6 +759,7 @@ static struct sysdev_class mce_sysclass 
 };
 
 DEFINE_PER_CPU(struct sys_device, device_mce);
+void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu) __cpuinitdata;
 
 /* Why are there no generic functions for this? */
 #define ACCESSOR(name, var, start) \
@@ -883,9 +884,13 @@ static int __cpuinit mce_cpu_callback(st
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		mce_create_device(cpu);
+		if (threshold_cpu_callback)
+			threshold_cpu_callback(action, cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		if (threshold_cpu_callback)
+			threshold_cpu_callback(action, cpu);
 		mce_remove_device(cpu);
 		break;
 	}
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -628,6 +628,7 @@ static void threshold_remove_bank(unsign
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
+	kobject_del(b->kobj);
 	kobject_put(b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
@@ -645,14 +646,11 @@ static void threshold_remove_device(unsi
 }
 
 /* get notified when a cpu comes on/off */
-static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
-					    unsigned long action, void *hcpu)
+static void __cpuinit amd_64_threshold_cpu_callback(unsigned long action,
+                                                    unsigned int cpu)
 {
-	/* cpu was unsigned int to begin with */
-	unsigned int cpu = (unsigned long)hcpu;
-
 	if (cpu >= NR_CPUS)
-		goto out;
+		return;
 
 	switch (action) {
 	case CPU_ONLINE:
@@ -666,14 +664,8 @@ static int __cpuinit threshold_cpu_callb
 	default:
 		break;
 	}
-      out:
-	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier __cpuinitdata = {
-	.notifier_call = threshold_cpu_callback,
-};
-
 static __init int threshold_init_device(void)
 {
 	unsigned lcpu = 0;
@@ -684,7 +676,7 @@ static __init int threshold_init_device(
 		if (err)
 			return err;
 	}
-	register_hotcpu_notifier(&threshold_cpu_notifier);
+	threshold_cpu_callback = amd_64_threshold_cpu_callback;
 	return 0;
 }
 
Index: linux-2.6/include/asm-x86/mce.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mce.h
+++ linux-2.6/include/asm-x86/mce.h
@@ -92,6 +92,7 @@ extern int mce_disabled;
 
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, device_mce);
+extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 #ifdef CONFIG_X86_MCE_INTEL
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
