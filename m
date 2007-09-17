Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXIQIfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXIQIfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXIQIc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 009/104] KVM: Trivial: Avoid hardware_disable predeclaration
Date: Mon, 17 Sep 2007 10:30:51 +0200
Message-Id: <11900179462543-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Don't pre-declare hardware_disable: shuffle the reboot hook down.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1be510b..326fa79 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -54,8 +54,6 @@ static cpumask_t cpus_hardware_enabled;
 
 struct kvm_arch_ops *kvm_arch_ops;
 
-static void hardware_disable(void *ignored);
-
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
 static struct kvm_stats_debugfs_item {
@@ -2924,25 +2922,6 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
-                       void *v)
-{
-	if (val == SYS_RESTART) {
-		/*
-		 * Some (well, at least mine) BIOSes hang on reboot if
-		 * in vmx root mode.
-		 */
-		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(hardware_disable, NULL, 0, 1);
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block kvm_reboot_notifier = {
-	.notifier_call = kvm_reboot,
-	.priority = 0,
-};
-
 /*
  * Make sure that a cpu that is being hot-unplugged does not have any vcpus
  * cached on it.
@@ -3025,6 +3004,25 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	return NOTIFY_OK;
 }
 
+static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
+                       void *v)
+{
+	if (val == SYS_RESTART) {
+		/*
+		 * Some (well, at least mine) BIOSes hang on reboot if
+		 * in vmx root mode.
+		 */
+		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+		on_each_cpu(hardware_disable, NULL, 0, 1);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvm_reboot_notifier = {
+	.notifier_call = kvm_reboot,
+	.priority = 0,
+};
+
 void kvm_io_bus_init(struct kvm_io_bus *bus)
 {
 	memset(bus, 0, sizeof(*bus));
-- 
1.5.3

