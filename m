Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbZHWMAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbZHWMAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933709AbZHWMAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933544AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/46] KVM: Reduce runnability interface with arch support code
Date: Sun, 23 Aug 2009 14:56:25 +0300
Message-Id: <1251028605-31977-27-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Remove kvm_cpu_has_interrupt() and kvm_arch_interrupt_allowed() from
interface between general code and arch code. kvm_arch_vcpu_runnable()
checks for interrupts instead.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c        |   16 ++--------------
 arch/powerpc/kvm/powerpc.c      |   13 +------------
 arch/s390/kvm/interrupt.c       |    8 +-------
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/x86.c              |    6 ++++--
 include/linux/kvm_host.h        |    2 --
 virt/kvm/kvm_main.c             |    4 +---
 7 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d7aa6bb..0ad09f0 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1935,19 +1935,6 @@ int kvm_highest_pending_irq(struct kvm_vcpu *vcpu)
     return find_highest_bits((int *)&vpd->irr[0]);
 }
 
-int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
-{
-	if (kvm_highest_pending_irq(vcpu) != -1)
-		return 1;
-	return 0;
-}
-
-int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
-{
-	/* do real check here */
-	return 1;
-}
-
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.timer_fired;
@@ -1960,7 +1947,8 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE;
+	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE) ||
+		(kvm_highest_pending_irq(vcpu) != -1);
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0341391..2a4551f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -39,20 +39,9 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 	return gfn;
 }
 
-int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
-{
-	return !!(v->arch.pending_exceptions);
-}
-
-int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
-{
-	/* do real check here */
-	return 1;
-}
-
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return !(v->arch.msr & MSR_WE);
+	return !(v->arch.msr & MSR_WE) || !!(v->arch.pending_exceptions);
 }
 
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4d61341..2c2f983 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -283,7 +283,7 @@ static int __try_deliver_ckc_interrupt(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
+static int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_float_interrupt *fi = vcpu->arch.local_int.float_int;
@@ -320,12 +320,6 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
-{
-	/* do real check here */
-	return 1;
-}
-
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f4f00a..08732d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -797,6 +797,8 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
+int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2e1ffb..48567fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4886,8 +4886,10 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE
-	       || vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
-	       || vcpu->arch.nmi_pending;
+		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
+		|| vcpu->arch.nmi_pending ||
+		(kvm_arch_interrupt_allowed(vcpu) &&
+		 kvm_cpu_has_interrupt(vcpu));
 }
 
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c6a5f0..4af5603 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -332,7 +332,6 @@ int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
-int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
 
@@ -341,7 +340,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_free_all_assigned_devices(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
 
-int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d7b9bbb..532af9b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1666,9 +1666,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
-		if ((kvm_arch_interrupt_allowed(vcpu) &&
-					kvm_cpu_has_interrupt(vcpu)) ||
-				kvm_arch_vcpu_runnable(vcpu)) {
+		if (kvm_arch_vcpu_runnable(vcpu)) {
 			set_bit(KVM_REQ_UNHALT, &vcpu->requests);
 			break;
 		}
-- 
1.6.4.1

