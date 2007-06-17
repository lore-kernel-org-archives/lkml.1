Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbXFQJ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbXFQJ7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXFQJph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:55188 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 52/58] KVM: Emulate hlt on real mode for Intel
Date: Sun, 17 Jun 2007 12:44:33 +0300
Message-Id: <11820734811851-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This has two use cases: the bios can't boot from disk, and guest smp
bootstrap.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    1 +
 drivers/kvm/vmx.c         |    7 ++++++-
 drivers/kvm/x86_emulate.c |    6 +++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ac358b8..d49b16c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -347,6 +347,7 @@ struct kvm_vcpu {
 			u32 ar;
 		} tr, es, ds, fs, gs;
 	} rmode;
+	int halt_request; /* real mode on Intel only */
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry cpuid_entries[KVM_MAX_CPUID_ENTRIES];
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 90abd3c..a1f51b9 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1608,8 +1608,13 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (vcpu->rmode.active &&
 	    handle_rmode_exception(vcpu, intr_info & INTR_INFO_VECTOR_MASK,
-								error_code))
+								error_code)) {
+		if (vcpu->halt_request) {
+			vcpu->halt_request = 0;
+			return kvm_emulate_halt(vcpu);
+		}
 		return 1;
+	}
 
 	if ((intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK)) == (INTR_TYPE_EXCEPTION | 1)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 6123c02..a4a8481 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -143,7 +143,8 @@ static u8 opcode_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
-	0, 0, ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
+	ImplicitOps, 0,
+	ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
 	/* 0xF8 - 0xFF */
 	0, 0, 0, 0,
 	0, 0, ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM
@@ -1149,6 +1150,9 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xf4:              /* hlt */
+		ctxt->vcpu->halt_request = 1;
+		goto done;
 	}
 	goto writeback;
 
-- 
1.5.0.6

