Return-Path: <linux-kernel-owner+w=401wt.eu-S1422757AbXBUSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422757AbXBUSQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422758AbXBUSQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:16:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:47675 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757AbXBUSQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:16:37 -0500
Subject: [PATCH 4/6] KVM: Move kvm_vm_ioctl_create_vcpu() around
From: Avi Kivity <avi@qumranet.com>
Date: Wed, 21 Feb 2007 18:16:35 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45DC8B6E.5050205@qumranet.com>
In-Reply-To: <45DC8B6E.5050205@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070221181635.AD04D25016D@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of some hacking.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  102 ++++++++++++++++++++++++------------------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 981f5d3..6fb36c8 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -599,57 +599,6 @@ void fx_init(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(fx_init);
 
 /*
- * Creates some virtual cpus.  Good luck creating more than one.
- */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
-{
-	int r;
-	struct kvm_vcpu *vcpu;
-
-	r = -EINVAL;
-	if (!valid_vcpu(n))
-		goto out;
-
-	vcpu = &kvm->vcpus[n];
-
-	mutex_lock(&vcpu->mutex);
-
-	if (vcpu->vmcs) {
-		mutex_unlock(&vcpu->mutex);
-		return -EEXIST;
-	}
-
-	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
-					   FX_IMAGE_ALIGN);
-	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
-
-	r = kvm_arch_ops->vcpu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
-
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
-
-	kvm_arch_ops->vcpu_load(vcpu);
-	r = kvm_mmu_setup(vcpu);
-	if (r >= 0)
-		r = kvm_arch_ops->vcpu_setup(vcpu);
-	vcpu_put(vcpu);
-
-	if (r < 0)
-		goto out_free_vcpus;
-
-	return 0;
-
-out_free_vcpus:
-	kvm_free_vcpu(vcpu);
-	mutex_unlock(&vcpu->mutex);
-out:
-	return r;
-}
-
-/*
  * Allocate some memory and give it an address in the guest physical address
  * space.
  *
@@ -1964,6 +1913,57 @@ static int kvm_vm_ioctl_debug_guest(struct kvm *kvm,
 	return r;
 }
 
+/*
+ * Creates some virtual cpus.  Good luck creating more than one.
+ */
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
+{
+	int r;
+	struct kvm_vcpu *vcpu;
+
+	r = -EINVAL;
+	if (!valid_vcpu(n))
+		goto out;
+
+	vcpu = &kvm->vcpus[n];
+
+	mutex_lock(&vcpu->mutex);
+
+	if (vcpu->vmcs) {
+		mutex_unlock(&vcpu->mutex);
+		return -EEXIST;
+	}
+
+	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
+					   FX_IMAGE_ALIGN);
+	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
+
+	r = kvm_arch_ops->vcpu_create(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
+
+	kvm_arch_ops->vcpu_load(vcpu);
+	r = kvm_mmu_setup(vcpu);
+	if (r >= 0)
+		r = kvm_arch_ops->vcpu_setup(vcpu);
+	vcpu_put(vcpu);
+
+	if (r < 0)
+		goto out_free_vcpus;
+
+	return 0;
+
+out_free_vcpus:
+	kvm_free_vcpu(vcpu);
+	mutex_unlock(&vcpu->mutex);
+out:
+	return r;
+}
+
 static long kvm_vm_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
