Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbYE0WHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbYE0WHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYE0WGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:06:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20577 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbYE0WGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:06:48 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5304"; a="3444511"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [sched] Fixed CPU hotplug and sched domain handling
Date: Tue, 27 May 2008 15:06:45 -0700
Message-Id: <1211926006-11559-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First issue is that we're leaking doms_cur. It's allocated in
arch_init_sched_domains() which is called for every hotplug event.
So we just keep reallocation doms_cur without freeing it.
I introduced free_sched_domains() function that cleans things up.

Second issue is that sched domains created by the cpusets are
completely destroyed by the CPU hotplug events. For all CPU hotplug
events scheduler attaches all CPUs to the NULL domain and then puts
them all into the single domain thereby destroying domains created
by the cpusets (partition_sched_domains).
The solution is simple, when cpusets are enabled scheduler should not
create default domain and instead let cpusets do that. Which is
exactly what the patch does.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/cpuset.c |    6 ++++++
 kernel/sched.c  |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

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
index 9694570..5ebf6a7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6837,6 +6837,18 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
 }
 
 /*
+ * Free current domain masks.
+ * Called after all cpus are attached to NULL domain.
+ */
+static void free_sched_domains(void)
+{
+	ndoms_cur = 0;
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
+	doms_cur = &fallback_doms;
+}
+
+/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -6956,6 +6968,7 @@ int arch_reinit_sched_domains(void)
 
 	get_online_cpus();
 	detach_destroy_domains(&cpu_online_map);
+	free_sched_domains();
 	err = arch_init_sched_domains(&cpu_online_map);
 	put_online_cpus();
 
@@ -7040,6 +7053,7 @@ static int update_sched_domains(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
+		free_sched_domains();
 		return NOTIFY_OK;
 
 	case CPU_UP_CANCELED:
@@ -7058,8 +7072,16 @@ static int update_sched_domains(struct notifier_block *nfb,
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

