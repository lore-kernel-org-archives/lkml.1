Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXLWPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXLWPDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXLWOwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:21 -0500
Received: from il.qumranet.com ([82.166.9.18]:35902 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Qing He <qing.he@intel.com>
Subject: [PATCH 38/50] KVM: apic round robin cleanup
Date: Sun, 23 Dec 2007 16:51:23 +0200
Message-Id: <1198421495-31481-39-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing He <qing.he@intel.com>

If no apic is enabled in the bitmap of an interrupt delivery with delivery
mode of lowest priority, a warning should be reported rather than select
a fallback vcpu

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Eddie (Yaozu) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/lapic.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index e15b42e..8840f9d 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -395,10 +395,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap)
 {
-	int vcpu_id;
 	int last;
 	int next;
-	struct kvm_lapic *apic;
+	struct kvm_lapic *apic = NULL;
 
 	last = kvm->round_robin_prev_vcpu;
 	next = last;
@@ -415,14 +414,8 @@ struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 	} while (next != last);
 	kvm->round_robin_prev_vcpu = next;
 
-	if (!apic) {
-		vcpu_id = ffs(bitmap) - 1;
-		if (vcpu_id < 0) {
-			vcpu_id = 0;
-			printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
-		}
-		apic = kvm->vcpus[vcpu_id]->apic;
-	}
+	if (!apic)
+		printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
 
 	return apic;
 }
-- 
1.5.3.7

