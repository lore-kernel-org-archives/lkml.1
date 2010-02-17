Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab0BQNpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab0BQNpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:34 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] KVM: cleanup the failure path of KVM_CREATE_IRQCHIP ioctrl
Date: Wed, 17 Feb 2010 15:45:16 +0200
Message-Id: <1266414330-27444-7-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If we fail to init ioapic device or the fail to setup the default irq
routing, the device register by kvm_create_pic() and kvm_ioapic_init()
remain unregister. This patch fixed to do this.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |   11 +++++++++++
 arch/x86/kvm/irq.h   |    1 +
 arch/x86/kvm/x86.c   |    8 ++++----
 virt/kvm/ioapic.c    |   11 +++++++++++
 virt/kvm/ioapic.h    |    1 +
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index d5753a7..a3711f9 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -543,3 +543,14 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 
 	return s;
 }
+
+void kvm_destroy_pic(struct kvm *kvm)
+{
+	struct kvm_pic *vpic = kvm->arch.vpic;
+
+	if (vpic) {
+		kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS, &vpic->dev);
+		kvm->arch.vpic = NULL;
+		kfree(vpic);
+	}
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index be399e2..0b71d48 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -75,6 +75,7 @@ struct kvm_pic {
 };
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm);
+void kvm_destroy_pic(struct kvm *kvm);
 int kvm_pic_read_irq(struct kvm *kvm);
 void kvm_pic_update_irq(struct kvm_pic *s);
 void kvm_pic_clear_isr_ack(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd3161c..b2f91b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2771,6 +2771,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (vpic) {
 			r = kvm_ioapic_init(kvm);
 			if (r) {
+				kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS,
+							  &vpic->dev);
 				kfree(vpic);
 				goto create_irqchip_unlock;
 			}
@@ -2782,10 +2784,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = kvm_setup_default_irq_routing(kvm);
 		if (r) {
 			mutex_lock(&kvm->irq_lock);
-			kfree(kvm->arch.vpic);
-			kfree(kvm->arch.vioapic);
-			kvm->arch.vpic = NULL;
-			kvm->arch.vioapic = NULL;
+			kvm_ioapic_destroy(kvm);
+			kvm_destroy_pic(kvm);
 			mutex_unlock(&kvm->irq_lock);
 		}
 	create_irqchip_unlock:
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index f3d0693..3db15a8 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -401,6 +401,17 @@ int kvm_ioapic_init(struct kvm *kvm)
 	return ret;
 }
 
+void kvm_ioapic_destroy(struct kvm *kvm)
+{
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+
+	if (ioapic) {
+		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &ioapic->dev);
+		kvm->arch.vioapic = NULL;
+		kfree(ioapic);
+	}
+}
+
 int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 {
 	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index a505ce9..8a751b7 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -72,6 +72,7 @@ int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
+void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-- 
1.6.5.3

