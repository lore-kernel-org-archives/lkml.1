Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYLIUgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYLIUgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYLIUYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 31/44] KVM: ia64: Add handler for crashed vmm
Date: Tue,  9 Dec 2008 22:22:46 +0200
Message-Id: <1228854179-23002-32-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Since vmm runs in an isolated address space and it is just a copy
of host's kvm-intel module, so once vmm crashes, we just crash all guests
running on it instead of crashing whole kernel.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/process.c |   20 ++++++++++++++++++++
 arch/ia64/kvm/vcpu.h    |    3 +++
 arch/ia64/kvm/vmm.c     |    2 ++
 arch/ia64/kvm/vmm_ivt.S |   31 +++++++++++++++++++------------
 4 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index cefc349..552d077 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -942,8 +942,20 @@ static void vcpu_do_resume(struct kvm_vcpu *vcpu)
 	ia64_set_pta(vcpu->arch.vhpt.pta.val);
 }
 
+static void vmm_sanity_check(struct kvm_vcpu *vcpu)
+{
+	struct exit_ctl_data *p = &vcpu->arch.exit_data;
+
+	if (!vmm_sanity && p->exit_reason != EXIT_REASON_DEBUG) {
+		panic_vm(vcpu, "Failed to do vmm sanity check,"
+			"it maybe caused by crashed vmm!!\n\n");
+	}
+}
+
 static void kvm_do_resume_op(struct kvm_vcpu *vcpu)
 {
+	vmm_sanity_check(vcpu); /*Guarantee vcpu runing on healthy vmm!*/
+
 	if (test_and_clear_bit(KVM_REQ_RESUME, &vcpu->requests)) {
 		vcpu_do_resume(vcpu);
 		return;
@@ -969,3 +981,11 @@ void vmm_transition(struct kvm_vcpu *vcpu)
 						1, 0, 0, 0, 0, 0);
 	kvm_do_resume_op(vcpu);
 }
+
+void vmm_panic_handler(u64 vec)
+{
+	struct kvm_vcpu *vcpu = current_vcpu;
+	vmm_sanity = 0;
+	panic_vm(vcpu, "Unexpected interruption occurs in VMM, vector:0x%lx\n",
+			vec2off[vec]);
+}
diff --git a/arch/ia64/kvm/vcpu.h b/arch/ia64/kvm/vcpu.h
index 0dad842..b2f12a5 100644
--- a/arch/ia64/kvm/vcpu.h
+++ b/arch/ia64/kvm/vcpu.h
@@ -741,5 +741,8 @@ void panic_vm(struct kvm_vcpu *v, const char *fmt, ...);
 
 extern u64 ia64_call_vsa(u64 proc, u64 arg1, u64 arg2, u64 arg3,
 		u64 arg4, u64 arg5, u64 arg6, u64 arg7);
+
+extern long vmm_sanity;
+
 #endif
 #endif	/* __VCPU_H__ */
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index d3dc0b0..9eee5c0 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -32,6 +32,8 @@ MODULE_LICENSE("GPL");
 extern char kvm_ia64_ivt;
 extern fpswa_interface_t *vmm_fpswa_interface;
 
+long vmm_sanity = 1;
+
 struct kvm_vmm_info vmm_info = {
 	.module	     = THIS_MODULE,
 	.vmm_entry   = vmm_entry,
diff --git a/arch/ia64/kvm/vmm_ivt.S b/arch/ia64/kvm/vmm_ivt.S
index c1d7251..50b4646 100644
--- a/arch/ia64/kvm/vmm_ivt.S
+++ b/arch/ia64/kvm/vmm_ivt.S
@@ -70,14 +70,12 @@
 # define PSR_DEFAULT_BITS   0
 #endif
 
-
 #define KVM_FAULT(n)    \
     kvm_fault_##n:;          \
     mov r19=n;;          \
-    br.sptk.many kvm_fault_##n;         \
+    br.sptk.many kvm_vmm_panic;         \
     ;;                  \
 
-
 #define KVM_REFLECT(n)    \
     mov r31=pr;           \
     mov r19=n;       /* prepare to save predicates */ \
@@ -85,17 +83,26 @@
     ;;      \
     tbit.z p6,p7=r29,IA64_PSR_VM_BIT;       \
 (p7)br.sptk.many kvm_dispatch_reflection;        \
-    br.sptk.many kvm_panic;      \
-
+    br.sptk.many kvm_vmm_panic;      \
 
-GLOBAL_ENTRY(kvm_panic)
-    br.sptk.many kvm_panic
+GLOBAL_ENTRY(kvm_vmm_panic)
+    KVM_SAVE_MIN_WITH_COVER_R19
+    alloc r14=ar.pfs,0,0,1,0
+    mov out0=r15
+    adds r3=8,r2                // set up second base pointer
     ;;
-END(kvm_panic)
-
-
-
-
+    ssm psr.ic
+    ;;
+    srlz.i                  // guarantee that interruption collection is on
+    ;;
+    //(p15) ssm psr.i               // restore psr.i
+    addl r14=@gprel(ia64_leave_hypervisor),gp
+    ;;
+    KVM_SAVE_REST
+    mov rp=r14
+    ;;
+    br.call.sptk.many b6=vmm_panic_handler;
+END(kvm_vmm_panic)
 
     .section .text.ivt,"ax"
 
-- 
1.6.0.3

