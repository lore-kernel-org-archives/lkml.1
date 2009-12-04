Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZLDIPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZLDIPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZLDIPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:15:41 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36282 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLDIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:15:40 -0500
Date: Fri, 4 Dec 2009 13:45:39 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v10 PATCH 8/9]: pSeries: implement pSeries processor idle
 module
Message-ID: <20091204081539.GA5883@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091202095427.GA27251@linux.vnet.ibm.com>
 <20091202100255.GI27251@linux.vnet.ibm.com>
 <1259894858.2076.1251.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1259894858.2076.1251.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [2009-12-04 13:47:38]:

> On Wed, 2009-12-02 at 15:32 +0530, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-12-02 15:24:27]:
> > 
> > This patch creates arch/powerpc/platforms/pseries/processor_idle.c,
> > which implements the cpuidle infrastructure for pseries.
> > It implements a pseries_cpuidle_loop() which would be the main idle loop
> > called from cpu_idle(). It makes decision of entering either
> > dedicated_snooze_loop or dedicated_cede_loop for dedicated lpar and
> > shared_cede_loop for shared lpar processor based on the
> > decision taken by the cpuidle governor.
> 
> So unless I'm mistaken, you removed our powerpc "generic" idle loop that
> calls into ppc_md.power_save(), and replaced it by some pseries specific
> idle loops... Now what about all the other powerpc platforms ? native
> 970 (aka G5) ? 6xx ? Cell ? Or are you still calling ppc_md.power_save
> somewhere that I missed ?
> 
> Cheers,
> Ben.

Hi Ben,

I forgot to attach the patch which enables cpuidle for the rest of the
POWER platforms. Attaching it below.

So for these platforms, ppc_md.power_save will be called from from the
cpuidle_idle_call idle loop itself. Also, this cpuidle_idle_call is
not a pseries specific idle loop. It is a common loop for Intel and
PPC which use cpuidle infrastructure.

arun



This patch enables cpuidle for the rest of the POWER platforms like
44x, Cell, Pasemi etc.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/system.h       |    2 ++
 arch/powerpc/kernel/idle.c              |   28 ++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_32.c          |    8 ++++++--
 arch/powerpc/platforms/44x/idle.c       |    2 ++
 arch/powerpc/platforms/cell/pervasive.c |    2 ++
 arch/powerpc/platforms/pasemi/idle.c    |    2 ++
 arch/powerpc/platforms/ps3/setup.c      |    2 ++
 7 files changed, 44 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/powerpc/include/asm/system.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/system.h
+++ linux.trees.git/arch/powerpc/include/asm/system.h
@@ -551,8 +551,10 @@ void cpu_idle_wait(void);
 
 #ifdef CONFIG_CPU_IDLE
 extern void update_smt_snooze_delay(int snooze);
+extern void setup_cpuidle_ppc(void);
 #else
 static inline void update_smt_snooze_delay(int snooze) {}
+static inline void setup_cpuidle_ppc(void) {}
 #endif
 
 #endif /* __KERNEL__ */
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -129,6 +129,34 @@ void default_idle(void)
 	HMT_very_low();
 }
 
