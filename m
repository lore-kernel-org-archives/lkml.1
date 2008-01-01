Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYAAPnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYAAPnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbYAAPgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:40 -0500
Received: from il.qumranet.com ([82.166.9.18]:33800 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbYAAPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:26 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 20/54] KVM: Correct kvm_init() error paths not freeing bad_pge.
Date: Tue,  1 Jan 2008 17:35:46 +0200
Message-Id: <1199201780-14001-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ef961cc..b56ee34 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1311,7 +1311,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 	r = kvm_arch_init(opaque);
 	if (r)
-		goto out4;
+		goto out_fail;
 
 	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 
@@ -1322,29 +1322,29 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
-		goto out;
+		goto out_free_0;
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
 				kvm_arch_check_processor_compat,
 				&r, 0, 1);
 		if (r < 0)
-			goto out_free_0;
+			goto out_free_1;
 	}
 
 	on_each_cpu(hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
-		goto out_free_1;
+		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	r = sysdev_class_register(&kvm_sysdev_class);
 	if (r)
-		goto out_free_2;
+		goto out_free_3;
 
 	r = sysdev_register(&kvm_sysdev);
 	if (r)
-		goto out_free_3;
+		goto out_free_4;
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size,
@@ -1352,7 +1352,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 					   0, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-		goto out_free_4;
+		goto out_free_5;
 	}
 
 	kvm_chardev_ops.owner = module;
@@ -1370,21 +1370,23 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
-out_free_4:
+out_free_5:
 	sysdev_unregister(&kvm_sysdev);
-out_free_3:
+out_free_4:
 	sysdev_class_unregister(&kvm_sysdev_class);
-out_free_2:
+out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
-out_free_1:
+out_free_2:
 	on_each_cpu(hardware_disable, NULL, 0, 1);
-out_free_0:
+out_free_1:
 	kvm_arch_hardware_unsetup();
+out_free_0:
+	__free_page(bad_page);
 out:
 	kvm_arch_exit();
 	kvm_exit_debug();
-out4:
+out_fail:
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
-- 
1.5.3.7

