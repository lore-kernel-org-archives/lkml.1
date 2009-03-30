Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZC3RMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZC3RMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZC3RLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171024.459968444@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/15] perf_counter: pmc arbitration
Content-Disposition: inline; filename=perf_counter-reserve.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the example set by powerpc and try to play nice with oprofile
and the nmi watchdog.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |   75 +++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -20,6 +20,7 @@
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
+#include <asm/nmi.h>
 
 static bool perf_counters_initialized __read_mostly;
 
@@ -172,6 +173,65 @@ again:
 	atomic64_sub(delta, &hwc->period_left);
 }
 
+static atomic_t num_counters;
+static DEFINE_MUTEX(pmc_reserve_mutex);
+
+static bool reserve_pmc_hardware(void)
+{
+	int i;
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		disable_lapic_nmi_watchdog();
+
+	for (i = 0; i < nr_counters_generic; i++) {
+		if (!reserve_perfctr_nmi(pmc_ops->perfctr + i))
+			goto perfctr_fail;
+	}
+
+	for (i = 0; i < nr_counters_generic; i++) {
+		if (!reserve_evntsel_nmi(pmc_ops->eventsel + i))
+			goto eventsel_fail;
+	}
+
+	return true;
+
+eventsel_fail:
+	for (i--; i >= 0; i--)
+		release_evntsel_nmi(pmc_ops->eventsel + i);
+
+	i = nr_counters_generic;
+
+perfctr_fail:
+	for (i--; i >= 0; i--)
+		release_perfctr_nmi(pmc_ops->perfctr + i);
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		enable_lapic_nmi_watchdog();
+
+	return false;
+}
+
+static void release_pmc_hardware(void)
+{
+	int i;
+
+	for (i = 0; i < nr_counters_generic; i++) {
+		release_perfctr_nmi(pmc_ops->perfctr + i);
+		release_evntsel_nmi(pmc_ops->eventsel + i);
+	}
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		enable_lapic_nmi_watchdog();
+}
+
+static void hw_perf_counter_destroy(struct perf_counter *counter)
+{
+	if (atomic_dec_and_mutex_lock(&num_counters, &pmc_reserve_mutex)) {
+		release_pmc_hardware();
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+}
+
 /*
  * Setup the hardware configuration for a given hw_event_type
  */
@@ -179,10 +239,23 @@ static int __hw_perf_counter_init(struct
 {
 	struct perf_counter_hw_event *hw_event = &counter->hw_event;
 	struct hw_perf_counter *hwc = &counter->hw;
+	int err;
 
 	if (unlikely(!perf_counters_initialized))
 		return -EINVAL;
 
+	err = 0;
+	if (atomic_inc_not_zero(&num_counters)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_read(&num_counters) == 0 && !reserve_pmc_hardware())
+			err = -EBUSY;
+		else
+			atomic_inc(&num_counters);
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+	if (err)
+		return err;
+
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
@@ -230,6 +303,8 @@ static int __hw_perf_counter_init(struct
 		hwc->config |= pmc_ops->event_map(perf_event_id(hw_event));
 	}
 
+	counter->destroy = hw_perf_counter_destroy;
+
 	return 0;
 }
 

-- 

