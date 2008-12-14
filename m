Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYLNIMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYLNIMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYLNIHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59921 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 17/36] KVM: add KVM_USERSPACE_IRQ_SOURCE_ID assertions
Date: Sun, 14 Dec 2008 10:06:50 +0200
Message-Id: <1229242029-13410-18-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Make sure kvm_request_irq_source_id() never returns
KVM_USERSPACE_IRQ_SOURCE_ID.

Likewise, check that kvm_free_irq_source_id() never accepts
KVM_USERSPACE_IRQ_SOURCE_ID.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index db75045..aa5d1e5 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -72,11 +72,15 @@ int kvm_request_irq_source_id(struct kvm *kvm)
 	unsigned long *bitmap = &kvm->arch.irq_sources_bitmap;
 	int irq_source_id = find_first_zero_bit(bitmap,
 				sizeof(kvm->arch.irq_sources_bitmap));
+
 	if (irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
 		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
-		irq_source_id = -EFAULT;
-	} else
-		set_bit(irq_source_id, bitmap);
+		return -EFAULT;
+	}
+
+	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+	set_bit(irq_source_id, bitmap);
+
 	return irq_source_id;
 }
 
@@ -84,7 +88,9 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 {
 	int i;
 
-	if (irq_source_id <= 0 ||
+	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+
+	if (irq_source_id < 0 ||
 	    irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		return;
-- 
1.6.0.3

