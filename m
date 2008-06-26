Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbYFZMr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbYFZMr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYFZMaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:09 -0400
Received: from il.qumranet.com ([212.179.150.194]:32339 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYFZM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/50] KVM: add missing kvmtrace bits
Date: Thu, 26 Jun 2008 15:27:48 +0300
Message-Id: <1214483312-9265-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds some kvmtrace bits to the generic x86 code
where it is instrumented from SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a85a29..cc5b0d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2020,6 +2020,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
+	KVMTRACE_0D(CLTS, vcpu, handler);
 	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
@@ -2600,27 +2601,41 @@ void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 {
+	unsigned long value;
+
 	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	switch (cr) {
 	case 0:
-		return vcpu->arch.cr0;
+		value = vcpu->arch.cr0;
+		break;
 	case 2:
-		return vcpu->arch.cr2;
+		value = vcpu->arch.cr2;
+		break;
 	case 3:
-		return vcpu->arch.cr3;
+		value = vcpu->arch.cr3;
+		break;
 	case 4:
-		return vcpu->arch.cr4;
+		value = vcpu->arch.cr4;
+		break;
 	case 8:
-		return kvm_get_cr8(vcpu);
+		value = kvm_get_cr8(vcpu);
+		break;
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 		return 0;
 	}
+	KVMTRACE_3D(CR_READ, vcpu, (u32)cr, (u32)value,
+		    (u32)((u64)value >> 32), handler);
+
+	return value;
 }
 
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		     unsigned long *rflags)
 {
+	KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr, (u32)val,
+		    (u32)((u64)val >> 32), handler);
+
 	switch (cr) {
 	case 0:
 		kvm_set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
-- 
1.5.6

