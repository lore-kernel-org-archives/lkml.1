Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZETL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZETL3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZETLUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55272 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 30/46] KVM: x86 emulator: Add new mode of instruction emulation: skip
Date: Wed, 20 May 2009 14:18:27 +0300
Message-Id: <1242818323-10413-31-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

In the new mode instruction is decoded, but not executed. The EIP
is moved to point after the instruction.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0e3a7c6..cb306cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -562,6 +562,7 @@ enum emulation_result {
 
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
+#define EMULTYPE_SKIP		    (1 << 2)
 int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long cr2, u16 error_code, int emulation_type);
 void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b89d9b..0c45df9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2409,6 +2409,11 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (emulation_type & EMULTYPE_SKIP) {
+		kvm_rip_write(vcpu, vcpu->arch.emulate_ctxt.decode.eip);
+		return EMULATE_DONE;
+	}
+
 	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 
 	if (vcpu->arch.pio.string)
-- 
1.6.0.6

