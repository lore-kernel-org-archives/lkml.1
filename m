Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbZDJJRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbZDJJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbZDJJRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:17:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:49593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbZDJJRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130054207"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, suresh.b.siddha@intel.com, dwmw2@infradead.org,
       allen.m.kay@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>
Subject: [PATCH] x86, intr-remap: fix eoi for interrupt remapping without x2apic
Date: Fri, 10 Apr 2009 17:17:17 +0800
Message-Id: <1239355037-22856-1-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify level irq migration in the presence of interrupt-remapping,
Suresh used a virtual vector (io-apic pin number) to eliminate io-apic
RTE modification. level triggered interrupt will appear as an edge to
the local apic cpu but still as level to the IO-APIC. So in addition to
do the local apic EOI, it still needs to do IO-APIC directed EOI to clear
the remote IRR bit in the IO-APIC RTE. Pls refer to Suresh's patch for
more details (commit 0280f7c416c652a2fd95d166f52b199ae61122c0).

Now interrupt remapping is decoupled from x2apic, it also needs to do the
directed EOI for apic. Otherwise, apic interrupts won't work correctly.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..a2789e4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2524,7 +2524,6 @@ static void irq_complete_move(struct irq_desc **descp)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-#ifdef CONFIG_X86_X2APIC
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -2558,6 +2557,7 @@ eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+#ifdef CONFIG_X86_X2APIC
 static void ack_x2apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2634,6 +2634,9 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	if (irq_remapped(irq))
+		eoi_ioapic_irq(desc);
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
-- 
1.6.0.4

