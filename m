Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYAAPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYAAPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYAAPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:33785 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbYAAPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:26 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 19/54] KVM: Portability: Move KVM_INTERRUPT vcpu ioctl to x86.c
Date: Tue,  1 Jan 2008 17:35:45 +0200
Message-Id: <1199201780-14001-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Other archs doesn't need it.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   29 -----------------------------
 drivers/kvm/x86.c      |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 003a43c..ef961cc 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -665,23 +665,6 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
-				    struct kvm_interrupt *irq)
-{
-	if (irq->irq < 0 || irq->irq >= 256)
-		return -EINVAL;
-	if (irqchip_in_kernel(vcpu->kvm))
-		return -ENXIO;
-	vcpu_load(vcpu);
-
-	set_bit(irq->irq, vcpu->irq_pending);
-	set_bit(irq->irq / BITS_PER_LONG, &vcpu->irq_summary);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
 static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
 				    unsigned long address,
 				    int *type)
@@ -883,18 +866,6 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_INTERRUPT: {
-		struct kvm_interrupt irq;
-
-		r = -EFAULT;
-		if (copy_from_user(&irq, argp, sizeof irq))
-			goto out;
-		r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
-		if (r)
-			goto out;
-		r = 0;
-		break;
-	}
 	case KVM_DEBUG_GUEST: {
 		struct kvm_debug_guest dbg;
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 12f1d6f..c9e4b67 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1001,6 +1001,23 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
+				    struct kvm_interrupt *irq)
+{
+	if (irq->irq < 0 || irq->irq >= 256)
+		return -EINVAL;
+	if (irqchip_in_kernel(vcpu->kvm))
+		return -ENXIO;
+	vcpu_load(vcpu);
+
+	set_bit(irq->irq, vcpu->irq_pending);
+	set_bit(irq->irq / BITS_PER_LONG, &vcpu->irq_summary);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1034,6 +1051,18 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_INTERRUPT: {
+		struct kvm_interrupt irq;
+
+		r = -EFAULT;
+		if (copy_from_user(&irq, argp, sizeof irq))
+			goto out;
+		r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	case KVM_SET_CPUID: {
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
-- 
1.5.3.7

