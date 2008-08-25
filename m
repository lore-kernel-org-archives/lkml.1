Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYHYJL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYHYJL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYHYJLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:11:49 -0400
Received: from il.qumranet.com ([212.179.150.194]:57451 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYHYJLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:11:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on Intel hosts
Date: Mon, 25 Aug 2008 12:11:46 +0300
Message-Id: <1219655506-27418-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling Intel VT has the curious side effect whereby the INIT signal is
blocked.  Rather than comment on the wisdom of this side effect, this patch
adds an emergency restart reboot notifier, and modifies the kvm reboot
notifier to disable VT on emergency reboot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/notifier.h |    1 +
 kernel/sys.c             |    3 +++
 virt/kvm/kvm_main.c      |   10 ++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index da2698b..59123e4 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -203,6 +203,7 @@ static inline int notifier_to_errno(int ret)
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+#define SYS_EMERGENCY_RESTART 0x0004 /* sysrq-b; no locks taken */
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..289dba3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -270,6 +270,9 @@ out_unlock:
  */
 void emergency_restart(void)
 {
+	struct raw_notifier_head list = { .head = reboot_notifier_list.head };
+
+	raw_notifier_call_chain(&list, SYS_EMERGENCY_RESTART, NULL);
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0309571..125041f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1550,14 +1550,20 @@ EXPORT_SYMBOL_GPL(kvm_handle_fault_on_reboot);
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
-	if (val == SYS_RESTART) {
+	switch (val) {
+	case SYS_RESTART:
+		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+		/* coming through! */
+	case SYS_EMERGENCY_RESTART:
 		/*
 		 * Some (well, at least mine) BIOSes hang on reboot if
 		 * in vmx root mode.
 		 */
-		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
 		kvm_rebooting = true;
 		on_each_cpu(hardware_disable, NULL, 1);
+		break;
+	default:
+		break;
 	}
 	return NOTIFY_OK;
 }
-- 
1.6.0

