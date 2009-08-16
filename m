Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZHPJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZHPJfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZHPJfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45350 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/48] KVM: do not register i8254 PIO regions until we are initialized
Date: Sun, 16 Aug 2009 12:29:45 +0300
Message-Id: <1250415008-17175-26-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We currently publish the i8254 resources to the pio_bus before the devices
are fully initialized.  Since we hold the pit_lock, its probably not
a real issue.  But lets clean this up anyway.

Reported-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index e800d2d..977af7a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -604,15 +604,6 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	mutex_lock(&pit->pit_state.lock);
 	spin_lock_init(&pit->pit_state.inject_lock);
 
-	/* Initialize PIO device */
-	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
-
-	if (flags & KVM_PIT_SPEAKER_DUMMY) {
-		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
-	}
-
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
 
@@ -631,6 +622,14 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	pit->mask_notifier.func = pit_mask_notifer;
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
+	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
+	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+
+	if (flags & KVM_PIT_SPEAKER_DUMMY) {
+		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
+		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	}
+
 	return pit;
 }
 
-- 
1.6.3.3

