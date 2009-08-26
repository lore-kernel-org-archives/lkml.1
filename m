Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZHZKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZHZKaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbZHZKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbZHZKaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/47] KVM: x86: Disallow hypercalls for guest callers in rings > 0
Date: Wed, 26 Aug 2009 13:29:26 +0300
Message-Id: <1251282609-12835-5-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

So far unprivileged guest callers running in ring 3 can issue, e.g., MMU
hypercalls. Normally, such callers cannot provide any hand-crafted MMU
command structure as it has to be passed by its physical address, but
they can still crash the guest kernel by passing random addresses.

To close the hole, this patch considers hypercalls valid only if issued
from guest ring 0. This may still be relaxed on a per-hypercall base in
the future once required.

Cc: stable@kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c       |    6 ++++++
 include/linux/kvm_para.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa525d5..92b5edd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3213,6 +3213,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
+	if (kvm_x86_ops->get_cpl(vcpu) != 0) {
+		ret = -KVM_EPERM;
+		goto out;
+	}
+
 	switch (nr) {
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
@@ -3224,6 +3229,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
+out:
 	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
 	++vcpu->stat.hypercalls;
 	return r;
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index 3ddce03..d731092 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -13,6 +13,7 @@
 #define KVM_ENOSYS		1000
 #define KVM_EFAULT		EFAULT
 #define KVM_E2BIG		E2BIG
+#define KVM_EPERM		EPERM
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2
-- 
1.6.4.1

