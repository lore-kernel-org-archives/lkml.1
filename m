Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZGSO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZGSO7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZGSO7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 10:59:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48396 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZGSO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 10:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=G8WZcbkdFfcJG9tYGWAGtmB5JH8Iu5tV4ifrop0T9PnPfc0Oy0IZPOtvM+56r4uSr8
         2vu7K+bXMpdWAN4msh8mWVOOM7ErjR9uq2P6qZ7UWoljyI6SyO+z2BLcwZeeWm6GeD0E
         3JPorJmC6dhpYqhhyANIOOv80Wwi68I0+/2Tw=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: venkatesh.pallipadi@intel.com, abelay@novell.com
Subject: [PATCH] cpuidle: menu governor: reduce latency on exit
Date: Sun, 19 Jul 2009 16:59:46 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30cz; KDE/4.2.4; i686; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907191659.47179.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the state residency accounting and statistics
computation off the hot exit path.
On exit, the need to recompute statistics is recorded, and new
statistics will be computed when menu_select is called again.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

---
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f1df59f..5e905e0 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -19,6 +19,7 @@
 
 struct menu_device {
 	int		last_state_idx;
+	int             needs_update;
 
 	unsigned int	expected_us;
 	unsigned int	predicted_us;
@@ -29,6 +30,8 @@ struct menu_device {
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
+static void menu_update(struct cpuidle_device *dev);
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -39,6 +42,11 @@ static int menu_select(struct cpuidle_device *dev)
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 
+	if (data->needs_update) {
+		menu_update(dev);
+		data->needs_update = 0;
+	}
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		data->last_state_idx = 0;
@@ -72,7 +80,7 @@ static int menu_select(struct cpuidle_device *dev)
 }
 
 /**
- * menu_reflect - attempts to guess what happened after entry
+ * menu_reflect - records that data structures need update
  * @dev: the CPU
  *
  * NOTE: it's important to be fast here because this operation will add to
@@ -81,6 +89,16 @@ static int menu_select(struct cpuidle_device *dev)
 static void menu_reflect(struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
+	data->needs_update = 1;
+}
+
+/**
+ * menu_update - attempts to guess what happened after entry
+ * @dev: the CPU
+ */
+static void menu_update(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &dev->states[last_idx];

