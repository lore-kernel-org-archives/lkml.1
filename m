Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbXLWOxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbXLWOxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXLWOvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:35897 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbXLWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:39 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 07/50] KVM: Call x86_decode_insn() only when needed
Date: Sun, 23 Dec 2007 16:50:52 +0200
Message-Id: <1198421495-31481-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Move emulate_ctxt to kvm_vcpu to keep emulate context when we exit from kvm
module. Call x86_decode_insn() only when needed. Modify x86_emulate_insn() to
not modify the context if it must be re-entered.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    8 ++++-
 drivers/kvm/kvm_main.c    |   77 +++++++++++++++++++++++++-------------------
 drivers/kvm/svm.c         |    9 +++--
 drivers/kvm/vmx.c         |    9 +++--
 drivers/kvm/x86_emulate.c |   24 ++++++++++++--
 5 files changed, 82 insertions(+), 45 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index da9c3aa..e885b19 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -207,6 +207,8 @@ enum {
 	VCPU_SREG_LDTR,
 };
 
+#include "x86_emulate.h"
+
 struct kvm_pio_request {
 	unsigned long count;
 	int cur_count;
@@ -380,6 +382,10 @@ struct kvm_vcpu {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+
+	/* emulate context */
+
+	struct x86_emulate_ctxt emulate_ctxt;
 };
 
 struct kvm_mem_alias {
@@ -555,7 +561,7 @@ enum emulation_result {
 };
 
 int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			unsigned long cr2, u16 error_code);
+			unsigned long cr2, u16 error_code, int no_decode);
 void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
 void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
 void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 39c54d5..fad3a08 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1251,45 +1251,56 @@ struct x86_emulate_ops emulate_ops = {
 int emulate_instruction(struct kvm_vcpu *vcpu,
 			struct kvm_run *run,
 			unsigned long cr2,
-			u16 error_code)
+			u16 error_code,
+			int no_decode)
 {
-	struct x86_emulate_ctxt emulate_ctxt;
-	int r;
-	int cs_db, cs_l;
+	int r = 0;
 
 	vcpu->mmio_fault_cr2 = cr2;
 	kvm_x86_ops->cache_regs(vcpu);
 
-	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
-
-	emulate_ctxt.vcpu = vcpu;
-	emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
-	emulate_ctxt.cr2 = cr2;
-	emulate_ctxt.mode = (emulate_ctxt.eflags & X86_EFLAGS_VM)
-		? X86EMUL_MODE_REAL : cs_l
-		? X86EMUL_MODE_PROT64 :	cs_db
-		? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
-
-	if (emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
-		emulate_ctxt.cs_base = 0;
-		emulate_ctxt.ds_base = 0;
-		emulate_ctxt.es_base = 0;
-		emulate_ctxt.ss_base = 0;
-	} else {
-		emulate_ctxt.cs_base = get_segment_base(vcpu, VCPU_SREG_CS);
-		emulate_ctxt.ds_base = get_segment_base(vcpu, VCPU_SREG_DS);
-		emulate_ctxt.es_base = get_segment_base(vcpu, VCPU_SREG_ES);
-		emulate_ctxt.ss_base = get_segment_base(vcpu, VCPU_SREG_SS);
-	}
-
-	emulate_ctxt.gs_base = get_segment_base(vcpu, VCPU_SREG_GS);
-	emulate_ctxt.fs_base = get_segment_base(vcpu, VCPU_SREG_FS);
-
 	vcpu->mmio_is_write = 0;
 	vcpu->pio.string = 0;
-	r = x86_decode_insn(&emulate_ctxt, &emulate_ops);
+
+	if (!no_decode) {
+		int cs_db, cs_l;
+		kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+
+		vcpu->emulate_ctxt.vcpu = vcpu;
+		vcpu->emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
+		vcpu->emulate_ctxt.cr2 = cr2;
+		vcpu->emulate_ctxt.mode =
+			(vcpu->emulate_ctxt.eflags & X86_EFLAGS_VM)
+			? X86EMUL_MODE_REAL : cs_l
+			? X86EMUL_MODE_PROT64 :	cs_db
+			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
+
+		if (vcpu->emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
+			vcpu->emulate_ctxt.cs_base = 0;
+			vcpu->emulate_ctxt.ds_base = 0;
+			vcpu->emulate_ctxt.es_base = 0;
+			vcpu->emulate_ctxt.ss_base = 0;
+		} else {
+			vcpu->emulate_ctxt.cs_base =
+					get_segment_base(vcpu, VCPU_SREG_CS);
+			vcpu->emulate_ctxt.ds_base =
+					get_segment_base(vcpu, VCPU_SREG_DS);
+			vcpu->emulate_ctxt.es_base =
+					get_segment_base(vcpu, VCPU_SREG_ES);
+			vcpu->emulate_ctxt.ss_base =
+					get_segment_base(vcpu, VCPU_SREG_SS);
+		}
+
+		vcpu->emulate_ctxt.gs_base =
+					get_segment_base(vcpu, VCPU_SREG_GS);
+		vcpu->emulate_ctxt.fs_base =
+					get_segment_base(vcpu, VCPU_SREG_FS);
+
+		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
+	}
+
 	if (r == 0)
-		r = x86_emulate_insn(&emulate_ctxt, &emulate_ops);
+		r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
 
 	if (vcpu->pio.string)
 		return EMULATE_DO_MMIO;
@@ -1313,7 +1324,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	}
 
 	kvm_x86_ops->decache_regs(vcpu);
