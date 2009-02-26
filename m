Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZBZOSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZBZOSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbZBZOPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 04/40] KVM: SVM: Implement GIF, clgi and stgi
Date: Thu, 26 Feb 2009 16:14:54 +0200
Message-Id: <1235657730-27683-5-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

This patch implements the GIF flag and the clgi and stgi instructions that
set this flag. Only if the flag is set (default), interrupts can be received by
the CPU.

To keep the information about that somewhere, this patch adds a new hidden
flags vector. that is used to store information that does not go into the
vmcb, but is SVM specific.

I tried to write some code to make -no-kvm-irqchip work too, but the first
level guest won't even boot with that atm, so I ditched it.

v2 moves the hflags to x86 generic code
v3 makes use of the new permission helper
v6 only enables interrupt_window if GIF=1

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++
 arch/x86/kvm/svm.c              |   47 ++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2998efe..29e4157 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -259,6 +259,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr8;
+	u32 hflags;
 	u64 pdptrs[4]; /* pae */
 	u64 shadow_efer;
 	u64 apic_base;
@@ -738,6 +739,8 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
+#define HF_GIF_MASK		(1 << 0)
+
 /*
  * Hardware virtualization extension instructions may fault if a
  * reboot turns off virtualization while processes are running.
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 87debdc..79cc06b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -251,7 +251,7 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	kvm_rip_write(vcpu, svm->next_rip);
 	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
-	vcpu->arch.interrupt_window_open = 1;
+	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
 
 static int has_svm(void)
@@ -600,6 +600,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr4 = 0;
 	}
 	force_new_asid(&svm->vcpu);
+
+	svm->vcpu.arch.hflags = HF_GIF_MASK;
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -1234,6 +1236,36 @@ static int nested_svm_do(struct vcpu_svm *svm,
 	return retval;
 }
 
+static int stgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+	skip_emulated_instruction(&svm->vcpu);
+
+	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+
+	return 1;
+}
+
+static int clgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+	skip_emulated_instruction(&svm->vcpu);
+
+	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+
+	/* After a CLGI no interrupts should come */
+	svm_clear_vintr(svm);
+	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
+
+	return 1;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
@@ -1535,8 +1567,8 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
 	[SVM_EXIT_VMSAVE]			= invalid_op_interception,
-	[SVM_EXIT_STGI]				= invalid_op_interception,
-	[SVM_EXIT_CLGI]				= invalid_op_interception,
+	[SVM_EXIT_STGI]				= stgi_interception,
+	[SVM_EXIT_CLGI]				= clgi_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
@@ -1684,6 +1716,9 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 	if (!kvm_cpu_has_interrupt(vcpu))
 		goto out;
 
+	if (!(svm->vcpu.arch.hflags & HF_GIF_MASK))
+		goto out;
+
 	if (!(vmcb->save.rflags & X86_EFLAGS_IF) ||
 	    (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	    (vmcb->control.event_inj & SVM_EVTINJ_VALID)) {
@@ -1710,7 +1745,8 @@ static void kvm_reput_irq(struct vcpu_svm *svm)
 	}
 
 	svm->vcpu.arch.interrupt_window_open =
-		!(control->int_state & SVM_INTERRUPT_SHADOW_MASK);
+		!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
+		 (svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
 
 static void svm_do_inject_vector(struct vcpu_svm *svm)
@@ -1734,7 +1770,8 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 
 	svm->vcpu.arch.interrupt_window_open =
 		(!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		 (svm->vmcb->save.rflags & X86_EFLAGS_IF));
+		 (svm->vmcb->save.rflags & X86_EFLAGS_IF) &&
+		 (svm->vcpu.arch.hflags & HF_GIF_MASK));
 
 	if (svm->vcpu.arch.interrupt_window_open && svm->vcpu.arch.irq_summary)
 		/*
-- 
1.6.0.6

