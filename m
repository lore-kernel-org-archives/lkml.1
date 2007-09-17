Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbXIQIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbXIQIp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXIQIc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:45281 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 071/104] KVM: Bypass irq_pending get/set when using in kernel irqchip
Date: Mon, 17 Sep 2007 10:31:53 +0200
Message-Id: <11900179481339-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

vcpu->irq_pending is saved in get/set_sreg IOCTL, but when in-kernel
local APIC is used, doing this may occasionally overwrite vcpu->apic to
an invalid value, as in the vm restore path.

Signed-off-by: Qing He <qing.he@intel.com>
---
 drivers/kvm/kvm_main.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 6e2c5f3..c270e4a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2145,8 +2145,12 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->efer = vcpu->shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
-	memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
-	       sizeof sregs->interrupt_bitmap);
+	if (irqchip_in_kernel(vcpu->kvm))
+		memset(sregs->interrupt_bitmap, 0,
+		       sizeof sregs->interrupt_bitmap);
+	else
+		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
+		       sizeof sregs->interrupt_bitmap);
 
 	vcpu_put(vcpu);
 
@@ -2200,12 +2204,14 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
 
-	memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
-	       sizeof vcpu->irq_pending);
-	vcpu->irq_summary = 0;
-	for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
-		if (vcpu->irq_pending[i])
-			__set_bit(i, &vcpu->irq_summary);
+	if (!irqchip_in_kernel(vcpu->kvm)) {
+		memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
+		       sizeof vcpu->irq_pending);
+		vcpu->irq_summary = 0;
+		for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
+			if (vcpu->irq_pending[i])
+				__set_bit(i, &vcpu->irq_summary);
+	}
 
 	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-- 
1.5.3

