Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXIQIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXIQIy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXIQIdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXIQIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 096/104] KVM: Improve emulation failure reporting
Date: Mon, 17 Sep 2007 10:32:18 +0200
Message-Id: <1190017949507-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Report failed opcodes from all locations.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   16 ++++++++--------
 drivers/kvm/svm.c      |    2 +-
 drivers/kvm/vmx.c      |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d93ab48..ad08138 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -558,6 +558,7 @@ enum emulation_result {
 
 int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long cr2, u16 error_code);
+void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
 void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
 void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
 void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e6301ce..99e4917 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1240,25 +1240,25 @@ int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
 	return X86EMUL_CONTINUE;
 }
 
-static void report_emulation_failure(struct x86_emulate_ctxt *ctxt)
+void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 {
 	static int reported;
 	u8 opcodes[4];
-	unsigned long rip = ctxt->vcpu->rip;
+	unsigned long rip = vcpu->rip;
 	unsigned long rip_linear;
 
-	rip_linear = rip + get_segment_base(ctxt->vcpu, VCPU_SREG_CS);
+	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
 
 	if (reported)
 		return;
 
-	emulator_read_std(rip_linear, (void *)opcodes, 4, ctxt->vcpu);
+	emulator_read_std(rip_linear, (void *)opcodes, 4, vcpu);
 
-	printk(KERN_ERR "emulation failed but !mmio_needed?"
-	       " rip %lx %02x %02x %02x %02x\n",
-	       rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
+	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
+	       context, rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
 	reported = 1;
 }
+EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
 struct x86_emulate_ops emulate_ops = {
 	.read_std            = emulator_read_std,
@@ -1323,7 +1323,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
 			return EMULATE_DONE;
 		if (!vcpu->mmio_needed) {
-			report_emulation_failure(&emulate_ctxt);
+			kvm_report_emulation_failure(vcpu, "mmio");
 			return EMULATE_FAIL;
 		}
 		return EMULATE_DO_MMIO;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 95681ea..729f1cd 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -960,7 +960,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		++svm->vcpu.stat.mmio_exits;
 		return 0;
 	case EMULATE_FAIL:
-		vcpu_printf(&svm->vcpu, "%s: emulate fail\n", __FUNCTION__);
+		kvm_report_emulation_failure(&svm->vcpu, "pagetable");
 		break;
 	default:
 		BUG();
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c44c9ac..4f115a8 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1798,7 +1798,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			++vcpu->stat.mmio_exits;
 			return 0;
 		 case EMULATE_FAIL:
-			vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);
+			kvm_report_emulation_failure(vcpu, "pagetable");
 			break;
 		default:
 			BUG();
-- 
1.5.3

