Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935447Ab0CMAbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:31:43 -0500
Received: from kroah.org ([198.145.64.141]:46682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935220Ab0CMAav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:51 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.085818296@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [021/145] ACPI: Be in TS_POLLING state during mwait based C-state entry
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

commit d306ebc28649b89877a22158fe0076f06cc46f60 upstream.

ACPI deep C-state entry had a long standing bug/missing feature, wherein we were sending
resched IPIs when an idle CPU is in mwait based deep C-state. Only mwait based C1 was using
the write to the monitored address to wake up mwait'ing CPU.

This patch changes the code to retain TS_POLLING bit if we are entering an mwait based
deep C-state.

The patch has been verified to reduce the number of resched IPIs in general and also
improves the performance/power on workloads with low system utilization (i.e., when mwait based
deep C-states are being used).

Fixes "netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f"
http://marc.info/?l=linux-kernel&m=126441481427331&w=4

Reported-by: Lin Ming <ming.m.lin@intel.com>
Tested-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -888,12 +888,14 @@ static int acpi_idle_enter_simple(struct
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
@@ -973,12 +975,14 @@ static int acpi_idle_enter_bm(struct cpu
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


