Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXDZJ3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXDZJ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXDZJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:53033 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933789AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/18] KVM: VMX: Reduce unnecessary saving of host msrs
Date: Thu, 26 Apr 2007 12:22:09 +0300
Message-Id: <11775793382678-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

THe automatically switched msrs are never changed on the host (with
the exception of MSR_KERNEL_GS_BASE) and thus there is no need to save
them on every vm entry.

This reduces vmexit latency by ~400 cycles on i386 and by ~900 cycles (10%)
on x86_64.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 8c0115b..3745e6c 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -78,6 +78,10 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
+#ifdef CONFIG_X86_64
+static unsigned msr_offset_kernel_gs_base;
+#endif
+
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -1129,6 +1133,10 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->host_msrs[j].reserved = 0;
 		vcpu->host_msrs[j].data = data;
 		vcpu->guest_msrs[j] = vcpu->host_msrs[j];
+#ifdef CONFIG_X86_64
+		if (index == MSR_KERNEL_GS_BASE)
+			msr_offset_kernel_gs_base = j;
+#endif
 		++vcpu->nmsrs;
 	}
 
@@ -1760,7 +1768,9 @@ again:
 	fx_save(vcpu->host_fx_image);
 	fx_restore(vcpu->guest_fx_image);
 
-	save_msrs(vcpu->host_msrs, vcpu->nmsrs);
+#ifdef CONFIG_X86_64
+	save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
+#endif
 	load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
 
 	asm (
-- 
1.5.0.6

