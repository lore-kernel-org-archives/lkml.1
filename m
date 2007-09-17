Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbXIQIf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbXIQIf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXIQIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 013/104] KVM: Trivial: Use standard BITMAP macros, open-code userspace-exposed header
Date: Mon, 17 Sep 2007 10:30:55 +0200
Message-Id: <11900179471394-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Creating one's own BITMAP macro seems suboptimal: if we use manual
arithmetic in the one place exposed to userspace, we can use standard
macros elsewhere.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +--
 drivers/kvm/kvm_main.c |    2 +-
 include/linux/kvm.h    |   10 ++--------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 25439a5..cec5f05 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -324,8 +324,7 @@ struct kvm_vcpu {
 	int guest_mode;
 	unsigned long requests;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
-#define NR_IRQ_WORDS KVM_IRQ_BITMAP_SIZE(unsigned long)
-	unsigned long irq_pending[NR_IRQ_WORDS];
+	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
 	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
 	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index af02320..fc63de2 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2130,7 +2130,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
 	       sizeof vcpu->irq_pending);
 	vcpu->irq_summary = 0;
-	for (i = 0; i < NR_IRQ_WORDS; ++i)
+	for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
 		if (vcpu->irq_pending[i])
 			__set_bit(i, &vcpu->irq_summary);
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 68ecced..8db01a9 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -12,14 +12,8 @@
 
 #define KVM_API_VERSION 12
 
-/*
- * Architectural interrupt line count, and the size of the bitmap needed
- * to hold them.
- */
+/* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
-#define KVM_IRQ_BITMAP_SIZE_BYTES    ((KVM_NR_INTERRUPTS + 7) / 8)
-#define KVM_IRQ_BITMAP_SIZE(type)    (KVM_IRQ_BITMAP_SIZE_BYTES / sizeof(type))
-
 
 /* for KVM_CREATE_MEMORY_REGION */
 struct kvm_memory_region {
@@ -165,7 +159,7 @@ struct kvm_sregs {
 	__u64 cr0, cr2, cr3, cr4, cr8;
 	__u64 efer;
 	__u64 apic_base;
-	__u64 interrupt_bitmap[KVM_IRQ_BITMAP_SIZE(__u64)];
+	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
 };
 
 struct kvm_msr_entry {
-- 
1.5.3

