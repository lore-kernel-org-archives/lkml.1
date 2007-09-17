Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXIQIkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXIQIkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXIQIco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 037/104] KVM: Use kmem cache for allocating vcpus
Date: Mon, 17 Sep 2007 10:31:19 +0200
Message-Id: <11900179472013-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Avi wants the allocations of vcpus centralized again.  The easiest way
is to add a "size" arg to kvm_init_arch, and expose the thus-prepared
cache to the modules.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 +++-
 drivers/kvm/kvm_main.c |   16 +++++++++++++++-
 drivers/kvm/svm.c      |    5 +++--
 drivers/kvm/vmx.c      |    4 ++--
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 030b93b..b362e8f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -141,6 +141,7 @@ struct kvm_mmu_page {
 };
 
 struct kvm_vcpu;
+extern struct kmem_cache *kvm_vcpu_cache;
 
 /*
  * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
@@ -483,7 +484,8 @@ extern struct kvm_arch_ops *kvm_arch_ops;
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
-int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module);
+int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
+		  struct module *module);
 void kvm_exit_arch(void);
 
 int kvm_mmu_module_init(void);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4bbd89e..4166a08 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -53,6 +53,8 @@ static LIST_HEAD(vm_list);
 static cpumask_t cpus_hardware_enabled;
 
 struct kvm_arch_ops *kvm_arch_ops;
+struct kmem_cache *kvm_vcpu_cache;
+EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 
@@ -3104,7 +3106,8 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_ops->vcpu_put(vcpu);
 }
 
-int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
+int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
+		  struct module *module)
 {
 	int r;
 
@@ -3142,6 +3145,14 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 	if (r)
 		goto out_free_3;
 
+	/* A kmem cache lets us meet the alignment requirements of fx_save. */
+	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size,
+					   __alignof__(struct kvm_vcpu), 0, 0);
+	if (!kvm_vcpu_cache) {
+		r = -ENOMEM;
+		goto out_free_4;
+	}
+
 	kvm_chardev_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
@@ -3156,6 +3167,8 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 	return r;
 
 out_free:
+	kmem_cache_destroy(kvm_vcpu_cache);
+out_free_4:
 	sysdev_unregister(&kvm_sysdev);
 out_free_3:
 	sysdev_class_unregister(&kvm_sysdev_class);
@@ -3173,6 +3186,7 @@ out:
 void kvm_exit_arch(void)
 {
 	misc_deregister(&kvm_dev);
+	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
 	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b25f4e1..8193651 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -577,7 +577,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	struct page *page;
 	int err;
 
-	svm = kzalloc(sizeof *svm, GFP_KERNEL);
+	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 	if (!svm) {
 		err = -ENOMEM;
 		goto out;
@@ -1849,7 +1849,8 @@ static struct kvm_arch_ops svm_arch_ops = {
 
 static int __init svm_init(void)
 {
-	return kvm_init_arch(&svm_arch_ops, THIS_MODULE);
+	return kvm_init_arch(&svm_arch_ops, sizeof(struct vcpu_svm),
+			      THIS_MODULE);
 }
 
 static void __exit svm_exit(void)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f770f55..2b30274 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2365,7 +2365,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	int err;
-	struct vcpu_vmx *vmx = kzalloc(sizeof(*vmx), GFP_KERNEL);
+	struct vcpu_vmx *vmx = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 	int cpu;
 
 	if (!vmx)
@@ -2490,7 +2490,7 @@ static int __init vmx_init(void)
 	memset(iova, 0xff, PAGE_SIZE);
 	kunmap(vmx_io_bitmap_b);
 
-	r = kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
+	r = kvm_init_arch(&vmx_arch_ops, sizeof(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		goto out1;
 
-- 
1.5.3

