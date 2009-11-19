Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZKSNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZKSNiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZKSNgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 28/35] KVM: x86: disallow multiple KVM_CREATE_IRQCHIP
Date: Thu, 19 Nov 2009 15:35:04 +0200
Message-Id: <1258637711-11674-29-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Otherwise kvm will leak memory on multiple KVM_CREATE_IRQCHIP.
Also serialize multiple accesses with kvm->lock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/irq.h |    6 +++++-
 arch/x86/kvm/x86.c |   30 ++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c025a23..be399e2 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -86,7 +86,11 @@ static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
-	return pic_irqchip(kvm) != NULL;
+	int ret;
+
+	ret = (pic_irqchip(kvm) != NULL);
+	smp_rmb();
+	return ret;
 }
 
 void kvm_pic_reset(struct kvm_kpic_state *s);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 719f31e..97f6f95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2362,25 +2362,39 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (r)
 			goto out;
 		break;
-	case KVM_CREATE_IRQCHIP:
+	case KVM_CREATE_IRQCHIP: {
+		struct kvm_pic *vpic;
+
+		mutex_lock(&kvm->lock);
+		r = -EEXIST;
+		if (kvm->arch.vpic)
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
-		kvm->arch.vpic = kvm_create_pic(kvm);
-		if (kvm->arch.vpic) {
+		vpic = kvm_create_pic(kvm);
+		if (vpic) {
 			r = kvm_ioapic_init(kvm);
 			if (r) {
-				kfree(kvm->arch.vpic);
-				kvm->arch.vpic = NULL;
-				goto out;
+				kfree(vpic);
+				goto create_irqchip_unlock;
 			}
 		} else
-			goto out;
+			goto create_irqchip_unlock;
+		smp_wmb();
+		kvm->arch.vpic = vpic;
+		smp_wmb();
 		r = kvm_setup_default_irq_routing(kvm);
 		if (r) {
+			mutex_lock(&kvm->irq_lock);
 			kfree(kvm->arch.vpic);
 			kfree(kvm->arch.vioapic);
-			goto out;
+			kvm->arch.vpic = NULL;
+			kvm->arch.vioapic = NULL;
+			mutex_unlock(&kvm->irq_lock);
 		}
+	create_irqchip_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
+	}
 	case KVM_CREATE_PIT:
 		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
 		goto create_pit;
-- 
1.6.5.2

