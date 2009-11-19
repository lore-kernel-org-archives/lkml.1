Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZKSNkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZKSNkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZKSNj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 14/35] KVM: fix irq_source_id size verification
Date: Thu, 19 Nov 2009 15:34:50 +0200
Message-Id: <1258637711-11674-15-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

find_first_zero_bit works with bit numbers, not bytes.

Fixes

https://sourceforge.net/tracker/?func=detail&aid=2847560&group_id=180599&atid=893831

Reported-by: "Xu, Jiajun" <jiajun.xu@intel.com>
Cc: stable@kernel.org
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/irq_comm.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 00c68d2..0d454d3 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -215,10 +215,9 @@ int kvm_request_irq_source_id(struct kvm *kvm)
 	int irq_source_id;
 
 	mutex_lock(&kvm->irq_lock);
-	irq_source_id = find_first_zero_bit(bitmap,
-				sizeof(kvm->arch.irq_sources_bitmap));
+	irq_source_id = find_first_zero_bit(bitmap, BITS_PER_LONG);
 
-	if (irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
+	if (irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
 		irq_source_id = -EFAULT;
 		goto unlock;
@@ -240,7 +239,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 
 	mutex_lock(&kvm->irq_lock);
 	if (irq_source_id < 0 ||
-	    irq_source_id >= sizeof(kvm->arch.irq_sources_bitmap)) {
+	    irq_source_id >= BITS_PER_LONG) {
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		goto unlock;
 	}
-- 
1.6.5.2

