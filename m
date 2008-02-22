Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbYBVVLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbYBVVLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbYBVVJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:09:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYBVVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:09:32 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="773387"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pj@sgi.com,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH sched-devel 7/7] cpuisol: Do not halt isolated CPUs with Stop Machine
Date: Fri, 22 Feb 2008 13:09:18 -0800
Message-Id: <1203714558-20904-7-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203714558-20904-6-git-send-email-maxk@qualcomm.com>
References: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-2-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-3-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-4-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-5-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-6-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes "stop machine" ignore isolated CPUs (if the config option is enabled).

It addresses exact same usecase explained in the previous workqueue isolation patch.
Where a user-space RT thread can prevent stop machine threads from running, which causes
the entire system to hang.

Stop machine is particularly bad when it comes to latencies because it halts every single
CPU and may take several milliseconds to complete. It's currently used for module insertion
and removal only.
As some folks pointed out in the previous discussions this patch is potentially unsafe
if applications running on the isolated CPUs use kernel services affected by the module
insertion and removal.
I've been running kernels with this patch on a wide range of the machines in production
environment were we routinely insert/remove modules with applications running on isolated
CPUs. Also I've recently done quite a bit of testing on life multi-core systems with
"stop machine" _completely_ disabled, and was not able to trigger any problems.
For more details please see this thread
	http://marc.info/?l=linux-kernel&m=120243837206248&w=2
That of course does not mean that the patch is totally safe but it does not seem to
cause any instability in real life.

This feature does not add any overhead when disabled. It's marked as experimental
due to potential issues mentioned above.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/Kconfig.cpuisol |   15 +++++++++++++++
 kernel/stop_machine.c  |    8 +++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/Kconfig.cpuisol b/kernel/Kconfig.cpuisol
index e681b02..24c1ef0 100644
--- a/kernel/Kconfig.cpuisol
+++ b/kernel/Kconfig.cpuisol
@@ -25,3 +25,18 @@ config CPUISOL_WORKQUEUE
 	  heavily rely on per cpu workqueues.
 
 	  Say 'Y' to enable workqueue isolation.  If unsure say 'N'.
+
+config CPUISOL_STOPMACHINE
+	bool "Do not halt isolated CPUs with Stop Machine (EXPERIMENTAL)"
+	depends on CPUISOL && STOP_MACHINE && EXPERIMENTAL
+	help
+	  If this option is enabled kernel will not halt isolated CPUs
+	  when Stop Machine is triggered. Stop Machine is currently only
+	  used by the module insertion and removal.
+	  Please note that at this point this feature is experimental. It is 
+	  not known to really break anything but can potentially introduce
+	  an instability due to race conditions in module removal logic.
+
+	  Say 'Y' if support for dynamic module insertion and removal is
+	  required for the system that uses isolated CPUs. 
+	  If unsure say 'N'.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 6f4e0e1..aa3af15 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -89,6 +89,12 @@ static void stopmachine_set_state(enum stopmachine_state state)
 		cpu_relax();
 }
 
+#ifdef CONFIG_CPUISOL_STOPMACHINE
+#define cpu_unusable(cpu) cpu_isolated(cpu)
+#else
+#define cpu_unusable(cpu) (0)
+#endif
+
 static int stop_machine(void)
 {
 	int i, ret = 0;
@@ -98,7 +104,7 @@ static int stop_machine(void)
 	stopmachine_state = STOPMACHINE_WAIT;
 
 	for_each_online_cpu(i) {
-		if (i == raw_smp_processor_id())
+		if (i == raw_smp_processor_id() || cpu_unusable(i))
 			continue;
 		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
 		if (ret < 0)
-- 
1.5.4.1

