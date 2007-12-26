Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXLZLY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXLZLY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXLZLHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:50487 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXLZLGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:11 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 50/55] KVM: Portability: Combine kvm_init and kvm_init_x86
Date: Wed, 26 Dec 2007 13:05:55 +0200
Message-Id: <1198667160-22953-51-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Will be called once arch module registers itself.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 +-
 drivers/kvm/kvm_main.c |   61 +++++++++++++++++------------------------------
 drivers/kvm/svm.c      |    4 +-
 drivers/kvm/vmx.c      |    4 +-
 4 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index bca07c6..5e7be15 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -495,9 +495,9 @@ void vcpu_put(struct kvm_vcpu *vcpu);
 void decache_vcpus_on_cpu(int cpu);
 
 
-int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
+int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module);
-void kvm_exit_x86(void);
+void kvm_exit(void);
 
 int kvm_mmu_module_init(void);
 void kvm_mmu_module_exit(void);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 2610046..510f2d1 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1434,12 +1434,27 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
-int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
+int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module)
 {
 	int r;
 	int cpu;
 
+	r = kvm_mmu_module_init();
+	if (r)
+		goto out4;
+
+	kvm_init_debug();
+
+	kvm_arch_init();
+
+	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (bad_page == NULL) {
+		r = -ENOMEM;
+		goto out;
+	}
+
 	if (kvm_x86_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
 		return -EEXIST;
@@ -1520,11 +1535,14 @@ out_free_0:
 	kvm_arch_hardware_unsetup();
 out:
 	kvm_x86_ops = NULL;
+	kvm_exit_debug();
+	kvm_mmu_module_exit();
+out4:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_init_x86);
+EXPORT_SYMBOL_GPL(kvm_init);
 
-void kvm_exit_x86(void)
+void kvm_exit(void)
 {
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
@@ -1535,43 +1553,8 @@ void kvm_exit_x86(void)
 	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_x86_ops = NULL;
-}
-EXPORT_SYMBOL_GPL(kvm_exit_x86);
-
-static __init int kvm_init(void)
-{
-	int r;
-
-	r = kvm_mmu_module_init();
-	if (r)
-		goto out4;
-
-	kvm_init_debug();
-
-	kvm_arch_init();
-
-	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-
-	if (bad_page == NULL) {
-		r = -ENOMEM;
-		goto out;
-	}
-
-	return 0;
-
-out:
-	kvm_exit_debug();
-	kvm_mmu_module_exit();
-out4:
-	return r;
-}
-
-static __exit void kvm_exit(void)
-{
 	kvm_exit_debug();
 	__free_page(bad_page);
 	kvm_mmu_module_exit();
 }
-
-module_init(kvm_init)
-module_exit(kvm_exit)
+EXPORT_SYMBOL_GPL(kvm_exit);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 991e77d..0f0958d 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1723,13 +1723,13 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 static int __init svm_init(void)
 {
-	return kvm_init_x86(&svm_x86_ops, sizeof(struct vcpu_svm),
+	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
 			      THIS_MODULE);
 }
 
 static void __exit svm_exit(void)
 {
-	kvm_exit_x86();
+	kvm_exit();
 }
 
 module_init(svm_init)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ad16865..18fd918 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2677,7 +2677,7 @@ static int __init vmx_init(void)
 	memset(iova, 0xff, PAGE_SIZE);
 	kunmap(vmx_io_bitmap_b);
 
-	r = kvm_init_x86(&vmx_x86_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
+	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		goto out1;
 
@@ -2698,7 +2698,7 @@ static void __exit vmx_exit(void)
 	__free_page(vmx_io_bitmap_b);
 	__free_page(vmx_io_bitmap_a);
 
-	kvm_exit_x86();
+	kvm_exit();
 }
 
 module_init(vmx_init)
-- 
1.5.3.7

