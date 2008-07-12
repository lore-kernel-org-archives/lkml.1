Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYGLXTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYGLXTr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYGLXTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:19:39 -0400
Received: from mail4.aster.pl ([212.76.33.58]:21451 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYGLXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:19:38 -0400
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org, mgross@linux.intel.com
Subject: [PATCH 2.6.25.10] pm_qos_params: change spinlock to rwlock
Date: Sun, 13 Jul 2008 01:19:19 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807130119.19663.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrent calls to pm_qos_requirement shouldn't block each other. This patch 
changes spinlock to rwlock and fixes issues with PREEMPT_RT.
 
Signed-off-by:  Jakub Jozwicki <jozwicki@aster.pl>

--- linux-2.6.25.10/kernel/pm_qos_params.c	2008-07-03 05:46:47.000000000 +0200
+++ linux-2.6.25.10-rt7/kernel/pm_qos_params.c	2008-07-12 23:18:20.696615771 
+0200
@@ -110,7 +110,7 @@
 	&network_throughput_pm_qos
 };
 
-static DEFINE_SPINLOCK(pm_qos_lock);
+static DEFINE_RWLOCK(pm_qos_lock);
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 		size_t count, loff_t *f_pos);
@@ -142,7 +142,7 @@
 	unsigned long flags;
 	int call_notifier = 0;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
+	write_lock_irqsave(&pm_qos_lock, flags);
 	extreme_value = pm_qos_array[target]->default_value;
 	list_for_each_entry(node,
 			&pm_qos_array[target]->requirements.list, list) {
@@ -155,7 +155,7 @@
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
 			pm_qos_array[target]->target_value);
 	}
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	write_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (call_notifier)
 		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
@@ -195,9 +195,9 @@
 	int ret_val;
 	unsigned long flags;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
+	read_lock_irqsave(&pm_qos_lock, flags);
 	ret_val = pm_qos_array[pm_qos_class]->target_value;
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	read_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return ret_val;
 }
@@ -228,10 +228,10 @@
 		if (!dep->name)
 			goto cleanup;
 
-		spin_lock_irqsave(&pm_qos_lock, flags);
+		write_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
 			&pm_qos_array[pm_qos_class]->requirements.list);
-		spin_unlock_irqrestore(&pm_qos_lock, flags);
+		write_unlock_irqrestore(&pm_qos_lock, flags);
 		update_target(pm_qos_class);
 
 		return 0;
@@ -260,7 +260,7 @@
 	struct requirement_list *node;
 	int pending_update = 0;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
+	write_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
 		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
@@ -273,7 +273,7 @@
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	write_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
 
@@ -295,7 +295,7 @@
 	struct requirement_list *node;
 	int pending_update = 0;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
+	write_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
 		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
@@ -306,7 +306,7 @@
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	write_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
 }
