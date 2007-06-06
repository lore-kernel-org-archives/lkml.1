Return-Path: <linux-kernel-owner+w=401wt.eu-S936048AbXFFU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936048AbXFFU54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935764AbXFFU5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:57:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:54119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935295AbXFFU5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:57:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="251607996"
Date: Wed, 6 Jun 2007 13:53:53 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 5/8] cpuidle: menu governor change the early break condition
Message-ID: <20070606205353.GE23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Change the C-state early break out algorithm in menu governor.

We only look at early breakouts that result in wakeups shorter than idle state's
target_residency. If such a breakout is frequent enough, eliminate the
particular idle state upto a timeout period.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/governors/menu.c	2007-06-05 09:39:27.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c	2007-06-05 15:46:34.000000000 -0700
@@ -14,19 +14,20 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
-#define BM_HOLDOFF	20000	/* 20 ms */
+#define BM_HOLDOFF			20000	/* 20 ms */
+#define DEMOTION_THRESHOLD		5
+#define DEMOTION_TIMEOUT_MULTIPLIER	1000
 
 struct menu_device {
 	int		last_state_idx;
-	int		deepest_bm_state;
 
-	int		break_last_us;
-	int		break_elapsed_us;
+	int		deepest_break_state;
+	struct timespec break_expire_time_ts;
+	int		break_last_cnt;
 
+	int		deepest_bm_state;
 	int		bm_elapsed_us;
 	int		bm_holdoff_us;
-
-	unsigned long	idle_jiffies;
 };
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
@@ -45,7 +46,6 @@
 
 	/* determine the expected residency time */
 	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
-	expected_us = min(expected_us, data->break_last_us);
 
 	/* determine the maximum state compatible with current BM status */
 	if (cpuidle_get_bm_activity())
@@ -53,17 +53,33 @@
 	if (data->bm_elapsed_us <= data->bm_holdoff_us)
 		max_state = data->deepest_bm_state + 1;
 
+	/* determine the maximum state compatible with recent idle breaks */
+	if (data->deepest_break_state >= 0) {
+		struct timespec now;
+		ktime_get_ts(&now);
+		if (timespec_compare(&data->break_expire_time_ts, &now) > 0) {
+			max_state = min(max_state,
+					data->deepest_break_state + 1);
+		} else {
+			data->deepest_break_state = -1;
+		}
+	}
+	
 	/* find the deepest idle state that satisfies our constraints */
 	for (i = 1; i < max_state; i++) {
 		struct cpuidle_state *s = &dev->states[i];
+
 		if (s->target_residency > expected_us)
 			break;
+
 		if (s->exit_latency > system_latency_constraint())
 			break;
 	}
 
+	if (data->last_state_idx != i - 1)
+		data->break_last_cnt = 0;
+
 	data->last_state_idx = i - 1;
-	data->idle_jiffies = tick_nohz_get_idle_jiffies();
 	return i - 1;
 }
 
@@ -91,14 +107,27 @@
 		measured_us = USEC_PER_SEC / HZ;
 
 	data->bm_elapsed_us += measured_us;
-	data->break_elapsed_us += measured_us;
+
+	if (data->last_state_idx == 0)
+		return;
 
 	/*
-	 * Did something other than the timer interrupt cause the break event?
+	 * Did something other than the timer interrupt
+	 * cause an early break event?
 	 */
-	if (tick_nohz_get_idle_jiffies() == data->idle_jiffies) {
-		data->break_last_us = data->break_elapsed_us;
-		data->break_elapsed_us = 0;
+	if (unlikely(measured_us < target->target_residency)) {
+		if (data->break_last_cnt > DEMOTION_THRESHOLD) {
+			data->deepest_break_state = data->last_state_idx - 1;
+			ktime_get_ts(&data->break_expire_time_ts);
+			timespec_add_ns(&data->break_expire_time_ts,
+						target->target_residency *
+						DEMOTION_TIMEOUT_MULTIPLIER);
+		} else {
+			data->break_last_cnt++;
+		}
+	} else {
+		if (data->break_last_cnt > 0)
+			data->break_last_cnt--;
 	}
 }
 
@@ -112,10 +141,9 @@
 	int i;
 
 	data->last_state_idx = 0;
-	data->break_last_us = 0;
-	data->break_elapsed_us = 0;
 	data->bm_elapsed_us = 0;
 	data->bm_holdoff_us = BM_HOLDOFF;
+	data->deepest_break_state = -1;
 
 	for (i = 1; i < dev->state_count; i++)
 		if (dev->states[i].flags & CPUIDLE_FLAG_CHECK_BM)
