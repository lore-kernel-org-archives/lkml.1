Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZALFnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZALFnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZALFnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:43:31 -0500
Received: from ozlabs.org ([203.10.76.45]:55693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbZALFna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:43:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18794.55122.441686.553409@drongo.ozlabs.ibm.com>
Date: Mon, 12 Jan 2009 16:38:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf_counter: Always schedule all software counters in
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Software counters aren't subject to the limitations imposed by the
fixed number of hardware counter registers, so there is no reason not
to enable them all in __perf_counter_sched_in.  Previously we used to
break out of the loop when we got to a group that wouldn't fit on the
PMU; with this we continue through the list but only schedule in
software counters (or groups containing only software counters) from
there on.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is also available in my perfcounters git tree (master branch) at
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4c0dccb..3aef306 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -455,12 +455,37 @@ group_error:
 	return -EAGAIN;
 }
 
+/*
+ * Return 1 for a software counter, 0 for a hardware counter
+ */
+static inline int is_software_counter(struct perf_counter *counter)
+{
+	return !counter->hw_event.raw && counter->hw_event.type < 0;
+}
+
+/*
+ * Return 1 for a group consisting entirely of software counters,
+ * 0 if the group contains any hardware counters.
+ */
+static int is_software_only_group(struct perf_counter *leader)
+{
+	struct perf_counter *counter;
+
+	if (!is_software_counter(leader))
+		return 0;
+	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+		if (!is_software_counter(counter))
+			return 0;
+	return 1;
+}
+
 static void
 __perf_counter_sched_in(struct perf_counter_context *ctx,
 			struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct perf_counter *counter;
 	u64 flags;
+	int can_add_hw = 1;
 
 	if (likely(!ctx->nr_counters))
 		return;
@@ -477,10 +502,12 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 
 		/*
 		 * If we scheduled in a group atomically and exclusively,
-		 * or if this group can't go on, break out:
+		 * or if this group can't go on, don't add any more
+		 * hardware counters.
 		 */
-		if (group_sched_in(counter, cpuctx, ctx, cpu))
-			break;
+		if (can_add_hw || is_software_only_group(counter))
+			if (group_sched_in(counter, cpuctx, ctx, cpu))
+				can_add_hw = 0;
 	}
 	hw_perf_restore(flags);
 	spin_unlock(&ctx->lock);
