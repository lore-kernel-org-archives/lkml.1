Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZERJXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZERJXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZERJXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZERJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 03/43] KVM: Split IOAPIC structure
Date: Mon, 18 May 2009 12:22:25 +0300
Message-Id: <1242638585-18470-4-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Prepared for reuse ioapic_redir_entry for MSI.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_types.h |   17 +++++++++++++++++
 virt/kvm/ioapic.c         |    6 +++---
 virt/kvm/ioapic.h         |   17 +----------------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2b8318c..b84aca3 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -40,4 +40,21 @@ typedef unsigned long  hfn_t;
 
 typedef hfn_t pfn_t;
 
+union kvm_ioapic_redirect_entry {
+	u64 bits;
+	struct {
+		u8 vector;
+		u8 delivery_mode:3;
+		u8 dest_mode:1;
+		u8 delivery_status:1;
+		u8 polarity:1;
+		u8 remote_irr:1;
+		u8 trig_mode:1;
+		u8 mask:1;
+		u8 reserve:7;
+		u8 reserved[4];
+		u8 dest_id;
+	} fields;
+};
+
 #endif /* __KVM_TYPES_H__ */
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index c3b99de..8128013 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -85,7 +85,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 
 static int ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
 {
-	union ioapic_redir_entry *pent;
+	union kvm_ioapic_redirect_entry *pent;
 	int injected = -1;
 
 	pent = &ioapic->redirtbl[idx];
@@ -284,7 +284,7 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 {
 	u32 old_irr = ioapic->irr;
 	u32 mask = 1 << irq;
-	union ioapic_redir_entry entry;
+	union kvm_ioapic_redirect_entry entry;
 	int ret = 1;
 
 	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
@@ -305,7 +305,7 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int pin,
 				    int trigger_mode)
 {
-	union ioapic_redir_entry *ent;
+	union kvm_ioapic_redirect_entry *ent;
 
 	ent = &ioapic->redirtbl[pin];
 
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index a34bd5e..008ec87 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -40,22 +40,7 @@ struct kvm_ioapic {
 	u32 id;
 	u32 irr;
 	u32 pad;
-	union ioapic_redir_entry {
-		u64 bits;
-		struct {
-			u8 vector;
-			u8 delivery_mode:3;
-			u8 dest_mode:1;
-			u8 delivery_status:1;
-			u8 polarity:1;
-			u8 remote_irr:1;
-			u8 trig_mode:1;
-			u8 mask:1;
-			u8 reserve:7;
-			u8 reserved[4];
-			u8 dest_id;
-		} fields;
-	} redirtbl[IOAPIC_NUM_PINS];
+	union kvm_ioapic_redirect_entry redirtbl[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
 	struct kvm *kvm;
 	void (*ack_notifier)(void *opaque, int irq);
-- 
1.6.0.6

