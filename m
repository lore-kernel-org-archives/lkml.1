Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXEXMLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXEXMLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXEXMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:36454 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXEXMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:20 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 6/7] KVM: Tune hotplug/suspend IPIs
Date: Thu, 24 May 2007 15:10:14 +0300
Message-Id: <11800086151115-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hotplug IPIs can be called from the cpu on which we are currently
running on, so use on_one_cpu().  Similarly, drop on_each_cpu() for the
suspend/resume callbacks, as we're in atomic context here and only one
cpu is up anyway.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9738d51..a632c8d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2921,13 +2921,13 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
+		on_one_cpu(cpu, hardware_disable, NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
+		on_one_cpu(cpu, hardware_enable, NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2984,13 +2984,13 @@ static void kvm_exit_debug(void)
 
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
1.5.0.6

