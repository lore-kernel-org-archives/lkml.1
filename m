Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXDZJYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXDZJYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbXDZJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:24:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:53036 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 12/18] KVM: VMX: Only save/restore MSR_K6_STAR if necessary
Date: Thu, 26 Apr 2007 12:22:12 +0300
Message-Id: <11775793381764-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel hosts only support syscall/sysret in long more (and only if efer.sce
is enabled), so only reload the related MSR_K6_STAR if the guest will
actually be able to use it.

This reduces vmexit cost by about 500 cycles (6400 -> 5870) on my setup.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b61d4dd..37537af 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -69,6 +69,10 @@ static struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
+/*
+ * Keep MSR_K6_STAR at the end, as setup_msrs() will try to optimize it
+ * away by decrementing the array size.
+ */
 static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR, MSR_KERNEL_GS_BASE,
@@ -323,6 +327,18 @@ static void setup_msrs(struct kvm_vcpu *vcpu)
 		nr_skip = NR_64BIT_MSRS;
 	nr_good_msrs = vcpu->nmsrs - nr_skip;
 
+	/*
+	 * MSR_K6_STAR is only needed on long mode guests, and only
+	 * if efer.sce is enabled.
+	 */
+	if (find_msr_entry(vcpu, MSR_K6_STAR)) {
+		--nr_good_msrs;
+#ifdef CONFIG_X86_64
+		if (is_long_mode(vcpu) && (vcpu->shadow_efer & EFER_SCE))
+			++nr_good_msrs;
+#endif
+	}
+
 	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
 		    virt_to_phys(vcpu->guest_msrs + nr_skip));
 	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
-- 
1.5.0.6

