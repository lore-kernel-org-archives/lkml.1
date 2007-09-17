Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXIQIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXIQIcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXIQIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:45224 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbXIQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Qing He <qing.he@intel.com>
Subject: [PATCH 002/104] KVM: SMP: Add vcpu_id field in struct vcpu
Date: Mon, 17 Sep 2007 10:30:44 +0200
Message-Id: <11900179462286-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing He <qing.he@intel.com>

This patch adds a `vcpu_id' field in `struct vcpu', so we can
differentiate BSP and APs without pointer comparison or arithmetic.

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    1 +
 drivers/kvm/svm.c      |    2 +-
 drivers/kvm/vmx.c      |    2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 336be86..b629a83 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -328,6 +328,7 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	int vcpu_id;
 	union {
 		struct vmcs *vmcs;
 		struct vcpu_svm *svm;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 36a458f..df9c05e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2355,6 +2355,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		goto out;
 
 	vcpu = &kvm->vcpus[n];
+	vcpu->vcpu_id = n;
 
 	mutex_lock(&vcpu->mutex);
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index bc818cc..52a11cc 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -591,7 +591,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 	vcpu->fpu_active = 1;
 	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vcpu == &vcpu->kvm->vcpus[0])
+	if (vcpu->vcpu_id == 0)
 		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
 
 	return 0;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 80628f6..7fa62c7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1253,7 +1253,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	vcpu->cr8 = 0;
 	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vcpu == &vcpu->kvm->vcpus[0])
+	if (vcpu->vcpu_id == 0)
 		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
 
 	fx_init(vcpu);
-- 
1.5.3

