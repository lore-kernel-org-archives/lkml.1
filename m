Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZJFPdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZJFPdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZJFPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:33:09 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:35159 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbZJFPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:33:08 -0400
Date: Tue, 6 Oct 2009 21:02:17 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
Subject: [v7 PATCH 4/7]: POWER: enable cpuidle for POWER.
Message-ID: <20091006153217.GB7343@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091006152421.GA7278@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091006152421.GA7278@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-06 20:54:21]:

This patch enables the cpuidle option in Kconfig for pSeries.

Currently cpuidle infrastructure is enabled only for x86 and ARM.
This code is almost completely borrowed from x86 to enable
cpuidle for pSeries.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig              |   17 +++++++++++++++++
 arch/powerpc/include/asm/system.h |    2 ++
 arch/powerpc/kernel/idle.c        |   19 +++++++++++++++++++
 3 files changed, 38 insertions(+)

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
@@ -243,6 +246,20 @@ source "kernel/Kconfig.freezer"
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
+menu "Power management options"
+
+source "drivers/cpuidle/Kconfig"
+
+config PSERIES_PROCESSOR_IDLE
+	bool "Idle Power Management Support for pSeries"
+	depends on PPC_PSERIES && CPU_IDLE
+	default y
+	help
+	  Idle Power Management Support for pSeries. This hooks onto cpuidle
+	  infrastructure to help in idle cpu power management.
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
+	/* Ensure that new value of ppc_md.power_save is set */
+	smp_mb();
+	/* kick all the CPUs so that they exit out of ppc_md.power_save */
+	smp_call_function(do_nothing, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
