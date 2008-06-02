Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYFBVIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYFBVIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYFBVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:08:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52743 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYFBVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:08:24 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3445608"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] sched: CPU hotplug events must not destroy scheduler domains created by the cpusets
Date: Mon,  2 Jun 2008 14:08:22 -0700
Message-Id: <1212440902-31215-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated/split up version of the patch I sent earlier.

Currently sched domains created by the cpusets are completely destroyed
during CPU hotplug event handling. For each CPU hotplug event scheduler
attaches all CPUs to the NULL domain and then puts them all into a single
domain thereby destroying domains created by the cpusets.

The solution is simple, when cpusets are enabled scheduler should not
create the default domain and instead let cpusets rebuild the domains based
on the current settings. Which is exactly what the patch does.

This is just a bug fix and should go into 2.6.26 and .25-stable.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/cpuset.c |    6 ++++++
 kernel/sched.c  |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a1b61f4..29c6304 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1789,6 +1789,12 @@ static void common_cpu_mem_hotplug_unplug(void)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 	scan_for_empty_cpusets(&top_cpuset);
 
+	/*
+	 * Scheduler destroys domains on hotplug events.
+	 * Rebuild them based on the current settings.
+	 */
+	rebuild_sched_domains();
+
 	cgroup_unlock();
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 465f3c8..da7c6c2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7091,8 +7091,16 @@ static int update_sched_domains(struct notifier_block *nfb,
 		return NOTIFY_DONE;
 	}
 
+#ifndef CONFIG_CPUSETS
+	/*
+	 * Create default domain partitioning if cpusets are disabled.
+	 * Otherwise we let cpusets rebuild the domains based on the 
+	 * current setup.
+	 */
+
 	/* The hotplug lock is already held by cpu_up/cpu_down */
 	arch_init_sched_domains(&cpu_online_map);
+#endif
 
 	return NOTIFY_OK;
 }
-- 
1.5.4.5

