Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbZB0Kcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbZB0Kcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbZB0K1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/37] KVM: Reset PIT irq injection logic when the PIT IRQ is unmasked
Date: Fri, 27 Feb 2009 12:26:49 +0200
Message-Id: <1235730420-7929-27-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the PIT is masked the guest cannot ack the irq, so the reinject logic
will never allow the interrupt to be injected.

Fix by resetting the reinjection counters on unmask.

Unbreaks Xen.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   15 +++++++++++++++
 arch/x86/kvm/i8254.h |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 69d1bbf..c13bb92 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -539,6 +539,16 @@ void kvm_pit_reset(struct kvm_pit *pit)
 	pit->pit_state.irq_ack = 1;
 }
 
+static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
+{
+	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
+
+	if (!mask) {
+		atomic_set(&pit->pit_state.pit_timer.pending, 0);
+		pit->pit_state.irq_ack = 1;
+	}
+}
+
 struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 {
 	struct kvm_pit *pit;
@@ -586,6 +596,9 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 
 	kvm_pit_reset(pit);
 
+	pit->mask_notifier.func = pit_mask_notifer;
+	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
+
 	return pit;
 }
 
@@ -594,6 +607,8 @@ void kvm_free_pit(struct kvm *kvm)
 	struct hrtimer *timer;
 
 	if (kvm->arch.vpit) {
+		kvm_unregister_irq_mask_notifier(kvm, 0,
+					       &kvm->arch.vpit->mask_notifier);
 		mutex_lock(&kvm->arch.vpit->pit_state.lock);
 		timer = &kvm->arch.vpit->pit_state.pit_timer.timer;
 		hrtimer_cancel(timer);
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 76959c4..6acbe4b 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -46,6 +46,7 @@ struct kvm_pit {
 	struct kvm *kvm;
 	struct kvm_kpit_state pit_state;
 	int irq_source_id;
+	struct kvm_irq_mask_notifier mask_notifier;
 };
 
 #define KVM_PIT_BASE_ADDRESS	    0x40
-- 
1.6.0.6

