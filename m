Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZHSNAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZHSNAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZHSNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:00:08 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38542 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZHSNAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:00:06 -0400
Date: Wed, 19 Aug 2009 18:29:52 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/2]: pSeries: Implement Thermal & Power Management
	Devices(TPMD) idle module.
Message-ID: <20090819125952.GC20627@linux.vnet.ibm.com>
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

This patch creates the Thermal & Power Management Devices module, tpmd_idle
which implements the cpuidle infrasture for pseries.
It implements a tpmd_idle_loop() which would be the main idle loop called
from cpu_idle(). It makes decision of entering either snooze or nap state
based on the decision taken by the cpuidle governor.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Makefile    |    1 
 arch/powerpc/platforms/pseries/tpmd.h      |   10 +
 arch/powerpc/platforms/pseries/tpmd_idle.c |  192 +++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+)

Index: linux.trees.git/arch/powerpc/platforms/pseries/tpmd_idle.c
===================================================================
--- /dev/null
+++ linux.trees.git/arch/powerpc/platforms/pseries/tpmd_idle.c
@@ -0,0 +1,192 @@
+
+/*
+ * tpmd_idle - idle state submodule to the tpmd driver
+ *
+ *  Copyright (C) 2009 Arun R Bharadwaj <arun@linux.vnet.ibm.com>
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/cpuidle.h>
+#include <linux/cpu.h>
+
+#include <asm/paca.h>
+#include <asm/machdep.h>
+
+#include "plpar_wrappers.h"
+#include "tpmd.h"
+
+MODULE_AUTHOR("Arun R Bharadwaj");
+MODULE_DESCRIPTION("TPMD Idle State Driver");
+MODULE_LICENSE("GPL");
+
+struct cpuidle_driver tpmd_idle_driver = {
+	.name =		"tpmd_idle",
+	.owner =	THIS_MODULE,
+};
+
+void (*pm_idle)(void);
+EXPORT_SYMBOL(pm_idle);
+
+static void (*old_idle_power_save)(void);
+
+DEFINE_PER_CPU(struct tpmd_processor_power, power);
+
+#define	IDLE_STATE_COUNT	2
+
+static int tpmd_idle_init(struct tpmd_processor_power *power)
+{
+	return cpuidle_register_device(&power->dev);
+}
+
+void tpmd_idle_exit(struct tpmd_processor_power *power)
+{
+	cpuidle_unregister_device(&power->dev);
+}
+
+static void snooze(void)
+{
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+	while (!need_resched()) {
+		HMT_low();
+		HMT_very_low();
+	}
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	local_irq_disable();
+	smp_mb();
+}
+
+static void nap(void)
+{
+	HMT_medium();
+	smp_mb();
+	cede_processor();
+}
+
+static int tpmd_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t t1, t2;
+	s64 diff;
+	int ret;
+
+	get_lppaca()->idle = 1;
+	get_lppaca()->donate_dedicated_cpu = 1;
+
+	t1 = ktime_get();
+
+	if (strcmp(st->desc, "idle") == 0)
+		snooze();
+	else
+		nap();
+
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	ret = (int) diff;
+
+	get_lppaca()->idle = 0;
+	get_lppaca()->donate_dedicated_cpu = 0;
+
+	return ret;
+}
+
+static int tpmd_setup_cpuidle(struct tpmd_processor_power *power)
+{
+	int i;
+	struct cpuidle_state *state;
+	struct cpuidle_device *dev = &power->dev;
+
+	dev->cpu = power->id;
+
+	dev->enabled = 0;
+	for (i = 0; i < IDLE_STATE_COUNT; i++) {
+		state = &dev->states[i];
+
+		snprintf(state->name, CPUIDLE_NAME_LEN, "TPM%d", i);
+
+		switch (i) {
+		case 0:
+			strncpy(state->desc, "idle", CPUIDLE_DESC_LEN);
+			state->exit_latency = 0;
+			state->target_residency = 0;
+			state->enter = tpmd_idle_loop;
+			break;
+
+		case 1:
+			strncpy(state->desc, "nap", CPUIDLE_DESC_LEN);
+			state->exit_latency = 1;
+			state->target_residency = 100;
+			state->enter = tpmd_idle_loop;
+			break;
+		}
+	}
+
+	power->dev.state_count = i;
+	return 0;
+}
+
+static int tpmd_processor_get_power_info(struct tpmd_processor_power *power,
+					int cpu)
+{
+	power->id = cpu;
+	power->count = 2;
+	return 0;
+}
+
+static int __init tpmd_processor_init(void)
+{
+	int cpu;
+	int result = cpuidle_register_driver(&tpmd_idle_driver);
+
+	if (result < 0)
+		return result;
+
+	printk(KERN_DEBUG "TPMD idle driver registered\n");
+
+	for_each_online_cpu(cpu) {
+		tpmd_processor_get_power_info(&per_cpu(power, cpu), cpu);
+		tpmd_setup_cpuidle(&per_cpu(power, cpu));
+		tpmd_idle_init(&per_cpu(power, cpu));
+	}
+
+	printk(KERN_DEBUG "Using cpuidle idle loop\n");
+	old_idle_power_save = ppc_md.power_save;
+	ppc_md.power_save = pm_idle;
+	return 0;
+}
+
+static void __exit tpmd_processor_exit(void)
+{
+	int cpu;
+
+	ppc_md.power_save = old_idle_power_save;
+	for_each_online_cpu(cpu)
+		tpmd_idle_exit(&per_cpu(power, cpu));
+	cpuidle_unregister_driver(&tpmd_idle_driver);
+	printk(KERN_DEBUG "TPMD idle driver removed\n");
+}
+
+module_init(tpmd_processor_init);
+module_exit(tpmd_processor_exit);
Index: linux.trees.git/arch/powerpc/platforms/pseries/tpmd.h
===================================================================
--- /dev/null
+++ linux.trees.git/arch/powerpc/platforms/pseries/tpmd.h
@@ -0,0 +1,10 @@
+#include <linux/kernel.h>
+#include <linux/cpuidle.h>
+
+struct tpmd_processor_power {
+	struct cpuidle_device dev;
+	int count;
+	int id;
+};
+
+extern struct cpuidle_driver tpmd_idle_driver;
Index: linux.trees.git/arch/powerpc/platforms/pseries/Makefile
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/Makefile
+++ linux.trees.git/arch/powerpc/platforms/pseries/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_HCALL_STATS)	+= hvCall_inst
 obj-$(CONFIG_PHYP_DUMP)	+= phyp_dump.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DTL)		+= dtl.o
+obj-$(CONFIG_TPMD)		+= tpmd_idle.o