+#ifdef CONFIG_CPU_IDLE
+DEFINE_PER_CPU(struct cpuidle_device, ppc_idle_devices);
+struct cpuidle_driver cpuidle_ppc_driver = {
+	.name =         "cpuidle_ppc",
+};
+
+static void ppc_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ppc_md.power_save();
+}
+
+void setup_cpuidle_ppc(void)
+{
+	struct cpuidle_device *dev;
+	int cpu;
+
+	cpuidle_register_driver(&cpuidle_ppc_driver);
+
+	for_each_online_cpu(cpu) {
+		dev = &per_cpu(ppc_idle_devices, cpu);
+		dev->cpu = cpu;
+		dev->states[0].enter = ppc_idle_loop;
+		dev->state_count = 1;
+		cpuidle_register_device(dev);
+	}
+}
+#endif
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
Index: linux.trees.git/arch/powerpc/kernel/setup_32.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/setup_32.c
+++ linux.trees.git/arch/powerpc/kernel/setup_32.c
@@ -133,14 +133,18 @@ notrace void __init machine_init(unsigne
 
 #ifdef CONFIG_6xx
 	if (cpu_has_feature(CPU_FTR_CAN_DOZE) ||
-	    cpu_has_feature(CPU_FTR_CAN_NAP))
+	    cpu_has_feature(CPU_FTR_CAN_NAP)) {
 		ppc_md.power_save = ppc6xx_idle;
+		setup_cpuidle_ppc();
+	}
 #endif
 
 #ifdef CONFIG_E500
 	if (cpu_has_feature(CPU_FTR_CAN_DOZE) ||
-	    cpu_has_feature(CPU_FTR_CAN_NAP))
+	    cpu_has_feature(CPU_FTR_CAN_NAP)) {
 		ppc_md.power_save = e500_idle;
+		setup_cpuidle_ppc();
+	}
 #endif
 	if (ppc_md.progress)
 		ppc_md.progress("id mach(): done", 0x200);
Index: linux.trees.git/arch/powerpc/platforms/44x/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/44x/idle.c
+++ linux.trees.git/arch/powerpc/platforms/44x/idle.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/kernel.h>
 #include <asm/machdep.h>
+#include <asm/system.h>
 
 static int mode_spin;
 
@@ -46,6 +47,7 @@ int __init ppc44x_idle_init(void)
 		/* If we are not setting spin mode 
                    then we set to wait mode */
 		ppc_md.power_save = &ppc44x_idle;
+		setup_cpuidle_ppc();
 	}
 
 	return 0;
Index: linux.trees.git/arch/powerpc/platforms/cell/pervasive.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/cell/pervasive.c
+++ linux.trees.git/arch/powerpc/platforms/cell/pervasive.c
@@ -35,6 +35,7 @@
 #include <asm/pgtable.h>
 #include <asm/reg.h>
 #include <asm/cell-regs.h>
+#include <asm/system.h>
 
 #include "pervasive.h"
 
@@ -128,5 +129,6 @@ void __init cbe_pervasive_init(void)
 	}
 
 	ppc_md.power_save = cbe_power_save;
+	setup_cpuidle_ppc();
 	ppc_md.system_reset_exception = cbe_system_reset_exception;
 }
Index: linux.trees.git/arch/powerpc/platforms/pasemi/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pasemi/idle.c
+++ linux.trees.git/arch/powerpc/platforms/pasemi/idle.c
@@ -27,6 +27,7 @@
 #include <asm/machdep.h>
 #include <asm/reg.h>
 #include <asm/smp.h>
+#include <asm/system.h>
 
 #include "pasemi.h"
 
@@ -81,6 +82,7 @@ static int __init pasemi_idle_init(void)
 
 	ppc_md.system_reset_exception = pasemi_system_reset_exception;
 	ppc_md.power_save = modes[current_mode].entry;
+	setup_cpuidle_ppc();
 	printk(KERN_INFO "Using PA6T idle loop (%s)\n", modes[current_mode].name);
 
 	return 0;
Index: linux.trees.git/arch/powerpc/platforms/ps3/setup.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/ps3/setup.c
+++ linux.trees.git/arch/powerpc/platforms/ps3/setup.c
@@ -33,6 +33,7 @@
 #include <asm/prom.h>
 #include <asm/lv1call.h>
 #include <asm/ps3gpu.h>
+#include <asm/system.h>
 
 #include "platform.h"
 
@@ -214,6 +215,7 @@ static void __init ps3_setup_arch(void)
 	prealloc_ps3flash_bounce_buffer();
 
 	ppc_md.power_save = ps3_power_save;
+	setup_cpuidle_ppc();
 	ps3_os_area_init();
 
 	DBG(" <- %s:%d\n", __func__, __LINE__);
