Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZLBKA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZLBKA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZLBKA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:00:27 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52554 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZLBKA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:00:26 -0500
Date: Wed, 2 Dec 2009 15:30:24 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v10 PATCH 5/9]: POWER: enable cpuidle for POWER.
Message-ID: <20091202100024.GF27251@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091202095427.GA27251@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091202095427.GA27251@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-12-02 15:24:27]:

This patch enables the cpuidle option in Kconfig for pSeries.

Currently cpuidle infrastructure is enabled only for x86 and ARM.
This code is almost completely borrowed from x86 to enable
cpuidle for pSeries.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig              |    9 +++++++++
 arch/powerpc/include/asm/system.h |    2 ++
 arch/powerpc/kernel/idle.c        |   19 +++++++++++++++++++
 3 files changed, 30 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -91,6 +91,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
+config ARCH_HAS_CPU_IDLE_WAIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -247,6 +250,12 @@ source "kernel/Kconfig.freezer"
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
+menu "Power management options"
+
+source "drivers/cpuidle/Kconfig"
+
+endmenu
+
 menu "Kernel options"
 
 config HIGHMEM
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
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -102,6 +102,25 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
+ * idle loop and start using the new idle loop.
+ * Required while changing idle handler on SMP systems.
+ * Caller must have changed idle handler to the new value before the call.
+ */
+void cpu_idle_wait(void)
+{
+	/* Ensure that new value of idle is set */
+	smp_mb();
+	/* kick all the CPUs so that they exit out of old idle routine */
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
