Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXK0O06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXK0O06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXK0O0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:26:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:45670 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbXK0O0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:26:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 2.6.24-rc3
Date: Tue, 27 Nov 2007 16:27:28 +0200
Message-Id: <11961736482266-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the the kvm updates in

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

fixing some x86 emulator and AMD FPU handling regressions.

Amit Shah (2):
      KVM: x86 emulator: Use emulator_write_emulated and not emulator_write_std
      KVM: SVM: Fix FPU leak while emulating clts

Avi Kivity (1):
      KVM: SVM: Unload guest fpu on vcpu_put()

Izik Eidus (2):
      KVM: x86 emulator: fix JMP_REL
      KVM: x86 emulator: fix the saving of of the eip value

 drivers/kvm/kvm_main.c    |    3 +--
 drivers/kvm/svm.c         |    1 +
 drivers/kvm/x86_emulate.c |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 07ae280..47c10b8 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1188,8 +1188,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	vcpu->cr0 &= ~X86_CR0_TS;
-	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0);
+	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 7a6eead..4e04e49 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -663,6 +663,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
+	kvm_put_guest_fpu(vcpu);
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 33b1814..bd46de6 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -448,8 +448,7 @@ struct operand {
 
 #define JMP_REL(rel) 							\
 	do {								\
-		_eip += (int)(rel);					\
-		_eip = ((op_bytes == 2) ? (uint16_t)_eip : (uint32_t)_eip); \
+		register_address_increment(_eip, rel);			\
 	} while (0)
 
 /*
@@ -1147,7 +1146,7 @@ done_prefixes:
 			}
 			register_address_increment(_regs[VCPU_REGS_RSP],
 						   -dst.bytes);
-			if ((rc = ops->write_std(
+			if ((rc = ops->write_emulated(
 				     register_address(ctxt->ss_base,
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt->vcpu)) != 0)
@@ -1359,6 +1358,7 @@ special_insn:
 		}
 		src.val = (unsigned long) _eip;
 		JMP_REL(rel);
+		op_bytes = ad_bytes;
 		goto push;
 	}
 	case 0xe9: /* jmp rel */
