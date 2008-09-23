Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYIWN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYIWN6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYIWNrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52409 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYIWNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:42 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 25/40] KVM: Ignore DEBUGCTL MSRs with no effect
Date: Tue, 23 Sep 2008 16:46:39 +0300
Message-Id: <1222177614-26669-26-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Netware writes to DEBUGCTL and reads from the DEBUGCTL and LAST*IP MSRs
without further checks and is really confused to receive a #GP during that.
To make it happy we should just make them stubs, which is exactly what SVM
already does.

Writes to DEBUGCTL that are vendor-specific are resembled to behave as if the
virtual CPU does not know them.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5620df2..94a2165 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -665,6 +665,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_CTL 0x%llx, nop\n",
 			__func__, data);
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		if (!data) {
+			/* We support the non-activated case already */
+			break;
+		} else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
+			/* Values other than LBR and BTF are vendor-specific,
+			   thus reserved and should throw a #GP */
+			return 1;
+		}
+		pr_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+			__func__, data);
+		break;
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
 		break;
@@ -757,6 +769,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_MISC+16:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
+	case MSR_IA32_DEBUGCTLMSR:
+	case MSR_IA32_LASTBRANCHFROMIP:
+	case MSR_IA32_LASTBRANCHTOIP:
+	case MSR_IA32_LASTINTFROMIP:
+	case MSR_IA32_LASTINTTOIP:
 		data = 0;
 		break;
 	case MSR_MTRRcap:
-- 
1.6.0.1

