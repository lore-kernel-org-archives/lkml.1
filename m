Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYLNINj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYLNINj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYLNIHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 03/36] KVM: s390: Fix refcounting and allow module unload
Date: Sun, 14 Dec 2008 10:06:36 +0200
Message-Id: <1229242029-13410-4-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Currently it is impossible to unload the kvm module on s390.
This patch fixes kvm_arch_destroy_vm to release all cpus.
This make it possible to unload the module.

In addition we stop messing with the module refcount in arch code.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/kvm-s390.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8b00eb2..3db9e5d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -185,8 +185,6 @@ struct kvm *kvm_arch_create_vm(void)
 	debug_register_view(kvm->arch.dbf, &debug_sprintf_view);
 	VM_EVENT(kvm, 3, "%s", "vm created");
 
-	try_module_get(THIS_MODULE);
-
 	return kvm;
 out_nodbf:
 	free_page((unsigned long)(kvm->arch.sca));
@@ -196,13 +194,32 @@ out_nokvm:
 	return ERR_PTR(rc);
 }
 
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
+	free_page((unsigned long)(vcpu->arch.sie_block));
+	kfree(vcpu);
+}
+
+static void kvm_free_vcpus(struct kvm *kvm)
+{
+	unsigned int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+}
+
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	debug_unregister(kvm->arch.dbf);
+	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	free_page((unsigned long)(kvm->arch.sca));
+	debug_unregister(kvm->arch.dbf);
 	kfree(kvm);
-	module_put(THIS_MODULE);
 }
 
 /* Section: vcpu related */
@@ -308,8 +325,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	VM_EVENT(kvm, 3, "create cpu %d at %p, sie block at %p", id, vcpu,
 		 vcpu->arch.sie_block);
 
-	try_module_get(THIS_MODULE);
-
 	return vcpu;
 out_free_cpu:
 	kfree(vcpu);
@@ -317,14 +332,6 @@ out_nomem:
 	return ERR_PTR(rc);
 }
 
-void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-{
-	VCPU_EVENT(vcpu, 3, "%s", "destroy cpu");
-	free_page((unsigned long)(vcpu->arch.sie_block));
-	kfree(vcpu);
-	module_put(THIS_MODULE);
-}
-
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	/* kvm common code refers to this, but never calls it */
-- 
1.6.0.3

