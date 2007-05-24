Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXEXMLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXEXMLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXEXMKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:36439 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXEXMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:18 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/7] HOTPLUG: Add CPU_DYING notifier
Date: Thu, 24 May 2007 15:10:09 +0300
Message-Id: <11800086153311-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM wants a notification when a cpu is about to die, so it can disable
hardware extensions, but at a time when user processes cannot be scheduled
on the cpu, so it doesn't try to use virtualization extensions after they
have been disabled.

This adds a CPU_DYING notification.  The notification is called in atomic
context on the doomed cpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/notifier.h |    3 +++
 kernel/cpu.c             |   16 ++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 9431101..576f2bb 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -196,6 +196,8 @@ extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
 #define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
+#define CPU_DYING		0x000A /* CPU (unsigned)v not running any task,
+				        * not handling interrupts, soon dead */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
@@ -208,6 +210,7 @@ extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 #define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 208cf34..181ae70 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -103,11 +103,19 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+struct take_cpu_down_param {
+	unsigned long mod;
+	void *hcpu;
+};
+
 /* Take this CPU down. */
-static int take_cpu_down(void *unused)
+static int take_cpu_down(void *_param)
 {
+	struct take_cpu_down_param *param = _param;
 	int err;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
@@ -127,6 +135,10 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpumask_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	struct take_cpu_down_param tcd_param = {
+		.mod = mod,
+		.hcpu = hcpu,
+	};
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -153,7 +165,7 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	set_cpus_allowed(current, tmp);
 
 	mutex_lock(&cpu_bitmask_lock);
-	p = __stop_machine_run(take_cpu_down, NULL, cpu);
+	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
 	mutex_unlock(&cpu_bitmask_lock);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
-- 
1.5.0.6

