Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbZDQImp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbZDQImp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbZDQIli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:41767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbZDQIlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762626"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/5] x86,intr-remap: fix ack for interrupt remapping
Date: Fri, 17 Apr 2009 16:42:13 +0800
Message-Id: <1239957736-6161-3-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't call ack_apic_edge in ir_ack_apic_edge, because
ack_apic_edge does more than just ack, it also does irq migration
in the non-interrupt-remapping case. But there is no such need for
interrupt-remapping case. as irq migration is done in the process
context.

Similarly, ir_ack_apic_level shouldn't call ack_apic_level, and
instead do the local cpu's EOI + directed EOI to the io-apic.

ack_x2APIC_irq is not neccessary, becasue ack_APIC_irq will use MSR
write for x2apic, and uncached write for non-x2apic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/include/asm/apic.h    |    8 --------
 arch/x86/kernel/apic/io_apic.c |   32 +++++---------------------------
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..c37af81 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -204,14 +204,6 @@ static inline int x2apic_enabled(void)
 
 extern int get_physical_broadcast(void);
 
-#ifdef CONFIG_X86_X2APIC
-static inline void ack_x2APIC_irq(void)
-{
-	/* Docs say use 0 for future compatibility */
-	native_apic_msr_write(APIC_EOI, 0);
-}
-#endif
-
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a2789e4..149e1b1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2557,20 +2557,6 @@ eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-#ifdef CONFIG_X86_X2APIC
-static void ack_x2apic_level(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	ack_x2APIC_irq();
-	eoi_ioapic_irq(desc);
-}
-
-static void ack_x2apic_edge(unsigned int irq)
-{
-	ack_x2APIC_irq();
-}
-#endif
-
 static void ack_apic_edge(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2634,9 +2620,6 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
-	if (irq_remapped(irq))
-		eoi_ioapic_irq(desc);
-
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2685,20 +2668,15 @@ static void ack_apic_level(unsigned int irq)
 #ifdef CONFIG_INTR_REMAP
 static void ir_ack_apic_edge(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_edge(irq);
-#endif
-       return ack_apic_edge(irq);
+	ack_APIC_irq();
 }
 
 static void ir_ack_apic_level(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_level(irq);
-#endif
-       return ack_apic_level(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	ack_APIC_irq();
+	eoi_ioapic_irq(desc);
 }
 #endif /* CONFIG_INTR_REMAP */
 
-- 
1.6.0.4

