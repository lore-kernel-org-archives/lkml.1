Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0BMIJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:09:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/39] KVM: VMX: trace clts and lmsw instructions as cr accesses
Date: Sat, 13 Feb 2010 10:01:37 +0200
Message-Id: <1266048119-14325-18-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clts writes cr0.ts; lmsw writes cr0[0:15] - record that in ftrace.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9b197b2..7c7b2ee 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2997,6 +2997,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		vmx_fpu_deactivate(vcpu);
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
+		trace_kvm_cr_write(0, vcpu->arch.cr0);
 		vmx_fpu_activate(vcpu);
 		skip_emulated_instruction(vcpu);
 		return 1;
@@ -3016,7 +3017,9 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		}
 		break;
 	case 3: /* lmsw */
-		kvm_lmsw(vcpu, (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f);
+		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
+		trace_kvm_cr_write(0, (vcpu->arch.cr0 & ~0xful) | val);
+		kvm_lmsw(vcpu, val);
 
 		skip_emulated_instruction(vcpu);
 		return 1;
-- 
1.6.5.3

