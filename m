Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab0BPKnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:43:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/38] KVM: VMX: Fix emulation of DR4 and DR5
Date: Tue, 16 Feb 2010 12:35:05 +0200
Message-Id: <1266316536-28936-8-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Make sure DR4 and DR5 are aliased to DR6 and DR7, respectively, if
CR4.DE is not set.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9727773..c7b99e1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3039,6 +3039,15 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int check_dr_alias(struct kvm_vcpu *vcpu)
+{
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_DE)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return -1;
+	}
+	return 0;
+}
+
 static int handle_dr(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
@@ -3081,14 +3090,20 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		case 0 ... 3:
 			val = vcpu->arch.db[dr];
 			break;
+		case 4:
+			if (check_dr_alias(vcpu) < 0)
+				return 1;
+			/* fall through */
 		case 6:
 			val = vcpu->arch.dr6;
 			break;
-		case 7:
+		case 5:
+			if (check_dr_alias(vcpu) < 0)
+				return 1;
+			/* fall through */
+		default: /* 7 */
 			val = vcpu->arch.dr7;
 			break;
-		default:
-			val = 0;
 		}
 		kvm_register_write(vcpu, reg, val);
 	} else {
@@ -3099,12 +3114,10 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 				vcpu->arch.eff_db[dr] = val;
 			break;
-		case 4 ... 5:
-			if (kvm_read_cr4_bits(vcpu, X86_CR4_DE)) {
-				kvm_queue_exception(vcpu, UD_VECTOR);
+		case 4:
+			if (check_dr_alias(vcpu) < 0)
 				return 1;
-			}
-			break;
+			/* fall through */
 		case 6:
 			if (val & 0xffffffff00000000ULL) {
 				kvm_inject_gp(vcpu, 0);
@@ -3112,7 +3125,11 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			}
 			vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
 			break;
-		case 7:
+		case 5:
+			if (check_dr_alias(vcpu) < 0)
+				return 1;
+			/* fall through */
+		default: /* 7 */
 			if (val & 0xffffffff00000000ULL) {
 				kvm_inject_gp(vcpu, 0);
 				return 1;
-- 
1.6.5.3

