Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbYF3NQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbYF3NQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYF3NOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:50401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762048AbYF3NOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=g6hi8G627QJOmpzq0CWNePk+Huu6zIb+jx3KBKcXmXj1RiJuj4xWVYaXbCtYFO2h/m
         UDOspD3FV8XOC1DgYwxO7hRKHRoHSkTbLxsIYILc/kVcPon3VQUtM3l859j/+68LouBX
         fmcqAMZ/I7TecbmiWLI400eF6w+Iy+s82kFsU=
To: linux-kernel@vger.kernel.org
Subject: [patch 09/19] perfmon2 minimal v3:  PMU mapping
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:05 -0700 (PDT)
Message-ID: <4868dc1d.0c07560a.5f1f.129a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PMU resource description management functions.
Perfmon2 exports a logical view of the PMU with uniform register
names across all architectures. Each logical register is then
map onto an actual PMU register via a mapping table. Such table
exists for each PMU model.

PMU description tables are hardcoded into the kernel and one
is selected during boot.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/perfmon/perfmon_pmu.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/perfmon/perfmon_pmu.c	2008-06-23 13:12:54.000000000 +0200
@@ -0,0 +1,255 @@
+/*
+ * perfmon_pmu.c: perfmon2 PMU configuration management
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/module.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+#ifndef CONFIG_MODULE_UNLOAD
+#define module_refcount(n)	1
+#endif
+
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_pmu_conf_lock);
+
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_pmu_acq_lock);
+static u32 pfm_pmu_acquired;
+
+/*
+ * perfmon core must acces PMU information ONLY through pfm_pmu_conf
+ * if pfm_pmu_conf is NULL, then no description is registered
+ */
+struct pfm_pmu_config	*pfm_pmu_conf;
+EXPORT_SYMBOL(pfm_pmu_conf);
+
+static int pfm_pmu_regdesc_init(u64 *unavail_pmcs, u64 *unavail_pmds)
+{
+	struct pfm_regmap_desc *d;
+	u16 n, n2, n_counters, i;
+	int max1, max2, max3;
+
+	/*
+	 * compute the number of implemented PMC from the
+	 * description table
+	 */
+	n = 0;
+	max1 = max2 = -1;
+	d = pfm_pmu_conf->pmc_desc;
+	for (i = 0; i < pfm_pmu_conf->num_pmc_entries;  i++, d++) {
+		if (!(d->type & PFM_REG_I))
+			continue;
+
+		if (test_bit(i, cast_ulp(unavail_pmcs)))
+			continue;
+
+		__set_bit(i, cast_ulp(pfm_pmu_conf->regs.pmcs));
+
+		max1 = i;
+		n++;
+	}
+
+	if (!n) {
+		PFM_INFO("%s PMU description has no PMC registers",
+			 pfm_pmu_conf->pmu_name);
+		return -EINVAL;
+	}
+
+	pfm_pmu_conf->regs.max_pmc = max1 + 1;
+	pfm_pmu_conf->regs.num_pmcs = n;
+
+	n = n_counters = n2 = 0;
+	max1 = max2 = max3 = -1;
+	d = pfm_pmu_conf->pmd_desc;
+	for (i = 0; i < pfm_pmu_conf->num_pmd_entries;  i++, d++) {
+		if (!(d->type & PFM_REG_I))
+			continue;
+
+		if (test_bit(i, cast_ulp(unavail_pmds)))
+			continue;
+
+		__set_bit(i, cast_ulp(pfm_pmu_conf->regs.pmds));
+		max1 = i;
+		n++;
+
+		/*
+		 * read-write registers
+		 */
+		if (!(d->type & PFM_REG_RO)) {
+			__set_bit(i, cast_ulp(pfm_pmu_conf->regs.rw_pmds));
+			max3 = i;
+			n2++;
+		}
+
+		/*
+		 * counter registers
+		 */
+		if (d->type & PFM_REG_C64) {
+			__set_bit(i, cast_ulp(pfm_pmu_conf->regs.cnt_pmds));
+			n_counters++;
+		}
+
+		/*
+		 * PMD with intr capabilities
+		 */
+		if (d->type & PFM_REG_INTR) {
+			__set_bit(i, cast_ulp(pfm_pmu_conf->regs.intr_pmds));
+			max2 = i;
+		}
+	}
+
+	if (!n) {
+		PFM_INFO("%s PMU description has no PMD registers",
+			 pfm_pmu_conf->pmu_name);
+		return -EINVAL;
+	}
+
+	pfm_pmu_conf->regs.max_pmd = max1 + 1;
+	pfm_pmu_conf->regs.max_intr_pmd  = max2 + 1;
+
+	pfm_pmu_conf->regs.num_counters = n_counters;
+	pfm_pmu_conf->regs.num_pmds = n;
+	pfm_pmu_conf->regs.max_rw_pmd = max3 + 1;
+	pfm_pmu_conf->regs.num_rw_pmd = n2;
+
+	return 0;
+}
+
+int pfm_pmu_register(struct pfm_pmu_config *cfg)
+{
+	int ret = -EBUSY;
+
+	if (perfmon_disabled) {
+		PFM_INFO("perfmon disabled, cannot add PMU description");
+		return -ENOSYS;
+	}
+
+	spin_lock(&pfm_pmu_conf_lock);
+
+	if (pfm_pmu_conf)
+		goto unlock;
+
+	pfm_pmu_conf = cfg;
+	pfm_pmu_conf->ovfl_mask = (1ULL << cfg->counter_width) - 1;
+
+unlock:
+	spin_unlock(&pfm_pmu_conf_lock);
+
+	if (ret)
+		PFM_INFO("register %s PMU error %d", cfg->pmu_name, ret);
+	else
+		PFM_INFO("%s PMU installed", cfg->pmu_name);
+	return ret;
+}
+
+/*
+ * acquire PMU resource from lower-level PMU register allocator
+ * (currently perfctr-watchdog.c)
+ *
+ * acquisition is done when the first context is created (and not
+ * when it is loaded). We grab all that is defined in the description
+ * module and then we make adjustments at the arch-specific level.
+ *
+ * The PMU resource is released when the last perfmon context is
+ * destroyed.
+ *
+ * interrupts are not masked
+ */
+int pfm_pmu_acquire(void)
+{
+	u64 unavail_pmcs[PFM_PMC_BV];
+	u64 unavail_pmds[PFM_PMD_BV];
+	int ret = 0;
+
+	spin_lock(&pfm_pmu_acq_lock);
+
+	PFM_DBG("pmu_acquired=%d", pfm_pmu_acquired);
+
+	pfm_pmu_acquired++;
+
+	if (pfm_pmu_acquired == 1) {
+
+		memset(unavail_pmcs, 0, sizeof(unavail_pmcs));
+		memset(unavail_pmds, 0, sizeof(unavail_pmds));
+
+		ret = pfm_arch_pmu_acquire(unavail_pmcs, unavail_pmds);
+		if (ret) {
+			pfm_pmu_acquired--;
+		} else {
+			pfm_pmu_regdesc_init(unavail_pmcs, unavail_pmds);
+
+			/* available PMU ressources */
+			PFM_DBG("PMU acquired: %u PMCs, %u PMDs, %u counters",
+				pfm_pmu_conf->regs.num_pmcs,
+				pfm_pmu_conf->regs.num_pmds,
+				pfm_pmu_conf->regs.num_counters);
+		}
+	}
+	spin_unlock(&pfm_pmu_acq_lock);
+
+	return ret;
+}
+
+/*
+ * release the PMU resource
+ *
+ * actual release happens when last context is destroyed
+ *
+ * interrupts are not masked
+ */
+void pfm_pmu_release(void)
+{
+	BUG_ON(irqs_disabled());
+
+	/*
+	 * we need to use a spinlock because release takes some time
+	 * and we may have a race with pfm_pmu_acquire()
+	 */
+	spin_lock(&pfm_pmu_acq_lock);
+
+	PFM_DBG("pmu_acquired=%d", pfm_pmu_acquired);
+
+	/*
+	 * we decouple test and decrement because if we had errors
+	 * in pfm_pmu_acquire(), we still come here on pfm_context_free()
+	 * but with pfm_pmu_acquire=0
+	 */
+	if (pfm_pmu_acquired > 0 && --pfm_pmu_acquired == 0) {
+		pfm_arch_pmu_release();
+		memset(&pfm_pmu_conf->regs, 0, sizeof(pfm_pmu_conf->regs));
+		PFM_DBG("PMU released");
+	}
+	spin_unlock(&pfm_pmu_acq_lock);
+}
Index: o/perfmon/Makefile
===================================================================
--- o.orig/perfmon/Makefile	2008-06-23 13:12:41.000000000 +0200
+++ o/perfmon/Makefile	2008-06-23 13:13:20.000000000 +0200
@@ -5,4 +5,4 @@
 obj-y =	perfmon_ctx.o perfmon_file.o \
 	perfmon_attach.o perfmon_res.o \
 	perfmon_init.o perfmon_ctxsw.o \
-	perfmon_intr.o
+	perfmon_intr.o perfmon_pmu.o
Index: o/perfmon/perfmon_priv.h
===================================================================
--- o.orig/perfmon/perfmon_priv.h	2008-06-23 13:07:06.000000000 +0200
+++ o/perfmon/perfmon_priv.h	2008-06-23 13:12:54.000000000 +0200
@@ -52,6 +52,9 @@
 
 void pfm_free_context(struct pfm_context *ctx);
 
+int pfm_pmu_acquire(void);
+void pfm_pmu_release(void);
+
 void pfm_save_pmds(struct pfm_context *ctx);
 
 /*

-- 

