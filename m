Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZH0LyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZH0LyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZH0LyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:54:04 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49294 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZH0LyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:54:03 -0400
Date: Thu, 27 Aug 2009 17:23:54 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
	cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
Message-ID: <20090827115354.GC24986@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090827114908.GA24986@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090827114908.GA24986@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-08-27 17:19:08]:

Cpuidle infrastructure assumes pm_idle as the default idle routine.
But, ppc_md.power_save is the default idle callback in case of pSeries.

So, create a more generic, architecture independent cpuidle_pm_idle
function pointer in driver/cpuidle/cpuidle.c and allow the idle routines
of architectures to be set to cpuidle_pm_idle.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c |   12 +++++++-----
 include/linux/cpuidle.h   |    7 +++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -25,6 +25,7 @@ DEFINE_PER_CPU(struct cpuidle_device *, 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
 static void (*pm_idle_old)(void);
+void (*cpuidle_pm_idle)(void);
 
 static int enabled_devices;
 
@@ -98,10 +99,10 @@ static void cpuidle_idle_call(void)
  */
 void cpuidle_install_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
+	if (enabled_devices && (cpuidle_pm_idle != cpuidle_idle_call)) {
 		/* Make sure all changes finished before we switch to new idle */
 		smp_wmb();
-		pm_idle = cpuidle_idle_call;
+		cpuidle_pm_idle = cpuidle_idle_call;
 	}
 }
 
@@ -110,8 +111,9 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
+	if (enabled_devices && pm_idle_old &&
+			(cpuidle_pm_idle != pm_idle_old)) {
+		cpuidle_pm_idle = pm_idle_old;
 		cpuidle_kick_cpus();
 	}
 }
@@ -382,7 +384,7 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
+	pm_idle_old = cpuidle_pm_idle;
 
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -188,4 +188,11 @@ static inline void cpuidle_unregister_go
 #define CPUIDLE_DRIVER_STATE_START	0
 #endif
 
+/*
+ * Idle callback used by cpuidle to call the cpuidle_idle_call().
+ * Platform drivers can use this to register to cpuidle's idle loop.
+ */
+
+extern void (*cpuidle_pm_idle)(void);
+
 #endif /* _LINUX_CPUIDLE_H */
