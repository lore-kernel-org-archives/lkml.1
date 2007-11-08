Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXKHKfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXKHKfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXKHKfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:52464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbXKHKfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 2/5] KVM: SVM: Fix SMP with kernel apic
Date: Thu,  8 Nov 2007 12:35:27 +0200
Message-Id: <11945181301284-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11945181301744-git-send-email-avi@qumranet.com>
References: <11945181301744-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

AP processor needs to reset to the SIPI vector, not normal INIT.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 729f1cd..3910358 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -561,6 +561,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	init_vmcb(svm->vmcb);
+
+	if (vcpu->vcpu_id != 0) {
+		svm->vmcb->save.rip = 0;
+		svm->vmcb->save.cs.base = svm->vcpu.sipi_vector << 12;
+		svm->vmcb->save.cs.selector = svm->vcpu.sipi_vector << 8;
+	}
 }
 
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
-- 
1.5.3

