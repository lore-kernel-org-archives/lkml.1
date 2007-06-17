Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXFQJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXFQJ63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbXFQJpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:55205 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 51/58] KVM: Move duplicate halt handling code into kvm_main.c
Date: Sun, 17 Jun 2007 12:44:32 +0300
Message-Id: <11820734813002-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will soon have a thid user.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   11 +++++++++++
 drivers/kvm/svm.c      |    7 +------
 drivers/kvm/vmx.c      |    7 +------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e665f55..ac358b8 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -504,6 +504,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  int size, unsigned long count, int string, int down,
 		  gva_t address, int rep, unsigned port);
 void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
 int emulate_clts(struct kvm_vcpu *vcpu);
 int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 230b25a..5564169 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1285,6 +1285,17 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(emulate_instruction);
 
+int kvm_emulate_halt(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->irq_summary)
+		return 1;
+
+	vcpu->run->exit_reason = KVM_EXIT_HLT;
+	++vcpu->stat.halt_exits;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_halt);
+
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	unsigned long nr, a0, a1, a2, a3, a4, a5, ret;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index ec040e2..70f386e 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1115,12 +1115,7 @@ static int halt_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 1;
 	skip_emulated_instruction(vcpu);
-	if (vcpu->irq_summary)
-		return 1;
-
-	kvm_run->exit_reason = KVM_EXIT_HLT;
-	++vcpu->stat.halt_exits;
-	return 0;
+	return kvm_emulate_halt(vcpu);
 }
 
 static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a534e6f..90abd3c 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1896,12 +1896,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 static int handle_halt(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	skip_emulated_instruction(vcpu);
-	if (vcpu->irq_summary)
-		return 1;
-
-	kvm_run->exit_reason = KVM_EXIT_HLT;
-	++vcpu->stat.halt_exits;
-	return 0;
+	return kvm_emulate_halt(vcpu);
 }
 
 static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
1.5.0.6

