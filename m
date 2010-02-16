Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab0BPKna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:43:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/38] KVM: SVM: Clean up and enhance mov dr emulation
Date: Tue, 16 Feb 2010 12:35:07 +0200
Message-Id: <1266316536-28936-10-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Enhance mov dr instruction emulation used by SVM so that it properly
handles dr4/5: alias to dr6/7 if cr4.de is cleared. Otherwise return
EMULATE_FAIL which will let our only possible caller in that scenario,
ud_interception, re-inject UD.

We do not need to inject faults, SVM does this for us (exceptions take
precedence over instruction interceptions). For the same reason, the
value overflow checks can be removed.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +--
 arch/x86/kvm/svm.c              |   64 +++++++++++++++++---------------------
 arch/x86/kvm/x86.c              |   19 +----------
 3 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a1f0b5d..d73ed48 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -506,9 +506,8 @@ struct kvm_x86_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
-	unsigned long (*get_dr)(struct kvm_vcpu *vcpu, int dr);
-	void (*set_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long value,
-		       int *exception);
+	int (*get_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long *dest);
+	int (*set_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8d7cb62..4295dfc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1122,76 +1122,70 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	svm->vmcb->control.asid = sd->next_asid++;
 }
 
-static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
+static int svm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *dest)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned long val;
 
 	switch (dr) {
 	case 0 ... 3:
-		val = vcpu->arch.db[dr];
+		*dest = vcpu->arch.db[dr];
 		break;
+	case 4:
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+			return EMULATE_FAIL; /* will re-inject UD */
+		/* fall through */
 	case 6:
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
-			val = vcpu->arch.dr6;
+			*dest = vcpu->arch.dr6;
 		else
-			val = svm->vmcb->save.dr6;
+			*dest = svm->vmcb->save.dr6;
 		break;
+	case 5:
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+			return EMULATE_FAIL; /* will re-inject UD */
+		/* fall through */
 	case 7:
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
-			val = vcpu->arch.dr7;
+			*dest = vcpu->arch.dr7;
 		else
-			val = svm->vmcb->save.dr7;
+			*dest = svm->vmcb->save.dr7;
 		break;
-	default:
-		val = 0;
 	}
 
-	return val;
+	return EMULATE_DONE;
 }
 
-static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
-		       int *exception)
+static int svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	*exception = 0;
-
 	switch (dr) {
 	case 0 ... 3:
 		vcpu->arch.db[dr] = value;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] = value;
-		return;
-	case 4 ... 5:
-		if (vcpu->arch.cr4 & X86_CR4_DE)
-			*exception = UD_VECTOR;
-		return;
+		break;
+	case 4:
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+			return EMULATE_FAIL; /* will re-inject UD */
+		/* fall through */
 	case 6:
-		if (value & 0xffffffff00000000ULL) {
-			*exception = GP_VECTOR;
-			return;
-		}
 		vcpu->arch.dr6 = (value & DR6_VOLATILE) | DR6_FIXED_1;
-		return;
+		break;
+	case 5:
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+			return EMULATE_FAIL; /* will re-inject UD */
+		/* fall through */
 	case 7:
-		if (value & 0xffffffff00000000ULL) {
-			*exception = GP_VECTOR;
-			return;
-		}
 		vcpu->arch.dr7 = (value & DR7_VOLATILE) | DR7_FIXED_1;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
 			svm->vmcb->save.dr7 = vcpu->arch.dr7;
 			vcpu->arch.switch_db_regs = (value & DR7_BP_EN_MASK);
 		}
-		return;
-	default:
-		/* FIXME: Possible case? */
-		printk(KERN_DEBUG "%s: unexpected dr %u\n",
-		       __func__, dr);
-		*exception = UD_VECTOR;
-		return;
+		break;
 	}
+
+	return EMULATE_DONE;
 }
 
 static int pf_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 322c2c5..fd5101b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3270,29 +3270,14 @@ int emulate_clts(struct kvm_vcpu *vcpu)
 
 int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
-	switch (dr) {
-	case 0 ... 3:
-		*dest = kvm_x86_ops->get_dr(vcpu, dr);
-		return X86EMUL_CONTINUE;
-	default:
-		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __func__, dr);
-		return X86EMUL_UNHANDLEABLE;
-	}
+	return kvm_x86_ops->get_dr(ctxt->vcpu, dr, dest);
 }
 
 int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
 {
 	unsigned long mask = (ctxt->mode == X86EMUL_MODE_PROT64) ? ~0ULL : ~0U;
-	int exception;
 
-	kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
-	if (exception) {
-		/* FIXME: better handling */
-		return X86EMUL_UNHANDLEABLE;
-	}
-	return X86EMUL_CONTINUE;
+	return kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask);
 }
 
 void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
-- 
1.6.5.3

