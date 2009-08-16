Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZHPJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZHPJit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZHPJiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/48] KVM: Allow PIT emulation without speaker port
Date: Sun, 16 Aug 2009 12:29:32 +0300
Message-Id: <1250415008-17175-13-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

The in-kernel speaker emulation is only a dummy and also unneeded from
the performance point of view. Rather, it takes user space support to
generate sound output on the host, e.g. console beeps.

To allow this, introduce KVM_CREATE_PIT2 which controls in-kernel
speaker port emulation via a flag passed along the new IOCTL. It also
leaves room for future extensions of the PIT configuration interface.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   14 ++++++++------
 arch/x86/kvm/i8254.h |    2 +-
 arch/x86/kvm/x86.c   |   12 +++++++++++-
 include/linux/kvm.h  |   12 ++++++++++++
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 21f68e0..0990bc9 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -563,7 +563,7 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 	}
 }
 
-struct kvm_pit *kvm_create_pit(struct kvm *kvm)
+struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
@@ -589,11 +589,13 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	pit->dev.private = pit;
 	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
 
-	pit->speaker_dev.read = speaker_ioport_read;
-	pit->speaker_dev.write = speaker_ioport_write;
-	pit->speaker_dev.in_range = speaker_in_range;
-	pit->speaker_dev.private = pit;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	if (flags & KVM_PIT_SPEAKER_DUMMY) {
+		pit->speaker_dev.read = speaker_ioport_read;
+		pit->speaker_dev.write = speaker_ioport_write;
+		pit->speaker_dev.in_range = speaker_in_range;
+		pit->speaker_dev.private = pit;
+		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	}
 
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index bbd863f..b267018 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -50,7 +50,7 @@ struct kvm_pit {
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val);
-struct kvm_pit *kvm_create_pit(struct kvm *kvm);
+struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags);
 void kvm_free_pit(struct kvm *kvm);
 void kvm_pit_reset(struct kvm_pit *pit);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15f39fc..5eb3b8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1127,6 +1127,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_IRQFD:
+	case KVM_CAP_PIT2:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -2038,6 +2039,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	union {
 		struct kvm_pit_state ps;
 		struct kvm_memory_alias alias;
+		struct kvm_pit_config pit_config;
 	} u;
 
 	switch (ioctl) {
@@ -2098,12 +2100,20 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		}
 		break;
 	case KVM_CREATE_PIT:
+		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
+		goto create_pit;
+	case KVM_CREATE_PIT2:
+		r = -EFAULT;
+		if (copy_from_user(&u.pit_config, argp,
+				   sizeof(struct kvm_pit_config)))
+			goto out;
+	create_pit:
 		mutex_lock(&kvm->lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
 		r = -ENOMEM;
-		kvm->arch.vpit = kvm_create_pit(kvm);
+		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 8f53f24..65df6f5 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -70,6 +70,14 @@ struct kvm_irqchip {
 	} chip;
 };
 
+/* for KVM_CREATE_PIT2 */
+struct kvm_pit_config {
+	__u32 flags;
+	__u32 pad[15];
+};
+
+#define KVM_PIT_SPEAKER_DUMMY     1
+
 #define KVM_EXIT_UNKNOWN          0
 #define KVM_EXIT_EXCEPTION        1
 #define KVM_EXIT_IO               2
@@ -419,6 +427,9 @@ struct kvm_trace_rec {
 #define KVM_CAP_MCE 31
 #endif
 #define KVM_CAP_IRQFD 32
+#ifdef __KVM_HAVE_PIT
+#define KVM_CAP_PIT2 33
+#endif
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -525,6 +536,7 @@ struct kvm_irqfd {
 			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
+#define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
 
 /*
  * ioctls for vcpu fds
-- 
1.6.3.3

