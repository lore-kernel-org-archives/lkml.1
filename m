Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbZHSM6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbZHSM6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZHSM6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:58:43 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44146 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZHSM6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:58:42 -0400
Date: Wed, 19 Aug 2009 18:28:36 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/2]: pSeries: Enable cpuidle for pSeries.
Message-ID: <20090819125836.GB20627@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090819125716.GA20627@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090819125716.GA20627@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-08-19 18:27:16]:

This patch enables the cpuidle option in Kconfig for pSeries.
It also adds the routine cpu_idle_wait.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig                   |   18 ++++++++++++++++++
 arch/powerpc/include/asm/system.h      |    2 ++
 arch/powerpc/platforms/pseries/setup.c |   20 ++++++++++++++++++++
 drivers/cpuidle/cpuidle.c              |    1 +
 4 files changed, 41 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -88,6 +88,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
+config ARCH_HAS_CPU_IDLE_WAIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -243,6 +246,21 @@ source "kernel/Kconfig.freezer"
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
+menu "Power management options"
+
+source "drivers/cpuidle/Kconfig"
+
+config TPMD
+	tristate "TPMD power management support"
+	depends on PPC_PSERIES && CPU_IDLE
+	default y
+	help
+	  Thermal and Power Management Devices (TPMD). This hooks onto cpuidle
+	  infrastructure to help in idle cpu power management. Currently this
+	  is enabled only for pSeries.
+
+endmenu
+
 menu "Kernel options"
 
 config HIGHMEM
Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -17,6 +17,7 @@
 #include <linux/cpuidle.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <linux/pm.h>
 
 #include "cpuidle.h"
 
Index: linux.trees.git/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/setup.c
+++ linux.trees.git/arch/powerpc/platforms/pseries/setup.c
@@ -278,6 +278,26 @@ static struct notifier_block pci_dn_reco
 	.notifier_call = pci_dn_reconfig_notifier,
 };
 
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
+void cpu_idle_wait(void)
+{
+	smp_mb();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 static void __init pSeries_setup_arch(void)
 {
 	/* Discover PIC type and setup ppc_md accordingly */
Index: linux.trees.git/arch/powerpc/include/asm/system.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/system.h
+++ linux.trees.git/arch/powerpc/include/asm/system.h
@@ -546,5 +546,7 @@ extern void account_system_vtime(struct 
 
 extern struct dentry *powerpc_debugfs_root;
 
+void cpu_idle_wait(void);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SYSTEM_H */
