Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbZBXBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbZBXBiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZBXBhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:37:55 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:35646 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZBXBhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:37:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18851.20328.847510.730956@cargo.ozlabs.ibm.com>
Date: Tue, 24 Feb 2009 12:37:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perfcounters/powerpc: Make exclude_kernel bit work on Apple G5 processors
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, setting hw_event.exclude_kernel does nothing on the PPC970
variants used in Apple G5 machines, because they have the HV (hypervisor)
bit in the MSR forced to 1, so as far as the PMU is concerned, the
kernel runs in hypervisor mode.  Thus we have to use the MMCR0_FCHV
(freeze counters in hypervisor mode) bit rather than the MMCR0_FCS
(freeze counters in supervisor mode) bit.

This checks the MSR.HV bit at startup, and if it is set, we set the
freeze_counters_kernel variable to MMCR0_FCHV (it was initialized to
MMCR0_FCS).  We then use that whenever we need to exclude kernel events.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Ingo, please pull this from my perfcounters.git tree master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index bd6ba85..6e27913 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -32,6 +32,15 @@ DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
 struct power_pmu *ppmu;
 
+/*
+ * Normally, to ignore kernel events we set the FCS (freeze counters
+ * in supervisor mode) bit in MMCR0, but if the kernel runs with the
+ * hypervisor bit set in the MSR, or if we are running on a processor
+ * where the hypervisor bit is forced to 1 (as on Apple G5 processors),
+ * then we need to use the FCHV bit to ignore kernel events.
+ */
+static unsigned int freeze_counters_kernel = MMCR0_FCS;
+
 void perf_counter_print_debug(void)
 {
 }
@@ -364,7 +373,7 @@ void hw_perf_restore(u64 disable)
 	if (counter->hw_event.exclude_user)
 		cpuhw->mmcr[0] |= MMCR0_FCP;
 	if (counter->hw_event.exclude_kernel)
-		cpuhw->mmcr[0] |= MMCR0_FCS;
+		cpuhw->mmcr[0] |= freeze_counters_kernel;
 	if (counter->hw_event.exclude_hv)
 		cpuhw->mmcr[0] |= MMCR0_FCHV;
 
@@ -606,10 +615,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 	/*
 	 * If we are not running on a hypervisor, force the
 	 * exclude_hv bit to 0 so that we don't care what
-	 * the user set it to.  This also means that we don't
-	 * set the MMCR0_FCHV bit, which unconditionally freezes
-	 * the counters on the PPC970 variants used in Apple G5
-	 * machines (since MSR.HV is always 1 on those machines).
+	 * the user set it to.
 	 */
 	if (!firmware_has_feature(FW_FEATURE_LPAR))
 		counter->hw_event.exclude_hv = 0;
@@ -841,6 +847,13 @@ static int init_perf_counters(void)
 		ppmu = &power6_pmu;
 		break;
 	}
+
+	/*
+	 * Use FCHV to ignore kernel events if MSR.HV is set.
+	 */
+	if (mfmsr() & MSR_HV)
+		freeze_counters_kernel = MMCR0_FCHV;
+
 	return 0;
 }
 
-- 
1.5.6.3

