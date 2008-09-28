Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbYI1Ppu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbYI1Ppu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYI1PpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYI1PpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 02/25] KVM: ia64: Implement kvm_arch_vcpu_ioctl_{set,get}_mpstate
Date: Sun, 28 Sep 2008 18:44:38 +0300
Message-Id: <1222616701-1206-3-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Two ioctl arch functions are added to set vcpu's smp state.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index cd0d1a7..7ad759e 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -179,6 +179,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_MP_STATE:
 
 		r = 1;
 		break;
@@ -1789,11 +1790,43 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	vcpu_load(vcpu);
+	mp_state->mp_state = vcpu->arch.mp_state;
+	vcpu_put(vcpu);
+	return 0;
+}
+
+static int vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	int r;
+	long psr;
+	local_irq_save(psr);
+	r = kvm_insert_vmm_mapping(vcpu);
+	if (r)
+		goto fail;
+
+	vcpu->arch.launched = 0;
+	kvm_arch_vcpu_uninit(vcpu);
+	r = kvm_arch_vcpu_init(vcpu);
+	if (r)
+		goto fail;
+
+	kvm_purge_vmm_mapping(vcpu);
+	r = 0;
+fail:
+	local_irq_restore(psr);
+	return r;
 }
 
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	int r = 0;
+
+	vcpu_load(vcpu);
+	vcpu->arch.mp_state = mp_state->mp_state;
+	if (vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
+		r = vcpu_reset(vcpu);
+	vcpu_put(vcpu);
+	return r;
 }
-- 
1.6.0.1