-	kvm_x86_ops->set_rflags(vcpu, emulate_ctxt.eflags);
+	kvm_x86_ops->set_rflags(vcpu, vcpu->emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write) {
 		vcpu->mmio_needed = 0;
@@ -2055,7 +2066,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->mmio_read_completed = 1;
 		vcpu->mmio_needed = 0;
 		r = emulate_instruction(vcpu, kvm_run,
-					vcpu->mmio_fault_cr2, 0);
+					vcpu->mmio_fault_cr2, 0, 1);
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 5883f3e..a0eef78 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -960,7 +960,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		return 1;
 	}
 	er = emulate_instruction(&svm->vcpu, kvm_run, fault_address,
-				 error_code);
+				 error_code, 0);
 	mutex_unlock(&kvm->lock);
 
 	switch (er) {
@@ -984,7 +984,7 @@ static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	int er;
 
-	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
+	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0, 0);
 	if (er != EMULATE_DONE)
 		inject_ud(&svm->vcpu);
 
@@ -1027,7 +1027,8 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 
 	if (string) {
-		if (emulate_instruction(&svm->vcpu, kvm_run, 0, 0) == EMULATE_DO_MMIO)
+		if (emulate_instruction(&svm->vcpu,
+					kvm_run, 0, 0, 0) == EMULATE_DO_MMIO)
 			return 0;
 		return 1;
 	}
@@ -1086,7 +1087,7 @@ static int cpuid_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int emulate_on_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
-	if (emulate_instruction(&svm->vcpu, NULL, 0, 0) != EMULATE_DONE)
+	if (emulate_instruction(&svm->vcpu, NULL, 0, 0, 0) != EMULATE_DONE)
 		pr_unimpl(&svm->vcpu, "%s: failed\n", __FUNCTION__);
 	return 1;
 }
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 77d061b..dcc0a84 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1750,7 +1750,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	 * Cause the #SS fault with 0 error code in VM86 mode.
 	 */
 	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0)
-		if (emulate_instruction(vcpu, NULL, 0, 0) == EMULATE_DONE)
+		if (emulate_instruction(vcpu, NULL, 0, 0, 0) == EMULATE_DONE)
 			return 1;
 	return 0;
 }
@@ -1787,7 +1787,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	if (is_invalid_opcode(intr_info)) {
-		er = emulate_instruction(vcpu, kvm_run, 0, 0);
+		er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
 		if (er != EMULATE_DONE)
 			vmx_inject_ud(vcpu);
 
@@ -1812,7 +1812,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			return 1;
 		}
 
-		er = emulate_instruction(vcpu, kvm_run, cr2, error_code);
+		er = emulate_instruction(vcpu, kvm_run, cr2, error_code, 0);
 		mutex_unlock(&vcpu->kvm->lock);
 
 		switch (er) {
@@ -1873,7 +1873,8 @@ static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	string = (exit_qualification & 16) != 0;
 
 	if (string) {
-		if (emulate_instruction(vcpu, kvm_run, 0, 0) == EMULATE_DO_MMIO)
+		if (emulate_instruction(vcpu,
+					kvm_run, 0, 0, 0) == EMULATE_DO_MMIO)
 			return 0;
 		return 1;
 	}
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9290083..cab1719 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -913,10 +913,19 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	unsigned long cr2 = ctxt->cr2;
 	int no_wb = 0;
 	u64 msr_data;
+	unsigned long saved_eip = 0;
 	unsigned long _eflags = ctxt->eflags;
 	struct decode_cache *c = &ctxt->decode;
 	int rc = 0;
 
+	/* Shadow copy of register state. Committed on successful emulation.
+	 * NOTE: we can copy them from vcpu as x86_decode_insn() doesn't
+	 * modify them.
+	 */
+
+	memcpy(c->regs, ctxt->vcpu->regs, sizeof c->regs);
+	saved_eip = c->eip;
+
 	if ((c->d & ModRM) && (c->modrm_mod != 3))
 		cr2 = c->modrm_ea;
 
@@ -1250,7 +1259,11 @@ writeback:
 	ctxt->vcpu->rip = c->eip;
 
 done:
-	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
+	if (rc == X86EMUL_UNHANDLEABLE) {
+		c->eip = saved_eip;
+		return -1;
+	}
+	return 0;
 
 special_insn:
 	if (c->twobyte)
@@ -1305,8 +1318,10 @@ push:
 				register_address(ctxt->es_base,
 						 c->regs[VCPU_REGS_RDI]),
 				c->rep_prefix,
-				c->regs[VCPU_REGS_RDX]) == 0)
+				c->regs[VCPU_REGS_RDX]) == 0) {
+			c->eip = saved_eip;
 			return -1;
+		}
 		return 0;
 	case 0x6e:		/* outsb */
 	case 0x6f:		/* outsw/outsd */
@@ -1321,8 +1336,10 @@ push:
 							ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
 				c->rep_prefix,
-				c->regs[VCPU_REGS_RDX]) == 0)
+				c->regs[VCPU_REGS_RDX]) == 0) {
+			c->eip = saved_eip;
 			return -1;
+		}
 		return 0;
 	case 0x70 ... 0x7f: /* jcc (short) */ {
 		int rel = insn_fetch(s8, 1, c->eip);
@@ -1711,5 +1728,6 @@ twobyte_special_insn:
 
 cannot_emulate:
 	DPRINTF("Cannot emulate %02x\n", c->b);
+	c->eip = saved_eip;
 	return -1;
 }
-- 
1.5.3.7

