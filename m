Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYFBVId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYFBVId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYFBVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:08:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1081 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYFBVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:08:24 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3619129"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] sched: Fix memory leak in the cpu hotplug handing logic
Date: Mon,  2 Jun 2008 14:08:21 -0700
Message-Id: <1212440902-31215-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated/split up version of the patch I sent earlier.

Basically the issue is that we are leaking doms_cur on cpu hotplug events.
doms_cur is allocated in the arch_init_sched_domains() which is called for
every hotplug event. So we just keep reallocating doms_cur without freeing it.
This patch introduces free_sched_domains() function that cleans things up.

Note that doms_cur can also come from cpusets via partition_sched_domains().
That path is already handled correctly.

This just a bug fix and should go into 2.6.26 and probably -stable as well.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/sched.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8dcdec6..465f3c8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6855,6 +6855,19 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
 }
 
 /*
+ * Free current domain masks.
+ * Called after all cpus are attached to NULL domain.
+ */
+static void free_sched_domains(void)
+{
+	ndoms_cur = 0;
+	if (doms_cur != &fallback_doms) {
+		kfree(doms_cur);
+		doms_cur = &fallback_doms;
+	}
+}
+
+/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -6974,6 +6987,7 @@ int arch_reinit_sched_domains(void)
 
 	get_online_cpus();
 	detach_destroy_domains(&cpu_online_map);
+	free_sched_domains();
 	err = arch_init_sched_domains(&cpu_online_map);
 	put_online_cpus();
 
@@ -7058,6 +7072,7 @@ static int update_sched_domains(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
+		free_sched_domains();
 		return NOTIFY_OK;
 
 	case CPU_UP_CANCELED:
-- 
1.5.4.5

