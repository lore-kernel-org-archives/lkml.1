Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbZH0L5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbZH0L5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZH0L5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:57:30 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:34373 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZH0L53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:57:29 -0400
Date: Thu, 27 Aug 2009 17:27:23 +0530
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
Subject: [PATCH 4/4]: CPUIDLE/POWER: Implement Pseries Processor Idle module
Message-ID: <20090827115723.GE24986@linux.vnet.ibm.com>
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

This patch creates arch/powerpc/platforms/pseries/processor_idle.c,
which implements the cpuidle infrastructure for pseries.
It implements a pseries_cpuidle_loop() which would be the main idle loop
called from cpu_idle(). It makes decision of entering either snooze or nap
state based on the decision taken by the cpuidle governor.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  178 ++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h        |   14 +
 arch/powerpc/platforms/pseries/setup.c          |    3 
 4 files changed, 193 insertions(+), 3 deletions(-)

Index: linux.trees.git/arch/powerpc/platforms/pseries/Makefile
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/Makefile
+++ linux.trees.git/arch/powerpc/platforms/pseries/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_HCALL_STATS)	+= hvCall_inst
 obj-$(CONFIG_PHYP_DUMP)	+= phyp_dump.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DTL)		+= dtl.o
+obj-$(CONFIG_PSERIES_PROCESSOR_IDLE)	+= processor_idle.o
Index: linux.trees.git/arch/powerpc/platforms/pseries/pseries.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/pseries.h
+++ linux.trees.git/arch/powerpc/platforms/pseries/pseries.h
@@ -10,6 +10,8 @@
 #ifndef _PSERIES_PSERIES_H
 #define _PSERIES_PSERIES_H
 
+#include <linux/cpuidle.h>
+
 extern void __init fw_feature_init(const char *hypertas, unsigned long len);
 
 struct pt_regs;
@@ -40,4 +42,16 @@ extern unsigned long rtas_poweron_auto;
 
 extern void find_udbg_vterm(void);
 
+DECLARE_PER_CPU(unsigned long, smt_snooze_delay);
+
+#ifdef CONFIG_PSERIES_PROCESSOR_IDLE
+struct pseries_processor_power {
+	struct cpuidle_device dev;
+	int count;
+	int id;
+};
+
+extern struct cpuidle_driver pseries_idle_driver;
+#endif
+
 #endif /* _PSERIES_PSERIES_H */
Index: linux.trees.git/arch/powerpc/platforms/pseries/processor_idle.c
===================================================================
--- /dev/null
+++ linux.trees.git/arch/powerpc/platforms/pseries/processor_idle.c
@@ -0,0 +1,178 @@
+/*
+ *  processor_idle - idle state cpuidle driver.
+ *  Adapted from drivers/acpi/processor_idle.c
+ *
+ *  Arun R Bharadwaj <arun@linux.vnet.ibm.com>
+ *
+ *  Copyright (C) 2009 IBM Corporation.
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
+
+#include <asm/paca.h>
+#include <asm/reg.h>
+#include <asm/machdep.h>
+
+#include "plpar_wrappers.h"
+#include "pseries.h"
+
+MODULE_AUTHOR("Arun R Bharadwaj");
+MODULE_DESCRIPTION("pSeries Idle State Driver");
+MODULE_LICENSE("GPL");
+
+struct cpuidle_driver pseries_idle_driver = {
+	.name =		"pseries_idle",
+	.owner =	THIS_MODULE,
+};
+
+DEFINE_PER_CPU(struct pseries_processor_power, power);
+
+#define IDLE_STATE_COUNT	2
+
+static int pseries_idle_init(struct pseries_processor_power *power)
+{
+	return cpuidle_register_device(&power->dev);
+}
+
+static void snooze(void)
+{
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+	while (!need_resched()) {
+		ppc64_runlatch_off();
+		HMT_low();
+		HMT_very_low();
+	}
+	HMT_medium();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb();
+	local_irq_disable();
+}
+
+static void nap(void)
+{
+	ppc64_runlatch_off();
+	HMT_medium();
+	cede_processor();
+}
+
+static int pseries_cpuidle_loop(struct cpuidle_device *dev,
+				struct cpuidle_state *st)
+{
+	ktime_t t1, t2;
+	s64 diff;
+	int ret;
+	unsigned long in_purr, out_purr;
+
+	get_lppaca()->idle = 1;
+	get_lppaca()->donate_dedicated_cpu = 1;
+	in_purr = mfspr(SPRN_PURR);
+
+	t1 = ktime_get();
+
+	if (strcmp(st->desc, "snooze") == 0)
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
+	out_purr = mfspr(SPRN_PURR);
+	get_lppaca()->wait_state_cycles += out_purr - in_purr;
+	get_lppaca()->donate_dedicated_cpu = 0;
+	get_lppaca()->idle = 0;
+
+	return ret;
+}
+
+static int pseries_setup_cpuidle(struct pseries_processor_power *power)
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
+		snprintf(state->name, CPUIDLE_NAME_LEN, "IDLE%d", i);
+		state->enter = pseries_cpuidle_loop;
+
+		switch (i) {
+		case 0:
+			strncpy(state->desc, "snooze", CPUIDLE_DESC_LEN);
+			state->exit_latency = 0;
+			state->target_residency = 0;
+			break;
+
+		case 1:
+			strncpy(state->desc, "nap", CPUIDLE_DESC_LEN);
+			state->exit_latency = 1;
+			state->target_residency =
+					__get_cpu_var(smt_snooze_delay);
+			break;
+		}
+	}
+
+	power->dev.state_count = i;
+	return 0;
+}
+
+static int pseries_get_power_info(struct pseries_processor_power *power,
+				int cpu)
+{
+	power->id = cpu;
+	power->count = IDLE_STATE_COUNT;
+	return 0;
+}
+
+static int __init pseries_processor_idle_init(void)
+{
+	int cpu;
+	int result = cpuidle_register_driver(&pseries_idle_driver);
+
+	if (result < 0)
+		return result;
+
+	printk(KERN_DEBUG "pSeries idle driver registered\n");
+
+	for_each_online_cpu(cpu) {
+		pseries_get_power_info(&per_cpu(power, cpu), cpu);
+		pseries_setup_cpuidle(&per_cpu(power, cpu));
+		pseries_idle_init(&per_cpu(power, cpu));
+	}
+
+	printk(KERN_DEBUG "Using cpuidle idle loop\n");
+	ppc_md.power_save = cpuidle_pm_idle;
+	return 0;
+}
+
+late_initcall(pseries_processor_idle_init);
Index: linux.trees.git/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/setup.c
+++ linux.trees.git/arch/powerpc/platforms/pseries/setup.c
@@ -500,9 +500,6 @@ static int __init pSeries_probe(void)
 	return 1;
 }
 
-
-DECLARE_PER_CPU(unsigned long, smt_snooze_delay);
-
 static void pseries_dedicated_idle_sleep(void)
 { 
 	unsigned int cpu = smp_processor_id();
