Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZLOEKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZLOEKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbZLOEHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbZLOEHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:13 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 09/20] Use TSC reference for SVM
Date: Mon, 14 Dec 2009 18:08:36 -1000
Message-Id: <1260850127-9766-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-9-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/kvm_timer.h        |   19 ++++++++++++++++
 arch/x86/kvm/svm.c              |   45 +++++++++++++--------------------------
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 758ffc2..26acb4c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -275,6 +275,7 @@ struct kvm_mmu {
 
 struct kvm_vcpu_arch {
 	u64 host_tsc;
+	u64 tsc_msr_offset;
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
diff --git a/arch/x86/kvm/kvm_timer.h b/arch/x86/kvm/kvm_timer.h
index 55c7524..3863161 100644
--- a/arch/x86/kvm/kvm_timer.h
+++ b/arch/x86/kvm/kvm_timer.h
@@ -16,3 +16,22 @@ struct kvm_timer_ops {
 
 enum hrtimer_restart kvm_timer_fn(struct hrtimer *data);
 
+u64 kvm_get_ref_tsc(void);
+
+static inline u64 kvm_get_elapsed_tsc(struct kvm *kvm)
+{
+	return kvm_get_ref_tsc() - kvm->arch.vm_init_tsc;
+}
+
+static inline u64 kvm_get_cpu_tsc(struct kvm_vcpu *vcpu)
+{
+	return kvm_get_elapsed_tsc(vcpu->kvm) + vcpu->arch.tsc_msr_offset;
+}
+
+static inline void kvm_set_cpu_tsc(struct kvm_vcpu *vcpu, u64 data)
+{
+	u64 tsc_offset;
+
+	tsc_offset = data - kvm_get_cpu_tsc(vcpu);
+	vcpu->arch.tsc_msr_offset = tsc_offset;
+}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 16c9048..29e88e5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -766,16 +766,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
-		u64 delta;
-
-		/*
-		 * Make sure that the guest sees a monotonically
-		 * increasing TSC.
-		 */
-		delta = vcpu->arch.host_tsc - native_read_tsc();
-		svm->vmcb->control.tsc_offset += delta;
-		if (is_nested(svm))
-			svm->nested.hsave->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
@@ -1826,7 +1816,6 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
-	svm->vmcb->control.tsc_offset += nested_vmcb->control.tsc_offset;
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
@@ -2030,12 +2019,20 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	return kvm_task_switch(&svm->vcpu, tss_selector, reason);
 }
 
-static int rdtsc_interception(struct vcpu_svm *svm)
+static u64 get_tsc(struct vcpu_svm *svm)
 {
 	u64 tsc;
 
-	rdtscll(tsc);
-	tsc += svm->vmcb->control.tsc_offset;
+	tsc = kvm_get_cpu_tsc(&svm->vcpu);
+	if (is_nested(svm))
+		tsc += svm->nested.hsave->control.tsc_offset;
+
+	return tsc;
+}
+
+static int rdtsc_interception(struct vcpu_svm *svm)
+{
+	u64 tsc = get_tsc(svm);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, tsc & 0xffffffff);
 	tsc >>= 32;
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RDX, tsc & 0xffffffff);
@@ -2095,14 +2092,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		u64 tsc_offset;
-
-		if (is_nested(svm))
-			tsc_offset = svm->nested.hsave->control.tsc_offset;
-		else
-			tsc_offset = svm->vmcb->control.tsc_offset;
-
-		*data = tsc_offset + native_read_tsc();
+		*data = get_tsc(svm);
 		break;
 	}
 	case MSR_K6_STAR:
@@ -2188,17 +2178,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		u64 tsc_offset = data - native_read_tsc();
-		u64 g_tsc_offset = 0;
-
 		if (is_nested(svm)) {
-			g_tsc_offset = svm->vmcb->control.tsc_offset -
-				       svm->nested.hsave->control.tsc_offset;
+			u64 tsc_offset = data - kvm_get_cpu_tsc(vcpu);
 			svm->nested.hsave->control.tsc_offset = tsc_offset;
+		} else {
+			kvm_set_cpu_tsc(vcpu, data);
 		}
-
-		svm->vmcb->control.tsc_offset = tsc_offset + g_tsc_offset;
-
 		break;
 	}
 	case MSR_K6_STAR:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 170fd5d..cb323f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5402,7 +5402,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	rdtscll(kvm->arch.vm_init_tsc);
+	kvm->arch.vm_init_tsc = kvm_get_ref_tsc();
 
 	return kvm;
 }
-- 
1.6.5.2

