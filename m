Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZHSNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZHSNIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZHSNEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50586 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/47] KVM: x86: missing locking in PIT/IRQCHIP/SET_BSP_CPU ioctl paths
Date: Wed, 19 Aug 2009 16:02:30 +0300
Message-Id: <1250686963-8357-35-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Correct missing locking in a few places in x86's vm_ioctl handling path.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    2 --
 arch/x86/kvm/x86.c   |   12 ++++++++++++
 virt/kvm/kvm_main.c  |    2 ++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 15fc95b..bcd00c7 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -345,9 +345,7 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 
 void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val)
 {
-	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	pit_load_count(kvm, channel, val);
-	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 }
 
 static inline struct kvm_pit *dev_to_pit(struct kvm_io_device *dev)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 57e76b3..e9b0982 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1987,19 +1987,25 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
+		spin_lock(&pic_irqchip(kvm)->lock);
 		memcpy(&pic_irqchip(kvm)->pics[0],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
+		spin_unlock(&pic_irqchip(kvm)->lock);
 		break;
 	case KVM_IRQCHIP_PIC_SLAVE:
+		spin_lock(&pic_irqchip(kvm)->lock);
 		memcpy(&pic_irqchip(kvm)->pics[1],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
+		spin_unlock(&pic_irqchip(kvm)->lock);
 		break;
 	case KVM_IRQCHIP_IOAPIC:
+		mutex_lock(&kvm->irq_lock);
 		memcpy(ioapic_irqchip(kvm),
 			&chip->chip.ioapic,
 			sizeof(struct kvm_ioapic_state));
+		mutex_unlock(&kvm->irq_lock);
 		break;
 	default:
 		r = -EINVAL;
@@ -2013,7 +2019,9 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 {
 	int r = 0;
 
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	memcpy(ps, &kvm->arch.vpit->pit_state, sizeof(struct kvm_pit_state));
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	return r;
 }
 
@@ -2021,8 +2029,10 @@ static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 {
 	int r = 0;
 
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	memcpy(&kvm->arch.vpit->pit_state, ps, sizeof(struct kvm_pit_state));
 	kvm_pit_load_count(kvm, 0, ps->channels[0].count);
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	return r;
 }
 
@@ -2031,7 +2041,9 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 {
 	if (!kvm->arch.vpit)
 		return -ENXIO;
+	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	kvm->arch.vpit->pit_state.pit_timer.reinject = control->pit_reinject;
+	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	return 0;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8361662..f1e2e8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2274,10 +2274,12 @@ static long kvm_vm_ioctl(struct file *filp,
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
+		mutex_lock(&kvm->lock);
 		if (atomic_read(&kvm->online_vcpus) != 0)
 			r = -EBUSY;
 		else
 			kvm->bsp_vcpu_id = arg;
+		mutex_unlock(&kvm->lock);
 		break;
 #endif
 	default:
-- 
1.6.3.3

