Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbYAFOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbYAFOtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYAFOkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:21 -0500
Received: from il.qumranet.com ([82.166.9.18]:46646 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbYAFOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 33/33] KVM: x86 emulator: Only allow VMCALL/VMMCALL trapped by #UD
Date: Sun,  6 Jan 2008 16:39:39 +0200
Message-Id: <1199630379-28638-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

When executing a test program called "crashme", we found the KVM guest cannot
survive more than ten seconds, then encounterd kernel panic. The basic concept
of "crashme" is generating random assembly code and trying to execute it.

After some fixes on emulator insn validity judgment, we found it's hard to
get the current emulator handle the invalid instructions correctly, for the
#UD trap for hypercall patching caused troubles. The problem is, if the opcode
itself was OK, but combination of opcode and modrm_reg was invalid, and one
operand of the opcode was memory (SrcMem or DstMem), the emulator will fetch
the memory operand first rather than checking the validity, and may encounter
an error there. For example, ".byte 0xfe, 0x34, 0xcd" has this problem.

In the patch, we simply check that if the invalid opcode wasn't vmcall/vmmcall,
then return from emulate_instruction() and inject a #UD to guest. With the
patch, the guest had been running for more than 12 hours.

Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |    2 +-
 arch/x86/kvm/vmx.c         |    2 +-
 arch/x86/kvm/x86.c         |   18 +++++++++++++++---
 include/asm-x86/kvm_host.h |    4 +++-
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 11e5baf..2da9e11 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -942,7 +942,7 @@ static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	int er;
 
-	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0, 0);
+	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0, EMULTYPE_TRAP_UD);
 	if (er != EMULATE_DONE)
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 	return 1;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4741806..5346e42 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1862,7 +1862,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	if (is_invalid_opcode(intr_info)) {
-		er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
+		er = emulate_instruction(vcpu, kvm_run, 0, 0, EMULTYPE_TRAP_UD);
 		if (er != EMULATE_DONE)
 			kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3b3141..8a90403 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1840,9 +1840,10 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			struct kvm_run *run,
 			unsigned long cr2,
 			u16 error_code,
-			int no_decode)
+			int emulation_type)
 {
 	int r;
+	struct decode_cache *c;
 
 	vcpu->arch.mmio_fault_cr2 = cr2;
 	kvm_x86_ops->cache_regs(vcpu);
@@ -1850,7 +1851,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	vcpu->mmio_is_write = 0;
 	vcpu->arch.pio.string = 0;
 
-	if (!no_decode) {
+	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		int cs_db, cs_l;
 		kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
@@ -1884,6 +1885,16 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 					get_segment_base(vcpu, VCPU_SREG_FS);
 
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
+
+		/* Reject the instructions other than VMCALL/VMMCALL when
+		 * try to emulate invalid opcode */
+		c = &vcpu->arch.emulate_ctxt.decode;
+		if ((emulation_type & EMULTYPE_TRAP_UD) &&
+		    (!(c->twobyte && c->b == 0x01 &&
+		      (c->modrm_reg == 0 || c->modrm_reg == 3) &&
+		       c->modrm_mod == 3 && c->modrm_rm == 1)))
+			return EMULATE_FAIL;
+
 		++vcpu->stat.insn_emulation;
 		if (r)  {
 			++vcpu->stat.insn_emulation_fail;
@@ -2640,7 +2651,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->mmio_read_completed = 1;
 		vcpu->mmio_needed = 0;
 		r = emulate_instruction(vcpu, kvm_run,
-					vcpu->arch.mmio_fault_cr2, 0, 1);
+					vcpu->arch.mmio_fault_cr2, 0,
+					EMULTYPE_NO_DECODE);
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 20597bc..4702b04 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -415,8 +415,10 @@ enum emulation_result {
 	EMULATE_FAIL,         /* can't emulate this instruction */
 };
 
+#define EMULTYPE_NO_DECODE	    (1 << 0)
+#define EMULTYPE_TRAP_UD	    (1 << 1)
 int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			unsigned long cr2, u16 error_code, int no_decode);
+			unsigned long cr2, u16 error_code, int emulation_type);
 void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
 void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
 void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
-- 
1.5.3.7

