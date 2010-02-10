Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0BJSfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:35:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:26656 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab0BJSfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,445,1262592000"; 
   d="scan'208";a="539597329"
Date: Wed, 10 Feb 2010 10:35:31 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       alex.shi@intel.com, ming.m.lin@intel.com
Subject: [PATCH] acpi: Be in TS_POLLING state during mwait based C-state entry
Message-ID: <20100210183530.GA5426@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACPI deep C-state entry had a long standing bug/missing feature, wherein we were sending
resched IPIs when an idle CPU is in mwait based deep C-state. Only mwait based C1 was using
the write to the monitored address to wake up mwait'ing CPU.

This patch changes the code to retain TS_POLLING bit if we are entering an mwait based
deep C-state.

The patch has been verified to reduce the number of resched IPIs in general and also
improves the performance/power on workloads with low system utilization (i.e., when mwait based
deep C-states are being used).

Reported-by: Lin Ming <ming.m.lin@intel.com>
Tested-by: Alex Shi <alex.shi@intel.com>

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/acpi/processor_idle.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 7c0441f..8abe91a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -872,12 +872,14 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		return(acpi_idle_enter_c1(dev, state));
 
 	local_irq_disable();
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we test
-	 * NEED_RESCHED:
-	 */
-	smp_mb();
+	if (cx->entry_method != ACPI_CSTATE_FFH) {
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we test
+		 * NEED_RESCHED:
+		 */
+		smp_mb();
+	}
 
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
@@ -957,12 +959,14 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	}
 
 	local_irq_disable();
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we test
-	 * NEED_RESCHED:
-	 */
-	smp_mb();
+	if (cx->entry_method != ACPI_CSTATE_FFH) {
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we test
+		 * NEED_RESCHED:
+		 */
+		smp_mb();
+	}
 
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
-- 
1.6.0.6

