Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZE0WQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZE0WQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbZE0WPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:15:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56287 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762229AbZE0WPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:15:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 3/3] kvm: do not register i8254 PIO regions until we
	are initialized
To: avi@redhat.com
Cc: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 17:37:50 -0400
Message-ID: <20090527213749.24324.18640.stgit@dev.haskins.net>
In-Reply-To: <20090527213535.24324.62362.stgit@dev.haskins.net>
References: <20090527213535.24324.62362.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently publish the i8254 resources to the pio_bus before the devices
are fully initialized.  Since we hold the pit_lock, its probably not
a real issue.  But lets clean this up anyway.

Found-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index d6a2b7d..0667700 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -601,15 +601,6 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
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
 
@@ -628,6 +619,14 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
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
 

