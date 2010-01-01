Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790Ab0AABUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab0AABUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443Ab0AABUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:20:37 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27486 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0AABUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:20:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5848"; a="31186414"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Mark Gross <mgross@linux.intel.com>
Subject: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Date: Thu, 31 Dec 2009 17:20:27 -0800
Message-Id: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Praveen Chidambaram <pchidamb@quicinc.com>

In some systems, the system bus speed can be varied, usually
based on the current CPU frequency.  However, various device
drivers and/or applications may need a faster system bus for I/O
even though the CPU itself may be idle.

Signed-off-by: Praveen Chidambaram <pchidamb@quicinc.com>
Signed-off-by: David Brown <davidb@quicinc.com>
Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 include/linux/pm_qos_params.h |    3 ++-
 kernel/pm_qos_params.c        |   32 +++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index d74f75e..091c13c 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -10,8 +10,9 @@
 #define PM_QOS_CPU_DMA_LATENCY 1
 #define PM_QOS_NETWORK_LATENCY 2
 #define PM_QOS_NETWORK_THROUGHPUT 3
+#define PM_QOS_SYSTEM_BUS_FREQ 4
 
-#define PM_QOS_NUM_CLASSES 4
+#define PM_QOS_NUM_CLASSES 5
 #define PM_QOS_DEFAULT_VALUE -1
 
 int pm_qos_add_requirement(int qos, char *name, s32 value);
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 3db49b9..8576f40 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -102,12 +102,24 @@ static struct pm_qos_object network_throughput_pm_qos = {
 	.comparitor = max_compare
 };
 
+static BLOCKING_NOTIFIER_HEAD(system_bus_freq_notifier);
+static struct pm_qos_object system_bus_freq_pm_qos = {
+	.requirements =
+		{LIST_HEAD_INIT(system_bus_freq_pm_qos.requirements.list)},
+	.notifiers = &system_bus_freq_notifier,
+	.name = "system_bus_freq",
+	.default_value = 0,
+	.target_value = ATOMIC_INIT(0),
+	.comparitor = max_compare
+};
+
 
-static struct pm_qos_object *pm_qos_array[] = {
-	&null_pm_qos,
-	&cpu_dma_pm_qos,
-	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+static struct pm_qos_object *pm_qos_array[PM_QOS_NUM_CLASSES] = {
+	[PM_QOS_RESERVED] = &null_pm_qos,
+	[PM_QOS_CPU_DMA_LATENCY] = &cpu_dma_pm_qos,
+	[PM_QOS_NETWORK_LATENCY] = &network_lat_pm_qos,
+	[PM_QOS_NETWORK_THROUGHPUT] = &network_throughput_pm_qos,
+	[PM_QOS_SYSTEM_BUS_FREQ] = &system_bus_freq_pm_qos,
 };
 
 static DEFINE_SPINLOCK(pm_qos_lock);
@@ -313,7 +325,7 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
  * will register the notifier into a notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
- int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
+int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
 	int retval;
 
@@ -409,9 +421,15 @@ static int __init pm_qos_power_init(void)
 		return ret;
 	}
 	ret = register_pm_qos_misc(&network_throughput_pm_qos);
-	if (ret < 0)
+	if (ret < 0) {
 		printk(KERN_ERR
 			"pm_qos_param: network_throughput setup failed\n");
+		return ret;
+	}
+	ret = register_pm_qos_misc(&system_bus_freq_pm_qos);
+	if (ret < 0)
+		printk(KERN_ERR
+			"pm_qos_param: system_bus_freq setup failed\n");
 
 	return ret;
 }
-- 
1.6.3.3

