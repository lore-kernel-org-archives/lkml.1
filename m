Return-Path: <linux-kernel-owner+w=401wt.eu-S1030481AbXCGJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481AbXCGJBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030496AbXCGJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:01:33 -0500
Received: from il.qumranet.com ([82.166.9.18]:38184 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030481AbXCGJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:01:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 2/2] KVM: Fix guest sysenter on vmx
Date: Wed,  7 Mar 2007 11:01:29 +0200
Message-Id: <11732580901561-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <1173258089147-git-send-email-avi@qumranet.com>
References: <1173258089147-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vmx code currently treats the guest's sysenter support msrs as 32-bit
values, which breaks 32-bit compat mode userspace on 64-bit guests.  Fix by
using the native word width of the machine.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c07178e..bfa0ce4 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -371,10 +371,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		data = vmcs_read32(GUEST_SYSENTER_CS);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		data = vmcs_read32(GUEST_SYSENTER_EIP);
+		data = vmcs_readl(GUEST_SYSENTER_EIP);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		data = vmcs_read32(GUEST_SYSENTER_ESP);
+		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
 	default:
 		msr = find_msr_entry(vcpu, msr_index);
@@ -412,10 +412,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_write32(GUEST_SYSENTER_CS, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		vmcs_write32(GUEST_SYSENTER_EIP, data);
+		vmcs_writel(GUEST_SYSENTER_EIP, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		vmcs_write32(GUEST_SYSENTER_ESP, data);
+		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TIME_STAMP_COUNTER:
 		guest_write_tsc(data);
-- 
1.5.0.2

