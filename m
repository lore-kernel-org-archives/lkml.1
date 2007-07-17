Return-Path: <linux-kernel-owner+w=401wt.eu-S1765549AbXGQNXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765549AbXGQNXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXGQNWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:22:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:43820 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbXGQNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:22:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 3/3] KVM: x86 emulator: implement rdmsr and wrmsr
Date: Tue, 17 Jul 2007 16:22:52 +0300
Message-Id: <11846785722767-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11846785722851-git-send-email-avi@qumranet.com>
References: <11846785722851-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow real-mode emulation of rdmsr and wrmsr.  This allows smp Windows to
boot, presumably for its sipi trampoline.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 ++
 drivers/kvm/kvm_main.c    |    8 ++++----
 drivers/kvm/x86_emulate.c |   26 +++++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6636ae2..3ac9cbc 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -569,6 +569,8 @@ void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
 		     unsigned long *rflags);
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *data);
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 
 struct x86_emulate_ctxt;
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 05f0418..bcbe683 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL_GPL(kvm_get_msr_common);
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	return kvm_arch_ops->get_msr(vcpu, msr_index, pdata);
 }
@@ -1595,7 +1595,7 @@ EXPORT_SYMBOL_GPL(kvm_set_msr_common);
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	return kvm_arch_ops->set_msr(vcpu, msr_index, data);
 }
@@ -2133,7 +2133,7 @@ static __init void kvm_init_msr_list(void)
  */
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	return set_msr(vcpu, index, *data);
+	return kvm_set_msr(vcpu, index, *data);
 }
 
 /*
@@ -2617,7 +2617,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_MSRS:
-		r = msr_io(vcpu, argp, get_msr, 1);
+		r = msr_io(vcpu, argp, kvm_get_msr, 1);
 		break;
 	case KVM_SET_MSRS:
 		r = msr_io(vcpu, argp, do_set_msr, 0);
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f60012d..1b800fc 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -163,7 +163,7 @@ static u16 twobyte_table[256] = {
 	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	ImplicitOps, 0, ImplicitOps, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
@@ -486,6 +486,7 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	unsigned long modrm_ea;
 	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
 	int no_wb = 0;
+	u64 msr_data;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 	unsigned long _regs[NR_VCPU_REGS];
@@ -1344,6 +1345,29 @@ twobyte_special_insn:
 			goto cannot_emulate;
 		realmode_set_cr(ctxt->vcpu, modrm_reg, modrm_val, &_eflags);
 		break;
+	case 0x30:
+		/* wrmsr */
+		msr_data = (u32)_regs[VCPU_REGS_RAX]
+			| ((u64)_regs[VCPU_REGS_RDX] << 32);
+		rc = kvm_set_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], msr_data);
+		if (rc) {
+			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			_eip = ctxt->vcpu->rip;
+		}
+		rc = X86EMUL_CONTINUE;
+		break;
+	case 0x32:
+		/* rdmsr */
+		rc = kvm_get_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], &msr_data);
+		if (rc) {
+			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			_eip = ctxt->vcpu->rip;
+		} else {
+			_regs[VCPU_REGS_RAX] = (u32)msr_data;
+			_regs[VCPU_REGS_RDX] = msr_data >> 32;
+		}
+		rc = X86EMUL_CONTINUE;
+		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 		{
 			u64 old, new;
-- 
1.5.2.4

