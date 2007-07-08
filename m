Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXGHMB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXGHMB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXGHLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:38399 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXGHLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 19/20] KVM: Tune hotplug/suspend IPIs
Date: Sun,  8 Jul 2007 14:54:48 +0300
Message-Id: <1183895689388-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hotplug IPIs can be called from the cpu on which we are currently
running on, so use on_cpu().  Similarly, drop on_each_cpu() for the
suspend/resume callbacks, as we're in atomic context here and only one
cpu is up anyway.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3226ad4..54cad51 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3010,13 +3010,13 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
+		on_cpu(cpu, hardware_disable, NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
+		on_cpu(cpu, hardware_enable, NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -3110,13 +3110,13 @@ static void kvm_exit_debug(void)
 
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
-	on_each_cpu(hardware_disable, NULL, 0, 0);
+	hardware_disable(NULL);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(hardware_disable, NULL, 0, 0);
+	hardware_enable(NULL);
 	return 0;
 }
 
-- 
1.5.2.2

