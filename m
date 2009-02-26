Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbZBZO2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbZBZO2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZBZORU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43084 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 34/40] KVM: PIT: provide an option to disable interrupt reinjection
Date: Thu, 26 Feb 2009 16:15:24 +0200
Message-Id: <1235657730-27683-35-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Certain clocks (such as TSC) in older 2.6 guests overaccount for lost
ticks, causing severe time drift. Interrupt reinjection magnifies the
problem.

Provide an option to disable it.

[avi: allow room for expansion in case we want to disable reinjection
      of other timers]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm.h |    5 +++++
 arch/x86/kvm/i8254.c       |    4 ++++
 arch/x86/kvm/i8254.h       |    1 +
 arch/x86/kvm/x86.c         |   21 +++++++++++++++++++++
 include/linux/kvm.h        |    4 ++++
 5 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 32eb96c..54bcf22 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -233,4 +233,9 @@ struct kvm_guest_debug_arch {
 struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
+
+struct kvm_reinject_control {
+	__u8 pit_reinject;
+	__u8 reserved[31];
+};
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 72bd275..528daad 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -201,6 +201,9 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 	if (!atomic_inc_and_test(&pt->pending))
 		set_bit(KVM_REQ_PENDING_TIMER, &vcpu0->requests);
 
+	if (!pt->reinject)
+		atomic_set(&pt->pending, 1);
+
 	if (vcpu0 && waitqueue_active(&vcpu0->wq))
 		wake_up_interruptible(&vcpu0->wq);
 
@@ -580,6 +583,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	pit_state->irq_ack_notifier.gsi = 0;
 	pit_state->irq_ack_notifier.irq_acked = kvm_pit_ack_irq;
 	kvm_register_irq_ack_notifier(kvm, &pit_state->irq_ack_notifier);
+	pit_state->pit_timer.reinject = true;
 	mutex_unlock(&pit->pit_state.lock);
 
 	kvm_pit_reset(pit);
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 4178022..76959c4 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -9,6 +9,7 @@ struct kvm_kpit_timer {
 	s64 period; /* unit: ns */
 	s64 scheduled;
 	atomic_t pending;
+	bool reinject;
 };
 
 struct kvm_kpit_channel_state {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3fbe8c..a1f1461 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -993,6 +993,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_SYNC_MMU:
+	case KVM_CAP_REINJECT_CONTROL:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -1728,6 +1729,15 @@ static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 	return r;
 }
 
+static int kvm_vm_ioctl_reinject(struct kvm *kvm,
+				 struct kvm_reinject_control *control)
+{
+	if (!kvm->arch.vpit)
+		return -ENXIO;
+	kvm->arch.vpit->pit_state.pit_timer.reinject = control->pit_reinject;
+	return 0;
+}
+
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
@@ -1925,6 +1935,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_REINJECT_CONTROL: {
+		struct kvm_reinject_control control;
+		r =  -EFAULT;
+		if (copy_from_user(&control, argp, sizeof(control)))
+			goto out;
+		r = kvm_vm_ioctl_reinject(kvm, &control);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 11e3e61..ae7a12c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -396,6 +396,9 @@ struct kvm_trace_rec {
 #if defined(CONFIG_X86)
 #define KVM_CAP_SET_GUEST_DEBUG 23
 #endif
+#if defined(CONFIG_X86)
+#define KVM_CAP_REINJECT_CONTROL 24
+#endif
 
 /*
  * ioctls for VM fds
@@ -429,6 +432,7 @@ struct kvm_trace_rec {
 				   struct kvm_assigned_pci_dev)
 #define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
 			    struct kvm_assigned_irq)
+#define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
 
 /*
  * ioctls for vcpu fds
-- 
1.6.0.6

