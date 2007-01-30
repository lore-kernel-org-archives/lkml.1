Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXA3OyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXA3OyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965563AbXA3OyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:54:19 -0500
Received: from il.qumranet.com ([62.219.232.206]:51131 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965551AbXA3OyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:54:18 -0500
Subject: [PATCH 2/5] KVM: Add a global list of all virtual machines
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:54:16 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com>
In-Reply-To: <45BF5B96.1070007@qumranet.com>
Message-Id: <20070130145416.E1BC3A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow us to iterate over all vcpus and see which cpus they are
running on.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -41,6 +41,9 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static spinlock_t kvm_lock = SPIN_LOCK_UNLOCKED;
+static struct list_head vm_list = LIST_HEAD_INIT(vm_list);
+
 struct kvm_arch_ops *kvm_arch_ops;
 struct kvm_stat kvm_stat;
 EXPORT_SYMBOL_GPL(kvm_stat);
@@ -230,9 +233,13 @@ static int kvm_dev_open(struct inode *in
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
 		mutex_init(&vcpu->mutex);
+		vcpu->cpu = -1;
 		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		INIT_LIST_HEAD(&vcpu->free_pages);
+		spin_lock(&kvm_lock);
+		list_add(&kvm->vm_list, &vm_list);
+		spin_unlock(&kvm_lock);
 	}
 	filp->private_data = kvm;
 	return 0;
@@ -292,6 +299,9 @@ static int kvm_dev_release(struct inode 
 {
 	struct kvm *kvm = filp->private_data;
 
+	spin_lock(&kvm_lock);
+	list_del(&kvm->vm_list);
+	spin_unlock(&kvm_lock);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
@@ -546,7 +556,6 @@ static int kvm_dev_ioctl_create_vcpu(str
 					   FX_IMAGE_ALIGN);
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
 
-	vcpu->cpu = -1;  /* First load will set up TR */
 	r = kvm_arch_ops->vcpu_create(vcpu);
 	if (r < 0)
 		goto out_free_vcpus;
Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -304,6 +304,7 @@ struct kvm {
 	int memory_config_version;
 	int busy;
 	unsigned long rmap_overflow;
+	struct list_head vm_list;
 };
 
 struct kvm_stat {
