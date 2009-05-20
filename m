Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZETL1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZETL1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZETLUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 33/46] KVM: ia64: Don't hold slots_lock in guest mode
Date: Wed, 20 May 2009 14:18:30 +0300
Message-Id: <1242818323-10413-34-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Reorder locking to avoid holding the slots_lock when entering
the guest.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by : Xiantao Zhang<xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |   64 +++++++++++++++++++++++----------------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 3bf0a34..f127fb7 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -632,34 +632,22 @@ static int kvm_vcpu_pre_transition(struct kvm_vcpu *vcpu)
 	vti_set_rr6(vcpu->arch.vmm_rr);
 	return kvm_insert_vmm_mapping(vcpu);
 }
+
 static void kvm_vcpu_post_transition(struct kvm_vcpu *vcpu)
 {
 	kvm_purge_vmm_mapping(vcpu);
 	vti_set_rr6(vcpu->arch.host_rr6);
 }
 
-static int  vti_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	union context *host_ctx, *guest_ctx;
 	int r;
 
-	/*Get host and guest context with guest address space.*/
-	host_ctx = kvm_get_host_context(vcpu);
-	guest_ctx = kvm_get_guest_context(vcpu);
-
-	r = kvm_vcpu_pre_transition(vcpu);
-	if (r < 0)
-		goto out;
-	kvm_vmm_info->tramp_entry(host_ctx, guest_ctx);
-	kvm_vcpu_post_transition(vcpu);
-	r = 0;
-out:
-	return r;
-}
-
-static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-{
-	int r;
+	/*
+	 * down_read() may sleep and return with interrupts enabled
+	 */
+	down_read(&vcpu->kvm->slots_lock);
 
 again:
 	if (signal_pending(current)) {
@@ -668,23 +656,28 @@ again:
 		goto out;
 	}
 
-	/*
-	 * down_read() may sleep and return with interrupts enabled
-	 */
-	down_read(&vcpu->kvm->slots_lock);
-
 	preempt_disable();
 	local_irq_disable();
 
+	/*Get host and guest context with guest address space.*/
+	host_ctx = kvm_get_host_context(vcpu);
+	guest_ctx = kvm_get_guest_context(vcpu);
+
 	vcpu->guest_mode = 1;
+
+	r = kvm_vcpu_pre_transition(vcpu);
+	if (r < 0)
+		goto vcpu_run_fail;
+
+	up_read(&vcpu->kvm->slots_lock);
 	kvm_guest_enter();
-	r = vti_vcpu_run(vcpu, kvm_run);
-	if (r < 0) {
-		local_irq_enable();
-		preempt_enable();
-		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		goto out;
-	}
+
+	/*
+	 * Transition to the guest
+	 */
+	kvm_vmm_info->tramp_entry(host_ctx, guest_ctx);
+
+	kvm_vcpu_post_transition(vcpu);
 
 	vcpu->arch.launched = 1;
 	vcpu->guest_mode = 0;
@@ -698,9 +691,10 @@ again:
 	 */
 	barrier();
 	kvm_guest_exit();
-	up_read(&vcpu->kvm->slots_lock);
 	preempt_enable();
 
+	down_read(&vcpu->kvm->slots_lock);
+
 	r = kvm_handle_exit(kvm_run, vcpu);
 
 	if (r > 0) {
@@ -709,12 +703,20 @@ again:
 	}
 
 out:
+	up_read(&vcpu->kvm->slots_lock);
 	if (r > 0) {
 		kvm_resched(vcpu);
+		down_read(&vcpu->kvm->slots_lock);
 		goto again;
 	}
 
 	return r;
+
+vcpu_run_fail:
+	local_irq_enable();
+	preempt_enable();
+	kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+	goto out;
 }
 
 static void kvm_set_mmio_data(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

