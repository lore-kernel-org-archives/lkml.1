Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbZDWH60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbZDWH60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZDWHeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:46 -0400
Received: from sous-sol.org ([216.99.217.87]:51072 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757446AbZDWHeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:44 -0400
Message-Id: <20090423073001.419526320@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: [patch 085/100] KVM: Reset PIT irq injection logic when the PIT IRQ is unmasked
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-reset-pit-irq-injection-logic-when-the-pit-irq-is-unmasked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Avi Kivity <avi@redhat.com>

upstream commit: 4780c65904f0fc4e312ee2da9383eacbe04e61ea

While the PIT is masked the guest cannot ack the irq, so the reinject logic
will never allow the interrupt to be injected.

Fix by resetting the reinjection counters on unmask.

Unbreaks Xen.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/i8254.c |   15 +++++++++++++++
 arch/x86/kvm/i8254.h |    1 +
 2 files changed, 16 insertions(+)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -536,6 +536,16 @@ void kvm_pit_reset(struct kvm_pit *pit)
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
@@ -584,6 +594,9 @@ struct kvm_pit *kvm_create_pit(struct kv
 
 	kvm_pit_reset(pit);
 
+	pit->mask_notifier.func = pit_mask_notifer;
+	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
+
 	return pit;
 }
 
@@ -592,6 +605,8 @@ void kvm_free_pit(struct kvm *kvm)
 	struct hrtimer *timer;
 
 	if (kvm->arch.vpit) {
+		kvm_unregister_irq_mask_notifier(kvm, 0,
+					       &kvm->arch.vpit->mask_notifier);
 		mutex_lock(&kvm->arch.vpit->pit_state.lock);
 		timer = &kvm->arch.vpit->pit_state.pit_timer.timer;
 		hrtimer_cancel(timer);
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -45,6 +45,7 @@ struct kvm_pit {
 	struct kvm *kvm;
 	struct kvm_kpit_state pit_state;
 	int irq_source_id;
+	struct kvm_irq_mask_notifier mask_notifier;
 };
 
 #define KVM_PIT_BASE_ADDRESS	    0x40

