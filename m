Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZBURIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZBURIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 12:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZBURIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 12:08:23 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:58163 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZBURIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 12:08:22 -0500
Date: Sat, 21 Feb 2009 12:08:14 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: stable@kernrel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.26.y] cpuidle: 40000 wake/s unless idle=nomwait
Message-id: <alpine.LFD.2.00.0902211203430.4051@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

upstream 2.6.27: 320eee776357db52d6fcfb11cff985b1976a4595
"cpuidle: Menu governor fix wrong usage of measured_us"
fixes http://bugzilla.kernel.org/show_bug.cgi?id=10914
"40000 wake/s unless idle=nomwait"


There is a bug in menu governor where we have
		if (data->elapsed_us < data->elapsed_us + measured_us)

with measured_us already having elapsed_us added in tickless case here
	unsigned int measured_us =
		cpuidle_get_last_residency(dev) + data->elapsed_us;

Also, it should be last_residency, not measured_us, that need to be used to
do comparing and distinguish between expected & non-expected events.

Refactor menu_reflect() to fix these two problems.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Wei Gang <gang.wei@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>

---
 drivers/cpuidle/governors/menu.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

Index: linux-2.6.26.y/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.26.y.orig/drivers/cpuidle/governors/menu.c
+++ linux-2.6.26.y/drivers/cpuidle/governors/menu.c
@@ -67,9 +67,9 @@ static void menu_reflect(struct cpuidle_
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
-	unsigned int measured_us =
-		cpuidle_get_last_residency(dev) + data->elapsed_us;
+	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &dev->states[last_idx];
+	unsigned int measured_us;
 
 	/*
 	 * Ugh, this idle state doesn't support residency measurements, so we
@@ -77,20 +77,27 @@ static void menu_reflect(struct cpuidle_
 	 * for one full standard timer tick.  However, be aware that this
 	 * could potentially result in a suboptimal state transition.
 	 */
-	if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
-		measured_us = USEC_PER_SEC / HZ;
+	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID)))
+		last_idle_us = USEC_PER_SEC / HZ;
 
-	/* Predict time remaining until next break event */
-	if (measured_us + BREAK_FUZZ < data->expected_us - target->exit_latency) {
-		data->predicted_us = max(measured_us, data->last_measured_us);
+	/*
+	 * measured_us and elapsed_us are the cumulative idle time, since the
+	 * last time we were woken out of idle by an interrupt.
+	 */
+	if (data->elapsed_us <= data->elapsed_us + last_idle_us)
+		measured_us = data->elapsed_us + last_idle_us;
+	else
+		measured_us = -1;
+
+	/* Predict time until next break event */
+	data->predicted_us = max(measured_us, data->last_measured_us);
+
+	if (last_idle_us + BREAK_FUZZ <
+	    data->expected_us - target->exit_latency) {
 		data->last_measured_us = measured_us;
 		data->elapsed_us = 0;
 	} else {
-		if (data->elapsed_us < data->elapsed_us + measured_us)
-			data->elapsed_us = measured_us;
-		else
-			data->elapsed_us = -1;
-		data->predicted_us = max(measured_us, data->last_measured_us);
+		data->elapsed_us = measured_us;
 	}
 }
 
