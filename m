Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0BPKof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:44:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/38] KVM: VMX: Fix exceptions of mov to dr
Date: Tue, 16 Feb 2010 12:35:04 +0200
Message-Id: <1266316536-28936-7-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Injecting GP without an error code is a bad idea (causes unhandled guest
exits). Moreover, we must not skip the instruction if we injected an
exception.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 516084f..9727773 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3045,6 +3045,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int dr, reg;
 
+	/* Do not handle if the CPL > 0, will trigger GP on re-entry */
 	if (!kvm_require_cpl(vcpu, 0))
 		return 1;
 	dr = vmcs_readl(GUEST_DR7);
@@ -3099,20 +3100,22 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 				vcpu->arch.eff_db[dr] = val;
 			break;
 		case 4 ... 5:
-			if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+			if (kvm_read_cr4_bits(vcpu, X86_CR4_DE)) {
 				kvm_queue_exception(vcpu, UD_VECTOR);
+				return 1;
+			}
 			break;
 		case 6:
 			if (val & 0xffffffff00000000ULL) {
-				kvm_queue_exception(vcpu, GP_VECTOR);
-				break;
+				kvm_inject_gp(vcpu, 0);
+				return 1;
 			}
 			vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
 			break;
 		case 7:
 			if (val & 0xffffffff00000000ULL) {
-				kvm_queue_exception(vcpu, GP_VECTOR);
-				break;
+				kvm_inject_gp(vcpu, 0);
+				return 1;
 			}
 			vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 			if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
-- 
1.6.5.3

