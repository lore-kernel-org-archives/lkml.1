Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbZDAKUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbZDAKUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbZDAKQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:16:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:34063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbZDAKQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:16:48 -0400
Date: Wed, 1 Apr 2009 10:15:06 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171024.459968444@chello.nl>
References: <20090330171024.459968444@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: pmc arbitration
Message-ID: <tip-b4110aa4b80378855c92a090dc079a3c5c69b69c@git.kernel.org>
Git-Commit-ID: b4110aa4b80378855c92a090dc079a3c5c69b69c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:15:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4110aa4b80378855c92a090dc079a3c5c69b69c
Gitweb:     http://git.kernel.org/tip/b4110aa4b80378855c92a090dc079a3c5c69b69c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:39 +0200

perf_counter: pmc arbitration

Follow the example set by powerpc and try to play nice with oprofile
and the nmi watchdog.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171024.459968444@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   75 ++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index e16dfaf..2a946a1 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
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
@@ -179,10 +239,23 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
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
@@ -230,6 +303,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		hwc->config |= pmc_ops->event_map(perf_event_id(hw_event));
 	}
 
+	counter->destroy = hw_perf_counter_destroy;
+
 	return 0;
 }
 
