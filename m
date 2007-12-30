Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbXL3H2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbXL3H2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXL3HLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:41 -0500
Received: from il.qumranet.com ([82.166.9.18]:59491 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbXL3HKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:50 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 39/52] KVM: Split vcpu creation to avoid vcpu_load() before preemption setup
Date: Sun, 30 Dec 2007 09:10:25 +0200
Message-Id: <1198998638-22713-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split kvm_arch_vcpu_create() into kvm_arch_vcpu_create() and
kvm_arch_vcpu_setup(), enabling preemption notification between the two.
This mean that we can now do vcpu_load() within kvm_arch_vcpu_setup().

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    4 ++++
 drivers/kvm/x86.c      |   16 +++++++---------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 49094a2..b65f5de 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -466,6 +466,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5f3ef54..d99396b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -769,6 +769,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
+	r = kvm_arch_vcpu_setup(vcpu);
+	if (r)
+		goto vcpu_destroy;
+
 	mutex_lock(&kvm->lock);
 	if (kvm->vcpus[n]) {
 		r = -EEXIST;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 6abb2ed..b482b6a 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2478,13 +2478,12 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
-	int r;
-	struct kvm_vcpu *vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+	return kvm_x86_ops->vcpu_create(kvm, id);
+}
 
-	if (IS_ERR(vcpu)) {
-		r = -ENOMEM;
-		goto fail;
-	}
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	int r;
 
 	/* We do fxsave: this must be aligned. */
 	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
@@ -2497,11 +2496,10 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (r < 0)
 		goto free_vcpu;
 
-	return vcpu;
+	return 0;
 free_vcpu:
 	kvm_x86_ops->vcpu_free(vcpu);
-fail:
-	return ERR_PTR(r);
+	return r;
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

